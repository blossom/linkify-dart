library linkify;

import 'dart:convert';

// * @fileoverview Utility function for linkifying text.
class Linkify extends Converter<String, String> {

  HtmlEscape _attributeEscape = new HtmlEscape(HtmlEscapeMode.ATTRIBUTE);
  HtmlEscape _elementEscape = new HtmlEscape(HtmlEscapeMode.ELEMENT);

  /**
   * Takes a string of plain text and linkifies URLs and email addresses. For a
   * URL (unless opt_attributes is specified), the target of the link will be
   * _blank and it will have a rel=nofollow attribute applied to it so that links
   * created by linkify will not be of interest to search engines.
   * @param {string} text Plain text.
   * @param {Object.<string, string>=} opt_attributes Attributes to add to all
   *      links created. Default are rel=nofollow and target=blank. To clear those
   *      default attributes set rel='' and target='_blank'.
   * @return {string} HTML Linkified HTML text.
   */
  String convert(String text, [ Map<String, String> opt_attributes ]) {
    var attributesMap = opt_attributes != null ? opt_attributes : {};
    // Set default options.
    if (!attributesMap.containsKey('rel')) {
      attributesMap['rel'] = 'nofollow';
    }
    if (!attributesMap.containsKey('target')) {
      attributesMap['target'] = '_blank';
    }
    // Creates attributes string from options.
    var attributesArray = [];
    for (var key in attributesMap.keys) {
      if (attributesMap[key].isNotEmpty) {
        attributesArray.addAll([
            _attributeEscape.convert(key), '="',
            _attributeEscape.convert(attributesMap[key]), '" ']);
      }
    }
    var attributes = attributesArray.join('');

    return text.replaceAllMapped(
        _FIND_LINKS_RE,
        (Match match) {
          return _createAnchorTag(attributes, match[0], match[1], match[2], match[3], match[4]);
        });
  }

  String _createAnchorTag(String attributes, String part, String before, String original, String email, String protocol) {
    var output = [_elementEscape.convert(before)];
    if (original.isEmpty) {
      return output[0];
    }
    output.addAll(['<a ', attributes, 'href="']);
    String link;
    String afterLink;
    if (email != null) {
      output.add('mailto:');
      link = email;
      afterLink = '';
    } else {
      // This is a full url link.
      if (protocol == null) {
        output.add('http://');
      }
      Match splitEndingPunctuation = _ENDS_WITH_PUNCTUATION_RE.firstMatch(original);
      if (splitEndingPunctuation != null) {
        link = splitEndingPunctuation[1];
        afterLink = splitEndingPunctuation[2];
      } else {
        link = original;
        afterLink = '';
      }
    }
    var linkText = _elementEscape.convert(link);
    afterLink = _elementEscape.convert(afterLink);
    output.addAll([link, '">', linkText, '</a>', afterLink]);
    return output.join('');
  }

/**
 * Gets the first URI in text.
 * @param {string} text Plain text.
 * @return {string} The first URL, or an empty string if not found.
 */
String findFirstUrl(String text) {
  var link = _URL_RE.firstMatch(text);
  return link != null ? link.group(0) : '';
}

/**
 * Gets the first email address in text.
 * @param {string} text Plain text.
 * @return {string} The first email address, or an empty string if not found.
 */
String findFirstEmail(String text) {
  var email = _EMAIL_RE.firstMatch(text);
  return email != null ? email.group(0) : '';
}

/**
 * If one of these characters is at the end of a url, it will be considered as a
 * puncutation and not part of the url.
 */
static const String _ENDING_PUNCTUATION_CHARS = ':;,\\.?>\\]\\)!';

static RegExp _ENDS_WITH_PUNCTUATION_RE = new RegExp(
    '^(.*)([' + _ENDING_PUNCTUATION_CHARS + '])\$');

/**
 * Set of characters to be put into a regex character set ("[...]"), used to
 * match against a url hostname and everything after it. It includes
 * "#-@", which represents the characters "#$%&'()*+,-./0123456789:;<=>?@".
 */
static String _ACCEPTABLE_URL_CHARS = _ENDING_PUNCTUATION_CHARS + '\\w~#-@!\\[\\]';

/**
 * List of all protocols patterns recognized in urls (mailto is handled in email
 * matching).
 */
static List _RECOGNIZED_PROTOCOLS = ['https?', 'ftp'];

/**
 * Regular expression pattern that matches the beginning of an url.
 * Contains a catching group to capture the scheme.
 */
static String _PROTOCOL_START = '(' + _RECOGNIZED_PROTOCOLS.join('|') + ')://';

/**
 * Regular expression pattern that matches the beginning of a typical
 * http url without the http:// scheme.
 */
static const String _WWW_START = 'www\\.';

/**
 * Regular expression pattern that matches an url.
 */
static String _URL =
    '(?:' + _PROTOCOL_START + '|' +
    _WWW_START + ')\\w[' +
    _ACCEPTABLE_URL_CHARS + ']*';

static RegExp _URL_RE = new RegExp(_URL);

/**
 * Regular expression pattern that matches a top level domain.
 */
static String _TOP_LEVEL_DOMAIN =
    '(?:com|org|net|edu|gov' +
    // from http://www.iana.org/gtld/gtld.htm
    '|aero|biz|cat|coop|info|int|jobs|mobi|museum|name|pro|travel' +
    '|arpa|asia|xxx' +
    // a two letter country code
    '|[a-z][a-z])\\b';

/**
 * Regular expression pattern that matches an email.
 * Contains a catching group to capture the email without the optional "mailto:"
 * prefix.
 */
static String _EMAIL =
    '(?:mailto:)?([\\w.+-]+@[A-Za-z0-9.-]+\\.' +
    _TOP_LEVEL_DOMAIN + ')';

static RegExp _EMAIL_RE = new RegExp(_EMAIL);

/**
 * Regular expression to match all the links (url or email) in a string.
 * First match is text before first link, might be empty string.
 * Second match is the original text that should be replaced by a link.
 * Third match is the email address in the case of an email.
 * Fourth match is the scheme of the url if specified.
 */
static RegExp _FIND_LINKS_RE = new RegExp(
    // Match everything including newlines.
    '([\\S\\s]*?)(' +
    // Match email after a word break.
    '\\b' + _EMAIL + '|' +
    // Match url after a workd break.
    '\\b' + _URL + '|\$)');
}

/*
 * Tests for Linkify
 *
 * Regex for conversion from JavaScript tests
 *
 * Find:"function test\w+\(\) \{\n\s+assertLinkify\(\n\s+"
 * Replace:"     test("
 *
 * Find:"}"
 * Replace where starts with test:"    });"
 *
 * Find:"(test\('[^']+',)"
 * Replace:"\1 () {\n      assertLinkify("
 *
 * Find:
 * Replace:
 *
 * Find:
 * Replace:
 *
 * Find:
 * Replace:
 */
library linkify_test;

import 'package:unittest/unittest.dart';
import 'package:linkify/linkify.dart';

void assertLinkify(input, expected) {
  expect(linkifyPlainText(input, {"rel": '', "target": ''}), equals(expected));
}

main() {

  group('Linkify', () {

    test('Text does not contain any links', () {
      assertLinkify(
          'Text with no links in it.',
          'Text with no links in it.');
    });

    test('Text does not contain any links', () {
      assertLinkify(
      'Text with no links in it.',
      'Text with no links in it.');
    });

    test('Text only contains a link', () {
      assertLinkify(
      'http://www.google.com/',
      '<a href="http://www.google.com/">http://www.google.com/<\/a>');
    });

    test('Text starts with a link', () {
      assertLinkify(
      'http://www.google.com/ is a well known search engine',
      '<a href="http://www.google.com/">http://www.google.com/<\/a>' +
          ' is a well known search engine');
    });

    test('Text ends with a link', () {
      assertLinkify(
      'Look at this search engine: http://www.google.com/',
      'Look at this search engine: ' +
          '<a href="http://www.google.com/">http://www.google.com/<\/a>');
    });

    test('Text only contains an email address', () {
      assertLinkify(
      'bolinfest@google.com',
      '<a href="mailto:bolinfest@google.com">bolinfest@google.com<\/a>');
    });

    test('Text starts with an email address', () {
      assertLinkify(
      'bolinfest@google.com wrote this test.',
      '<a href="mailto:bolinfest@google.com">bolinfest@google.com<\/a>' +
          ' wrote this test.');
    });

    test('Text ends with an email address', () {
      assertLinkify(
      'This test was written by bolinfest@google.com.',
      'This test was written by ' +
          '<a href="mailto:bolinfest@google.com">bolinfest@google.com<\/a>.');
    });

    test('URL with a port number', () {
      assertLinkify(
      'http://www.google.com:80/',
      '<a href="http://www.google.com:80/">http://www.google.com:80/<\/a>');
    });

    test('URL with a user, a password and a port number', () {
      assertLinkify(
      'http://lascap:p4ssw0rd@google.com:80/s?q=a&hl=en',
      '<a href="http://lascap:p4ssw0rd@google.com:80/s?q=a&amp;hl=en">' +
          'http://lascap:p4ssw0rd@google.com:80/s?q=a&amp;hl=en<\/a>');
    });

    test('URL with an underscore', () {
      assertLinkify(
      'http://www_foo.google.com/',
      '<a href="http://www_foo.google.com/">http://www_foo.google.com/<\/a>');
    });

    test('Internal URL without a proper domain', () {
      assertLinkify(
      'http://tracker/1068594',
      '<a href="http://tracker/1068594">http://tracker/1068594<\/a>');
    });

    test('Internal URL with a one char domain', () {
      assertLinkify(
      'http://b',
      '<a href="http://b">http://b<\/a>');
    });

    test('Secure Internal URL without a proper domain', () {
      assertLinkify(
      'https://review/6594805',
      '<a href="https://review/6594805">https://review/6594805<\/a>');
    });

    test('Text with two URLs in it', () {
      assertLinkify(
      'I use both http://www.google.com and http://yahoo.com, don\'t you?',
      'I use both <a href="http://www.google.com">http://www.google.com<\/a> ' +
          'and <a href="http://yahoo.com">http://yahoo.com<\/a>, ' +
          goog.string.htmlEscape('don\'t you?'));
    });

    test('URL with GET params', () {
      assertLinkify(
      'http://google.com/?a=b&c=d&e=f',
      '<a href="http://google.com/?a=b&amp;c=d&amp;e=f">' +
          'http://google.com/?a=b&amp;c=d&amp;e=f<\/a>');
    });

    test('Google search result from cache', () {
      assertLinkify(
      'http://66.102.7.104/search?q=cache:I4LoMT6euUUJ:' +
          'www.google.com/intl/en/help/features.html+google+cache&hl=en',
      '<a href="http://66.102.7.104/search?q=cache:I4LoMT6euUUJ:' +
          'www.google.com/intl/en/help/features.html+google+cache&amp;hl=en">' +
          'http://66.102.7.104/search?q=cache:I4LoMT6euUUJ:' +
          'www.google.com/intl/en/help/features.html+google+cache&amp;hl=en' +
          '<\/a>');
    });

    test('URL without http protocol', () {
      assertLinkify(
      'It\'s faster to type www.google.com without the http:// in front.',
      goog.string.htmlEscape('It\'s faster to type ') +
          '<a href="http://www.google.com">www.google.com' +
          '<\/a> without the http:// in front.');
    });

    test('URL with #!', () {
      assertLinkify(
      'Another test URL: ' +
      'https://www.google.com/testurls/#!/page',
      'Another test URL: ' +
      '<a href="https://www.google.com/testurls/#!/page">' +
      'https://www.google.com/testurls/#!/page<\/a>');
    });

    test('Text looks like an url but is not', () {
      assertLinkify(
      'This showww.is just great: www.is',
      'This showww.is just great: <a href="http://www.is">www.is<\/a>');
    });

    test('Email with a subdomain', () {
      assertLinkify(
      'Send mail to bolinfest@groups.google.com.',
      'Send mail to <a href="mailto:bolinfest@groups.google.com">' +
          'bolinfest@groups.google.com<\/a>.');
    });

    test('Email with a hyphen in the domain name', () {
      assertLinkify(
      'Send mail to bolinfest@google-groups.com.',
      'Send mail to <a href="mailto:bolinfest@google-groups.com">' +
          'bolinfest@google-groups.com<\/a>.');
    });

    test('Email with a hyphen, period, and + in the user name', () {
      assertLinkify(
      'Send mail to bolin-fest+for.um@google.com',
      'Send mail to <a href="mailto:bolin-fest+for.um@google.com">' +
          'bolin-fest+for.um@google.com<\/a>');
    });

    test('Email with an underscore in the domain name, which is invalid', () {
      assertLinkify(
      'Do not email bolinfest@google_groups.com.',
      'Do not email bolinfest@google_groups.com.');
    });

    test('Url using unusual scheme', () {
      assertLinkify(
      'Looking for some goodies: ftp://ftp.google.com/goodstuff/',
      'Looking for some goodies: ' +
      '<a href="ftp://ftp.google.com/goodstuff/">' +
          'ftp://ftp.google.com/goodstuff/<\/a>');
    });

    test('Text includes some javascript', () {
      assertLinkify(
      'Welcome in hell <script>alert(\'this is hell\')<\/script>',
      goog.string.htmlEscape('Welcome in hell <script>alert(\'this is hell\')<\/script>'));
    });

    test('Javascript injection using regex . blindness to newline chars', () {
      assertLinkify(
      '<script>malicious_code()<\/script>\nVery nice url: www.google.com',
      '&lt;script&gt;malicious_code()&lt;/script&gt;\nVery nice url: ' +
          '<a href="http://www.google.com">www.google.com<\/a>');
    });

    test('Javascript injection using regex . blindness to newline chars with a ' +
          'unicode newline character.',
      '<script>malicious_code()<\/script>\u2029Vanilla text',
      '&lt;script&gt;malicious_code()&lt;/script&gt;\u2029Vanilla text');
    });

    test('Angle brackets are normalized even when followed by an ignorable ' +
          'non-tag character.',
      '<\u0000img onerror=alert(1337) src=\n>',
      '&lt;\u0000img onerror=alert(1337) src=\n&gt;');
    });

    test('Putting the result in a textarea can\'t cause other textarea text to ' +
          'be treated as tag content.',
      '</textarea',
      '&lt;/textarea');
    });

    test('Any newline conversion and whitespace normalization won\'t cause tag ' +
          'parts to be recombined.',
      '<<br>script<br>>alert(1337)<<br>/<br>script<br>>',
      '&lt;&lt;br&gt;script&lt;br&gt;&gt;alert(1337)&lt;&lt;br&gt;/&lt;' +
          'br&gt;script&lt;br&gt;&gt;');
    });

    test('No protocol blacklisting.', () {
      assertLinkify(
      'Click: jscript:alert%281337%29\nClick: JSscript:alert%281337%29\n' +
          'Click: VBscript:alert%281337%29\nClick: Script:alert%281337%29\n' +
          'Click: flavascript:alert%281337%29',
      'Click: jscript:alert%281337%29\nClick: JSscript:alert%281337%29\n' +
          'Click: VBscript:alert%281337%29\nClick: Script:alert%281337%29\n' +
          'Click: flavascript:alert%281337%29');
    });

    test('Protocol whitelisting is effective.', () {
      assertLinkify(
      'Click httpscript:alert%281337%29\nClick mailtoscript:alert%281337%29\n' +
          'Click j\u00A0avascript:alert%281337%29\n' +
          'Click \u00A0javascript:alert%281337%29',
      'Click httpscript:alert%281337%29\nClick mailtoscript:alert%281337%29\n' +
          'Click j\u00A0avascript:alert%281337%29\n' +
          'Click \u00A0javascript:alert%281337%29');
    });
  });
}


function testLinkifyNoOptions() {
  div.innerHTML = goog.string.linkify.linkifyPlainText('http://www.google.com');
  goog.testing.dom.assertHtmlContentsMatch(
      '<a href="http://www.google.com" target="_blank" rel="nofollow">' +
      'http://www.google.com<\/a>',
      div, true /* opt_strictAttributes */);
}

function testLinkifyOptionsNoAttributes() {
  div.innerHTML = goog.string.linkify.linkifyPlainText(
      'The link for www.google.com is located somewhere in ' +
      'https://www.google.fr/?hl=en, you should find it easily.',
      {rel: '', target: ''});
  goog.testing.dom.assertHtmlContentsMatch(
      'The link for <a href="http://www.google.com">www.google.com<\/a> is ' +
      'located somewhere in ' +
      '<a href="https://www.google.fr/?hl=en">https://www.google.fr/?hl=en' +
      '<\/a>, you should find it easily.',
      div, true /* opt_strictAttributes */);
}

function testLinkifyOptionsClassName() {
  div.innerHTML = goog.string.linkify.linkifyPlainText(
      'Attribute with <class> name www.w3c.org.',
      {'class': 'link-added'});
  goog.testing.dom.assertHtmlContentsMatch(
      'Attribute with &lt;class&gt; name <a href="http://www.w3c.org" ' +
      'target="_blank" rel="nofollow" class="link-added">www.w3c.org<\/a>.',
      div, true /* opt_strictAttributes */);
}

function testFindFirstUrlNoScheme() {
  assertEquals('www.google.com', goog.string.linkify.findFirstUrl(
      'www.google.com'));
}

function testFindFirstUrlNoSchemeWithText() {
  assertEquals('www.google.com', goog.string.linkify.findFirstUrl(
      'prefix www.google.com something'));
}

function testFindFirstUrlScheme() {
  assertEquals('http://www.google.com', goog.string.linkify.findFirstUrl(
      'http://www.google.com'));
}

function testFindFirstUrlSchemeWithText() {
  assertEquals('http://www.google.com', goog.string.linkify.findFirstUrl(
      'prefix http://www.google.com something'));
}

function testFindFirstUrlNoUrl() {
  assertEquals('', goog.string.linkify.findFirstUrl(
      'ygvtfr676 5v68fk uygbt85F^&%^&I%FVvc .'));
}

function testFindFirstEmailNoScheme() {
  assertEquals('fake@google.com', goog.string.linkify.findFirstEmail(
      'fake@google.com'));
}

function testFindFirstEmailNoSchemeWithText() {
  assertEquals('fake@google.com', goog.string.linkify.findFirstEmail(
      'prefix fake@google.com something'));
}

function testFindFirstEmailScheme() {
  assertEquals('mailto:fake@google.com', goog.string.linkify.findFirstEmail(
      'mailto:fake@google.com'));
}

function testFindFirstEmailSchemeWithText() {
  assertEquals('mailto:fake@google.com', goog.string.linkify.findFirstEmail(
      'prefix mailto:fake@google.com something'));
}

function testFindFirstEmailNoUrl() {
  assertEquals('', goog.string.linkify.findFirstEmail(
      'ygvtfr676 5v68fk uygbt85F^&%^&I%FVvc .'));
}

    test('Link contains parens, but does not end with them', () {
      assertLinkify(
      'www.google.com/abc(v1).html',
      '<a href="http://www.google.com/abc(v1).html">' +
          'www.google.com/abc(v1).html<\/a>');
    });

    test('Link ends with punctuation', () {
      assertLinkify(
      'Have you seen www.google.com? It\'s awesome.',
      'Have you seen <a href="http://www.google.com">www.google.com<\/a>?' +
      goog.string.htmlEscape(' It\'s awesome.'));
    });

    test('Link inside parentheses', () {
      assertLinkify(
      '(For more info see www.googl.com)',
      '(For more info see <a href="http://www.googl.com">www.googl.com<\/a>)');
    });

    test('Link followed by open parenthesis', () {
      assertLinkify(
      'www.google.com(',
      '<a href="http://www.google.com(">www.google.com(<\/a>');
    });

    test('Link inside angled brackets', () {
      assertLinkify(
      'Here is a bibliography entry <http://www.google.com/>',
      'Here is a bibliography entry &lt;<a href="http://www.google.com/">' +
          'http://www.google.com/<\/a>&gt;');
    });

    test('Link followed by closing punctuation pair then singular punctuation', () {
      assertLinkify(
      'Here is a bibliography entry <http://www.google.com/>, PTAL.',
      'Here is a bibliography entry &lt;<a href="http://www.google.com/">' +
          'http://www.google.com/<\/a>&gt;, PTAL.');
    });

    test('Link followed by three dots', () {
      assertLinkify(
      'just look it up on www.google.com...',
      'just look it up on <a href="http://www.google.com">www.google.com' +
          '<\/a>...');
    });

    test('Link containing brackets', () {
      assertLinkify(
      'before http://google.com/details?answer[0]=42 after',
      'before <a href="http://google.com/details?answer[0]=42">' +
          'http://google.com/details?answer[0]=42<\/a> after');
    });

    test('URL with exclamation points', () {
      assertLinkify(
      'This is awesome www.google.com!',
      'This is awesome <a href="http://www.google.com">www.google.com<\/a>!');
    });
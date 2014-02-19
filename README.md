# Task Queue

Takes a string of plain text and linkifies URLs and email addresses. Dart port of Google closure-library's String.linkify.

## Example

	import "linkify";
	
	var linkifiedHtml = linkifyPlainText("text");
	
	
	import "linkify" as linkify;
	
	var linkifiedHtml = linkify.linkifyPlainText("text");

## Resources

Original source of the Google [closure-library](https://code.google.com/p/closure-library/)'s 
[string.linkify](https://code.google.com/p/closure-library/source/browse/closure/goog/string/linkify.js) 
at [revision](https://code.google.com/p/closure-library/source/browse/closure/goog/string/linkify.js?r=8281e61b4173d0cdcd91d3815690d59bae410ca5).

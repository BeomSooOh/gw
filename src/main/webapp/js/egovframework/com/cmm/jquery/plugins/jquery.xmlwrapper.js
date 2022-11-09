/*!
File        : jquery.xmlwrapper.js
Author      : jnz
Version     : 1.5a
Copyright   : Placed in public domain by W. H. Jou, 2010
Discription : XML Wrapper v1.5a
*/
(function($){



// Initialize xmlDOM plugin : BEGIN
  if ($.xmlDOM == undefined) {
    // Use embedded xmlDOM plugin



/*!
 * jQuery xmlDOM Plugin v1.0
 * http://outwestmedia.com/jquery-plugins/xmldom/
 *
 * Released: 2009-04-06
 * Version: 1.0
 *
 * Copyright (c) 2009 Jonathan Sharp, Out West Media LLC.
 * Dual licensed under the MIT and GPL licenses.
 * http://docs.jquery.com/License
 */
(function($) {
        // IE DOMParser wrapper
        if ( window['DOMParser'] == undefined && window.ActiveXObject ) {
                DOMParser = function() { };
                DOMParser.prototype.parseFromString = function( xmlString ) {
                        var doc = new ActiveXObject('Microsoft.XMLDOM');
                doc.async = 'false';
                doc.loadXML( xmlString );
                        return doc;
                };
        }
        
        $.xmlDOM = function(xml, onErrorFn) {
                try {
                        var xmlDoc 	= ( new DOMParser() ).parseFromString( xml, 'text/xml' );
                        if ( $.isXMLDoc( xmlDoc ) ) {
                                var err = $('parsererror', xmlDoc);
                                if ( err.length == 1 ) {
                                        throw('Error: ' + $(xmlDoc).text() );
                                }
                        } else {
                                throw('Unable to parse XML');
                        }
                } catch( e ) {
                        var msg = ( e.name == undefined ? e : e.name + ': ' + e.message );
                        if ( $.isFunction( onErrorFn ) ) {
                                onErrorFn( msg );
                        } else {
                                $(document).trigger('xmlParseError', [ msg ]);
                        }
                        return $([]);
                }
                return $( xmlDoc );
        };
})(jQuery);



  } else {
    // Use external xmlDOM plugin
  }
// Initialize xmlDOM plugin : END



  var OTHER_NODE                  = 0;

  var ELEMENT_NODE                = 1;
  var ATTRIBUTE_NODE              = 2;
  var TEXT_NODE                   = 3;
  var CDATA_SECTION_NODE          = 4;
  var ENTITY_REFERENCE_NODE       = 5;
  var ENTITY_NODE                 = 6;
  var PROCESSING_INSTRUCTION_NODE = 7;
  var COMMENT_NODE                = 8;
  var DOCUMENT_NODE               = 9;
  var DOCUMENT_TYPE_NODE          = 10;
  var DOCUMENT_FRAGMENT_NODE      = 11;
  var NOTATION_NODE               = 12;

 var NODE_NAME  = [undefined, 'ELEMENT', 'ATTRIBUTE', 'TEXT', 'CDATA_SECTION', 'ENTITY_REFERENCE', 'ENTITY', 'PROCESSING_INSTRUCTION', 'COMMENT', 'DOCUMENT', 'DOCUMENT_TYPE', 'DOCUMENT_FRAGMENT', 'NOTATION'];
 var NODE_CLASS = [undefined];
 for (var i = 1; i < NODE_NAME.length; ++i) {
   NODE_CLASS[i] = 'xml-' + NODE_NAME[i];
 }

  var LT_CHAR = '&lt;';
  var GT_CHAR = '&gt;';

  var OTHER_CLASS      = 'xml-OTHER';
  var SYMBOL_CLASS     = 'xml-symbol';
  var BODY_CLASS       = 'xml-body';
  var NODE_NAME_CLASS  = 'xml-nodeName';
  var NODE_VALUE_CLASS = 'xml-nodeValue';

  function spanBegin(c) {
    return '<span class="' + c + '">';
  }

  function spanEnd() {
    return '</span>';
  }


  function wrapOther(node) {
    return '' 
      + spanBegin(NODE_CLASS[OTHER_NODE]) 
      +   '[Unhandled ' + NODE_NAME[node.nodeType] + ']'
      + spanEnd();
  }

  function wrapDocument(node) {
    return ''
      + '<div class="' + NODE_CLASS[node.nodeType]+ '">'
      +   wrapNode(node.childNodes[0])
      + '</div>';
  }

  function wrapText(node) {
    return ''
      + '<span class="' + NODE_CLASS[node.nodeType]+ '">' 
      +   spanBegin(BODY_CLASS)
      +       node.data 
      +   spanEnd()
      + spanEnd();
  }

  function wrapCdata(node) {
    return ''
      + '<span class="' + NODE_CLASS[node.nodeType]+ '">' 
      +   spanBegin(SYMBOL_CLASS)
      +     LT_CHAR + '![CDATA['
      +   spanEnd()
      +   spanBegin(BODY_CLASS)
      +       node.data 
      +   spanEnd()
      +   spanBegin(SYMBOL_CLASS)
      +     ']]' + GT_CHAR 
      +   spanEnd()
      + spanEnd();
  }

  function wrapComment(node) {
      return ''
      + '<span class="' + NODE_CLASS[node.nodeType]+ '">' 
      +   spanBegin(SYMBOL_CLASS)
      +     LT_CHAR + '!--' 
      +   spanEnd()
      +   spanBegin(BODY_CLASS)
      +       node.data 
      +   spanEnd()
      +   spanBegin(SYMBOL_CLASS)
      +     '--' + GT_CHAR
      +   spanEnd()
      + spanEnd();
  }

  function wrapAttribute(node) {
      return ''
      + spanBegin(NODE_CLASS[node.nodeType]+ '" name="' + node.nodeName + '" value="' + node.nodeValue)
      +   spanBegin(NODE_NAME_CLASS) 
      +     node.nodeName 
      +   spanEnd()
      +   spanBegin(SYMBOL_CLASS)
      +     '="'
      +   spanEnd()
      +   spanBegin(NODE_VALUE_CLASS)
      +     node.nodeValue 
      +   spanEnd()
      +   spanBegin(SYMBOL_CLASS)
      +     '"' 
      +   spanEnd()
      + spanEnd();
  }

  function wrapElement(node) {
    var wrappedAttributeNodes = [];
    var wrappedChildNodes     = [];
    var wrappedElement        = '';
    for (var i = 0; i < node.attributes.length; ++i) {
      var wrappedChildNode = wrapNode(node.attributes.item(i));
      wrappedAttributeNodes.push(wrappedChildNode);
    }
    for (var i = 0; i < node.childNodes.length; ++i) {
      var wrappedChildNode = wrapNode(node.childNodes[i]);
      wrappedChildNodes.push(wrappedChildNode);
    }

    var wrappedElement = ''
      + spanBegin(NODE_CLASS[node.nodeType]+ '" name="' + node.nodeName)
      +   spanBegin(SYMBOL_CLASS)
      +     LT_CHAR
      +   spanEnd()
      +   spanBegin(NODE_NAME_CLASS) 
      +     node.nodeName 
      +   spanEnd()
      +   spanBegin(BODY_CLASS)
    for (var i = 0; i < wrappedAttributeNodes.length; ++i) {
      wrappedElement += ' ' + wrappedAttributeNodes[i];
    }

    if (wrappedChildNodes.length == 0) {
      wrappedElement += ''
        +   spanEnd()
        +   spanBegin(NODE_VALUE_CLASS)
        +   spanEnd()
        +   spanBegin(SYMBOL_CLASS)
        +     '/' + GT_CHAR 
        +   spanEnd()
        + spanEnd();
    } else {
      wrappedElement += ''
        +     spanBegin(SYMBOL_CLASS)
        +       GT_CHAR
        +     spanEnd()
        +     spanBegin(NODE_VALUE_CLASS);
      for (var i = 0; i < wrappedChildNodes.length; ++i) {
        wrappedElement += wrappedChildNodes[i];
      }
      wrappedElement += ''
        +     spanEnd()
        +     spanBegin(SYMBOL_CLASS)
        +       LT_CHAR
        +     spanEnd()
        +   spanEnd()
        +   spanBegin(SYMBOL_CLASS)
        +     '/' 
        +   spanEnd()
        +   spanBegin(BODY_CLASS)
        +     spanBegin(NODE_NAME_CLASS) 
        +       node.nodeName 
        +     spanEnd()
        +   spanEnd()
        +   spanBegin(SYMBOL_CLASS)
        +     GT_CHAR
        +   spanEnd()
        + spanEnd();
    }
    return wrappedElement;
  }

  function wrapNode(node) {
    var wrappedNode = '';
    if (node.nodeType == TEXT_NODE) {
      wrappedNode = wrapText(node);
    } else if (node.nodeType == CDATA_SECTION_NODE) {
      wrappedNode = wrapCdata(node);
    } else if (node.nodeType == COMMENT_NODE) {
      wrappedNode = wrapComment(node);
    } else if (node.nodeType == ATTRIBUTE_NODE) {
      wrappedNode = wrapAttribute(node);
    } else if (node.nodeType == ELEMENT_NODE) {
      wrappedNode = wrapElement(node);
    } else if (node.nodeType == DOCUMENT_NODE) {
      wrappedNode = wrapDocument(node);
    } else {
      wrappedNode = wrapOther(node);
    }
    return wrappedNode;
  }

  function wrapXml(xml) {
    var node = $.xmlDOM(xml).get(0);
    var wrappedXml = wrapNode(node);
    return wrappedXml;
  }

  $.wrapXml = function(xml) {
    var wrappedXml = wrapXml(xml);
    var $wrappedXml = $(wrappedXml);
    return $wrappedXml;
  }
  $.wrapXmlFind = function($xml, xpathlike) {
    var compArray = xpathlike.split('/');
    var $e = $xml;
    for (var i = 0; i < compArray.length; ++i) {
      var comp = compArray[i];
      if (comp == '') {
        if (i == 0) {
          var $p = $e.closest('.' + NODE_CLASS[DOCUMENT_NODE]);
          var $c = $e.find('.' + NODE_CLASS[DOCUMENT_NODE]);
          $e = ($p.length > 0) ? $p : $c;
        }
      } else if (comp == '..') {
        $e = $e.closest('.' + NODE_CLASS[ELEMENT_NODE]);
      } else if (comp == '*') {
        $e = $e.find('.' + NODE_CLASS[ELEMENT_NODE]);
      } else if (comp.charAt(0) == '@') {
        comp = comp.substring(1);
        if (comp == '*') {
          $e = $e.find('.' + NODE_CLASS[ATTRIBUTE_NODE]);
        } else {
          $e = $e.find('.' + NODE_CLASS[ATTRIBUTE_NODE] + '[name="' + comp + '"]' );
        }
      } else if (comp == '#') {
        $e = $e.find('.' + NODE_VALUE_CLASS);
      } else {
        $e = $e.find('.' + NODE_CLASS[ELEMENT_NODE] + '[name="' + comp + '"]');
      }
    }
    return $e;
  }

  $.wrapXmlSetCollapsible = function($xml, collapsible) {
    if (collapsible) {
      $xml
        .find(NODE_CLASS[ELEMENT_NODE])
        .toggle(
          function() {$(this).find('.' + BODY_CLASS).hide();},
          function() {$(this).find('.' + BODY_CLASS).show();}
        );
    } else {
      $xml
        .find(NODE_CLASS[ELEMENT_NODE])
        .unbind('click');
    }
  }


})(jQuery);
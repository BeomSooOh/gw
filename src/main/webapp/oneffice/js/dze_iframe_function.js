function getEditorIframeWindow(b){b=parseInt(b,10);for(var a=document.getElementsByTagName("iframe"),c=null,d=0;d<a.length;d++)if(a[d].getAttribute("dzeditor_no")&&parseInt(a[d].getAttribute("dzeditor_no"),10)==b){c=a[d];break}return null==c?null:c.contentWindow||c.contentDocument}function getEditorHTMLCodeIframe(b){var a=getEditorIframeWindow(b);return null==a?"":a.dzeEnvConfig.fnGetEditorHTMLCode(!1,b)}
function setEditorHTMLCodeIframe(b,a){var c=getEditorIframeWindow(a);return null==c?"":c.dzeEnvConfig.fnSetEditorHTMLCode(b,!1,a)}function setFocusEditorIframe(b){var a=getEditorIframeWindow(b);null!=a&&(a.duzon_dialog.nEditNumber=b,a.duzon_dialog.setEditorSelection(),a.duzon_dialog.setEditorFocus(),a.editor_onselectionchange(b))}function getUploadedFileListIframe(b){var a=getEditorIframeWindow(b);return null==a?"":a.DZE_UPLOAD_EVENT.getUploadedFileList(b)};

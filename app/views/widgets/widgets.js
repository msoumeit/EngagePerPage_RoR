(function() {
var jQuery;
if (window.jQuery === undefined || window.jQuery.fn.jquery !== '1.11.0') {
    var script_tag = document.createElement('script');
    script_tag.setAttribute("type","text/javascript");
    script_tag.setAttribute("src", "//ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js");
    if (script_tag.readyState) {
      script_tag.onreadystatechange = function () { // For old versions of IE
          if (this.readyState == 'complete' || this.readyState == 'loaded') {
              scriptLoadHandler();
          }
      };
    } else {
      script_tag.onload = scriptLoadHandler;
    }
    (document.getElementsByTagName("head")[0] || document.documentElement).appendChild(script_tag);
} else {
    jQuery = window.jQuery;
    main();
}

function scriptLoadHandler() {
    jQuery = window.jQuery.noConflict(true);
    main();
}


function gup(name) {
		name = name.replace(/[\[]/, "\\\[").replace(/[\]]/, "\\\]");
		var regexS = "[\\?&]" + name + "=([^&#]*)";
		var regex = new RegExp(regexS);
		var results = regex.exec(window.location.href);
		if (results == null)
			return "";
		else
			return results[1];
	}


function main() {
    jQuery(document).ready(function($) {
        var resize_link = $("<script>", {
            type: "text/javascript",
            text: "function resizeIframe(iframe) { iframe.height = '700px';}"
        });
        
        resize_link.appendTo('.epp-widget');
		var game_url = "<%= @gameshow %>";
		var iframe_content =  $('<iframe>', {
   					 src: game_url ,
   					 scrolling:   'no',
   					 frameborder:'0',
   					 width: '500px',
   					 height: '1000px'
		});
	iframe_content.appendTo('.epp-widget');

    });
}
})();
$(document).ready(function() {

    // Create mailto link for contact information
    var url = "mai";
    url += "lto:dl";
    url += "i@r";
    url += "ice.edu";
    $(".contact-us").attr("href",url);

    // Create collapsable divs for certain metadata fields and other toggleables
    $('div.hiddenvalue').hide();
    $('span.show-hide').show();
    $('div.hiddenfield').click(function() {
        $(this).parent().next().find("div").slideToggle('fast');
        $(this).find("span.hide").toggle();
        $(this).find("span.show").toggle();
    });

    // For metadata tables, set the even/odd classes here instead of bothering with a bunch of nasty XSL.
    $(".ds-includeSet-table tr:odd").addClass("odd");                       
    $(".ds-includeSet-table tr:even").addClass("even");

    // Change style if we're not on production
	if (location.href.indexOf('dspacetest') > 0) {
	    $("h1.primary-header").css({'background-image' : 'url(/themes/Rice/images/dspacetest-background.png)'});
	}
	if (location.href.indexOf('dspacedev') > 0) {
	    $("h1.primary-header").css({'background-image' : 'url(/themes/Rice/images/dspacedev-background.png)'});
	}

	if (window.location.hash == '#collapseBrowse' && window.location.href.replace(window.location.hash,'').indexOf("browse") != -1) {
		collapseBrowseControls();
	}
});

function collapseBrowseControls() {
	$("#ds-trail").hide();
	$("#ds-options").hide();
	$("#context-browse-search").hide();
	$("#aspect_artifactbrowser_ConfigurableBrowse_div_browse-navigation").hide();
	$("#aspect_artifactbrowser_ConfigurableBrowse_div_browse-controls").hide();
	$("#ds-body").css("margin-left","0px");
	$("#rice-main").css("background-image","url()");
	
	// modify all body links to preserve collapsed state
	$("#ds-body a").attr('href', function(h) {
		return $(this).attr('href')+'#collapseBrowse';
	});

	// add link to turn controls back on
	var link = $("<a id=\"browse-restore\" href=\""+window.location.href.replace(window.location.hash,'')+"\">Show full browse controls</a>");
	$(".pagination.top").after(link);
}

function showJPEG2000Viewer(bitstreamurl){
    var bits = bitstreamurl.split(/\?/);
    if(bits!= null){
	bitstreamurl = bits[0];
    }
    var url = document.location.href;
    var baseurl = "";

    if (url != null){
    var proto = window.location.protocol;
	var ss = url.split(/\//);
	var ss1 = ss[1];
	var ss2 = ss[2];
	if((ss[1] != null) && (ss[1].indexOf('rice.edu') > 0)){
	    baseurl = proto+'//' + ss1;

	}
	else {
	    if((ss[2] != null) && (ss[2].indexOf('rice.edu')>0)){
		baseurl = proto+'//' + ss2;
	    }
	}
    }
    var fullurl = baseurl + "/jp2/viewer.html?url=" + baseurl + bitstreamurl;
    window.location = fullurl;

}

// Ying added this for mp4 streaming
function getfullURL (bitstreamurl) {

    var server = "";
    if (location.href.indexOf('dspacetest') > 0) {
        server = "dspacetest";
    }else if((location.href.indexOf('dspacedev') > 0)) {
        server = "dspacedev";
    }else if((location.href.indexOf('dspaceland') > 0)) {
        server = "dspaceland";
    }else{

        server= "dspace";
    }

    return "http://"+server+".rice.edu/"+bitstreamurl;
}

function streamingIt(format, title, streamingfilename){

    //SERVER-SPECIFIC
    var uri = "";
    var server = "";
    if (location.href.indexOf('dspacetest') > 0) {
        server = "dspacetest";
    }else if((location.href.indexOf('dspacedev') > 0)) {
        server = "dspacedev";
    }else if((location.href.indexOf('dspaceland') > 0)) {
        server = "dspaceland";
    }else{

        server= "dspace";
    }

    if(format == 'win'){
	uri = "mms://wmdp.rice.edu/"+server+"/streaming/";
    }else if(format == 'real'){
        uri = "rtsp://rmdp.rice.edu/"+server+"/streaming/";
    }
    // var fullurl = "http://webcast.rice.edu/webcast.php?action=view&format=" + encodeURIComponent(format) + "&title=" + encodeURIComponent(title) + "&uri=" + encodeURIComponent(uri) + encodeURIComponent(streamingfilename);
    //--- var fullurl = "http://edtech.rice.edu/cms/?option=com_iwebcast&action=view&format=" + encodeURIComponent(format) + "&title=" + encodeURIComponent(title) + "&uri=" + encodeURIComponent(uri) + encodeURIComponent(streamingfilename);
    //var fullurl	= encodeURIComponent(uri) + encodeURIComponent(streamingfilename);
    var fullurl = uri + streamingfilename;

    window.open(fullurl, "CDS streaming");

}


/* 
Two search inputs (repository and context), with default helper text in each.  
If the user clicks in or tabs to an input, and the default text is there, replace it with nothing and let the user type in their own text.  
If the user leaves the input, replace it with the default text iff the user has left the input blank. 
*/

var valueRepository = '';
var valueContext = '';
var iterationRepository = 0;
var iterationContext = 0;

function removeLabel(input, context) {
  if (iterationRepository == 0 && !context) {
     valueRepository = input.value;
  }
  if (iterationContext == 0 && context) {
     valueContext = input.value;
  }
  if ((input.value == valueRepository && !context) || (input.value == valueContext && context)) {
    input.style.color = '#000000';
    input.value = '';
  }
  if (iterationRepository == 0 && !context) {
     iterationRepository = 1;
  }
  if (iterationContext == 0 && context) {
     iterationContext = 1;
  }
}
function resurrectLabel(input, context) {
  if (input.value == '' && !context) {
     input.value = valueRepository;
     input.style.color = '#999999'
  }
  if (input.value == '' && context) {
     input.value = valueContext;
     input.style.color = '#999999'
  }
}

// Ying added this for mp4 html5/flash streaming
(function(win, doc) {
	/* Flash detection */
	var isFlashInstalled = ((navigator.plugins && navigator.plugins['Shockwave Flash']) || (win.ActiveXObject && !!(new ActiveXObject('ShockwaveFlash.ShockwaveFlash'))));
	/* Event handlers */
	var _addEvent = (win.addEventListener) ? function(type, node, fn) {
		node.addEventListener(type, fn, false);
	} : function(type, node, fn) {
		node.attachEvent(
			'on'+type,
			function(e) {
				fn.apply(node, [e]);
			}
		);
	};
	var _removeEvent = (win.removeEventListener) ? function(type, node, fn) {
		node.removeEventListener(type, fn, false);
	} : function(type, node, fn) {
		node.detachEvent(
			'on'+type,
			function(e) {
				fn.apply(node, [e]);
			}
		);
	};
	/* Element By Id */
	function _gid(id) {
		return document.getElementById(id);
	}
	/* Copy to Clipboard  */
	function getCopyToClipboardSWF(str) {
		var swf = 'clippy.swf',
			flashHTML = '<object type="application/x-shockwave-flash" data="'+swf+'" width="110" height="14" style="vertical-align: bottom;">'+
					'<param name="movie" value="'+swf+'">'+
					'<param name="wmode" value="transparent">'+
					'<param name="allowScriptAccess" value="true">'+
					'<param name="flashvars" value="text='+urlEncode(str)+'">'+
				'</object>';
		return (isFlashInstalled) ? flashHTML : '';
	}
	/* Form functions */
	function isChecked(el) {
		return !!el.checked;
	}
	function isVal(el) {
		return el.value != '';
	}
	function val(el) {
		return el.value;
	}
	/* URL Encoding */
	function urlEncode(str) {
		return encodeURIComponent(str).replace(
			/!/g, '%21'
		).replace(
			/'/g, '%27'
		).replace(
			/\(/g, '%28'
		).replace(
			/\)/g, '%29'
		).replace(
			/\*/g, '%2A'
		).replace(
			/%20/g, '+'
		);
	}
	/* Read Embed Type from radio array */
	function getEmbedType() {
		var nodes = formNode.embedType,
			nodesLen = nodes.length,
			i = -1;
		while(++i < nodesLen) if (nodes[i].checked) return nodes[i].value;
	}
	/* Current flash players */
	function getFlashPlayerURL() {
		var type = val(formNode.flashPlayer),
			types = {
				flo: 'http://releases.flowplayer.org/swf/flowplayer-3.2.1.swf',
				jwp: 'http://player.longtailvideo.com/player.swf',
				ffx: 'http://flashfox.googlecode.com/svn/trunk/flashfox.swf'
			};
		return types[type];
	}
	/* Current flash player flashvars */
	function getFlashPlayerVars() {
		var poster = urlEncode(val(posterNode)),
			mp4 = urlEncode(val(mp4Node))	,
			isAutoplay = autoplayNode.checked,
			isPoster = isVal(posterNode);
		var type = val(formNode.flashPlayer),
			types = {
				flo: ('config={"playlist":['+(isPoster?'"'+poster+'",':'')+'{"url":"'+mp4+'","autoPlay":'+isAutoplay+'}]}').replace(/"/g, '\''),
				jwp: (isAutoplay?'autostart=true&amp;':'')+'controlbar=over'+(poster?'&amp;image='+poster:'')+'&amp;file='+mp4,
				ffx: (isAutoplay?'autoplay=true&amp;':'')+'controls=true'+(poster?'&amp;poster='+poster:'')+'&amp;src='+mp4
			};
		return types[type];
	}
	/* XML Formatting */
	function addXMLFormatting(str) {
		return str.replace(
			/<video controls autoplay /, '<video controls="controls" autoplay="autoplay" '
		).replace(
			/<video controls /, '<video controls="controls" '
		).replace(
			/<(br|hr|img|input|param|source)(.*?)\s*\/*>/g, '<$1$2 />'
		);
	}
	function removeXMLFormatting(str) {
		return str.replace(
			/<video controls="controls" autoplay="autoplay" /, '<video controls autoplay '
		).replace(
			/<video controls="controls" /, '<video controls '
		).replace(
			/<(br|hr|img|input|param|source)(.*?)\s*\/*>/g, '<$1$2>'
		);
	}
	/* HTML after Video */
	function getPostHtml() {
		var postHtml = [];
		if (isVal(mp4Node)) postHtml.push('<a href="'+val(mp4Node)+'">MP4 format</a>');
		if (isVal(ogvNode)) postHtml.push('<a href="'+val(ogvNode)+'">Ogg format</a>');
		if (isVal(webmNode)) postHtml.push('<a href="'+val(webmNode)+'">WebM format</a>');
		return '<p>\n\t<strong>Download video:</strong> '+postHtml.join(' | ')+'\n</p>';
	}
	/* HTML if no video */
	function getFallbackHtml() {
		var titleAttr = 'title="No video playback capabilities, please download the video below"';
		return isVal(posterNode) ? '<img alt="'+val(fallbackTitleNode)+'" src="'+val(posterNode)+'" width="'+val(widthNode)+'" height="'+val(heightNode)+'" '+titleAttr+'>' : '<span '+titleAttr+'>'+val(fallbackTitleNode)+'</span>';
	}
	/* HTML for Flash */
	function getFlashHtml(fallbackHTML) {
		var htmlArr = [
			'<object type="application/x-shockwave-flash" data="'+getFlashPlayerURL()+'" width="'+val(widthNode)+'" height="'+val(heightNode)+'">',
			'\t<param name="movie" value="'+getFlashPlayerURL()+'">',
			'\t<param name="allowFullScreen" value="true">',
			'\t<param name="wmode" value="transparent">',
			'\t<param name="flashVars" value="'+getFlashPlayerVars()+'">'
		];
		if (fallbackHTML) htmlArr.push('\t'+fallbackHTML);
		return htmlArr.join('\n')+'\n</object>';
	}
	/* HTML video */
	function getVideoHtml(fallbackHTML) {
		var htmlArr = [];
		htmlArr.push(
			'<video controls'+
			(isChecked(autoplayNode) ? ' autoplay' : '')+
			(isVal(posterNode) ? ' poster="'+val(posterNode)+'"' : '')+
			' width="'+val(widthNode)+'" height="'+val(heightNode)+'">'
		);
		if (isVal(mp4Node)) htmlArr.push('\t<source src="'+val(mp4Node)+'" type="video/mp4">');
		if (isVal(webmNode)) htmlArr.push('\t<source src="'+val(webmNode)+'" type="video/webm">');
		if (isVal(ogvNode)) htmlArr.push('\t<source src="'+val(ogvNode)+'" type="video/ogg">');
		if (fallbackHTML) htmlArr.push(fallbackHTML.replace(/(^|\n)/g, '$1\t'));
		return htmlArr.join('\n')+'\n</video>';
	}
	/* Render Output */
	function renderOutput() {
		var callee = arguments.callee;
		var embedType = getEmbedType(),
			flashPlayerURL = getFlashPlayerURL(),
			flashPlayerVars = getFlashPlayerVars();
		var preHtml = '<!-- "Video For Everybody" http://camendesign.com/code/video_for_everybody -->',
			postHtml = getPostHtml(),
			fallbackHtml = getFallbackHtml(),
			html,
			show,
			source,
			codeChanged;
		if (embedType == '5f') html = getVideoHtml(getFlashHtml(fallbackHtml));
		if (embedType == '5') html = getVideoHtml(fallbackHtml);
		if (embedType == 'f') html = getFlashHtml(fallbackHtml);
		if (embedType == 'p') html = '<div>\n\t'+fallbackHtml+'\n</div>';
		html = preHtml+'\n'+html+'\n'+postHtml;
		htmlChanged = callee.html != html;
		callee.html = show = source = html;
		if (isChecked(xmlNode)) show = addXMLFormatting(show);
		source = show
			.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/"/g, '&quot;')
			.replace(/(&lt;!--.*?-->)/g, '<span class="rem">$1</span>')
			.replace(/(&amp;[A-z0-9]+;)/g, '<span class="enc">$1</span>')
			.replace(/(&lt;\/*)([a-z]+)/g, '$1<span class="node">$2</span>')
			.replace(/([a-z]+)=&quot;(.*?)&quot;/g, '<span class="attr">$1</span>=&quot;<span class="val">$2</span>&quot;');
		codeChanged = callee.code != source;
		callee.code = source;
		if (htmlChanged) showCodeNode.innerHTML = show;
		if (codeChanged) {
			clipboardSwfNode.innerHTML = getCopyToClipboardSWF(show);
			sourceCodeNode.innerHTML = '<pre>'+source+'</pre>';
			expandCode();
		}
	}
	/* Node variables */
	var clipboardSwfNode = _gid('clipboardSWF'),
		showCodeNode = _gid('showCode'),
		sourceCodeNode = _gid('sourceCode'),
		formNode = _gid('controlsForm'),
		mp4Node = formNode.mp4,
		ogvNode = formNode.ogv,
		webmNode = formNode.webm,
		posterNode = formNode.poster,
		autoplayNode = formNode.autoplay,
		xmlNode = formNode.xml,
		widthNode = formNode.width,
		heightNode = formNode.height,
		fallbackTitleNode = formNode.fallbackTitle;
	/* Attach render events to form controls */
	var formNodes = formNode.elements,
		formNodesLen = formNodes.length,
		i = -1;
	while (++i < formNodesLen) {
		_addEvent('change', formNodes[i], renderOutput);
		_addEvent('click', formNodes[i], renderOutput);
	}
	/* Disable highlight selection of controls labels */
	var falseFn = function() { return false; }
	formNodes = formNode.getElementsByTagName('label');
	formNodesLen = formNodes.length;
	i = -1;
	while (++i < formNodesLen) {
		formNodes[i].style.MozUserSelect = 'none';
		formNodes[i].onselectstart = falseFn;
		formNodes[i].onmousedown = falseFn;
	}
	/* Run immediately */
	var controlCommand = _gid('control-command'),
		controlContainer = controlCommand.parentNode.parentNode.parentNode,
		controlContainerContent = controlContainer.getElementsByTagName('div')[0];
	function collapseCode() {
		controlCommand.className += ' control-command-collapsed';
		controlContainer.className += ' section-code-collapsed';
		controlContainer.style.height = '0px';
	}
	function expandCode() {
		controlCommand.className = controlCommand.className.replace(/ control-command-collapsed/, '');
		controlContainer.className = controlContainer.className.replace(/ section-code-collapsed/, '');
		controlContainer.style.height = controlContainerContent.scrollHeight+'px';
	}
	_addEvent(
		'click',
		controlCommand,
		function(e) {
			if (/control-command-collapsed/.test(controlCommand.className)) {
				expandCode();
			}
			else {
				collapseCode();
			}
		}
	);
	/* Run immediately */
	renderOutput();
})(this, document);


//END  Ying added this for mp4 html5 streaming

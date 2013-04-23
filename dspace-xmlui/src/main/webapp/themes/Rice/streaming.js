function showJPEG2000Viewer(bitstreamurl){
    //  alert("here");
    // var bitstreamurl = '<xsl:value-of select="mets:FLocat[@LOCTYPE='URL']/@xlink:href"/>';
    // alert(bitstreamurl);
    
    var bits = bitstreamurl.split(/\?/);
       if(bits!= null){
          bitstreamurl = bits[0];
       }
    // alert (bitstreamurl);
    var url = document.location.href;
    var baseurl = "";
    if (url != null){
       var ss = url.split(/\//);
       if(ss[2] != null){
          baseurl = "http://" + ss[2];
       }
    }
    //alert(baseurl);
    //var fullurl = "http://sansa.rice.edu:8080/adore-djatoka/viewer.html?url=" + baseurl + bitstreamurl;
    var fullurl = baseurl + "/adore-djatoka/viewer.html?url=" + baseurl + bitstreamurl;
    //alert(fullurl);
    window.location = fullurl;
}

function streamingIt(format, title, streamingfilename){

   
    var url = document.location.href;
    var server = "";

    if(url.indexOf('dspacedev') > 0){
        server = "dspacedev";
    }
    else if(url.indexOf('dspacetest') > 0){
        server = "dspacetest";
    }else{
        server = "dspace";
    }

    if (url != null){
       var ss = url.split(/\//);
       if(ss[2] != null){
          baseurl = "http://" + ss[2];
       }
    }
    var proto = "";
    if(format == 'win'){
	    proto = "rtsp://wmdp.rice.edu/";
    }else if(format == 'real'){
        proto = "rtsp://rmdp.rice.edu/";
    }
    var uri = proto + sever + "/streaming/";

    //var fullurl = "http://webcast.rice.edu/webcast.php?action=view&format=" + encodeURIComponent(format) + "&title=" + encodeURIComponent(title) + "&uri=" + encodeURIComponent(uri) + encodeURIComponent(streamingfilename);
    var fullurl = "http://edtech.rice.edu/cms/?option=com_iwebcast&action=view&format=" + encodeURIComponent(format) + "&title=" + encodeURIComponent(title) + "&uri=" + encodeURIComponen\
t(uri) + encodeURIComponent(streamingfilename);
    //alert(fullurl);
    window.location = fullurl;
}
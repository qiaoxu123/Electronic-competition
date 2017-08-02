//===============（菜单栏选中处理）begin==================//
var _url = window.location.href;
if (_url.length < 25)
    document.getElementById("default-aspx").className = "title0c";
if (_url.indexOf("info-list-2") > 0 || _url.indexOf("info-toplist-2") > 0)
    document.getElementById("infolist-2").className = "title1c";
if (_url.indexOf("info-list-3") > 0 || _url.indexOf("info-toplist-3") > 0)
    document.getElementById("infolist-3").className = "title1c";
if (_url.indexOf("info-list-4") > 0 || _url.indexOf("info-toplist-4") > 0)
    document.getElementById("infolist-4").className = "title1c";
if (_url.indexOf("info-list-5") > 0 || _url.indexOf("info-toplist-5") > 0)
    document.getElementById("infolist-5").className = "title1c";
if (_url.indexOf("info-list-6") > 0 || _url.indexOf("info-toplist-6") > 0)
    document.getElementById("infolist-6").className = "title1c";
if (_url.indexOf("info-list-7") > 0 || _url.indexOf("info-toplist-7") > 0)
    document.getElementById("infolist-7").className = "title1c";
if (_url.indexOf("info-list-8") > 0 || _url.indexOf("info-toplist-8") > 0)
    document.getElementById("infolist-8").className = "title1c";
if (_url.indexOf("info-list-9") > 0 || _url.indexOf("info-toplist-9") > 0)
    document.getElementById("infolist-9").className = "title1c";
if (_url.indexOf("info-list-11") > 0 || _url.indexOf("info-toplist-11") > 0)
    document.getElementById("infolist-11").className = "title1c";
if (_url.indexOf("member.html") > 0)
    document.getElementById("memberhtml").className = "title1c";
//===============（菜单栏选中处理）end===================//
function mamicode_enterpress(e) {
    var keynum;
    if (window.event)
        keynum = e.keyCode;
    else if (e.which)
        keynum = e.which;
    if (keynum == 13){
        mamicode_soJS();
        return false;
    }
}
function getCookie(objName) {
    var arrStr = document.cookie.split("; ");
    for (var i = 0; i < arrStr.length; i++) {
        var temp = arrStr[i].split("=");
        if (temp[0] == objName)
            return temp[1];
    }
}
//------（登录状态）begin--------//
$.ajax({
    type: "POST", cache: false,
    url: "/ajaxjs/member_login.aspx?act=loginstate",
    data: "",
    success: function (data) {
        if (data != null && data != "")
            $("#logintopdescription").html(data);
    }
});
//------（登录状态）end--------//
(function ($) {
    var obj = $("#xuanting");
    if(obj)
    {
        var left = parseInt(($(document.body).width() - 1000) / 2) + 1000 - 300;
        var contentTop = parseInt(obj.offset().top)+260;
        $(window).bind("scroll", function () {
            var tt = $(document).scrollTop() + 1;
            if (tt > contentTop && $(document).height() > 4000) {
                obj.css("position", "fixed");
                obj.css("left", "" + left + "px");
                obj.css("top", "1px");
                obj.css("z-index", "1000");
            }
            if (tt <= contentTop)
                obj.css("position", "");
        });
    }
})(jQuery);
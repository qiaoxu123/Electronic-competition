$(function () {

    /*----赞----*/
    $("#infoyes").click(function () {
        $.ajax({
            type: "POST", cache: false,
            url: "/ajaxjs/info_detail_ajaxjs.aspx?act=yes&id=" + id + "&idm=" + idm,
            data: "",
            success: function (data) {
                if (data != null && data != "") {
                    if (data == "-2") {
                        $("#spanYesContent").html("异常！");
                    }
                    else if (data == "-1") {
                        $("#spanYesContent").html("您已经赞过了！");
                    }
                    else {
                        $("#spanYes").html(data);
                    }
                }
            }
        });

    });
    /*----赞----(end)*/


    /*----踩----*/
    $("#infono").click(function () {

        $.ajax({
            type: "POST", cache: false,
            url: "/ajaxjs/info_detail_ajaxjs.aspx?act=no&id=" + id + "&idm=" + idm,
            data: "",
            success: function (data) {
                if (data != null && data != "") {
                    if (data == "-2") {
                        $("#spanNoContent").html("异常！");
                    }
                    else if (data == "-1") {
                        $("#spanNoContent").html("您已经踩过了！");
                    }
                    else {
                        $("#spanNo").html(data);
                    }
                }
            }
        });
    });
    /*----踩----(end)*/

    /*----举报----*/
    $("#infobad").click(function () {

        $.ajax({
            type: "POST", cache: false,
            url: "/ajaxjs/info_detail_ajaxjs.aspx?act=bad&id=" + id + "&idm=" + idm,
            data: "",
            success: function (data) {
                if (data != null && data != "") {
                    if (data == "-2") {
                        $("#spanBadContent").html("异常！");
                    }
                    else if (data == "-1") {
                        $("#spanBadContent").html("您已经举报过了！");
                    }
                    else {
                        $("#spanBadContent").html("成功举报，感谢您！");
                    }
                }
            }
        });
    });
    /*----举报----(end)*/

    /*----评论----*/
    $("#btnaddcomment").click(function () {

        var cValue = $("#tbcommentcontent").val();
        var byid = $("#commenthfid").val();

        if (cValue.length < 5) {
            $("#addCommentTishi").html("评论内容不可少于5个字！");
        }
        else {
            cValue = encodeURIComponent(cValue);
            cValue = cValue.replace(/(&)/g, "(_)");

            $.ajax({
                type: "POST", cache: false,
                url: "/ajaxjs/info_detail_ajaxjs.aspx?act=addcomment&id=" + id + "&idm=" + idm + "&byid=" + byid + "&content=" + cValue,
                data: "",
                success: function (data) {
                    if (data != null && data != "") {
                        if (data == "1") {
                            var now = (new Date()).getTime();

                            $("#tbcommentcontent").val('');
                            location.href = "info-detail-" + id + ".html?a=" + now + "&commentpage=end#commentitem" + (parseInt(commentitemcount) + 1);

                        }
                        else if (data == "-22") {
                            //$("#addCommentTishi").html("评论速度太快了，稍等一小会！");
                            alert("评论速度太快了，稍等一小会！");
                        }
                        else if (data == "-1") {
                            $("#addCommentTishi").html("评论异常！");
                        }
                        else {
                            $("#addCommentTishi").html("评论异常[" + data + "]！");
                        }
                    }
                }
            });
        }
    });
    /*----评论----(end)*/

    /*----收藏----*/
    $("#infofavorite").click(function () {
        var _title = $("#Htitle").html();
        _title = encodeURIComponent(_title);

        $.ajax({
            type: "POST", cache: false,
            url: "/ajaxjs/info_detail_ajaxjs.aspx?act=favorite&id=" + id + "&idm=" + idm + "&title=" + _title,
            data: "",
            success: function (data) {
                if (data != null && data != "") {
                    if (data == "1") {
                        alert("收藏成功！");
                    }
                    else if (data == "-2") {
                        $("#spanBadContent").html("异常！");
                    }
                    else if (data == "-3") {
                        alert("您已经收藏过了！");
                        //$("#spanBadContent").html("您已经收藏过了！");
                    }
                    else if (data == "-4") {
                        $("#spanBadContent").html("收藏异常！");
                    }
                    else if (data == "-1") {
                        location.href = memberhost + "login.aspx?returnUrl=" + document.URL.replace(/&/, "(_)");
                    }
                    else {

                    }
                }
            }
        });
    });
    /*----收藏----(end)*/

});

function itemCommentYesOnclick(_id) {

    $.ajax({
        type: "POST", cache: false,
        url: "/ajaxjs/info_detail_ajaxjs.aspx?act=commentyes&id=" + id + "&idm=" + idm + "&cid=" + _id,
        data: "",
        success: function (data) {
            if (data != null && data != "") {
                if (data == "-2") {
                    $("#spanYesContent_" + _id).html("异常！");
                }
                else if (data == "-1") {
                    $("#spanYesContent_" + _id).html("您已经赞过了！");
                }
                else {
                    $("#spanYes_" + _id).html(data);
                }
            }
        }
    });
}

function itemCommentNoOnclick(_id) {

    $.ajax({
        type: "POST", cache: false,
        url: "/ajaxjs/info_detail_ajaxjs.aspx?act=commentno&id=" + id + "&idm=" + idm + "&cid=" + _id,
        data: "",
        success: function (data) {
            if (data != null && data != "") {
                if (data == "-2") {
                    $("#spanNoContent_" + _id).html("异常！");
                }
                else if (data == "-1") {
                    $("#spanNoContent_" + _id).html("您已经踩过了！");
                }
                else {
                    $("#spanNo_" + _id).html(data);
                }
            }
        }
    });
}

function itemCommenthfOnclick(_id, _nickname, _content) {

    $("#commenthfid").val(_id);

    var des = "";

    des = "<div class='padding5 divbackgroundcolor colorboldCheng'>回复：" + _nickname + "</div>" +
            "<div class='padding5 detailpinglundetail'>" + _content + "</div>";

    $("#commenthf").html(des);

    location.hash = "#commenthf";
}


function infocommentDel(_id) {
    $.ajax({
        type: "POST", cache: false,
        url: "/ajaxjs/info_detail_ajaxjs.aspx?act=delcomment&id=" + _id,
        data: "",
        success: function (data) {
            if (data != null && data != "") {
                if (data == "-2") {
                    alert("异常！");
                }
                else if (data == "-1") {
                    alert("您未登录！");
                }
                else if (data == "1") {
                    $("#commentitem" + _id).html("已删除");
                }
                else {
                }
            }
        }
    });
}
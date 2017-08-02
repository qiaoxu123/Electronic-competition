$(function () {

    /*----关注----*/
    $("#member_right_t_memberattention").click(function () {
        var _memberID = $("#member_right_t_hfmemberID").val();
        var _currentmemberID = $("#member_right_t_hfcurrentmemberID").val();
        var _memberIDm = $("#member_right_t_hfmemberIDm").val();

        if (_currentmemberID == "0") {
            location.href = "http://member.mamicode.com/login.aspx?returnUrl=" + document.URL.replace(/&/, "(_)");
        }
        else {
            $.ajax({
                type: "POST", cache: false,
                url: "/ajaxjs/member_attention.aspx?act=attention&id=" + _currentmemberID + "&byid=" + _memberID + "&idm=" + _memberIDm,
                data: "",
                success: function (data) {
                    if (data != null && data != "") {
                        if (data == "1") {
                            $("#member_right_t_memberattentionstate").css("display", "");
                            $("#member_right_t_memberattention").css("display", "none");
                        }
                        else if (data == "-3") {
                            alert('已经关注了！');
                        }
                        else if (data == "-2") {
                            alert('异常！');
                        }
                        else if (data == "-1") {
                            alert('操作异常！');
                        }
                        else {
                            alert('异常[' + data + ']！');
                        }
                    }
                }
            });
        }

    });
    /*----关注----(end)*/

});
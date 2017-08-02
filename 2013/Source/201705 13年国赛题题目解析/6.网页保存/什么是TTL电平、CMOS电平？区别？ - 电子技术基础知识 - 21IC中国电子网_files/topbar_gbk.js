
var img = 'http://misc.21ic.com/pub/topbar/images/';

var top_uid = 0;
var top_user = '';

function getcookie(name) {
	var cookie_start = document.cookie.indexOf(name);
	var cookie_end = document.cookie.indexOf(";", cookie_start);
	return cookie_start == -1 ? '' : decodeURI(document.cookie.substring(cookie_start + name.length + 1, (cookie_end > cookie_start ? cookie_end : document.cookie.length)));
}

top_user = getcookie('ic21_bbsuser');
if (top_user) {
	var top_userinfo = top_user.split("\t");
	var top_uid = top_userinfo[1];
	var top_username = top_userinfo[0];
	var Qtpl ='\<div id="top_wallet"><span class="down_arrow5"><a href="http://pay.21ic.com" target="_blank" title="我的钱包">我的钱包</a></span></div>\
		<div id="top_user" onmouseover="showmenu3()" onmouseout="hidemenu3()"><span class="down_arrow3"><a href="http://my.21ic.com" target="_blank" title="进入用户中心"><img src="http://uc2.21ic.com/avatar.php?uid='+top_uid+'&size=small" /></a></span>\
			<div class="top_downmenu3" style="display:none;">\
				<div class="usercenter_head"><a href="http://my.21ic.com/home.php?mod=spacecp&ac=avatar" target="_blank"><img src="http://uc2.21ic.com/avatar.php?uid='+top_uid+'&size=middle" title="点击修改头像" /></a></div>\
				<div class="usercenter_username"><a href="http://my.21ic.com" target="_blank" title="进入用户中心">'+top_username+'</a></div>\
				<ul class="usercenter_menu">\
				  <li><a class="top_edit13" href="http://my.21ic.com" target="_blank">用户中心</a></li>\
				  <li><a class="top_edit9" href="http://my.21ic.com/home.php?mod=spacecp&ac=profile" target="_blank">资料修改</a></li>\
				  <li><a class="top_edit10" href="http://my.21ic.com/logout_www.php">退出</a></li>\
				</ul>\
			</div>\
		</div>\
		<div id="top_edit" onmouseover="showmenu2()" onmouseout="hidemenu2()"><span class="down_arrow2"></span>\
			<ul class="top_downmenu2" style="display:none;">\
			  <li><a href="http://bbs.21ic.com/home.php?mod=space&do=thread&view=me" target="_blank" class="top_edit1">我的帖子</a></li>\
			  <li><a href="http://project.21ic.com/my/info" target="_blank" class="top_edit2">我的项目</a></li>\
			  <li><a href="http://photo.21ic.com/member/info" target="_blank" class="top_edit4">我的图集</a></li>\
			  <li><a href="http://dl.21ic.com/user/downloadlog.html" target="_blank" class="top_edit6">我的下载</a></li>\
			  <li><a href="http://edu.21ic.com/user/lesson" target="_blank" class="top_edit7">我的课程</a></li>\
			  <li><a href="http://seminar.21ic.com/usercenter" target="_blank" class="top_edit11">我的研讨会</a></li>\
			  <li><a href="http://bbs.21ic.com/home.php?mod=space&do=blog" target="_blank" class="top_edit8">我的博客</a></li>\
			</ul>\
		</div>\
	';

	$(document).ready(function(){$("#top_userlogin").html(Qtpl);});
}
 function checkinput(){
 	var q_name = $("#topbar_q").attr('name');
 	var q_value = $("#topbar_q").val().length;
 	if( (q_name == 'k' || q_name == 'part_number') && q_value <3 )
 	{
 		alert("查询器件，需要输入三个以上字符");
 		return false;
 	}
 	return true;
 }
 
 var topso_ac = new Array(4); 
  topso_ac['s1'] = 'http://www.21ic.com.cn/search';
  topso_ac['s2'] = 'http://www.21icsearch.com/search/index.html';
  topso_ac['s3'] = 'http://search.21ic.com/so.php?type=www';
  topso_ac['s4'] = 'http://search.21ic.com/so.php?type=dl';
  topso_ac['s5'] = 'http://project.21ic.com/project/list';
 var top_sc = new Array(4);
 top_sc['s1'] = 'part_number';
 top_sc['s2'] = 'k';
 top_sc['s3'] = 'keyword';
 top_sc['s4'] = 'keyword';
 top_sc['s5'] = 'kw';
 var top_t = new Array(4);
top_t['s1'] = '';
top_t['s2'] = '';
top_t['s3'] = 'www';
top_t['s4'] = 'dl';
top_t['s5'] = '';


$(document).ready(function(){
 $("#formsearch").attr('accept-charset','UTF-8');

 $("#x1").mouseover(function(){
 	jQuery('#x1').attr('class','sa sa_hover');
 	$("#x2").show();
 });

 $("#x2 a").click(function(){
 	$("#s0").html($(this).html());
 	$("#formsearch").attr('action',topso_ac[$(this).attr("id")]);
 	$("#topbar_q").attr('name',top_sc[$(this).attr("id")]);
	jQuery("#topbar_type").val(top_t[jQuery(this).attr("id")]);
 	$("#x2").hide();
 });
  $("#x2").mouseout(function(){
  	jQuery('#x1').attr('class','sa');
 	$(this).hide();
 });
  $("#x1").mouseout(function(){
  	jQuery('#x1').attr('class','sa');
 	$("#x2").hide();
 });
  $("#x2").mouseover(function(){
 	$(this).show();
 });
});
function showmenu1()
{
	jQuery('#top_all').attr('class','top_downone1');
	jQuery('.top_downmenu1').show();
}
function hidemenu1()
{
	jQuery('.top_downmenu1').hide();
	jQuery('#top_all').attr('class','');
}
function showmenu2()
{
	jQuery('#top_edit').attr('class','top_downone2');
	jQuery('.top_downmenu2').show();
}
function hidemenu2()
{
	jQuery('.top_downmenu2').hide();
	jQuery('#top_edit').attr('class','');
}
function showmenu3()
{
	jQuery('#top_user').attr('class','top_downone3');
	jQuery('.top_downmenu3').show();
}
function hidemenu3()
{
	jQuery('.top_downmenu3').hide();
	jQuery('#top_user').attr('class','');
}
function showmenu4()
{
	jQuery('#top_code').attr('class','top_downone4');
	jQuery('.top_downmenu4').show();
}
function hidemenu4()
{
	jQuery('.top_downmenu4').hide();
	jQuery('#top_code').attr('class','');
}

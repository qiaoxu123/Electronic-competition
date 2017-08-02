
var t = null;
function selectTabContent(id_num, num)
{
	for(var i = 0;i <= 20;i++)
	{
		if(GetObj("M_" + id_num + i)){GetObj("M_" + id_num + i).className = '';}
		if(GetObj("C_" + id_num + i)){GetObj("C_" + id_num + i).style.display = 'none';}
	}
	if(GetObj("M_" + id_num + num)){GetObj("M_" + id_num + num).className = 'yixuan';}
	if(GetObj("C_" + id_num + num)){GetObj("C_" + id_num + num).style.display = 'block';}
	if(t != null && id_num == 'o') window.clearTimeout(t);
}

function AutoShow()
{
	for(var i = 0;i <= 10;i++)
	{
		if(GetObj("M_" + o + i)){GetObj("M_" + o + i).className = '';}
		if(GetObj("C_" + o + i)){GetObj("C_" + o + i).style.display = 'none';}
	}
	if(GetObj("M_" + o + c)){GetObj("M_" + o + c).className = 'yixuan';}
	if(GetObj("C_" + o + c)){GetObj("C_" + o + c).style.display = 'block';}
	c++;
	if(!GetObj("M_" + o + c)) c = 1;
	if(t != null) window.clearTimeout(t);
	t = window.setTimeout("AutoShow()", 2000);
}

function GetObj(objName)
{
	if(document.getElementById)
	{
		return eval('document.getElementById("' + objName + '")');
	}
	else
	{
		return eval('document.all.' + objName);
	}
}

function doFormLogin()
{
	return true;
}

function doFormSearch(frm)
{
	if(frm.keyword.value == "")
	{
		alert("请输入要查询的内容");
		return false;
	}
	var _radio = document.getElementsByName("stype");
	if(_radio[0].checked)
	{
		if(frm.keyword.value.length < 4)
		{
			alert("请至少输入4位芯片型号进行查询！");
			return false;
		}
		frm.method = "post";
		frm.action = "http://kucun.21ic.com/search_ic_new.php?action=search&part_number=" + encodeURIComponent(frm.keyword.value);
	}
	else if(_radio[1].checked)
	{
		frm.action = "http://www.21icsearch.com/s_" + frm.keyword.value + ".html";
	}
	else
	{
		frm.acceptCharset="UTF-8";
		document.charset="UTF-8";
		frm.action = "http://search.21ic.com/so.php";
	}
	return true;
}

function check_part_number(frm)
{
	if(frm.part_number.value.length<4)
	{
		alert("请至少输入4位芯片型号进行查询！");
		return false;
	}
	return true;
}
// 2010-3-9 17:29:05
function $(id) {return document.getElementById(id);}
function parsetag(cid, pid)
{
	if(!$(pid)) return;
	var havetag = false;
	var tagfindarray = new Array();
	var str = $(pid).innerHTML.replace(/(^|>)([^<]+)(?=<|$)/ig, function($1, $2, $3, $4) {
		for(i in tagarray) {
			if(tagarray[i] && $3.indexOf(tagarray[i]) != -1) {
				havetag = true;
				$3 = $3.replace(tagarray[i], '<h_ ' + i + '>');
				tmp = $3.replace(/&[a-z]*?<h_ \d+>[a-z]*?;/ig, '');
				if(tmp != $3) {
					$3 = tmp;
				} else {
					tagfindarray[i] = tagarray[i];
					tagarray[i] = '';
				}
			}
		}
		return $2 + $3;
    	});
    	if(havetag) {
		$(pid).innerHTML = str.replace(/<h_ (\d+)>/ig, function($1, $2) {
			return '<a href=\"http://www.21ic.com/ex/t.php?cid=' + cid + '&xh=' + tagfindarray[$2] + '\" title=\"' + tagcnarray[$2] + '\" class=\"ad_tag\" target=\"_blank\">' + tagfindarray[$2] + '</a>';
	    	});
	}
}
var ic_tc_tj = new function(){
    var LO  = location,
        D   = document,
        SC  = screen,
        W   = window,
        DT  = new Date(),
        M   = Math;
        DTL = D.title;

    var __sid,L;

    L = "https:" == D.location.protocol ? "https:": "http:";
    var  Aa = function(){
        this.h  =  LO.hostname;
        this.rh = function(){
            var d_a = this.h.split(".");
            var rh;
            if(d_a.length>2){
                rh = d_a[d_a.length-2]+'.'+d_a[d_a.length-1]
                if(rh=='com.cn'){
                    rh =  d_a[d_a.length-3]+'.'+d_a[d_a.length-2]+'.'+d_a[d_a.length-1]
                }    
            }else{
                rh = this.h;
            }
            return  rh;
        }
    }
    var aa= new Aa();
    var Ba = function(){
        this.width  = SC.width;
        this.height = SC.height;
    }
    var Ca = function(){
        this.agent = encodeURI(W.navigator.userAgent);
        this.refer = encodeURI(D.referrer);
        this.url = encodeURI(D.URL);

        this.title = D.title;
        this.cookie = D.cookie;
    }
    var Da = function(){
        this.time = DT.getTime();
    }
    var da = new Da();
    var ba = new Ba();
    var ca = new Ca();
    __sid =da.time.toString()+M.round(M.random()*256984).toString();
    var Ea = function(){
        this.gce = function(c_name){
            if(D.cookie.length>0){
                c_start = D.cookie.indexOf(c_name + "=");
                if(c_start!=-1){
                    c_start = c_start + c_name.length +1 ;
                    c_end = D.cookie.indexOf(';',c_start);
                    if(c_end==-1)c_end = D.cookie.length;
                    return unescape(D.cookie.substring(c_start,c_end));
                }
            }
            return '';
        }
        this.sce = function(c_name,value,exp){
            DT.setDate(DT.getDate()+exp);
            D.cookie = c_name+ "=" +escape(value)+((exp==null)?"":";expires="+DT.toGMTString())+";path=/;domain="+aa.rh();
        }
        this.cce = function(){
            if(this.gce('__fansid')==""){
                this.sce('__fansid',__sid,365*10);
            }else{
                __sid=this.gce("__fansid");
            }
            this.sce("__fanvt",DT.getTime());
        }
        this.gt = (this.gce('__fanvt'))?DT.getTime()-this.gce('__fanvt'):0;
    }
    var ea = new Ea();
    ea.cce();
    this.ic_st_ds=function (url,ti){
        var im = new Image();
        var a=[];
        a.push('h='+aa.h);
        a.push('sid='+ea.gce('__fansid'));
        a.push('at='+ca.agent);
        a.push('w='+ba.width);
        a.push('h='+ba.height);
        a.push('re='+ca.refer);
        a.push('url='+url);
        a.push('t='+ea.gt);
        a.push('asr='+ea.gce('aSr_auth'));
        if(aa.h=='www.21icsearch.com'&&typeof(ckun)!='undefined'){
            a.push('un='+encodeURI(ckun));
        }else{
            a.push('un='+encodeURI(ea.gce('www_username')));
        }
        a.push('bun='+encodeURI(ea.gce('bbs_username')));
        a.push('i_m_sg='+encodeURIComponent(ti));
        this.src = L+'//tj.21ic.com/sn.gif?'+a.join('&');
        im.src = this.src;
    }
    var g_tag = function(){
        var tag = D.getElementsByTagName('span');
        var tagname = '';
        for(var i=0;i<tag.length ;i++){
            if(tag[i].className=='tags'){
               var  tags = tag[i].getElementsByTagName('a');
                for(var j=0;j<tags.length;j++){
                   if(tagname!=''){
                        tagname = tagname+'||'+tags[j].innerHTML;
                   }else{
                        tagname= tags[j].innerHTML;
                   }
                }
            }
        }
        this.tagname = tagname;
    }
    var ga = function(){
        if(aa.h=='datasheet.21ic.com'){
            var tag = D.getElementsByTagName('table');
            for(var i=0;i<tag.length;i++){
                if(tag[i].className=='cont_table'||tag[i].className=='cont_right'){
                    var taga =  tag[i].getElementsByTagName('a');
                    for(var j=0;j<taga.length;j++){
                       var re = /\/manufacturer\/.*/g;
                        if(re.test(taga[j])){
                            DTL = DTL+":_:"+taga[j].innerHTML;
                        }
                    }
                }
            }
        }
    }
    new ga();
    var ha = function(){
        if(aa.h=='dl.21ic.com'){
            var tag = D.getElementsByTagName('div');
            for(var i=0;i<tag.length;i++){
                if(tag[i].className=='dl_location'){
                    var taga =  tag[i].getElementsByTagName('a');
                    for(var j=0;j<taga.length;j++){
                        if(j==1||j==2){
                            DTL = DTL+":_:"+taga[j].innerHTML;
                        }
                    }
                    break;
                }
            }
            var re = /\/ebook.*/g;
            if(re.test(LO.href)){
                for(var i=0;i<tag.length;i++){
                    if(tag[i].className=='ebookcont'){
                        var taga =  tag[i].getElementsByTagName('a');
                        for(var j=0;j<taga.length;j++){
                            if(j==1){
                                DTL = DTL+":_:"+taga[j].innerHTML;
                            }
                        }
                        break;
                    }
                }
            }
        }
    }
    new ha();
    var ia = function(){
        if(aa.h=='edu.21ic.com'){
            var tag = D.getElementsByTagName('div');
            for(var i=0;i<tag.length;i++){
                if(tag[i].className=='location_ongray'||tag[i].className=='location'){
                    var taga =  tag[i].getElementsByTagName('a');
                    for(var j=0;j<taga.length;j++){
                        if(j==1||j==2){
                            DTL = DTL+":_:"+taga[j].innerHTML;
                        }
                    }
                }
            }
        }
    }
    new ia();
    var ja = function(){
        if(aa.h=='www.21icsearch.com'){
            var tag = D.getElementsByTagName('div');
            for(var i=0;i<tag.length;i++){
                if(tag[i].className=='position'){
                    var taga =  tag[i].getElementsByTagName('a');
                    for(var j=0;j<taga.length;j++){
                        if(j==1||j==2){
                            DTL = DTL+":_:"+taga[j].innerHTML;
                        }
                    }
                }
            }
            document.write(unescape("%3Cscript src='http://tj.21ic.com/ck.php' type='text/javascript'%3E%3C/script%3E"));

        }
        if(aa.h=='www.21ic.com.cn'){
            document.write(unescape("%3Cscript src='http://tj.21ic.com/ck.php' type='text/javascript'%3E%3C/script%3E"));
        }
     }
    new ja();
    function Fa(){
        var im = new Image();
        var a=[];
        a.push('h='+aa.h);
        a.push('sid='+ea.gce('__fansid'));
        a.push('at='+ca.agent);
        a.push('w='+ba.width);
        a.push('h='+ba.height);
        a.push('re='+ca.refer);
        a.push('url='+ca.url);
        a.push('t='+ea.gt);
        a.push('asr='+ea.gce('aSr_auth'));
        if((aa.h=='www.21icsearch.com'|| aa.h=='www.21ic.com.cn') && typeof(ckun)!='undefined'){
            a.push('un='+encodeURI(ckun));
        }else{
            a.push('un='+encodeURI(ea.gce('www_username')));
        }
        a.push('bun='+encodeURI(ea.gce('bbs_username')));

        if(aa.h=='www.21ic.com'){
            var tag = new g_tag();
            tag = tag.tagname;
            DTL = DTL+":_:"+tag;
        }
        if(aa.h=='bbs.21ic.com'&&typeof(fid)!='undefined'){
            if(typeof(tid)!='undefined'){
                DTL = DTL+":_:"+tid+'||'+fid;
            }else{
                DTL = DTL+":_:0||"+fid;
            }
        }
        a.push('i_m_sg='+encodeURIComponent(DTL));
        this.src = L+'//tj.21ic.com/sn.gif?'+a.join('&');
        im.src = this.src;
    }
    if(aa.h=='www.21icsearch.com'||aa.h=='www.21ic.com.cn'){
        setTimeout(function(){ Fa();},500);
    }else{
        Fa();
    }

};



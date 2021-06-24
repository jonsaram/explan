// LNB
$(function(){
	$(".lnbTree li a").click(function(){
		$(this).addClass("current");
		$(".lnbTree li a").not(this).removeClass("current");
	});
});

//snb collapse
$(function(){
	$(".snb_collapsed .nav_col").click(function(){
		$(this).hide();
		$(this).next().show();
		$(this).parent().css("left","0");
		$("#LNB").hide();
		$("#contents .gridbox").css("width","99.9%");
		
	});
	$(".snb_collapsed .nav_exp").click(function(){
		$(this).hide();
		$(this).prev().show();
		$(this).parent().css("left","173px");
		$("#LNB").show();
		$("#contents .gridbox").css("width","99.9%");
	});
});

// form 드롭다운
$(function(){
	$(".ico_dropdown, .ico_sdwrap").click(function(){
		$(this).next().toggle();
		$(".ico_dropdown, .ico_sdwrap").not(this).next().hide();
	});
});

// seach toggle
$(function(){
	$(".hide_srch .btn_srch_close").click(function(){
		$(this).hide();
		$(".srch_wrap").hide();
		$(".hide_srch .btn_srch_view").show();
		$(".hide_srch").css("margin-top", "0");
	});
	$(".hide_srch .btn_srch_view").click(function(){
		$(this).hide();
		$(".srch_wrap").show();
		$(".hide_srch .btn_srch_close").show();
		$(".hide_srch").css("margin-top", "-16px");
	});
});

// tab
$(function(){
	$(".tab ul li").click(function(){
		$(this).parent().parent().parent().find(".tab_cont").hide();
		$(this).parent().parent().parent().find(".tab_cont").eq($(this).index()).show();
		$(this).parent().parent().find("li").removeClass("on");
		$(this).addClass("on");
	});
});

// popup resize
function win_resize(){
	$(document).attr("overflow-x","hidden");
	$(document).attr("overflow-y","hidden");

	var wrapWidth = $("#pop_wrap").outerWidth();
	var wrapHeight = $("#pop_wrap").outerHeight();
	var w1 = $(window).width();
	var h1 = $(window).height();

	window.resizeBy(wrapWidth- w1, 0);
	window.resizeBy(0, wrapHeight - h1);

	if ($(window).height() != $("#pop_wrap").outerHeight()){
	setTimeout(function(){win_resize()}, 500);
	}
}

// open popup
var win = null;
function NewWin(mypage,myname,w,h,scroll){
	LeftPosition = (screen.width) ? (screen.width-w)/2 : 0;
	TopPosition = (screen.height) ? (screen.height-h)/2 : 0;
	settings ='height='+h+',width='+w+',top='+TopPosition+',left='+LeftPosition+',scrollbars='+scroll+',resizable=no'
	win = window.open(mypage,myname,settings);
}

// Layer Popup
$(function(){
	$(".open_layer").click(function(){
		$(".layer_pop_wrap").show();
		
		var $layer = $(".layer_pop");
		var left = (($(window).width() - $layer.width()) / 2);
		var top = (($(window).height() - $layer.height()) / 2) ;
		$layer.css({"left":left,"top":top});
		
	});
});

// msg box
$(function(){
	var msgWidth = $(".msg_wrap").width() /2;
	var msgHeight = $(".msg_wrap").height() /2;
	$(".msg_wrap").css({"margin-left":-msgWidth,"margin-top":-msgHeight});
});

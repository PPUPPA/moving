$(function(){
  // SRCH INPUT
  $(".board-head .srch-box .btn-del").click(function(){
		$(this).prev(".inp").val("");
		$(this).hide();
		$(this).next(".btn-srch").click();
	});

	$(".board-head .srch-box .inp").on("input", function(){
		if($(this).val() == ""){
			$(this).siblings(".btn-del").hide();
		}else{
			$(this).siblings(".btn-del").show();
		}
	});
});
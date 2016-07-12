
function onLoad()
{
	var navmove = 200;
	
	$('#navigation').mouseenter(function()
	{
		$('#navigation').animate(
		{
			"width" : "+="+navmove+"px"
		},'fast');
		
		
		$('.navigation-element').css(
		{
			"visibility" : "visible"
		});
		
	});
	
	$('#navigation').mouseleave(function()
	{
		$('#navigation').animate(
		{
			"width" : "-="+navmove+"px"
		},'fast'); 
		
		$('.navigation-element').css(
		{
			"visibility" : "hidden"
		});
		
	});
	
}
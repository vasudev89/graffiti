
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
	
	/////////////
	
	var chatmove = 260;
	
	var chatmovestatus = true;
	
	$('#btn-chat-move').click(function()
	{
		if(chatmovestatus)
		{
			$('#chat').animate(
			{
				"width" : "+="+chatmove+"px"
			},'fast');
			
			$('#btn-chat-move').html(">");
		}
		else
		{
			$('#chat').animate(
			{
				"width" : "-="+chatmove+"px"
			},'fast');
			
			$('#btn-chat-move').html("<");
		}
		
		chatmovestatus = !chatmovestatus;
						
	});
		
}
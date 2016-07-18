function resizing()
{
	document.getElementById("body_div").style.height = (document.getElementById("index_div_row").offsetHeight + 100) + 'px';
	$('#body_div').height( $('#body_div').height()<$(window).height()? $(window).height() : $('#body_div').height() );
	
	window.addEventListener('resize', function()
	{
		document.getElementById("body_div").style.height = (document.getElementById("index_div_row").offsetHeight + 100) + 'px';
		$('#body_div').height( $('#body_div').height()<$(window).height()? $(window).height() : $('#body_div').height() );
	}, false);
}

$('#index_div_row').bind('change', function(){
	
	window.setTimeout(function()
	{
		document.getElementById("body_div").style.height = (document.getElementById("index_div_row").offsetHeight + 100) + 'px'; 
	}, 200);
	
});
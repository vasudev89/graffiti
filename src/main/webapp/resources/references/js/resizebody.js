function resizing()
{
	document.getElementById("body_div").style.height = (document.getElementById("index_div_row").offsetHeight + 100) + 'px';
			
	window.addEventListener('resize', function()
	{
		//alert('Hi');
		document.getElementById("body_div").style.height = (document.getElementById("index_div_row").offsetHeight + 100) + 'px';
	}, false);
}

$('#index_div_row').bind('change', function(){
	
	window.setTimeout(function()
	{
		document.getElementById("body_div").style.height = (document.getElementById("index_div_row").offsetHeight + 100) + 'px'; 
	}, 200);
	
});
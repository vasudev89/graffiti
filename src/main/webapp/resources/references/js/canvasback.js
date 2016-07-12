	function resize_canvas(){
        canvas = document.getElementById("myCanvas");
        canvas.style.width = document.getElementById("AboutUsDiv").offsetWidth + 'px';
		canvas.style.height = document.getElementById("AboutUsDiv").offsetHeight + 'px';
		canvas.style.left = document.getElementById("AboutUsDiv").offsetLeft + 'px';
    }
	
	//var colors = ["rgb(128,148,0)","rgb(100,0,0)","rgb(255,199,6)","rgb(184,30,14)","rgb(17,181,181)"];
	
	var colors = ["rgb(255,255,255)","rgb(206,207,212)"];
	var index = 0;

	var linecols = ["rgb(150,134,179)","rgb(100,0,0)","rgb(255,199,6)","rgb(184,30,14)","rgb(17,181,181)"];
	var linecolindex = 0;
	
	window.onload = draw;
	
	window.addEventListener('resize', resize_canvas, false);
	
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
	
	function draw()
	{
		resize_canvas();
		
		onLoad();
		
		var canvas = document.getElementById('myCanvas');
		var context = canvas.getContext('2d');
	
		//console.log( document.getElementById("AboutUsDiv").offsetWidth );
		//console.log( document.getElementById("AboutUsDiv").offsetHeight );
		
		canvas.style.width = document.getElementById("AboutUsDiv").offsetWidth + 'px';
		canvas.style.height = document.getElementById("AboutUsDiv").offsetHeight + 'px';
		canvas.style.left = document.getElementById("AboutUsDiv").offsetLeft + 'px';
		
		var particles=[];
		
		particle = function()
		{
			this.arch = { index: -1 , x : Math.random() * canvas.width/1 , y : Math.random() * canvas.height/1 , col : colors[index+1] , radius : 1+Math.random()*5 , targetX : Math.random() * canvas.width/1 , targetY : Math.random() * canvas.height/1 };
		}
		
		for( i = 0 ; i < 50 ; i++ )
			particles.push( new particle() );
		
		for( i = 0 ; i < particles.length ; i++ )
		{
			particles[i].arch.index = i;			
		}	
			
		setInterval(function()
		{
			context.fillStyle = colors[index];
		    context.fillRect(0,0,canvas.width, canvas.height);
			
			for( i = 0 ; i < particles.length-1 ; i++ )
			{
				for( j = i+1 ; j < particles.length ; j+=1 )
				{
					context.beginPath();
					context.moveTo(particles[i].arch.x,particles[i].arch.y);
					context.lineTo(particles[j].arch.x,particles[j].arch.y);
					context.strokeStyle = linecols[linecolindex];
					//linecolindex = (linecolindex + 1)%linecols.length;
					
					context.lineWidth=0.3;
					
					context.stroke();
				}
			}
			
			for( i = 0 ; i < particles.length ; i++ )
			{
				context.beginPath();
				
				context.shadowBlur = blur;
			    context.shadowOffsetX = 1;
			    context.shadowOffsetY = 1;

			    context.fillStyle=particles[i].arch.col;
			    //context.shadowColor="#000000";
				
				context.arc( particles[i].arch.x , particles[i].arch.y, particles[i].arch.radius, 0, Math.PI*2, true); 
				context.closePath();
				context.fill();
			}
			
			for( i = 0 ; i < particles.length ; i++ )
			{	
			    if( particles[i].arch.x != particles[i].arch.targetX && particles[i].arch.y != particles[i].arch.targetY )
				{
					context.beginPath();
					context.fillStyle= particles[i].arch.col ;
					
					disX = (particles[i].arch.targetX - particles[i].arch.x );
					disY = (particles[i].arch.targetY - particles[i].arch.y );
					
					particles[i].arch.x += (disX > 0)?0.2:-0.2;
					particles[i].arch.y += (disY > 0)?0.2:-0.2;
					
					context.arc( particles[i].arch.x , particles[i].arch.y, particles[i].arch.radius, 0, Math.PI*2, true); 
					context.closePath();
					context.fill();
				}
				else
				{
					/*if( i < particles.length / 4 )
					{
						particles[i].arch.targetX = parseInt( 0 + Math.random() * canvas.width / 4 * 1 );
						//particles[i].arch.targetY = parseInt( 0 + Math.random() * canvas.height * 1 )
					}
					else if( i >= particles.length / 4 && i < particles.length / 2 )
					{
						particles[i].arch.targetX = parseInt( canvas.width/4 + Math.random() * canvas.width / 4 * 1 );
						//particles[i].arch.targetY = parseInt( 0 + Math.random() * canvas.height * 1 )
					}
					else if( i >= particles.length / 2 && i < 3 * particles.length / 4 )
					{
						particles[i].arch.targetX = parseInt( canvas.width/2 + Math.random() * canvas.width / 4 * 1 );
						//particles[i].arch.targetY = parseInt( 0 + Math.random() * canvas.height * 1 )
					}
					else
					{
						particles[i].arch.targetX = parseInt( 3 * canvas.width / 4 + Math.random() * canvas.width / 4 * 1 );
						//particles[i].arch.targetY = parseInt( 0 + Math.random() * canvas.height * 1 )
					}
					
					if( Math.random() < 0.5 )
						particles[i].arch.targetY = parseInt( 0 + Math.random() * canvas.height / 16 * 1 )
					else
						particles[i].arch.targetY = parseInt( 7 * canvas.height / 8 + Math.random() * canvas.height / 8 * 1 )*/
					
					particles[i].arch.targetX = parseInt( 0 + Math.random() * canvas.width * 1 );
					particles[i].arch.targetY = parseInt( 0 + Math.random() * canvas.height * 1 );
					
					//console.log(particles[i]);
				}
			}
			
		}, 30 );
		
		//draw();
			
	}
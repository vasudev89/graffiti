function ProgressObject()
{
	this.JSON = {Index:"",X:"",Y:"",ParentElement:"",Size:"", Ratio:"",Opacity:"",Angle:"",Mode:"",ShowText:"Loading"};

	this.GetX =  function(){ return this.JSON.X };
	this.SetX =  function( input ){ this.JSON.X = input };

	this.GetY =  function(){ return this.JSON.Y };
	this.SetY =  function( input ){ this.JSON.Y = input };

	this.GetParentElement =  function(){ return this.JSON.ParentElement };
	this.SetParentElement =  function( input ){ this.JSON.ParentElement = input };

	this.GetIndex =  function(){ return this.JSON.Index };
	this.SetIndex =  function( input ){ this.JSON.Index = input };

	this.GetMode =  function(){ return this.JSON.Mode };
	this.SetMode =  function( input ){ this.JSON.Mode = input };

	this.GetSize =  function(){ return this.JSON.Size };
	this.SetSize =  function( input ){ this.JSON.Size = input };

	this.GetRatio =  function(){ return this.JSON.Ratio };
	this.SetRatio =  function( input ){ this.JSON.Ratio = input };

	this.GetOpacity =  function(){ return this.JSON.Opacity };
	this.SetOpacity =  function(input){ this.JSON.Opacity = input };

	this.GetAngle =  function(){ return this.JSON.Angle };
	this.SetAngle =  function(input){ this.JSON.Angle = input };

	this.Constructor = function( Index, X , Y , ParentElement , Size, Ratio, Opacity , Angle, Mode)
	{
		this.SetIndex( Index );
		this.SetX( X );
		this.SetY( Y );
		this.SetParentElement( ParentElement );
		this.SetSize( Size );
		this.SetRatio( Ratio );
		this.SetOpacity( Opacity );
		this.SetAngle( Angle );
		this.SetMode( Mode );
		
		this.Draw(this);
	}

	this.SetIndeterminateCounter = 0;

	this.timer = null;

	this.SwitchFlag = function( flag )
	{

		if(this.JSON.Mode == "Indeterminate")
		{

			if(flag==true)
			{
				myObject = this;

				this.timer = setInterval(function()
				{
					var circlecol = $( "#"+myObject.GetParentElement()+"" ).css("background-color");
					circlecol = myObject.ColWithFactor( myObject , circlecol , 25 );
					
					var circlecolIndeterminate = "rgb(255,255,255)";
					circlecolIndeterminate = myObject.ColWithFactor( myObject , circlecolIndeterminate , 0 );
					
					$( "#Progress_1"+myObject.GetIndex()+"" ).css( {"background-color":circlecol} );
					$( "#Progress_2"+myObject.GetIndex()+"" ).css( {"background-color":circlecol} );
					$( "#Progress_3"+myObject.GetIndex()+"" ).css( {"background-color":circlecol} );

					myObject.SetIndeterminateCounter = (myObject.SetIndeterminateCounter)%3 +1;

					$( "#Progress_"+ myObject.SetIndeterminateCounter +myObject.GetIndex()+"" ).css( {"background-color":circlecolIndeterminate} );

				},500);
			}
			else
			{
				clearInterval(this.timer);

				myObject = this;
				
				var circlecolIndeterminate = $( "#"+myObject.GetParentElement()+"" ).css("background-color");
				circlecolIndeterminate = myObject.ColWithFactor( myObject , circlecolIndeterminate , 25 );
				
				$( "#Progress_1"+myObject.GetIndex()+"" ).css( {"background-color":circlecolIndeterminate} );
				$( "#Progress_2"+myObject.GetIndex()+"" ).css( {"background-color":circlecolIndeterminate} );
				$( "#Progress_3"+myObject.GetIndex()+"" ).css( {"background-color":circlecolIndeterminate} );
			}

		}
	}

	this.ChangeBarVal = function( input )
	{
		myObject = this;
		if(myObject.JSON.Mode == "Determinate")
		$( "#Progress"+myObject.GetIndex()+"" ).val(input);
	}

	this.ColWithFactor = function( myObject , col , fact )
	{
		colsample = col.substring( col.indexOf('(') + 1 , col.indexOf(')') ).split(",");
		
		colsample[0] = ( parseInt( colsample[0] ) - fact < 0 ) ? 0 : parseInt( colsample[0] ) - fact;
		colsample[1] = ( parseInt( colsample[1] ) - fact < 0 ) ? 0 : parseInt( colsample[1] ) - fact;
		colsample[2] = ( parseInt( colsample[2] ) - fact < 0 ) ? 0 : parseInt( colsample[2] ) - fact;
		
		colsample = "rgb("+ colsample[0] +", "+ colsample[1] +", "+ colsample[2] +")";
		
		return colsample;
	}
	
	this.Draw = function(myObject)
	{
		var col = $( "#"+myObject.GetParentElement()+"" ).css("background-color");
		col = myObject.ColWithFactor( myObject , col , 20 );

		var circlecol = $( "#"+myObject.GetParentElement()+"" ).css("background-color");
		circlecol = myObject.ColWithFactor( myObject , circlecol , 25 );
		
		myObject.Base_Div = 	
					"<div id='Base_Div"+myObject.GetIndex()+"' style='position: absolute; top: "+myObject.GetY()+"; right: "+myObject.GetX()+"; width: "+myObject.GetSize()+"px; height: "+myObject.GetSize()/myObject.GetRatio()+"px; opacity: "+myObject.GetOpacity()+"; transform: ("+myObject.GetAngle()+"deg); border: 0px solid rgb(242,61,4); background-color: transparent;z-index:5;border-radius:0px; box-shadow:1px 1px 10px "+col+";'></div>"

		$( "#"+myObject.GetParentElement()+"" ).append(myObject.Base_Div);

		var k = myObject.GetSize()/myObject.GetRatio();
		var l = myObject.GetSize();



		if( myObject.GetMode() == "Determinate" )
		{
			myObject.Progress = "<progress id='Progress"+myObject.GetIndex()+"' value='0' min='0' max='100'></progress>";
			$( "#Base_Div"+myObject.GetIndex()+"" ).append(myObject.Progress);
			$( "#Progress"+myObject.GetIndex()+"" ).css( {"position":"absolute","top":"30%","right":"10%","height":"40%","width":"80%","background-color": "transparent","border":"0px solid rgb(145,141,2)", "color": "#333333","font-size":"12px","border-radius":"5px","font-weight":"none","text-align":"center","transform":"rotate(0deg)","box-shadow":"0px 0px 0px #999999"});

			myObject.Progress_Label = "<label id='Progress_Label"+myObject.GetIndex()+"'>"+myObject.JSON.ShowText+"</label>";
			$( "#Base_Div"+myObject.GetIndex()+"" ).append(myObject.Progress_Label);
			$( "#Progress_Label"+myObject.GetIndex()+"" ).css( {"position":"absolute","height":"100%","width":"100%","background-color": "transparent","border":"0px solid rgb(145,141,2)", "color": "rgb(128,0,0)","font-size":"12px","border-radius":"5px","font-weight":"none","text-align":"center","transform":"rotate(0deg)","box-shadow":"0px 0px 0px #999999","line-height":k+"px", "margin-left":"auto", "margin-right":"auto"});

		}
		else if( myObject.GetMode() == "Indeterminate" )
		{
			myObject.Progress_1 = "<div id='Progress_1"+myObject.GetIndex()+"'></div>";
			$( "#Base_Div"+myObject.GetIndex()+"" ).append(myObject.Progress_1);
			$( "#Progress_1"+myObject.GetIndex()+"" ).css( {"position":"absolute","top":"30%","left":(0.1*l)+"px","height":"40%","width":0.4*k+"px","background-color": circlecol,"border":"0px solid rgb(145,141,2)", "color": "#333333","font-size":"12px","border-radius":"100%","font-weight":"none","text-align":"center","transform":"rotate(0deg)","box-shadow":"0px 0px 0px #999999"});

			myObject.Progress_2 = "<div id='Progress_2"+myObject.GetIndex()+"'></div>";
			$( "#Base_Div"+myObject.GetIndex()+"" ).append(myObject.Progress_2);
			$( "#Progress_2"+myObject.GetIndex()+"" ).css( {"position":"absolute","top":"30%","left":(0.1*l+0.4*k+0.1*l)+"px","height":"40%","width":0.4*k+"px","background-color": circlecol,"border":"0px solid rgb(145,141,2)", "color": "#333333","font-size":"12px","border-radius":"100%","font-weight":"none","text-align":"center","transform":"rotate(0deg)","box-shadow":"0px 0px 0px #999999"});

			myObject.Progress_3 = "<div id='Progress_3"+myObject.GetIndex()+"'></div>";
			$( "#Base_Div"+myObject.GetIndex()+"" ).append(myObject.Progress_3);
			$( "#Progress_3"+myObject.GetIndex()+"" ).css( {"position":"absolute","top":"30%","left":(0.1*l+0.4*k+0.1*l+0.4*k+0.1*l)+"px","height":"40%","width":0.4*k+"px","background-color": circlecol,"border":"0px solid rgb(145,141,2)", "color": "#333333","font-size":"12px","border-radius":"100%","font-weight":"none","text-align":"center","transform":"rotate(0deg)","box-shadow":"0px 0px 0px #999999"});

			$( "#Base_Div"+myObject.GetIndex()+"" ).css({"width":(0.1*l+0.4*k+0.1*l+0.4*k+0.1*l+0.4*k+0.1*l)+"px"});
			//width not set in json after updation


		}
		
					
		myObject.EventHandlers(myObject);
	}


	this.EventHandlers = function(myObject)
	{
		
	}
}
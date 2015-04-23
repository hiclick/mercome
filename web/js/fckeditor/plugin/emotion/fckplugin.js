/*
 * 表情插件
 * 2008-01-02
 * maoxiang@gmail.com
 */

//FCKConfig.EmotionPath	          = FCKConfig.BasePath + 'images/smiley/msn/' ;
//FCKConfig.EmotionImages	        = ['regular_smile.gif','sad_smile.gif','wink_smile.gif','teeth_smile.gif','confused_smile.gif','tounge_smile.gif','embaressed_smile.gif','omg_smile.gif','whatchutalkingabout_smile.gif','angry_smile.gif','angel_smile.gif','shades_smile.gif','devil_smile.gif','cry_smile.gif','lightbulb.gif','thumbs_down.gif','thumbs_up.gif','heart.gif','broken_heart.gif','kiss.gif','envelope.gif'] ;
//FCKConfig.EmotionColumns        = 8 ;

//表情插件
var FCKEmotionCommand = function()
{
	try{
	var oWindow ;
 	if ( FCKBrowserInfo.IsIE )
		oWindow = window ;
	else if ( FCK.ToolbarSet && FCK.ToolbarSet._IFrame )
		oWindow = FCKTools.GetElementWindow( FCK.ToolbarSet._IFrame ) ;
	else
		oWindow = window.parent ;
	
	this._Panel = new FCKPanel( oWindow ) ;

	this._Panel.AppendStyleSheet( FCKConfig.SkinPath + 'fck_editor.css' ) ;
	this._Panel.MainNode.className = 'FCK_Panel' ;
	this._CreatePanelBody( this._Panel.Document, this._Panel.MainNode ) ;
	

	FCKTools.DisableSelection( this._Panel.Document.body ) ;
}catch(e){
	alert(e.message);
}
}

FCKEmotionCommand.prototype.Execute = function( panelX, panelY, relElement )
{
	// Show the Color Panel at the desired position.
	this._Panel.Show( panelX, panelY, relElement ) ;
}

FCKEmotionCommand.prototype.GetState = function()
{
	return FCK_TRISTATE_OFF ;
}

function FCKEmotionCommand_OnMouseOver()
{
	this.className = 'ColorSelected' ;
}

function FCKEmotionCommand_OnMouseOut()
{
	this.className = 'ColorDeselected' ;
}

function FCKEmotionCommand_OnClick( ev, command, url )
{
	this.className = 'ColorDeselected' ;
	
	FCKUndo.SaveUndoStep() ;
  url = url.replace(/'/g, "\\'" )
  
	var oImg = FCK.InsertElement( 'img' ) ;
	oImg.src = url ;
	oImg.setAttribute( '_fcksavedurl', url ) ;

	command._Panel.Hide() ;
}


FCKEmotionCommand.prototype._CreatePanelBody = function( targetDocument, targetDiv )
{
	function CreateSelectionDiv()
	{
		var oDiv = targetDocument.createElement( "DIV" ) ;
		oDiv.className = 'ColorDeselected' ;
		FCKTools.AddEventListenerEx( oDiv, 'mouseover', FCKEmotionCommand_OnMouseOver ) ;
		FCKTools.AddEventListenerEx( oDiv, 'mouseout', FCKEmotionCommand_OnMouseOut ) ;

		return oDiv ;
	}

	// Create the Table that will hold all colors.
	var oTable = targetDiv.appendChild( targetDocument.createElement( "TABLE" ) ) ;
	oTable.className = 'ForceBaseFont' ;		// Firefox 1.5 Bug.
	oTable.style.tableLayout = 'fixed' ;
	oTable.cellPadding = 0 ;
	oTable.cellSpacing = 0 ;
	oTable.border = 0 ;
	oTable.width = FCKConfig.EmotionColumns * 32 ;


	// Dirty hack for Opera, Safari and Firefox 3.
	//if ( !FCKBrowserInfo.IsIE )
	//	oDiv.style.width = '96%' ;
		
	var aImages = FCKConfig.EmotionImages;
	
	var iCounter = 0 ;
	while ( iCounter < aImages.length )
	{
		var oRow = oTable.insertRow(-1) ;

		for ( var i = 0 ; i < FCKConfig.EmotionColumns ; i++, iCounter++ )
		{
			// The div will be created even if no more colors are available.
			// Extra divs will be hidden later in the code. (#1597)
			
			var oDiv = oRow.insertCell(-1).appendChild( CreateSelectionDiv() ) ;
			if ( iCounter < aImages.length )
			{
				var imageUrl = FCKConfig.EmotionPath + aImages[iCounter];
				
				oDiv.innerHTML = '<div class="ColorBoxBorder" ><img width="24" height="24" src="'+imageUrl+'"/></div>' ;
				FCKTools.AddEventListenerEx( oDiv, 'click', FCKEmotionCommand_OnClick, [ this, imageUrl ] ) ; 
			}else{
				oDiv.innerHTML = '<div class="ColorBoxBorder" >'+0+'</div>' ;
			  oDiv.style.visibility = 'hidden' ;
		  }
			//alert(oDiv.innerHTML); 
		}
	}	

	// Dirty hack for Opera, Safari and Firefox 3.
	//if ( !FCKBrowserInfo.IsIE )
	//	oDiv.style.width = '96%' ;
 
}
FCKLang['FCKEmotionCommand']		= '选择表情' ;

FCKCommands.RegisterCommand( 'Emotion'	, new FCKEmotionCommand() ) ;

FCKToolbarItems.RegisterItem( 'Emotion'	, new FCKToolbarPanelButton( 'Emotion', FCKLang['FCKEmotionCommand'], null, null, 41 )) ;
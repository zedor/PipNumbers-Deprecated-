package  {
	
	import flash.display.MovieClip;
	
	import ValveLib.Globals;
	import ValveLib.ResizeManager;
	
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.Font;
	
	import flash.geom.Point;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	//=====================================================
	//
	// changes ability level indicators (pips) with numbers
	//
	//========================================= made by zed
	
	public class PipNumbers extends MovieClip {
		
		
		public var heroEnt:int = -1;
		public var splCount:int = 8;
		// volvo stuff
		public var gameAPI:Object;
		public var globals:Object;
		public var elementName:String;
		
		// holding our textfields
		public var pips:Object = new Object;
		
		// our timer.. at the start the dota_ability_changed gets called a LOT, so this dun fixed it
		public var timer:Timer = new Timer(250, 1);
		// our timer for pip removal on hero level up.. there's a delay to showing it so we can't hide the pip instantly
		public var hlTimer:Timer = new Timer(150, 1);
		
		public function PipNumbers() {
		}
		
		// gets called by the event, handles our ability changes
		public function abilityChanged( e:TimerEvent ) {
			// the owner of this UI
			var pID = this.globals.Players.GetLocalPlayer();
			
			// check if exists
			if( pID != null ) var hero = this.globals.Players.GetPlayerHeroEntityIndex(pID);
			
			// check if exists
			if( hero != null ) {
				
				splCount = globals.Entities.GetAbilityCount(hero);
				// iterate through the abilities
				var i = 0;
				while (i < splCount) {
					
					// assign the ability | GetAbility( entity, slot)
					var ability = this.globals.Entities.GetAbility( hero, i );
					//trace("[", i, "/", splCount ,"] ", globals.Abilities.GetAbilityName( ability ));
					
					// checks if ability is null, is attribute bonus (no pip needed for that), is empty or is hidden
					if( ability != null && this.globals.Abilities.GetAbilityName(ability)!="attribute_bonus" && this.globals.Abilities.GetAbilityName(ability)!="" && !globals.Abilities.IsHidden(ability) ) {
						//additional check if the ability has an AbilitySpecial "pip_show"
						if( globals.Abilities.GetLevelSpecialValueFor( ability, 'pip_show', globals.Abilities.GetLevel(ability) ) != 0 ) {
						
							// if the pip exists, it updates the text and positioning, otherwise it creates a new one
							if( pips[i] != null ) updatePip(i, ability);
								else pips[i] = createNewPip(i, ability);
						}
							
					// if the ability is null, attr_bonus or empty, clear the pip
					} else if( pips[i] != null ) pips[i] = null;
					i++;
				}
			}
			hideOrSeek();
		}
		
		public function gainedLevel( e:TimerEvent ) {
			// the owner of this UI
			var pID = this.globals.Players.GetLocalPlayer();
			
			// check if the owner exists
			if( pID != null ) {
				var i = 0;
					while (i < splCount) {
						// hide the valve pips
						if( globals.Loader_actionpanel.movieClip.middle.abilities["abilityLevelPips"+i]!= null )
							if( this.globals.Loader_actionpanel.movieClip.middle.abilities["abilityLevelPips"+i].visible ) this.globals.Loader_actionpanel.movieClip.middle.abilities["abilityLevelPips"+i].visible = false;
						i++;
					}
			}
			hideOrSeek();
		}
		
		public function updatePip( slot:int, ent:* ) {
			
			// some text formatting
			var txFormat:TextFormat = new TextFormat;
			txFormat.color = 0xFFFFC0;
			txFormat.size = 26;
			txFormat.font = "$TextFontBold";
			txFormat.align = "center";
			pips[slot].getChildByName("txtField").multiline = false;
			pips[slot].getChildByName("txtField").wordWrap = false;
			var curLevel:Number = globals.Abilities.GetLevel(ent);
			var maxLevel:Number = globals.Abilities.GetMaxLevel(ent);
			// check for overrides in AbilitySpecial
			if( globals.Abilities.GetLevelSpecialValueFor(ent, 'pip_current', globals.Abilities.GetLevel(ent)) ) curLevel = globals.Abilities.GetLevelSpecialValueFor(ent, 'pip_current', globals.Abilities.GetLevel(ent));
			if( globals.Abilities.GetLevelSpecialValueFor(ent, 'pip_max', globals.Abilities.GetLevel(ent)) ) maxLevel = globals.Abilities.GetLevelSpecialValueFor(ent, 'pip_max', globals.Abilities.GetLevel(ent));
			pips[slot].getChildByName("txtField").text = curLevel.toString() + "/" + maxLevel.toString();
			pips[slot].getChildByName("txtField").selectable = false;
			pips[slot].getChildByName("txtField").setTextFormat(txFormat);
			
			// position our pip
			var pnt:Point = globals.Loader_actionpanel.movieClip.middle.abilities["abilityLevelPips"+slot].localToGlobal(new Point(0,0));
			var pnt2:Point = globals.Loader_actionpanel.movieClip.middle.abilities["Ability"+slot].localToGlobal(new Point(0,0));
			//pips[slot].x = pnt2.x + ((globals.Loader_actionpanel.movieClip.middle.abilities["Ability"+slot].width*globals.Loader_actionpanel.movieClip.middle.abilities["Ability"+slot].scaleX*globals.Loader_actionpanel.movieClip.middle.scaleX)/2);
			pips[slot].x = pnt2.x + ((115.3*0.452*globals.Loader_actionpanel.movieClip.middle.scaleX)/2);
			pips[slot].y = pnt.y - (5*pips[slot].scaleY);
			
			
			// hide the volvo pips
			this.globals.Loader_actionpanel.movieClip.middle.abilities["abilityLevelPips"+slot].visible = false;
		}
		
		public function createNewPip( slot:int, ent:* ):MovieClip {
			
			// holds our textfield, its a new pip[slot]
			var temp:MovieClip = new MovieClip;
			
			// some text formatting
			var txFormat:TextFormat = new TextFormat;
			var txField:TextField = new TextField;
			txFormat.color = 0xFFFFC0;
			txFormat.size = 26;
			txFormat.font = "$TextFontBold";
			txFormat.align = "center";
			txFormat.leftMargin = 1;
			txFormat.rightMargin = 1;
			txField.width = 0;
			txField.height = 0;
			txField.autoSize = "center";
			txField.multiline = false;
			txField.wordWrap = false;
			txField.text = globals.Abilities.GetLevel(ent) + "/" + globals.Abilities.GetMaxLevel(ent);
			txField.selectable = false;
			//txField.background = true;
			//txField.backgroundColor = 0x000000;
			//txField.border = true;
			//txField.borderColor = 0xFFFFFF;
			txField.setTextFormat(txFormat);
			
			// hide the volvo pips
			this.globals.Loader_actionpanel.movieClip.middle.abilities["abilityLevelPips"+slot].visible = false;
			
			temp.width = 50;
			temp.height = 15;
			temp.addChild(txField);
			txField.name = "txtField";
			this.addChild(temp);
			
			// scaling / positioning
			var pnt:Point = globals.Loader_actionpanel.movieClip.middle.abilities["abilityLevelPips"+slot].localToGlobal(new Point(0,0));
			var pnt2:Point = globals.Loader_actionpanel.movieClip.middle.abilities["Ability"+slot].localToGlobal(new Point(0,0));
			//temp.scaleX = globals.Loader_actionpanel.movieClip.middle.abilities["Ability"+slot].scaleX*globals.Loader_actionpanel.movieClip.middle.scaleX;
			//temp.scaleY = globals.Loader_actionpanel.movieClip.middle.abilities["Ability"+slot].scaleY*globals.Loader_actionpanel.movieClip.middle.scaleY;
			temp.scaleX = 0.452*globals.Loader_actionpanel.movieClip.middle.scaleX;
			temp.scaleY = 0.462*globals.Loader_actionpanel.movieClip.middle.scaleY;
			//temp.x = pnt2.x + ((globals.Loader_actionpanel.movieClip.middle.abilities["Ability"+slot].width*globals.Loader_actionpanel.movieClip.middle.abilities["Ability"+slot].scaleX*globals.Loader_actionpanel.movieClip.middle.scaleX)/2);
			temp.x = pnt2.x + ((115.3*0.452*globals.Loader_actionpanel.movieClip.middle.scaleX)/2);
			temp.y = pnt.y - (5*temp.scaleY);	
			/*
			trace("[", globals.Abilities.GetAbilityName( ent ), "] ", txField.text);
			trace("[x,y] ", temp.x, ",", temp.y);
			trace("[w,h] ", temp.width, ",", temp.height);
			trace("[abilitywidth]",globals.Loader_actionpanel.movieClip.middle.abilities["Ability"+slot].width);
			trace("[scaleX,scaleY] ", globals.Loader_actionpanel.movieClip.middle.abilities["Ability"+slot].scaleX, ",", globals.Loader_actionpanel.movieClip.middle.abilities["Ability"+slot].scaleY);
			*/
			return temp;
		}
		
		public function abilityTimer( args:Object ) {
			// reset the timer so the count is put back to 1
			// also if the dota_ability_changed is called multiple times in quick succession we will only respond to the last fire
			timer.reset();
			timer.start();
		}
		
		public function levelTimer( args:Object ) {
			// reset the timer so the count is put back to 1
			hlTimer.reset();
			hlTimer.start();
		}
		
		public function onLoaded() : void {			
			//make this UI visible
			visible = true;
			
			//let the client rescale the UI
			Globals.instance.resizeManager.AddListener(this);
			
			// our events
			this.gameAPI.SubscribeToGameEvent("send_hero_ent", this.getHeroEnt);
			this.gameAPI.SubscribeToGameEvent("dota_ability_changed", this.abilityTimer);
			this.gameAPI.SubscribeToGameEvent("dota_player_gained_level", this.levelTimer);
			this.gameAPI.SubscribeToGameEvent("dota_player_update_selected_unit", this.hideOrSeek);
			this.gameAPI.SubscribeToGameEvent("dota_player_update_query_unit", this.hideOrSeek);
		
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, abilityChanged);
			hlTimer.addEventListener(TimerEvent.TIMER_COMPLETE, gainedLevel);
			
			// set the pips to null at init, this is probably not needed but MEH
			for( var i = 0; i < 6; i++) {
				pips[i] = null;
			}
		}
		
		public function getHeroEnt( args:Object = null ) {
			if( args != null ) {
				heroEnt = args._ent;
			}
		}
		
		public function hideOrSeek( args:Object = null ) {
			var pID = globals.Players.GetLocalPlayer();
			
			if( globals.Players.GetQueryUnit(pID)=="-1" && globals.Players.GetSelectedEntities(pID)[0]==heroEnt ) seekMe();
				else hideMe();
		}
		
		public function hideMe() {
			var i = 0;
			while (i < splCount) {
				if( pips[i]!=null ) pips[i].visible = false;
				i++;
			}
		}
		
		public function seekMe() {
			hlTimer.reset();
			hlTimer.start();
			var i = 0;
			while (i < splCount) {
				if( pips[i]!=null ) pips[i].visible = true;
				i++;
			}
		}
		
		public function onResize(re:ResizeManager) : * {
			
			// iterate through our pips and scale/position them
			for( var i = 0; i < 6; i++) {
				if( pips[i] != null ) {
					var pnt:Point = globals.Loader_actionpanel.movieClip.middle.abilities["abilityLevelPips"+i].localToGlobal(new Point(0,0));
					var pnt2:Point = globals.Loader_actionpanel.movieClip.middle.abilities["Ability"+i].localToGlobal(new Point(0,0));
					pips[i].scaleX = globals.Loader_actionpanel.movieClip.middle.abilities["Ability"+i].scaleX*globals.Loader_actionpanel.movieClip.middle.scaleX;
					pips[i].scaleY = globals.Loader_actionpanel.movieClip.middle.abilities["Ability"+i].scaleY*globals.Loader_actionpanel.movieClip.middle.scaleY;
					pips[i].x = pnt2.x + ((globals.Loader_actionpanel.movieClip.middle.abilities["Ability"+i].width*globals.Loader_actionpanel.movieClip.middle.abilities["Ability"+i].scaleX*globals.Loader_actionpanel.movieClip.middle.scaleX)/2);
					pips[i].y = pnt.y - (5*pips[i].scaleY);
				}
			}
		}
	}
	
}

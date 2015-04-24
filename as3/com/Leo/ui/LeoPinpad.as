package com.Leo.ui
{
	import com.Leo.utils.LeoButton;
	import com.danielfreeman.madcomponents.UILabel;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class LeoPinpad extends Sprite
	{
		private var _currentPressedButton:LeoButton;
		private var _label:UILabel;
		public function LeoPinpad()
		{
			var w:int = Statics.STAGEWIDTH;
			var h:int = Statics.STAGEHEIGHT;
			this.graphics.beginFill(0x000000,0.95);
			this.graphics.drawRect(0,0,w,Math.round(h*0.4));
			this.graphics.endFill();
			
			var gw:int = Math.round(this.width*0.25);
			var gh:int = Math.round(this.height*0.25);
			
			this.graphics.lineStyle(1,0xffffff,0.4);
			this.graphics.moveTo(0,Math.round(this.height*0.5));
			this.graphics.lineTo(this.width-1, Math.round(this.height*0.5));
			
			this.graphics.moveTo(0,Math.round(this.height*0.25));
			this.graphics.lineTo(Math.round(this.width*0.75), Math.round(this.height*0.25));
			this.graphics.moveTo(0,Math.round(this.height*0.75));
			this.graphics.lineTo(Math.round(this.width*0.75), Math.round(this.height*0.75));
			
			this.graphics.moveTo(Math.round(this.width*0.75),0);
			this.graphics.lineTo(Math.round(this.width*0.75), this.height);
			this.graphics.moveTo(Math.round(this.width*0.5),0);
			this.graphics.lineTo(Math.round(this.width*0.5), this.height-1);
			this.graphics.moveTo(Math.round(this.width*0.25),0);
			this.graphics.lineTo(Math.round(this.width*0.25), this.height-1);
			
			
			var rn:int = 1;
			var cn:int = 0;
			for (var i:int = 0; i < 12; i++){
				var txt:String = '';
				if (i == 0 || i == 1 || i == 2) {
					switch (i) {
						case 0:
							txt = '.';
							break;
						case 1:
							txt = '0';
							break;
						case 2:
							txt = 'C';
							break;
					}
				}else{
					txt = (i - 2).toString();
				}
				var btn:LeoButton = new LeoButton(gh-(rn==1?1:2),0,txt,0xffffff,0xffffff,0);
				addChild(btn);
				btn.width = gw;
				btn.x = cn*gw;
				btn.y = this.height-rn*gh;
				if (rn > 1) btn.y++;
				if (rn == 4) btn.y++; 
				if (numChildren%3 == 0 && i > 0) {
					rn++;
					cn = 0;
				}else{
					cn++;
				}
			}
			
			var btnBack:LeoButton = new LeoButton(Math.round(this.height*0.5)-1,0,'✗',0xffffff,0xffffff,0);
			addChild(btnBack);
			btnBack.width = gw-1;
			btnBack.x = Math.round(this.width*0.75)+1;
			
			var btnEnter:LeoButton = new LeoButton(Math.round(this.height*0.5)-2,0,'✓',0xffffff,0xffffff,0);
			addChild(btnEnter);
			btnEnter.width = gw-1;
			btnEnter.y = Math.round(this.height*0.5);
			btnEnter.x = Math.round(this.width*0.75)+1;
			
			addEventListener(MouseEvent.MOUSE_DOWN, mousedownHandler);
			addEventListener(Event.ADDED_TO_STAGE, onStage);
			addEventListener(Event.REMOVED_FROM_STAGE, offStage);
		}
		
		protected function onStage(e:Event):void
		{
			this.y = Statics.STAGEHEIGHT;
			Statics.tLite(this, 0.25, {y: Math.round(Statics.STAGEHEIGHT*0.6)});
		}
		
		protected function offStage(e:Event):void
		{
			this.y = Statics.STAGEHEIGHT;
			_label = null;
		}
		
		public function set label(prLabel:UILabel):void {
			_label = prLabel;
		}
		
		protected function mousedownHandler(e:MouseEvent):void
		{
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseupHandler);
			if (e.target is LeoButton || e.target.parent is LeoButton) {
				_currentPressedButton = (e.target is LeoButton)?(e.target as LeoButton):(e.target.parent as LeoButton);
				_currentPressedButton.bgAlpha = 0.2;
				if (_label) {
					switch (_currentPressedButton.label) {
						case '✗':
							_label.text = _label.text.slice(0,-1);
							break;
						case '✓':
							
							break;
						default:
							_label.appendText(_currentPressedButton.label);
							break;
					}
				}
			}
		}
		
		protected function mouseupHandler(e:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseupHandler);
			if (_currentPressedButton) {
				_currentPressedButton.bgAlpha = 0;
				_currentPressedButton = null;
			}
		}
	}
}
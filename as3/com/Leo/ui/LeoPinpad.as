package com.Leo.ui
{
	import com.Leo.utils.LeoButton;
	import com.Leo.utils.dFormat;
	import com.Leo.utils.pf;
	import com.danielfreeman.madcomponents.UILabel;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	
	public class LeoPinpad extends Sprite
	{
		private var _currentPressedButton:LeoButton;
		private var _label:UILabel;
		private var _dollarMode:Boolean = false;
		private var _clickBlocker:Sprite = new Sprite;
		private var _callback:Function = null;
		private var btnEnter:LeoButton;
		private var btnBack:LeoButton;
		private var _myTargetPlaceholder:*;
		public function LeoPinpad(dollarMode:Boolean = false)
		{
			_dollarMode = dollarMode;
			var w:int = Statics.STAGEWIDTH;
			var h:int = Statics.STAGEHEIGHT;
			this.graphics.beginFill(0x000000,0.98);
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
			
			_clickBlocker.graphics.beginFill(0xffffff,0);
			_clickBlocker.graphics.drawRect(0,0,Statics.STAGEWIDTH, Statics.STAGEHEIGHT);
			_clickBlocker.graphics.endFill();
			
			_clickBlocker.name = 'pinpad_screen_blocker';
			
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
				if (rn > 1) {
					btn.height = btn.height + 1;
				}
				if (rn == 4) {
					btn.y--;
					btn.height = btn.height + 1;
				}
				if (numChildren%3 == 0 && i > 0) {
					rn++;
					cn = 0;
				}else{
					cn++;
				}
			}
			
			btnBack = new LeoButton(Math.round(this.height*0.5)-1,0,'✗',0xffffff,0xffffff,0);
			addChild(btnBack);
			btnBack.width = gw-1;
			btnBack.x = Math.round(this.width*0.75)+1;
			
			btnEnter = new LeoButton(Math.round(this.height*0.5)-2,0,'✓',0xffffff,0xffffff,0);
			addChild(btnEnter);
			btnEnter.width = gw-1;
			btnEnter.y = Math.round(this.height*0.5);
			btnEnter.x = Math.round(this.width*0.75)+1;
			
			addEventListener(Event.ADDED_TO_STAGE, onStage);
			addEventListener(Event.REMOVED_FROM_STAGE, offStage);
			
		}
		
		public function set myTargetPlaceholder(target:*):void {
			_myTargetPlaceholder = target;
		}
		
		protected function onStage(e:Event):void
		{
			btnBack.labelObject.y = Math.round((btnBack.height - btnBack.labelObject.textHeight)*0.5);
			btnEnter.labelObject.y = Math.round((btnEnter.height - btnEnter.labelObject.textHeight)*0.5);
			stage.addChildAt(_clickBlocker,stage.numChildren-1);
			this.y = Statics.STAGEHEIGHT;
			Statics.tLite(this, 0.25, {y: Math.round(Statics.STAGEHEIGHT*0.6)});
			stage.addEventListener(MouseEvent.MOUSE_DOWN, mousedownHandler);
			if (stage.contains(Statics._EDITOR)) {
				stage.addChild(Statics._EDITOR);
				stage.addChild(this);
			}
			if (stage.contains(Statics._CIGEDITOR)) {
				stage.addChild(Statics._CIGEDITOR);
				stage.addChild(this);
			}
		}
		
		public function set DeleteButtonLabel(s:String):void {
			btnBack.label = s;
			if (s.length > 1) {
				var lbl:UILabel = btnBack.labelObject;
				var newTF:TextFormat = lbl.getTextFormat();
				newTF.size = Math.round(btnBack.height*0.2);
				
				btnBack.labelObject.defaultTextFormat = newTF;
				btnBack.labelObject.setTextFormat(newTF);
				btnBack.labelObject.y = Math.round((btnBack.height - btnBack.labelObject.textHeight)*0.5);
			}
		}
		
		public function set EnterButtonLabel(s:String):void {
			btnEnter.label = s;
			if (s.length > 1) {
				var lbl:UILabel = btnEnter.labelObject;
				var newTF:TextFormat = lbl.getTextFormat();
				newTF.size = Math.round(btnEnter.height*0.2);
				
				btnEnter.labelObject.defaultTextFormat = newTF;
				btnEnter.labelObject.setTextFormat(newTF);
				btnEnter.labelObject.y = Math.round((btnEnter.height - btnEnter.labelObject.textHeight)*0.5);
			}
		}
		
		public function set goFunction(f:Function):void {
			_callback = f;
		}
		
		public function close(e:MouseEvent = null):void {
			if (_dollarMode) _label.text = dFormat(_label.text);
			if (stage) {
				stage.removeChild(_clickBlocker);
				stage.removeEventListener(MouseEvent.MOUSE_DOWN, mousedownHandler);
				stage.removeEventListener(MouseEvent.MOUSE_UP, mouseupHandler);
			}
			var lcThis:LeoPinpad = this;
			Statics.tLite(this, 0.25, {y: Statics.STAGEHEIGHT, onComplete:function():void {
				if (lcThis.parent) lcThis.parent.removeChild(lcThis);
			}});
			if (_callback) _callback(e);
		}
		
		protected function offStage(e:Event):void
		{
			if (_currentPressedButton) {
				_currentPressedButton.bgAlpha = 0;
				_currentPressedButton = null;
			}
			this.y = Statics.STAGEHEIGHT;
			_label = null;
		}
		
		public function set label(prLabel:UILabel):void {
			_label = prLabel;
		}
		
		private function isMyChild(child:*):Boolean {
			var b:Boolean = false;
			
			while(child.parent) {
				if (child.parent is LeoPinpad) {
					b = true;
					return b;
				}else{
					child = child.parent;
				}
			}
			
			return b;
		}
		
		protected function mousedownHandler(e:MouseEvent):void
		{
			if (!stage) return;
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseupHandler);
			
			if (e.target.name == 'pinpad_screen_blocker') {
				trace('you clicked me');
				close();
				return;
			}
			
			if (e.target is LeoButton || e.target.parent is LeoButton) {
				if (!isMyChild(e.target)) { trace('clicked others child'); return;} 
				_currentPressedButton = (e.target is LeoButton)?(e.target as LeoButton):(e.target.parent as LeoButton);
				_currentPressedButton.bgAlpha = 0.2;
				if (_label) {
					switch (_currentPressedButton.label) {
						case btnBack.label:
							if (_dollarMode) {
								if (_label.text == '$' || _label.text == '$0.00' || _label.text == '$0.' || (_label.text.indexOf('$') == 0 && _label.text.length == 2)) {
									_label.text = '$0.00';
								}else{
									_label.text = _label.text.slice(0,-1);
								}
							}else{
								if (_label.text.length > 0) {
									_label.text = _label.text.slice(0,-1);
									if (_label.text.length == 0 && _myTargetPlaceholder) {
										_myTargetPlaceholder.visible = true;
									}
								}
							}
							break;
						case btnEnter.label:
							close(e);
							break;
						case 'C':
							_label.text = _dollarMode?'$0.00':'';
							if (!_dollarMode && _myTargetPlaceholder) _myTargetPlaceholder.visible = true;
							break;
						case '.':
							if (_label.text.length == 0) {
								if (!_dollarMode && _myTargetPlaceholder) _myTargetPlaceholder.visible = false;
								_label.text = _dollarMode?'$0.':'0.';
							}else{
								if (_label.text.indexOf('.') < 0) {
									_label.appendText(_currentPressedButton.label);
								}else{
									if (pf(_label.text) == 0) {
										if (!_dollarMode && _myTargetPlaceholder) _myTargetPlaceholder.visible = false;
										_label.text = _dollarMode?'$0.':'0.';
									}
								}
							}
							break;
						default:
							trace(_currentPressedButton.label);
							if (_currentPressedButton.label != 'Save') {
								if (_currentPressedButton.label != '0') {
									if (_label.text == '$0.00') _label.text = '$';
								}
								_label.appendText(_currentPressedButton.label);
								if (_myTargetPlaceholder) {
									_myTargetPlaceholder.visible = false;
								}
							}
							break;
							
					}
				}
			}
		}
		
		protected function mouseupHandler(e:MouseEvent):void
		{
			if (stage){
				stage.removeEventListener(MouseEvent.MOUSE_UP, mouseupHandler);
			}
			if (_currentPressedButton) {
				_currentPressedButton.bgAlpha = 0;
				_currentPressedButton = null;
			}
		}
	}
}
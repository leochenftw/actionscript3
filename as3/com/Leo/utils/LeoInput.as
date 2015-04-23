package com.Leo.utils
{
	import com.ruochi.shape.RoundRect;
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.SoftKeyboardEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class LeoInput extends Sprite
	{
		protected var _w:int = 0;
		protected var _h:int = 0;
		protected var _prompt:String = "";
		protected var _inboxText:String = "";
		protected var _tf:TextFormat;
		protected var _round:int = 0;
		protected var _callBack:Function = null;
		//protected var _moveScreen:Function = null;
		protected var _parentScreen:Sprite;
		protected var _bg:RoundRect;
		protected var _text:TextField;
		protected var _parentY:Number = 0;
		public function LeoInput(w:int, h:int, parentScreen:Sprite, restrictString:String = "", 
								   tf:TextFormat = null, border:Boolean = false, 
								   backgroundColor:uint = 0, prompt:String = "",rounded:int = 0, 
								   prAlign:String = "left",callBack:Function = null)
		{
			
			_w = w;
			_h = h;
			_parentScreen = parentScreen;
			_parentY = _parentScreen.y;
			this._text = new TextField;
			if (tf){
				_tf = tf;
			}else{
				_tf = new TextFormat("Myriad Pro",_h*0.6,0x000000,null,null,null,null,null,prAlign,prAlign == "left"?_w*0.04:0,prAlign == "right"?_w*0.04:0);
			}
			this._text.type = "input";
			this._text.defaultTextFormat = _tf;
			
			this._text.height = int(this._text.textHeight*1.2);
			
			if (rounded > 0){
				_round = rounded;
			}
			if (backgroundColor != 0) {
				_bg = new RoundRect(_w,_h,_round,backgroundColor);
				this._text.width = _w*0.96;
				this._text.height = _h*0.8;
				addChild(_bg);
				this._text.x = _w*0.02;
				this._text.y = (_h - this._text.textHeight-5)*0.5;
			}else{
				this._text.width = _w;
				this._text.height = _h;
				
			}
			
			addChild(this._text);
			
			if (restrictString.length > 0){
				this._text.restrict = restrictString;
			}
			
			if (prompt.length > 0){
				_prompt = prompt;
				this._text.htmlText = "<font color=\"#999999\"><em>" + _prompt + "</em></font>";
				this._text.addEventListener(FocusEvent.FOCUS_IN, focIn);
				this._text.addEventListener(FocusEvent.FOCUS_OUT, focOut);
			}
			
			_callBack = callBack?callBack:null; 
			//_moveScreen = moveScreenFunction?moveScreenFunction:null;
			
			this.addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATING, onKeyboardUp);
			this.addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_DEACTIVATE, onKeyboardDown);
			this.addEventListener(KeyboardEvent.KEY_DOWN, downdown);
			
			if (border) {
				if (!_bg){
					this.graphics.lineStyle(1,0xcccccc);
					this.graphics.lineTo(_w,0);
					this.graphics.lineTo(_w,_h);
					this.graphics.lineTo(0,_h);
					this.graphics.lineTo(0,0);
				}else{
					_bg.graphics.lineStyle(1,0xcccccc);
					_bg.graphics.moveTo(0,0);
					_bg.graphics.lineTo(_w,0);
					_bg.graphics.lineTo(_w,_h);
					_bg.graphics.lineTo(0,_h);
					_bg.graphics.lineTo(0,0);
				}
			}
			
			_text.softKeyboardInputAreaOfInterest = _text.getBounds(_text);
		}
		
		public function set wordWrap(b:Boolean):void {
			_text.wordWrap = b;
		}
		
		public function set multiline(b:Boolean):void {
			_text.multiline = b;
		}
		
		private function downdown(e:KeyboardEvent):void {
			if (e.keyCode == 13) {
				if (!_text.multiline) {
					stage.focus = null;
					//toSay();
				}
			}
		}
		
		/*private function toSay(e:SoftKeyboardEvent = null):void {
			if (_moveScreen){
				_moveScreen(false,this.y + (_bg?_bg.height:this._text.height)*0.5);
			}
		}*/
		
//		private function toListen(e:SoftKeyboardEvent):void {
//			if (_moveScreen){
//				_moveScreen(true,this.y + (_bg?_bg.height:this._text.height)*0.5);
//			}
//		}
		
		public function focIn(e:FocusEvent):void {
			if (_inboxText.length == 0) {
				this._text.text = "";
			}else{
				this._text.setSelection(0,this._text.text.length);
			}
			
		}
		
		public function focOut(e:FocusEvent = null):void {
			_inboxText = this._text.text;
			if (_inboxText.length == 0){
				this._text.htmlText = "<font color=\"#999999\"><i>" + _prompt + "</i></font>";
				if (_callBack && e){
					_callBack("0");
				}
			}else{
				if (_callBack){
					_callBack(_inboxText);
				}
			}
		}
		
		public function reset():void {
			_inboxText = "";
			this._text.htmlText = "<font color=\"#999999\"><i>" + _prompt + "</i></font>";
		}
		
		public function get text():String {
			return _prompt.length > 0?_inboxText:this._text.text;
		}
		
		public function set text(s:String):void {
			_inboxText = this._text.text = s;
		}
		
		public function get bg():RoundRect {
			return _bg?_bg:new RoundRect();
		}
		
		public function set displayAsPassword(b:Boolean):void {
			this._text.displayAsPassword = b;
		}
		
		override public function get height():Number {
			return _bg?_bg.height:this._text.height;
		}
		
		override public function get width():Number {
			
			return _bg?_bg.width:this._text.width;
		}
		
		private function onKeyboardDown( event:SoftKeyboardEvent ):void 
		{ 
			TweenLite.to(_parentScreen,0.25,{y: _parentY});
		}
		
		private function onKeyboardUp( event:SoftKeyboardEvent ):void 
		{ 
			var offset:Number = 0; 
			
			//if the softkeyboard is open and the field is at least partially covered 
			if( (this.stage.softKeyboardRect.y != 0) && (_text.y + _text.height > this.stage.softKeyboardRect.y) ) 
				offset = _text.y + _text.height - this.stage.softKeyboardRect.y; 
			
			//but don't push the top of the field above the top of the screen 
			if( _text.y - offset < 0 ) offset += _text.y - offset; 
			//_parentScreen.y = -offset;
			TweenLite.to(_parentScreen,0.25,{y: -offset});
		}
	}
}
package com.Leo.utils
{
	import com.danielfreeman.madcomponents.UILabel;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.SoftKeyboardEvent;
	import flash.geom.Rectangle;
	import flash.text.StageText;
	import flash.text.StageTextInitOptions;
	import flash.text.TextFormat;
	
	[Event(name="change",                 type="flash.events.Event")]
	[Event(name="focusIn",                type="flash.events.FocusEvent")]
	[Event(name="focusOut",               type="flash.events.FocusEvent")]
	[Event(name="keyDown",                type="flash.events.KeyboardEvent")]
	[Event(name="keyUp",                  type="flash.events.KeyboardEvent")]
	[Event(name="softKeyboardActivate",   type="flash.events.SoftKeyboardEvent")]
	[Event(name="softKeyboardActivating", type="flash.events.SoftKeyboardEvent")]
	[Event(name="softKeyboardDeactivate", type="flash.events.SoftKeyboardEvent")]
	public class LeoNativeText extends Sprite
	{
		protected var _txt:StageText;
		protected var _width:int;
		protected var _height:int;
		protected var _radius:Number;
		protected var _bgColor:uint;
		protected var _bgAlpha:Number;
		protected var _padding:int;
		protected var _border:Number;
		protected var _borderColor:uint;
		protected var _borderAlpha:Number;
		
		protected var _placeHolder:String = '';
		protected var _multiline:Boolean = false;
		protected var _lblPlaceholder:UILabel;
		protected var _txtFormat:TextFormat;
		protected var _unfreezeUponAddtoScreen:Boolean = true;
		protected var _snapshot:Sprite = new Sprite;
		protected var _enterLabel:String = '';
		public function LeoNativeText(txtFormat:TextFormat, w:int,h:int,r:Number,bgColor:uint, bgAlpha:Number = 1, padding:int = 10, border:Number = 0, borderColor:uint = 0x000000, borderAlpha: Number = 1, multiline:Boolean = false,placeHolder:String = '',enterLabel = '')
		{
			_txtFormat = txtFormat;
			_width = w;
			_height = h;
			_radius = r;
			_bgColor = bgColor;
			_bgAlpha = bgAlpha;
			_padding = padding;
			_border = border;
			_borderColor = borderColor;
			_borderAlpha = borderAlpha;
			_multiline = multiline;
			_placeHolder = placeHolder;
			_enterLabel = enterLabel;
			
			drawBG();
			if (_placeHolder.length > 0) {
				_lblPlaceholder = new UILabel(this,_padding,_padding,_placeHolder,txtFormat);
				
				if (_multiline) {
					_lblPlaceholder.multiline = true;
				}
				_lblPlaceholder.fixwidth = _width - 2*_padding;
				_lblPlaceholder.fixheight = _height - 2*_padding;
				
				removeChild(_lblPlaceholder);
			}
			
			var stio:StageTextInitOptions = new StageTextInitOptions(_multiline);
			this._txt = new StageText(stio);
			this._txt.fontFamily = txtFormat.font;
			this._txt.fontSize = txtFormat.size as int;
			this._txt.returnKeyLabel = enterLabel;
			if (_enterLabel == 'done') {
				this._txt.addEventListener(Event.CHANGE,function(e:Event):void {
					var str:String = (e.target as StageText).text;
					if (str.charAt(str.length - 1) == '\n'){
						stage.focus = null;
					}
				});
			}
			this._txt.addEventListener(FocusEvent.FOCUS_IN, focin);
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		public function set unfreezeUponAddtoScreen(b:Boolean):void {
			_unfreezeUponAddtoScreen = b;
		}
		
		protected function focin(e:FocusEvent):void
		{
			this._txt.addEventListener(FocusEvent.FOCUS_OUT, focout);
			if (_lblPlaceholder && contains(_lblPlaceholder)) removeChild(_lblPlaceholder); 
			
		}
		
		
		protected function focout(e:FocusEvent):void
		{
			this._txt.removeEventListener(FocusEvent.FOCUS_OUT,focout);
			if (_lblPlaceholder) {
				if (this._txt.text.length == 0) {
					addChild(_lblPlaceholder);
				}
			}
		}
		
		protected function init(e:Event):void {
			if (_unfreezeUponAddtoScreen){
				unfreeze();
			}
			if (_lblPlaceholder && this._txt.text.length == 0) this.addChild(_lblPlaceholder);
			this._txt.viewPort = new Rectangle(this.x + _padding, this.y + _padding, _width - _padding*2, _height - _padding*2);
		}
		
		protected function render():void {
			if (!stage) return;
		}
		
		public function freeze():void {
			if (this._txt&&stage){
				var bmd:BitmapData = new BitmapData(this._txt.viewPort.width, this._txt.viewPort.height, true,0x000000);
				this._txt.drawViewPortToBitmapData(bmd);
				var bmp:Bitmap = new Bitmap(bmd,'auto',true);

				_snapshot.removeChildren();
				_snapshot.addChild(bmp);
				_snapshot.x = _padding;
				_snapshot.y = _padding;
				addChild(_snapshot);
				this._txt.stage = null;
			}
		}
		
		public function unfreeze():void {
			if (contains(_snapshot) && stage) {
				removeChild(_snapshot);
			}
			this._txt.stage = stage;
		}
		
		public override function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			if (this.isEventTypeStageTextSpecific(type))
			{
				this._txt.addEventListener(type, listener, useCapture, priority, useWeakReference);
			}
			else
			{
				super.addEventListener(type, listener, useCapture, priority, useWeakReference);
			}
		}
		
		public override function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
		{
			if (this.isEventTypeStageTextSpecific(type))
			{
				this._txt.removeEventListener(type, listener, useCapture);
			}
			else
			{
				super.removeEventListener(type, listener, useCapture);
			}
		}
		
		private function isEventTypeStageTextSpecific(type:String):Boolean
		{
			return (type == Event.CHANGE ||
				type == FocusEvent.FOCUS_IN ||
				type == FocusEvent.FOCUS_OUT ||
				type == KeyboardEvent.KEY_DOWN ||
				type == KeyboardEvent.KEY_UP ||
				type == SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATE ||
				type == SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATING ||
				type == SoftKeyboardEvent.SOFT_KEYBOARD_DEACTIVATE);
		}
		
		protected function drawBG():void {
			this.graphics.clear();
			if (_border > 0) {
				this.graphics.lineStyle(_border,_borderColor,_borderAlpha);
			}
			this.graphics.beginFill(_bgColor,_bgAlpha);
			if (_radius > 0) {
				this.graphics.drawRoundRect(0,0,_width,_height,_radius,_radius);
			}else{
				this.graphics.drawRect(0,0,_width,_height);
			}
			this.graphics.endFill();
		}
		
		
		
		
		
		
		/*native text getters */
		public function get text():String {
			return this._txt.text;
		}
		
		
		/* native text setters */
		public function set text(txt:String):void {
			this._txt.text = txt;
		}
		
		public function set autoCapitalize(autoCapitalize:String):void
		{
			this._txt.autoCapitalize = autoCapitalize;
		}
		
		public function set autoCorrect(autoCorrect:Boolean):void
		{
			this._txt.autoCorrect = autoCorrect;
		}
		
		public function set color(color:uint):void
		{
			this._txt.color = color;
		}
		
		public function set displayAsPassword(displayAsPassword:Boolean):void
		{
			this._txt.displayAsPassword = displayAsPassword;
		}
		
		public function set editable(editable:Boolean):void
		{
			this._txt.editable = editable;
		}
		
		public function set fontFamily(fontFamily:String):void
		{
			this._txt.fontFamily = fontFamily;
		}
		
		public function set fontPosture(fontPosture:String):void
		{
			this._txt.fontPosture = fontPosture;
		}
		
		public function set fontSize(fontSize:uint):void
		{
			this._txt.fontSize = fontSize;
		}
		
		public function set fontWeight(fontWeight:String):void
		{
			this._txt.fontWeight = fontWeight;
		}
		
		public function set locale(locale:String):void
		{
			this._txt.locale = locale;
		}
		
		public function set maxChars(maxChars:int):void
		{
			this._txt.maxChars = maxChars;
		}
		
		public function set restrict(restrict:String):void
		{
			this._txt.restrict = restrict;
		}
		
		public function set returnKeyLabel(returnKeyLabel:String):void
		{
			this._txt.returnKeyLabel = returnKeyLabel;
		}
		
		public function get selectionActiveIndex():int
		{
			return this._txt.selectionActiveIndex;
		}
		
		public function get selectionAnchorIndex():int
		{
			return this._txt.selectionAnchorIndex;
		}
		
		public function set softKeyboardType(softKeyboardType:String):void
		{
			this._txt.softKeyboardType = softKeyboardType;
		}
	}
}
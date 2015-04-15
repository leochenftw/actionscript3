package com.Leo.utils
{
	import com.danielfreeman.madcomponents.UILabel;
	import com.greensock.TweenLite;
	import com.ruochi.shape.Rect;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.geom.Point;
	import flash.text.TextFormat;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	
	public class LeoTimePicker extends LeoSprite
	{
		private var _stage:Sprite; 
		private var _tx:Number,_ty:Number = 0;
		private var _btnOK:LeoButton;
		private var _gp:int = 0;
		private var _hour:UILabel;
		private var _min:UILabel;
		private var _ttf:TextFormat;
		private var _timeWrapper:Sprite = new Sprite;
		private var cbf:Function = null;
		private var targetField:UILabel;
		private var _landPoint:int = 0;
		private var _maxTick:int = 0;
		private var _date:Object = null;
		public function LeoTimePicker(w:int,h:int,g:int, callback:Function, prHour:String = '00', prMin:String = '00', prDate:Object = null)
		{
			super();
			cbf = callback;
			_date = prDate;
			_stage = new Rect(w,h);
			_stage.alpha = 0.98;
			addChild(_stage);
			
			_btnOK = new LeoButton(w*0.3, h*0.08, 10, 'OK', 0xffffff, 1, 0x1D3255, 0,false)
			
			_btnOK.x = w - g - _btnOK.width;
			_btnOK.y = h - g - _btnOK.height;
			_btnOK.addEventListener(MouseEvent.CLICK, timePicked);
			addChild(_btnOK);
			
			_ttf = new TextFormat('Myriad Pro',int(h*0.15),0x1D3255,null,null,null,null,null,'center');
			_hour = new UILabel(_timeWrapper, 0, 0, prHour,_ttf);
			var colon:UILabel = new UILabel(_timeWrapper, _hour.width, 0,':',_ttf);
			_min = new UILabel(_timeWrapper, colon.x + colon.width, 0, prMin,_ttf);
			colon.y = int((_hour.height - colon.height)*0.5);
			_timeWrapper.y = int((h-_hour.height)*0.5);
			_timeWrapper.x = int((w-_timeWrapper.width)*0.5);
			addChild(_timeWrapper);
			
			this.addEventListener(TouchEvent.TOUCH_BEGIN, start);
			//_sMin.addEventListener(TransformGestureEvent.GESTURE_SWIPE,swipeText);
		}
		
		protected function start(e:TouchEvent):void {
			if (e.stageX <= stage.fullScreenWidth*0.5) {
				targetField = _hour;
				_maxTick = 23;
			}else{
				targetField = _min;
				_maxTick = 59;
			}
			
			_landPoint = e.stageY;
			
			if(!stage.hasEventListener(TouchEvent.TOUCH_END)) {                    
				stage.addEventListener(TouchEvent.TOUCH_MOVE, update);
				stage.addEventListener(TouchEvent.TOUCH_END, end);
			}
		}
		
		public function set time(t:String):void {
			var tarr:Array = t.split(':');
			_hour.text = tarr[0].length==1?'0'+tarr[0]:tarr[0];
			_min.text = tarr[1].length==1?'0'+tarr[1]:tarr[1];
		}
		
		public function set date(d:Object):void {
			_date = d;
		}
		
		protected function update(e:TouchEvent):void {
			
		}
		
		protected function end(e:TouchEvent):void {
			
			if (stage){
				stage.removeEventListener(TouchEvent.TOUCH_MOVE, update);
				stage.removeEventListener(TouchEvent.TOUCH_END, end);
			}
			var d:Number = e.stageY - _landPoint;
			var v:Number = Number(targetField.text);
			if (d > 0) {
				if (v-1<0){
					v = _maxTick;
				}else{
					v--;
				}
			}else{
				if (v+1>_maxTick){
					v = 0;
				}else{
					v++;
				}
			}
			targetField.text = v<10?'0' + v.toString():v.toString();
			targetField = null;
			_landPoint = 0;
		}
		
		
		private function timePicked(e:MouseEvent):void {
			if (stage.hasEventListener(TouchEvent.TOUCH_END)){
				stage.removeEventListener(TouchEvent.TOUCH_MOVE, update);
				stage.removeEventListener(TouchEvent.TOUCH_END, end);
			}
			
			_date = _date?_date:{};
			var lcHour:Number = Number(_hour.text);
			_date.fullhour = lcHour;
			if (lcHour >= 12) {
				lcHour -= 12;
				_date.ampm = 'pm';
			}else{
				if (lcHour == 0) {
					lcHour = 12;
				}
				_date.ampm = 'am';
			}
			
			_date.hour = lcHour < 10? '0' + lcHour.toString(): lcHour.toString(); 
			_date.min = _min.text;
			cbf(_date);
		}
		
		public function withDraw(callback:Function = null):void {
			var lcThis:LeoTimePicker = this;
			TweenLite.to(this, 0.25, {alpha: 0, x: _tx, y: _ty, scaleX: 1.5, scaleY: 1.5, onComplete:function():void {
				parent.removeChild(lcThis);
				if (callback) callback();
			}});
		}
		
		override protected function init(e:Event=null):void {
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			this.scaleX = this.scaleY = 1.5; 
			this.alpha = 0;
			_tx = this.x = (stage.stageWidth - this.width) * 0.5;
			_ty = this.y = (stage.stageHeight - this.height) * 0.5;
			TweenLite.to(this, 0.25, {alpha: 1, x: 0, y: 0, scaleX: 1, scaleY: 1});
		}
	}
}
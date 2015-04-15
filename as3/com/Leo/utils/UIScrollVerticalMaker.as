package com.Leo.utils 
{
	import com.danielfreeman.madcomponents.Attributes;
	import com.danielfreeman.madcomponents.UI;
	import com.danielfreeman.madcomponents.UIScrollVertical;
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.events.TransformGestureEvent;
	import flash.utils.Timer;

//	import flash.utils.Timer;
	
	public class UIScrollVerticalMaker extends UIScrollVertical
	{
		protected static const GAP:Number = 8.0;
		
		protected var _pureLayer:Sprite;
		protected var _gap:Number = GAP;
		protected var _xgap:Number = _gap;
		protected var _originH:Number = 0;
		protected var _oddOffset:Number = 0;
		protected var expNum:int = 0;
		protected var _fingerDown:Boolean = false;
		protected var _ueTimer:Timer = new Timer(50,1);
		protected var _associate:UIScrollHorizontalMaker;
		protected var _commandlyFrozen:Boolean = false;
		public function UIScrollVerticalMaker(screen:Sprite, width:Number, height:Number, offset:Number, style:String = "") {
			_originH = height;
			_oddOffset = offset;
			var attributes:Attributes = new Attributes(0, 0, width, height-offset);
			attributes.parse(XML("<null "+style+"/>"));
			super(screen,<null/>, attributes);
			_slider.addChild(_pureLayer = new Sprite());
			this.addEventListener(MouseEvent.MOUSE_DOWN,ueListenerOn);
			_ueTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onUETimerComplete);
			super.scrollEnabled = false;
			
			//this.addEventListener(MouseEvent.MOUSE_DOWN,fingerDownHandler);
		}
		
//		protected function fingerDownHandler(e:MouseEvent):void {
//			stage.addEventListener(MouseEvent.MOUSE_UP,fingerUpHandler);
//			_fingerDown = true;
//		}
//		
//		protected function fingerUpHandler(e:MouseEvent):void {
//			stage.removeEventListener(MouseEvent.MOUSE_UP,fingerUpHandler);
//			_fingerDown = false;
//		}
		
		
		public function set commandlyFreeze(b:Boolean):void {
			_commandlyFrozen = b;
			super.scrollEnabled = !b;
		}
		
		public function get commandlyFreeze():Boolean {
			return _commandlyFrozen;
		}
		
		public override function set height(value:Number):void {
			_originH = value;
			this.attributes.height = value;
			this.doLayout();
		}
		
		public override function get height():Number {
			return _originH;
		}
		
		public function set associate(prScroller:UIScrollHorizontalMaker):void {
			_associate = prScroller;
		}
		
		protected function onUETimerComplete(e:TimerEvent):void {
			if (_fingerDown && !_commandlyFrozen) {
				super.scrollEnabled = true;
				_distance = 0;
			}
		}
		
		protected function ueListenerOn(e:MouseEvent):void {
			_ueTimer.reset();
			_ueTimer.start();
			_fingerDown = true;
			if (_associate) _associate.distance = 0;
			stage.addEventListener(MouseEvent.MOUSE_UP, ueListenerOff);
		}
		
		public override function hideScrollBar():void {
			dispatchEvent(new Event(STOPPED));
			if (_scrollBarVisible) {
				_scrollBarLayer.graphics.clear();
				_scrollBarVisible = false;
				super.scrollEnabled = false;
			}
		}
		
		protected function ueListenerOff(e:MouseEvent):void {
			if (stage) {
				stage.removeEventListener(MouseEvent.MOUSE_UP, ueListenerOff);
			}
			_fingerDown = false;
			//super.scrollEnabled = false;
		}
		
		public function get slideH():int {
			return _slider.height;
		}
		
		public function get pureH():int {
			return _pureLayer.height;
		}
		
		public function set gap(value:Number):void {
			_gap = Math.floor(value);
		}
		
		public function set xgap(value:Number):void {
			_xgap = Math.floor(value);
		}
		
		
		public function attach(child:DisplayObject):void {
			_pureLayer.addChild(child);
			adjustMaximumSlide();
		}
		
		
		public function attachHorizontal(child:DisplayObject):void {
			var lastChild:DisplayObject = _pureLayer.numChildren>0 ? _pureLayer.getChildAt(_pureLayer.numChildren - 1) : null;
			_pureLayer.addChild(child);
			child.x = lastChild ? lastChild.x + lastChild.width + _gap : UI.PADDING;
			child.y = lastChild ? lastChild.y : UI.PADDING;
			adjustMaximumSlide();
		}
		
		public function updatePos():void {
			for (var i:int = 0; i < _pureLayer.numChildren; i++){
				if (i > 0) {
					_pureLayer.getChildAt(i).y = _pureLayer.getChildAt(i-1).y + _pureLayer.getChildAt(i-1).height + _gap;
					adjustMaximumSlide();
				}
			}
		}
		
		public function attachVertical(child:DisplayObject):void {
			var lastChild:DisplayObject = _pureLayer.numChildren>0 ? _pureLayer.getChildAt(_pureLayer.numChildren - 1) : null;
			_pureLayer.addChild(child);
			//child.x = lastChild ? lastChild.x : UI.PADDING;
			child.x = _xgap;
			//child.y = lastChild ? lastChild.y + lastChild.height + _gap : UI.PADDING;
			child.y = lastChild ? lastChild.y + lastChild.height + _gap : _gap;
			adjustMaximumSlide();
		}
		
		public function prepend(child:DisplayObject):void {
			if (_pureLayer.numChildren > 0) {
				child.x = _xgap;
				child.y = _gap;
				_pureLayer.addChildAt(child,0);
				for (var i:int = 1; i < _pureLayer.numChildren; i++){
					var thisChild:DisplayObject = _pureLayer.getChildAt(i);
					var lastChild:DisplayObject = _pureLayer.getChildAt(i-1);
					thisChild.y = lastChild.y + lastChild.height + _gap;
				}
			}else{
				_pureLayer.addChild(child);
			}
			adjustMaximumSlide();
		}
		
		public function attachVerticalAt(child:DisplayObject,pry:int):void {
			var lastChild:DisplayObject = _pureLayer.numChildren>0 ? _pureLayer.getChildAt(_pureLayer.numChildren - 1) : null;
			_pureLayer.addChild(child);
			//child.x = lastChild ? lastChild.x : UI.PADDING;
			child.x = _gap;
			//child.y = lastChild ? lastChild.y + lastChild.height + _gap : UI.PADDING;
			child.y = pry;
			adjustMaximumSlide();
		}
		
		public function removeItemInstant(child:*):void {
			_pureLayer.removeChild(child);
			attention();
		}
		
		public function removeItem(child:DisplayObject):void {
			var offsetH:Number = 0;
			var mayFly:Boolean = false;
			for (var i:int = 0; i<_pureLayer.numChildren;i++){
				
				if (mayFly) {
					TweenLite.to(_pureLayer.getChildAt(i),0.2,{y:(_pureLayer.getChildAt(i).y-offsetH),onComplete:waitforFinish});
				}
				
				if (_pureLayer.getChildAt(i) == child){
					offsetH = child.height+GAP;
					mayFly = true;
					expNum = _pureLayer.numChildren - 1 - i;
				}
				
			}
			
			_pureLayer.removeChild(child);
			
		}
		
		public function attention():void {
			var nextY:int = _gap;
			for (var i:int = 0; i<_pureLayer.numChildren;i++){
				var thisChild:DisplayObject = getChildAt(i);
				if (thisChild.visible) {
					thisChild.y = nextY;
					nextY = thisChild.y + thisChild.height + _gap; 
				}
			}
			adjustMaximumSlide();
		}
		
		protected override function adjustVerticalSlide():void {
			if (!_pureLayer) {
				var sliderHeight:Number = _scrollerHeight>0 ? _scrollerHeight*_scale : _slider.getBounds(this).bottom;
				_maximumSlide = sliderHeight - _height + PADDING * (_border=="false" ? 0 : 1);
			}else{
				_maximumSlide = _pureLayer.height - _originH - _oddOffset;
			}
			if (_maximumSlide < 0) {
				_maximumSlide = 0;
			}
			if (sliderY < -_maximumSlide) {
				sliderY = -_maximumSlide;
			}
		}
		
		protected function waitforFinish():void {
			expNum--;
			if (expNum <= 0){
				adjustMaximumSlide();
			}
		}
		
		public function set distance(d:Number):void {
			_distance = d;
		}
		
		public function get distance():Number {
			return  _distance;
		}
		
		override public function getChildByName(name:String):DisplayObject {
			return _pureLayer.getChildByName(name);
		}
		
		override public function getChildAt(index:int):DisplayObject {
			return _pureLayer.getChildAt(index);
		}
		
		override public function get numChildren():int {
			return _pureLayer.numChildren;
		}
		
		override public function clear():void {
			/*while (_pureLayer.numChildren > 0) {
				_pureLayer.removeChildAt(_pureLayer.numChildren - 1);
			}*/
			_pureLayer.removeChildren();
		}
		
		public function updateHeight(prMoreOffset:int = 0):void {
			//adjustMaximumSlide();
			//_maximumSlide = _pureLayer.numChildren * (_pureLayer.getChildAt(0).height-_oddOffset) - _originH - prMoreOffset;
			_maximumSlide = this.height-_originH;
		}
		
		public function toTop():void {
			scrollPositionY = 0;
			_slider.y = 0;
		}
		
		public function toBottom():void {
			TweenLite.to(_slider, 0.5, {y:-(this.height-_originH)});
			scrollPositionY = this.height-_originH;
		}
		
		public function jigList(dif:int):void {
			var len:int = _pureLayer.numChildren;
			for (var i:int = 1; i<len; i++){
				_pureLayer.getChildAt(i).y += dif*i;
			}
			_slider.y = 0;
			scrollPositionY = 0;
			updateHeight();
			_slider.y = -(this.height-_originH);
			scrollPositionY = this.height-_originH;
		}
		
		protected override function mouseMove(event:TimerEvent):void {
			
			if (_associate){
				//trace(_associate.distance);
				if (_associate.distance > 0) 
					return;
			}
			if (!_noScroll) {
				var delta:Number = -sliderY;
				sliderY += (outsideSlideRange ? _dampen : 1.0) * (mouseY - _lastMouse.y);
				delta += sliderY;
				
				if (delta * _swipeTotalY < 0 || Math.abs(delta) < DELTA_THRESHOLD && Math.abs(_oldDeltaY) < DELTA_THRESHOLD) {
					_swipeTotalY = 0;
					_swipeDurationY = 0;
				}
				
				_swipeTotalY += delta;
				_swipeDurationY++;
				_oldDeltaY = delta;
				_delta = SWIPE_FACTOR * _swipeTotalY / _swipeDurationY;                                 
				
				_distance += Math.abs(mouseY - _lastMouse.y); // + Math.abs(mouseX - _startMouse.x);
				_lastMouse.x = mouseX;
				_lastMouse.y = mouseY;
			}
			if (!_noScroll && _distance > ABORT_THRESHOLD) {
				showScrollBar();
			}
			else if (_classic && _distance < THRESHOLD && _touchTimer.currentCount == MAXIMUM_TICKS) {
				pressButton();
			}
			
		}
		
	}
}
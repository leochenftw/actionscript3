package com.Leo.utils
{
	import com.danielfreeman.madcomponents.Attributes;
	import com.danielfreeman.madcomponents.UIScrollVertical;
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	
	
	public class UIScrollVerticalMaker extends UIScrollVertical
	{
		protected var _pureLayer:Sprite;
		protected var _xgap:Number = 0;
		protected var _ygap:Number = 0;
		protected var _thisMask:Shape;
		protected var _w:Number;
		protected var actualDistance:Number = 0;
		protected var _associate:UIScrollVerticalMaker;
		protected var _delayDistance:int = 0;
		protected var _expandedHeight:Number = 0;
		public function UIScrollVerticalMaker(screen:Sprite, width:Number, height:Number, xgap:Number=0, ygap:Number=0, style:String = "",associate:UIScrollVerticalMaker=null) {
			
			_w = width;
			_xgap = xgap;
			_ygap = ygap;
			_associate = associate;
			super(screen,XML("<null "+style+"/>"), new Attributes(0, 0, width, height));
			_slider.addChild(_pureLayer = new Sprite());
			_thisMask = new Shape;
			_thisMask.graphics.beginFill(0x000000);
			_thisMask.graphics.drawRect(0,0,width,height);
			_thisMask.graphics.endFill();
			addChild(_thisMask);
			_pureLayer.mask = _thisMask;
			if (_associate) {
				_pureLayer.addEventListener(MouseEvent.MOUSE_DOWN, mousedownOnLayer);
			}
			
			addEventListener(MouseEvent.MOUSE_DOWN, delayPurposeDown);
		}
		
		public override function clear():void {
			_pureLayer.removeChildren();
		}
		
		public function set commandlyFreeze(b:Boolean):void {
			
		}
		
		protected function delayPurposeDown(e:MouseEvent):void
		{
			stage.addEventListener(MouseEvent.MOUSE_UP,resetDistance);
		}
		
		protected function resetDistance(e:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP,resetDistance);
			actualDistance = 0;
		}		
		
		protected override function mouseMove(event:TimerEvent):void {
			if (!_noScroll) {
				if (actualDistance < _delayDistance) {
					actualDistance += Math.abs(mouseY - _lastMouse.y);
					_lastMouse.x = mouseX;
					_lastMouse.y = mouseY;
					return;
				}
				var delta:Number = -sliderY;
				sliderY += (outsideSlideRange ? _dampen : 1.0) * (mouseY - _lastMouse.y);
				delta += sliderY;
				
				if (Math.abs(delta) > DELTA_THRESHOLD) {
					if (delta * _delta > 0) {
						_delta = SMOOTH * _delta + (1 - SMOOTH) * delta;
					}
					else {
						_delta = delta;
					}
					_noSwipeCount = 0;
				}
				else if (++_noSwipeCount > NO_SWIPE_THRESHOLD) {
					_delta = 0;
				}
				_distance += Math.abs(mouseY - _lastMouse.y); // + Math.abs(mouseX - _startMouse.x);
				_lastMouse.x = mouseX;
				_lastMouse.y = mouseY;
			}
			if (!_noScroll && _distance > ABORT_THRESHOLD) {
				showScrollBar();
			}
			else if (_touchTimer.currentCount == MAXIMUM_TICKS && _classic && _distance < THRESHOLD) {
				pressButton();
			}
			else if (_touchTimer.currentCount == TOUCH_DELAY && !_classic && Math.abs(_delta) <= DELTA_THRESHOLD) {
				pressButton();
			}
			
		}
		
		protected override function adjustVerticalSlide():void {
			if (!_pureLayer) {
				var sliderHeight:Number = _scrollerHeight>0 ? _scrollerHeight*_scale : _slider.getBounds(this).bottom;
				_maximumSlide = sliderHeight - _height + PADDING * (_border=="false" ? 0 : 1);
			}else{
				_maximumSlide = pureHeight - _thisMask.height + _ygap*2;
				if (pureHeight <= _thisMask.height) {
					this.scrollEnabled = false;
				}else{
					this.scrollEnabled = true;
				}
			}
			if (_maximumSlide < 0) {
				_maximumSlide = 0;
			}
			if (sliderY < -_maximumSlide) {
				sliderY = -_maximumSlide;
			}
		}
		
		protected function get pureHeight():Number {
			var n:Number = _ygap;
			var hasInvisible:Boolean = false;
			for (var i:int = 0; i < _pureLayer.numChildren; i++){
				var thisChild:DisplayObject = _pureLayer.getChildAt(i);
				if (thisChild.visible) {
					n += (thisChild.height + _ygap);
				}else{
					if (!hasInvisible) {
						hasInvisible = true;
					}
				}
			}
			return hasInvisible?n:_pureLayer.height;
		}
		
		protected function mousedownOnLayer(event:MouseEvent):void
		{
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseupFromLayer);
			_associate.scrollEnabled = false;
		}
		
		protected function mouseupFromLayer(event:MouseEvent):void
		{
			if (stage) stage.removeEventListener(MouseEvent.MOUSE_UP, mouseupFromLayer);
			_associate.distance = 0;
			_associate.scrollEnabled = true;
		}
		
		public function set xgap(value:Number):void {
			_xgap = value;
		}
		
		public function set ygap(value:Number):void {
			_ygap = value;
		}
		
		public override function get height():Number {
			return _thisMask.height;
		}
		
		public override function set height(value:Number):void {
			_thisMask.graphics.clear();
			_thisMask.graphics.beginFill(0x000000);
			_thisMask.graphics.drawRect(0,0,_w,value);
			_thisMask.graphics.endFill();
			this.attributes.height = value;
			_height = value;
			adjustMaximumSlide();
		}
		
		public function attach(child:DisplayObject):void {
			_pureLayer.addChild(child);
			adjustMaximumSlide();
		}
		
		public function set distance(n:Number):void {
			this._distance = n;
		}
		
		public function get distance():Number {
			return this._distance;
		}
		
		public function attachHorizontal(child:DisplayObject):void {
			var lastChild:DisplayObject = _pureLayer.numChildren>0 ? _pureLayer.getChildAt(_pureLayer.numChildren - 1) : null;
			_pureLayer.addChild(child);
			child.x = lastChild ? (lastChild.x + lastChild.width + _xgap) : _xgap;
			child.y = lastChild ? lastChild.y : _ygap;
			adjustMaximumSlide();
		}
		
		
		public function attachVertical(child:DisplayObject):void {
			var lastChild:DisplayObject = _pureLayer.numChildren>0 ? _pureLayer.getChildAt(_pureLayer.numChildren - 1) : null;
			_pureLayer.addChild(child);
			child.x = lastChild ? lastChild.x : _xgap;
			child.y = lastChild ? (lastChild.y + lastChild.height + _ygap) : _ygap;
			
			if (_delayDistance == 0) {
				_delayDistance = child.height;
			}
			adjustMaximumSlide();
		}
		
		public function prependVertical(child:DisplayObject):void {
			if (_pureLayer.numChildren == 0) {
				_pureLayer.addChild(child);
			}else{
				_pureLayer.addChildAt(child,0);
			}
			child.x = _xgap;
			child.y = _ygap;
			
			for (var i:int = 1; i < _pureLayer.numChildren; i++){
				_pureLayer.getChildAt(i).y+= (child.height + _ygap);
			}
			
			if (_delayDistance == 0) {
				_delayDistance = child.height;
			}
			adjustMaximumSlide();
		}
		
		public function set delayDistance(n:Number):void {
			_delayDistance = n;
		}
		
		public function get pureLayer():Sprite {
			return _pureLayer;
		}
		
		public override function removeChild(child:DisplayObject):DisplayObject {
			var rc:DisplayObject = _pureLayer.removeChild(child);
			this.height -= rc.height;
			trace('remover called');
			attention();
			return rc;
		}
		
		public function attention():void {
			var nextY:int = _ygap;
			for (var i:int = 0; i<_pureLayer.numChildren;i++){
				var thisChild:DisplayObject = _pureLayer.getChildAt(i);
				if (thisChild.visible) {
					thisChild.y = nextY;
					nextY = thisChild.y + thisChild.height + _ygap; 
				}
			}
			adjustMaximumSlide();
		}
		
//		public function attention():void {
//			if (_pureLayer.numChildren > 0) {
//				for (var i:int = 1; i<_pureLayer.numChildren; i++){
//					var lastChild:DisplayObject = _pureLayer.getChildAt(i-1);
//					var child:DisplayObject = _pureLayer.getChildAt(i);
//					child.y = lastChild.y + lastChild.height + _ygap;
//				}
//			}
//			adjustMaximumSlide();
//		}
		
		public function toTop():void {
			scrollPositionY = 0;
			_slider.y = 0;
		}
	}
}



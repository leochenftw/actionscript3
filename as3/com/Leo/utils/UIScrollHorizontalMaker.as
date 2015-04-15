package com.Leo.utils
{
	import com.danielfreeman.extendedMadness.UIScrollHorizontal;
	import com.danielfreeman.madcomponents.Attributes;
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class UIScrollHorizontalMaker extends UIScrollHorizontal
	{
		protected static const GAP:Number = 8.0;
		
		protected var _pureLayer:Sprite;
		protected var _gap:Number = GAP;
		protected var _originH:Number = 0;
		protected var _oddOffset:Number = 0;
		protected var expNum:int = 0;
		protected var _fingerDown:Boolean = false;
		private var _ueTimer:Timer = new Timer(50,1);
		public function UIScrollHorizontalMaker(screen:Sprite, width:Number, height:Number, offset:Number, style:String = "")
		{
			_originH = height;
			_oddOffset = offset;
			var attributes:Attributes = new Attributes(0, 0, width-offset, height);
			attributes.parse(XML("<null "+style+"/>"));
			super(screen,<null/>, attributes);
			_slider.addChild(_pureLayer = new Sprite());
			//scrollEnabled = false;
			this.addEventListener(MouseEvent.MOUSE_DOWN,ueListenerOn);
			_ueTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onUETimerComplete);
			super.scrollEnabled = false;
		}
		
		private function onUETimerComplete(e:TimerEvent):void {
			if (_fingerDown) {
				var sliderWidth:Number = _scrollerWidth>0 ? _scrollerWidth*_scale : _slider.width;
				if (sliderWidth > stage.fullScreenWidth) {
					super.scrollEnabled = true;
				}
			}
		}
		
		private function ueListenerOn(e:MouseEvent):void {
			_ueTimer.reset();
			_ueTimer.start();
			_fingerDown = true;
			this.addEventListener(MouseEvent.MOUSE_UP, ueListenerOff);
		}
		
		private function ueListenerOff(e:MouseEvent):void {
			this.removeEventListener(MouseEvent.MOUSE_UP, ueListenerOff);
			_fingerDown = false;
			//super.scrollEnabled = false;
		}
		
		public function get slideW():int {
			return _slider.width;
		}
		
		public function get pureW():int {
			return _pureLayer.width;
		}
		
		public function set gap(value:Number):void {
			_gap = Math.floor(value);
		}
		
		public function attach(child:DisplayObject):void {
			_pureLayer.addChild(child);
			adjustMaximumSlide();
		}
		
		override protected function adjustMaximumSlide():void {
			var sliderWidth:Number = _scrollerWidth>0 ? _scrollerWidth*_scale : _slider.width;
			_maximumSlide = sliderWidth - _width + _gap * (_border=="false" ? 0 : 2);
			if (_maximumSlide < 0)
				_maximumSlide = 0;
			if (_slider.x < -_maximumSlide)
				_slider.x = -_maximumSlide;
			
			if (stage){
				if (sliderWidth > stage.fullScreenWidth) {
					trace(sliderWidth + ' vs ' + stage.fullScreenWidth);
					scrollEnabled = true;
				}
			}
		}
		
		public function prependHorizontal(newChild:DisplayObject):void {
			var w:int = newChild.width;
			var n:int = _pureLayer.numChildren;
			var firstX:int = _pureLayer.getChildAt(n-1).x;
			for (var i:int = 0; i < _pureLayer.numChildren;i++){
				var child:DisplayObject = _pureLayer.getChildAt(i);
				child.x += (w+_gap);
			}
			newChild.x = firstX;
			_pureLayer.addChild(newChild);
			adjustMaximumSlide();
		}
		
		public function attachHorizontal(child:DisplayObject):void {
			
			var lastChild:DisplayObject = _pureLayer.numChildren>0 ? _pureLayer.getChildAt(_pureLayer.numChildren - 1) : null;
			_pureLayer.addChild(child);
			child.x = lastChild ? lastChild.x + lastChild.width + _gap : _gap;
			child.y = lastChild ? lastChild.y : 0;
			
			adjustMaximumSlide();
		}
		
		
		public function attachVertical(child:DisplayObject):void {
			var lastChild:DisplayObject = _pureLayer.numChildren>0 ? _pureLayer.getChildAt(_pureLayer.numChildren - 1) : null;
			_pureLayer.addChild(child);
			//child.x = lastChild ? lastChild.x : UI.PADDING;
			child.x = _gap;
			//child.y = lastChild ? lastChild.y + lastChild.height + _gap : UI.PADDING;
			child.y = lastChild ? lastChild.y + lastChild.height + _gap : 0;
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
		
		public function removeItem(child:*):void {
			_pureLayer.removeChild(child);
			attention();
		}
		
		public function attention():void {
			var nextX:int = _gap;
			for (var i:int = _pureLayer.numChildren-1; i>=0;i--){
				var thisChild:DisplayObject = getChildAt(i);
				thisChild.x = nextX;
				nextX = thisChild.x + thisChild.width + _gap; 
			}
			adjustMaximumSlide();
		}
		
		private function waitforFinish():void {
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
		
		public function get Children():Array {
			var arr:Array = [];
			for (var i:int = 0; i <_pureLayer.numChildren; i++){
				arr.push(_pureLayer.getChildAt(i));
			}
			
			return arr;
		}
		
		override public function clear():void {
			_pureLayer.removeChildren();
		}
		
		public function updateHeight(prMoreOffset:int = 0):void {
			//adjustMaximumSlide();
			//_maximumSlide = _pureLayer.numChildren * (_pureLayer.getChildAt(0).height-_oddOffset) - _originH - prMoreOffset;
			_maximumSlide = this.height-_originH;
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
		
		private var _associate:UIScrollVerticalMaker;
		
		public function set associate(prScroller:UIScrollVerticalMaker):void {
			_associate = prScroller;
			_associate.associate = this;
		}
		
		override protected function mouseMove(event:TimerEvent):void {
			if (_associate) {
				if (_associate.distance > 0) {
					
					return;
				}
			}
			
			if (!_noScroll) {
				_delta = -_slider.x;
				sliderX = _startSlider.x + (mouseX - _startMouse.x);
				_delta += _slider.x;
				_distance += Math.abs(_delta);
			}
			if (_distance > THRESHOLD) {
				showScrollBar();
			}
		}
		
		
	}
}
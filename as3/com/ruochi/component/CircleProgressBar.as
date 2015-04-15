package com.ruochi.component{
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.events.Event;
	import com.ruochi.shape.Rect;
	import com.ruochi.shape.LoaderShape;
	public class CircleProgressBar extends Sprite {
		private var _r1:Number = 10;
		private var _r2:Number = 16;
		private var _speed:Number = 5;
		private var _loaderColor:uint = 0xffffff;
		private var _bgColor:uint = 0;
		private var _circle:LoaderShape = new LoaderShape(_r1, _r2, _loaderColor);
		private var _bg:Rect;
		private var _w:Number;
		private var _h:Number;
		public function CircleProgressBar(w:Number=0,h:Number=0) {
			visible = false;
			_bg = new Rect(w, h);	
			buildUI();			
		}
		private function buildUI() {			
			_bg.alpha = .3;
			addChild(_bg)
			addChild(_circle);
			_circle.x = _bg.width / 2;
			_circle.y = _bg.height / 2;
		
		}
		private function onEnterFrame(e:Event){
			_circle.rotation += _speed;
		}
		public function start(){
			visible = true;
			addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);			
		}
		public function stop() {
			visible = false;
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);	
		}
		public function set loaderColor(col:Number) {
			_loaderColor = col;
			_circle.color = _loaderColor;
		}
		public function set bgColor(col:Number) {
			_bgColor = col;
			_bg.color = _bgColor;
		}
		public function get circle():LoaderShape{
			return _circle;
		}
		public function get bg():Rect {
			return _bg;
		}
	}
}
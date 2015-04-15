package com.ruochi.shape{
	import flash.display.Sprite;
	import flash.geom.Matrix;

	public class Rect extends Sprite {
		private var _color:uint = 0xffffff;
		private var _w:Number;
		private var _h:Number;
		private var _borderThickness:Number = 0;
		private var _borderColor:uint = 0x000000;
		private var _cached:Boolean = true;
		public function Rect(w:Number=100,h:Number=100,c:uint=0xffffff, borderThickness:Number = 0, borderColor:uint = 0x000000,cached:Boolean = true) {
			super();
			_cached = cached;
			_borderThickness = borderThickness;
			_borderColor = borderColor;
			_color = c;
			_w = w;
			_h = h;
			buildUI();
		}
		
		private function buildUI():void {
			graphics.clear();
			if (_borderThickness > 0){
				graphics.lineStyle(_borderThickness,_borderColor);
			}
			graphics.beginFill(_color);
			graphics.drawRect(0, 0, _w, _h);
			graphics.endFill();
			if (_cached) {
				this.cacheAsBitmap = true;
				this.cacheAsBitmapMatrix = new Matrix;
			}
		}
		public function set color(c:uint):void {
			_color = c;
			buildUI()
		}
		public function get color():uint {
			return _color;
		}
	}
}
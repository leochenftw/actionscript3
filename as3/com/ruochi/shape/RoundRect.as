package com.ruochi.shape{
	import flash.display.Sprite;
	import flash.geom.Rectangle;

	public class RoundRect extends Sprite {
		private var _w:Number;
		private var _h:Number;
		private var _r:Number;
		private var _color:uint;
		private var _borderThickness:Number = 0;
		private var _borderColor:uint = 0x000000;
		private var _backgroundAlpha:Number = 1;
		public function RoundRect(w:Number=100,h:Number=100,r:Number=10,c:uint=0xff0000,backgroundAlpha:Number = 1, borderThickness:Number = 0, borderColor:uint = 0x000000) {
			super()
			_w = w;
			_h = h;
			_r = r;
			_color = c;
			_backgroundAlpha = backgroundAlpha;
			_borderThickness = borderThickness;
			_borderColor = borderColor;
			buildUI();
		}
		public function buildUI():void {
			this.graphics.clear();
			if (_borderThickness > 0) {
				this.graphics.lineStyle(_borderThickness,_borderColor);
			}
			this.graphics.beginFill(_color,_backgroundAlpha);
            this.graphics.drawRoundRect(0, 0, _w, _h, _r * 2);
            this.graphics.endFill();
			if (_r > 0 && _r < _w / 2 && _r < _h / 2){
				this.scale9Grid = new Rectangle( _r, _r, _w - _r * 2, _h - _r * 2);
			}
		}
		
		public override function set height(value:Number):void {
			_h = value;
			this.graphics.clear();
			if (_borderThickness > 0) {
				this.graphics.lineStyle(_borderThickness,_borderColor);
			}
			this.graphics.beginFill(_color,_backgroundAlpha);
			this.graphics.drawRoundRect(0, 0, _w, _h, _r * 2);
			this.graphics.endFill();
			if (_r > 0 && _r < _w / 2 && _r < _h / 2){
				this.scale9Grid = new Rectangle( _r, _r, _w - _r * 2, _h - _r * 2);
			}
		}
		
		public function set color(c:uint):void {
			_color = c;
			buildUI();
		}
		public function get color():uint {
			return _color;
		}
		public function set corner(r:uint):void {
			_r = r;
			buildUI();
		}
	}
}
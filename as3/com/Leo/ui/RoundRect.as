package com.Leo.ui
{
	import flash.display.BitmapData;
	import flash.display.Shape;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	public class RoundRect extends Sprite
	{
		private var _image:Image;
		private var _w:Number;
		private var _h:Number;
		private var _c:uint;
		private var _r:Number;
		private var _a:Number;
		private var _borderThickness:Number;
		private var _borderColor:uint;
		private var _borderAlpha:Number;
		public function RoundRect(w:Number,h:Number,r:Number,c:uint,backgroundAlpha:Number = 1, borderThickness:Number = 0, borderColor:uint = 0x000000, borderAlpha:Number = 1)
		{
			super();
			_w = w;
			_h = h;
			_c = c;
			_r = r;
			_a = backgroundAlpha;
			_borderThickness = borderThickness;
			_borderColor = borderColor;
			_borderAlpha = borderAlpha;
			buildUI();
		}
		
		private function buildUI():void {
			var _shape:Shape = new Shape;
			_shape.graphics.clear();
			if (_borderThickness > 0) {
				_shape.graphics.lineStyle(_borderThickness,_borderColor,_borderAlpha);
			}
			_shape.graphics.beginFill(_c,_a);
			_shape.graphics.drawRoundRect(0, 0, _w, _h, _r * 2);
			_shape.graphics.endFill();
			var bmd:BitmapData = new BitmapData(_w,_h,true,0x000000);
			bmd.draw(_shape);
			
			var _texture:Texture = Texture.fromBitmapData(bmd);
			addChild(new Image(_texture));
		}
		
		public override function set height(value:Number):void {
			_h = value;
			if (_image && contains(_image)) {
				removeChild(_image);
				_image.dispose();
				buildUI();
			}
		}
		
		
	}
}
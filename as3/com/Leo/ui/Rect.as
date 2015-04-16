package com.Leo.ui
{
	import flash.display.BitmapData;
	import flash.display.Shape;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	public class Rect extends Sprite
	{
		private var _image:Image;
		private var _w:Number;
		private var _h:Number;
		private var _c:uint;
		private var _a:Number;
		private var _borderThickness:Number;
		private var _borderColor:uint;
		private var _borderAlpha:Number;
		public function Rect(w:Number,h:Number,c:uint,a:Number = 1, border_thickness:Number = 0, border_color: uint = 0x000000, border_alpha:Number = 1)
		{
			super();
			_w = w;
			_h = h;
			_c = c;
			_a = a;
			_borderThickness = border_thickness;
			_borderColor = border_color;
			_borderAlpha = border_alpha;
			buildUI();
		}
		
		private function buildUI():void {
			var _shape:Shape = new Shape;
			if (_borderThickness>0) {
				_shape.graphics.lineStyle(_borderThickness,_borderColor,_borderAlpha);
			}
			_shape.graphics.beginFill(_c,_a);
			_shape.graphics.drawRect(0,0,_w,_h);
			_shape.graphics.endFill();
			var bmd:BitmapData = new BitmapData(_w,_h,true,0x000000);
			bmd.draw(_shape);
			
			var _texture:Texture = Texture.fromBitmapData(bmd);
			_image = new Image(_texture)
			addChild(_image);
		}
		
		public override function set height(value:Number):void {
			_h = value;
			if (_image && contains(_image)) {
				removeChild(_image);
				_image.dispose();
				buildUI();
			}
		}
		
		public static function CreateRect(w:Number,h:Number,c:uint,a:Number = 1, border_thickness:Number = 0, border_color: uint = 0x000000, border_alpha:Number = 1):Image {
			var _shape:Shape = new Shape;
			if (border_thickness>0) {
				_shape.graphics.lineStyle(border_thickness,border_color,border_alpha);
			}
			_shape.graphics.beginFill(c,a);
			_shape.graphics.drawRect(0,0,w,h);
			_shape.graphics.endFill();
			var bmd:BitmapData = new BitmapData(w,h,true,0x000000);
			bmd.draw(_shape);
			
			var _texture:Texture = Texture.fromBitmapData(bmd,false);
			return (new Image(_texture));
		}
		
		public static function CreateTransMask(w:Number, h:Number):Image {
			var _shape:Shape = new Shape;
			_shape.graphics.beginFill(0xffffff,0);
			_shape.graphics.drawRect(0,0,w,h);
			_shape.graphics.endFill();
			var bmd:BitmapData = new BitmapData(w,h,true,0x000000);
			bmd.draw(_shape);
			var _texture:Texture = Texture.fromBitmapData(bmd);
			return (new Image(_texture));
		}
	}
}
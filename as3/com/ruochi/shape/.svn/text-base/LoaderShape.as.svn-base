package com.ruochi.shape{
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	public class LoaderShape extends Sprite {
		private var _r1:Number;
		private var _r2:Number;
		private var _color:uint;
		public function LoaderShape(r1:Number=10,r2:Number=16,c:uint=0xff0000) {
			super()
			_r1 = r1;
			_r2 = r2;
			_color = c;
			buildUI();
		}
		private function buildUI():void {
			this.graphics.beginFill(_color);
			this.graphics.moveTo(_r1, 0);
			this.graphics.curveTo(_r1, Math.tan(Math.PI/8)*_r1, Math.sin(Math.PI/4)*_r1, Math.sin(Math.PI/4)*_r1);
			this.graphics.curveTo(Math.tan(Math.PI/8)*_r1, _r1, 0, _r1);
			this.graphics.curveTo(-Math.tan(Math.PI/8)*_r1, _r1, -Math.sin(Math.PI/4)*_r1, Math.sin(Math.PI/4)*_r1);
			this.graphics.curveTo(-_r1, Math.tan(Math.PI/8)*_r1, -_r1, 0);
			this.graphics.curveTo(-_r1, -Math.tan(Math.PI/8)*_r1, -Math.sin(Math.PI/4)*_r1, -Math.sin(Math.PI/4)*_r1);
			this.graphics.curveTo(-Math.tan(Math.PI/8)*_r1, -_r1, 0, -_r1);
			this.graphics.curveTo(Math.tan(Math.PI/8)*_r1, -_r1, Math.sin(Math.PI/4)*_r1, -Math.sin(Math.PI/4)*_r1);
			this.graphics.lineTo(Math.sin(Math.PI/4)*_r2, -Math.sin(Math.PI/4)*_r2);
			this.graphics.curveTo(Math.tan(Math.PI/8)*_r2, -_r2,0, -_r2 );
			this.graphics.curveTo(-Math.tan(Math.PI/8)*_r2, -_r2, -Math.sin(Math.PI/4)*_r2, -Math.sin(Math.PI/4)*_r2 );
			this.graphics.curveTo(-_r2, -Math.tan(Math.PI/8)*_r2,-_r2, 0);
			this.graphics.curveTo(-_r2, Math.tan(Math.PI/8)*_r2,  -Math.sin(Math.PI/4)*_r2, Math.sin(Math.PI/4)*_r2);
			this.graphics.curveTo(-Math.tan(Math.PI/8)*_r2, _r2, 0, _r2);
			this.graphics.curveTo(Math.tan(Math.PI/8)*_r2, _r2,Math.sin(Math.PI/4)*_r2, Math.sin(Math.PI/4)*_r2);
			this.graphics.curveTo(_r2, Math.tan(Math.PI/8)*_r2,  _r2, 0);
			this.graphics.lineTo(_r1, 0);
			this.graphics.endFill();
		}
		public function set color(c:uint):void {
			_color = c;
			buildUI();
		}
		public function get color():uint {
			return _color;
		}
	}
}
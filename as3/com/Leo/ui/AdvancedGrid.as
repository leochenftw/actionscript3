package com.Leo.ui
{
	import com.Leo.events.GridEvent;
	import com.greensock.BlitMask;
	import com.greensock.TweenLite;
	import com.greensock.easing.*;
	import com.greensock.plugins.*;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	TweenPlugin.activate([ThrowPropsPlugin]);
	
	public class AdvancedGrid extends Sprite
	{
		private var _numX:int = 0;
		private var _numY:int = 0;
		private var _borderThickness:Number;
		private var _borderColor:uint;
		private var _c:int;
		private var _w:int;
		private var _h:int;
		private var _gap:int = 0;
		private var t1:uint, t2:uint, y1:Number, y2:Number, x1:Number, x2:Number, xOverlap:Number, xOffset:Number, yOverlap:Number, yOffset:Number;
		private var _grid:Sprite = new Sprite;
		private var bounds:Rectangle;
		private var blitMask:BlitMask;
		
		public function AdvancedGrid(w:int, h:int, gap:int, numX:int, numY:int,borderThickness:Number,borderColor: uint,c:int)
		{
			_w = w;
			_h = h;
			_gap = gap;
			_numX = numX;
			_numY = numY;
			_c = c;
			_borderThickness = borderThickness;
			_borderColor = borderColor;
			drawGrid();
			addChild(_grid);
			bounds = new Rectangle(0,0,_w,_h);
			
			
			blitMask = new BlitMask(_grid, 0, 0, _w, _h, false);
			
			blitMask.addEventListener(MouseEvent.MOUSE_DOWN, mousedownHandler);
			
		}
		
		private function drawGrid(prX:Number = 0, prY:Number = 0):void {
			
			_grid.graphics.clear();
			_grid.graphics.lineStyle(_borderThickness,_borderColor,0.5);
			_grid.graphics.beginFill(0x000000,0.1);
			_grid.graphics.drawRect(prX,prY,_numX*_c,_c);
			_grid.graphics.endFill();
			
			for (var i:int = 0; i <= _numX; i++){
				_grid.graphics.moveTo(prX + i*_c, prY + _c+2 + _gap);
				_grid.graphics.lineTo(prX + i*_c, prY+_c*_numY + _c+2 + _gap);
			}
			for (var n:int = 0; n <= _numY; n++){
				_grid.graphics.moveTo(prX, prY + n*_c + _c+2 + _gap);
				_grid.graphics.lineTo(prX+_numX*_c, prY + n*_c + _c+2 + _gap);
			}
			
			_grid.graphics.beginFill(0x000000,0.1);
			_grid.graphics.drawRect(prX,prY + _numY*_c + _c+2 + _gap*2, _numX*_c, _c);
			_grid.graphics.endFill();
			
		}
		
		protected function mousedownHandler(e:MouseEvent):void
		{
			TweenLite.killTweensOf(_grid);
			x1 = x2 = _grid.x;
			xOffset = this.mouseX - _grid.x;
			xOverlap = Math.max(0, _grid.width - _w);
			y1 = y2 = _grid.y;
			yOffset = this.mouseY - _grid.y;
			yOverlap = Math.max(0, _grid.height - _h);
			t1 = t2 = getTimer();
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			dispatchEvent(new GridEvent(GridEvent.ON_START));
		}
		
		protected function mouseUpHandler(e:MouseEvent):void
		{
			_grid.stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			_grid.stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			var time:Number = (getTimer() - t2) / 1000;
			var xVelocity:Number = (_grid.x - x2) / time;
			var yVelocity:Number = (_grid.y - y2) / time;
			ThrowPropsPlugin.to(_grid, {throwProps:{
				y:{velocity:yVelocity, max:bounds.top, min:bounds.top - yOverlap, resistance:300},
				x:{velocity:xVelocity, max:bounds.left, min:bounds.left - xOverlap, resistance:300}
			}, onUpdate:function():void{
				blitMask.update();
				dispatchEvent(new GridEvent(GridEvent.ON_UPDATE));
			}, onComplete:function():void {
				dispatchEvent(new GridEvent(GridEvent.ON_COMPLETE));
			}, ease:Strong.easeOut
			}, 10, 0.3, 1);
		}
		
		protected function mouseMoveHandler(e:MouseEvent):void
		{
			var y:Number = this.mouseY - yOffset;
			//if mc's position exceeds the bounds, make it drag only half as far with each mouse movement (like iPhone/iPad behavior)
			if (y > bounds.top) {
				_grid.y = (y + bounds.top) * 0.5;
			} else if (y < bounds.top - yOverlap) {
				_grid.y = (y + bounds.top - yOverlap) * 0.5;
			} else {
				_grid.y = y;
			}
			var x:Number = this.mouseX - xOffset;
			if (x > bounds.left) {
				_grid.x = (x + bounds.left) * 0.5;
			} else if (x < bounds.left - xOverlap) {
				_grid.x = (x + bounds.left - xOverlap) * 0.5;
			} else {
				_grid.x = x;
			}
			blitMask.update();
			var t:uint = getTimer();
			//if the frame rate is too high, we won't be able to track the velocity as well, so only update the values 20 times per second
			if (t - t2 > 50) {
				x2 = x1;
				x1 = _grid.x;
				y2 = y1;
				t2 = t1;
				y1 = _grid.y;
				t1 = t;
			}
			
			dispatchEvent(new GridEvent(GridEvent.ON_UPDATE));
			e.updateAfterEvent();
		}
		public override function get x():Number {
			return _grid.x;
		}
		
		public override function get y():Number {
			return _grid.y;
		}
	}
}
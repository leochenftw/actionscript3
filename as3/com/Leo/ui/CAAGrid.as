package com.Leo.ui
{
	import com.Leo.events.GridEvent;
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	
	public class CAAGrid extends Sprite
	{
		private var _numX:int = 0;
		private var _numY:int = 0;
		private var _borderThickness:Number;
		private var _borderColor:uint;
		private var _c:int;
		private var _grid:Sprite = new Sprite;
		private var _mask:Shape = new Shape;
		private var _w:int;
		private var _h:int;
		private var _landX:Number;
		private var _landY:Number;
		
		private var _pivitX:Number;
		private var _pivitY:Number;
		private var _incr:int = 1;
		private var _xy:Object = {x:0,y:0};
		private var _tween:TweenMax;
		private var vX:Number = 0;
		private var vY:Number = 0;
		private var _gap:int = 0;
		private var _gridWidth:int;
		private var _gridHeight:int;
		
		private var _nowX:Number;
		private var _nowY:Number;
		public function CAAGrid(w:int, h:int, gap:int, numX:int, numY:int,borderThickness:Number,borderColor: uint,c:int)
		{
			_w = w;
			_h = h;
			_gap = gap;
			_numX = numX;
			_numY = numY;
			_c = c;
			
			addChild(_grid);
			_mask.graphics.beginFill(0x000000,1);
			_mask.graphics.drawRect(0,0,w+1,h+1);
			_mask.graphics.endFill();
			addChild(_mask);
			_grid.mask = _mask;
			_borderThickness = borderThickness;
			_borderColor = borderColor;
			drawGrid(vX,vY);
			_gridWidth = _numX*_c +2;
			_gridHeight = _gap*2 + 2 + (_numY+2)*_c;
			this.addEventListener(Event.ADDED_TO_STAGE, ontoStage);
		}
		
		protected function ontoStage(e:Event):void
		{
			if (_grid.width > stage.fullScreenWidth || _grid.height > stage.fullScreenHeight) {
				stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			}else{
				this.removeEventListener(Event.ADDED_TO_STAGE, ontoStage);
			}
		}
		
		protected function mouseDown(e:MouseEvent):void
		{
			if (_tween) _tween.kill();
			dispatchEvent(new GridEvent(GridEvent.ON_START));
			_landX = stage.mouseX;
			_landY = stage.mouseY;
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
			stage.addEventListener(Event.ENTER_FRAME, updateGrid);
		}		
		
		protected function mouseUp(e:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
			stage.removeEventListener(Event.ENTER_FRAME, updateGrid);
						
			var thisX:int = this.x;
			var thisY:int = this.y;
			vX = _xy.x = _pivitX;
			vY = _xy.y = _pivitY;
			
			var speed:Number = 1/Math.sqrt(Math.pow((stage.mouseX-_nowX),2) + Math.pow((stage.mouseY-_nowY),2));
			
			_tween = TweenMax.to(_xy,speed,{
				ease: Linear.easeNone,
				x:_pivitX+(stage.mouseX-_nowX)*3,
				y:_pivitY+(stage.mouseY-_nowY)*3,
				onComplete:function():void {
					if (_pivitX > 0 || _pivitY > 0 || _pivitX + _numX*_c < _w || _pivitY + _numY*_c < _h) {
						var tx:int = _pivitX;
						var ty:int = _pivitY;
						if (_pivitX>0) {
							tx = 0;
						}else if (_pivitX + _gridWidth < _w) {
							tx = _w-_gridWidth-thisX;
						}
						if (_pivitY>0) {
							ty = 0;
						}else if (_pivitY + _gridHeight < _h) {
							ty = _h-_gridHeight-thisY;
						}
						_tween = TweenMax.to(_xy,0.25,{
							ease: Linear.easeNone,
							x:tx,
							y:ty,
							onUpdate:function():void {
								drawGrid(_xy.x,_xy.y);
								vX = _xy.x;
								vY = _xy.y;
								dispatchEvent(new GridEvent(GridEvent.ON_UPDATE));
							},
							onComplete:function():void {
								dispatchEvent(new GridEvent(GridEvent.ON_COMPLETE));
							}
						});
					}else{
						dispatchEvent(new GridEvent(GridEvent.ON_COMPLETE));
					}
				}
			});
		}
		
		
		protected function updateGrid(e:Event):void {
			_nowX = stage.mouseX;
			_nowY = stage.mouseY;
			if (stage.mouseX - _landX != 0 && stage.mouseY - _landY != 0) {
				drawGrid(vX + (stage.mouseX - _landX), vY + (stage.mouseY - _landY));
			}
		}
		
		private function drawGrid(prX:Number = 0, prY:Number = 0):void {
			_pivitX = prX;
			_pivitY = prY;
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
			
			dispatchEvent(new GridEvent(GridEvent.ON_UPDATE));
		}
		
		public function get gridx():Number {
			return _pivitX;
		}
		
		public function get gridy():Number {
			return _pivitY;
		}
	}
}



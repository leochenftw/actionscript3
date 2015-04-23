package com.Leo.ui
{
	import com.danielfreeman.madcomponents.UILabel;
	import com.greensock.BlitMask;
	
	import flash.display.Sprite;
	import flash.text.TextFormat;
	
	public class CAAWindGrid extends Sprite
	{
	
		private var _gh:int;
		private var _w:int;
		private var _h:int;
		private var _grid:Sprite = new Sprite;
		private var blitMask:BlitMask;
		private var _bt:Number,_bc:uint;
		private var _gap:int = 0;
		public function CAAWindGrid(gridWidth:int, gridHeight:int, viewportHeight:int, gap:int, bt:Number = 1, bc:uint = 0xffffff)
		{
			_gh = gridHeight;
			_w = gridWidth;
			_h = viewportHeight;
			_bt = bt;
			_bc = bc;
			_gap = gap;
			var format:TextFormat = new TextFormat('Myriad Pro',_gh*0.4,_bc,true,null,null,null,null,'center');
			var lblWind:UILabel = new UILabel(this,_gap,_gap,'WIND',format);
			
			_grid.graphics.lineStyle(_bt,_bc,0.8);
			_grid.graphics.beginFill(0x000000,0.1);
			_grid.graphics.drawRect(0,0,_w-1,_gh);
			_grid.graphics.endFill();
			
			_grid.graphics.beginFill(0xffffff,0);
			_grid.graphics.drawRect(0,_gap+_gh,_w-1,_gh*10-1);
			_grid.graphics.endFill();
			
			for (var i:int = 1; i < 10; i++){
				_grid.graphics.moveTo(0,_gh*i+_gap+_gh);
				_grid.graphics.lineTo(_w-1,_gh*i+_gap+_gh);
			}
			
			addChild(_grid);
			blitMask = new BlitMask(_grid, 0, 0, _w, _h, false);
		}
		
		
		public function get gridY():Number {
			return _grid.y;
		}
		
		public function set gridY(n:Number):void {
			_grid.y = n;
			blitMask.update();
		}
		
	}
}


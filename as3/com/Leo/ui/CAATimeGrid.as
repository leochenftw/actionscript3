package com.Leo.ui
{
	import com.danielfreeman.madcomponents.UILabel;
	import com.greensock.BlitMask;
	
	import flash.display.Sprite;
	import flash.text.TextFormat;
	
	public class CAATimeGrid extends Sprite
	{
		private var _st:Number;
		private var _et:Number;
		private var _gw:int;
		private var _w:int;
		private var _h:int;
		private var _grid:Sprite = new Sprite;
		private var blitMask:BlitMask;
		private var _bt:Number,_bc:uint;
		public function CAATimeGrid(startTime:Number, endTime:Number, gridWidth:int, viewportWidth:int, viewportHeight:int, bt:Number = 1, bc:uint = 0xffffff)
		{
			_st = startTime-1;
			_et = endTime+1;
			_gw = gridWidth;
			_w = viewportWidth;
			_h = viewportHeight;
			_bt = bt;
			_bc = bc;
			var format:TextFormat = new TextFormat('Myriad Pro',_h*0.5,_bc,null,null,null,null,null,'center');
			var dif:Number = _et - _st;
			var numGrid:Number = int(dif)==dif?(dif*2):(dif*2)+1;
			
			_grid.graphics.lineStyle(_bt,_bc,0.8);
			_grid.graphics.beginFill(0x4791E5,0.8);
			_grid.graphics.drawRect(0,0,numGrid*_gw,_h-1);
			_grid.graphics.endFill();
			
			for (var i:int = 0; i < numGrid; i++){
				_grid.graphics.moveTo(i*_gw,0);
				_grid.graphics.lineTo(i*_gw,_h-1);
				var lblTime:UILabel = new UILabel(_grid,i*_gw,0,toTime((_st+i*0.5)),format);
				lblTime.fixwidth = _gw;
				lblTime.y = Math.round((_h - lblTime.height)*0.5);
			}
			
			addChild(_grid);
			blitMask = new BlitMask(_grid, 0, 0, _w, _h, false);
		}
		
		private function toTime(n:Number):String
		{
			var s:String = '';
			s = int(Math.floor(n)).toString();
			if (int(Math.floor(n)) < 10) s = '0' + s;
			if (int(n) != n) {
				s += '30';
			}else{
				s += '00';
			}
			return s;
		}
		
		public function get gridX():Number {
			return _grid.x;
		}
		
		public function set gridX(n:Number):void {
			_grid.x = n;
			blitMask.update();
		}
		
	}
}
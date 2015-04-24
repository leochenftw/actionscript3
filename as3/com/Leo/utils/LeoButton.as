package com.Leo.utils
{
	import com.danielfreeman.madcomponents.UILabel;
	
	import flash.display.Sprite;
	import flash.text.TextFormat;

	public class LeoButton extends Sprite
	{
		private var _bg:Sprite = new Sprite;
		private var _label:UILabel;
		private var _border:int;
		private var _borderColor:uint;
		private var _bgOpacity:Number;
		private var _bgColor:uint;
		private var _h:int,_r:int;
		private var _w:int = 0;
		public function LeoButton(h:int, r:int, txt:String, txtColor:uint = 0xffffff, bgColor:uint = 0x666666, bgOpacity:Number = 1, fontRatio:Number = 0.6, border:int = 0, borderColor:uint = 0x000000)
		{
			_label = new UILabel(this,0,0,txt, new TextFormat("Myriad Pro", fontRatio*(border==0?h:h-2*border),txtColor,null,null,null,null,null,"center"));
			
			_h = h;
			_r = r;
			_bgColor = bgColor;
			_border = border;
			_borderColor = borderColor;
			_bgOpacity = bgOpacity;
			drawBG();
		}
		
		private function drawBG():void {
			_bg.graphics.clear();
			if (_border > 0){
				_bg.graphics.lineStyle(_border,_borderColor);
			}
			_bg.graphics.beginFill(_bgColor,_bgOpacity);
			_bg.graphics.drawRoundRect(0,0,_w>0?_w:Math.round(_label.width*1.2)+2*_border,_h,_r * 2);
			_bg.graphics.endFill();
			
			addChildAt(_bg,0);
			
			_label.x = (_bg.width - _label.width)*0.5;
			_label.y = Math.round((_bg.height - _label.height*2 + _label.textHeight)*0.5);
		}
		
		public function set bgAlpha(n:Number):void {
			_bgOpacity = n;
			drawBG();
		}
		
		public override function set width(value:Number):void {
			_w = value;
			_label.x = 0;
			_label.fixwidth = value;
			drawBG();
		}
		
		public function get labelObject():UILabel {
			return _label;
		}
		
		public function get label():String {
			return _label.text;
		}
		
		public function set label(s:String):void {
			_label.text = s;
			drawBG();
		}
	}
}
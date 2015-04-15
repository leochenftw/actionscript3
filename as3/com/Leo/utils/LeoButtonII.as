package com.Leo.utils
{
	import com.danielfreeman.madcomponents.UILabel;
	import com.ruochi.shape.RoundRect;
	
	import flash.display.Sprite;
	import flash.text.TextFormat;

	public class LeoButtonII extends Sprite
	{
		private var _bg:RoundRect;
		private var _label:UILabel;
		private var _border:int;
		private var _borderColor:uint;
		private var _bgColor:uint;
		private var _innerBG:RoundRect;
		private var _h:int,_r:int;
		public function LeoButtonII(h:int, r:int, txt:String, txtColor:uint = 0xffffff, bgColor:uint = 0x666666, bgOpacity:Number = 1, fontRatio:Number = 0.6, border:int = 0, borderColor:uint = 0x000000)
		{
			_label = new UILabel(this,0,0,txt, new TextFormat("Myriad Pro", fontRatio*(border==0?h:h-2*border),txtColor,null,null,null,null,null,"center"));
			
			_bg = new RoundRect(int(_label.width*1.2)+2*border,h,r,border==0?bgColor:borderColor);
			
			
			if (border > 0){
				_innerBG = new RoundRect(_bg.width - 2*border,h-2*border,r,bgColor);
				_innerBG.x = _innerBG.y = border;
				addChildAt(_innerBG,0);
			}
			
			addChildAt(_bg,0);
			
			
			_bg.alpha = bgOpacity;
			_label.x = (_bg.width - _label.width)*0.5;
			_label.y = (_bg.height - _label.height)*0.5;
			
			_h = h;
			_r = r;
			_bgColor = bgColor;
			_border = border;
			_borderColor = borderColor;
		}
		
		public override function set width(value:Number):void {
			_label.x = 0;
			_label.fixwidth = value;
			removeChild(_bg);
			if (_innerBG){
				removeChild(_innerBG);
			}
			_bg = new RoundRect(value+2*_border,_h,_r,_border==0?_bgColor:_borderColor);
			
			if (_border > 0){
				_innerBG = new RoundRect(_bg.width - 2*_border,_h-2*_border,_r,_bgColor);
				_innerBG.x = _innerBG.y = _border;
				addChildAt(_innerBG,0);
			}
			addChildAt(_bg,0);
		}
		
		public function get labelObject():UILabel {
			return _label;
		}
		
		public function get label():String {
			return _label.text;
		}
		
		public function set label(s:String):void {
			removeChild(_bg);
			removeChild(_innerBG);
			var rGap:int = 0;
			if (stage) {
				if (this.x >= stage.fullScreenWidth*0.5){
					rGap = stage.fullScreenWidth-this.width - this.x;
				}
			}
			trace('before: ' + _label.width);
			_label.text = s;
			trace('after: ' + _label.width);
			_bg = new RoundRect(int(_label.width*1.2)+2*_border,_h,_r,_border==0?_bgColor:_borderColor);
			
			if (_border > 0){
				_innerBG = new RoundRect(_bg.width - 2*_border,_h-2*_border,_r,_bgColor);
				_innerBG.x = _innerBG.y = _border;
				addChildAt(_innerBG,0);
			}
			addChildAt(_bg,0);
			_label.x = (_bg.width - _label.width)*0.5;
			_label.y = (_bg.height - _label.height)*0.5;
			
			if (rGap > 0){
				if (stage){
					//if (this.x + this.width > stage.fullScreenWidth) {
						this.x = stage.fullScreenWidth - this.width - rGap;
					//}
				}
			}
		}
	}
}
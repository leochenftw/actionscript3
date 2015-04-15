package com.Leo.utils
{	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	
	public class LeoCheckbox extends Sprite
	{
		private var _h:int = 0;
		private var _box:Shape;
		private var _txt:TextField;
		private var _tick:Sprite = new Sprite;
		private var _fcolor:uint;
		public function LeoCheckbox(h:int,s:String = '', b:Boolean = false, fcolor:uint = 0x333333)
		{
			_h = h;
			_fcolor = fcolor;
			_box = new Shape();
			_box.graphics.beginFill(0xffffff);
			_box.graphics.drawRect(0,0,h,h);
			_box.graphics.endFill();
			_box.graphics.lineStyle(1, 0x999999,1);
			_box.graphics.lineTo(h,0);
			_box.graphics.lineTo(h,h);
			_box.graphics.lineTo(0,h);
			_box.graphics.lineTo(0,0);
			
			addChild(_box);
			
			_txt = new TextField();
			_txt.text = s;
			_txt.setTextFormat(new TextFormat('Myriad Pro',_h*0.8,_fcolor));
			_txt.x = int(h*1.5);
			addChild(_txt);
			_txt.selectable = false;
			_txt.autoSize = "left";
			//_txt.width = _txt.textWidth*1.2;
			
			_tick.graphics.lineStyle(5, 0x333333);
			var hh:Number = h*1.1;
			_tick.graphics.moveTo(0, hh*0.6);
			_tick.graphics.lineTo(hh*0.4,hh);
			_tick.graphics.lineTo(hh,0);
			addChild(_tick);
			if (!b) {
				_tick.visible = false;
			}
			
			this.addEventListener(MouseEvent.CLICK,checkThis);
		}
		
		private function checkThis(e:MouseEvent):void {
			_tick.visible = _tick.visible?false:true;
		}
		
		public function set label(s:String):void {
			_txt.text = s;
		}
		
		public function get label():String {
			return _txt.text;
		}
		
		public function set cb(b:Boolean):void {
			_tick.visible = b;
		}
		
		public function get cb():Boolean {
			return _tick.visible;
		}
		
	}
}
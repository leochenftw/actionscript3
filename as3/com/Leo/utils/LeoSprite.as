package com.Leo.utils
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class LeoSprite extends Sprite
	{
		protected var _width:Number = 0;
		protected var _height:Number = 0;
		protected var _bgColor:uint = 0xfffff;
		public function LeoSprite(bgColor:uint = 0xffffff)
		{
			_bgColor = bgColor;
			if (stage){
				init();
			}else{
				addEventListener(Event.ADDED_TO_STAGE, init);
			}
		}
		
		protected function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		public override function set width(value:Number):void {
			_width = value;
			this.graphics.clear();
			this.graphics.beginFill(_bgColor,1);
			this.graphics.drawRect(0,0,value,this.height);
			this.graphics.endFill();
		}
		
		public override function set height(value:Number):void {
			_height = value;
			this.graphics.clear();
			this.graphics.beginFill(_bgColor,1);
			this.graphics.drawRect(0,0,this.width,value);
			this.graphics.endFill();
		}
		
		public override function get width():Number {
			return _width;
		}
		
		public override function get height():Number {
			return _height;
		}
		
	}
}
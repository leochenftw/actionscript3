package com.Leo.utils
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class LeoSprite extends Sprite
	{
		public function LeoSprite()
		{
			if (stage){
				init();
			}else{
				addEventListener(Event.ADDED_TO_STAGE, init);
			}
		}
		
		protected function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}
		
	}
}
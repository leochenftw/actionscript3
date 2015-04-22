package com.Leo.events
{
	import flash.events.Event;
	
	public class GridEvent extends Event
	{
		public static const ON_START:String = 'onStart';
		public static const ON_UPDATE:String = 'onUpdate';
		public static const ON_COMPLETE:String = 'onComplete';
		public function GridEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		public override function clone():Event {
			return new GridEvent(type,bubbles,cancelable);
		}
	}
}
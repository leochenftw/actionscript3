package com.Leo.events
{
	import flash.events.Event;
	
	public class LeoCamEvent extends Event
	{
		
		public static const COMPLETE:String = 'Complete';
		public function LeoCamEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		public override function clone():Event {
			return new LeoCamEvent(type,bubbles,cancelable);
		}
	}
}
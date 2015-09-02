package com.Leo.utils
{
	import flash.system.Capabilities;

	public class os
	{
		public function os()
		{
		}
		
		public static function get isApple():Boolean {
			return (Capabilities.version.indexOf('IOS') > -1);
		}
		
		public static function get OS():String {
//			trace(Capabilities.version);
			var rs:String = 'God knows what';
			if (Capabilities.version.indexOf('IOS') > -1) {
				rs = 'iOS';
			}
			
			if (Capabilities.version.indexOf('AND') > -1) {
				rs = 'Android';
			}
			return rs;
		}
	}
}
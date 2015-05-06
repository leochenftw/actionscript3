package com.Leo.utils {
	
	import flash.events.Event;
	import flash.net.NetworkInfo;
	import flash.net.NetworkInterface;
	
	public class checkInternet {
		public function checkInternet(onConnectivityFunction:Function = null) {
			var supported:Boolean = flash.net.NetworkInfo.isSupported;
			if (supported){
				flash.net.NetworkInfo.networkInfo.addEventListener(Event.NETWORK_CHANGE,function(e:Event):void {
					trace(e);
					if (onConnectivityFunction) onConnectivityFunction();
				});
			}else{
				
			}
		}
		
		public static function get hasInternet():Boolean {
			var b:Boolean = false;
			var supported:Boolean = flash.net.NetworkInfo.isSupported;
			if (supported){
				var interfaces:Vector.<flash.net.NetworkInterface> = flash.net.NetworkInfo.networkInfo.findInterfaces();
				for(var i:uint = 0; i < interfaces.length; i++) {
					trace(interfaces[i].name +': ' + interfaces[i].active);
					if(interfaces[i].name.toLowerCase() == "wifi" && interfaces[i].active) {
						b = true;
						break;
					} else if(interfaces[i].name.toLowerCase() == "mobile" && interfaces[i].active) {
						b = true;
						break;
					}
					
					if ((interfaces[i].displayName.toLowerCase().indexOf("local area connection") > -1)&&(interfaces[i].active)){
						b = true;
						break;
					}
				}
			}
			return b;
		}
	}
	
}
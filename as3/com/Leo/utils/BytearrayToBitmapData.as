package com.Leo.utils
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	public function BytearrayToBitmapData(ba:ByteArray,callback:Function):void
	{
		var _imageLdr:Loader = new Loader();
		_imageLdr.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e:Event):void {
			var bitmap:Bitmap = e.target.loader.content as Bitmap;
			callback(bitmap.bitmapData);
		});
		_imageLdr.loadBytes(ba);
	}
	
	
}



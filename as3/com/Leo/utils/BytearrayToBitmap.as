package com.Leo.utils
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.utils.ByteArray;

	public function BytearrayToBitmap(ba:ByteArray,callback:Function,cid:int = 0):void
	{
		var _imageLdr:Loader = new Loader();
		_imageLdr.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e:Event):void {
			var bitmap:Bitmap = e.target.loader.content as Bitmap;
			bitmap.smoothing = true;
			if (cid >0){
				callback(bitmap,ba,cid);
			}else{
				callback(bitmap,ba);
			}
		});
		_imageLdr.loadBytes(ba);
	}
	
	
}
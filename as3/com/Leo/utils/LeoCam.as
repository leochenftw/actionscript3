package com.Leo.utils
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.media.CameraRoll;
	import com.Leo.events.LeoCamEvent

	public class LeoCam extends Sprite
	{
		private var _cameraRoll:CameraRoll;
		public function LeoCam()
		{
			if (CameraRoll.supportsAddBitmapData && CameraRoll.supportsBrowseForImage) {
				_cameraRoll = new CameraRoll;
			}else{
				trace('device not supported');
			}
		}
		
		public function saveImage(image:DisplayObject):void {
			if (_cameraRoll) {
				var bmd:BitmapData = new BitmapData(image.width,image.height,true,0x000000);
				bmd.draw(image);
				_cameraRoll.addEventListener(Event.COMPLETE, doneSaving);
				_cameraRoll.addBitmapData(bmd);
			}else{
				trace('device not supported');
			}
		}
		
		private function doneSaving(e:Event):void {
			dispatchEvent(new LeoCamEvent(LeoCamEvent.COMPLETE));
		}
	}
}
package com.Leo.utils
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class LeoWalkthrough extends Sprite
	{
		private var _screenOverlay:Sprite = new Sprite;
		private var _viewportWidth:int;
		private var _slides:Vector.<Bitmap> = new Vector.<Bitmap>;
		private var _idx:int = 0;
		public function LeoWalkthrough(viewportWidth:int, bitmapVector:Vector.<Bitmap>)
		{
			_viewportWidth = viewportWidth;
			
			for (var i:int = 0; i < bitmapVector.length; i++) {
				var bmp:Bitmap = LeoBitmapResizer.resize(bitmapVector[i] as Bitmap,viewportWidth,0);
				_slides.push(_slides);
				(bitmapVector[i] as Bitmap).bitmapData.dispose();
				bitmapVector[i] = null;
			}
			
			bitmapVector = null;
			this.addEventListener(Event.ADDED_TO_STAGE,toStage);
		}
		
		protected function toStage(e:Event):void
		{
			_screenOverlay.graphics.clear();
			_screenOverlay.graphics.beginFill(0x000000,0.9);
			_screenOverlay.graphics.drawRect(0,0,stage.fullScreenWidth,stage.fullScreenHeight);
			_screenOverlay.graphics.endFill();
			stage.addChild(_screenOverlay);
			stage.addEventListener(MouseEvent.CLICK,clickHandler);
		}		
		
		protected function clickHandler(e:MouseEvent):void
		{
			if (_idx < _slides.length-1) {
				this.removeChildren();
				this.addChild(_slides[_idx]);
				pos(_slides[_idx]);
				_idx++;
			}else{
				_idx = 0;
				stage.removeEventListener(MouseEvent.CLICK,clickHandler);
				stage.removeChild(_screenOverlay);
				stage.removeChild(this);
			}
		}
		
		protected function pos(bmp:Bitmap):void {
			bmp.x = Math.round((stage.fullScreenWidth - bmp.width)*0.5);
			bmp.x = Math.round((stage.fullScreenHeight - bmp.height)*0.5);
		}
		
	}
}
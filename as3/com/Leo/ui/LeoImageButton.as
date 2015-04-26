package com.Leo.ui
{
	import com.Leo.utils.LeoBitmapResizer;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	public class LeoImageButton extends Sprite
	{
		private var _bgColor:uint;
		private var _image:Bitmap;
		public function LeoImageButton(w:int, h:int, bgColor:uint, image:Bitmap, percent:Number = 0.4)
		{
			_bgColor = bgColor;
			this.graphics.beginFill(bgColor,1);
			this.graphics.drawRect(0,0,w,h);
			this.graphics.endFill();
			
			_image = LeoBitmapResizer.resize(image,0,this.height*percent);
			
			_image.x = Math.round((this.width - _image.width)*0.5);
			_image.y = Math.round((this.height - _image.height)*0.5);
			
			addChild(_image);
		}
		
		public function dispose():void {
			removeChild(_image);
			_image.bitmapData.dispose();
			_image = null;
			this.graphics.clear();
		}
	}
}
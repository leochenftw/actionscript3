package com.Leo.utils
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.geom.Matrix;

	public class LeoBitmapResizer
	{
		public function LeoBitmapResizer()
		{
		}
		
		public static function resize(bitmap:Bitmap,prW:int=0, prH:int=0):Bitmap {
			var scale:Number = 0;
			if (prW>0) {
				scale = prW/bitmap.width;
			}else if (prH>0) {
				scale = prH/bitmap.height;
			}
			
			
			var w:int = prW>0?prW:(bitmap.width * scale);
			var h:int = prH>0?prH:(bitmap.height * scale);
			
			var matrix:Matrix = new Matrix();
			matrix.scale(scale, scale);
			
			var smallBMD:BitmapData = new BitmapData(w, h, true, 0x000000);
			smallBMD.draw(bitmap, matrix, null, null, null, true);
			var rbitmap:Bitmap = new Bitmap(smallBMD, PixelSnapping.NEVER, true);
			rbitmap.smoothing = true;
			return rbitmap;
		}
	}
}
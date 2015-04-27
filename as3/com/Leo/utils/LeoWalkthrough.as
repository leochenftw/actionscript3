package com.Leo.utils
{
	import com.danielfreeman.madcomponents.UILabel;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	
	public class LeoWalkthrough extends Sprite
	{
		private var _screenOverlay:Sprite = new Sprite;
		private var _viewportWidth:int;
		private var _slides:Vector.<Bitmap> = new Vector.<Bitmap>;
		private var _idx:int = 0;
		private var _description:Vector.<String> = new Vector.<String>;
		private var _label:UILabel;
		public function LeoWalkthrough(viewportWidth:int, bitmapVector:Vector.<Bitmap>,descriptions:Vector.<String>)
		{
			if (bitmapVector.length != descriptions.length) {
				throw Error('Bitmap number is not equal description number');
				return;
			}
			_viewportWidth = viewportWidth;
			for (var i:int = 0; i < bitmapVector.length; i++) {
				var bmp:Bitmap = LeoBitmapResizer.resize(bitmapVector[i] as Bitmap,viewportWidth,0);
				_slides.push(_slides);
				(bitmapVector[i] as Bitmap).bitmapData.dispose();
				bitmapVector[i] = null;
				_description.push(descriptions[i]);
			}
			
			bitmapVector = null;
			this.addEventListener(Event.ADDED_TO_STAGE,toStage);
		}
		
		protected function toStage(e:Event):void
		{
			if (!_label) {
				_label = new UILabel(this,0,0,_description[_idx],new TextFormat('Arial',Math.round(stage.fullScreenWidth*0.0375),0xffffff,true,null,null,null,null,'center'));
			}else{
				_label.text = _description[_idx];
			}
			_screenOverlay.graphics.clear();
			_screenOverlay.graphics.beginFill(0x000000,0.9);
			_screenOverlay.graphics.drawRect(0,0,stage.fullScreenWidth,stage.fullScreenHeight);
			_screenOverlay.graphics.endFill();
			stage.addChild(_screenOverlay);
			stage.addEventListener(MouseEvent.CLICK,clickHandler);
			
			this.addChild(_slides[_idx]);
			pos(_slides[_idx]);
			_idx++;
			_label.y = _slides[_idx].y + _slides[_idx].height;
			addChild(_label);
			
			if (!(this.parent is Stage)) {
				stage.addChild(this);
			}
			
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
package com.Leo.utils
{
	import com.danielfreeman.madcomponents.Attributes;
	import com.danielfreeman.madcomponents.UIScrollVertical;
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	
	public class UIScrollVerticalMaker extends UIScrollVertical
	{
		protected var _pureLayer:Sprite;
		protected var _xgap:Number = 0;
		protected var _ygap:Number = 0;
		protected var _thisMask:Shape;
		
		public function UIScrollVerticalMaker(screen:Sprite, width:Number, height:Number, xgap:Number, ygap:Number, style:String = "") {
			super(screen,XML("<null "+style+"/>"), new Attributes(0, 0, width, height));
			_slider.addChild(_pureLayer = new Sprite());
			_thisMask = new Shape;
			_thisMask.graphics.beginFill(0x000000);
			_thisMask.graphics.drawRect(0,0,width,height);
			_thisMask.graphics.endFill();
			addChild(_thisMask);
			_pureLayer.mask = _thisMask;
		}
		
		public function set xgap(value:Number):void {
			_xgap = value;
		}
		
		public function set ygap(value:Number):void {
			_ygap = value;
		}
		
		
		public function attach(child:DisplayObject):void {
			_pureLayer.addChild(child);
			adjustMaximumSlide();
		}
		
		public function get distance():Number {
			return this._distance;
		}
		
		public function attachHorizontal(child:DisplayObject):void {
			var lastChild:DisplayObject = _pureLayer.numChildren>0 ? _pureLayer.getChildAt(_pureLayer.numChildren - 1) : null;
			_pureLayer.addChild(child);
			child.x = lastChild ? lastChild.x + lastChild.width + _xgap : _xgap;
			child.y = lastChild ? lastChild.y : _ygap;
			adjustMaximumSlide();
		}
		
		
		public function attachVertical(child:DisplayObject):void {
			var lastChild:DisplayObject = _pureLayer.numChildren>0 ? _pureLayer.getChildAt(_pureLayer.numChildren - 1) : null;
			_pureLayer.addChild(child);
			child.x = lastChild ? lastChild.x : _xgap;
			child.y = lastChild ? lastChild.y + lastChild.height + _ygap : _ygap;
			adjustMaximumSlide();
		}
	}
}



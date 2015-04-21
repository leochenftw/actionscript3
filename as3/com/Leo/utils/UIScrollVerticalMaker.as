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
		protected var _w:Number;
		protected var _associate:UIScrollVerticalMaker;
		public function UIScrollVerticalMaker(screen:Sprite, width:Number, height:Number, xgap:Number=0, ygap:Number=0, style:String = "",associate:UIScrollVerticalMaker=null) {
			_w = width;
			_associate = associate;
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
		
		public override function set height(value:Number):void {
			_thisMask.graphics.clear();
			_thisMask.graphics.beginFill(0x000000);
			_thisMask.graphics.drawRect(0,0,_w,height);
			_thisMask.graphics.endFill();
			this.attributes.height = value;
			adjustMaximumSlide();
			_maximumSlide -= 10;
		}
		
		public function expand(child:DisplayObject,extraHeight:Number):void {
			var i:int = _pureLayer.getChildIndex(child)+1;
			for (i;i<_pureLayer.numChildren;i++){
				var thisChild:DisplayObject = _pureLayer.getChildAt(i);
				if (i<_pureLayer.numChildren-1) {
					Statics.tLite(thisChild,0.25,{y:thisChild.y + extraHeight});
				}else{
					Statics.tLite(thisChild,0.25,{y:thisChild.y + extraHeight, onUpdate:function():void {
						adjustMaximumSlide();
						_maximumSlide -= 10;
					}});
				}
			}
		}
		
		public function collapse(child:DisplayObject,deductHeight:Number):void {
			var i:int = _pureLayer.getChildIndex(child)+1;
			for (i;i<_pureLayer.numChildren;i++){
				var thisChild:DisplayObject = _pureLayer.getChildAt(i);
				if (i<_pureLayer.numChildren-1) {
					Statics.tLite(thisChild,0.25,{y:thisChild.y - deductHeight});
				}else{
					Statics.tLite(thisChild,0.25,{y:thisChild.y - deductHeight, onUpdate:function():void {
						adjustMaximumSlide();
						_maximumSlide -= 10;
					}});
				}
			}
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
			_maximumSlide -= 10;
		}
	}
}



package com.Leo.utils
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Circ;
	
	import flash.display.Stage;
	
	import Pages.Page;

	public class Navigator
	{
		private var _idx:int = 0;
		private var _pages:Vector.<Page>;
		private var _tweenType:String = 'vertical';
		private var _duration:Number = 0;
		private var _stage:Stage;
		public function Navigator(stage:Stage,pages:Vector.<Page>,tween:String,duration:Number)
		{
			_stage = stage;
			_pages = pages;
			_tweenType = tween;
			_duration = duration;
		}
	
		public function next(tween:String = null,callback:Function = null):void {
			if (!_pages[_idx].parent) return;
			var lcTween:String = tween?tween:_tweenType;
			switch (lcTween) {
				case 'vertical':
					if (_idx < _pages.length - 1) {
						TweenLite.to(_pages[_idx],_duration, {ease:Circ.easeInOut, y:-_stage.fullScreenHeight, onComplete:function():void {
							if (_pages[_idx].parent){
								_pages[_idx].parent.removeChild(_pages[_idx]);
							}
							_idx++;
							if (callback) callback.call();
						}});
						_pages[_idx+1].y = _stage.fullScreenHeight;
						_pages[_idx].parent.addChild(_pages[_idx+1]);
						TweenLite.to(_pages[_idx+1],_duration, {ease:Circ.easeInOut, y:0});
					}
					
					break;
			}
		}
		
		public function prev(tween:String = null, callback:Function = null):void {
			if (!_pages[_idx].parent) return;
			var lcTween:String = tween?tween:_tweenType;
			switch (lcTween) {
				case 'vertical':
					if (_idx > 0) {
						TweenLite.to(_pages[_idx],_duration, {ease:Circ.easeInOut, y:_stage.fullScreenHeight, onComplete:function():void {
							if (_pages[_idx].parent){
								_pages[_idx].parent.removeChild(_pages[_idx]);
							}
							_idx--;
							if (callback) callback.call();
						}});
						_pages[_idx-1].y = -_stage.fullScreenHeight;
						_pages[_idx].parent.addChild(_pages[_idx-1]);
						TweenLite.to(_pages[_idx-1],_duration, {ease:Circ.easeInOut, y:0});
					}
					
					break;
			}
		}
		
	}
}
package com.Leo.utils
{
	import com.danielfreeman.madcomponents.UILabel;
	import com.greensock.TweenLite;
	import com.ruochi.shape.Rect;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TransformGestureEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	
	
	public class LeoDatepicker extends Sprite
	{
		private var _gw:int,_gh:int,_gg:int = 0;
		private var _callback:Function;
		private var _tf:TextFormat;
		private var _ttf:TextFormat;
		private var _stage:Sprite; 
		private var _date:Date = new Date;
		private var _thisMonth:int,_thisYear:int,_thisDate:int,_today:int;
		private var _monthEndDate:Array = [31,28,31,30,31,30,31,31,30,31,30,31];
		private var _pickedDateObject:Object = { year: 0, month: 0, date: 0 };
		private var _pickedDate:Sprite = null;
		private var _todayGrid:Sprite = null;
		private var _lblTitle:UILabel;
		private var _aniTitle:UILabel;
		private var _months:Array = ["JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"];
		private var la:Sprite = new Sprite;
		private var ra:Sprite = new Sprite;
		private var _screenMonth:Sprite;
		private var _tx:Number,_ty:Number = 0;
		private var _btnClose:LeoButton;
		public function LeoDatepicker(w:int,h:int, gap:int, tf:TextFormat = null, callback:Function = null)
		{
			super();
			
			this.addEventListener(TransformGestureEvent.GESTURE_SWIPE, onSwipe);
			this.addEventListener(Event.ADDED_TO_STAGE, init);
			_gw = _gh = int((w-8*gap)/7);
			_gg = gap;
			_tf = tf?tf:new TextFormat('Myriad Pro',int(_gh*0.35),0x00727F,null,null,null,null,null,'center');
			_ttf = new TextFormat('Myriad Pro',int(_gh*0.8),0x00727F,null,null,null,null,null,'center');
			_callback = callback;
			
			_pickedDateObject.month = _thisMonth = _date.getMonth();
			_pickedDateObject.year = _thisYear = _date.getFullYear();
			_pickedDateObject.date = _today = _date.getDate();
			febDate();
			
			_stage = new Rect(w,h);
			_stage.alpha = 0.98;
			addChild(_stage);
			
			_lblTitle = new UILabel(this,0, h * 0.05, _months[_thisMonth] + ' ' + _thisYear.toString(), _ttf);
			_lblTitle.fixwidth = w;
			
			_screenMonth = monthTemplate();
			_screenMonth.y = _lblTitle.height + h * 0.1;
			
			la.graphics.beginFill(0xffffff,0);
			la.graphics.drawRect(0,0,_lblTitle.height,_lblTitle.height);
			la.graphics.endFill();
			
			ra.graphics.beginFill(0xffffff,0);
			ra.graphics.drawRect(0,0,_lblTitle.height,_lblTitle.height);
			ra.graphics.endFill();
			
			la.graphics.lineStyle(2, 0x00727F);
			la.graphics.moveTo(0,Math.round(_lblTitle.height*0.25));
			la.graphics.lineTo(Math.round(_lblTitle.height*0.25), 0);
			la.graphics.moveTo(0,Math.round(_lblTitle.height*0.25));
			la.graphics.lineTo(Math.round(_lblTitle.height*0.25), Math.round(_lblTitle.height*0.5));
			
			ra.graphics.lineStyle(2, 0x00727F);
			ra.graphics.moveTo(_lblTitle.height,Math.round(_lblTitle.height*0.25));
			ra.graphics.lineTo(_lblTitle.height-Math.round(_lblTitle.height*0.25), 0);
			ra.graphics.moveTo(_lblTitle.height,Math.round(_lblTitle.height*0.25));
			ra.graphics.lineTo(_lblTitle.height-Math.round(_lblTitle.height*0.25), Math.round(_lblTitle.height*0.5));
			la.x = gap*2;
			ra.x = w-gap*2-ra.width;
			la.y = ra.y = _lblTitle.y + (_lblTitle.height * 0.25);
			addChild(la);
			addChild(ra);
			la.name = 'left';
			ra.name = 'right';
			la.addEventListener(MouseEvent.MOUSE_DOWN, clickArrow);
			ra.addEventListener(MouseEvent.MOUSE_DOWN, clickArrow);
			
			addChild(_screenMonth);
			
			_btnClose = new LeoButton(_gh,0,'CLOSE',0xffffff,0xFF4D4D);
			addChild(_btnClose);
			_btnClose.y = h - gap - _gh;
			_btnClose.x = gap;
			_btnClose.width = w-2*gap;
			
		}
		
		public function get btnClose():LeoButton {
			return _btnClose;
		}
		
		private function onSwipe(e:TransformGestureEvent):void {
			if (e.offsetX == -1) {
				ra.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
			}
			
			if (e.offsetX == 1){
				la.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
			}
		}
		
		protected function init(e:Event=null):void {
			Multitouch.inputMode = MultitouchInputMode.GESTURE;
			this.scaleX = this.scaleY = 1.5; 
			this.alpha = 0;
			_tx = this.x = (stage.stageWidth - this.width) * 0.5;
			_ty = this.y = (stage.stageHeight - this.height) * 0.5;
			TweenLite.to(this, 0.25, {alpha: 1, x: 0, y: 0, scaleX: 1, scaleY: 1});
		}
		
		public function withDrawCal(cbf:Function = null):void {
			var lcThis:LeoDatepicker = this;
			var thisParent:* = parent;
			TweenLite.to(this, 0.25, {alpha: 0, x: _tx, y: _ty, scaleX: 1.5, scaleY: 1.5, onComplete:function():void {
				Multitouch.inputMode = MultitouchInputMode.NONE;
				thisParent.removeChild(lcThis);
				if (cbf) cbf();
			}});
		}
		
		private function clickArrow(e:MouseEvent):void {
			
			var arrow:Sprite = e.currentTarget as Sprite;
			la.removeEventListener(MouseEvent.MOUSE_DOWN,clickArrow);
			ra.removeEventListener(MouseEvent.MOUSE_DOWN,clickArrow);
			var lr:int = 1;
			switch (arrow.name) {
				case 'left':
					_thisMonth--;
					if (_thisMonth < 0) {
						_thisMonth = 11;
						_thisYear--;
					}
					lr = -1;
					break;
				case 'right':
					_thisMonth++;
					if (_thisMonth > 11){
						_thisMonth = 0;
						_thisYear++;
					}
					break;
			}
			
			febDate();
			
			_aniTitle = new UILabel(this,stage.stageWidth*lr, stage.stageHeight * 0.05, _months[_thisMonth] + ' ' + _thisYear.toString(), _ttf);
			_aniTitle.fixwidth = stage.stageWidth;
			_aniTitle.alpha = 0;
			var newMonth:Sprite = monthTemplate();
			newMonth.x = _aniTitle.x;
			newMonth.y = _screenMonth.y;
			newMonth.alpha = 0;
			addChild(newMonth);
			TweenLite.to([_lblTitle,_screenMonth], 0.25, {alpha: 0, x:_aniTitle.x*-1});
			TweenLite.to([_aniTitle,newMonth],0.25,{alpha: 1,x:0, onComplete:function():void {
				removeChild(_lblTitle);
				_lblTitle = null;
				_lblTitle = _aniTitle;
				destructMonth(_screenMonth);
				_screenMonth = newMonth;
				la.addEventListener(MouseEvent.MOUSE_DOWN, clickArrow);
				ra.addEventListener(MouseEvent.MOUSE_DOWN, clickArrow);
			}});
			addChild(la);
			addChild(ra);
		}
		
		private function febDate():void {
			if (_thisYear%4 == 0) {
				_monthEndDate[1] = 29;
			}else{
				_monthEndDate[1] = 28;
			}
		}
		
		private function destructMonth(month:Sprite):void {
			while (month.numChildren > 0){
				month.removeChildAt(month.numChildren-1);
			}
			removeChild(month);
			month = null;
		}
		
		private function monthTemplate():Sprite {
			var spMonth:Sprite = new Sprite;
			var firstDay:int = 0;
			var endDate:int = _monthEndDate[_thisMonth];
			var lcDate:Date = new Date(_thisYear,_thisMonth,1);
			firstDay = lcDate.day;
			var i:int = 0;
			var r:int = 0;
			var d:int = 1;
			var mayStart:Boolean = false;
			for (var n:int = 0; n < 49; n++){
				var grid:Sprite = new Sprite;
				if (r < 1) {
					var strLabel:String = '';
					switch (i) {
						case 0:
							strLabel = 'SUN';
							break;
						case 1:
							strLabel = 'MON';
							break;
						case 2:
							strLabel = 'TUE';
							break;
						case 3:
							strLabel = 'WED';
							break;
						case 4:
							strLabel = 'THU';
							break;
						case 5:
							strLabel = 'FRI';
							break;
						case 6:
							strLabel = 'SAT';
							break;
					}
					dateTemplate(grid,strLabel,false);
				}
				
				if (r == 1 && i == firstDay) {
					mayStart = true;
				}
				
				
				if (mayStart && d<=endDate) {
					dateTemplate(grid,d.toString());
					if (_thisMonth == _date.getMonth() && _thisYear == _date.getFullYear()){
						if (d == _today) {
							drawBorder(grid);
							_todayGrid = grid;
						}
					}
					if (_thisMonth == _pickedDateObject.month && _thisYear == _pickedDateObject.year){
						if (d == _pickedDateObject.date){
							_pickedDate = grid;
							(_pickedDate.getChildByName('bg') as Rect).color = 0xcccccc; 
						}
					}
					d++;
					grid.addEventListener(MouseEvent.CLICK, datePicked);
				}
				
				grid.x = i*_gw + (i+1)*_gg;
				grid.y = r*(_gh + _gg);
				spMonth.addChild(grid);
				
				if (i == 6) {
					i = 0;
					r++;
				}else{
					i++;
				}
			}
			
			return spMonth;
		}
		
		private function dateTemplate(grid:Sprite,prText:String,paintBG:Boolean = true):void {
			var gridBG:Sprite = new Rect(_gw,_gh,0xeeeeee);
			if (!paintBG) gridBG.alpha = 0;
			gridBG.name = 'bg';
			grid.addChild(gridBG);
			var gridLabel:TextField = new TextField;
			gridLabel.selectable = false;
			gridLabel.defaultTextFormat = _tf;
			gridLabel.width = _gw;
			gridLabel.text = prText;
			
			gridLabel.height = gridLabel.textHeight;
			gridLabel.y = (_gh-gridLabel.height) * 0.5;
			gridLabel.name = 'text';
			grid.addChild(gridLabel);
		}
		
		private function drawBorder(obj:Sprite, c:uint = 0x7d6594):void {
			var border:Sprite = new Sprite;
			border.graphics.lineStyle(4,c);
			border.graphics.moveTo(2,0);
			border.graphics.lineTo(obj.width-2,0);
			border.graphics.lineTo(obj.width-2,obj.height-2);
			border.graphics.lineTo(2,obj.height-2);
			border.graphics.lineTo(2,0);
			obj.addChild(border);
		}
		
		private function datePicked(e:MouseEvent):void {
			if (_pickedDate) (_pickedDate.getChildByName('bg') as Rect).color = 0xeeeeee;
			var dGrid:Sprite = e.currentTarget as Sprite;
			(dGrid.getChildByName('bg') as Rect).color = 0xcccccc;
			_pickedDate = dGrid;
			var lcPicked:Number = Number((_pickedDate.getChildByName('text') as TextField).text);
			var lcPickedDate:int = isNaN(lcPicked)?1:int(lcPicked);
			_thisDate = lcPickedDate;
			var rObj:Object = {
				year: _thisYear,
				month: _thisMonth+1,
				date: lcPickedDate
			};
			_pickedDateObject.year = _thisYear;
			_pickedDateObject.month = _thisMonth;
			_pickedDateObject.date = lcPickedDate;
			
			if (_callback) _callback(rObj);
		}
	}
}
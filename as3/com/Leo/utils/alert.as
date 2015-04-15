package com.Leo.utils {
	import com.danielfreeman.madcomponents.UILabel;
	import com.greensock.TweenLite;
	import com.ruochi.shape.Rect;
	import com.ruochi.shape.RoundRect;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	
	public class alert extends LeoSprite {
		private var _w:int = 0, _h:int = 0;
		private var _overlay:Rect;
		private var _bg:RoundRect;
		private var _title:UILabel;
		private var _strTitle:String,_strContent:String,_strLabel:String,_strCancel:String;
		private var _content:UILabel;
		private var _btnLabel:UILabel,_cancelLabel:UILabel;
		private var _btn:Rect;
		private var _btnCancel:Rect;
		private var _titleFormat:TextFormat;
		private var _contentFormat:TextFormat;
		private var _btnFormat:TextFormat;
		private var _msg:Sprite = new Sprite;
		private var _bar:Rect;
		private var _alignment:String;
		//[Event(name="Click",type="flash.events.MouseEvent")]
		public function alert(prTitle:String, prContent:String, btnLabel:String = '',btnCancelLabel:String = '',alignment:String = 'center') {
			_strTitle = prTitle;
			_strContent = prContent;
			_strLabel = btnLabel;
			_strCancel = btnCancelLabel;
			_alignment = alignment;
		}
		
		protected override function init(e:Event=null):void {
			if (!_overlay){
				_w = stage.fullScreenWidth;
				_h = stage.fullScreenHeight;
				
				_overlay = new Rect(_w,_h, 0x000000);
				_overlay.alpha = 0.8;
				addChild(_overlay);
				
				_titleFormat = new TextFormat('Myriad Pro',int(_h*0.03125),0x000000,true,null,null,null,null,'center');
				_contentFormat = new TextFormat('Myriad Pro',int(_h*0.025),0x000000,null,null,null,null,null,_alignment);
				_btnFormat = new TextFormat('Myriad Pro',int(_h*0.03125),0x3C7BC8,null,null,null,null,null,'center');
				
				var padding:int = int(_h*0.02);
				_title = new UILabel(_msg,0,padding,_strTitle,_titleFormat);
				_content = new UILabel(_msg,0,padding+int(_title.height*1.5),'',_contentFormat);
				_content.multiline = true;
				_content.htmlText = _strContent;
				
				_title.fixwidth = _content.fixwidth = int(_w*0.9);
				
				var cX:int = int(_msg.width*0.05);
				var mW:int = _msg.width;
				_content.fixwidth = int(_msg.width*0.9);
				_content.x = cX;
				
				if (_strLabel.length > 0 && _strCancel.length > 0){
					_cancelLabel = new UILabel(_msg,0,_content.y+_content.height + padding+_title.height,_strCancel,_btnFormat);
					_btnLabel = new UILabel(_msg,_title.width*0.5,_content.y+_content.height + padding+_title.height,_strLabel,_btnFormat);
					_cancelLabel.fixwidth = _btnLabel.fixwidth = _title.width*0.5;
					
					_bar = new Rect(_msg.width, 1, 0xAFB0B6);
					_bar.y = _btnLabel.y - padding;
					_msg.addChild(_bar);
					
				}else{
					if (_strLabel.length > 0){
						_btnLabel = new UILabel(_msg,0,_content.y+_content.height + padding+_title.height,_strLabel,_btnFormat);
						_btnLabel.fixwidth = _title.width;
						
						_bar = new Rect(_msg.width, 1, 0xAFB0B6);
						_bar.y = _btnLabel.y - padding;
						_msg.addChild(_bar);
					}
				}
				
				_bg = new RoundRect(mW,_msg.height + padding*2,int(_h*0.0104),0xffffff);
				_msg.addChildAt(_bg,0);
				addChild(_msg);
				
				if (_cancelLabel) {
					
					_btnCancel = new Rect(_msg.width*0.5, _msg.height - _bar.y, 0x000000);
					_btnCancel.alpha = 0;
					_btnCancel.y = _msg.height - _btnCancel.height;
					_msg.addChild(_btnCancel);
					
					var minBar:Rect = new Rect(1,_msg.height - _bar.y,0xAFB0B6);
					minBar.y = _bar.y;
					minBar.x = _title.width*0.5;
					_msg.addChild(minBar);
					_btnCancel.addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void {
						close();
					});
				}
				
				if (_btnLabel) {
					_btn = new Rect(_msg.width*(_cancelLabel?0.5:1), _msg.height - _bar.y, 0x000000);
					_btn.alpha = 0;
					_btn.x = _cancelLabel?(_msg.width*0.5):0;
					_btn.y = _msg.height - _btn.height;
					_msg.addChild(_btn);
				}
				
				
			}
			
			_msg.x = int(_w*0.05);
			_msg.y = (_h - _msg.height) * 0.5;
			
			this.alpha = 0;
			TweenLite.to(this, 0.25, {alpha: 1});
		}
		
		public function set content(s:String):void {
			
			_content.htmlText = _strContent = s;
			_msg.removeChild(_bg);
			_bg = new RoundRect(_msg.width,_msg.height + int(_h*0.02)*2,int(_h*0.0104),0xffffff);
			_msg.addChildAt(_bg,0);
		}
		
		public function close():void {
			var lcThis:alert = this;
			TweenLite.to(this, 0.25, {alpha: 0,onComplete:function():void {
				if (stage) {
					stage.removeChild(lcThis);
				}
			}});
		}
		
		public function ClickEvent(func:Function):void {
			if (_btn) {
				_btn.addEventListener(MouseEvent.CLICK,func);
			}
		}
		
		
	}
	
}
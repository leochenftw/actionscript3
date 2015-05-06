//  Adobe(R) Systems Incorporated Source Code License Agreement
//  Copyright(c) 2006-2011 Adobe Systems Incorporated. All rights reserved.
//	
//  Please read this Source Code License Agreement carefully before using
//  the source code.
//	
//  Adobe Systems Incorporated grants to you a perpetual, worldwide, non-exclusive, 
//  no-charge, royalty-free, irrevocable copyright license, to reproduce,
//  prepare derivative works of, publicly display, publicly perform, and
//  distribute this source code and such derivative works in source or 
//  object code form without any attribution requirements.    
//	
//  The name "Adobe Systems Incorporated" must not be used to endorse or promote products
//  derived from the source code without prior written permission.
//	
//  You agree to indemnify, hold harmless and defend Adobe Systems Incorporated from and
//  against any loss, damage, claims or lawsuits, including attorney's 
//  fees that arise or result from your use or distribution of the source 
//  code.
//  
//  THIS SOURCE CODE IS PROVIDED "AS IS" AND "WITH ALL FAULTS", WITHOUT 
//  ANY TECHNICAL SUPPORT OR ANY EXPRESSED OR IMPLIED WARRANTIES, INCLUDING,
//  BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
//  FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  ALSO, THERE IS NO WARRANTY OF 
//  NON-INFRINGEMENT, TITLE OR QUIET ENJOYMENT.  IN NO EVENT SHALL ADOBE 
//  OR ITS SUPPLIERS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, 
//  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, 
//  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
//  OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
//  WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR 
//  OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOURCE CODE, EVEN IF
//  ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

package com.Leo.utils
{
	import com.danielfreeman.madcomponents.UILabel;
	import flash.utils.setTimeout;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.SoftKeyboardEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.StageText;
	import flash.text.StageTextInitOptions;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextLineMetrics;
	import flash.text.engine.FontPosture;
	import flash.text.engine.FontWeight;
	
	[Event(name="change",                 type="flash.events.Event")]
	[Event(name="focusIn",                type="flash.events.FocusEvent")]
	[Event(name="focusOut",               type="flash.events.FocusEvent")]
	[Event(name="keyDown",                type="flash.events.KeyboardEvent")]
	[Event(name="keyUp",                  type="flash.events.KeyboardEvent")]
	[Event(name="softKeyboardActivate",   type="flash.events.SoftKeyboardEvent")]
	[Event(name="softKeyboardActivating", type="flash.events.SoftKeyboardEvent")]
	[Event(name="softKeyboardDeactivate", type="flash.events.SoftKeyboardEvent")]
	
	public class NativeText extends Sprite
	{
		private var st:StageText;
		private var numberOfLines:uint;
		private var _width:uint, _height:uint;
		private var snapshot:Bitmap;
		private var _borderThickness:uint = 0;
		private var _borderColor:uint = 0x000000;
		private var _borderCornerSize:uint = 0;
		private var lineMetric:TextLineMetrics;
		private var _maxHeight:int;
		private var _bgColor:uint;
		private var _strPlaceholder:String;
		private var _placeHolder:UILabel;
		private var _startFrozen:Boolean = false;
		
		public function NativeText(bg:Boolean, numberOfLines:uint = 1, prPlaceholder:String = '')
		{
			_strPlaceholder = prPlaceholder;
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
			
			this.numberOfLines = numberOfLines;
			var stio:StageTextInitOptions = new StageTextInitOptions((this.numberOfLines > 1));
			this.st = new StageText(stio);
			this.st.addEventListener(FocusEvent.FOCUS_IN,focIn);
			this.st.addEventListener(FocusEvent.FOCUS_OUT,focOut);
		}
		
		protected function focIn(e:FocusEvent):void {
			if (_placeHolder) {
				_placeHolder.visible = false;
			}
		}
		
		protected function focOut(e:FocusEvent):void {
			if (_placeHolder && this.st.text.length == 0) {
				_placeHolder.visible = true;
			}
		}
		
		public override function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			if (this.isEventTypeStageTextSpecific(type))
			{
				this.st.addEventListener(type, listener, useCapture, priority, useWeakReference);
			}
			else
			{
				super.addEventListener(type, listener, useCapture, priority, useWeakReference);
			}
		}
		
		public override function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
		{
			if (this.isEventTypeStageTextSpecific(type))
			{
				this.st.removeEventListener(type, listener, useCapture);
			}
			else
			{
				super.removeEventListener(type, listener, useCapture);
			}
		}
		
		private function isEventTypeStageTextSpecific(type:String):Boolean
		{
			return (type == Event.CHANGE ||
				type == FocusEvent.FOCUS_IN ||
				type == FocusEvent.FOCUS_OUT ||
				type == KeyboardEvent.KEY_DOWN ||
				type == KeyboardEvent.KEY_UP ||
				type == SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATE ||
				type == SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATING ||
				type == SoftKeyboardEvent.SOFT_KEYBOARD_DEACTIVATE);
		}
		
		private function onAddedToStage(e:Event):void
		{
			if (this.st && stage){
				this.st.stage = this.stage;
				this.render();
			}
		}
		
		private function onRemoveFromStage(e:Event):void
		{
			//this.st.dispose();
			this.st.visible = false;
		}
		
		public function dispose():void {
			this.st.dispose();
		}
		
		public function set bgColor(u:uint):void {
			_bgColor = u;
		}
		
		public function get bgColor():uint {
			return _bgColor;
		}
		
		public function set maxHeight(i:int):void {
			this._maxHeight = i;
		}
		
		public function set borderThickness(borderThickness:uint):void
		{
			this._borderThickness = borderThickness;
			this.render();
		}
		
		public function get borderThickness():uint
		{
			return this._borderThickness;
		}
		
		public function set borderColor(borderColor:uint):void
		{
			this._borderColor = borderColor;
			this.render();
		}
		
		public function get borderColor():uint
		{
			return this._borderColor;
		}
		
		public function set borderCornerSize(borderCornerSize:uint):void
		{
			this._borderCornerSize = borderCornerSize;
			this.render();
		}
		
		public function get borderCornerSize():uint
		{
			return this._borderCornerSize;
		}
		
		//// StageText properties and functions ///
		
		public function set autoCapitalize(autoCapitalize:String):void
		{
			this.st.autoCapitalize = autoCapitalize;
		}
		
		public function set autoCorrect(autoCorrect:Boolean):void
		{
			this.st.autoCorrect = autoCorrect;
		}
		
		public function set color(color:uint):void
		{
			this.st.color = color;
		}
		
		public function set displayAsPassword(displayAsPassword:Boolean):void
		{
			this.st.displayAsPassword = displayAsPassword;
		}
		
		public function set editable(editable:Boolean):void
		{
			this.st.editable = editable;
		}
		
		public function set fontFamily(fontFamily:String):void
		{
			this.st.fontFamily = fontFamily;
		}
		
		public function set fontPosture(fontPosture:String):void
		{
			this.st.fontPosture = fontPosture;
		}
		
		public function set fontSize(fontSize:uint):void
		{
			this.st.fontSize = fontSize;
			this.render();
		}
		
		public function set fontWeight(fontWeight:String):void
		{
			this.st.fontWeight = fontWeight;
		}
		
		public function set locale(locale:String):void
		{
			this.st.locale = locale;
		}
		
		public function set maxChars(maxChars:int):void
		{
			this.st.maxChars = maxChars;
		}
		
		public function set restrict(restrict:String):void
		{
			this.st.restrict = restrict;
		}
		
		public function set returnKeyLabel(returnKeyLabel:String):void
		{
			this.st.returnKeyLabel = returnKeyLabel;
		}
		
		public function get selectionActiveIndex():int
		{
			return this.st.selectionActiveIndex;
		}
		
		public function get selectionAnchorIndex():int
		{
			return this.st.selectionAnchorIndex;
		}
		
		public function set softKeyboardType(softKeyboardType:String):void
		{
			this.st.softKeyboardType = softKeyboardType;
		}
		
		public function set text(text:String):void
		{
			this.st.text = text;
			if (trim(text).length > 0) {
				if (_placeHolder) _placeHolder.visible = false;
			}else{
				if (_placeHolder) _placeHolder.visible = true;
			}
		}
		
		public function get text():String {
			return this.st.text;
		}
		
		public function set textAlign(textAlign:String):void
		{
			this.st.textAlign = textAlign;
		}
		
		public override function set visible(visible:Boolean):void
		{
			super.visible = visible;
			this.st.visible = visible;
		}
		
		public function get multiline():Boolean
		{
			return this.st.multiline;
		}
		
		public function assignFocus():void
		{
			if (this.st && stage) {
				this.st.assignFocus();
			}
		}
		
		public function selectRange(anchorIndex:int, activeIndex:int):void
		{
			this.st.selectRange(anchorIndex, activeIndex);
		}
		
		//// Additional functions ////
		
		public function freeze():void
		{
			if (this.st&&stage){
				var viewPortRectangle:Rectangle = this.getViewPortRectangle();
				var border:Sprite = new Sprite();
				
				var bmd:BitmapData = new BitmapData(this.st.viewPort.width, this.st.viewPort.height, true,0x000000);
				this.st.drawViewPortToBitmapData(bmd);
				bmd.draw(border, new Matrix(1, 0, 0, 1, this.x - viewPortRectangle.x, this.y - viewPortRectangle.y));
				if (this.snapshot != null && this.contains(this.snapshot))
				{
					this.removeChild(this.snapshot);
					this.snapshot = null;
				}
				this.snapshot = new Bitmap(bmd);
				if (!parent) {
					this.snapshot.x = viewPortRectangle.x - this.x;
					this.snapshot.y = viewPortRectangle.y - this.y;
				}else{
					this.snapshot.x = viewPortRectangle.x - this.x - parent.x;
					this.snapshot.y = viewPortRectangle.y - this.y - parent.y;
				}
				this.addChild(this.snapshot);
				this.st.visible = false;
			}else{
				_startFrozen = true;
			}
		}
		
		public function unfreeze():void
		{
			if (this.snapshot != null && this.contains(this.snapshot))
			{
				this.removeChild(this.snapshot);
				this.snapshot = null;
				this.st.visible = true;
				this.st.viewPort = new Rectangle(this.st.viewPort.x, this.st.viewPort.y,this.st.viewPort.width,this.st.viewPort.height);
				assignFocus();
				if (stage) stage.focus = null;
			}
		}
		
		//// Functions that must be overridden to make this work ///
		
		public override function set width(width:Number):void
		{
			this._width = width;
			this.render();
			
		}
		
		public override function get width():Number
		{
			return this._width;
		}
		
		public override function set height(height:Number):void
		{
			// This is a NO-OP since the height is set automatically
			// based on things like font size, etc.
		}
		
		public override function get height():Number
		{
			var totalFontHeight:Number = this.getTotalFontHeight();
			return this.numberOfLines <= 1? Math.round((totalFontHeight + (totalFontHeight - this.st.fontSize)) * this.numberOfLines): Math.round(_maxHeight-10);
		}
		
		public override function set x(x:Number):void
		{
			super.x = x;
			this.render();
		}
		
		public override function set y(y:Number):void
		{
			super.y = y;
			this.render();
		}
		
		private function render():void
		{
			if (this.stage == null || !this.stage.contains(this)) return;
			this.lineMetric = null;
			this.calculateHeight();
			if (this.numberOfLines <= 1){
				this.st.viewPort = this.getViewPortRectangle();
			}else{
				this.st.viewPort = this.getViewPortRectangle();
				
			}
			
			if (!_placeHolder && _strPlaceholder.length > 0){
				_placeHolder = new UILabel(this,5,0,'', new TextFormat("Myriad Pro",this.st.fontSize,0xcccccc,false));
				_placeHolder.htmlText = _strPlaceholder;
				_placeHolder.fixwidth = width;
				if (numberOfLines > 1){
					_placeHolder.multiline = _placeHolder.wordWrap = true;
				}
				if (this.st.text.length>0) _placeHolder.visible = false;
			}
			if (_startFrozen) {
				setTimeout(function():void {
					freeze();
				},250);
			}
		}
		
		private function getViewPortRectangle():Rectangle
		{
			var totalFontHeight:Number = this.getTotalFontHeight();
			var lcX:int = this.x;
			var lcY:int = this.y;
			var h:int = this.numberOfLines <= 1? Math.round((totalFontHeight + (totalFontHeight - this.st.fontSize)) * this.numberOfLines): Math.round(_maxHeight-10);
			if (parent) {
				lcX += parent.x;
				lcY += parent.y;
				if (this.numberOfLines <= 1) {
					lcY += int((this.height - h)*0.5);
				}else{
					lcY += this.borderThickness+5;
				}
			}
			
			
			return new Rectangle(lcX + this.borderThickness + 5,
				lcY,
				Math.round(this._width -10 - (this.borderThickness * 2.5)),
				h);
		}
		
		private function calculateHeight():void
		{
			var totalFontHeight:Number = this.getTotalFontHeight();
			this._height = (totalFontHeight * this.numberOfLines) + (this.borderThickness * 2) + 4;
		}
		
		private function getTotalFontHeight():Number
		{
			if (this.lineMetric != null) return (this.lineMetric.ascent + this.lineMetric.descent);
			var textField:TextField = new TextField();
			var textFormat:TextFormat = new TextFormat(this.st.fontFamily, this.st.fontSize, null, (this.st.fontWeight == FontWeight.BOLD), (this.st.fontPosture == FontPosture.ITALIC));
			textField.defaultTextFormat = textFormat;
			textField.text = "QQQ";
			this.lineMetric = textField.getLineMetrics(0);
			return (this.lineMetric.ascent + this.lineMetric.descent);
		}
		
		public function moveToPos(offsetX:int = 0, offsetY:int = 0):void {
			if (snapshot) {
				trace('this');
				var shouldbe:Point = localToGlobal(new Point(this.snapshot.x,this.snapshot.y));
				trace(shouldbe);
				trace(offsetX + ', ' + offsetY);
				trace(this.st.viewPort);
				this.st.viewPort = new Rectangle(shouldbe.x+offsetX, shouldbe.y+offsetY,this.st.viewPort.width,this.st.viewPort.height);
				trace(this.st.viewPort);
			}
		}
	}
}

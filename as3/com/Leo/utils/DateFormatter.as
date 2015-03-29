package com.Leo.utils
{
	public function DateFormatter(date:Date,formatString:String = 'dd/mm/yyyy'):String {
		
		var pad:Function = function(n:int):String {
			return n<10 ? '0'+n.toString():n.toString();
		};
		
		var bigMonth:Function = function(i:int,full:Boolean = false):String {
			var monthArray:Array = full?['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']:['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
			return monthArray[i];
		};
		
		var returnString:String = '';
		switch (formatString) {
			case 'dd/mm/yyyy':
				returnString = pad(date.getDate()) + "/" +	pad(date.getMonth() + 1) + "/" + date.getFullYear();
				break;
			case 'd M yyyy':
				returnString = date.getDate().toString() + ' ' + bigMonth(date.getMonth()) + ' ' + date.getFullYear();
				break;
		}
		
		return returnString;
	}
}

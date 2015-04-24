package com.Leo.utils
{
	public function pf(value:*):Number
	{
		var n:Number = 0;
		if (value is String) {
			var s:String = trim(value as String);
			if (s.length == 0) {
				n = 0;
			}else{
				s = s.replace(/\$/gi,'');
				s = s.replace(/\,/gi,'');
				n = Number(s);
				n = isNaN(n)?0:n;
			}
		}
		
		if (value is Number || value is int) {
			n = value;
		}
		return n;
	}
}

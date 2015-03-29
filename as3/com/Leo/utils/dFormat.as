package com.Leo.utils
{
	public function dFormat(value:*):String
	{
		var n:Number = 0;
		if (value is Number || value is int) {
			n = value;
		}
		
		if (value is String) {
			n = Number(value);
			n = isNaN(n)?0:n;
		}
		
		var prefix:String = n < 0?'-$':'$';
		var s:String = prefix + kmark(n.toFixed(2));
		
		return s;
	}
}
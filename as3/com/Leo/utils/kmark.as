package com.Leo.utils {
	
	public function kmark(value:*):String {
		var s:String = '';
		if (value is int || value is Number) {
			s = value.toString();
		}
		
		if (value is String) {
			s = value;
		}
		var res:String = "";
		var ticker:int = 0;
		var cap:int = -1;
		var endIndex:int = -1;
		var trimmed:String = "";
		var isNegative:Boolean = false;
		if (s.length > 3){
			
			if (s.indexOf(".")>0){
				cap = s.indexOf(".")-1;
				for (var n:int = cap+1;n<s.length;n++){
					trimmed += s.charAt(n);
				}
			}else{
				cap = s.length-1;
			}
			
			if (int(s) < 0){
				endIndex = 1;
				isNegative = true;
			}else{
				endIndex = 0;
			}
			
			
			for (var i:int = cap; i >= endIndex; i--){
				ticker++;
				if (ticker%3 == 1){
					res += ",";
				}
				res += s.charAt(i);
			}
			
			
			
			s = "";
			i = res.length-1;
			
			
			
			for (i;i>=0;i--){
				if (i == 0){
					if (res.charAt(i) == ","){
						
					}else{
						s += res.charAt(i);
					}
				}else{
					s += res.charAt(i);
				}
			}
			
			if (isNegative){
				s = "-"+s;
			}
		}
		
		return s+trimmed;
	}
	
}



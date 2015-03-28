package com.Leo.utils
{
	public function trim(s:String):String{
		return s.replace( /^([\s|\t|\n]+)?(.*)([\s|\t|\n]+)?$/gm, "$2" );
	}
}
package com.Leo.utils
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;

	public class JSONIO
	{
		public function JSONIO()
		{
		}
		
		public static function write(o:Object, fileName:String = 'savedJson.txt'):void {
			var file:File = File.applicationStorageDirectory.resolvePath(fileName);
			var stream:FileStream = new FileStream();
			stream.open(file, FileMode.WRITE);
			stream.writeUTF(JSON.stringify(o));
			stream.close();
		}
		
		public static function read(callback:Function, fileName:String = 'savedJson.txt'):void {
			var file:File = File.applicationStorageDirectory.resolvePath(fileName);
			if (file.exists) {
				var stream:FileStream = new FileStream();
				stream.open(file, FileMode.READ);
				var loadedString:String = stream.readUTF()
				stream.close();
				
				if (loadedString.length > 0) {
					callback(JSON.parse(loadedString));
				}else{
					callback({error:'String is empty'});
				}
			}else{
				callback({error:'file does not exist'});
			}
		}
	}
}
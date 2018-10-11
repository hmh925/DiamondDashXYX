package laya.display.cmd {
	import laya.resource.Context;
	import laya.utils.Pool;
	
	/**
	 * 填充文字命令
	 */
	public class FillWordsCmd {
		public static const ID:String = "FillWords";
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		public var words:Array;
		public var x:Number;
		public var y:Number;
		public var font:String;
		public var color:String;
		
		public static function create(words:Array, x:Number, y:Number, font:String, color:String):FillWordsCmd {
			var cmd:FillWordsCmd = Pool.getItemByClass("FillWordsCmd", FillWordsCmd);
			cmd.words = words;
			cmd.x = x;
			cmd.y = y;
			cmd.font = font;
			cmd.color = color;
			return cmd;
		}
		
		/**
		 * 回收到对象池
		 */
		public function recover():void {
			words = null;
			Pool.recover("FillWordsCmd", this);
		}
		
		/**@private */
		public function run(context:Context, gx:Number, gy:Number):void {
			context.fillWords(words, x + gx, y + gy, font, color);
		}
		
		public function get cmdID():String {
			return ID;
		}
	
	}
}
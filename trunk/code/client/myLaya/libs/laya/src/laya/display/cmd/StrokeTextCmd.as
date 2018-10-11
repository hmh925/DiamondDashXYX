package laya.display.cmd {
	import laya.resource.Context;
	import laya.utils.Pool;
	
	/**
	 * 绘制描边文字
	 */
	public class StrokeTextCmd {
		public static const ID:String = "StrokeText";
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		public var text:String;
		public var x:Number;
		public var y:Number;
		public var font:String;
		public var color:String;
		public var lineWidth:Number;
		public var textAlign:String;
		
		public static function create(text:String, x:Number, y:Number, font:String, color:String, lineWidth:Number, textAlign:String):StrokeTextCmd {
			var cmd:StrokeTextCmd = Pool.getItemByClass("StrokeTextCmd", StrokeTextCmd);
			cmd.text = text;
			cmd.x = x;
			cmd.y = y;
			cmd.font = font;
			cmd.color = color;
			cmd.lineWidth = lineWidth;
			cmd.textAlign = textAlign;
			return cmd;
		}
		
		/**
		 * 回收到对象池
		 */
		public function recover():void {
			
			Pool.recover("StrokeTextCmd", this);
		}
		
		/**@private */
		public function run(context:Context, gx:Number, gy:Number):void {
			context.strokeWord(text, x + gx, y + gy, font, color, lineWidth, textAlign);
		}
		
		public function get cmdID():String {
			return ID;
		}
	
	}
}
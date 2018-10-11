package laya.display.cmd {
	import laya.resource.Context;
	import laya.utils.Pool;
	
	/**
	 * 绘制文本边框
	 */
	public class FillBorderTextCmd {
		public static const ID:String = "FillBorderText";
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		public var text:String;
		public var x:Number;
		public var y:Number;
		public var font:String;
		public var fillColor:String;
		public var borderColor:String;
		public var lineWidth:Number;
		public var textAlign:String;
		
		public static function create(text:String, x:Number, y:Number, font:String, fillColor:String, borderColor:String, lineWidth:Number, textAlign:String):FillBorderTextCmd {
			var cmd:FillBorderTextCmd = Pool.getItemByClass("FillBorderTextCmd", FillBorderTextCmd);
			cmd.text = text;
			cmd.x = x;
			cmd.y = y;
			cmd.font = font;
			cmd.fillColor = fillColor;
			cmd.borderColor = borderColor;
			cmd.lineWidth = lineWidth;
			cmd.textAlign = textAlign;
			return cmd;
		}
		
		/**
		 * 回收到对象池
		 */
		public function recover():void {			
			Pool.recover("FillBorderTextCmd", this);
		}
		
		/**@private */
		public function run(context:Context, gx:Number, gy:Number):void {
			context.fillBorderText(text, x + gx, y + gy, font, fillColor, borderColor, lineWidth, textAlign);
		}
		
		public function get cmdID():String {
			return ID;
		}
	
	}
}
package laya.display.cmd
{
	import laya.maths.Point;
	import laya.resource.Context;
	import laya.resource.Texture;
	import laya.utils.Pool;
	import laya.maths.Matrix;
	
	/**
	 * 绘制边框
	 */
	public class FillBorderWordsCmd
	{
		public static const ID:String = "FillBorderWords";
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		public var words:Array;
		public var x:Number;
		public var y:Number;
		public var font:String;
		public var fillColor:String;
		public var borderColor:String;
		public var lineWidth:int;
		
		public static function create(words:Array, x:Number, y:Number, font:String, fillColor:String, borderColor:String, lineWidth:int):FillBorderWordsCmd
		{
			var cmd:FillBorderWordsCmd = Pool.getItemByClass("FillBorderWordsCmd", FillBorderWordsCmd);
			cmd.words = words;
			cmd.x = x;
			cmd.y = y;
			cmd.font = font;
			cmd.fillColor = fillColor;
			cmd.borderColor = borderColor;
			cmd.lineWidth = lineWidth;
			return cmd;
		}
		
		/**
		 * 回收到对象池
		 */
		public function recover():void
		{
			words = null;
			Pool.recover("FillBorderWordsCmd", this);
		}
		
		/**@private */
		public function run(context:Context, gx:Number, gy:Number):void
		{
			context.fillBorderWords(words, x + gx, y + gy, font, fillColor, borderColor, lineWidth);
		}
		
		public function get cmdID():String
		{
			return ID;
		}
	
	}
}
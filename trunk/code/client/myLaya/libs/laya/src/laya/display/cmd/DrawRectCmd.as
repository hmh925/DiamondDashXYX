package laya.display.cmd {
	import laya.maths.Point;
	import laya.resource.Context;
	import laya.resource.Texture;
	import laya.utils.Pool;
	import laya.maths.Matrix;
	
	/**
	 * 绘制矩形
	 */
	public class DrawRectCmd {
		public static const ID:String = "DrawRect";
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		public var x:Number;
		public var y:Number;
		public var width:Number;
		public var height:Number;
		public var fillColor:*;
		public var lineColor:*;
		public var lineWidth:Number;
		
		public static function create(x:Number, y:Number, width:Number, height:Number, fillColor:*, lineColor:*, lineWidth:Number):DrawRectCmd {
			var cmd:DrawRectCmd = Pool.getItemByClass("DrawRectCmd", DrawRectCmd);
			cmd.x = x;
			cmd.y = y;
			cmd.width = width;
			cmd.height = height;
			cmd.fillColor = fillColor;
			cmd.lineColor = lineColor;
			cmd.lineWidth = lineWidth;
			return cmd;
		}
		
		/**
		 * 回收到对象池
		 */
		public function recover():void {
			fillColor = null;
			lineColor = null;
			Pool.recover("DrawRectCmd", this);
		}
		
		/**@private */
		public function run(context:Context, gx:Number, gy:Number):void {
			context.drawRect(x + gx, y + gy, width, height, fillColor, lineColor, lineWidth);
		}
		
		public function get cmdID():String {
			return ID;
		}
	
	}
}
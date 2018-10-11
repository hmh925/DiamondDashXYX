package laya.display.cmd {
	import laya.resource.Context;
	import laya.utils.Pool;
	
	/**
	 * 绘制曲线
	 */
	public class DrawCurvesCmd {
		public static const ID:String = "DrawCurves";
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		public var x:Number;
		public var y:Number;
		public var points:Array;
		public var lineColor:*;
		public var lineWidth:Number;
		
		public static function create(x:Number, y:Number, points:Array, lineColor:*, lineWidth:Number):DrawCurvesCmd {
			var cmd:DrawCurvesCmd = Pool.getItemByClass("DrawCurvesCmd", DrawCurvesCmd);
			cmd.x = x;
			cmd.y = y;
			cmd.points = points;
			cmd.lineColor = lineColor;
			cmd.lineWidth = lineWidth;
			return cmd;
		}
		
		/**
		 * 回收到对象池
		 */
		public function recover():void {
			points = null;
			lineColor = null;
			Pool.recover("DrawCurvesCmd", this);
		}
		
		/**@private */
		public function run(context:Context, gx:Number, gy:Number):void {
			context.drawCurves(x + gx, y + gy, points, lineColor, lineWidth);
		}
		
		public function get cmdID():String {
			return ID;
		}
	
	}
}
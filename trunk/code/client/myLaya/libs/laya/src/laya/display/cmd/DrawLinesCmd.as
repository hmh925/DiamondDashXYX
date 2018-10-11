package laya.display.cmd {
	import laya.resource.Context;
	import laya.utils.Pool;
	
	/**
	 * 绘制连续曲线
	 */
	public class DrawLinesCmd {
		public static const ID:String = "DrawLines";
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		public var x:Number;
		public var y:Number;
		public var points:Array;
		public var lineColor:*;
		public var lineWidth:Number;
		public var vid:int;
		
		public static function create(x:Number, y:Number, points:Array, lineColor:*, lineWidth:Number, vid:int):DrawLinesCmd {
			var cmd:DrawLinesCmd = Pool.getItemByClass("DrawLinesCmd", DrawLinesCmd);
			cmd.x = x;
			cmd.y = y;
			cmd.points = points;
			cmd.lineColor = lineColor;
			cmd.lineWidth = lineWidth;
			cmd.vid = vid;
			return cmd;
		}
		
		/**
		 * 回收到对象池
		 */
		public function recover():void {
			points = null;
			lineColor = null;
			Pool.recover("DrawLinesCmd", this);
		}
		
		/**@private */
		public function run(context:Context, gx:Number, gy:Number):void {
			context._drawLines(x + gx, y + gy, points, lineColor, lineWidth, vid);
		}
		
		public function get cmdID():String {
			return ID;
		}
	
	}
}
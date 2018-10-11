package laya.display.cmd {
	import laya.resource.Context;
	import laya.utils.Pool;
	
	/**
	 * 绘制多边形
	 */
	public class DrawPolyCmd {
		public static const ID:String = "DrawPoly";
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		public var x:Number;
		public var y:Number;
		public var points:Array;
		public var fillColor:*;
		public var lineColor:*;
		public var lineWidth:Number;
		public var isConvexPolygon:Boolean;
		public var vid:int;
		
		public static function create(x:Number, y:Number, points:Array, fillColor:*, lineColor:*, lineWidth:Number, isConvexPolygon:Boolean, vid:int):DrawPolyCmd {
			var cmd:DrawPolyCmd = Pool.getItemByClass("DrawPolyCmd", DrawPolyCmd);
			cmd.x = x;
			cmd.y = y;
			cmd.points = points;
			cmd.fillColor = fillColor;
			cmd.lineColor = lineColor;
			cmd.lineWidth = lineWidth;
			cmd.isConvexPolygon = isConvexPolygon;
			cmd.vid = vid;
			return cmd;
		}
		
		/**
		 * 回收到对象池
		 */
		public function recover():void {
			points = null;
			fillColor = null;
			lineColor = null;
			Pool.recover("DrawPolyCmd", this);
		}
		
		/**@private */
		public function run(context:Context, gx:Number, gy:Number):void {
			context._drawPoly(x + gx, y + gy, points, fillColor, lineColor, lineWidth, isConvexPolygon, vid);
		}
		
		public function get cmdID():String {
			return ID;
		}
	
	}
}
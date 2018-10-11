package laya.display.cmd {
	import laya.resource.Context;
	import laya.utils.Pool;
	
	/**
	 * 绘制圆形
	 */
	public class DrawCircleCmd {
		public static const ID:String = "DrawCircle";
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		public var x:Number;
		public var y:Number;
		public var radius:Number;
		public var fillColor:*;
		public var lineColor:*;
		public var lineWidth:Number;
		public var vid:int;
		
		public static function create(x:Number, y:Number, radius:Number, fillColor:*, lineColor:*, lineWidth:Number, vid:int):DrawCircleCmd {
			var cmd:DrawCircleCmd = Pool.getItemByClass("DrawCircleCmd", DrawCircleCmd);
			cmd.x = x;
			cmd.y = y;
			cmd.radius = radius;
			cmd.fillColor = fillColor;
			cmd.lineColor = lineColor;
			cmd.lineWidth = lineWidth;
			cmd.vid = vid;
			return cmd;
		}
		
		/**
		 * 回收到对象池
		 */
		public function recover():void {
			fillColor = null;
			lineColor = null;
			Pool.recover("DrawCircleCmd", this);
		}
		
		/**@private */
		public function run(context:Context, gx:Number, gy:Number):void {
			context._drawCircle(x + gx, y + gy, radius, fillColor, lineColor, lineWidth, vid);
		}
		
		public function get cmdID():String {
			return ID;
		}
	
	}
}
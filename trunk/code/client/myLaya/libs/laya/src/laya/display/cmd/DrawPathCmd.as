package laya.display.cmd {
	import laya.resource.Context;
	import laya.utils.Pool;
	
	/**
	 * 根据路径绘制矢量图形
	 */
	public class DrawPathCmd {
		public static const ID:String = "DrawPath";
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		public var x:Number;
		public var y:Number;
		public var paths:Array;
		public var brush:Object;
		public var pen:Object;
		
		public static function create(x:Number, y:Number, paths:Array, brush:Object, pen:Object):DrawPathCmd {
			var cmd:DrawPathCmd = Pool.getItemByClass("DrawPathCmd", DrawPathCmd);
			cmd.x = x;
			cmd.y = y;
			cmd.paths = paths;
			cmd.brush = brush;
			cmd.pen = pen;
			return cmd;
		}
		
		/**
		 * 回收到对象池
		 */
		public function recover():void {
			paths = null;
			brush = null;
			pen = null;
			Pool.recover("DrawPathCmd", this);
		}
		
		/**@private */
		public function run(context:Context, gx:Number, gy:Number):void {
			context._drawPath(x + gx, y + gy, paths, brush, pen);
		}
		
		public function get cmdID():String {
			return ID;
		}
	
	}
}
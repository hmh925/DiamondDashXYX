package laya.display.cmd {
	import laya.maths.Point;
	import laya.resource.Context;
	import laya.utils.Pool;
	/**
	 * 缩放命令
	 */
	public class ScaleCmd {
		public static const ID:String = "Scale";
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		public var scaleX:Number;
		public var scaleY:Number;
		public var pivotX:Number;
		public var pivotY:Number;
		
		public static function create(scaleX:Number, scaleY:Number, pivotX:Number, pivotY:Number):ScaleCmd {
			var cmd:ScaleCmd = Pool.getItemByClass("ScaleCmd", ScaleCmd);
			cmd.scaleX = scaleX;
			cmd.scaleY = scaleY;
			cmd.pivotX = pivotX;
			cmd.pivotY = pivotY;
			return cmd;
		}
		
		/**
		 * 回收到对象池
		 */
		public function recover():void {
			
			Pool.recover("ScaleCmd", this);
		}
		
		/**@private */
		public function run(context:Context, gx:Number, gy:Number):void {
			context._scale(scaleX, scaleY, pivotX + gx, pivotY + gy);
		}
		
		public function get cmdID():String {
			return ID;
		}
	
	}
}
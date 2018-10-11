package laya.display.cmd {
	import laya.resource.Context;
	import laya.utils.Pool;
	
	/**
	 * 旋转命令
	 */
	public class RotateCmd {
		public static const ID:String = "Rotate";
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		public var angle:Number;
		public var pivotX:Number;
		public var pivotY:Number;
		
		public static function create(angle:Number, pivotX:Number, pivotY:Number):RotateCmd {
			var cmd:RotateCmd = Pool.getItemByClass("RotateCmd", RotateCmd);
			cmd.angle = angle;
			cmd.pivotX = pivotX;
			cmd.pivotY = pivotY;
			return cmd;
		}
		
		/**
		 * 回收到对象池
		 */
		public function recover():void {
			
			Pool.recover("RotateCmd", this);
		}
		
		/**@private */
		public function run(context:Context, gx:Number, gy:Number):void {
			context._rotate(angle, pivotX + gx, pivotY + gy);
		}
		
		public function get cmdID():String {
			return ID;
		}
	
	}
}
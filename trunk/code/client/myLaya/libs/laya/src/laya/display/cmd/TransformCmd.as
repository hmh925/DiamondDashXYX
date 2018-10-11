package laya.display.cmd {
	import laya.maths.Matrix;
	import laya.resource.Context;
	import laya.utils.Pool;
	
	/**
	 * 矩阵命令
	 */
	public class TransformCmd {
		public static const ID:String = "Transform";
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		public var matrix:Matrix;
		public var pivotX:Number;
		public var pivotY:Number;
		
		public static function create(matrix:Matrix, pivotX:Number, pivotY:Number):TransformCmd {
			var cmd:TransformCmd = Pool.getItemByClass("TransformCmd", TransformCmd);
			cmd.matrix = matrix;
			cmd.pivotX = pivotX;
			cmd.pivotY = pivotY;
			return cmd;
		}
		
		/**
		 * 回收到对象池
		 */
		public function recover():void {
			matrix = null;
			Pool.recover("TransformCmd", this);
		}
		
		/**@private */
		public function run(context:Context, gx:Number, gy:Number):void {
			context._transform(matrix, pivotX + gx, pivotY + gy);
		}
		
		public function get cmdID():String {
			return ID;
		}
	
	}
}
package laya.display.cmd {
	import laya.maths.Point;
	import laya.resource.Context;
	import laya.utils.Pool;
	/**
	 * 位移命令
	 */
	public class TranslateCmd {
		public static const ID:String = "Translate";
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		public var tx:Number;
		public var ty:Number;
		
		public static function create(tx:Number, ty:Number):TranslateCmd {
			var cmd:TranslateCmd = Pool.getItemByClass("TranslateCmd", TranslateCmd);
			cmd.tx = tx;
			cmd.ty = ty;
			return cmd;
		}
		
		/**
		 * 回收到对象池
		 */
		public function recover():void {
			
			Pool.recover("TranslateCmd", this);
		}
		
		/**@private */
		public function run(context:Context, gx:Number, gy:Number):void {
			context.translate(tx, ty);
		}
		
		public function get cmdID():String {
			return ID;
		}
	
	}
}
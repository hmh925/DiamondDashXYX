package laya.display.cmd {
	import laya.maths.Point;
	import laya.resource.Context;
	import laya.resource.Texture;
	import laya.utils.Pool;
	import laya.maths.Matrix;
	
	/**
	 * 绘制圆形
	 */
	public class DrawParticleCmd {
		public static const ID:String = "DrawParticleCmd";
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		private var _templ:*;
		
		public static function create(_temp:*):DrawParticleCmd {
			var cmd:DrawParticleCmd = Pool.getItemByClass("DrawParticleCmd", DrawParticleCmd);
			cmd._templ = _temp;
			return cmd;
		}
		
		/**
		 * 回收到对象池
		 */
		public function recover():void {
			_templ = null;
			Pool.recover("DrawParticleCmd", this);
		}
		
		/**@private */
		public function run(context:Context, gx:Number, gy:Number):void {
			//这个只有webgl在用
			context.drawParticle(gx, gy, _templ);
		}
		
		public function get cmdID():String {
			return ID;
		}
	}
}
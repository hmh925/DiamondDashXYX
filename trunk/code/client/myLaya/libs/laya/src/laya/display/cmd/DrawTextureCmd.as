package laya.display.cmd {
	import laya.maths.Matrix;
	import laya.resource.Context;
	import laya.resource.Texture;
	import laya.utils.Pool;
	
	/**
	 * 绘制单个贴图
	 */
	public class DrawTextureCmd {
		public static const ID:String = "DrawTexture";
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		public var texture:Texture;
		public var x:Number;
		public var y:Number;
		public var width:Number;
		public var height:Number;
		public var matrix:Matrix;
		public var alpha:Number;
		public var color:String;
		public var blendMode:String;
		
		public static function create(texture:Texture, x:Number, y:Number, width:Number, height:Number, matrix:Matrix, alpha:Number, color:String, blendMode:String):DrawTextureCmd {
			var cmd:DrawTextureCmd = Pool.getItemByClass("DrawTextureCmd", DrawTextureCmd);
			cmd.texture = texture;
			texture._addReference();
			cmd.x = x;
			cmd.y = y;
			cmd.width = width;
			cmd.height = height;
			cmd.matrix = matrix;
			cmd.alpha = alpha;
			cmd.color = color;
			cmd.blendMode = blendMode;
			return cmd;
		}
		
		/**
		 * 回收到对象池
		 */
		public function recover():void {
			texture._removeReference();
			texture = null;
			matrix = null;
			Pool.recover("DrawTextureCmd", this);
		}
		
		/**@private */
		public function run(context:Context, gx:Number, gy:Number):void {
			context.drawTextureWithTransform(texture, x, y, width, height, matrix, gx, gy, alpha, blendMode);
		}
		
		public function get cmdID():String {
			return ID;
		}
	
	}
}
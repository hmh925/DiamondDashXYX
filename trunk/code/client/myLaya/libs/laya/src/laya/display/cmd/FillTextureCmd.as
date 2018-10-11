package laya.display.cmd {
	import laya.maths.Point;
	import laya.resource.Context;
	import laya.resource.Texture;
	import laya.utils.Pool;
	
	/**
	 * 填充贴图
	 */
	public class FillTextureCmd {
		public static const ID:String = "FillTexture";
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		public var texture:Texture;
		public var x:Number;
		public var y:Number;
		public var width:Number;
		public var height:Number;
		public var type:String;
		public var offset:Point;
		public var other:Object;
		
		public static function create(texture:Texture, x:Number, y:Number, width:Number, height:Number, type:String, offset:Point, other:Object):FillTextureCmd {
			var cmd:FillTextureCmd = Pool.getItemByClass("FillTextureCmd", FillTextureCmd);
			cmd.texture = texture;
			cmd.x = x;
			cmd.y = y;
			cmd.width = width;
			cmd.height = height;
			cmd.type = type;
			cmd.offset = offset;
			cmd.other = other;
			return cmd;
		}
		
		/**
		 * 回收到对象池
		 */
		public function recover():void {
			texture = null;
			offset = null;
			other = null;
			Pool.recover("FillTextureCmd", this);
		}
		
		/**@private */
		public function run(context:Context, gx:Number, gy:Number):void {
			context.fillTexture(texture, x + gx, y + gy, width, height, type, offset, other);
		}
		
		public function get cmdID():String {
			return ID;
		}
	
	}
}
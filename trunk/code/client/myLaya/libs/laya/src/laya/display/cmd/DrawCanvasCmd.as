package laya.display.cmd {
	import laya.utils.Pool;
	
	/**
	 * 绘制Canvas贴图
	 */
	public class DrawCanvasCmd {
		public static const ID:String = "DrawCanvasCmd";
		public static var _DRAW_IMAGE_CMD_ENCODER_:* = null;
		public static var _PARAM_TEXTURE_POS_:int = 2;
		public static var _PARAM_VB_POS_:int = 5;
		
		private var _graphicsCmdEncoder:*;
		private var _index:int;
		private var _paramData:* = null;
		public var texture:*/*RenderTexture2D*/;
		public var x:Number;
		public var y:Number;
		public var width:Number;
		public var height:Number;
		
		public static function create(texture:*/*RenderTexture2D*/, x:Number, y:Number, width:Number, height:Number):DrawCanvasCmd {
			return null;
		}
		
		/**
		 * 回收到对象池
		 */
		public function recover():void {
			_graphicsCmdEncoder = null;
			Pool.recover("DrawCanvasCmd", this);
		}
		
		public function get cmdID():String {
			return ID;
		}
	
	}
}
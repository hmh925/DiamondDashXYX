package laya.d3.core.material {
	import laya.d3.core.TransformUV;
	import laya.d3.core.render.RenderQueue;
	import laya.d3.core.scene.Scene3D;
	import laya.d3.resource.DataTexture2D;
	import laya.d3.shader.Shader3D;
	import laya.d3.shader.ShaderData;
	import laya.d3.shader.ShaderDefines;
	import laya.utils.Browser;
	import laya.webgl.WebGLContext;
	import laya.webgl.resource.BaseTexture;
	
	public class PBRMaterial extends BaseMaterial {
		public static const DIFFUSETEXTURE:int = 1;
		public static const NORMALTEXTURE:int = 2;
		public static const PBRINFOTEXTURE:int = 3;
		public static const PBRLUTTEXTURE:int = 4;
		public static const UVANIAGE:int = 5;
		public static const MATERIALROUGHNESS:int = 6;
		public static const MATERIALMETALESS:int = 7;
		public static const UVMATRIX:int = 8;
		public static const UVAGE:int = 9;
		public static const AOOBJPOS:int = 14;
		public static const HSNOISETEXTURE:int = 15;
		
		public static var SHADERDEFINE_FIX_ROUGHNESS:int = 0;
		public static var SHADERDEFINE_FIX_METALESS:int = 0;
		public static var SHADERDEFINE_HAS_TANGENT:int = 0;
		public static var SHADERDEFINE_TEST_CLIPZ:int = 0;
		public static var SHADERDEFINE_HAS_PBRINFO:int = 0;
		public static var SHADERDEFINE_USE_GROUNDTRUTH:int = 0;
		
		/**渲染状态_不透明。*/
		public static const RENDERMODE_OPAQUE:int = 1;
		/**渲染状态_不透明_双面。*/
		public static const RENDERMODE_OPAQUEDOUBLEFACE:int = 2;
		/**渲染状态_透明测试。*/
		public static const RENDERMODE_CUTOUT:int = 3;
		/**渲染状态_透明测试_双面。*/
		public static const RENDERMODE_CUTOUTDOUBLEFACE:int = 4;
		/**渲染状态_透明混合。*/
		public static const RENDERMODE_TRANSPARENT:int = 13;
		
		public static var pbrlutTex:DataTexture2D;
		
		public static var HammersleyNoiseTex:DataTexture2D;
		/** @private */
		protected var _transformUV:TransformUV = null;
		
		/** 默认材质，禁止修改*/
		public static const defaultMaterial:PBRMaterial = new PBRMaterial();
		
		/**@private */
		public static var shaderDefines:ShaderDefines = new ShaderDefines(BaseMaterial.shaderDefines);
		
		/**
		 * @private
		 */
		public static function __init__():void {
			SHADERDEFINE_FIX_METALESS = shaderDefines.registerDefine("FIX_METALESS");
			SHADERDEFINE_FIX_ROUGHNESS = shaderDefines.registerDefine("FIX_ROUGHNESS");
			SHADERDEFINE_HAS_TANGENT = shaderDefines.registerDefine("HAS_TANGENT");
			SHADERDEFINE_HAS_PBRINFO = shaderDefines.registerDefine("HAS_PBRINFO");
			SHADERDEFINE_USE_GROUNDTRUTH = shaderDefines.registerDefine("USE_GROUNDTRUTH");
			SHADERDEFINE_TEST_CLIPZ = shaderDefines.registerDefine("CLIPZ");
		}
		
		/**
		 * 获取粗糙度的值，0为特别光滑，1为特别粗糙。
		 * @return 粗糙度的值。
		 */
		public function get roughness():Number {
			return _shaderValues.getNumber(MATERIALROUGHNESS);
		}
		
		/**
		 * 设置粗糙度的值，0为特别光滑，1为特别粗糙。
		 * @param value 粗糙度。
		 */
		public function set roughness(value:Number):void {
			_shaderValues.setNumber(MATERIALROUGHNESS, value);
			_defineDatas.add(SHADERDEFINE_FIX_ROUGHNESS);
		}
		
		public function get metaless():Number {
			return _shaderValues.getNumber(MATERIALMETALESS);
		}
		
		public function set metaless(v:Number):void {
			_shaderValues.setNumber(MATERIALMETALESS, v);
			_defineDatas.add(SHADERDEFINE_FIX_METALESS);
		}
		
		public function set has_tangent(v:Boolean):void {
			_defineDatas.add(SHADERDEFINE_HAS_TANGENT);
		}
		
		public function set use_groundtruth(v:Boolean):void {
			if (v) {
				_defineDatas.add(SHADERDEFINE_USE_GROUNDTRUTH);
				//创建随机值查找表
				if (!PBRMaterial.HammersleyNoiseTex) {
					var texdata:Uint8Array = createHammersleyTex(32, 32);
					PBRMaterial.HammersleyNoiseTex = DataTexture2D.create(texdata.buffer, 32, 32, WebGLContext.NEAREST, WebGLContext.NEAREST, false);
				}
				_shaderValues.setTexture(HSNOISETEXTURE, HammersleyNoiseTex);
			} else {
				PBRMaterial.HammersleyNoiseTex = null;
				_defineDatas.remove(SHADERDEFINE_USE_GROUNDTRUTH);
			}
		}
		
		/**
		 * 获取漫反射贴图。
		 * @return 漫反射贴图。
		 */
		public function get diffuseTexture():BaseTexture {
			return _shaderValues.getTexture(DIFFUSETEXTURE);
		}
		
		/**
		 * 设置漫反射贴图。
		 * @param value 漫反射贴图。
		 */
		public function set diffuseTexture(value:BaseTexture):void {
			_shaderValues.setTexture(DIFFUSETEXTURE, value);
		}
		
		/**
		 * 获取PBRLUT贴图。
		 * @return PBRLUT贴图。
		 */
		public function get pbrlutTexture():BaseTexture {
			return _shaderValues.getTexture(PBRLUTTEXTURE);
		}
		
		/**
		 * 设置PBRLUT贴图。
		 * @param value PBRLUT贴图。
		 */
		public function set pbrlutTexture(value:BaseTexture):void {
			_shaderValues.setTexture(PBRLUTTEXTURE, value);
		}
		
		/**
		 * 获取法线贴图。
		 * @return 法线贴图。
		 */
		public function get normalTexture():BaseTexture {
			return _shaderValues.getTexture(NORMALTEXTURE);
		}
		
		/**
		 * 设置法线贴图。
		 * @param value 法线贴图。
		 */
		public function set normalTexture(value:BaseTexture):void {
			_shaderValues.setTexture(NORMALTEXTURE, value);
		}
		
		/**
		 * 获取pbr信息贴图。
		 * @return pbr信息贴图。
		 */
		public function get pbrInfoTexture():BaseTexture {
			return _shaderValues.getTexture(PBRINFOTEXTURE);
		}
		
		/**
		 * 设置pbr信息贴图。
		 * @param value pbr信息贴图。
		 */
		public function set pbrInfoTexture(value:BaseTexture):void {
			_shaderValues.setTexture(PBRINFOTEXTURE, value);
			_defineDatas.add(SHADERDEFINE_HAS_PBRINFO);
		}
		
		/**
		 * 获取UV变换。
		 * @return  UV变换。
		 */
		public function get transformUV():TransformUV {
			return _transformUV;
		}
		
		/**
		 * 设置UV变换。
		 * @param value UV变换。
		 */
		public function set transformUV(value:TransformUV):void {
			_transformUV = value;
			_shaderValues.setMatrix4x4(UVMATRIX, value.matrix);
		}
		
		public function PBRMaterial() {
			super(15);
			if (!PBRMaterial.pbrlutTex) {
				var lutdt:Array = Browser.window['__pbrlutdata'];
				if (!lutdt) {
					alert('no pbr lutdata, need pbrlut.js');
					throw 'no pbr lutdata, need pbrlut.js';
				}
				var luttex:DataTexture2D = DataTexture2D.create((new Uint32Array(lutdt)).buffer, 256, 256, WebGLContext.NEAREST, WebGLContext.NEAREST, false);
				//luttex.repeat = false; 编译不过
				PBRMaterial.pbrlutTex = luttex;
			}
			_shaderValues.setTexture(PBRLUTTEXTURE, PBRMaterial.pbrlutTex);
			setShaderName("PBR");
			_shaderValues.setNumber(ALPHATESTVALUE, 0.5);
			use_groundtruth = false;
		}
		
		/**
		 * 禁用灯光。
		 */
		public function disableLight():void {
			_defineDatas.add(Scene3D.SHADERDEFINE_POINTLIGHT | Scene3D.SHADERDEFINE_SPOTLIGHT | Scene3D.SHADERDEFINE_DIRECTIONLIGHT);
		}
		
		/**
		 * 禁用雾化。
		 */
		public function disableFog():void {
			_defineDatas.add(Scene3D.SHADERDEFINE_FOG);
		}
		
		public function set renderMode(value:int):void {
			var renderState:RenderState = getRenderState();
			switch (value) {
			case RENDERMODE_OPAQUE: 
				renderQueue = BaseMaterial.RENDERQUEUE_OPAQUE;
				renderState.depthWrite = true;
				renderState.cull = RenderState.CULL_BACK;
				renderState.blend = RenderState.BLEND_DISABLE;
				alphaTest = false;
				break;
			case RENDERMODE_OPAQUEDOUBLEFACE: 
				renderQueue = BaseMaterial.RENDERQUEUE_OPAQUE;
				renderState.depthWrite = true;
				renderState.cull = RenderState.CULL_NONE;
				renderState.blend = RenderState.BLEND_DISABLE;
				alphaTest = false;
				break;
			case RENDERMODE_CUTOUT: 
				renderState.depthWrite = true;
				renderState.cull = RenderState.CULL_BACK;
				renderState.blend = RenderState.BLEND_DISABLE;
				renderQueue = BaseMaterial.RENDERQUEUE_ALPHATEST;
				break;
			case RENDERMODE_TRANSPARENT: 
				renderQueue = BaseMaterial.RENDERQUEUE_TRANSPARENT;
				renderState.depthWrite = true;
				renderState.cull = RenderState.CULL_BACK;
				renderState.blend = RenderState.BLEND_ENABLE_ALL;
				renderState.srcBlend = RenderState.BLENDPARAM_SRC_ALPHA;
				renderState.dstBlend = RenderState.BLENDPARAM_ONE_MINUS_SRC_ALPHA;
				break;
			default: 
				throw new Error("PBRMaterial:renderMode value error.");
			}
		}
		
		public function set testClipZ(v:Boolean):void {
			_defineDatas.add(SHADERDEFINE_TEST_CLIPZ);
		}
		
		/**
		 * vdc算法产生的序列。这个比random要均匀一些。
		 */
		public function radicalInverse_VdC(bits:int):Number {
			var tmpUint:Uint32Array = new Uint32Array(1);
			return (function(bits:Number):Number {
				//先颠倒前后16位
				bits = (bits << 16) | (bits >>> 16);
				//下面颠倒16位中的前后8位
				bits = ((bits & 0x55555555) << 1) | ((bits & 0xAAAAAAAA) >>> 1);
				bits = ((bits & 0x33333333) << 2) | ((bits & 0xCCCCCCCC) >>> 2);
				bits = ((bits & 0x0F0F0F0F) << 4) | ((bits & 0xF0F0F0F0) >>> 4);
				bits = ((bits & 0x00FF00FF) << 8) | ((bits & 0xFF00FF00) >>> 8);
				//必须是uint的
				tmpUint[0] = bits;
				return tmpUint[0] * 2.3283064365386963e-10; // / 0x100000000
			})(bits);
		}
		
		/**
		 *
		 */
		public function createHammersleyTex(w:int, h:int):Uint8Array {
			var ret:Uint8Array = new Uint8Array(w * h * 4);
			var ri:int = 0;
			var ci:int = 0;
			for (ci = 0; ci < w * h; ci++) {
				var v:Number = radicalInverse_VdC(ci);
				ret[ri++] = v * 255;
				ret[ri++] = 0;
				ret[ri++] = 0;
				ret[ri++] = 255;
			}
			return ret;
		}
	}
}
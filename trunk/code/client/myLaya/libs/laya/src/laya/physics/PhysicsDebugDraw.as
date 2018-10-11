package laya.physics {
	import laya.display.Sprite;
	import laya.renders.Render;
	import laya.resource.Context;
	import laya.utils.Browser;
	
	/**
	 * @private webgl+非fixed模式有bug
	 * box2d物理辅助线，调用PhysicsDebugDraw.enable()开启
	 */
	public class PhysicsDebugDraw extends Sprite {
		public var m_drawFlags:int = 99;
		public static var box2d:*;
		public static var DrawString_s_color:*;
		public static var DrawStringWorld_s_p:*;
		public static var DrawStringWorld_s_cc:*;
		public static var DrawStringWorld_s_color:*;
		public var world:*;
		public var m_ctx:*;
		private var g_camera:Object;
		private static var canvas:*;
		private static var _inited:Boolean = false;
		
		public static function init():void {
			box2d = Browser.window.box2d;
			DrawString_s_color = new box2d.b2Color(0.9, 0.6, 0.6);
			DrawStringWorld_s_p = new box2d.b2Vec2();
			DrawStringWorld_s_cc = new box2d.b2Vec2();
			DrawStringWorld_s_color = new box2d.b2Color(0.5, 0.9, 0.5);
		}
		
		public function PhysicsDebugDraw() {
			this.customRenderEnable = true;
			
			if (!_inited) {
				_inited = true;
				init();
			}
			g_camera = {};
			g_camera.m_center = new box2d.b2Vec2(0, 0);
			g_camera.m_extent = 25;
			g_camera.m_zoom = 1;
			g_camera.m_width = 1280;
			g_camera.m_height = 800;
			
			if (Render.isWebGL) {
				initInitCanvas();
			}
		}
		
		private function initInitCanvas():void {
			if (!canvas) {
				canvas = Browser.window.document.createElement("canvas");
				m_ctx = canvas.getContext("2d");
				canvas.width = Laya.stage.width;
				canvas.height = Laya.stage.height;
				var style:Object;
				style = canvas.style;
				style.position = "absolute";
				style.pointerEvents = "none";
				style.left = "0px";
				style.top = "0px";
				style["z-index"] = 999999;
				Browser.window.document.body.appendChild(canvas);
			}
		}
		
		override public function customRender(context:Context, x:Number, y:Number):void {
			//debugger;
			super.customRender(context, x, y);
			if (!Render.isWebGL) {
				m_ctx = context.ctx || context;
			} else {
				canvas.width = canvas.width;
			}
			
			if (world) {
				m_ctx.save();
				m_ctx.scale(Physics.PIXEL_RATIO, Physics.PIXEL_RATIO);
				m_ctx.lineWidth /= Physics.PIXEL_RATIO;
				world.DrawDebugData();
				m_ctx.restore();
			}
		}
		
		public function SetFlags(flags:int):void {
			this.m_drawFlags = flags;
		}
		
		public function GetFlags():int {
			return this.m_drawFlags;
		}
		
		public function AppendFlags(flags:int):void {
			this.m_drawFlags |= flags;
		}
		
		public function ClearFlags(flags:*):void {
			this.m_drawFlags &= ~flags;
		}
		
		public function PushTransform(xf:*):void {
			var ctx:* = this.m_ctx;
			if (ctx) {
				ctx.save();
				ctx.translate(xf.p.x, xf.p.y);
				ctx.rotate(xf.q.GetAngle());
			}
		}
		
		public function PopTransform(xf:*):void {
			var ctx:* = this.m_ctx;
			if (ctx) {
				ctx.restore();
			}
		}
		
		public function DrawPolygon(vertices:*, vertexCount:*, color:*):void {
			var ctx:* = this.m_ctx;
			if (ctx) {
				ctx.beginPath();
				ctx.moveTo(vertices[0].x, vertices[0].y);
				for (var i:int = 1; i < vertexCount; i++) {
					ctx.lineTo(vertices[i].x, vertices[i].y);
				}
				ctx.closePath();
				ctx.strokeStyle = color.MakeStyleString(1);
				ctx.stroke();
			}
		}
		
		public function DrawSolidPolygon(vertices:*, vertexCount:*, color:*):void {
			var ctx:* = this.m_ctx;
			if (ctx) {
				ctx.beginPath();
				ctx.moveTo(vertices[0].x, vertices[0].y);
				for (var i:int = 1; i < vertexCount; i++) {
					ctx.lineTo(vertices[i].x, vertices[i].y);
				}
				ctx.closePath();
				ctx.fillStyle = color.MakeStyleString(0.5);
				ctx.fill();
				ctx.strokeStyle = color.MakeStyleString(1);
				ctx.stroke();
			}
		}
		
		public function DrawCircle(center:*, radius:*, color:*):void {
			var ctx:* = this.m_ctx;
			if (ctx) {
				ctx.beginPath();
				ctx.arc(center.x, center.y, radius, 0, box2d.b2_pi * 2, true);
				ctx.strokeStyle = color.MakeStyleString(1);
				ctx.stroke();
			}
		}
		
		public function DrawSolidCircle(center:*, radius:*, axis:*, color:*):void {
			var ctx:* = this.m_ctx;
			if (ctx) {
				var cx:* = center.x;
				var cy:* = center.y;
				ctx.beginPath();
				ctx.arc(cx, cy, radius, 0, box2d.b2_pi * 2, true);
				ctx.moveTo(cx, cy);
				ctx.lineTo((cx + axis.x * radius), (cy + axis.y * radius));
				ctx.fillStyle = color.MakeStyleString(0.5);
				ctx.fill();
				ctx.strokeStyle = color.MakeStyleString(1);
				ctx.stroke();
			}
		}
		
		// #if B2_ENABLE_PARTICLE
		public function DrawParticles(centers:*, radius:*, colors:*, count:*):void {
			var ctx:* = this.m_ctx;
			if (ctx) {
				if (colors !== null) {
					for (var i:int = 0; i < count; ++i) {
						var center:* = centers[i];
						var color:* = colors[i];
						ctx.fillStyle = color.MakeStyleString();
						// ctx.fillRect(center.x - radius, center.y - radius, 2 * radius, 2 * radius);
						ctx.beginPath();
						ctx.arc(center.x, center.y, radius, 0, box2d.b2_pi * 2, true);
						ctx.fill();
					}
				} else {
					ctx.fillStyle = "rgba(255,255,255,0.5)";
					// ctx.beginPath();
					for (i = 0; i < count; ++i) {
						center = centers[i];
						// ctx.rect(center.x - radius, center.y - radius, 2 * radius, 2 * radius);
						ctx.beginPath();
						ctx.arc(center.x, center.y, radius, 0, box2d.b2_pi * 2, true);
						ctx.fill();
					}
						// ctx.fill();
				}
			}
		}
		
		// #endif
		public function DrawSegment(p1:*, p2:*, color:*):void {
			var ctx:* = this.m_ctx;
			if (ctx) {
				ctx.beginPath();
				ctx.moveTo(p1.x, p1.y);
				ctx.lineTo(p2.x, p2.y);
				ctx.strokeStyle = color.MakeStyleString(1);
				ctx.stroke();
			}
		}
		
		public function DrawTransform(xf:*):void {
			var ctx:* = this.m_ctx;
			if (ctx) {
				this.PushTransform(xf);
				ctx.beginPath();
				ctx.moveTo(0, 0);
				ctx.lineTo(1, 0);
				ctx.strokeStyle = box2d.b2Color.RED.MakeStyleString(1);
				ctx.stroke();
				ctx.beginPath();
				ctx.moveTo(0, 0);
				ctx.lineTo(0, 1);
				ctx.strokeStyle = box2d.b2Color.GREEN.MakeStyleString(1);
				ctx.stroke();
				this.PopTransform(xf);
			}
		}
		
		public function DrawPoint(p:*, size:*, color:*):void {
			var ctx:* = this.m_ctx;
			if (ctx) {
				ctx.fillStyle = color.MakeStyleString();
				size *= g_camera.m_zoom;
				size /= g_camera.m_extent;
				var hsize:* = size / 2;
				ctx.fillRect(p.x - hsize, p.y - hsize, size, size);
			}
		}
		
		public function DrawString(x:*, y:*, message:*):void {
			var ctx:* = this.m_ctx;
			if (ctx) {
				ctx.save();
				ctx.setTransform(1, 0, 0, 1, 0, 0);
				ctx.font = "15px DroidSans";
				var color:* = DrawString_s_color;
				ctx.fillStyle = color.MakeStyleString();
				ctx.fillText(message, x, y);
				ctx.restore();
			}
		}
		
		public function DrawStringWorld(x:*, y:*, message:*):void {
			var ctx:* = this.m_ctx;
			if (ctx) {
				var p:* = DrawStringWorld_s_p.Set(x, y);
				// world -> viewport
				var vt:* = g_camera.m_center;
				box2d.b2Vec2.SubVV(p, vt, p);
				///const vr = g_camera.m_roll;
				///box2d.b2Rot.MulTRV(vr, p, p);
				var vs:* = g_camera.m_zoom;
				box2d.b2Vec2.MulSV(1 / vs, p, p);
				// viewport -> canvas
				var cs:* = 0.5 * g_camera.m_height / g_camera.m_extent;
				box2d.b2Vec2.MulSV(cs, p, p);
				p.y *= -1;
				var cc:* = DrawStringWorld_s_cc.Set(0.5 * ctx.canvas.width, 0.5 * ctx.canvas.height);
				box2d.b2Vec2.AddVV(p, cc, p);
				ctx.save();
				ctx.setTransform(1, 0, 0, 1, 0, 0);
				ctx.font = "15px DroidSans";
				var color:* = DrawStringWorld_s_color;
				ctx.fillStyle = color.MakeStyleString();
				ctx.fillText(message, p.x, p.y);
				ctx.restore();
			}
		}
		
		public function DrawAABB(aabb:*, color:*):void {
			var ctx:* = this.m_ctx;
			if (ctx) {
				ctx.strokeStyle = color.MakeStyleString();
				var x:int = aabb.lowerBound.x;
				var y:int = aabb.lowerBound.y;
				var w:int = aabb.upperBound.x - aabb.lowerBound.x;
				var h:int = aabb.upperBound.y - aabb.lowerBound.y;
				ctx.strokeRect(x, y, w, h);
			}
		}
		
		public static var I:PhysicsDebugDraw;
		
		/**
		 * 激活box2d物理辅助线
		 */
		public static function enable():void {
			if (!I) {
				var debug:PhysicsDebugDraw = new PhysicsDebugDraw();
				debug.world = Physics.I.world;
				debug.world.SetDebugDraw(debug);
				debug.zOrder = 1000;
				Laya.stage.addChild(debug);
				I = debug;
			}
		}
	}
}
package laya.physics {
	import laya.components.Component;
	import laya.display.Sprite;
	import laya.maths.Point;
	import laya.utils.Utils;
	
	/**
	 * 2D刚体
	 */
	public class RigidBody extends Component {
		/**
		 * 刚体类型，支持三种类型static，dynamic和kinematic类型，默认为dynamic类型
		 * static为静态类型，静止不动，不受重力影响，质量无限大，可以通过节点移动，旋转，缩放进行控制
		 * dynamic为动态类型，受重力影响
		 * kinematic为运动类型，不受重力影响，可以通过施加速度或者力的方式使其运动
		 */
		protected var _type:String = "dynamic";
		/**是否允许休眠，允许休眠能提高性能*/
		protected var _allowSleep:Boolean = true;
		/**角速度，设置会导致旋转*/
		protected var _angularVelocity:Number = 0;
		/**旋转速度阻尼系数，范围可以在0到无穷大之间，0表示没有阻尼，无穷大表示满阻尼，通常阻尼的值应该在0到0.1之间*/
		protected var _angularDamping:Number = 0;
		/**线性运动速度，比如10,10*/
		protected var _linearVelocity:Array = [0, 0];
		/**线性速度阻尼系数，范围可以在0到无穷大之间，0表示没有阻尼，无穷大表示满阻尼，通常阻尼的值应该在0到0.1之间*/
		protected var _linearDamping:Number = 0;
		/**是否高速移动的物体，设置为true，可以防止高速穿透*/
		protected var _bullet:Boolean = false;
		/**是否允许旋转，如果不希望刚体旋转，这设置为false*/
		protected var _allowRotation:Boolean = true;
		/**重力缩放系数，设置为0为没有重力*/
		protected var _gravityScale:Number = 1;
		
		/**[只读] 指定了该主体所属的碰撞组，默认为0，碰撞规则如下：
		 * 1.如果两个对象group相等
		 * 		group值大于零，它们将始终发生碰撞
		 * 		group值小于零，它们将永远不会发生碰撞
		 * 		group值等于0，则使用规则3
		 * 2.如果group值不相等，则使用规则3
		 * 3.每个刚体都有一个category类别，此属性接收位字段，范围为[1,2^31]范围内的2的幂
		 * 每个刚体也都有一个mask类别，指定与其碰撞的类别值之和（值是所有category按位AND的值）
		 */
		public var group:int = 0;
		/**[只读]碰撞类别，使用2的幂次方值指定，有32种不同的碰撞类别可用*/
		public var category:int = 1;
		/**[只读]指定冲突位掩码碰撞的类别，category位操作的结果*/
		public var mask:int = -1;
		/**[只读]自定义标签*/
		public var label:String = "RigidBody";
		/**[只读]原始刚体*/
		public var body:*;
		
		private function _createBody():void {
			if (body) return;
			var sp:Sprite = owner as Sprite;
			var box2d:* = window.box2d;
			var def:* = new box2d.b2BodyDef();
			var point:Point = Sprite(owner).localToGlobal(Point.TEMP.setTo(0, 0), false, Physics.I.worldRoot);
			//TODO：可以复用
			def.position.Set(point.x / Physics.PIXEL_RATIO, point.y / Physics.PIXEL_RATIO);
			def.angle = Utils.toRadian(sp.rotation);
			def.allowSleep = _allowSleep;
			def.angularDamping = _angularDamping;
			def.angularVelocity = _angularVelocity;
			def.bullet = _bullet;
			def.fixedRotation = !_allowRotation;
			def.gravityScale = _gravityScale;
			def.linearDamping = _linearDamping;
			var arr:Array = _linearVelocity;
			if (arr[0] != 0 || arr[1] != 0) {
				def.linearVelocity = new box2d.b2Vec2(arr[0], arr[1]);
			}
			def.type = box2d.b2BodyType["b2_" + _type + "Body"];
			//def.userData = label;
			
			body = Physics.I._createBody(def);
			//console.log(body);
			
			//查找碰撞体
			var comps:Array = owner.getComponents(ColliderBase);
			if (comps) {
				for (var i:int = 0, n:int = comps.length; i < n; i++) {
					var collider:ColliderBase = comps[i];
					collider.rigidBody = this;
					collider.refresh();
				}
			}
		}
		
		override protected function _onAwake():void {
			//todo body能否复用？
			this._createBody();
		}
		
		override protected function _onEnable():void {
			//todo body能否复用？
			this._createBody();
			//实时同步物理到节点
			Laya.physicsTimer.frameLoop(1, this, _sysPhysicToNode);
			
			//监听节点变化，同步到物理世界
			var sp:* = owner as Sprite;
			//如果节点发生变化，则同步到物理世界（仅限节点本身，父节点发生变化不会自动同步）
			if (sp._$set_x && !sp._changeByRigidBody) {
				sp._changeByRigidBody = true;
				function setX(value:*):void {
					sp._$set_x(value);
					_sysPosToPhysic();
				}
				_overSet(sp, "x", setX);
				
				function setY(value:*):void {
					sp._$set_y(value);
					_sysPosToPhysic();
				};
				_overSet(sp, "y", setY);
				
				function setRotation(value:*):void {
					sp._$set_rotation(value);
					_sysNodeToPhysic();
				};
				_overSet(sp, "rotation", setRotation);
			}
		}
		
		/**@private 同步物理坐标到游戏坐标*/
		private function _sysPhysicToNode():void {
			if (type != "static" && body.IsAwake()) {
				var pos:* = body.GetPosition();
				var ang:* = body.GetAngle();
				var sp:* = owner as Sprite;
				
				//if (label == "tank") console.log("get",ang);
				sp._$set_rotation(Utils.toAngle(ang) - Sprite(sp.parent).globalRotation);
				
				if (ang == 0) {
					var point:Point = sp.parent.globalToLocal(Point.TEMP.setTo(pos.x * Physics.PIXEL_RATIO + sp.pivotX, pos.y * Physics.PIXEL_RATIO + sp.pivotY), false, Physics.I.worldRoot);
					sp._$set_x(point.x);
					sp._$set_y(point.y);
				} else {
					point = sp.globalToLocal(Point.TEMP.setTo(pos.x * Physics.PIXEL_RATIO, pos.y * Physics.PIXEL_RATIO), false, Physics.I.worldRoot);
					point.x += sp.pivotX;
					point.y += sp.pivotY;
					point = sp.toParentPoint(point);
					sp._$set_x(point.x);
					sp._$set_y(point.y);
				}
			}
		}
		
		/**@private 同步节点坐标及旋转到物理世界*/
		private function _sysNodeToPhysic():void {
			var sp:Sprite = Sprite(owner);
			this.body.SetAngle(Utils.toRadian(sp.rotation));
			var p:Point = sp.localToGlobal(Point.TEMP.setTo(0, 0), false, Physics.I.worldRoot);
			this.body.SetPositionXY(p.x / Physics.PIXEL_RATIO, p.y / Physics.PIXEL_RATIO);
		}
		
		/**@private 同步节点坐标到物理世界*/
		private function _sysPosToPhysic():void {
			var sp:Sprite = Sprite(owner);
			var p:Point = sp.localToGlobal(Point.TEMP.setTo(0, 0), false, Physics.I.worldRoot);
			this.body.SetPositionXY(p.x / Physics.PIXEL_RATIO, p.y / Physics.PIXEL_RATIO);
		}
		
		/**@private */
		private function _overSet(sp:Sprite, prop:String, getfun:Function):void {
			__JS__('Object.defineProperty(sp, prop, {get: sp["_$get_" + prop], set: getfun, enumerable: false, configurable: true});');
		}
		
		override protected function _onDisable():void {
			//添加到物理世界
			Laya.physicsTimer.clear(this, _sysPhysicToNode);
			Physics.I._removeBody(body);
			body = null;
			
			var owner:* = this.owner;
			if (owner._changeByRigidBody) {
				_overSet(owner, "x", owner._$set_x);
				_overSet(owner, "y", owner._$set_y);
				_overSet(owner, "rotation", owner._$set_rotation);
				_overSet(owner, "scaleX", owner._$set_scaleX);
				_overSet(owner, "scaleY", owner._$set_scaleY);
				owner._changeByRigidBody = false;
			}
		}
		
		/**获得原始body对象 */
		public function getBody():* {
			if (!body) _onAwake();
			return body;
		}
		
		/**
		 * 对刚体施加力
		 * @param	position 施加力的点，如{x:100,y:100}，全局坐标
		 * @param	force	施加的力，如{x:0.1,y:0.1}
		 */
		public function applyForce(position:Object, force:Object):void {
			if (!body) _onAwake();
			body.ApplyForce(force, position);
		}
		
		/**
		 * 从中心点对刚体施加力，防止对象旋转
		 * @param	force	施加的力，如{x:0.1,y:0.1}
		 */
		public function applyForceToCenter(force:Object):void {
			if (!body) _onAwake();
			body.applyForceToCenter(force);
		}
		
		/**
		 * 施加速度冲量，添加的速度冲量会与刚体原有的速度叠加，产生新的速度
		 * @param	position 施加力的点，如{x:100,y:100}，全局坐标
		 * @param	impulse	施加的速度冲量，如{x:0.1,y:0.1}
		 */
		public function applyLinearImpulse(position:Object, impulse:Object):void {
			if (!body) _onAwake();
			body.ApplyLinearImpulse(impulse, position);
		}
		
		/**
		 * 施加速度冲量，添加的速度冲量会与刚体原有的速度叠加，产生新的速度
		 * @param	impulse	施加的速度冲量，如{x:0.1,y:0.1}
		 */
		public function applyLinearImpulseToCenter(impulse:Object):void {
			if (!body) _onAwake();
			body.ApplyLinearImpulseToCenter(impulse);
		}
		
		/**
		 * 对刚体施加扭矩，使其旋转
		 * @param	torque	施加的扭矩
		 */
		public function applyTorque(torque:Number):void {
			if (!body) _onAwake();
			body.ApplyTorque(torque);
		}
		
		/**
		 * 设置速度，比如{x:10,y:10}
		 * @param	velocity
		 */
		public function setVelocity(velocity:Object):void {
			if (!body) _onAwake();
			body.SetLinearVelocity(velocity);
		}
		
		/**
		 * 设置角度
		 * @param	value 单位为弧度
		 */
		public function setAngle(value:Object):void {
			if (!body) _onAwake();
			body.SetAngle(value);
			body.SetAwake(true);
		}
		
		/**获得刚体质量*/
		public function getMass():Number {
			return body ? body.GetMass() : 0;
		}
		
		/**
		 * 质心的相对节点0,0点的位置偏移
		 */
		public function getCenter():Point {
			if (!body) _onAwake();
			return body.GetLocalCenter();
		}
		
		/**
		 * 刚体类型，支持三种类型static，dynamic和kinematic类型
		 * static为静态类型，静止不动，不受重力影响，质量无限大，可以通过节点移动，旋转，缩放进行控制
		 * dynamic为动态类型，接受重力影响
		 * kinematic为运动类型，不受重力影响，可以通过施加速度或者力的方式使其运动
		 */
		public function get type():String {
			return _type;
		}
		
		public function set type(value:String):void {
			_type = value;
			if (body) body.SetType(window.box2d.b2BodyType["b2_" + _type + "Body"]);
		}
		
		/**重力缩放系数，设置为0为没有重力*/
		public function get gravityScale():Number {
			return _gravityScale;
		}
		
		public function set gravityScale(value:Number):void {
			_gravityScale = value;
			if (body) body.SetGravityScale(value);
		}
		
		/**是否允许旋转，如果不希望刚体旋转，这设置为false*/
		public function get allowRotation():Boolean {
			return _allowRotation;
		}
		
		public function set allowRotation(value:Boolean):void {
			_allowRotation = value;
			if (body) body.SetFixedRotation(!value);
		}
		
		/**是否允许休眠，允许休眠能提高性能*/
		public function get allowSleep():Boolean {
			return _allowSleep;
		}
		
		public function set allowSleep(value:Boolean):void {
			_allowSleep = value;
			if (body) body.SetSleepingAllowed(value);
		}
		
		/**旋转速度阻尼系数，范围可以在0到无穷大之间，0表示没有阻尼，无穷大表示满阻尼，通常阻尼的值应该在0到0.1之间*/
		public function get angularDamping():Number {
			return _angularDamping;
		}
		
		public function set angularDamping(value:Number):void {
			_angularDamping = value;
			if (body) body.SetAngularDamping(value);
		}
		
		/**角速度，设置会导致旋转*/
		public function get angularVelocity():Number {
			if (body) return body.GetAngularVelocity();
			return _angularVelocity;
		}
		
		public function set angularVelocity(value:Number):void {
			_angularVelocity = value;
			if (body) body.SetAngularVelocity(value);
		}
		
		/**线性速度阻尼系数，范围可以在0到无穷大之间，0表示没有阻尼，无穷大表示满阻尼，通常阻尼的值应该在0到0.1之间*/
		public function get linearDamping():Number {
			return _linearDamping;
		}
		
		public function set linearDamping(value:Number):void {
			_linearDamping = value;
			if (body) body.SetLinearDamping(value);
		}
		
		/**线性运动速度，比如[10,10]*/
		public function get linearVelocity():Array {
			if (body) {
				var vec:* = body.GetLinearVelocity();
				return [vec.x, vec.y];
			}
			return _linearVelocity;
		}
		
		public function set linearVelocity(value:Array):void {
			_linearVelocity = value;
			if (body) body.SetLinearVelocity(new window.box2d.b2Vec2(value[0], value[1]));
		}
		
		/**是否高速移动的物体，设置为true，可以防止高速穿透*/
		public function get bullet():Boolean {
			return _bullet;
		}
		
		public function set bullet(value:Boolean):void {
			_bullet = value;
			if (body) body.SetBullet(value);
		}
	}
}
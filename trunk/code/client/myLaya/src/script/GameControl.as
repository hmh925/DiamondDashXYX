package script {
	import laya.components.Prefab;
	import laya.components.Script;
	import laya.display.Sprite;
	import laya.events.Event;
	import laya.utils.Browser;
	import laya.utils.Pool;
	import laya.ui.List;
	import laya.d3.resource.models.primitiveGeometry;
	import laya.utils.Handler;
	import script.grid.*;
	import script.grid.GemData;
	import script.grid.henum.GemType;
	import script.grid.Gem;
	import laya.d3.math.Vector2;
	import laya.utils.Tween;
	import laya.media.SoundManager;
	import laya.display.Text;
	import laya.display.Animation;
	import script.grid.specialeffect.Bomb;
	import laya.d3.component.KeyframeNodeOwner;
	import script.grid.specialeffect.BaseSpecialEffect;
	import laya.ui.Image;
	/**
	 * 游戏控制脚本。定义了几个dropBox，bullet，createBoxInterval等变量，能够在IDE显示及设置该变量
	 * 更多类型定义，请参考官方文档
	 */
	public class GameControl extends Script {
		/** @prop {name:dropBox,tips:"掉落容器预制体对象",type:Prefab}*/
		public var dropBox:Prefab;
		/** @prop {name:bullet,tips:"子弹预制体对象",type:Prefab}*/
		public var bullet:Prefab;
		/** @prop {name:createBoxInterval,tips:"间隔多少毫秒创建一个下跌的容器",type:int,default=1000}*/
		public var updateTimeInterval:Number = 1000;
		/** @prop {name:gem,tips:"预制体对象",type:Prefab}*/
		public var gem:Prefab;
		/** @prop {name:specialEffect,tips:"效果",type:Prefab}*/
		public var specialEffect:Prefab;


		public static var instance:GameControl;

		/**开始时间*/
		private var _time:Number = 0;
		/**是否已经开始游戏 */
		private var _started:Boolean = false;
		/**子弹和盒子所在的容器对象 */
		private var _gameBox:Sprite;
		private var _gridContent:Sprite;
		private var _startPoint:Sprite;
		public function GameControl(){
			GameControl.instance = this;
		}
		override public function onEnable():void {
			this._time = Browser.now();
			this._gameBox = this.owner.getChildByName("gameBox") as Sprite;
			this._gridContent = this._gameBox.getChildByName("gridContent") as Sprite;
			this._startPoint = this._gridContent.getChildByName("startPoint") as Sprite;
			startGame();
		}
		
		override public function onUpdate():void {
			var now:* = Browser.now();
			if (now - this._time > this.updateTimeInterval) {
				this._time = now;
				timeUpdate();
			}
		}
		private static var GRID_COLUMN:int = 7;
		private static var GRID_LINE:int = 8; 
		private var gridList:Vector.<Gem>;
		public function createBox():void {
			gridList = new Vector.<Gem>();
			for(var i:int = 0;i<GRID_LINE;i++){
				for(var j:int  = 0;j<GRID_COLUMN;j++){
					var box:Sprite = Pool.getItemByCreateFun("gemGrid",this.gem.create,this.gem);
					var dashGrid:Gem = box.getComponent(Gem);
					var gridType:int = Math.floor(Math.random()*GemType.COUNT);
					var idx:int = i *GRID_LINE + j;
					var gemData:GemData = new GemData(idx);
					gemData.gridPositionX = j;
					gemData.gridPositionY = i;
					gemData.gemType = GemType.arr[gridType];
					dashGrid.setData(gemData);
					dashGrid.SetPos(GetPosByXY(j,i));
					dashGrid.clickCallBack = Handler.create(this,this.gridClickCallBack,null,false);
					this._gridContent.addChild(box);
					gridList[idx] = dashGrid;
				}
			}
		}

		private function gridClickCallBack(dashGrid:Gem):void{
			//trace(dashGrid);
			//遍历上下左右，找出相同颜色
			var sameTypeIdArr:Array = new Array();
			findSameType(dashGrid,dashGrid.GetGemType(), sameTypeIdArr);
							
			var destroyArr:Array = new Array();
			if(sameTypeIdArr.length>=3){
				excuteCombot();
				var rangeArr:Object = new Object();
				for(var i:int = 0;i<sameTypeIdArr.length;i++){
					if(sameTypeIdArr[i]){
						var gem:Gem = sameTypeIdArr[i] as Gem; 
						gem.SetVisible(false);

						
						var tl:Animation = new Animation();
						//加载动画文件
						tl.loadAnimation("scene/gem_explosion_firemode.ani");
						tl.pos(gem.GetPos().x +Gem.WIDTH/2,gem.GetPos().y+ Gem.HEIGHT/2);
						//添加到舞台
						_gridContent.addChild(tl);
						//播放Animation动画
						tl.play(0,false);


						trace(gem);
						destroyArr.push(gem);
						var dx:int = gem.dx;
						var dy:int = gem.dy;
						if(!rangeArr[dx]){
							rangeArr[dx] = new Object();
							rangeArr[dx]["min"] = dy;
							rangeArr[dx]["max"] = dy;
						}
						if(dy<rangeArr[dx]["min"])
							rangeArr[dx]["min"] = dy;
						if(dy>rangeArr[dx]["max"])
							rangeArr[dx]["max"] = dy;
					}
				}
										trace(destroyArr.length);
				var k:int=0;
				//消失的由上面的向下补
				for(var i:int = 0;i<GRID_COLUMN;i++){
					if(rangeArr[i]){
						var min:int = rangeArr[i]["min"];
						var max:int = rangeArr[i]["max"];
						var reduceValue:int = max - min+1;
						var cnt:int = 0;
						for(var j:int = max+1;j<GRID_LINE;j++){
							var idx:int = GetIdxByXAndY(i,j);
							var curModifyGem:Gem = gridList[idx];
							if(curModifyGem){
								cnt++;
								var newIdx:int = GetIdxByXAndY(i,curModifyGem.dy - reduceValue);
								//(idx+"=>"+newIdx+","+curModifyGem.dy +"=>" +(curModifyGem.dy - reduceValue));								
								curModifyGem.dy = curModifyGem.dy - reduceValue;
								//curModifyGem.SetPos(GetPosByXY(i,curModifyGem.dy));
								curModifyGem.DropToPos(GetPosByXY(i,curModifyGem.dy),k++);
								gridList[newIdx] = curModifyGem;
							}
						}
						for(var j:int = min+cnt;j<GRID_LINE;j++){
							//trace(i+","+j);
							gridList[GetIdxByXAndY(i,j)] = null;
							var gem:Gem = destroyArr.pop();
							if(!gem){						
								trace(gem);
							}
							var newIdx:int = GetIdxByXAndY(i,j);
							gem.dx = i;
							gem.dy = j;	
							var targetPos:Vector2 = GetPosByXY(gem.dx,gem.dy);
							gem.SetPos(new Vector2(targetPos.x,-300));
							gem.DropToPos(targetPos,j-min);
							gridList[GetIdxByXAndY(i,j)] = gem;
							var gemData:GemData = gem.GetData();
							gemData.gemType = GemType.arr[Math.floor(Math.random()*GemType.COUNT)];
							gemData.gridPositionX = i;
							gemData.gridPositionY = j;
							gem.setData(gemData);
							gem.SetVisible(true);
						}
					}
				}
				createSpecialEffect();
			}
		}
		private function findSameType(dashGrid:Gem,gemType:String,arr:Array):void{
			if(!dashGrid){
				return ;
			}
			if(arr.indexOf(dashGrid) != -1)
				return;
			if(dashGrid.GetGemType() != gemType){
				return ;
			}
			arr.push(dashGrid);
			var dx:int = dashGrid.dx;
			var dy:int = dashGrid.dy;
			var temp:Gem;
			temp = GetGemByIdx(GetIdxByXAndY(dx+1,dy));
			if(temp) findSameType(temp,gemType,arr);
			temp = GetGemByIdx(GetIdxByXAndY(dx-1,dy));
			if(temp) findSameType(temp,gemType,arr);
			temp = GetGemByIdx(GetIdxByXAndY(dx,dy+1));
			if(temp) findSameType(temp,gemType,arr);
			temp = GetGemByIdx(GetIdxByXAndY(dx,dy-1));
			if(temp) findSameType(temp,gemType,arr);									
		}
		private function GetIdxByXAndY(dx:int,dy:int):int{
			return dy *GRID_LINE + dx;
		}
		public function GetGemByIdx(idx:int):Gem{
			if(idx<0)
				return null;
			if(idx>= gridList.length)
				return null;
			return gridList[idx];
		}
		private function GetPosByXY(dx:int,dy:int):Vector2{
			return new Vector2(dx*Gem.WIDTH + _startPoint.x, -(dy +1)*Gem.HEIGHT +_startPoint.y )
		}

		private var combotStep:int = 0;
		private static const COMBOT_MAX:int = 11;
		internal var _maxTriggerDelay:int=3000;
		internal var _lastTriggerTime:int = 0;
		private function excuteCombot():void{
			var now:Number = Browser.now();
			var missCombot:Boolean = false;
			if((now -_lastTriggerTime)>_maxTriggerDelay){
				missCombot = true;
			}
			_lastTriggerTime = now;
			if(missCombot){
				combotStep = 0;
			}
			if(combotStep<=11){
				SoundManager.playSound("sound/sound_firemode_build_up_"+combotStep+".wav");
			}else
			{
				SoundManager.playSound("sound/sound_firemode_gem_removed.wav");
			}
			combotStep++;
		}

		private var startTime:int = 0;
		private static const WAVE_TIME:int = 60;
		private var playCoolDownAudio:Boolean = false;
		private function timeUpdate():void{
			if(!_started)
				return;
			var durTime:int = Browser.now() - startTime;
			durTime = 60 -durTime/1000;
			if(durTime<0){
				durTime = 0;
				stopGame();
			}
			if(!playCoolDownAudio){
				if(durTime<10){
					playCoolDownAudio = true;
					SoundManager.playSound("sound/sound_countdown.wav");
				}
			}
			MainViewUI.instance.text_time.text =  Math.floor(durTime).toString();
		}

		private var seTypeDic:Array;
		private function createSpecialEffect():void
		{
			if(seTypeDic == null){
				 seTypeDic= new Array();
				 seTypeDic[0] = Bomb;
			}
			//if(Math.random()<0.5)//0~1
			{
				var effect:BaseSpecialEffect = new seTypeDic[0]();
				var randomIdx:int = Math.floor(Math.random() *gridList.length);
				var se:Sprite = specialEffect.create();
				effect.Init(se,randomIdx,gridList[randomIdx]);
			}
		}

		
		override public function onStageClick(e:Event):void {
		//trace(e.target);
			//停止事件冒泡，提高性能，当然也可以不要
			//e.stopPropagation();
			//舞台被点击后，使用对象池创建子弹
			//var flyer:Sprite = Pool.getItemByCreateFun("bullet", this.bullet.create, this.bullet);
			//flyer.pos(Laya.stage.mouseX, Laya.stage.mouseY);
			//this._gameBox.addChild(flyer);
			//trace(e.currentTarget);
		}
		
		/**开始游戏，通过激活本脚本方式开始游戏*/
		public function startGame():void {
			if (!this._started) {
				this._started = true;
				this.enabled = true;
				startTime = Browser.now();;
				this.createBox();
			}
		}
		
		/**结束游戏，通过非激活本脚本停止游戏 */
		public function stopGame():void {
			this._started = false;
			this.enabled = false;
			this.updateTimeInterval = 1000;
		}
	}
}
package script.grid {
	import laya.components.Script;
	import laya.display.Animation;
	import laya.display.Sprite;
	import laya.display.Text;
	import laya.events.Event;
	import laya.media.SoundManager;
	import laya.physics.RigidBody;
	import laya.utils.Pool;
	import laya.ui.Image;
	import laya.d3.terrain.Terrain;
	import laya.utils.Handler;
	import script.grid.henum.*;
	import script.grid.henum.GemType;
	import laya.d3.math.Vector2;
	import laya.utils.Tween;
	import laya.utils.Ease;

	public class Gem extends Script {
		private var imgArr:Array;
		public var dx:int;
		public var dy:int;
		public var idx:int;
		public var clickCallBack:Handler = null;
		internal var _type:String;
		internal var _currentStyle:GemStyle;
		internal var _data:GemData;
		public static const WIDTH:int=90;
        public static const HEIGHT:int=90;

		private var red:Image;
		private var green:Image;
		private var blue:Image;
		private var yellow:Image;
		private var purple:Image;

		private var isCreated:Boolean = false;

		public function SetXY(_x:int,_y:int):void{
			dx = _x;
			dy = _y;
		}
		public function SetPos(value:Vector2):void{
			(owner as Sprite).pos(value.x,value.y);
		}
		public function GetPos():Vector2{
			return new Vector2((owner as Sprite).x,(owner as Sprite).y);
		}
		public function DropToPos(value:Vector2,i:int):void{
			Tween.to(owner,{"y":value.y},300,Ease.quadIn,null,i*50)
		}
		public function SetIdx(_idx:int):void{
			idx = _idx;
		}
		public function GetGemType():String{
			return _type;
		}

		override public function onEnable():void {
			red = this.owner.getChildByName("red") as Image;
			green = this.owner.getChildByName("green") as Image;
			blue = this.owner.getChildByName("blue") as Image;
			yellow = this.owner.getChildByName("yellow") as Image;
			purple = this.owner.getChildByName("purple") as Image;
			red.mouseEnabled = true;
			green.mouseEnabled = true;
			blue.mouseEnabled = true;
			yellow.mouseEnabled = true;
			purple.mouseEnabled = true;
			isCreated = true;
			setData(_data);
			(this.owner as Sprite).mouseEnabled = true;
			this.owner.on(Event.CLICK, this,this.OnClick);
			
		}
		public function setData(gemData:GemData):void
		{
			this._data=gemData;
			if(!isCreated)
				return;
			dx = _data.gridPositionX;
			dy = _data.gridPositionY;
			var gs:GemStyle = new GemStyle();
			gs.setGemType(_data.gemType);
			applyStyle(gs);
		}
				
		public function GetData():GemData
		{
			return _data;
		}

		private function OnClick():void{
			//trace(clickCallBack);
			if(clickCallBack)
				clickCallBack.runWith(this);
		}
		public function SetVisible(b:Boolean):void{
			(this.owner as Sprite).visible = b;
		}


		internal var _empoweredType:String;
		internal var _boostIconAdded:Boolean;
		private function setType(value:String):void
		{
			_type = value;
		}

		public function applyStyle(value:GemStyle):void{
			_currentStyle = value;
			this.applyEmpoweredType();
            this.applyGemType();
            this.applyGemVisibility();
            this.applyGreyTime();
            this.applyGemGlow();
            this.applyGemIcon();
		}

        internal function applyGreyTime():void
        {
            if (this._currentStyle.hasGreyTime) 
            {
                this.greyOutForDuration(this._currentStyle.greyTime);
            }
            return;
        }
		internal function applyEmpoweredType():void
        {
            if (this._currentStyle.empoweredType) 
            {
                this._empoweredType = this._currentStyle.empoweredType;
            }
            return;
        }

        internal function applyGemType():void
        {
            if (this._currentStyle.gemType) 
            {
                this.setType(this._currentStyle.gemType);
                this.updateBoostIconColor();
            }
            return;
        }

        internal function applyGemVisibility():void
        {
            if (this._currentStyle.gemVisibility) 
            {
                SetVisible(this._currentStyle.gemVisibility == GemVisibility.ON);
            }
            return;
        }

        internal function applyGemGlow():void
        {
            if (this._currentStyle.gemDecoration) 
            {
			}
		}
		internal function applyGemIcon():void
        {
            if (this._currentStyle.gemIcon) 
            {
			}
		}

		internal function updateBoostIconColor():void
        {
            if (this._boostIconAdded) 
            {
                //this._boostGemAnimationIcon.applyType(this._type);
            }
            this.red.visible = this._type == GemType.RED;
            this.green.visible = this._type == GemType.GREEN;
            this.blue.visible = this._type == GemType.BLUE;
            this.yellow.visible = this._type == GemType.YELLOW;
            this.purple.visible = this._type == GemType.PURPLE;
        }
        internal function greyOutForDuration(arg1:Number):void
        {
		}
	}
}
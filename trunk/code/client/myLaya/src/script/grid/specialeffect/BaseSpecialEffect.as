package script.grid.specialeffect
{
    import script.grid.Gem;
    import laya.ui.Image;
    import laya.resource.Bitmap;
    import laya.display.Sprite;
    import script.GameControl;
    import laya.d3.math.Vector2;
    public class BaseSpecialEffect{
        protected var gem:Gem;
        protected var imgurl:String;
        protected var gameObject:Sprite;
        public function Init(sprite:Sprite,idx:int,gem:Gem):void{
            this.gem = gem;
            this.gameObject = sprite;
            OnInit();
        }
        protected function OnInit():void
        {
            //GameControl.instance.GetGemByIdx();
            var pos:Vector2 = gem.GetPos();
            trace(pos);
            gem.owner.parent.addChild(this.gameObject);;
            this.gameObject.pos(pos.x,pos.y);
        }
    }
}
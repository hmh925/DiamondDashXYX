package script.grid
{
    import script.grid.henum.*;
     public class GemData
    {
        public function GemData(arg1:uint)
        {
            super();
            this._index = arg1;
            return;
        }

        public function get index():uint
        {
            return this._index;
        }

        public function get isDiamond():Boolean
        {
            return this.category == GemCategory.DIAMOND;
        }

        public function toString():String
        {
            return "GemData( x: " + this.gridPositionX + ",y: " + this.gridPositionY + ",type: " + this.gemType.toString() + ")";
        }

        internal var _index:uint;

        public var gridPositionX:uint=0;

        public var gridPositionY:uint=0;

        public var gemType:String;

        public var outOfGrid:Boolean=true;

        public var groupFinderFlag:Boolean;

        //public var groupData:GroupData;

        //public var boost:BoostName;

        public var generation:uint;

        public var isInColoredGroup:Boolean=false;

        public var category:String;
    }   
}
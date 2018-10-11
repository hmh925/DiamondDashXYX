package script.grid
{
    import script.grid.henum.*;
    public class GemStyle
    {
        public function GemStyle()
        {
            super();
            return;
        }

        public function setGemType(arg1:String):GemStyle
        {
            this._gemType = arg1;
            return this;
        }

        public function get gemType():String//GemType
        {
            return this._gemType;
        }

        public function setGemDecoration(arg1:String):GemStyle
        {
            this._gemDecoration = arg1;
            return this;
        }

        public function get gemDecoration():String
        {
            return this._gemDecoration;
        }

        public function setGemIcon(arg1:GemIcon):GemStyle
        {
            this._gemIcon = arg1;
            return this;
        }

        public function get gemIcon():GemIcon
        {
            return this._gemIcon;
        }

        public function setGemVisible(arg1:Boolean):GemStyle
        {
            this._gemVisibility = arg1 ? GemVisibility.ON : GemVisibility.OFF;
            return this;
        }

        public function get gemVisibility():String
        {
            return this._gemVisibility;
        }

        public function setGreyTime(arg1:uint):GemStyle
        {
            this._greyTime = arg1;
            this._hasGreyTime = true;
            return this;
        }

        public function get greyTime():Number
        {
            return this._greyTime;
        }

        public function get hasGreyTime():Boolean
        {
            return this._hasGreyTime;
        }

        public function setEmpowered(arg1:String):GemStyle
        {
            this._empoweredType = arg1;
            return this;
        }

        public function get empoweredType():String//EmpoweredType
        {
            return this._empoweredType;
        }

        public function setChangeImmediate(arg1:Boolean):GemStyle
        {
            this._canChangeImmediate = arg1;
            return this;
        }

        public function get canChangeImmediate():Boolean
        {
            return this._canChangeImmediate;
        }

        internal var _gemType:String//GemType;

        internal var _gemDecoration:String;//GemDecoration

        internal var _gemVisibility:String;//GemVisibility

        internal var _gemIcon:GemIcon;

        internal var _greyTime:uint;

        internal var _hasGreyTime:Boolean=false;

        internal var _empoweredType:String//EmpoweredType;

        internal var _canChangeImmediate:Boolean=false;
    }
}
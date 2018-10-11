package laya.net {
	import laya.renders.Render;
	
	/**
	 * <p><code>URL</code> 提供URL格式化，URL版本管理的类。</p>
	 * <p>引擎加载资源的时候，会自动调用formatURL函数格式化URL路径</p>
	 * <p>通过basePath属性可以设置网络基础路径</p>
	 * <p>通过设置customFormat函数，可以自定义URL格式化的方式</p>
	 * <p>除了默认的通过增加后缀的格式化外，通过VersionManager类，可以开启IDE提供的，基于目录的管理方式来替代 "?v=" 的管理方式</p>
	 * @see laya.net.VersionManager
	 */
	public class URL {
		/**URL地址版本映射表，比如{"aaa/bb.png":99,"aaa/bb.png":12}，默认情况下，通过formatURL格式化后，会自动生成为"aaa/bb.png?v=99"的一个地址*/
		public static var version:Object = {};
		/**@private */
		private var _url:String;
		/**@private */
		private var _path:String;
		
		/**创建一个新的 <code>URL</code> 实例。*/
		public function URL(url:String) {
			_url = formatURL(url);
			_path = getPath(url);
		}
		
		/**格式化后的地址。*/
		public function get url():String {
			return _url;
		}
		
		/**地址的文件夹路径（不包括文件名）。*/
		public function get path():String {
			return _path;
		}
		
		/**基础路径。如果不设置，默认为当前网页的路径。最终地址将被格式化为 basePath+相对URL地址，*/
		public static var basePath:String = "";
		/**root路径。只针对'~'类型的url路径有效*/
		public static var rootPath:String = "";
		
		/** 自定义URL格式化的方式。例如： customFormat = function(url:String):String{} */
		public static var customFormat:Function = function(url:String):String {
			var newUrl:String = version[url];
			if (!Render.isConchApp && newUrl) url += "?v=" + newUrl;
			return url;
		}
		
		/**
		 * 格式化指定的地址并返回。
		 * @param	url 地址。
		 * @param	base 基础路径，如果没有，则使用basePath。
		 * @return	格式化处理后的地址。
		 */
		public static function formatURL(url:String):String {
			if (!url) return "null path";
			
			//如果是全路径，直接返回，提高性能
			if (url.indexOf(":") > 0) return url;
			//自定义路径格式化
			if (customFormat != null) url = customFormat(url);			
			//如果是全路径，直接返回，提高性能
			if (url.indexOf(":") > 0) return url;
			
			var char1:String = url.charAt(0);
			if (char1 === ".") {
				return _formatRelativePath (basePath + url);
			} else if (char1 === '~') {
				return rootPath + url.substring(1);
			} else if (char1 === "d") {
				if (url.indexOf("data:image") === 0) return url;
			} else if (char1 === "/") {
				return url;
			}
			return basePath + url;
		}
		
		/**
		 * @private
		 * 格式化相对路径。
		 */
		public static function _formatRelativePath(value:String):String {
			var parts:Array = value.split("/");
			for (var i:int = 0, len:int = parts.length; i < len; i++) {
				if (parts[i] == '..') {
					parts.splice(i - 1, 2);
					i -= 2;
				}
			}
			return parts.join('/');
		}
		
		/**
		 * 获取指定 URL 的文件夹路径（不包括文件名）。
		 * <p><b>注意：</b>末尾有斜杠（/）。</p>
		 * @param	url url地址。
		 * @return  返回文件夹路径。
		 */
		public static function getPath(url:String):String {
			var ofs:int = url.lastIndexOf('/');
			return ofs > 0 ? url.substr(0, ofs + 1) : "";
		}
		
		/**
		 * 获取指定 URL 的文件名。
		 * @param	url 地址。
		 * @return 	返回文件名。
		 */
		public static function getFileName(url:String):String {
			var ofs:int = url.lastIndexOf('/');
			return ofs > 0 ? url.substr(ofs + 1) : url;
		}
	}
}
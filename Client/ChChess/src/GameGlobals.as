package  
{
	import flash.display.Loader;
	import flash.net.URLLoader;
	import flash.utils.Dictionary;
	
	import mx.core.Application;
	import mx.core.FlexGlobals;
	import mx.utils.URLUtil;
	
	import net.wdmir.core.QiPaiAudio;
	import net.wdmir.core.QiPaiClient;
	import net.wdmir.core.QiPaiHabit;
	import net.wdmir.core.QiPaiName;
	import net.wdmir.core.QiPaiState;
	import net.silverfoxserver.extfactory.RoomModelFactory;
	import net.silverfoxserver.extfactory.RuleModelFactory;
	
	
	public class GameGlobals
	{		
		/**
		 * 测试全自动机器人模式
		 */ 
		public static const TEST_ROBOT_MODE:Boolean = false;//false;//
		
		 /**
		 * 发布Release版本时修改这里
		 * 
		 */
		public static const DEBUG:Boolean = false;//true; 		
		
		/**
		 * 发布日期
		 */ 
		public static const PUBLISH_DATE:String = "2015.9.8";//"2015.6.7";//"2015.6.3";//"2015.4.29",//"2014.4.8",//"2013.8.24",
		
		/**
		 * 指定游戏名称和类型
		 */ 
		public static const GAMENAME:String = QiPaiName.ChChess;
		
		/**
		 * 主swf名称
		 */
		public static const SWFNAME:String = "ChChess.swf";
		
		/**
		 * 游戏当前场景
		 * 场景名称要和 .mxml的场景名称对应
		 */ 
		 //[Bindable]
		 public static function get currentState():String
		 {
			 
		 	//return Application.application.currentState;
			 return FlexGlobals.topLevelApplication.currentState;
		 }
		 
		 public static function set currentState(value:String):void
		 {
			 //Application.application.currentState = value;
			 FlexGlobals.topLevelApplication.currentState = value;
		 }
		 
		 /**
		 * 所有场景统一宽高
		 */
		 [Bindable]
		 public static var stageWidth:Number = 900; 
		 
		 [Bindable]
		 public static var stageHeight:Number= 600; 
		 				
					
		/**
		* 客户端连接Socket服务器 
		* qpc = qiPaiClient
		*/ 
		private static var _qpc:QiPaiClient = null;//new QiPaiClient(GameGlobals.DEBUG,GameGlobals.GAMENAME);
			
		public static function get qpc():QiPaiClient
		{
			if(_qpc == null)
			{
				_qpc = new QiPaiClient(GameGlobals.DEBUG,GameGlobals.GAMENAME);
				
				_qpc.data.rule = RuleModelFactory.Create(GameGlobals.GAMENAME);
				_qpc.data.activeRoom = RoomModelFactory.Create(-1,_qpc.data.rule);
				
			}
		
			return _qpc;
		}
		
		
		 /**
		 * 声音管理 
		 */
		 [Bindable]
		 public static var audio:QiPaiAudio = new QiPaiAudio();
		 
		 
		 /**
		 * 习惯设置
		 */ 
		 public static var habit:QiPaiHabit = new QiPaiHabit();
		 		 
		 /**
		 * url
		 */ 
		 public static var url:String
		 public static var rootUrl:String;
		 
		 /**
		 * 返回不包含http://的域名
		 */ 
		 public static function get domain():String
		 {
		 	return URLUtil.getServerName(url);
		 }
		 
		 /**
		 * 
		 */ 
		 public static function get loaderURL():String
		 {
		 
		 	return FlexGlobals.topLevelApplication.loaderInfo.loaderURL;
		 }
		
		 /**
		  * html页面的加载参数		
		  *  
		  * 一般为flash vars
		  * 
		  * 目前接受参数 id_sql,session
		  * 
		  */
		 public static var pageVars:Dictionary = new Dictionary(true);	
		 
		 public static var decodeURIErr:Boolean = false;
		 public static function getFlashVars():void
		 {
			 
			 decodeURIErr = false;
			 
			 //save
			 var _loaderURL:String = FlexGlobals.topLevelApplication.loaderInfo.loaderURL;//.loaderInfo.loaderURL;
			 
			 //test
			 //_loaderURL = "http://127.0.0.1/template/default/ddz/client_ddz.swf?bbs=@Discuz&amp;mode=@autoLogin_autoReg&amp;account=@iui2005&amp;pwd=@iui2005@qq.com&amp;email=@iui2005@qq.com&amp;gender=@0";
			 
			 if(_loaderURL.indexOf("?") > -1)
			 {
				 var _loaderURL_Param:String = _loaderURL.split("?")[1]; 
				 
				 var _loaderURL_Pattern:RegExp = /&amp;/gi;  
				 
				 _loaderURL_Param = _loaderURL_Param.replace(_loaderURL_Pattern,"&");
				 
				 var _pairs:Array = _loaderURL_Param.split("&");
				 
				 //var _pairs:Array = this.loaderInfo.loaderURL.split("?")[1].split("&");
				 
				 for (var i:int = 0; i <_pairs.length; i++)
				 {
					 //如用户名=开头，则无法判断，现改为双字符当分隔符
					 var pairName:String = _pairs[i].split("=@")[0];
					 var pairValue:String = _pairs[i].split("=@")[1];
					 
					 //提示过滤字符 是因为浏览器传递的参数转成url编码了
					 //目前只能decode1个中文对应三字节的，对应二字节的decodeURI会报错
					 if(pairValue.indexOf("%") >= 0)
					 {
						 try
						 {
							 pairValue = decodeURI(pairValue);
						 }
						 catch (exd:Error) 
						 {            
							 
							 decodeURIErr = true;
							 
							 /* Alert.show(
							 QiPaiStr.getErrorMessage("decodeURI",
							 "参数名称:" + pairName +
							 " 参数值:" + pairValue,
							 exd.message)
							 ); */
						 }	
						 
					 }
					 
					 
					 GameGlobals.pageVars[pairName] = pairValue;
				 }
				 
			 }
			 
		 }
		
	}
}
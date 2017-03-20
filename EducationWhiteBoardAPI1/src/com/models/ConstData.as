package com.models
{
	import com.models.msgs.PPTMSG;
	import com.models.vo.UserVO;
	import com.plter.air.windows.utils.NativeCommand;
	import com.plter.air.windows.utils.ShowCmdWindow;
	import com.res.WangLuoTiShiRes;
	import com.views.components.DisplaySprite;
	import com.views.components.PPTYuLan;
	import com.views.components.SaveLocalImage;
	import com.views.components.SettingEnvironment;
	import com.views.components.SocketComponents;
	
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.display.BitmapData;
	import flash.display.JPEGEncoderOptions;
	import flash.display.Stage;
	import flash.events.NativeProcessExitEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.dns.AAAARecord;
	import flash.utils.ByteArray;

	/**
	 * @author XiangZi
	 * @E-mail: [email=995435501@qq.com][/email]
	 * 创建时间：2015-10-12 下午3:32:13
	 * 
	 */
	public class ConstData
	{
		public static var isVoting:Boolean = false;
		public static var serverAddress:String = ApplicationData.getInstance().socketServer;
		public static var votes:Vector.<UserVO> = new Vector.<UserVO>;
		public static var voteUsers:Vector.<String> = new Vector.<String>;
		public static var socket:SocketComponents;
		public static var setEnv:SettingEnvironment;
		public static var ips:Vector.<String> = new Vector.<String>;
		public static var pptYuLan:PPTYuLan;
		public static var historyDate:String;
		public static var teacherVO:UserVO = null;
//		public static var answers:Vector.<String> = new Vector.<String>["A","B","C","D","E","F","G"];
		public static var answers:Array=["A","B","C","D","E","F","G"];
		public static var voteResults:Vector.<Object> = new Vector.<Object>;
		public static var colorList:Array=[0xFF0F00,0xFCD202,0xB0DE09,0x0D8ECF,0xFFF000,0xF000FF,0xFCD000];
		public static var spCon:DisplaySprite;
		public static var voteTitleType:String;
		public static var bgs:Array=[];
		public static var bgThumbs:Array=[];
		public static var stage:Stage;
		public static var himiID:int;
		public static var stageWidth:int;
		public static var stageScaleX:Number;
		public static var stageHeight:int;
		public static var stageScaleY:Number;
		public static var isFmsNet:Boolean = false;
		public static var isNetworkSuccess:Boolean = false;
		public static var isMemoryFull:Boolean;
		public static var isHuanDengFull:Boolean;
		public static var isPPTCtr:Boolean;
		public static var wangLuoTiShi:WangLuoTiShiRes;
		public static var dateFile:String;
		public static var colorArr:Array=[0xFFFFFF,0xFF0000];
		public static var thincessArr:Array=[5,10];
		public static var users:Vector.<String> = new Vector.<String>;
		private static var isExist:Boolean;
		public static var stageWidth1:Number;
		public static var stageHeight1:Number;
		
		
		public function ConstData()
		{
			
		}
		
		public static function killJingCheng(name:String):void
		{
			var args:Vector.<String>=new Vector.<String>;
			var str:String = "taskkill /im "+ name+".exe" +" /f";
			args.push(str);
			try
			{
				var _cmdNa:NativeCommand = new com.plter.air.windows.utils.NativeCommand();
				_cmdNa.runCmd(args,ShowCmdWindow.HIDE);
			} 
			catch(error:Error) 
			{
				
			}
		}
		
		public static function saveLocalFile(bmpd:BitmapData, imgagPath:String):void
		{
			var ba:ByteArray = new ByteArray(); 
			var jpegEncoder:JPEGEncoderOptions = new JPEGEncoderOptions(100); 
			bmpd.encode(bmpd.rect,jpegEncoder,ba);
			bmpd.dispose();
			bmpd=null;
			var file:File = new File(imgagPath);
			var fs:FileStream = new FileStream();
			fs.open(file,FileMode.WRITE);
			fs.writeBytes(ba);
			fs.close();
		}
		
		/**
		 * @name 需要获取的进程的名称 
		 * */
		public static function getProcessExist(name:String,callback:Function):void
		{
			isExist = false;
			var nativeProcessStartupInfo:NativeProcessStartupInfo = new NativeProcessStartupInfo(); 
			var file:File = File.applicationDirectory.resolvePath(ApplicationData.getInstance().appPath + "assets/GetProcess.exe"); 
			nativeProcessStartupInfo.executable = file; 
			var processArgs:Vector.<String> = new Vector.<String>(); 
			processArgs.push(name); 
			nativeProcessStartupInfo.arguments = processArgs; 
			var process:NativeProcess = new NativeProcess(); 
			//			process.addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, onOutputData); 
			process.addEventListener(NativeProcessExitEvent.EXIT,onProcessExit);
			process.start(nativeProcessStartupInfo); 
			
			function onProcessExit(event:NativeProcessExitEvent):void
			{
				if(event.exitCode > 0)
				{
					isExist = true;
				} else {
					isExist = false;
				}
				if(callback!=null) callback(isExist);
			}
		}
	}
}
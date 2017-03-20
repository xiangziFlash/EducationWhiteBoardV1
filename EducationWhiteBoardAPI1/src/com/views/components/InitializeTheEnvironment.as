package com.views.components
{
	import com.controls.ToolKit;
	import com.models.ApplicationData;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.InterfaceAddress;
	import flash.net.NetworkInfo;
	import flash.net.NetworkInterface;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.setTimeout;
	
	/**
	 * @author XiangZi
	 * @E-mail: [email=995435501@qq.com][/email]
	 * 创建时间：2016-1-9 下午3:00:15
	 * 
	 */
	public class InitializeTheEnvironment extends Sprite
	{
		private var _ipAddress:String = "";
		private var _ldr:URLLoader;
		private var _ldr1:URLLoader;
		private var _appPath:String;
		public function InitializeTheEnvironment()
		{
			var file1:File=File.applicationDirectory;   
			var appPath:String = file1.nativePath+"/";
			var pattern:RegExp = /\\/g;//正则表达式，将“\”字符换成“/”字符
			_appPath = appPath.replace(pattern, "/");
			initViews();
		}
		
		private function initViews():void
		{
			_ipAddress = getIpAddress();
			var file:File = new File(_appPath+"assets/0.txt");
			xiuGaiBaiBanData();
		}
		
		private function getIpAddress():String
		{
			var networkInfo:NetworkInfo = NetworkInfo.networkInfo;   
			var interfaces:Vector.<NetworkInterface> = networkInfo.findInterfaces();   
			var ips:Vector.<String> = new Vector.<String>;
			if( interfaces != null )   
			{   
				for each ( var interfaceObj:NetworkInterface in interfaces )   
				{   
 
					for each ( var address:InterfaceAddress in interfaceObj.addresses )   
					{   
						if(address.ipVersion == "IPv4"){
							ips.push(address.address);
						}
					}   
				}               
			}   
			
			for (var j:int = 0; j < ips.length; j++) 
			{
				if(ips[j].indexOf("192.168.") == 0)
				{
					return ips[j];
				}
			}
			
			ips.push("127.0.0.1");
			return ips[0];
		}
		
		private function xiuGaiBaiBanData():void
		{
			var file1:File=File.applicationDirectory;   
			var appPath:String = file1.nativePath+"/";
			var pattern:RegExp = /\\/g;//正则表达式，将“\”字符换成“/”字符
			appPath = appPath.replace(pattern, "/");
			
			var pptPath:String = appPath + "PPT/EE4WebCam.exe.config";
			var appConfig:String = appPath + "config/config.xml";
			var serverPath:String = appPath + "assets/WhiteBoardServer/config.xml";
			var webConfig:String = appPath + "UPloadfile/web.config";
			var webServer:String = appPath + "assets/webserver/Web Sockets Test - Server.exe.config";
			readConfigFile(pptPath);
			
			setTimeout(function ():void
			{
				readAppConfigFile(appConfig);
			},1000);
			
			setTimeout(function ():void
			{
				readserverPath(serverPath);
			},2000);
			
			setTimeout(function ():void
			{
				readWebConfig(webConfig);
			},3000);
			
			setTimeout(function ():void
			{
				readWebServerConfig(webServer);
			},3000);
			var file:File = new File(_appPath+"assets/0.txt");
			if(file.exists)return;

			shiXianJieKou();
			faQiVote("-1");
		}
		
		private function faQiVote(type:String):void
		{
			//http://t.iptid.com/ws/eduVote.asmx 
			var request:URLRequest=new URLRequest("http://t.iptid.com/ws/eduVote.asmx/SetVote");
			var params:URLVariables = new URLVariables();
			params.status = type;
			request.method = URLRequestMethod.POST;
			request.data=params;
			
			_ldr = new URLLoader();
			_ldr.addEventListener(Event.COMPLETE,onUrlLdrEnd);
			_ldr.load(request);
		}
		
		private function onUrlLdrEnd(event:Event):void
		{
			var msg:String = event.target.data;
			trace("<<<<faQiVote", msg);
		}
		
		private function readAppConfigFile(path:String):void
		{
			var txtLoad:URLLoader = new URLLoader();
			//txt.txt文本以UTF-8的编码保存。
			var txtURL:URLRequest = new URLRequest(path);
			txtLoad.addEventListener(Event.COMPLETE, showContent);
			txtLoad.load(txtURL);
			function showContent(evt:Event):void{
				//trace(evt.target.data);
				//					trace(evt.target.data.appSettings);
				var xml:XML = new XML(evt.target.data);
				//					trace(xml.appSettings.add[1].@value);
				xml.httpAddress = _ipAddress+":1800";
				xml.pptAddress = _ipAddress;
				xml.socketServer = _ipAddress;
				txtLoad.close();
				saveUTFString(xml.toString(), path);
			}
		}
		
		private function readserverPath(path:String):void
		{
			var txtLoad:URLLoader = new URLLoader();
			//txt.txt文本以UTF-8的编码保存。
			var txtURL:URLRequest = new URLRequest(path);
			txtLoad.addEventListener(Event.COMPLETE, showContent);
			txtLoad.load(txtURL);
			function showContent(evt:Event):void{
				//trace(evt.target.data);
				//					trace(evt.target.data.appSettings);
				var xml:XML = new XML(evt.target.data);
				//trace(xml.appSettings.add[1].@value);
				xml.ipAddress = _ipAddress;
				xml.webAddress = _ipAddress;
				txtLoad.close();
				saveUTFString(xml.toString(), path);
			}
		}
		
		private function readWebServerConfig(path:String):void
		{
			var txtLoad:URLLoader = new URLLoader();
			//txt.txt文本以UTF-8的编码保存。
			var txtURL:URLRequest = new URLRequest(path);
			txtLoad.addEventListener(Event.COMPLETE, showContent);
			txtLoad.load(txtURL);
			function showContent(evt:Event):void{
				//trace(evt.target.data);
				//					trace(evt.target.data.appSettings);
				var xml:XML = new XML(evt.target.data);
				xml.appSettings.add[0].@value = _ipAddress;
				txtLoad.close();
				saveUTFString(xml.toString(), path);
			}
		}
		
		private function readWebConfig(path:String):void
		{
			var txtLoad:URLLoader = new URLLoader();
			//txt.txt文本以UTF-8的编码保存。
			var txtURL:URLRequest = new URLRequest(path);
			txtLoad.addEventListener(Event.COMPLETE, showContent);
			txtLoad.load(txtURL);
			function showContent(evt:Event):void{
				//trace(evt.target.data);
				//					trace(evt.target.data.appSettings);
				var xml:XML = new XML(evt.target.data);
				xml.appSettings.add[1].@value = _ipAddress;
				xml.appSettings.add[3].@value = _ipAddress;
				xml.appSettings.add[4].@value = "http://" + _ipAddress + ":1800/UPloadfile/";
				/*xml.appSettings.add[1].@value = "http://"+ _ipAddress +":10000/photos/";
				xml.appSettings.add[0].@value = ApplicationData.getInstance().appPath +"FileSytem/photos/";*/
				txtLoad.close();
				saveUTFString(xml.toString(), path);
			}
		}
		
		private function readConfigFile(path:String):void
		{
			var txtLoad:URLLoader = new URLLoader();
			//txt.txt文本以UTF-8的编码保存。
			var txtURL:URLRequest = new URLRequest(path);
			txtLoad.addEventListener(Event.COMPLETE, showContent);
			txtLoad.load(txtURL);
			function showContent(evt:Event):void{
				//trace(evt.target.data);
				//					trace(evt.target.data.appSettings);
				var xml:XML = new XML(evt.target.data);
				//trace(xml.appSettings.add[1].@value);
				xml.appSettings.add[1].@value = _ipAddress;
				txtLoad.close();
				saveUTFString(xml.toString(), path);
			}
			setTimeout(function ():void
			{
				disEvent();
			},3000);
		}
		
		private function shiXianJieKou():void
		{
			/*接口地址：http://t.iptid.com/ws/eduShow.asmx
			方法：SetCallbackpage
			参数类型：string（例如“http://192.168.3.89/frame.aspx”）
			结果：string
			“0”：设置失败；
			“1”：设置成功*/
			
			var request:URLRequest = new URLRequest("http://t.iptid.com/ws/eduShow.asmx"+"/SetCallbackpage");
			var params:URLVariables = new URLVariables();
//			params.url = "http://" + "192.168.3.89" + ":1236/frame.aspx";
			trace("http://"+_ipAddress+":1800/Default.aspx","---");
			params.url = "http://"+_ipAddress+":1800/Default.aspx";
			request.method = URLRequestMethod.POST;
			request.data=params;
			_ldr1 = new URLLoader();
			_ldr1.load(request);
			_ldr1.addEventListener(Event.COMPLETE,onUrlLdrEnd1);
		}
		
		private function onUrlLdrEnd1(event:Event):void
		{
			_ldr1.removeEventListener(Event.COMPLETE,onUrlLdrEnd1);
			var msg:String = event.target.data;
			trace("<<<<shiXianJieKou", msg);
		}
		
		private function disEvent():void
		{
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		/**
		 * xml写入
		 * @param fileName
		 * @return 
		 */	
		private static function saveUTFString(str:String, fileName:String):void
		{//trace("数据处理完成")
			var pattern:RegExp = /\n/g;
			str = str.replace(pattern, "\r\n");
			//				trace(fileName, "fileName");
			var file:File = new File(fileName);
			var fs:FileStream = new FileStream();
			fs.openAsync(file, FileMode.WRITE);
			fs.writeUTFBytes(str);
			fs.close();
			file = null;
			fs = null;
		}
		
	}
}
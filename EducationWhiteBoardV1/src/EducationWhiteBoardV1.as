package
{
	import com.cndragon.Register;
	import com.controls.ToolKit;
	import com.models.ApplicationData;
	import com.models.ConstData;
	import com.net.hires.debug.Stats;
	import com.notification.ILogic;
	import com.notification.NotificationFactory;
	import com.notification.NotificationIDs;
	import com.plter.air.windows.utils.NativeCommand;
	import com.plter.air.windows.utils.ShowCmdWindow;
	import com.scxlib.GetDateName;
	import com.scxlib.GraffitiBoardMouse;
	import com.tweener.transitions.Tweener;
	import com.views.components.ClearHistory;
	import com.views.components.DisplaySprite;
	import com.views.components.FuWuQi;
	import com.views.components.InitializeTheEnvironment;
	import com.views.components.JiaZaiContent;
	import com.views.components.ReceiveNotification;
	import com.views.components.ZhuCePath;
	import com.views.components.menu.Menus;
	import com.views.components.menu.MeunMC;
	import com.views.container.MainContainer;
	import com.views.windows.InputPasswordWindow;
	
	import flash.desktop.NativeApplication;
	import flash.display.MovieClip;
	import flash.display.NativeWindow;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageAspectRatio;
	import flash.display.StageDisplayState;
	import flash.display.StageOrientation;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.PerspectiveProjection;
	import flash.geom.Point;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.system.Capabilities;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.ui.Multitouch;
	
	/**
	 * 版本说明：这个双脑白板和手机交互采用的是 h5网页的形式 
	 */	
//	[SWF(width=2736, height=1824, backgroundColor=0xCCCCCC, frameRate=30)]
	public class EducationWhiteBoardV1 extends Sprite
	{
		private var mainApp:NativeWindow;
		private var _mainContenter:MainContainer;
		private var _closeBtn:Sprite;
		private var _qingChuLiShi:ClearHistory;
		private var _closeWin:InputPasswordWindow;
		private var _jiaZai:JiaZaiContent;
		private var _ldr:URLLoader;
		
		public function EducationWhiteBoardV1()
		{
			ConstData.killJingCheng("EE4WebCam");
			this.addEventListener(Event.ADDED_TO_STAGE,onAddStage);
		}
		
		private function onAddStage(event:Event):void
		{
			layOut();
			initEnvironment();
			initLogic();
			//			initData();
			NotificationFactory.registerLogic(new JiaZaiContent());
			_jiaZai=NotificationFactory.getLogic(JiaZaiContent.NAME) as JiaZaiContent;
			this.addChild(_jiaZai);
		}
		
		/**
		 * 
		 * 初始化布局
		 * */
		private function layOut():void
		{
			flash.ui.Multitouch.inputMode = flash.ui.MultitouchInputMode.TOUCH_POINT;
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.displayState = StageDisplayState.FULL_SCREEN;
			stage.frameRate = 30;
			stage.setOrientation(StageOrientation.ROTATED_LEFT);
			/*Tool.log(Stage.supportsOrientationChange+"____Stage.supportsOrientationChange");
			if(Stage.supportsOrientationChange){
				stage.autoOrients = false;
				stage.setAspectRatio(StageAspectRatio.LANDSCAPE);
			}*/
			
			mainApp = NativeApplication.nativeApplication.openedWindows[0] as NativeWindow;
			mainApp.addEventListener(Event.CLOSING, closeAppF4);
			mainApp.addEventListener(Event.CLOSE, closeAppHandler);			
			mainApp.width = Capabilities.screenResolutionX;
			mainApp.height = Capabilities.screenResolutionY;
//			this.scaleX = Capabilities.screenResolutionX/1920;
//			this.scaleY = Capabilities.screenResolutionY/1080;
			ConstData.stageScaleX = this.scaleX;
			ConstData.stageScaleY = this.scaleY;
			mainApp.x = mainApp.y = 0;
			ConstData.stageWidth = Capabilities.screenResolutionX;
//			ConstData.stageWidth = 2736;
			ConstData.stageHeight = Capabilities.screenResolutionY;
//			ConstData.stageHeight = 1824;
			
			InputPasswordWindow.closePassword = "0";
			_closeWin = new InputPasswordWindow();
			_closeWin.addEventListener(InputPasswordWindow.CLOSE_APP_EVENT, closeAppHandler);
			
			_closeBtn=new Sprite();
			_closeBtn.graphics.beginFill(0x000000, 0);
			_closeBtn.graphics.drawRect(0, 0, 40, 40);
			_closeBtn.graphics.endFill();
			_closeBtn.x=_closeBtn.y=0;
			
			_qingChuLiShi = new ClearHistory();
			_qingChuLiShi.visible = false;
			mainApp.stage.addChild(_qingChuLiShi);
			stage.addChild(_closeBtn);
			
			_qingChuLiShi.addEventListener(MouseEvent.CLICK, onQingChuLiShiClick);
			ApplicationData.getInstance().closeBtn = _closeBtn;
			_closeBtn.addEventListener(MouseEvent.CLICK,onCloseBtn_CLICK);
			stage.addEventListener(Event.RESIZE, onStageResize);
			
			var p:PerspectiveProjection=new PerspectiveProjection(); 
			p.projectionCenter = new Point(ConstData.stageWidth/2,ConstData.stageHeight/2); 
			p.fieldOfView=15; 
			this.transform.perspectiveProjection=p;
			killJingCheng("Web Sockets Test - Server");
		}
		
		private function initEnvironment():void
		{
			var  initEnvir:InitializeTheEnvironment = new InitializeTheEnvironment();
			initEnvir.addEventListener(Event.COMPLETE ,oninitEnvirCom); 
		}
		
		private function closeAppF4(event:Event):void
		{
			event.preventDefault();
			killJingCheng("WhiteBoardServer");
			delFolder(ApplicationData.getInstance().httpAssets);
			killJingCheng("SaveImage");
			killJingCheng("EE4WebCam");
			_mainContenter.closeProcess();
			closeApp();
		}
		
		private function oninitEnvirCom(event:Event):void
		{
			event.target.removeEventListener(Event.COMPLETE ,oninitEnvirCom); 
			//trace("oninitEnvirCom");
			initData();
			ConstData.killJingCheng("WhiteBoardServer");
		}
		
		/**
		 * 注册逻辑
		 * */
		private function initLogic():void
		{
			NotificationFactory.registerLogic(new DisplaySprite() as ILogic);
			NotificationFactory.registerLogic(new MainContainer() as ILogic);
			NotificationFactory.registerLogic(new ReceiveNotification() as ILogic);
			var sp:DisplaySprite=NotificationFactory.getLogic(DisplaySprite.NAME) as DisplaySprite;
		}
		
		/**
		 * 加载数据
		 * */
		private function initData():void
		{
			ApplicationData.getInstance().initAppData();
			ApplicationData.getInstance().addEventListener(Event.COMPLETE,dataEnd);
		}
		
		/**
		 * 软件所需资料加载完成后
		 * */
		private function dataEnd(e:Event):void
		{
			Tweener.addTween(_jiaZai,{time:1,visible:false,alpha:0,delay:2,onComplete:end});
			function end():void
			{
				this.removeChild(_jiaZai);
			}
			
			ConstData.dateFile = GetDateName.getDateName();;
			InputPasswordWindow.closePassword = ApplicationData.getInstance().configXML.closePassword;
			
			_mainContenter=NotificationFactory.getLogic(MainContainer.NAME) as MainContainer;
			_mainContenter.ininContent();
			this.addChild(_mainContenter);
			
			//			NotificationFactory.sendNotification(NotificationIDs.SHOW_LOADING, "正在配置软件环境，请稍候...");
			
			ToolKit.sw = 350;
			ToolKit.sh = 600;
			ToolKit.toolRes.x = Capabilities.screenResolutionX-400;
			ToolKit.toolRes.y = 10;
			stage.addChild(ToolKit.toolRes);
			ToolKit.toolRes.visible = false;
			ToolKit.log("版本号为：0.0.1.6");
			var file:File=File.applicationDirectory;
			var file1:File = new File(file.nativePath+"/META-INF/AIR/debug");
			if(file1.exists)
			{
				var debug:Stats=new Stats();
				debug.scaleX=2;
				debug.scaleY=2;
				debug.x = 100;
				debug.y = 50;
				stage.addChild(debug);
				ToolKit.toolRes.visible = true;
			}
			ToolKit.log("电脑分辨率为："+ConstData.stageWidth+"*"+ConstData.stageHeight);
			ConstData.stage = stage;
			ConstData.killJingCheng("SaveImage");
		}
		
		private function onStageDoubleClick(event:MouseEvent):void
		{
			trace("stage",event.target.name);
		}
		
		private function onCloseBtn_CLICK(event:MouseEvent):void
		{
			_qingChuLiShi.visible = true;
		}
		
		private function onStageResize(e:Event):void{
			ConstData.stageWidth = Capabilities.screenResolutionX;
			ConstData.stageHeight = Capabilities.screenResolutionY;
			ToolKit.log("onStageResize>>>" + ConstData.stageWidth + "*" + ConstData.stageHeight);
			ToolKit.log("onStageResize1>>>" + stage.width + "*" + stage.height);
		}
		
		private function onQingChuLiShiClick(e:MouseEvent):void
		{
			if(e.target.name =="yesBtn"){
				_qingChuLiShi.visible = false;
				if(_closeWin.closed){
					_closeWin=new InputPasswordWindow();
					_closeWin.addEventListener(InputPasswordWindow.CLOSE_APP_EVENT, closeAppHandler);
					InputPasswordWindow.closePassword  = ApplicationData.getInstance().configXML.closePassword;
				}
				_closeWin.show();
				removeXML();
			}else if(e.target.name =="noBtn"){
				_qingChuLiShi.visible = false;
				if(_closeWin.closed){
					_closeWin=new InputPasswordWindow();
					_closeWin.addEventListener(InputPasswordWindow.CLOSE_APP_EVENT, closeAppHandler);
					InputPasswordWindow.closePassword  = ApplicationData.getInstance().configXML.closePassword;
				}
				_closeWin.show();
			}else{
				return;
			}
		}
		
		private function removeXML():void
		{
			var fileName:String = ApplicationData.getInstance().assetsPath+"photo/用户/历史记录.xml";
			var myXML:XML = <data></data>;
			myXML.appendChild(<data></data>);
//			saveUTFString("<data/>",fileName);
		}
		
		public function killJingCheng(name:String):void
		{
			try
			{
				var args:Vector.<String>=new Vector.<String>;
				var str:String = "taskkill /im "+ name+".exe" +" /f";
				//			var str:String = "taskkill /f /t /im "+ name+".exe";
				args.push(str);
				var _cmdNa:NativeCommand = new NativeCommand();
				_cmdNa.runCmd(args,ShowCmdWindow.HIDE);
			} 
			catch(error:Error) 
			{
				
			}
		}
		
		
		/**
		 * xml写入
		 * @param fileName
		 * @return 
		 **/
		private function saveUTFString(str:String, fileName:String):void
		{
			var pattern:RegExp = /\n/g;
			str = str.replace(pattern, "\r\n");
			
			var file:File = new File(fileName);
			var fs:FileStream = new FileStream();
			fs.open(file, FileMode.WRITE);
			fs.writeUTFBytes(str);
			fs.close();
			file = null;
			fs = null;
		}
		
		private function closeAppHandler(event:Event):void
		{
			delFolder("D:/视频截图/");
			closeApp();
		}
		
		private function closeApp():void
		{
			var windows:Array=NativeApplication.nativeApplication.openedWindows;
			var len:int=windows.length;
			for(var i:int=0;i<len;i++){
				windows[i].close();
			}
			delFolder(ApplicationData.getInstance().appPath + "/temporaryFile");
			//关闭进程closeNativeProcess
			if(_mainContenter)
			{
				_mainContenter.closeProcess();
				_mainContenter.closeNativeProcess();
			}
			delFolder(ApplicationData.getInstance().httpAssets + GetDateName.getDateName());
			_mainContenter.closeServer();
			if(ApplicationData.getInstance().videoWin == null)return;
			if(!ApplicationData.getInstance().videoWin.closed)
			{
				ApplicationData.getInstance().videoWin.closeApp();
				ApplicationData.getInstance().videoWin = null;
			}
		}
		
		/**删除文件夹
		 * path:文件夹路径
		 * 当软件关闭的时候让视频保存的图片删除  清理硬盘空间
		 */
		public function delFolder(str:String):void
		{
			var delDirectory:File =new File(str);
			if(delDirectory.exists == false)return;
			try
			{
				delDirectory.deleteDirectoryAsync(true);
			} 
			catch(error:Error) 
			{
			}
		}
	}
}
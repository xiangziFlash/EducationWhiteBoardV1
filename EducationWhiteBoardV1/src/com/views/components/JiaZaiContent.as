package com.views.components
{
	import com.models.ConstData;
	import com.notification.ILogic;
	import com.notification.NotificationIDs;
	import com.notification.SimpleNotification;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class JiaZaiContent extends Sprite implements ILogic
	{
		private var _res:WelcomeWin;
		private var _tf:TextFormat=new TextFormat("YaHei_font",18,0x000000,true);
		static public const NAME:String="JiaZaiContent";
		private var _textInfor:TextField;
		private var _bg:Sprite;
		public function JiaZaiContent()
		{
			_bg=new Sprite();
			_bg.graphics.beginFill(0,0.6);
			_bg.graphics.drawRect(0,0,ConstData.stageWidth, ConstData.stageHeight);
			_bg.graphics.endFill();
			this.addChild(_bg);
			
			_res=new WelcomeWin();
			_res.x = (ConstData.stageWidth - _res.width) * 0.5;
			_res.y = (ConstData.stageHeight - _res.height) * 0.5;
			addChild(_res);
//			_res.infoText.embedFonts=true;
//			_res.infoText.autoSize=TextFieldAutoSize.LEFT;
//			_res.infoText.setTextFormat(_tf);
//			_res.infoText.defaultTextFormat=_tf;
//			_res.infoText.selectable=false;
			
			_textInfor=new TextField();
			_textInfor.x = _res.x + 189;
			_textInfor.y = _res.y + 237;
			this.addChild(_textInfor);
			_textInfor.embedFonts=true;
			_textInfor.autoSize=TextFieldAutoSize.LEFT;
			_textInfor.defaultTextFormat=_tf;
			_textInfor.selectable=false;
			_textInfor.text = "正在初始化资源...";
		}
		
		public function getLogicName():String
		{
			return NAME;
		}
		
		public function onRegister():void
		{
		}
		
		public function onRemove():void
		{
		}
		
		public function listNotificationInterests():Array
		{
			return [NotificationIDs.APP_DATA_LOADING];
		}
		
		public function handleNotification(notification:SimpleNotification):void
		{
			if(notification.getId()==NotificationIDs.APP_DATA_LOADING){
				_textInfor.text=String(notification.getBody());
			}
		}
	}
}
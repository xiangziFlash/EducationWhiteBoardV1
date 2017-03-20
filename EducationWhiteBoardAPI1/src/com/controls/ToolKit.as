package com.controls
{
	import com.models.ApplicationData;
	
	import fl.controls.TextArea;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	
	import mx.core.Application;
	
	/**
	 * @author XiangZi
	 * @E-mail: [email=995435501@qq.com][/email]
	 * 创建时间：2015-3-17 上午9:59:01
	 * 
	 */
	public class ToolKit extends Sprite
	{
		public static var toolRes:ToolRes = new ToolRes();
		public static var textArea:TextArea;
		public static var sw:Number=0;
		public static var sh:Number=0;
		public static var isHide:Boolean=true;
		public static var stageTT:String;
		
		public function ToolKit()
		{
			
		}
		
		private static function onShengChengTxtClick(event:MouseEvent):void
		{
			var jb:ByteArray =new ByteArray();
			jb.writeMultiByte(textArea.text,"utf-8");
			new FileReference().save(jb,"logs.txt");
		}
		
		private static function onclearBtnClick(event:MouseEvent):void
		{
			textArea.text = "";
		}
		
		public static function log(str:String):void
		{
			textArea = toolRes.textArea;
			textArea.width = sw;
			textArea.height = sh;
			var date:Date = new Date();
//			trace("--->>>",str)
			toolRes.clearBtn.x = 0;
			toolRes.shengChengBtn.x = sw-toolRes.shengChengBtn.width;
			toolRes.hideBtn.x = (sw-toolRes.hideBtn.width)*0.5;
			
			//textArea.text += "\n"+getFormatDate()+"--->>>" + str;
//			stageTT += "\n" +getFormatDate()+"-->>"+ str;
			stageTT += "\n" + str;
//			textArea.text += "\n"+getFormatDate()+ str;
			textArea.text += "\n"+ str;
//			var tt_str:String=textArea.text.toString();
//			var tt_str:String="aa\nbb\ncc";
			saveLog(stageTT);
			if(!toolRes.shengChengBtn.hasEventListener(MouseEvent.CLICK))
			{
				toolRes.shengChengBtn.addEventListener(MouseEvent.CLICK,onShengChengTxtClick);
				toolRes.clearBtn.addEventListener(MouseEvent.CLICK,onclearBtnClick);
				toolRes.hideBtn.addEventListener(MouseEvent.CLICK,onHideBtnClick);
			}
		}
		
		/**
		 * 保存文字性文件
		 * @param	str
		 * @param	fileName
		 */
		private static function saveUTFString(str:String, fileName:String):void
		{
			var pattern2:RegExp = /\r\n/g;
			str = str.replace(pattern2, "\n");
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
		
		public static function saveLog(str:String):void
		{
//			trace("--",str)
			var pattern2:RegExp = /\r\n/g;
			str = str.replace(pattern2, "\n");
			var pattern:RegExp = /\n/g;
			str = str.replace(pattern, "\r\n");
			/*var jb:ByteArray =new ByteArray();
			jb.writeMultiByte(str,"utf-8");*/
//			new FileReference().save(jb,"tools.txt");
			var file1:File=File.applicationDirectory;   
			var appPath:String = file1.nativePath+"/";
			var pattern3:RegExp = /\\/g;//正则表达式，将“\”字符换成“/”字符
			appPath = appPath.replace(pattern3, "/");
			var file:File = new File(appPath+"loggers.txt");
			var fs:FileStream = new FileStream();
			fs.addEventListener(Event.COMPLETE,onSaveEd);
			fs.open(file,FileMode.WRITE);
			fs.writeUTFBytes(str);
			fs.close();
//			jb.clear();
		}
		
		private static function onSaveEd(event:Event):void
		{
			
		}
		
		private static function onHideBtnClick(event:MouseEvent):void
		{
			if(!isHide)
			{
				isHide = true;
				toolRes.hideBtn.label = "隐藏";
				showContent();
			}else{
				isHide = false;
				toolRes.hideBtn.label = "显示";
				hideContent();
			}
		}
		
		private  static function hideContent():void
		{
			toolRes.shengChengBtn.visible = false;
			toolRes.clearBtn.visible = false;
			textArea.visible = false;
		}
		
		private  static function showContent():void
		{
			toolRes.shengChengBtn.visible = true;
			toolRes.clearBtn.visible = true;
			textArea.visible = true;
		}
		
		public static function getFormatDate(id:int=0,type:String=""):String
		{
			var date:Date = new Date();
			var formatDate:String = date.fullYear+"年"+date.month +"月"+date.date+"日"+date.hours+"时"+date.minutes+"分"+date.seconds+"秒";
			return formatDate;
		}
	}
}
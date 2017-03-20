package com.views.components
{
	import com.controls.ToolKit;
	import com.models.ApplicationData;
	import com.models.ConstData;
	import com.models.msgs.ClientType;
	import com.models.msgs.ControlType;
	import com.models.msgs.HandleMSG;
	import com.models.msgs.IMSG;
	import com.models.msgs.MSGType;
	import com.models.msgs.MsgHeader;
	import com.models.vo.MediaVO;
	import com.notification.NotificationFactory;
	import com.notification.NotificationIDs;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.media.MediaType;
	import flash.net.Socket;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	
	import mx.core.Application;
	
	import org.osmf.media.MediaType;
	
	/**
	 * @author XiangZi
	 * @E-mail: [email=995435501@qq.com][/email]
	 * 创建时间：2015-6-17 下午3:20:31
	 * 
	 */
	public class SocketComponents extends Sprite
	{
		private var _socket:Socket;
		private var _timer:Timer;
		private var _isNetSuccess:Boolean;
		public var updata:Function;
		public var traceFun:Function;
		public static var ipAddress:String;
		public static var port:int;
		private var _isFirst:Boolean;
		private var _timerID:int;
		
		public function SocketComponents()
		{
			initContent();
			initSocket();
		}
		
		private function initContent():void
		{
			_timer = new Timer(1000);
			_timer.addEventListener(TimerEvent.TIMER,onTimer);		
			_timer.reset();
			_timer.start();
		}
		
		private function initSocket():void
		{
			ToolKit.log(_timerID+"initSocket");
			_socket = new Socket();
			_socket.addEventListener(Event.CONNECT,onCONNECT);
			_socket.addEventListener(Event.CLOSE,onSocketClose);
			_socket.addEventListener(IOErrorEvent.IO_ERROR,onError);
			_socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR,onseError);
			_socket.addEventListener(ProgressEvent.SOCKET_DATA,onSOCKET_DATA);
			
			setConnect();
		}
		
		private function onSocketClose(event:Event):void
		{
			_isNetSuccess = false;
			_timer.reset();
			_timer.start();
			ConstData.isNetworkSuccess = false;
			ConstData.wangLuoTiShi.visible = true;
			ConstData.wangLuoTiShi.tt.text = "网络连接失败，请重新配置网络...";
		}
		
		public function setConnect():void
		{
			ToolKit.log(_timerID+"setConnect");
			ToolKit.log("正在建立连接"+ApplicationData.getInstance().socketServer+ApplicationData.getInstance().port);
			_socket.connect(ApplicationData.getInstance().socketServer,ApplicationData.getInstance().port);
		}
		
		private function onCONNECT(e:Event):void 
		{
//			trace("socket 服务器网络连接成功");
			ToolKit.log("socket 服务器网络连接成功");
			_timerID = 0;
			_isNetSuccess = true;
			_timer.stop();
			/*if(!_isFirst)
			{
				var msg:String = "SwitchMSG-&open&end";
				ConstData.socketComponents.sendMsg(msg);
			}
			_isFirst = true;*/
			NotificationFactory.sendNotification(NotificationIDs.SETTINGENVIR_COMPLETE);
		}
		
		private function onError(e:IOErrorEvent):void 
		{
//			trace("网络连接失败，正在重新连接");
			ToolKit.log(_timerID+"网络连接失败，正在重新连接");
			_isNetSuccess = false;
			ConstData.isNetworkSuccess = false;
			ConstData.wangLuoTiShi.tt.text = "网络连接失败，服务器关闭";
			ConstData.wangLuoTiShi.visible = true;
			_timer.reset();
			_timer.start();
			sengShiBaiMsg();
			
		}
		
		private function onseError(e:SecurityErrorEvent):void 
		{
//			trace("网络连接失败，服务器关闭");
			ToolKit.log(_timerID+"网络连接失败，服务器关闭");
			ConstData.isNetworkSuccess = false;
			ConstData.wangLuoTiShi.tt.text = "网络连接失败，服务器关闭";
			ConstData.wangLuoTiShi.visible = true;
			ConstData.stage.addChild(ConstData.wangLuoTiShi);
			_isNetSuccess = false;
			_timer.reset();
			_timer.start();
			
			sengShiBaiMsg();
		}
		
		private function sengShiBaiMsg():void
		{
			NotificationFactory.sendNotification(NotificationIDs.SOCKET_SHIBAI);
		}
		
		private function onSOCKET_DATA(event:ProgressEvent):void 
		{
			try
			{
				//数据更新  
				var tmpSocket:Socket=event.target as Socket;	
				var msg:String=tmpSocket.readUTFBytes(tmpSocket.bytesAvailable);
			/*	if(updata)
				{
					updata(msg);
				}*/
//				Tool.log("--->>> "+msg)
				var msgType:String = msg.split("-&")[0];
//				Tool.log(msgType+"msgType");
				switch(msgType)
				{
					case "condragon%PPTMSG":
					{
						var key:String =msg.split("&controlType=")[1].split("&")[0];
						ToolKit.log("key>>"+key);
						if(ConstData.isPPTCtr && ConstData.pptYuLan)
						{
							ConstData.pptYuLan.sendMessage(key);
						}
						if(ConstData.isHuanDengFull)
						{
							NotificationFactory.sendNotification(NotificationIDs.HUANDENG_PAGEMOVE,key);
						}
						break;
					}
					case "PPTMSG":
					{
						var key1:String =msg.split("&controlType=")[1].split("&")[0];
						ConstData.pptYuLan.sendMessage(key1);
						break;
					}
						
					case "condragon%AddMediaMSG":
					case "AddMediaMSG":
					{
						var url:String=msg.split("&")[2];
						var fileName:String = msg.split("&MediaPath=")[1].split("&")[0];
						ToolKit.log(fileName+"<<<<fileName")
						var vo:MediaVO=new MediaVO();
						vo.formatString(fileName);
						vo.path=fileName;
						vo.title = fileName.split("@@@")[1];
						vo.copyPath=fileName;
						vo.isBmpd = false;
						vo.isZiDong = true;
						vo.globalP = new Point(1920*0.5, 1080*0.5);
						NotificationFactory.sendNotification(NotificationIDs.ADD_GHONEMEDIA,vo);
						break;
					}
						
					case "CLOSEPPTMSG":
					{
						NotificationFactory.sendNotification(NotificationIDs.HIDE_SMALLBOARDBUTTON);
						break;
					}
				}
			} 
			catch(error:Error) 
			{
				ToolKit.log("获取数据失败，请检查网络是否连接正常");
			}
				
			/*var msg:String=tmpSocket.readUTFBytes(tmpSocket.bytesAvailable);
			var msgObj:IMSG=HandleMSG.getObj(msg);
			if(msgObj.getMsgHeader() != MsgHeader.CONDRAGON)return;
			trace(msgObj.getMsgType(),"msgObj.getMsgType()");
			switch(msgObj.getMsgType())
			{
				case MSGType.ADD_MEDIA_MSG:
				{
//					trace("用户上传媒体素材成功 请更新" , msgObj.getMediaPath());
					var url:String=msg.split("&")[2];
					var fileName:String = msgObj.getMediaPath();
					Tool.log(fileName+"<<<<fileName");
					var vo:MediaVO=new MediaVO();
					vo.formatString(fileName);
					vo.path=fileName;
					vo.title = fileName.split("@@@")[1];
					vo.copyPath=fileName;
					vo.isBmpd = false;
					vo.isZiDong = true;
					vo.globalP = new Point(1920*0.5, 1080*0.5);
					NotificationFactory.sendNotification(NotificationIDs.ADD_GHONEMEDIA,vo);
					break;
				}
					
				case MSGType.PHONE_SUCCESS_MSG:
				{
					//trace("手机连接了");
					break;
				}
					
				case MSGType.Vote_MSG:
				{
					if(updata)
					{
						updata();
					}
					//trace("Vote_MSG--",msgObj.getControlType());
					/*if(msgObj.getControlType() == ControlType.OPEN)
					{
						ConstData.voteUsers.length = 0;
						ConstData.votes.length = 0;
//						_voteTitleType = msgObj.getQuestionsType();
					} else if(msgObj.getControlType() == ControlType.STOP)
					{
						NotificationFactory.sendNotification(NotificationIDs.SHOW_LOADING,"正在分析数据，请稍候...");
//						generateVoteData();
						
					} else if(msgObj.getControlType() == ControlType.VOTING){
						//	trace("手机投票--------");
//						voteDataFengXi(msgObj);
					}*/
			/*		break;
				}
					
				case MSGType.PPT_MSG:
				{
//					trace("PPT_MSG",msgObj.getControlType());
					ConstData.pptYuLan.controlPPT(msgObj.getControlType());
					break;
				}
					
				case MSGType.PHONE_CLOSE_MSG:
				{
					
					break;
				}
					
				case MSGType.ADD_HIMIMEDIA_MSG:
				{
					
					break;
				}
			}*/
		}
		
		private function onTimer(e:TimerEvent):void
		{
			_timerID ++;
			ToolKit.log(_timerID+"_timerID");
			/*if(_timerID > 10)
			{
				_timer.reset();
				_timer.stop();
				_timerID = 0;
				NotificationFactory.sendNotification(NotificationIDs.HIDE_LOADING);
				NotificationFactory.sendNotification(NotificationIDs.SETTING_ENVIR);
				return;
			}*/
			_timer.reset();
			_timer.stop();
			setConnect();
		}
		
		public function sendMsg(str:String):void
		{
			if(_isNetSuccess)
			{
				try
				{
					_socket.writeUTFBytes(str);
					_socket.flush();
					ToolKit.log("正在发送消息-------");
				} 
				catch(error:Error) 
				{
//					_timer.start();
				}
				
			}else{
//				trace("网络连接失败，无法发送消息，请检查网络")
//				trace("网络连接失败，无法发送消息，请检查网络");
			//	ApplicationData.getInstance().stageTT.text = "网络连接失败，无法发送消息，请检查网络";
			}
		}
		
		public function closeNetnect():void
		{
			if(_socket)
			{
				//_socket.close();
			}
		}

		public function get isNetSuccess():Boolean
		{
			return _isNetSuccess;
		}

	}
}
package com.views.components
{
	import com.models.ConstData;
	
	import flash.display.Sprite;

	/**
	 * @author XiangZi
	 * @E-mail: [email=995435501@qq.com][/email]
	 * 创建时间：2016-9-19 下午5:17:10
	 * 
	 */
	public class ClearHistory extends Sprite
	{
		private var _bg:Sprite;
		private var _qingChuLiShi:QingChuLiShiRes;
		
		public function ClearHistory()
		{
			_bg=new Sprite();
			_bg.graphics.beginFill(0,0.6);
			_bg.graphics.drawRect(0,0,ConstData.stageWidth, ConstData.stageHeight);
			_bg.graphics.endFill();
			this.addChild(_bg);
			
			_qingChuLiShi = new QingChuLiShiRes();
			_qingChuLiShi.x = (ConstData.stageWidth - _qingChuLiShi.width) * 0.5;
			_qingChuLiShi.y = (ConstData.stageHeight - _qingChuLiShi.height) * 0.5;
			this.addChild(_qingChuLiShi);
		}
	}
}
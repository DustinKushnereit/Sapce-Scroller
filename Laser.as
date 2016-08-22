package
{
	import flash.display.MovieClip;
	import flash.events.*;
	
	public class Laser extends MovieClip
	{
		public var _root:Object;
		
		public function Laser()
		{
			addEventListener(Event.ADDED, beginClass);
			addEventListener(Event.ENTER_FRAME, eFrame);
		}
		
		private function beginClass(event:Event):void
		{
			_root = MovieClip(root);
		}
		
		private function eFrame(event:Event):void
		{
			
		}
		
		public function removeListeners():void
		{
			removeEventListener(Event.ENTER_FRAME, eFrame);
		}
	}
}
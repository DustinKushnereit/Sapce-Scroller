package
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.utils.Timer;
	import flash.text.TextField;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.ui.Keyboard;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.DisplayObject;
	
	[SWF(width="800", height="400", frameRate="30", backgroundColor="0x00000")]
	
	public class Main extends MovieClip
	{
		
		public var myFormat:TextFormat = new TextFormat;
		
		public var particleContainer:MovieClip = new MovieClip();
		public var farParticleContainer:MovieClip = new MovieClip();
		
		public var laserFired:Boolean = false;
		public var movedLeft:Boolean = false;
		public var movedRight:Boolean = false;
		public var movedUp:Boolean = false;
		public var movedDown:Boolean = false;
		public var hitSpace:Boolean = false;
		public var hitEnemy:Boolean = false;
		public var makeDiamond:Boolean = false;
		public var keepGoing:Boolean = false;

		public var fireDelay:int = 250;
		public var fireDelayTimer:Timer;
		public var canFire:Boolean = true;

		public var outputText:TextField = new TextField;
		public var winText:TextField = new TextField;
		public var gameBoundary:TextField = new TextField;
		public var timeText:TextField = new TextField;
		public var livesText:TextField = new TextField;

		public var score:int = 0;
		public var enemyCount:int = 0;
		public var laserCount:int = 0;
		public var enemyTime:int = 0;
		public var enemyLimit:int = 18;
		public var reverseEnemyTime:int = 0;
		public var reverseEnemyLimit:int = 18;
		public var downEnemyTime:int = 0;
		public var downEnemyLimit:int = 18;
		public var maxSpeed:int = 2;
		public var time:int = 0;
		public var timeDisplay:int = 0;
	
		public var startScreen:TextField = new TextField;
		public var loseScreen:TextField = new TextField;

		private var _root:Object;
		
		public var ship:MovieClip = new MovieClip();
		public var gr:Graphics = ship.graphics;
		public var enemy:Enemy;
		public var reverseEnemy:ReverseEnemy;
		public var downEnemy:DownEnemy;
		public var diamond:Diamond;
		public var DG:Graphics;
		public var glow:GlowFilter;
		public var lives:int = 0;
		
		public function Main()
		{
			beginGame();
			addEventListener(MouseEvent.CLICK, youWin);
			addEventListener(Event.ENTER_FRAME, generateParticles);
			stage.addEventListener(MouseEvent.CLICK, startGame);
			addChild(timeText);
			addChild(outputText);
			addChild(livesText);
		}
		
		public function beginGame():void
		{
			_root = MovieClip(root);
			myFormat.size = 25;
			myFormat.align = TextFormatAlign.CENTER;
			
			startScreen.defaultTextFormat = myFormat;
			startScreen.textColor = 0xFF0000;
			startScreen.border = true;
			startScreen.borderColor = 0xFF0000;
			startScreen.width = 420;
			startScreen.height = 250;
			startScreen.x = stage.stageWidth / 4;
			startScreen.y = stage.stageHeight / 6;
			startScreen.text = "Collect 50 Gems To Win!\n\nUse The Arrow Keys To Move\n\nDon't Get Hit!\n\nClick Here To Start!"
			addChild(startScreen);
			stage.addChild(particleContainer);
			stage.addChild(farParticleContainer);
		}
		
		public function startGame(e:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.CLICK, startGame);
			removeChild(startScreen);
			
			gameBoundary = new TextField;
			gameBoundary.border = true;
			gameBoundary.borderColor = 0xFF0000;
			gameBoundary.width = 797;
			gameBoundary.height = 364;
			gameBoundary.x = 1;
			gameBoundary.y = 34;
			stage.addChild(gameBoundary);
			
			movedLeft = false;
			movedRight = false;
			movedUp = false;
			movedDown = false;
			hitEnemy = false;
			makeDiamond = true;
			score = 0;
			time = 0;
			enemyLimit = 35;
			reverseEnemyLimit = 35;
			downEnemyLimit = 25;
			lives = 3;
			
			stage.addEventListener(Event.ENTER_FRAME, update);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyPressed);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyReleased);
			
			var glow:GlowFilter = new GlowFilter();
			glow.color = 0xFF0000;
			glow.alpha = 3;
			glow.blurX = 18;
			glow.blurY = 18;
			glow.quality = BitmapFilterQuality.HIGH;
			
			gr.lineStyle(5, 0xFF0000);
			gr.beginFill(0, 0);
			gr.moveTo(75, 60);
			gr.lineTo(100, 75);
			gr.lineTo(75, 90);
			gr.endFill();
			ship.x = -50;
			ship.y = 150;
			ship.filters = [glow];
			
			stage.addChild(ship);
			
			keepGoing = true;
		}

		public function keyPressed( event:KeyboardEvent ):void
		{
			if ( event.keyCode == Keyboard.RIGHT )
			{
				movedRight = true;
				keepGoing = false;
			}
			else if ( event.keyCode == Keyboard.LEFT ) 
			{
				movedLeft = true;
				keepGoing = false;
			}
			else if ( event.keyCode == Keyboard.UP ) 
			{
				movedUp = true;
				keepGoing = false;
			}
			else if ( event.keyCode == Keyboard.DOWN ) 
			{
				movedDown = true;
				keepGoing = false;
			}
			else if ( event.keyCode == Keyboard.P ) 
			{
				score += 10;
			}
			else if ( event.keyCode == Keyboard.L ) 
			{
				lives += 2;
			}
			else if ( event.keyCode == Keyboard.E ) 
			{
				lives = 0;
			}
		}

		public function MoveUp():void
		{
			ship.y -= 10;
		}

		public function MoveDown():void
		{
			ship.y += 10;
		}

		public function MoveRight():void
		{
			ship.x += 10;
		}

		public function MoveLeft():void
		{
			ship.x -= 10;
		}

		public function keyReleased( event:KeyboardEvent ):void
		{
			if ( event.keyCode == Keyboard.RIGHT )
			{
				movedRight = false;
				keepGoing = true;
			}
			if ( event.keyCode == Keyboard.LEFT ) 
			{
				movedLeft = false;
				keepGoing = true;
			}
			if ( event.keyCode == Keyboard.UP ) 
			{
				movedUp = false;
				keepGoing = true;
			}
			if ( event.keyCode == Keyboard.DOWN ) 
			{
				movedDown = false;
				keepGoing = true;
			}
		}

		public function update(e:Event):void
		{
			if( movedUp )
				MoveUp();
			
			if( movedDown )
				MoveDown();
			
			if( movedLeft )
				MoveLeft();
			
			if( movedRight )
				MoveRight();
			
			shipCollision();
			
			time++;
			timeDisplay = time / 20;
			showScore();
			
			if( enemyTime < enemyLimit )
				enemyTime++;
			else
				createEnemies();
				
			if( makeDiamond )
				createDiamond();
			
			if( hitEnemy || score >= 50)
				endGame();
			
			if (score >= 1 && score < 10 )
				createReverseEnemies();
				
			if (score >= 10)
				createDownEnemies();
				
			if (score >= 20)
				createReverseEnemies();
			
			if (keepGoing)
				moveShip();
		}
		
		public function moveShip():void 
		{
			ship.x += 1;			
		}

		public function endGame():void
		{
			stage.removeEventListener(Event.ENTER_FRAME, update);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyPressed);
			stage.removeEventListener(KeyboardEvent.KEY_UP, keyReleased);
			stage.removeChild(ship);
			stage.removeChild(gameBoundary);

			if( score >= 50 )
			{
				myFormat.size = 30;
				myFormat.align = TextFormatAlign.CENTER;
				
				winText.defaultTextFormat = myFormat;
				winText.textColor = 0xFF0000;
				winText.border = true;
				winText.borderColor = 0xFF0000;
				winText.width = 380;
				winText.height = 200;
				winText.x = stage.stageWidth / 4;
				winText.y = stage.stageHeight / 4;
				winText.text = "\n\nYou Win!"
				addChild(winText);
				stage.addEventListener(MouseEvent.CLICK, youWin);
			}
			else
			{
				myFormat.size = 30;
				myFormat.align = TextFormatAlign.CENTER;
				
				loseScreen.defaultTextFormat = myFormat;
				loseScreen.textColor = 0xFF0000;
				loseScreen.border = true;
				loseScreen.borderColor = 0xFF0000;
				loseScreen.width = 380;
				loseScreen.height = 200;
				loseScreen.x = stage.stageWidth / 4;
				loseScreen.y = stage.stageHeight / 4;
				loseScreen.text = "\n\nYou Lose!\nClick To Start Again"
				addChild(loseScreen);
				stage.addEventListener(MouseEvent.CLICK, youLose);
			}
		}

		public function youLose(e:MouseEvent):void
		{
			hitEnemy = false;
			stage.removeEventListener(MouseEvent.CLICK, youLose);
			removeChild(loseScreen);
			
			addChild(startScreen);
			stage.addEventListener(MouseEvent.CLICK, startGame);
		}

		public function youWin(e:MouseEvent):void
		{
			hitEnemy = false;
			winText.border = false;
			winText.text = " "
			stage.removeEventListener(MouseEvent.CLICK, youWin);
			
			addChild(startScreen);
			stage.addEventListener(MouseEvent.CLICK, startGame);
		}

		public function showScore():void
		{	
			myFormat.size = 18;
			myFormat.align = TextFormatAlign.LEFT;
			
			outputText.defaultTextFormat = myFormat;
			outputText.textColor = 0xFF0000;
			outputText.border = true;
			outputText.borderColor = 0xFF0000;
			outputText.width = 85;
			outputText.height = 25;
			outputText.x = 710;
			outputText.y = 5;
			
			timeText.defaultTextFormat = myFormat;
			timeText.textColor = 0xFF0000;
			timeText.border = true;
			timeText.borderColor = 0xFF0000;
			timeText.width = 95;
			timeText.height = 25;
			timeText.x = 5;
			timeText.y = 5;
			
			livesText.defaultTextFormat = myFormat;
			livesText.textColor = 0xFF0000;
			livesText.border = true;
			livesText.borderColor = 0xFF0000;
			livesText.width = 95;
			livesText.height = 25;
			livesText.x = 350;
			livesText.y = 5;
			
			glow = new GlowFilter();
			glow.color = 0xFF0000;
			glow.alpha = 40;
			glow.blurX = 18;
			glow.blurY = 18;
			glow.quality = BitmapFilterQuality.HIGH;
			livesText.filters = [glow];
			
			outputText.text = "Score: " + String(score);
			timeText.text = "Time: " + String(timeDisplay);
			livesText.text = "Lives: " + String(lives);
		}

		public function shipCollision():void
		{ 
			if( ship.x <= -71)
				ship.x = -71;
			
			if( ship.x >= 694 )
				ship.x = 694;
			
			if( ship.y <= -23 )
				ship.y = -23;
			
			if( ship.y >= 306 )
				ship.y = 306;
		}

		public function handleTimer(e:TimerEvent):void
		{
			fireDelayTimer.removeEventListener(TimerEvent.TIMER, handleTimer);
			fireDelayTimer = null;
			canFire = true;
		}

		public function createEnemies():void
		{
			if( enemyTime < enemyLimit )
				enemyTime++;
			else
			{
				enemy = new Enemy();
				var dimensions:int = 14;
				enemy.graphics.beginFill(0xFFCC00,15);
				enemy.graphics.drawCircle( dimensions, dimensions, dimensions );
				enemy.graphics.endFill();
				enemy.x = 800;
				enemy.y = int(Math.floor(Math.random() * (350 - 20 + 1)) + 50);
				
				glow = new GlowFilter();
				glow.color = 0xFF6600;
				glow.alpha = 1;
				glow.blurX = 15;
				glow.blurY = 15;
				glow.quality = BitmapFilterQuality.HIGH;
				enemy.filters = [glow];
				
				addChild(enemy);
				enemyCount++;
				enemyTime = 0;
			}
		}
		
		public function createReverseEnemies():void
		{
			if( reverseEnemyTime < reverseEnemyLimit )
				reverseEnemyTime++;
			else
			{
				reverseEnemy = new ReverseEnemy();
				var dimensions:int = 14;
				reverseEnemy.graphics.beginFill(0x33FF00,1);
				reverseEnemy.graphics.drawCircle( dimensions, dimensions, dimensions );
				reverseEnemy.graphics.endFill();
				reverseEnemy.graphics.endFill();
				reverseEnemy.x = -50;
				reverseEnemy.y = int(Math.floor(Math.random() * (350 - 20 + 1)) + 50);
				
				glow = new GlowFilter();
				glow.color = 0x33FF00;
				glow.alpha = 4;
				glow.blurX = 15;
				glow.blurY = 15;
				glow.quality = BitmapFilterQuality.HIGH;
				reverseEnemy.filters = [glow];
				
				addChild(reverseEnemy);
				enemyCount++;
				reverseEnemyTime = 0;
			}
		}
		
		public function createDownEnemies():void
		{
			if( downEnemyTime < downEnemyLimit )
				downEnemyTime++;
			else
			{
				downEnemy = new DownEnemy();
				var dimensions:int = 14;
				downEnemy.graphics.beginFill(0xFF0000, 1);
				downEnemy.graphics.drawCircle( dimensions, dimensions, dimensions );
				downEnemy.graphics.endFill();
				downEnemy.x = int(Math.floor(Math.random() * (750 - 20 + 1)) + 50);
				downEnemy.y = 50;
				
				glow = new GlowFilter();
				glow.color = 0x800000;
				glow.alpha = 8;
				glow.blurX = 15;
				glow.blurY = 15;
				glow.quality = BitmapFilterQuality.HIGH;
				downEnemy.filters = [glow];
				
				addChild(downEnemy);
				enemyCount++;
				downEnemyTime = 0;
			}
		}
		
		public function createDiamond():void
		{
			if ( makeDiamond )
			{
				diamond = new Diamond();
				var dimensions:int = 6;
				DG = diamond.graphics;
				diamond.graphics.beginFill(0xCCFFFF,3);
				diamond.graphics.drawCircle( dimensions, dimensions, dimensions );
				diamond.x = int(Math.floor(Math.random() * (750 - 20 + 1)) + 50);
				diamond.y = int(Math.floor(Math.random() * (350 - 20 + 1)) + 50);
				
				glow = new GlowFilter();
				glow.color = 0xCCFFFF;
				glow.alpha = 4;
				glow.blurX = 18;
				glow.blurY = 18;
				glow.quality = BitmapFilterQuality.HIGH;
				diamond.filters = [glow];
				
				addChild(diamond);
				makeDiamond = false;
			}
		}

		public function generateParticles(event:Event):void
		{
			if( Math.random()*20 < 2)
			{
				var newParticle:Shape = new Shape(); 
				var dimensions:int = 4;
				
				newParticle.graphics.beginFill(0x99999,15);
				newParticle.graphics.drawCircle( dimensions, dimensions, dimensions );
				newParticle.x = 800; 
				newParticle.y = int(Math.random() * 400) + 40;
				
				glow = new GlowFilter();
				glow.color = 0x99999;
				glow.alpha = 1;
				glow.blurX = 15;
				glow.blurY = 15;
				glow.quality = BitmapFilterQuality.HIGH;
				newParticle.filters = [glow];
				
				particleContainer.addChild(newParticle);
			}
			
			if( Math.random()*15 < 2)
			{
				var newParticle2:Shape = new Shape(); 
				var dimensions2:int = 2;
				
				newParticle2.graphics.beginFill(0x99999,15);
				newParticle2.graphics.drawCircle( dimensions2, dimensions2, dimensions2 );
				newParticle2.x = 800; 
				newParticle2.y = int(Math.random() * 400) + 40;
				
				glow = new GlowFilter();
				glow.color = 0x99999;
				glow.alpha = 4;
				glow.blurX = 15;
				glow.blurY = 15;
				glow.quality = BitmapFilterQuality.HIGH;
				newParticle2.filters = [glow];
				
				farParticleContainer.addChild(newParticle2);
			}
			
			for(var i:int = 0; i < particleContainer.numChildren; i++)
			{
				var particle:DisplayObject = particleContainer.getChildAt(i);
				
				particle.x -= maxSpeed;
				
				if( particle.x <= 0 )
					particleContainer.removeChild( particle );
			}
			
			for(var u:int = 0; u < farParticleContainer.numChildren; u++)
			{
				var farParticle:DisplayObject = farParticleContainer.getChildAt(u);
				
				farParticle.x -= 1;
				
				if( farParticle.x <= 0 )
					farParticleContainer.removeChild( farParticle );
			}
		}
	
	}

}
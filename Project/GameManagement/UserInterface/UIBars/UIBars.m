//
//  TowerSelection.m
//  towerDefense
//
//  Created by Joey Manso on 8/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "UIBars.h"
#import "TowerFactory.h"
#import "UITools.h"
#import "GameState.h"

@implementation TowerSelect

-(id)initWithBackground:(Image*)i
{
	if(self = [super initWithDisplayPos:[[Point2D alloc] initWithX:0.0f y:0.0] hidePos:[[Point2D alloc] initWithX:0.0f y:-50.0] imageRef:i])
	{
		// add our UIObjects
		[barObjects setObject:[[VendingMachineFactory alloc] initWithPosition:[[Point2D alloc] initWithX:0.1f * backgroundWidth y:0.65f * backgroundHeight]]
					   forKey:@"vmFactory"];
		[barObjects setObject:[[MatronFactory alloc] initWithPosition:[[Point2D alloc] initWithX:0.233f * backgroundWidth y:0.65f * backgroundHeight]]
					   forKey:@"mtFactory"];
		[barObjects setObject:[[CookieLauncherFactory alloc] initWithPosition:[[Point2D alloc] initWithX:0.367f * backgroundWidth y:0.65f * backgroundHeight]]
					   forKey:@"clFactory"];
		[barObjects setObject:[[FreezerFactory alloc] initWithPosition:[[Point2D alloc] initWithX:0.5f * backgroundWidth y:0.65f * backgroundHeight]]
					   forKey:@"frFactory"];
		[barObjects setObject:[[PopcornMachineFactory alloc] initWithPosition:[[Point2D alloc] initWithX:0.633f * backgroundWidth y:0.65f * backgroundHeight]]
					   forKey:@"pmFactory"];
		[barObjects setObject:[[PieLauncherFactory alloc] initWithPosition:[[Point2D alloc] initWithX:0.767f * backgroundWidth y:0.65f * backgroundHeight]]
					   forKey:@"plFactory"];
		[barObjects setObject:[[RegisterFactory alloc] initWithPosition:[[Point2D alloc] initWithX:0.9f * backgroundWidth y:0.65f * backgroundHeight]]
					   forKey:@"crFactory"];
		
		// display this bar on launch
		visible = YES;
		[self setState:BAR_DISPLAY];
		
		removedTowerFactory = nil;
		removedTowerFactoryKey = nil;
	}
	return self;
}
-(void)setState:(uint)s
{
	// override this to add lost tower factory
	[super setState:s];
	if(s == BAR_DISPLAY)
	{
		if(removedTowerFactory)
		{
			[[barObjects objectForKey:removedTowerFactoryKey] setRenderOnSelectBar:YES];
			removedTowerFactory = nil;
			removedTowerFactoryKey = nil;
		}
	}
}
-(BOOL)touchEvent:(CGPoint)touchPosition
{
	// when a tower factory is pressed, we want to stop drawing it
	if(!removedTowerFactory)
	{
		for(NSString *UIKey in barObjects)
		{
			removedTowerFactory = [barObjects objectForKey:UIKey];
			removedTowerFactoryKey = UIKey;
			if([removedTowerFactory respondToTouchAt:touchPosition])
			{
				[[barObjects objectForKey:UIKey] setRenderOnSelectBar:NO];
				return YES;
			}
			removedTowerFactory = nil;
		}
	}
	return NO;
}
-(void)drawBar
{
	if(visible)
	{
		// draw background
		[background renderAtPoint:CGPointMake(currentPosition.x,currentPosition.y) centerOfImage:NO];
		
		// draw all UIObjects
		for(NSString *UIKey in barObjects)
		{
			TowerFactory *tf = [barObjects objectForKey:UIKey];
			if([tf renderOnSelectBar])
				[tf drawUIObject];
		}
	}
}
@end

@implementation TowerDetails

const float TRANSITION_SPEED_BASE = 225.0f;

-(id)initWithBackground:(Image*)i
{
	if(self = [super initWithDisplayPos:[[Point2D alloc] initWithX:0.0f y:0.0] hidePos:[[Point2D alloc] initWithX:0.0f y:-50.0f] imageRef:i])
	{
		[barObjects setObject:[[Text alloc] initWithString:@"TowerName" position:[[Point2D alloc] initWithX:0.15f*backgroundWidth y:backgroundHeight]
												  fontName:@"TowerTitleFont"]
					   forKey:@"towerName"];
		[barObjects setObject:[[Text alloc] initWithString:@"" position:[[Point2D alloc] initWithX:0.15f * backgroundWidth y:0.6f * backgroundHeight]
												  fontName:@"EnemyStatFont"]
					   forKey:@"buttonBuyBlock"];
		[barObjects setObject:[[Button alloc] initWithImage:[[Image alloc] initWithImage:[UIImage imageNamed:@"ButtonBuy.png"] filter:GL_LINEAR]
												   position:[[Point2D alloc] initWithX:0.27f * backgroundWidth y:0.35f * backgroundHeight]] 
					   forKey:@"buttonBuy"];
		[barObjects setObject:[[Text alloc] initWithString:@"Damage :" position:[[Point2D alloc] initWithX:0.78f * backgroundWidth y:0.25f * backgroundHeight]
												  fontName:@"TowerStatFont"]
					   forKey:@"towerDamage"];
		[barObjects setObject:[[Text alloc] initWithString:@"Range :" position:[[Point2D alloc] initWithX:0.78f * backgroundWidth y:0.55f * backgroundHeight]
												  fontName:@"TowerStatFont"]
					   forKey:@"towerRange"];
		[barObjects setObject:[[Text alloc] initWithString:@"Rate :" position:[[Point2D alloc] initWithX:0.78f * backgroundWidth y:0.85f * backgroundHeight]
												  fontName:@"TowerStatFont"]
					   forKey:@"towerROF"];
		[barObjects setObject:[[Text alloc] initWithString:@"D Line One" position:[[Point2D alloc] initWithX:0.42f * backgroundWidth y:0.85f * backgroundHeight]
												  fontName:@"TowerStatFont"]
					   forKey:@"towerDesc1"];
		[barObjects setObject:[[Text alloc] initWithString:@"D Line Two" position:[[Point2D alloc] initWithX:0.42f * backgroundWidth y:0.55f * backgroundHeight]
												  fontName:@"TowerStatFont"]
					   forKey:@"towerDesc2"];
		[barObjects setObject:[[Text alloc] initWithString:@"D Line Three" position:[[Point2D alloc] initWithX:0.42f * backgroundWidth y:0.25f * backgroundHeight]
												  fontName:@"TowerStatFont"]
					   forKey:@"towerDesc3"];
		
		transitionSpeed = TRANSITION_SPEED_BASE;
		isMovingLeft = NO;
		towerFactoryOrigin = nil;
		towerCost = 0;
		requiredRound = 0;
	}
	return self;
}
-(void)setDescription:(NSString*)name cost:(uint)c range:(uint)range damage:(uint)damage rof:(float)rof
			descLine1:(NSString*)line1 descLine2:(NSString*)line2 descLine3:(NSString*)line3 requiredRound:(uint)rReq
{
	towerCost = c;
	requiredRound = rReq;
	[(Text*)[barObjects objectForKey:@"towerName"] setText:name];
	[(Text*)[barObjects objectForKey:@"towerRange"] append_uint:range];
	[(Text*)[barObjects objectForKey:@"towerDamage"] append_uint:damage];
	[(Text*)[barObjects objectForKey:@"towerROF"] append_float:rof];
	[(Text*)[barObjects objectForKey:@"towerDesc1"] setText:line1];
	[(Text*)[barObjects objectForKey:@"towerDesc2"] setText:line2];
	[(Text*)[barObjects objectForKey:@"towerDesc3"] setText:line3];
	
	if([[GameState sharedGameStateInstance] currentRound] < rReq)
	{
		[(Button*)[barObjects objectForKey:@"buttonBuy"] setActive:NO];
		[(Text*)[barObjects objectForKey:@"buttonBuyBlock"] setText:[NSString stringWithFormat:@"Round %u",rReq]];
	}
	else
	{
		if(towerCost > [[GameState sharedGameStateInstance] currentCash])
			[(Button*)[barObjects objectForKey:@"buttonBuy"] setActive:NO];
		else
			[(Button*)[barObjects objectForKey:@"buttonBuy"] setActive:YES];
		[(Text*)[barObjects objectForKey:@"buttonBuyBlock"] setText:@""];
	}
}
-(void)setState:(uint)s
{
	// override this to send an event notice to the UI Manager to deal with unique movement properties
	[super setState:s];
	switch(s)
	{
		case BAR_LOCK:
			if(hidePosition.x > displayPosition.x)
			{
				isMovingLeft = NO;
				[hidePosition setX:0.0f y:-50.0f];
				[displayPosition setX:0.0f y:0.0f];
			}
			if(!visible && !isMovingLeft) // hidden, revert and remove tower factory
			{
				[towerFactoryOrigin release];
				towerFactoryOrigin = nil;
			}
			else
			{
				transitionSpeed = newTransitionSpeed;
				[[UIManager getInstance] detailsBarHasLocked];
			}
				
			break;
		case BAR_DISPLAY:
			if(hidePosition.x > displayPosition.x)
			{
				// HACK boo, hiss
				isMovingLeft = YES;
			}
			break;
		case BAR_HIDE:
			if(hidePosition.x > displayPosition.x)
			{
				[displayPosition setX:currentPosition.x y:currentPosition.y];
				[hidePosition setX:currentPosition.x y:-50.0f];
				[super setState:s];
			}
			transitionSpeed = TRANSITION_SPEED_BASE;
	}
	
}
-(void)setTowerFactory:(TowerFactory*)tf
{
	towerFactoryRef = tf;
	towerFactoryOrigin = [[Point2D alloc] initWithX:[tf UIObjectPosition].x y:[tf UIObjectPosition].y];
}
-(void)drawBar
{
	if(visible)
	{
		[super drawBar];
		[(Text*)[barObjects objectForKey:@"buttonBuyBlock"] drawUIObject];
		if(towerFactoryRef)
		{
			if(state == BAR_DISPLAY && !isMovingLeft)
				[towerFactoryRef drawUIObjectAtPoint:towerFactoryOrigin];
			else
				[towerFactoryRef drawUIObjectAtCGPoint:CGPointMake(currentPosition.x + [towerFactoryRef detailsBarRelativeX],
																   currentPosition.y + towerFactoryRef.UIObjectRelativePosition.y)];
		}
	}
}
-(BOOL)touchEvent:(CGPoint)touchPosition
{
	// the only touch event we care about is the buy button
	if([self barIsTouched:touchPosition])
	{
		if([[barObjects objectForKey:@"buttonBuy"] respondToTouchAt:touchPosition])
		{
			buttonPressed = BUTTON_TOWER;
			[[TouchManager getInstance] putPendingTowerOnMap];
		}
		return YES;
	}
	return NO;
}
-(void)cashHasChanged:(uint)newCashAmount
{
	if(visible)
	{
		if(towerCost > newCashAmount || [[GameState sharedGameStateInstance] currentRound] < requiredRound)
			[(Button*)[barObjects objectForKey:@"buttonBuy"] setActive:NO];
		else
			[(Button*)[barObjects objectForKey:@"buttonBuy"] setActive:YES];
	}
}
-(void)roundHasFinished:(uint)newRound currentCash:(uint)cash;
{
	if(newRound >= requiredRound)
	{
		[(Text*)[barObjects objectForKey:@"buttonBuyBlock"] setText:@""];
		if(towerCost <= cash)
			[(Button*)[barObjects objectForKey:@"buttonBuy"] setActive:YES];
	}
}
-(void)scaleTransitionSpeed:(float)scaleAmount
{
	newTransitionSpeed = TRANSITION_SPEED_BASE * scaleAmount;
}
-(void)dealloc
{
	if(towerFactoryOrigin)
		[towerFactoryOrigin dealloc];
	[super dealloc];
}
@end


@implementation ConfirmBar

-(id)initWithBackground:(Image*)i
{
	if(self = [super initWithDisplayPos:[[Point2D alloc] initWithX:0.0f y:0.0f] hidePos:[[Point2D alloc] initWithX:0.0f y:-50.0] imageRef:i])
	{
		// add our UIObjects
		Button *b = [[Button alloc] initWithImage:[[Image alloc] initWithImage:[UIImage imageNamed:@"ButtonConfirm.png"] filter:GL_LINEAR] 
										 position:[[Point2D alloc] initWithX:0.25 * backgroundWidth y:0.5 * backgroundHeight]
									clickSoundKey:nil];
		[b setUIObjectScale:0.75f];
		
		[barObjects setObject:b forKey:@"CONFIRM"];
		
		b = [[Button alloc] initWithImage:[[Image alloc] initWithImage:[UIImage imageNamed:@"ButtonCancel.png"] filter:GL_LINEAR] 
								 position:[[Point2D alloc] initWithX:0.75 * backgroundWidth 
																   y:0.5 * backgroundHeight]];
		[b setUIObjectScale:0.75f];
		
		[barObjects setObject:b forKey:@"CANCEL"];
		
		[b release];
	}
	return self;
}
-(BOOL)touchEvent:(CGPoint)touchPosition
{
	// check our buttons to see if they were hit
	if([[barObjects objectForKey:@"CONFIRM"] respondToTouchAt:touchPosition])
	{
		buttonPressed = BUTTON_CONFIRM;
		return YES;
	}
	if([[barObjects objectForKey:@"CANCEL"] respondToTouchAt:touchPosition])
	{
		buttonPressed = BUTTON_CANCEL;
		return YES;
	}
	return NO;
}
-(void)setConfirmButton:(BOOL)activeFlag
{
	[[barObjects objectForKey:@"CONFIRM"] setActive:activeFlag];
}
@end

@implementation GameStatus

-(id)initWithBackground:(Image*)i
{
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    
	if(self = [super initWithDisplayPos:
               [[Point2D alloc] initWithX:0.0f y:screenBounds.size.height - 50.0f]
                                hidePos:[[Point2D alloc] initWithX:0.0f y:screenBounds.size.height]
                               imageRef:i])
	{
		[barObjects setObject:[[MenuButton alloc] initWithImage:[[Image alloc] initWithImage:[UIImage imageNamed:@"ButtonMenu.png"] filter:GL_LINEAR]
													   position:[[Point2D alloc] initWithX:0.16f * backgroundWidth y:0.3f * backgroundHeight]]
					   forKey:@"menuButton"];
		[barObjects setObject:[[Text alloc] initWithString:@"Lives: " position:[[Point2D alloc] initWithX:0.05f * backgroundWidth y:1.1f * backgroundHeight]
												  fontName:@"GameStatFont"]
					   forKey:@"currentLives"];
		[barObjects setObject:[[Text alloc] initWithString:@"Score: " position:[[Point2D alloc] initWithX:0.35f * backgroundWidth y:0.6f * backgroundHeight]
												  fontName:@"GameStatFont"]
					   forKey:@"currentScore"];
		[barObjects setObject:[[Text alloc] initWithString:@"Cash: " position:[[Point2D alloc] initWithX:0.37f * backgroundWidth y:1.1f * backgroundHeight]
											      fontName:@"GameStatFont"]
					   forKey:@"currentCash"];
		[barObjects setObject:[[Text alloc] initWithString:@"Round: " position:[[Point2D alloc] initWithX:0.72f * backgroundWidth y:1.07f * backgroundHeight]
												  fontName:@"GameStatFont"]
					   forKey:@"currentRound"];
		[barObjects setObject:[[Button alloc] initWithImage:[[Image alloc] initWithImage:[UIImage imageNamed:@"ButtonStart.png"] filter:GL_LINEAR]
												   position:[[Point2D alloc] initWithX:0.82f * backgroundWidth y:0.3f * backgroundHeight]]
					   forKey:@"pauseButton"];
		visible = YES;
		startButtonWasPressed = NO;
		[self setState:BAR_DISPLAY];
	}
	return self;
}
-(void)resetStartButton
{
	startButtonWasPressed = NO;
	[(Button*)[barObjects objectForKey:@"pauseButton"] replaceWithImage:[[Image alloc]
																		initWithImage:[UIImage imageNamed:@"ButtonStart.png"] filter:GL_LINEAR]];
}
-(BOOL)touchEvent:(CGPoint)touchPosition
{
	// check our buttons to see if they were hit
	if([[barObjects objectForKey:@"pauseButton"] respondToTouchAt:touchPosition])
	{
		// switch start button to skip button
		if(!startButtonWasPressed)
		{
			startButtonWasPressed = YES;
			buttonPressed = BUTTON_START;
			[(Button*)[barObjects objectForKey:@"pauseButton"] replaceWithImage:[[Image alloc]
																				initWithImage:[UIImage imageNamed:@"ButtonPause.png"] filter:GL_LINEAR]];
		}
		else if(!pausedButtonWasPressed)
		{
			pausedButtonWasPressed = YES;
			buttonPressed = BUTTON_PAUSE;
			[(Button*)[barObjects objectForKey:@"pauseButton"] replaceWithImage:[[Image alloc]
																				 initWithImage:[UIImage imageNamed:@"ButtonStart.png"] filter:GL_LINEAR]];
		}
		else
		{
			pausedButtonWasPressed = NO;
			buttonPressed = BUTTON_RESUME;
			[(Button*)[barObjects objectForKey:@"pauseButton"] replaceWithImage:[[Image alloc]
																				 initWithImage:[UIImage imageNamed:@"ButtonPause.png"] filter:GL_LINEAR]];
		}
		return YES;
	}
	if([[barObjects objectForKey:@"menuButton"] respondToTouchAt:touchPosition])
	{
		buttonPressed = BUTTON_MENU;
		return YES;
	}
	return NO;
}

-(void)drawBar
{
	[super drawBar];
	// make sure we draw current round on top of the timer bar. Kinda hacky.
	[[barObjects objectForKey:@"currentRound"] drawUIObject];
}
-(void)setScore:(uint)s
{
	[(Text*)[barObjects objectForKey:@"currentScore"] append_uint:s];
}
-(void)setLives:(uint)l
{
	[(Text*)[barObjects objectForKey:@"currentLives"] append_uint:l];
}
-(void)setRound:(uint)r
{
	// animate status bar for round change
	[(StatusBar*)[barObjects objectForKey:@"currentTime"] playScaleAnimation];
	[(Text*)[barObjects objectForKey:@"currentRound"] append_uint:r];
}
-(void)setCash:(uint)c
{
	[(Text*)[barObjects objectForKey:@"currentCash"] append_uint:c];
}
@end

@interface TowerStatus()

-(void)setUpgradeButtonActive:(BOOL)active;

@end

@implementation TowerStatus
-(id)initWithBackground:(Image*)i
{
	if(self = [super initWithDisplayPos:[[Point2D alloc] initWithX:0.0f y:0.0] hidePos:[[Point2D alloc] initWithX:0.0f y:-50.0f] imageRef:i])
	{
		reloadBar = [[StatusBar alloc] initWithPosition:[[Point2D alloc] initWithX:40.0f y:0.2f * backgroundHeight] height:8.0f width:60.0f];
		[reloadBar setColorsStartRed:0.4f startGreen:1.0f startBlue:0.0f startAlpha:0.8f endRed:0.4f endGreen:1.0f endBlue:0.0f endAlpha:0.8f];
		
		[barObjects setObject:[[Text alloc] initWithString:@"TowerName" position:[[Point2D alloc] initWithX:10.0f y:backgroundHeight]
												  fontName:@"TowerTitleFont"]
					   forKey:@"towerName"];
		[barObjects setObject:[[Text alloc] initWithString:@" Level:" position:[[Point2D alloc] initWithX:10.0f y:0.55f * backgroundHeight]
												  fontName:@"TowerStatFont"]
					   forKey:@"towerLevel"];
		[barObjects setObject:reloadBar forKey:@"currentTime"];
		[barObjects setObject:[[Text alloc] initWithString:@"Damage :" position:[[Point2D alloc] initWithX:0.26f * backgroundWidth y:0.95f * backgroundHeight]
												  fontName:@"TowerStatFont"]
					   forKey:@"towerDamage"];
		[barObjects setObject:[[Text alloc] initWithString:@"Range :" position:[[Point2D alloc]  initWithX:0.26f * backgroundWidth y:0.65f * backgroundHeight]
												  fontName:@"TowerStatFont"]
					   forKey:@"towerRange"];
		[barObjects setObject:[[Text alloc] initWithString:@"Rate :" position:[[Point2D alloc] initWithX:0.26f * backgroundWidth y:0.35f * backgroundHeight]
												  fontName:@"TowerStatFont"]
					   forKey:@"towerROF"];
		[barObjects setObject:[[Text alloc] initWithString:@"Line One" position:[[Point2D alloc] initWithX:0.5f * backgroundWidth y:0.95f * backgroundHeight]
												  fontName:@"TowerStatFont"]
					   forKey:@"towerSpecial1"];
		[barObjects setObject:[[Text alloc] initWithString:@"Line Two" position:[[Point2D alloc] initWithX:0.5f * backgroundWidth y:0.65f * backgroundHeight]
												  fontName:@"TowerStatFont"]
					   forKey:@"towerSpecial2"];
		[barObjects setObject:[[Text alloc] initWithString:@"Line Three" position:[[Point2D alloc] initWithX:0.5f * backgroundWidth y:0.35f * backgroundHeight]
												  fontName:@"TowerStatFont"]
					   forKey:@"towerSpecial3"];
		
		// buttons with amounts next to them
		[barObjects setObject:[[Button alloc] initWithImage:[[Image alloc] initWithImage:[UIImage imageNamed:@"ButtonUpgrade.png"] filter:GL_LINEAR]
												   position:[[Point2D alloc] initWithX:0.79f * backgroundWidth y:0.5 * backgroundHeight] 
											  clickSoundKey:@"UpgradeTower"] 
					   forKey:@"upgradeButton"];
		
		[barObjects setObject:[[Text alloc] initWithString:@"-" position:[[Point2D alloc] initWithX:0.75f * backgroundWidth y:0.4f * backgroundHeight]
												  fontName:@"CashFont"]
					   forKey:@"upgradeCost"];
		
		[barObjects setObject:[[Button alloc] initWithImage:[[Image alloc] initWithImage:[UIImage imageNamed:@"ButtonSell.png"] filter:GL_LINEAR]
												   position:[[Point2D alloc] initWithX:0.91f * backgroundWidth y:0.5 * backgroundHeight]] 
					   forKey:@"sellButton"];
		[barObjects setObject:[[Text alloc] initWithString:@"+" position:[[Point2D alloc] initWithX:0.87f * backgroundWidth y:0.4f * backgroundHeight]
												  fontName:@"CashFont"]
					   forKey:@"sellAmount"];
	}
	return self;
}

-(BOOL)touchEvent:(CGPoint)touchPosition
{
	// check our buttons to see if they were hit
	if([self barIsTouched:touchPosition])
	{
		if([[barObjects objectForKey:@"upgradeButton"] respondToTouchAt:touchPosition])
		{
			buttonPressed = BUTTON_UPGRADE;
			[[barObjects objectForKey:@"upgradeCost"] playScaleAnimation];
		}
		else if([[barObjects objectForKey:@"sellButton"] respondToTouchAt:touchPosition])
		{
			buttonPressed = BUTTON_SELL;
			[[barObjects objectForKey:@"sellAmount"] playScaleAnimation];
		}
		return YES;
	}
	return NO;
}

-(void)setName:(NSString*)n
{
	[(Text*)[barObjects objectForKey:@"towerName"] setText:n];
}
-(void)setStats:(uint)level range:(uint)range damage:(uint)damage rof:(float)rof sellAmount:(uint)sell upgradeCost:(uint)upgrade 
   specialLine1:(NSString*)line1 specialLine2:(NSString*)line2 specialLine3:(NSString*)line3
{
	upgradeCost = upgrade;
	[(Text*)[barObjects objectForKey:@"towerLevel"] append_uint:level];
	[(Text*)[barObjects objectForKey:@"towerRange"] append_uint:range];
	[(Text*)[barObjects objectForKey:@"towerDamage"] append_uint:damage];
	[(Text*)[barObjects objectForKey:@"towerROF"] append_float:rof];
	[(Text*)[barObjects objectForKey:@"sellAmount"] append_uint:sell];
	if(upgrade==0 || upgradeCost > [[GameState sharedGameStateInstance] currentCash])
	{
		[self setUpgradeButtonActive:NO];
		if(upgrade==0)
			[(Text*)[barObjects objectForKey:@"upgradeCost"] setText:@"N/A"];
		else
		{
			[(Text*)[barObjects objectForKey:@"upgradeCost"] setText:@"-"];
			[(Text*)[barObjects objectForKey:@"upgradeCost"] append_uint:upgrade];
		}
	}
	else
	{
		[self setUpgradeButtonActive:YES];
		[(Text*)[barObjects objectForKey:@"upgradeCost"] setText:@"-"];
		[(Text*)[barObjects objectForKey:@"upgradeCost"] append_uint:upgrade];
		[(Text*)[barObjects objectForKey:@"upgradeCost"] setAlpha:1.0f];
	}
	[(Text*)[barObjects objectForKey:@"towerSpecial1"] setText:line1];
	[(Text*)[barObjects objectForKey:@"towerSpecial2"] setText:line2];
	[(Text*)[barObjects objectForKey:@"towerSpecial3"] setText:line3];
}
-(void)setUpgradeButtonActive:(BOOL)active
{
	[(Button*)[barObjects objectForKey:@"upgradeButton"] setActive:active];
	
	if(active)
		[(Text*)[barObjects objectForKey:@"upgradeCost"] setAlpha:1.0f];
	else
		[(Text*)[barObjects objectForKey:@"upgradeCost"] setAlpha:0.25f];
}

-(void)drawBar
{
	if(visible)
	{
		[super drawBar];
		// make sure we draw text on top of our buttons. Yey more hacks
		[[barObjects objectForKey:@"upgradeCost"] drawUIObject];
		[[barObjects objectForKey:@"sellAmount"] drawUIObject];
	}
}
-(void)cashHasChanged:(uint)newCashAmount
{
	if(visible)
	{
		if(upgradeCost > newCashAmount || upgradeCost == 0)
			[self setUpgradeButtonActive:NO];
		else
			[self setUpgradeButtonActive:YES];
	}
}
-(void)updateReloadBar:(float)ratio
{
	[reloadBar setFillRatio:ratio];
}

@end
@implementation EnemyStatus

-(id)initWithBackground:(Image*)i
{
	if(self = [super initWithDisplayPos:[[Point2D alloc] initWithX:0.0f y:0.0] hidePos:[[Point2D alloc] initWithX:0.0f y:-50.0f] imageRef:i])
	{
		[barObjects setObject:[[Text alloc] initWithString:@"EnemyName" position:[[Point2D alloc] initWithX:5.0f y:0.95f * backgroundHeight]
												  fontName:@"EnemyStatFont"]
					   forKey:@"enemyName"];
		[barObjects setObject:[[Text alloc] initWithString:@"Ground" position:[[Point2D alloc] initWithX:5.0f y:0.55f * backgroundHeight]
												  fontName:@"EnemyStatFont"]
					   forKey:@"enemyType"];
		[barObjects setObject:[[Text alloc] initWithString:@"Speed: " position:[[Point2D alloc] initWithX:0.28f * backgroundWidth y:0.95f * backgroundHeight]
												  fontName:@"EnemyStatFont"]
					   forKey:@"enemySpeed"];
		[barObjects setObject:[[Text alloc] initWithString:@"HP: " position:[[Point2D alloc] initWithX: 0.28f * backgroundWidth y:0.55f *backgroundHeight]
												  fontName:@"EnemyStatFont"]
					   forKey:@"enemyHP"];
		[barObjects setObject:[[Text alloc] initWithString:@"Immune" position:[[Point2D alloc] initWithX:0.73f * backgroundWidth y:0.95f * backgroundHeight]
												  fontName:@"EnemyStatFont"]
					   forKey:@"enemyImmunity"];
		[barObjects setObject:[[Text alloc] initWithString:@"None" position:[[Point2D alloc] initWithX:0.73f * backgroundWidth y:0.55f * backgroundHeight]
												  fontName:@"EnemyStatFont"]
					   forKey:@"enemyImmunityType"];
	}
	return self;
}

-(void)setName:(NSString*)n speed:(uint)s type:(NSString*)t immunity:(NSString*)i
{
	[(Text*)[barObjects objectForKey:@"enemyName"] setText:n];
	[(Text*)[barObjects objectForKey:@"enemySpeed"] append_uint:s];
	[(Text*)[barObjects objectForKey:@"enemyType"] setText:t];
	[(Text*)[barObjects objectForKey:@"enemyImmunityType"] setText:i];
}
-(void)setHitPoints:(uint)current total:(uint)total
{
	[(Text*)[barObjects objectForKey:@"enemyHP"] append_divisor:current max:total];
}
-(BOOL)touchEvent:(CGPoint)touchPosition
{
	return [self barIsTouched:touchPosition];
}

@end

@implementation MessageScreen

-(id)initWithBackground:(Image*)i
{
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGPoint screenOffset = CGPointMake(0.0f,0.0f);
    screenOffset.x = (screenBounds.size.width - [i imageWidth]) * 0.5f;
    screenOffset.y = (screenBounds.size.height - [i imageHeight]) * 0.5f;
    
	if(self = [super initWithDisplayPos:[[Point2D alloc] initWithX:screenOffset.x y:screenOffset.y] hidePos:[[Point2D alloc] initWithX:screenOffset.x - 300.0f y:screenOffset.y] imageRef:i])
	{
		buttonPressed = BUTTON_ROUND;
		transitionSpeed = 545.0f;
		startPosition = [[Point2D alloc] initWithX:screenOffset.x + 340.0f y:screenOffset.y];
		[currentPosition setX:startPosition.x y:startPosition.y];
		[direction setX:-1 y:0.0f];
		
		Text *title = [[Text alloc] initWithString:@"Round 0 Completed!" position:[[Point2D alloc] initWithX:30.0f y:325.0f] fontName:@"GameStatFont"];
		[title setUIObjectScale:1.35f];
		
		[barObjects setObject:title forKey:@"MessageTitle"];
		[barObjects setObject:[[Text alloc] initWithString:@"10/10 Enemies Defeated" position:[[Point2D alloc] initWithX:15.0f y:275.0f] fontName:@"MessageFont"]
					   forKey:@"MessageDefeated"];
		[barObjects setObject:[[Text alloc] initWithString:@"100% x 50 = $50 Bonus" position:[[Point2D alloc] initWithX:15.0f y:225.0f] 
												  fontName:@"MessageFont"] forKey:@"MessageBonus"];
		[barObjects setObject:[[Text alloc] initWithString:@"MessageText1" position:[[Point2D alloc] initWithX:15.0f y:165.0f] fontName:@"MessageFont"]
					   forKey:@"MessageText1"];
		[barObjects setObject:[[Text alloc] initWithString:@"MessageText2" position:[[Point2D alloc] initWithX:15.0f y:140.0f] fontName:@"MessageFont"]
					   forKey:@"MessageText2"];
		[barObjects setObject:[[Text alloc] initWithString:@"MessageText3" position:[[Point2D alloc] initWithX:15.0f y:115.0f] fontName:@"MessageFont"]
					   forKey:@"MessageText3"];
		[barObjects setObject:[[Button alloc] initWithImage:[[Image alloc] initWithImage:[UIImage imageNamed:@"ButtonStartRound.png"] filter:GL_LINEAR]
												   position:[[Point2D alloc] initWithX:140.0f y:38.0f]] forKey:@"MessageStartRoundButton"];
	}
	return self;
}
-(void)setRound:(uint)round enemiesDefeated:(uint)defeated enemiesTotal:(uint)total maxBonusCash:(uint)maxBonus 
	   message1:(NSString*)msg1 message2:(NSString*)msg2 message3:(NSString*)msg3
{
	float bonusPercent;
	if(total == 0)
		bonusPercent = 0.0f;
	else
		bonusPercent = (float)defeated/(float)total;
	uint givenBonus = (uint)(bonusPercent * (float)maxBonus);
	[(Text*)[barObjects objectForKey:@"MessageTitle"] setText:[NSString stringWithFormat:@"Round %u Completed!",round]];
	[(Text*)[barObjects objectForKey:@"MessageDefeated"] setText:[NSString stringWithFormat:@"%u/%u Enemies Defeated",defeated,total]];
	[(Text*)[barObjects objectForKey:@"MessageBonus"] setText:[NSString stringWithFormat:@"%.1f%% x %u = $%u Bonus",bonusPercent*100.0f,maxBonus,givenBonus]];
	[(Text*)[barObjects objectForKey:@"MessageText1"] setText:msg1];
	[(Text*)[barObjects objectForKey:@"MessageText2"] setText:msg2];
	[(Text*)[barObjects objectForKey:@"MessageText3"] setText:msg3];
}
-(void)setWithCutomTitle:(NSString*)title enemiesDefeated:(uint)defeated enemiesTotal:(uint)total maxBonusCash:(uint)maxBonus 
				message1:(NSString*)msg1 message2:(NSString*)msg2 message3:(NSString*)msg3;
{
	[self setRound:0 enemiesDefeated:defeated enemiesTotal:total maxBonusCash:maxBonus message1:msg1 message2:msg2 message3:msg3];
	[(Text*)[barObjects objectForKey:@"MessageTitle"] setText:title];
}
-(void)setState:(uint)s
{
	// message display is special and never changes direction
	state = s;
}
-(void)swapRoundWithReset:(Image*)resetImage
{
	[(Button*)[barObjects objectForKey:@"MessageStartRoundButton"] replaceWithImage:resetImage];
	buttonPressed = BUTTON_MENU;
}
-(void)swapResetWithRound:(Image*)roundImage
{
	[(Button*)[barObjects objectForKey:@"MessageStartRoundButton"] replaceWithImage:roundImage];
	buttonPressed = BUTTON_ROUND;
}
-(void)updateBar:(float)deltaTime
{
	// the logic below has the bar slide to the appropriate location depending on state, and locks it once there.
	switch (state) 
	{
		case BAR_HIDE:
			[currentPosition updateWithVector2D:direction speed:transitionSpeed deltaT:deltaTime];
			if(fabs(displayPosition.x - currentPosition.x) > fabs(displayPosition.x - hidePosition.x))
			{
				[currentPosition setX:startPosition.x y:startPosition.y];
				visible = NO;
				[self setState:BAR_LOCK];
			}
			[self transitionUIObjects];
			break;
		case BAR_DISPLAY:
			visible = YES;
			[currentPosition updateWithVector2D:direction speed:transitionSpeed deltaT:deltaTime];
			if(fabs(startPosition.x - currentPosition.x) >= fabs(startPosition.x - displayPosition.x))
			{
				[currentPosition setX:displayPosition.x y:displayPosition.y];
				[self setState:BAR_LOCK];
			}
			[self transitionUIObjects];
			break;
		default:
			break;
	}
	if(visible)
	{
		// if we're visible, then we want to update our UIObjects as well
		for(NSString *UIKey in barObjects)
			[[barObjects objectForKey:UIKey] updateUIObject:deltaTime];
	}
}
-(void)hideBar
{
	visible = NO;
	[currentPosition setX:startPosition.x y:startPosition.y];
}
-(BOOL)touchEvent:(CGPoint)touchPosition
{
	return [[barObjects objectForKey:@"MessageStartRoundButton"] respondToTouchAt:touchPosition];
}
-(void)dealloc
{
	[startPosition dealloc];
	[super dealloc];
}
@end




















//
//  UIManager.m
//  towerDefense
//
//  Created by Joey Manso on 8/11/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "UIManager.h"
#import "UIBars.h"
#import "TouchManager.h"
#import "SoundManager.h"
#import "GameState.h"

static Image *BarBlank; // single instance of default background that UIBars will refer to
static UIBar *bottomUIBar; // currently displaying bar on the bottom (Game Stats are always at the top)
static SoundManager *soundMan;
static GameStatus *gameStatus;
static TowerSelect *towerSelect;
static TowerDetails *towerDetails;
static ConfirmBar *confirmBar;
static TowerStatus *towerStatus;
static EnemyStatus *enemyStatus;
static MessageScreen *messageScreen;

@interface UIManager()
@end


@implementation UIManager

@synthesize showingMessageScreen;

-(id)init
{
	if(self = [super init])
	{
		BarBlank = [[Image alloc] initWithImage:[UIImage imageNamed:@"BarBlank.png"] filter:GL_LINEAR];
		showingMessageScreen = NO;
		soundMan = [SoundManager getInstance];
	}
	return self;
}
+(UIManager*)getInstance
{
	// return a singleton
	static UIManager *UIManagerInstance;
	
	// lock the class (for multithreading!)
	@synchronized(self)
	{
		if(!UIManagerInstance)
		{
			UIManagerInstance = [[UIManager alloc] init];
			// add the bars we're going to use
			messageScreen = [[MessageScreen alloc] initWithBackground:[[Image alloc] initWithImage:[UIImage imageNamed:@"BackgroundMessage.png"] 
																							filter:GL_LINEAR]];
			gameStatus = [[GameStatus alloc] initWithBackground:[[Image alloc] initWithImage:[UIImage imageNamed:@"BarGameStats.png"] filter:GL_LINEAR]];
			towerDetails = [[TowerDetails alloc] initWithBackground:[[Image alloc] initWithImage:[UIImage imageNamed:@"BarTowerDesc.png"] filter:GL_LINEAR]];
			confirmBar = [[ConfirmBar alloc] initWithBackground:BarBlank];
			towerStatus = [[TowerStatus alloc] initWithBackground:[[Image alloc] initWithImage:[UIImage imageNamed:@"BarTowerStats.png"] filter:GL_LINEAR]];
			enemyStatus = [[EnemyStatus alloc] initWithBackground:[[Image alloc] initWithImage:[UIImage imageNamed:@"BarEnemyStats.png"] filter:GL_LINEAR]];
			towerSelect = [[TowerSelect alloc] initWithBackground:BarBlank];
			bottomUIBar = towerSelect;
		}
		
	}
	
	return UIManagerInstance;
}

-(void)updateActiveUI:(float)deltaTime
{
	[towerSelect updateBar:deltaTime];
	[gameStatus updateBar:deltaTime];
	[towerDetails updateBar:deltaTime];
	[confirmBar updateBar:deltaTime];
	[towerStatus updateBar:deltaTime];
	[enemyStatus updateBar:deltaTime];
	[messageScreen updateBar:deltaTime];
}
-(void)drawActiveUI
{
	[towerSelect drawBar];	
	[gameStatus drawBar];
	[towerDetails drawBar];
	[confirmBar drawBar];
	[towerStatus drawBar];
	[enemyStatus drawBar];
	[messageScreen drawBar];
}
-(BOOL)touchEvent:(CGPoint)touchPosition
{
	BOOL returnVal = NO;
	// check all UIBars with input for potential touch events
	
	// the message screen supercedes all other activity
	if(showingMessageScreen)
	{
		if([messageScreen touchEvent:touchPosition]) // only button this has is to start the round
		{
			if([messageScreen buttonPressed] == BUTTON_ROUND)
				[[GameState sharedGameStateInstance] messageScreenHasFinished];
			else if([messageScreen buttonPressed] == BUTTON_MENU)
				[[GameState sharedGameStateInstance] showMenuEndGame];
			
			[messageScreen setState:BAR_HIDE];
			showingMessageScreen = NO;
			returnVal = YES;
		}
	}
	else
	{
		// first check the status bar, as it's always present
		// if no event here, then check bottom bar
		if([gameStatus touchEvent:touchPosition])
		{
			switch(gameStatus.buttonPressed)
			{
				case BUTTON_START:
					[gameStatus resetButtonPressed];
					[[GameState sharedGameStateInstance] goToNextRound];
					break;
				case BUTTON_PAUSE:
					[gameStatus resetButtonPressed];
					[[GameState sharedGameStateInstance] pause];
					break;
				case BUTTON_RESUME:
					[gameStatus resetButtonPressed];
					[[GameState sharedGameStateInstance] unpause];
					break;
				case BUTTON_MENU:
					[gameStatus resetButtonPressed];
					[[GameState sharedGameStateInstance] showMenu];
				default:
					break;
			}
			returnVal = YES;
		}
		else if(![[GameState sharedGameStateInstance] paused])
		{
			if(towerSelect == bottomUIBar && [towerSelect state] == BAR_LOCK)
			{
				if([towerSelect touchEvent:touchPosition])
				{
					showingTowerDetailsBar = YES;
					[towerDetails setState:BAR_DISPLAY];
					returnVal = YES;
				}
			}
			else if(towerDetails == bottomUIBar && [towerDetails state] == BAR_LOCK)
			{			
				if([towerDetails touchEvent:touchPosition])
				{
					if(towerDetails.buttonPressed == BUTTON_TOWER)
					{
						[bottomUIBar setState:BAR_HIDE];
						bottomUIBar = confirmBar;
						[towerDetails resetButtonPressed];;
						returnVal = YES;
					}
				}
				else if(!showingTowerDetailsBar)
				{
					// if the user clicks elsewhere, go back to select bar
					[bottomUIBar setState:BAR_HIDE];
					bottomUIBar = towerSelect;
					[[TouchManager getInstance] removePendingTower];
				}
				
				[bottomUIBar setState:BAR_DISPLAY];
			}
			else if(confirmBar == bottomUIBar && [confirmBar state] == BAR_LOCK)
			{
				if([confirmBar touchEvent:touchPosition])
				{
					switch(confirmBar.buttonPressed)
					{
						case BUTTON_CONFIRM:
							[confirmBar resetButtonPressed];
							if([[TouchManager getInstance] hasPendingTower])
							{
								// confirm placement of tower
								[soundMan playSoundWithKey:@"PlaceTower" gain:1.0f pitch:1.0f shouldLoop:NO];
								if(![[TouchManager getInstance] placeTower]) // fails if the tower is in an invalid location
									return YES;
							}
							else
							{
								// confirm sell of tower
								[soundMan playSoundWithKey:@"SellTower" gain:1.0f pitch:1.0f shouldLoop:NO];
								[[GameState sharedGameStateInstance] sellSelectedTower];
							}
							break;
						case BUTTON_CANCEL:
							[confirmBar resetButtonPressed];
							if([[TouchManager getInstance] hasPendingTower])
								[[TouchManager getInstance] removeTower];
							else
							{
								// go back to tower stats for this tower on cancel of sell
								[bottomUIBar setState:BAR_HIDE];
								[towerStatus setState:BAR_DISPLAY];
								bottomUIBar = towerStatus;
								return YES;
							}
							break;
						default:
							break;
					}
					
					[bottomUIBar setState:BAR_HIDE];
					[towerSelect setState:BAR_DISPLAY];
					bottomUIBar = towerSelect;
					returnVal = YES;
				}
			}
			else if(towerStatus == bottomUIBar &&  [towerStatus state] == BAR_LOCK)
			{
				if([towerStatus touchEvent:touchPosition])
				{
					// Only switch the UIBar (confirm) if we are selling. Stay with Stats if it's just an upgrade.
					switch(towerStatus.buttonPressed)
					{
						case BUTTON_UPGRADE:
							[towerStatus resetButtonPressed];
							[[GameState sharedGameStateInstance] upgradeSelectedTower];
							break;
						case BUTTON_SELL:
							[towerStatus resetButtonPressed];
							[bottomUIBar setState:BAR_HIDE];
							[confirmBar setState:BAR_DISPLAY];
							bottomUIBar = confirmBar;
							break;
						default:
							break;
					}
					returnVal = YES;
				}
			}
			else if(enemyStatus == bottomUIBar && [bottomUIBar touchEvent:touchPosition])
				returnVal = YES;
		}
	}
	return returnVal;
}
-(void)detailsBarHasLocked
{
	if(towerSelect == bottomUIBar && [bottomUIBar state] == BAR_LOCK)
	{
		// hide select bar and shift details bar to the left, setting it as the current bottom bar
		showingTowerDetailsBar = NO;
		[bottomUIBar setState:BAR_HIDE];
		bottomUIBar = towerDetails;
		[[bottomUIBar hidePosition] setX:[bottomUIBar currentPosition].x y:[bottomUIBar currentPosition].y];
		[[bottomUIBar displayPosition] setX:0.0f y:0.0f];
		[bottomUIBar setState:BAR_DISPLAY];
	}
}
-(void)cashHasChanged:(uint)newCashAmount
{
	// only check for bars that care
	[towerDetails cashHasChanged:newCashAmount];
	[towerStatus cashHasChanged:newCashAmount];
}
-(void)roundHasFinished:(uint)newRound currentCash:(uint)cash;
{
	[towerDetails roundHasFinished:newRound currentCash:cash];
}
-(BOOL)showTowerStats
{
	if(towerStatus != bottomUIBar && confirmBar != bottomUIBar)
	{
		// if the tower bar is not currently displaying, animate it to display
		// special cases, horray...
		if([towerDetails state] != BAR_DISPLAY)
		{
			[bottomUIBar setState:BAR_HIDE];
			[towerStatus setState:BAR_DISPLAY];
			bottomUIBar = towerStatus;
			return YES;
		}
	}
	return NO;
}
-(BOOL)showEnemyStats
{
	if(enemyStatus != bottomUIBar && confirmBar != bottomUIBar)
	{
		// if the tower bar is not currently displaying, animate it to display
		// special cases, horray...
		if([towerDetails state] != BAR_DISPLAY)
		{
			[bottomUIBar setState:BAR_HIDE];
			[enemyStatus setState:BAR_DISPLAY];
			bottomUIBar = enemyStatus;
			return YES;
		}
	}
	return NO;
}
-(BOOL)clearBottomStatsBar
{
	if(confirmBar != bottomUIBar)
	{
		[bottomUIBar setState:BAR_HIDE];
		bottomUIBar = towerSelect;
		[bottomUIBar setState:BAR_DISPLAY];
		return YES;
	}
	return NO;
}
-(void)setConfirmButton:(BOOL)activeFlag
{
	[confirmBar setConfirmButton:activeFlag];
}
-(TowerSelect*)getTowerSelectBarReference
{
	return towerSelect;
}
-(TowerDetails*)getTowerDetailsBarReference
{
	return towerDetails;
}
-(GameStatus*)getGameStatBarReference
{
	return gameStatus;
}
-(TowerStatus*)getTowerStatBarReference
{
	return towerStatus;
}
-(EnemyStatus*)getEnemyStatBarReference
{
	return enemyStatus;
}
-(void)showMessageScreenWithRound:(uint)round numEnemiesDefeated:(uint)numDefeated numEnemiesTotal:(uint)numTotal maxBonusAmount:(uint)max 
						 message1:(NSString*)m1 message2:(NSString*)m2 message3:(NSString*)m3
{
	[messageScreen setState:BAR_DISPLAY];
	showingMessageScreen = YES;
	[messageScreen setRound:round enemiesDefeated:numDefeated enemiesTotal:numTotal maxBonusCash:max message1:m1 message2:m2 message3:m3];
}
-(void)showMessageCustomTitle:(NSString*)title numEnemiesDefeated:(uint)numDefeated numEnemiesTotal:(uint)numTotal maxBonusAmount:(uint)max 
					 message1:(NSString*)m1 message2:(NSString*)m2 message3:(NSString*)m3;
{
	[messageScreen setState:BAR_DISPLAY];
	showingMessageScreen = YES;
	[messageScreen setWithCutomTitle:title enemiesDefeated:numDefeated enemiesTotal:numTotal maxBonusCash:max message1:m1 message2:m2 message3:m3];
}
-(void)swapRoundWithReset:(Image*)resetImage
{
	[messageScreen swapRoundWithReset:resetImage];
}
-(void)resetGame
{
	// set the bottom bar reference to tower selection and hide all bars, preparing to display the starting bars
	[gameStatus hideBar];
	[towerDetails hideBar];
	[confirmBar hideBar];
	[towerStatus hideBar];
	[enemyStatus hideBar];
	[towerSelect hideBar];
	[messageScreen hideBar];
	
	[gameStatus resetStartButton];
	[messageScreen setButtonPressed:BUTTON_ROUND];
	[messageScreen swapResetWithRound:[[Image alloc] initWithImage:[UIImage imageNamed:@"ButtonStartRound.png"] filter:GL_LINEAR]];
	
	if([[TouchManager getInstance] hasPendingTower])
		[[TouchManager getInstance] removeTower];
	[bottomUIBar setState:BAR_HIDE];
	bottomUIBar = towerSelect;
	[towerSelect setState:BAR_DISPLAY];
	[gameStatus setState:BAR_DISPLAY];
}
-(void)dealloc
{
	[gameStatus release];
	[towerDetails release];
	[confirmBar release];
	[towerStatus release];
	[enemyStatus release];
	[towerSelect release];
	[super dealloc];
}
@end

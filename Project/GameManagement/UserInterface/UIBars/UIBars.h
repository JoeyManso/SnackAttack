//
//  TowerSelection.h
//  towerDefense
//
//  Created by Joey Manso on 8/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIBar.h"

@class TowerFactory;
@class StatusBar;

@interface TowerSelect : UIBar 
{
	@private
	TowerFactory *removedTowerFactory;
	NSString *removedTowerFactoryKey;
}
@end
@interface TowerDetails : UIBar 
{
	// reference to the tower factory origin Point and original relative position
	Point2D *towerFactoryOrigin;
	TowerFactory *towerFactoryRef;
	BOOL isMovingLeft;
	float newTransitionSpeed;
	
	uint towerCost;
	uint requiredRound;
}
-(void)setDescription:(NSString*)name cost:(uint)c range:(uint)range damage:(uint)damage rof:(float)rof
			descLine1:(NSString*)line1 descLine2:(NSString*)line2 descLine3:(NSString*)line3 requiredRound:(uint)rReq;
-(void)setTowerFactory:(TowerFactory*)tf;
-(void)scaleTransitionSpeed:(float)scaleAmount;
-(void)roundHasFinished:(uint)newRound currentCash:(uint)cash;
@end
@interface ConfirmBar : UIBar 
{
    BOOL towerPlaceable;
}
-(void)setTowerPlaceable:(BOOL)isPlaceable;
@end
@interface GameStatus : UIBar 
{
	BOOL startButtonWasPressed;
	BOOL pausedButtonWasPressed;
}
-(void)setScore:(uint)s;
-(void)setLives:(uint)l;
-(void)setRound:(uint)r;
-(void)setCash:(uint)c;
-(void)setGameSpeed:(float)s;
-(void)resetStartButton;
-(void)onLoadGame;
-(void)onResignActive;
@end

// only one instance of the bottom two bars which have their data swapped depending on the game object
@interface TowerStatus : UIBar 
{
	@private
	uint upgradeCost;
	StatusBar *reloadBar;
}
-(void)setName:(NSString*)n;
-(void)setStats:(uint)level range:(uint)range damage:(uint)damage rof:(float)rof sellAmount:(uint)sell upgradeCost:(uint)upgrade 
   specialLine1:(NSString*)line1 specialLine2:(NSString*)line2 specialLine3:(NSString*)line3;
-(void)updateReloadBar:(float)ratio;
@end
@interface EnemyStatus : UIBar 
{
}
-(void)setName:(NSString*)n speed:(uint)s type:(NSString*)t immunity:(NSString*)i;
-(void)setHitPoints:(uint)current total:(uint)total;
@end

@interface MessageScreen : UIBar 
{
	Point2D *startPosition;
}
-(void)setRound:(uint)round enemiesDefeated:(uint)defeated enemiesTotal:(uint)total maxBonusCash:(uint)maxBonus 
	   message1:(NSString*)msg1 message2:(NSString*)msg2 message3:(NSString*)msg3;
-(void)setWithCutomTitle:(NSString*)title enemiesDefeated:(uint)defeated enemiesTotal:(uint)total maxBonusCash:(uint)maxBonus 
				message1:(NSString*)msg1 message2:(NSString*)msg2 message3:(NSString*)msg3 message4:(NSString*)msg4 message5:(NSString*)msg5;
-(void)swapRoundWithReset:(Image*)resetImage;
-(void)swapResetWithRound:(Image*)roundImage;
@end

//
//  UIManager.h
//  towerDefense
//
//  Created by Joey Manso on 8/11/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIBars.h"

@interface UIManager : NSObject 
{
    BOOL showingTowerDetailsBar;
	BOOL showingMessageScreen;
}
@property(nonatomic, readonly)BOOL showingMessageScreen;
+(UIManager*)getInstance;

-(BOOL)touchEvent:(CGPoint)touchPosition;

-(void)updateActiveUI:(float)deltaTime;
-(void)drawActiveUI;
-(BOOL)showTowerStats;
-(BOOL)showEnemyStats;
-(void)showMessageScreenWithRound:(uint)round numEnemiesDefeated:(uint)numDefeated numEnemiesTotal:(uint)numTotal maxBonusAmount:(uint)max 
						 message1:(NSString*)m1 message2:(NSString*)m2 message3:(NSString*)m3;
-(void)showMessageCustomTitle:(NSString*)title numEnemiesDefeated:(uint)numDefeated numEnemiesTotal:(uint)numTotal maxBonusAmount:(uint)max 
					 message1:(NSString*)m1 message2:(NSString*)m2 message3:(NSString*)m3 message4:(NSString*)m4 message5:(NSString*)m5;
-(void)swapRoundWithReset:(Image*)resetImage;
-(BOOL)clearBottomStatsBar;

-(void)detailsBarHasLocked;
-(void)setConfirmButton:(BOOL)activeFlag;
-(void)cashHasChanged:(uint)newCashAmount; // cash has beed added or deducted (event)
-(void)roundHasFinished:(uint)newRound currentCash:(uint)cash; // round has finished (for tower details bar)
-(void)resetGame;
-(void)onLoadGame;
-(void)onResignActive;

-(TowerSelect*)getTowerSelectBarReference; // to give the TowerFactories direct access
-(TowerDetails*)getTowerDetailsBarReference; // to give the TowerFactories direct access
-(GameStatus*)getGameStatBarReference; // to give the game manager direct access
-(TowerStatus*)getTowerStatBarReference; // to give the Tower direct access
-(EnemyStatus*)getEnemyStatBarReference; // to give the Enemy direct access

@end

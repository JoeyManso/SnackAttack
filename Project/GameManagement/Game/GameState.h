//
//  GameState.h
//  towerDefense
//
//  Created by Joey Manso on 7/20/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

// static class

#import <Foundation/Foundation.h>
#import <OpenGLES/ES1/gl.h>
#import "GameObject.h"
#import "Round.h"

@class Map;

@interface GameState : NSObject 
{
@private
    NSMutableArray *gameObjects;
    NSMutableArray *addQueue;
    NSMutableArray *removeQueue;
    
    NSMutableArray *registerPoints; // array of register points on map to apply boosts, index these for speed
    
    float roundBuffer;
    uint enemiesDefeatedThisRound;
    uint bonusToApply;
    Round *currentRoundInfo;
    BOOL enemiesOnMap;
    
    int sortCounter;
@public
	// currently bound texture
	GLuint currentlyBoundTexture;
	
	// game stats
	uint currentLives;
	uint currentScore;
	uint currentCash;
	uint currentRound;
	
	// cumulative time
	float time;
	
	// flag to display debug information
	BOOL debug; 
	
	BOOL paused;
	
	Map *currentMap;
}
@property(nonatomic, assign)GLuint currentlyBoundTexture;
@property(nonatomic, readonly)uint currentScore;
@property(nonatomic, readonly)uint currentLives;
@property(nonatomic, readonly)uint currentCash;
@property(nonatomic, readonly)uint currentRound;
@property(nonatomic, readonly)float time;
@property(nonatomic, readonly)BOOL paused;

// return this singleton
+(GameState*)sharedGameStateInstance;

-(GameObject*)findObjectAtPosition:(CGPoint)p;
-(BOOL)pointIsWithinTower:(Point2D*)p;
-(BOOL)debugMode;
-(void)addObject:(GameObject*)o;
-(void)removeObject:(GameObject*)o;
-(void)update:(float)deltaTime;
-(void)draw;

-(void)setMap:(Map*)m;
-(void)goToNextRound;
-(void)pause;
-(void)unpause;
-(void)upgradeSelectedTower;
-(void)sellSelectedTower;
-(void)showMenu;
-(void)showMenuEndGame;
-(void)messageScreenHasFinished;
-(void)resetGame;

// for stats
-(void)subtractLife;
-(void)alterCash:(int)deltaCash;
-(void)enemyDefeated:(uint)enemyValue;

// for radius effects
-(void)damageEnemiesInRadius:(float)radius origin:(Point2D*)originPoint damage:(float)damage damageType:(uint)type;
-(void)freezeEnemiesInRadius:(float)radius origin:(Point2D*)originPoint duration:(float)duration;
-(void)showBoostForTowersFromPoint:(Point2D*)originPoint;
-(void)applyBoostForTowersFromPoint:(Point2D*)originPoint;
-(void)removeBoostForTowersFromPoint:(Point2D*)originPoint;
-(BOOL)isBoostTowerInRange:(Point2D*)startPoint;

@end

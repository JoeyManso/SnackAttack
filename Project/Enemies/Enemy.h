//
//  Enemy.h
//  towerDefense
//
//  Created by Joey Manso on 7/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnimationObject.h"
#import "PathNode.h"
#import "UIManager.h"
#import "UIBars.h"
#import "GameState.h"

@class StatusBar;

@interface Enemy : AnimationObject 
{
@private
    GameState *game;
    
    // reference to the Enemy Stat Bar and UI Manager
    EnemyStatus *enemyStatusBar;
    UIManager *UIMan;

@public
	float enemyHitPoints; // how many hitpoints an enemy has
	float enemySpeed; // speed, in units per second
	uint enemyType; // GROUND or AIR (default is ground)
	uint enemyImmunity; // types of attacks this enemy is immune to
	NSString *deathSoundKey; // key for the sound played on death
	uint killValue; // how much is earned by kililng this enemy
	
	uint kernelCount; // count of kernels this enemy has
	
	@private
	PathNode *target; // node the enemy is currently headed towards
	Vector2D *dirToTarget; // direction to target, used to compare against actual direction
	uint enemyMaxHitPoints;
	StatusBar *healthBar;
	
	BOOL isFrozen;
	float freezeTimeStamp;
	float freezeDuration;
	
	// for fade out death
	BOOL fadeOut;
	float deathFadeTimeCurrent;
	
	BOOL takeDamageOverTime;
	float addDamageTimeStamp;
	float damageDuration;
	float damagePerSecond;
	float damageBurstInterval; // create an emitter to burst at 1 second intervals
	
	GLfloat radiusVertices[720];
	
	@protected
	Animation *aniWalk;
}
@property(nonatomic, readonly)float enemyHitPoints;
@property(nonatomic, readonly)float enemySpeed;
@property(nonatomic, readonly)uint enemyType;
@property(nonatomic, readonly)uint enemyImmunity;
@property(nonatomic, readonly)NSString *deathSoundKey;
@property(nonatomic)uint kernelCount;

-(id)initWithName:(NSString*)n position:(Point2D*)p hitPoints:(float)hp speed:(float)s spriteSheet:(SpriteSheet*)ss targetNode:(PathNode*)t;

-(void)takeDamage:(float)d;
-(void)addDamageOverTime:(float)duration damage:(float)damage;
-(void)freeze:(float)duration;
-(uint)getTargetNodeValue;
-(void)multiplyMaxHitPoints:(uint)factor;

-(int)update:(float)deltaT;
-(int)draw;

@end

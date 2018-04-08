//
//  Projectile.h
//  towerDefense
//
//  Created by Joey Manso on 7/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageObject.h"
#import "ParticleEmitter.h"
#import "Enemy.h"

@interface Projectile : ImageObject 
{
	float projectileDamage; // damage projectile does
	float projectileSpeed; // speed in units per second
	float projectileBirthTime; // timestamp for the projectile creation time
	float projectileLifeDuration; // how long the projectile lasts (in seconds)
	ParticleEmitter* projectileTail;
	NSString *hitSoundKey;
	Enemy *targetEnemy; // reference to the targetted enemy (to hone in)
	uint projectileType;
	uint towerType; // Ground or Air
	
	@protected
	float projectileSpinAmount; // allows the projectile to spin while moving
	
	@private
	float homingDelay; // delay before updating trajectory (so we don't alter trajectory each frame)
}

@property(nonatomic, readonly)float projectileDamage;
@property(nonatomic, readonly)float projectileSpeed;
@property(nonatomic, readonly)float projectileBirthTime;
@property(nonatomic, readonly)float projectileLifeDuration;
@property(nonatomic, readonly)ParticleEmitter* projectileTail;
@property(nonatomic, readonly)Enemy *targetEnemy;
@property(nonatomic, readonly)uint projectileType;
@property(nonatomic, readonly)uint towerType;

-(id)initWithName:(NSString*)n position:(Point2D*)p damage:(float)d speed:(float)s image:(Image*)p;
-(void)setTarget:(Enemy*)enemy;
-(void)hasCollided:(Enemy*)e;

@end

//
//  Projectiles.h
//  towerDefense
//
//  Created by Joey Manso on 7/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Projectile.h"

@interface PopCan : Projectile 
{
@private
	NSString *explodeKey;
	float pcExplosionChance;
	float pcExplosionDamage;
}
-(id)initWithPosition:(Point2D*)p image:(Image*)i damage:(float)d speed:(float)s expChance:(float)exC expDamage:(float)exD;

@end

@interface Slop : Projectile 
{
@private
	float spDamageOverTime;
	float spDamageDuration;
}

-(id)initWithPosition:(Point2D*)p damage:(float)d speed:(float)s damagePerSec:(float)dmg damageDuration:(float)dur;

@end

@interface Cookie : Projectile 
{
	@private
	float fadeTime;
}

-(id)initWithPosition:(Point2D*)p image:(Image*)i damage:(float)d speed:(float)s range:(float)r;

@end

@interface Pie : Projectile 
{
	@private
	float timeLeft;
	float timeToTarget;
	float timeToHalfway;
	float pieBaseScale;
	
	float piExplosionRange;
	float piExplosionDamage;
}

-(id)initWithPosition:(Point2D*)p image:(Image*)i damage:(float)d speed:(float)s splashRange:(float)splashRng splashDamage:(float)splashDmg;

@end

@interface Kernel : Projectile 
{
@private
	BOOL isAttachedToEnemy;
	float attachedTime;
	float delayDamage;
	float delayTime;
}

-(id)initWithPosition:(Point2D*)p image:(Image*)i damage:(float)d speed:(float)s delayDamage:(float)delayDmg delayTime:(float)delayT;
@end

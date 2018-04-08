//
//  Projectile.m
//  towerDefense
//
//  Created by Joey Manso on 7/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Projectile.h"

@implementation Projectile

@synthesize projectileDamage;
@synthesize projectileSpeed;
@synthesize projectileBirthTime;
@synthesize projectileLifeDuration;
@synthesize projectileTail;
@synthesize targetEnemy;
@synthesize projectileType;
@synthesize towerType;

static const float MAX_HOMING_DELAY=0.1f;

-(id)init
{
	return [self initWithName:nil position:nil damage:0.0f speed:0.0f image:nil];
}
-(id)initWithName:(NSString*)n position:(Point2D*)p damage:(float)d speed:(float)s image:(Image*)i
{
	// make sure we initialize the super class
	if (self = [super initWithName:n position:p image:i])
	{		
		projectileDamage = d;
		projectileSpeed = s;
		projectileBirthTime = [GameObject getCurrentTime];
		projectileLifeDuration = 3.0f;
		projectileTail = nil;
		hitSoundKey = nil;
		targetEnemy = nil;
		homingDelay = 0.0f;
		projectileType = NONE;
		towerType = GROUND;
		
		projectileSpinAmount = 0.0f;
	}
	return self;
}
-(void)setTarget:(Enemy*)e
{
	if(e)
	{
		targetEnemy = e;
		[targetEnemy retain];
	}
}
-(void)hasCollided:(Enemy*)e
{
	// this method is called when a projectile hits an enemy
	// play hit something sound
	[self playSound];
	
	// apply damage to the enemy
	[e takeDamage:projectileDamage];
	// mark for removal
	[self remove];
}
-(int)update:(float)deltaT;
{
	if([GameObject getCurrentTime] - projectileBirthTime > projectileLifeDuration)
	{
		[self remove];
		return 1;
	}
	// check if the enemy is still alive, if so continue honing in on it
	if(targetEnemy && homingDelay > MAX_HOMING_DELAY && [targetEnemy enemyHitPoints] >= 1)
	{
		// update the projectile's trajectory every time we hit the MAX_FRAME_COUNT
		Vector2D* newDir = [Point2D subtract:targetEnemy.objectPosition :objectPosition];
		
		// rotate our sprite angle in degrees
		float dot = [Vector2D dot:objectDirection :newDir];
		float angle = [Math convertToDegrees:acos(dot)];
		// i think this is a hack
		if(dot < 0.0f || targetEnemy.objectDirection.x > targetEnemy.objectDirection.y)
			angle*=-1;
		
		// set our new vector
		[objectDirection setX:newDir.x y:newDir.y];
		
		// deallocate the new direction we created
		[newDir dealloc];
		
		homingDelay -= MAX_HOMING_DELAY;
	}
	homingDelay += deltaT;
	
	[objectPosition updateWithVector2D:objectDirection speed:projectileSpeed deltaT:deltaT];
	
	if(projectileSpinAmount != 0.0f)
		[self setObjectRotationAngle:objectRotationAngle+projectileSpinAmount];
	
	// if we have a tail, update it with the projectile's position and rotation
	if(projectileTail)
	{
		[projectileTail setSourcePosition:objectPosition];
		[projectileTail setAngle:objectRotationAngle];
	}

	return [super update:deltaT];
}
-(void)dealloc
{
	// remove tail smoothly
	if(projectileTail)
	{
		[projectileTail setDuration:0.0f];
		[projectileTail release];
	}
	if(targetEnemy)
		[targetEnemy release];
	[super dealloc];
}

@end

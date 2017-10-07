//
//  Projectiles.m
//  towerDefense
//
//  Created by Joey Manso on 7/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Projectiles.h"
#import "GameState.h"
#import "ProjectileFactory.h"

@implementation PopCan

static float const PC_EXP_RANGE = 50.0f; // radius of effect for explosion
static float const PC_EXP_ANI_TIME = 0.25f; // time the animation displays

-(id)initWithPosition:(Point2D*)p image:(Image*)i damage:(float)d speed:(float)s expChance:(float)exC expDamage:(float)exD
{
	if(self = [super initWithName:@"PopCan" position:p damage:d speed:s image:i])
	{
		projectileType = POP;
		towerType = GROUND;
		
		pcExplosionChance = exC;
		pcExplosionDamage = exD;
		
		hitSoundKey = @"PopCanHit";
		explodeKey = @"PopCanExplode";
		projectileSpinAmount = 10.0f;
		
		// set default sound key to hit
		objectSound.key = hitSoundKey;
		projectileTail = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:@"texture.png"
																		   position:[[Point2D alloc] initWithX:0.0f y:0.0f]
															 sourcePositionVariance:[[Point2D alloc] initWithX:0.0f y:0.0f]
																			  speed:1.0f
																	  speedVariance:0.5f
																   particleLifeSpan:0.2f	
														   particleLifespanVariance:0.4f
																			  angle:0.0f
																	  angleVariance:30.0f
																			gravity:nil
																		 startColor:Color4fMake(0.54f, 0.27f, 0.07f, 1.0f)
																 startColorVariance:Color4fMake(0.2f, 0.15f, 0.0f, 0.5f)
																		finishColor:Color4fMake(1.0f, 0.7f, 0.4f, 0.0f)  
																finishColorVariance:Color4fMake(0.15f, 0.15f, 0.15f, 0.0f)
																	   maxParticles:200
																	   particleSize:5
															   particleSizeVariance:4
																		   duration:-1
																	  blendAdditive:NO];
	}
	return self;
}

-(void)hasCollided:(Enemy*)e
{
	// override hasCollided to deal with pop can explosions
	if(RANDOM_0_TO_1() <= pcExplosionChance)
	{
		// damage nearby enemies
		[[GameState sharedGameStateInstance] damageEnemiesInRadius:PC_EXP_RANGE origin:objectPosition damage:pcExplosionDamage  damageType:projectileType];
		ParticleEmitter *p = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:@"texture.png"
														  position:[[Point2D alloc] initWithX:objectPosition.x y:objectPosition.y]
										    sourcePositionVariance:[[Point2D alloc] initWithX:5.0f y:5.0f]
											 				 speed:2.5f
											 		 speedVariance:0.0f
											 	  particleLifeSpan:0.25f	
										  particleLifespanVariance:0.0f
															 angle:0.0f
													 angleVariance:360.0f
														   gravity:nil
													    startColor:Color4fMake(1.0f, 1.0f, 1.0f, 1.0f)
											    startColorVariance:Color4fMake(0.0f, 0.0f, 0.0f, 0.5f)
													   finishColor:Color4fMake(0.54f, 0.27f, 0.07f, 0.0f) 
											   finishColorVariance:Color4fMake(0.2f, 0.1f, 0.1f, 0.0f)
													  maxParticles:300
													  particleSize:7
											  particleSizeVariance:5
														  duration:PC_EXP_ANI_TIME
													 blendAdditive:NO];
		[p release];
		// change our sound info to the explosion sound
		objectSound.key = explodeKey;
		objectSound.gain = 0.2f;
	}
	[super hasCollided:e];
	
	// change our sound back to the hit sound
	objectSound.key = hitSoundKey;
	objectSound.gain = 1.0f;
}		
@end

@implementation Slop

-(id)initWithPosition:(Point2D*)p damage:(float)d speed:(float)s damagePerSec:(float)dmg damageDuration:(float)dur
{
	if(self = [super initWithName:@"Slop" position:p damage:d speed:s image:nil])
	{
		projectileType = SLOP;
		towerType = AIR;
		
		spDamageOverTime = dmg;
		spDamageDuration = dur;
		hitSoundKey = @"SlopHit";
		
		// set default sound key to hit
		objectSound.key = hitSoundKey;
		projectileTail = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:@"Slop.png"
																		   position:[[Point2D alloc] initWithX:0.0f y:0.0f]
															 sourcePositionVariance:[[Point2D alloc] initWithX:0.0f y:0.0f]
																			  speed:1.0f
																	  speedVariance:0.5f
																   particleLifeSpan:0.1f	
														   particleLifespanVariance:0.0f
																			  angle:0.0f
																	  angleVariance:35.0f
																			gravity:nil
																		 startColor:Color4fMake(0.54f, 0.27f, 0.07f, 1.0f)
																 startColorVariance:Color4fMake(0.1f, 0.1f, 0.1f, 0.0f)
																		finishColor:Color4fMake(0.1f, 0.1f, 0.1f, 0.5f)  
																finishColorVariance:Color4fMake(0.1f, 0.1f, 0.1f, 0.0f)
																	   maxParticles:35
																	   particleSize:2
															   particleSizeVariance:7
																		   duration:-1
																	  blendAdditive:NO];
	}
	return self;
}
-(void)hasCollided:(Enemy*)e
{
	// add the slop damage over time
	[e addDamageOverTime:spDamageDuration damage:spDamageOverTime];
	[super hasCollided:e];
}
-(CGRect)getObjectHitBox
{
	return CGRectMake(objectPosition.x - ((10 * objectScale) * 0.5f), 
					  objectPosition.y - ((10 * objectScale) * 0.5f), 
					  10 * objectScale, 
					  10 * objectScale);
}
@end

@implementation Cookie

-(id)initWithPosition:(Point2D*)p image:(Image*)i damage:(float)d speed:(float)s range:(float)r
{
	if(self = [super initWithName:@"Cookie" position:p damage:d speed:s image:i])
	{
		projectileType = COOKIE;
		towerType = GROUND;
		
		hitSoundKey = @"CookieHit";
		projectileSpinAmount = 10.0f;
		// calculate how long the cookie lives based upon the current range of the tower
		projectileLifeDuration = 1.25f*(r/projectileSpeed);
		fadeTime = 0.4f * projectileLifeDuration; // duration of fade out
		
		// set default sound key to hit
		objectSound.key = hitSoundKey;
	}
	return self;
}
-(int)update:(float)deltaT
{
	/// THIS HAS TO BE A RENDER FILTER HACKKKK
	if([GameObject getCurrentTime] - projectileBirthTime > projectileLifeDuration - fadeTime)
	{
		objectAlpha = (fadeTime-(([GameObject getCurrentTime] - projectileBirthTime) - (projectileLifeDuration - fadeTime)))/fadeTime;
	}
	
	return [super update:deltaT];
}
@end

@interface Pie()

-(void)explode;

@end

@implementation Pie

float const piExplosionTime = 0.2f; // time the animation displays

-(id)initWithPosition:(Point2D*)p image:(Image*)i damage:(float)d speed:(float)s splashRange:(float)splashRng splashDamage:(float)splashDmg
{
	if(self = [super initWithName:@"Pie" position:p damage:d speed:s image:i])
	{
		projectileType = PIE;
		towerType = GROUND;
		
		piExplosionRange = splashRng;
		piExplosionDamage = splashDmg;
		hitSoundKey = @"PieHit";
		projectileSpinAmount = 4.0f;
		// set default sound key to hit
		objectSound.key = hitSoundKey;
		
		pieBaseScale = objectScale;
	}
	return self;
}
-(void)explode
{
	[[GameState sharedGameStateInstance] damageEnemiesInRadius:piExplosionRange origin:objectPosition damage:piExplosionDamage damageType:projectileType];
	ParticleEmitter *p = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:@"texture.png"
													  position:[[Point2D alloc] initWithX:objectPosition.x y:objectPosition.y]
										sourcePositionVariance:[[Point2D alloc] initWithX:5.0f y:5.0f]
														 speed:0.9f
												 speedVariance:0.0f
											  particleLifeSpan:0.008f * piExplosionRange	
									  particleLifespanVariance:0.0f
														 angle:0.0f
												 angleVariance:360.0f
													   gravity:nil
													startColor:Color4fMake(0.0f, 0.0f, 0.5f, 1.0f)
											startColorVariance:Color4fMake(0.0f, 0.0f, 0.0f, 0.0f)
												   finishColor:Color4fMake(0.58f, 0.0f, 0.82f, 1.0f) 
										   finishColorVariance:Color4fMake(0.2f, 0.0f, 0.1f, 0.0f)
												  maxParticles:300
												  particleSize:12
										  particleSizeVariance:5
													  duration:piExplosionTime
												 blendAdditive:NO];
	[p release];
	[self playSound];
	[self remove];
}
-(void)hasCollided:(Enemy*)e
{
	// check if we've "landed"
	if(timeLeft < timeToHalfway * 0.5f)
	{
		[e takeDamage:projectileDamage];
		[self explode];
	}
}
-(void)setTarget:(Enemy*)enemy
{
	[super setTarget:enemy];
	timeToTarget = [Math distance:[targetEnemy objectPosition] :objectPosition]/projectileSpeed;
	timeLeft = timeToTarget += timeToTarget*0.2f;
	timeToHalfway = timeToTarget * 0.5f;
}
-(int)update:(float)deltaT
{	
	if(timeLeft >= timeToHalfway)
		[self setObjectScale:pieBaseScale + (((timeToTarget - timeLeft)/timeToHalfway) * pieBaseScale)];
	else if(timeLeft < timeToHalfway && timeLeft > 0)
		[self setObjectScale:pieBaseScale + ((timeLeft/timeToHalfway) * pieBaseScale)];
	else
		[self explode];
	
	timeLeft-=deltaT;
	return [super update:deltaT];
}
@end

@interface Kernel()

-(void)explode;

@end

@implementation Kernel

-(id)initWithPosition:(Point2D*)p image:(Image*)i damage:(float)d speed:(float)s delayDamage:(float)delayDmg delayTime:(float)delayT
{
	if(self = [super initWithName:@"Kernel" position:p damage:d speed:s image:i])
	{
		projectileType = KERNEL;
		towerType = AIR;
		
		projectileSpinAmount = 10.0f;
		delayDamage = delayDmg;
		delayTime = delayT;
		isAttachedToEnemy = NO;
		attachedTime = 0.0f;
		hitSoundKey = @"PopcornHit";
		
		// set default sound key to hit
		objectSound.key = hitSoundKey;
		objectSound.gain = 2.0f;
	}
	return self;
}
-(void)hasCollided:(Enemy*)e
{
	if(delayDamage == 0.0f)
		[super hasCollided:e];
	else if(!isAttachedToEnemy)
	{
		// increment kernel count for this enemy
		[e setKernelCount:[e kernelCount]+1];
		isAttachedToEnemy = YES;
		attachedTime = [GameObject getCurrentTime];
		[self playSound];
		[e takeDamage:projectileDamage];
	}
}
-(int)update:(float)deltaT
{
	if(isAttachedToEnemy)
	{
		if([targetEnemy enemyHitPoints] > 1)
		{
			if([GameObject getCurrentTime] - attachedTime > delayTime)
				[self explode];
		}
		else // enemy has died, no explosion 
			[self remove];
	}
			
	return [super update:deltaT];
}
-(void)explode
{
	ParticleEmitter *p = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:@"Popcorn.png"
													  position:[[Point2D alloc] initWithX:[targetEnemy objectPosition].x y:[targetEnemy objectPosition].y]
										sourcePositionVariance:[[Point2D alloc] initWithX:0.0f y:0.0f]
														 speed:0.1f
												 speedVariance:1.1f
											  particleLifeSpan:0.4f	
									  particleLifespanVariance:0.0f
														 angle:0.0f
												 angleVariance:360.0f
													   gravity:nil
													startColor:Color4fMake(1.0f, 1.0f, 1.0f, 1.0f)
											startColorVariance:Color4fMake(0.0f, 0.0f, 0.0f, 0.0f)
												   finishColor:Color4fMake(1.0f, 1.0f, 1.0f, 0.4f)
										   finishColorVariance:Color4fMake(0.0f, 0.0f, 0.0f, 0.0f)
												  maxParticles:50
												  particleSize:4
										  particleSizeVariance:15
													  duration:0.25f
												 blendAdditive:NO];
	[p release];
	[targetEnemy takeDamage:delayDamage];
	[targetEnemy setKernelCount:[targetEnemy kernelCount]-1];
	objectSound.key = @"PopcornExplode";
	objectSound.gain = 0.7f;
	objectSound.pitch = 1.3f;
	[self playSound];
	[self remove];
}
@end

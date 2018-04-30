//
//  Towers.m
//  towerDefense
//
//  Created by Joey Manso on 7/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Towers.h"
#import "UIManager.h"
#import "TouchManager.h"

@implementation VendingMachine

// private consts
float const VM_ROF = 1.2f;
float const VM_RANGE = 70.0f;

-(id)initWithPosition:(Point2D*)p spriteSheet:(SpriteSheet*)ss
{
	if(self = [super initWithName:@"Vending" position:p projFactory:[[PopCanFactory alloc] init] rateOfFire:VM_ROF range:VM_RANGE cost:VM_COST 
					  spriteSheet:ss])
	{
		// set types
		towerType = GROUND;
		projectileType = POP;
		
		// set upgrades for this tower
		upgrades[0] = [[VendingUpgrade alloc] initWithCost:60 damage:30.0f rateOfFire:1.0f range:80.0f explosionChance:0.15f explosionDamage:35];
		upgrades[1] = [[VendingUpgrade alloc] initWithCost:155 damage:70.0f rateOfFire:0.7f range:90.0f explosionChance:0.25f explosionDamage:70];
		// set default animation for vending machine
		[self setAni:aniIdle row:0 numFrames:8];
		aniAttack = [[Animation alloc] init];
		[self setAni:aniAttack row:1 numFrames:2 delay:0.1f];
		aniCurrent = aniIdle;
		// set vending machine shoot sound
		shootSoundKey = @"VendingShoot";
		
		towerDescriptionText1 = @"Shoots pop cans";
		towerDescriptionText2 = @"with a chance to";
		towerDescriptionText3 = @"explode on impact";
		
		towerSpecialText1 = @"Explosion";
		towerSpecialText2 = [[NSString alloc] initWithFormat:@"Odds :%.0f%%",[(PopCanFactory*)projectileFactory pcExpChance] * 100.0f];
		towerSpecialText3 = [[NSString alloc] initWithFormat:@"Damage :%.0u",[(PopCanFactory*)projectileFactory pcExpDamage]];
		
		// set default sound to shoot
		objectSound.key = shootSoundKey;
		return self;
	}
	return nil;
}
-(id)initLoadedWithPosition:(Point2D*)p level:(int)l cooldown:(float)c spriteSheet:(SpriteSheet*)ss
{
    if(self = [self initWithPosition:p spriteSheet:ss])
    {
        while(towerLevel < l)
        {
            [upgrades[towerLevel-1] upgradeTower:self];
            ++towerLevel;
        }
        canBeMoved = NO;
        shotCooldownRemain = c;
        return self;
    }
    return nil;
}
-(void)setExpRatio:(float)ratio expDamage:(float)damage
{
	[(PopCanFactory*)projectileFactory setPcExpChance:ratio];
	[(PopCanFactory*)projectileFactory setPcExpDamage:damage];
	[towerSpecialText2 dealloc];
	[towerSpecialText3 dealloc];
	towerSpecialText2 = [[NSString alloc] initWithFormat:@"Odds :%.0f%%",ratio * 100.0f];
	towerSpecialText3 = [[NSString alloc] initWithFormat:@"Damage :%.0f",damage];
}
-(void)dealloc
{
	[towerSpecialText2 dealloc];
	[towerSpecialText3 dealloc];
	[super dealloc];
}

@end

@implementation Freezer

@synthesize freezeDuration;

// private consts
float const FR_ROF = 4.0f;
float const FR_RANGE = 40.0f;

-(id)initWithPosition:(Point2D*)p spriteSheet:(SpriteSheet*)ss
{
	if(self = [super initWithName:@"Freezer" position:p projFactory:nil rateOfFire:FR_ROF range:FR_RANGE cost:FR_COST spriteSheet:ss])
	{
		minimumRound = 5;
		
		// set types
		towerType = GROUND;
		projectileType = FREEZE;
		
		// initialize upgrades
		upgrades[0] = [[FreezerUpgrade alloc] initWithCost:100 damage:0.0f rateOfFire:3.8f range:50.0f freezeDuration:1.2f];
		upgrades[1] = [[FreezerUpgrade alloc] initWithCost:255 damage:0.0f rateOfFire:3.5f range:60.0f freezeDuration:2.2f];
		
		freezeDuration = 0.8f;
		// set default animation for Freezer
		[self setAni:aniIdle row:0 numFrames:16 delay:0.04];
		aniCurrent = aniIdle;
		aniAttack = [[Animation alloc] init];
		[self setAni:aniAttack row:1 numFrames:16 delay:0.05f];
		[aniAttack setRepeat:NO];
		// set shoot sound
		shootSoundKey = @"FreezerShoot";
		
		towerDescriptionText1 = @"Freezes enemies";
		towerDescriptionText2 = @"in place without";
		towerDescriptionText3 = @"doing any damage";
		
		towerSpecialText1 = @"Freezes";
		towerSpecialText2 = @"enemies";
		towerSpecialText3 = [[NSString alloc] initWithFormat:@"for %.1f sec", freezeDuration];
		
		// set default sound to shoot
		objectSound.key = shootSoundKey;
		return self;
	}
	return nil;
}
-(id)initLoadedWithPosition:(Point2D*)p level:(int)l cooldown:(float)c spriteSheet:(SpriteSheet*)ss
{
    if(self = [self initWithPosition:p spriteSheet:ss])
    {
        while(towerLevel < l)
        {
            [upgrades[towerLevel-1] upgradeTower:self];
            ++towerLevel;
        }
        canBeMoved = NO;
        shotCooldownRemain = c;
        return self;
    }
    return nil;
}
-(void)shoot
{
	// create one off freeze particle emitter
	ParticleEmitter *p = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:@"texture.png"
													  position:[[Point2D alloc] initWithX:objectPosition.x y:objectPosition.y]
										sourcePositionVariance:[[Point2D alloc] initWithX:5.0f y:5.0f]
														 speed:90.0f
												 speedVariance:30.0f
											  particleLifeSpan:([self towerRange] / 90.0f)
									  particleLifespanVariance:0.0f
														 angle:0.0f
												 angleVariance:360.0f
													   gravity:nil
													startColor:Color4fMake(0.0f, 0.0f, 0.5f, 1.0f)
											startColorVariance:Color4fMake(0.1f, 0.1f, 0.1f, 0.5f)
												   finishColor:Color4fMake(0.52f, 0.81f, 1.0f, 0.0f) 
										   finishColorVariance:Color4fMake(0.1f, 0.1f, 0.1f, 0.0f)
												  maxParticles:500
												  particleSize:12
										  particleSizeVariance:5
													  duration:0.3f
												 blendAdditive:YES];
	[p release];
	[game freezeEnemiesInRadius:towerRange origin:objectPosition duration:freezeDuration];
    
    towerState = TOWER_STATE_SHOOT;
    if(aniAttack)
    {
        aniCurrent = aniAttack;
        [aniAttack setCurrentFrame:0];
        [aniAttack setRunning:YES];
    }
    lastShotTime = [GameObject getCurrentTime];
    shotCooldownRemain = towerRateOfFire;
    [self playSound];
}
-(BOOL)targetGameObject:(Enemy*)gameObject
{
	// freezers don't target anything, so override and just return yes
	return YES;
}

-(void)setFreezeDuration:(float)d
{
	freezeDuration = d;
	[towerSpecialText3 dealloc];
	towerSpecialText3 = [[NSString alloc] initWithFormat:@"for %.1f sec", freezeDuration];
}
-(void)dealloc
{
	[towerSpecialText3 dealloc];
	[super dealloc];
}

@end

@implementation Matron

// private consts
float const MT_ROF = 1.6f;
float const MT_RANGE = 70.0f;

-(id)initWithPosition:(Point2D*)p spriteSheet:(SpriteSheet*)ss
{
	if(self = [super initWithName:@"Matron" position:p projFactory:[[SlopFactory alloc] init] rateOfFire:MT_ROF range:MT_RANGE cost:MT_COST 
					  spriteSheet:ss])
	{
		// set types
		towerType = AIR;
		projectileType = SLOP;
		
		// initialize upgrades
		upgrades[0] = [[SlopUpgrade alloc] initWithCost:105.0f damage:40.0f rateOfFire:1.4f range:85.0f damageOverTime:10 damageDuration:3.0f];
		upgrades[1] = [[SlopUpgrade alloc] initWithCost:215.0f damage:75.0f rateOfFire:1.0f range:110.0f damageOverTime:20 damageDuration:4.0f];
		
		matronHasShot = NO;
		
		// set default animation for Matron
		[self setAni:aniIdle row:0 numFrames:32 delay:0.03f];
		aniAttack = [[Animation alloc] init];
		[self setAni:aniAttack row:1 numFrames:20 delay:0.02f];
		[aniAttack setRepeat:NO];
		aniCurrent = aniIdle;
		// set shoot sound
		shootSoundKey = @"MatronShoot";
		
		towerDescriptionText1 = @"Does damage over";
		towerDescriptionText2 = @"time and can";
		towerDescriptionText3 = @"target air units";
		
		towerSpecialText1 = [[NSString alloc] initWithFormat:@"+ %u dmg", [(SlopFactory*)projectileFactory spDamageOverTime]];
		towerSpecialText2 = @"per second";
		towerSpecialText3 = [[NSString alloc] initWithFormat:@"for %.1f sec", [(SlopFactory*)projectileFactory spDamageDuration]];
		
		// set default sound to shoot
		objectSound.key = shootSoundKey;
		return self;
	}
	return nil;
}
-(id)initLoadedWithPosition:(Point2D*)p level:(int)l cooldown:(float)c spriteSheet:(SpriteSheet*)ss
{
    if(self = [self initWithPosition:p spriteSheet:ss])
    {
        while(towerLevel < l)
        {
            [upgrades[towerLevel-1] upgradeTower:self];
            ++towerLevel;
        }
        canBeMoved = NO;
        shotCooldownRemain = c;
        return self;
    }
    return nil;
}
-(void)setTimeDamage:(uint)dmg timeDuration:(float)dur
{
	[(SlopFactory*)projectileFactory setSpDamageOverTime:dmg];
	[(SlopFactory*)projectileFactory setSpDamageDuration:dur];
	[towerSpecialText1 dealloc];
	[towerSpecialText3 dealloc];
	towerSpecialText1 = [[NSString alloc] initWithFormat:@"+ %u dmg", dmg];
	towerSpecialText3 = [[NSString alloc] initWithFormat:@"for %.1f sec", dur];
}
-(void)shoot
{
	// override this to trigger shooting animation, release projectile in the middle.
	towerState = TOWER_STATE_SHOOT;
	aniCurrent = aniAttack;
	[aniCurrent setCurrentFrame:0];
	[aniCurrent setRunning:YES];
	lastShotTime = [GameObject getCurrentTime];
    shotCooldownRemain = towerRateOfFire;
	matronHasShot = NO;
}
-(int)update:(float)deltaT
{
	if(towerState == TOWER_STATE_SHOOT)
	{
		if(!matronHasShot && [aniCurrent getCurrentFrameNumber] > (GLuint)((float)[aniCurrent getAnimationFrameCount] * 0.65f))
		{
			[self targetGameObjectNoRetain:[projectileFactory enemyReference]];
			[projectileFactory createProjectile:[[Point2D alloc] initWithX:objectPosition.x y:objectPosition.y] 
								  rotationAngle:[self objectRotationAngle] direction:[self objectDirection]];
			[self playSound];
			matronHasShot = YES;
		}
	}
			
	return [super update:deltaT];
}
-(void)dealloc
{
	[towerSpecialText1 dealloc];
	[towerSpecialText3 dealloc];
	[super dealloc];
}
@end

@implementation CookieLauncher

// private consts
float const CL_ROF = 0.8f;
float const CL_RANGE = 40.0f;

-(id)initWithPosition:(Point2D*)p spriteSheet:(SpriteSheet*)ss
{
	if(self = [super initWithName:@"Cookies" position:p projFactory:[[CookieFactory alloc] init] rateOfFire:CL_ROF range:CL_RANGE cost:CL_COST 
					  spriteSheet:ss])
	{
		// set types
		towerType = GROUND;
		projectileType = COOKIE;
		
		// initialize upgrades
		upgrades[0] = [[CookieUpgrade alloc] initWithCost:100 damage:24.0f rateOfFire:0.8f range:50.0f numDirections:6];
		upgrades[1] = [[CookieUpgrade alloc] initWithCost:225 damage:40.0f rateOfFire:0.7f range:70.0f numDirections:9];
		
		[self setTowerRange:CL_RANGE];
		// set default animation for Cookie Launcher
		[self setAni:aniIdle row:0 numFrames:8 delay:0.05];
		aniAttack = [[Animation alloc] init];
		[self setAni:aniAttack row:1 numFrames:8 delay:0.025f];
        [aniAttack setRepeat:NO];
		aniCurrent = aniIdle;
		// set shoot sound
		shootSoundKey = @"CookieShoot";
		
		towerDescriptionText1 = @"Shoots cookies";
		towerDescriptionText2 = @"in multiple";
		towerDescriptionText3 = @"directions";
		
		towerSpecialText1 = @"Shoots";
		towerSpecialText2 = @"Cookies in";
		towerSpecialText3 = [[NSString alloc] initWithFormat:@"%u directions", [(CookieFactory*)projectileFactory ckNumDirections]];
		
		// set default sound to shoot
		objectSound.key = shootSoundKey;
		return self;
	}
	return nil;
}
-(id)initLoadedWithPosition:(Point2D*)p level:(int)l cooldown:(float)c spriteSheet:(SpriteSheet*)ss
{
    if(self = [self initWithPosition:p spriteSheet:ss])
    {
        while(towerLevel < l)
        {
            [upgrades[towerLevel-1] upgradeTower:self];
            ++towerLevel;
        }
        canBeMoved = NO;
        shotCooldownRemain = c;
        return self;
    }
    return nil;
}

-(BOOL)targetGameObject:(Enemy*)gameObject
{
	// freezers don't target anything, so override and just return yes
	return YES;
}

-(void)setTowerRange:(float)r
{
    [super setTowerRange:r];
    [(CookieFactory*)projectileFactory setTowerRange:towerRange];
}
-(void)setNumDirections:(uint)dirs
{
	[(CookieFactory*)projectileFactory setCkNumDirections:dirs];
	[towerSpecialText3 dealloc];
	towerSpecialText3 = [[NSString alloc] initWithFormat:@"%u directions", dirs];
}
-(void)dealloc
{
	[towerSpecialText3 dealloc];
	[super dealloc];
}

@end

@implementation PieLauncher

// private consts
float const PL_ROF = 2.6f;
float const PL_RANGE = 90.0f;

-(id)initWithPosition:(Point2D*)p spriteSheet:(SpriteSheet*)ss
{
	if(self = [super initWithName:@"Pies" position:p projFactory:[[PieFactory alloc] init] rateOfFire:PL_ROF range:PL_RANGE cost:PL_COST 
					  spriteSheet:ss])
	{
		minimumRound = 15;
		
		// set types
		towerType = GROUND;
		projectileType = PIE;
		
		// initialize upgrades
		upgrades[0] = [[PieUpgrade alloc] initWithCost:195 damage:55.0f rateOfFire:2.3f range:110.0f splashRadius:40 splashDamage:40];
		upgrades[1] = [[PieUpgrade alloc] initWithCost:305 damage:85.0f rateOfFire:1.8f range:140.0f splashRadius:60 splashDamage:75];
		
		// set default animation for Pie Launcher
		[self setAni:aniIdle row:0 numFrames:32 delay:0.03f];
		[aniIdle setPingPong:YES];
		aniAttack = [[Animation alloc] init];
		[self setAni:aniAttack row:1 numFrames:28 delay:0.02f];
		[aniAttack setRepeat:NO];
		aniCurrent = aniIdle;
		// set shoot sound
		shootSoundKey = @"PieShoot";
		
		towerDescriptionText1 = @"Launches pies with";
		towerDescriptionText2 = @"target damage and";
		towerDescriptionText3 = @"splash damage";	
		
		towerSpecialText1 = @"Splash:";
		towerSpecialText2 = [[NSString alloc] initWithFormat:@"%.0f damage", [(PieFactory*)projectileFactory piSplashDamage]];
		towerSpecialText3 = [[NSString alloc] initWithFormat:@"in %.0f radius", [(PieFactory*)projectileFactory piSplashRadius]];
		
		// set default sound to shoot
		objectSound.key = shootSoundKey;
	}
	return self;
}
-(id)initLoadedWithPosition:(Point2D*)p level:(int)l cooldown:(float)c spriteSheet:(SpriteSheet*)ss
{
    if(self = [self initWithPosition:p spriteSheet:ss])
    {
        while(towerLevel < l)
        {
            [upgrades[towerLevel-1] upgradeTower:self];
            ++towerLevel;
        }
        canBeMoved = NO;
        shotCooldownRemain = c;
        return self;
    }
    return nil;
}
-(void)setSplashDamage:(float)damage splashRadius:(float)radius
{
	[(PieFactory*)projectileFactory setPiSplashDamage:damage];
	[(PieFactory*)projectileFactory setPiSplashRadius:radius];
	[towerSpecialText2 dealloc];
	[towerSpecialText3 dealloc];
	towerSpecialText2 = [[NSString alloc] initWithFormat:@"%.0f damage", damage];
	towerSpecialText3 = [[NSString alloc] initWithFormat:@"in %.0f radius", radius];
}
-(void)dealloc
{
	[towerSpecialText2 dealloc];
	[towerSpecialText3 dealloc];
	[super dealloc];
}

@end

@implementation PopcornMachine

// private consts
float const PF_ROF = 1.6f;
float const PF_RANGE = 75.0f;
float const PF_KERNEL_DELAY = 0.05f;
uint const PF_KERNEL_MAX_COUNT = 3;

-(id)initWithPosition:(Point2D*)p spriteSheet:(SpriteSheet*)ss
{
	if(self = [super initWithName:@"Popcorn" position:p projFactory:[[KernelFactory alloc] init] rateOfFire:PF_ROF range:PF_RANGE cost:PM_COST 
					  spriteSheet:ss])
	{
		minimumRound = 10;
		
		// set types
		towerType = AIR;
		projectileType = KERNEL;
		
		kernelCounter = 0;
		kernelLastShotTime = 0.0f;
		
		// set default animation for Popcorn Machine
		[self setAni:aniIdle row:0 numFrames:32 delay:0.03f];
		aniAttack = [[Animation alloc] init];
		[self setAni:aniAttack row:1 numFrames:16 delay:0.04f];
		[aniAttack setRepeat:NO];
		aniCurrent = aniIdle;
		
		// initialize upgrades
		upgrades[0] = [[PopcornUpgrade alloc] initWithCost:160 damage:3 rateOfFire:1.4f range:85.0f delayDamage:95.0f delayTime:2.0f];
		upgrades[1] = [[PopcornUpgrade alloc] initWithCost:260 damage:5 rateOfFire:1.0f range:100.0f delayDamage:130.0f delayTime:1.4f];
		
		towerDescriptionText1 = @"Shoots kernels";
		towerDescriptionText2 = @"with a powerful";
		towerDescriptionText3 = @"delayed explosion";
		
		towerSpecialText1 = [[NSString alloc] initWithFormat:@"%.0f dmg", [(KernelFactory*)projectileFactory kDelayDamage]];
		towerSpecialText2 = @"after delay";
		towerSpecialText3 = [[NSString alloc] initWithFormat:@"of %.1f sec", [(KernelFactory*)projectileFactory kDelayTime]];
		
		// set shoot sound
		shootSoundKey = @"PopcornShoot";
		
		// set default sound to shoot
		objectSound.key = shootSoundKey;
		objectSound.gain = 0.6f;
	}
	return self;
}
-(id)initLoadedWithPosition:(Point2D*)p level:(int)l cooldown:(float)c spriteSheet:(SpriteSheet*)ss
{
    if(self = [self initWithPosition:p spriteSheet:ss])
    {
        while(towerLevel < l)
        {
            [upgrades[towerLevel-1] upgradeTower:self];
            ++towerLevel;
        }
        shotCooldownRemain = c;
        canBeMoved = NO;
        return self;
    }
    return nil;
}
-(void)shoot
{
	towerState = TOWER_STATE_SHOOT;
	if(aniAttack)
	{
		aniCurrent = aniAttack;
		[aniAttack setCurrentFrame:0];
		[aniAttack setRunning:YES];
		kernelCounter = 0;
	}
	lastShotTime = [GameObject getCurrentTime];
    shotCooldownRemain = towerRateOfFire;
}
-(int)update:(float)deltaT
{
	if(towerState == TOWER_STATE_SHOOT && kernelCounter < PF_KERNEL_MAX_COUNT && kernelLastShotTime+PF_KERNEL_DELAY < [GameObject getCurrentTime])
	{
		BOOL explodeFlag = (kernelCounter == 0);
        BOOL releaseFlag = (kernelCounter == PF_KERNEL_MAX_COUNT-1);

		[(KernelFactory*)projectileFactory createProjectile:[[Point2D alloc] initWithX:objectPosition.x y:objectPosition.y]
                                              rotationAngle:[self objectRotationAngle] direction:[self objectDirection] shouldExplode:explodeFlag shouldRelease:releaseFlag];
		[self playSound];
		++kernelCounter;
		kernelLastShotTime = [GameObject getCurrentTime];
	}
	return [super update:deltaT];
}
-(void)setDelayDamage:(float)damage delayTime:(float)time
{
	[(KernelFactory*)projectileFactory setKDelayDamage:damage];
	[(KernelFactory*)projectileFactory setKDelayTime:time];
	[towerSpecialText1 dealloc];
	[towerSpecialText3 dealloc];
	towerSpecialText1 = [[NSString alloc] initWithFormat:@"%.0f damage", damage];
	towerSpecialText3 = [[NSString alloc] initWithFormat:@"%.1f seconds", time];
}
-(void)dealloc
{
	[towerSpecialText1 dealloc];
	[towerSpecialText3 dealloc];
	[super dealloc];
}

@end

@interface Register()

-(void)drawRegisterRadius;

@end

@implementation Register

const float registerDeltaRadius = 20.0f;
const float RADIAL_MAX_ALPHA = 0.35f;

-(id)initWithPosition:(Point2D*)p spriteSheet:(SpriteSheet*)ss
{
	if(self = [super initWithName:@"Register" position:p projFactory:nil rateOfFire:0.0f range:RG_RANGE cost:RG_COST spriteSheet:ss])
	{
		minimumRound = 20;
		
		touchMan = [TouchManager getInstance];
		
		// set radius intervals
		radius1 = 0.33f * towerRange;
		radius2 = 0.66f * towerRange;
		radius3 = towerRange;
		
		registerRadialRGBA1[0] = registerRadialRGBA2[0] = registerRadialRGBA3[0] = 1.0f;
		registerRadialRGBA1[1] = registerRadialRGBA2[1] = registerRadialRGBA3[1] = 0.8f;
		registerRadialRGBA1[2] = registerRadialRGBA2[2] = registerRadialRGBA3[2] = 0.0f;
		registerRadialRGBA1[3] = registerRadialRGBA2[3] = registerRadialRGBA3[3] = RADIAL_MAX_ALPHA;
		
		// set types
		towerType = NONE;
		projectileType = NONE;
		
		// set default animation for Cash Register
		[self setAni:aniIdle row:0 numFrames:32 delay:0.03f];
		aniCurrent = aniIdle;
		
		towerDescriptionText1 = @"Provides boosts";
		towerDescriptionText2 = @"to any towers";
		towerDescriptionText3 = @"within it's radius";
		
		towerSpecialText1 = [[NSString alloc] initWithFormat:@"+ %.1f%%",RG_DAMAGE_BOOST * 100.0f];
		towerSpecialText2 = [[NSString alloc] initWithFormat:@"+ %.1f%%",RG_RANGE_BOOST * 100.0f];
		towerSpecialText3 = [[NSString alloc] initWithFormat:@"+ %.1f%%",RG_ROF_BOOST * 100.0f];
	}
	return self;
}
-(id)initLoadedWithPosition:(Point2D*)p level:(int)l cooldown:(float)c spriteSheet:(SpriteSheet*)ss
{
    if(self = [self initWithPosition:p spriteSheet:ss])
    {
        while(towerLevel < l)
        {
            [upgrades[towerLevel-1] upgradeTower:self];
            ++towerLevel;
        }
        canBeMoved = NO;
        shotCooldownRemain = c;
        return self;
    }
    return nil;
}-(BOOL)isTouchedAtPoint:(CGPoint)p
{
	BOOL returnVal = [super isTouchedAtPoint:p];
	if(![touchMan towerIsBeingPlaced] && !returnVal)
	{
		// reset radius intervals to ensure they stay the same distance apart
		radius1 = 0.33f * towerRange;
		radius2 = 0.66f * towerRange;
		radius3 = towerRange;
		return NO;
	}
	return returnVal;
}
-(int)update:(float)deltaT
{
	if([self canBeMoved])
		[game showBoostForTowersFromPoint:objectPosition];
	
	radius1 += registerDeltaRadius * deltaT;
	radius2 += registerDeltaRadius * deltaT;
	radius3 += registerDeltaRadius * deltaT;
	
	if(radius1 > towerRange)
		radius1 = 0.0f;
	else if(radius2 > towerRange)
		radius2 = 0.0f;
	else if(radius3 > towerRange)
		radius3 = 0.0f;
	
	if(selected)
		[[[UIManager getInstance] getTowerStatBarReference] updateReloadBar:0.0f];
	
	[aniCurrent update:deltaT];
	return 0;
}
-(void)drawRegisterRadius
{
    registerRadialRGBA1[3] = RADIAL_MAX_ALPHA * (1.0f - radius1/towerRange);
    registerRadialRGBA2[3] = RADIAL_MAX_ALPHA * (1.0f - radius2/towerRange);
    registerRadialRGBA3[3] = RADIAL_MAX_ALPHA * (1.0f - radius3/towerRange);
	for (int i = 0; i < 720; i+=2) 
	{
		registerRadial1[i] = cos([Math convertToRadians:i]) * radius1;
		registerRadial1[i+1] = sin([Math convertToRadians:i]) * radius1;
		
		registerRadial2[i] = cos([Math convertToRadians:i]) * radius2;
		registerRadial2[i+1] = sin([Math convertToRadians:i]) * radius2;
		
		registerRadial3[i] = cos([Math convertToRadians:i]) * radius3;
		registerRadial3[i+1] = sin([Math convertToRadians:i]) * radius3;
	}
	
	glPushMatrix();
	glEnable(GL_BLEND);
	glEnableClientState(GL_VERTEX_ARRAY);
	glTranslatef(objectPosition.x, objectPosition.y, 0.0f);
	glColor4f(registerRadialRGBA1[0],registerRadialRGBA1[1],registerRadialRGBA1[2],registerRadialRGBA1[3]);
	glVertexPointer(2, GL_FLOAT, 0, registerRadial1);
	glDrawArrays(GL_TRIANGLE_FAN, 0, 360);
	glColor4f(registerRadialRGBA2[0],registerRadialRGBA2[1],registerRadialRGBA2[2],registerRadialRGBA2[3]);
	glVertexPointer(2, GL_FLOAT, 0, registerRadial2);
	glDrawArrays(GL_TRIANGLE_FAN, 0, 360);
	glColor4f(registerRadialRGBA3[0],registerRadialRGBA3[1],registerRadialRGBA3[2],registerRadialRGBA3[3]);
	glVertexPointer(2, GL_FLOAT, 0, registerRadial3);
	glDrawArrays(GL_TRIANGLE_FAN, 0, 360);
	glDisable(GL_BLEND);
	glDisableClientState(GL_VERTEX_ARRAY);
	glPopMatrix();
}
-(int)draw
{
	if(selected || [touchMan towerIsBeingPlaced])
		[self drawRegisterRadius];
	
	[aniCurrent renderAtPoint:CGPointMake(objectPosition.x,objectPosition.y)];
	[aniCurrent setRotationAngle:objectRotationAngle];
	[aniCurrent setScale:objectScale];
	return 0;
}
-(void)lock
{
	[game applyBoostForTowersFromPoint:objectPosition];
	[super lock];
}
-(void)dealloc
{
	[towerSpecialText1 dealloc];
	[towerSpecialText2 dealloc];
	[towerSpecialText3 dealloc];
	[game removeBoostForTowersFromPoint:objectPosition];
	[super dealloc];
}

@end

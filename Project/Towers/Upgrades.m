//
//  Upgrade.m
//  towerDefense
//
//  Created by Joey Manso on 9/9/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Upgrades.h"
#import	"Towers.h"

@implementation Upgrade

@synthesize upgradeCost;
@synthesize upgradeRange;

-(id)initWithCost:(uint)c damage:(float)d rateOfFire:(float)rof range:(float)r
{
	if(self = [super init])
	{
		upgradeCost = c;
		upgradeDamage = d;
		upgradeRateOfFire = rof;
		upgradeRange = r;
	}
	return self;
}
-(void)upgradeTower:(Tower*)t
{
	[t setTowerDamage:upgradeDamage];
	[t setTowerRateOfFire:upgradeRateOfFire];
	[t setTowerRange:upgradeRange];
}
@end

@implementation VendingUpgrade
-(id)initWithCost:(uint)c damage:(float)d rateOfFire:(float)rof range:(float)r explosionChance:(float)expChance explosionDamage:(uint)expDmg
{
	if(self = [super initWithCost:c damage:d rateOfFire:rof range:r])
	{
		upgradeExpChance = expChance;
		upgradeExpDamage = expDmg;
	}
	return self;
}
-(void)upgradeTower:(Tower*)t
{
	[super upgradeTower:t];
	[(VendingMachine*)t setExpRatio:upgradeExpChance expDamage:upgradeExpDamage];
}
@end

@implementation FreezerUpgrade
-(id)initWithCost:(uint)c damage:(float)d rateOfFire:(float)rof range:(float)r freezeDuration:(uint)freeze
{
	if(self = [super initWithCost:c damage:d rateOfFire:rof range:r])
		upgradeFreezeDuration = freeze;
	return self;
}
-(void)upgradeTower:(Tower*)t
{
	[super upgradeTower:t];
	[(Freezer*)t setFreezeDuration:upgradeFreezeDuration];
}
@end

@implementation SlopUpgrade
-(id)initWithCost:(uint)c damage:(float)d rateOfFire:(float)rof range:(float)r damageOverTime:(uint)damage damageDuration:(float)damageDur
{
	if(self = [super initWithCost:c damage:d rateOfFire:rof range:r])
	{
		upgradeDamageOverTime = damage;
		upgradeDamageDuration = damageDur;
	}
	return self;
}
-(void)upgradeTower:(Tower*)t
{
	[super upgradeTower:t];
	[(Matron*)t setTimeDamage:upgradeDamageOverTime timeDuration:upgradeDamageDuration];
}
@end

@implementation CookieUpgrade
-(id)initWithCost:(uint)c damage:(float)d rateOfFire:(float)rof range:(float)r numDirections:(uint)dirs
{
	if(self = [super initWithCost:c damage:d rateOfFire:rof range:r])
		upgradeNumDirections = dirs;
	return self;
}
-(void)upgradeTower:(Tower*)t
{
	[super upgradeTower:t];
	[(CookieLauncher*)t setNumDirections:upgradeNumDirections];
}
@end

@implementation PieUpgrade
-(id)initWithCost:(uint)c damage:(float)d rateOfFire:(float)rof range:(float)r splashRadius:(float)splashR splashDamage:(float)splashD
{
	if(self = [super initWithCost:c damage:d rateOfFire:rof range:r])
	{
		upgradeSplashRadius = splashR;
		upgradeSplashDamage = splashD;
	}
	return self;
}
-(void)upgradeTower:(Tower*)t
{
	[super upgradeTower:t];
	[(PieLauncher*)t setSplashDamage:upgradeSplashDamage splashRadius:upgradeSplashRadius];
}
@end

@implementation PopcornUpgrade
-(id)initWithCost:(uint)c damage:(float)d rateOfFire:(float)rof range:(float)r delayDamage:(float)delayD delayTime:(float)delayT
{
	if(self = [super initWithCost:c damage:d rateOfFire:rof range:r])
	{
		upgradeDelayDamage = delayD;
		upgradeDelayTime = delayT;
	}
	return self;
}
-(void)upgradeTower:(Tower*)t
{
	[super upgradeTower:t];
	[(PopcornMachine*)t setDelayDamage:upgradeDelayDamage delayTime:upgradeDelayTime];
}
@end



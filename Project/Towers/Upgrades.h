//
//  Upgrades.h
//  towerDefense
//
//  Created by Joey Manso on 9/9/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Tower;

@interface Upgrade : NSObject 
{
@private
	uint upgradeCost;
	float upgradeDamage;
	float upgradeRateOfFire;
	float upgradeRange;
}
@property(nonatomic,readonly)uint upgradeCost;
@property(nonatomic,readonly)float upgradeRange;
-(id)initWithCost:(uint)c damage:(float)d rateOfFire:(float)rof range:(float)r;
-(void)upgradeTower:(Tower*)t;
@end

@interface VendingUpgrade : Upgrade 
{
	float upgradeExpChance;
	uint upgradeExpDamage;
}
-(id)initWithCost:(uint)c damage:(float)d rateOfFire:(float)rof range:(float)r explosionChance:(float)expChance explosionDamage:(uint)expDmg;

@end

@interface FreezerUpgrade : Upgrade  
{
	float upgradeFreezeDuration;
}
-(id)initWithCost:(uint)c damage:(float)d rateOfFire:(float)rof range:(float)r freezeDuration:(uint)freeze;

@end

@interface SlopUpgrade : Upgrade  
{
	uint upgradeDamageOverTime;
	float upgradeDamageDuration;
}
-(id)initWithCost:(uint)c damage:(float)d rateOfFire:(float)rof range:(float)r damageOverTime:(uint)damage damageDuration:(float)damageDur;

@end

@interface CookieUpgrade : Upgrade  
{
	uint upgradeNumDirections;
}
-(id)initWithCost:(uint)c damage:(float)d rateOfFire:(float)rof range:(float)r numDirections:(uint)dirs;

@end

@interface PieUpgrade : Upgrade  
{
	float upgradeSplashRadius;
	float upgradeSplashDamage;
}
-(id)initWithCost:(uint)c damage:(float)d rateOfFire:(float)rof range:(float)r splashRadius:(float)splashR splashDamage:(float)splashD;

@end

@interface PopcornUpgrade : Upgrade  
{
	float upgradeDelayDamage;
	float upgradeDelayTime;
}
-(id)initWithCost:(uint)c damage:(float)d rateOfFire:(float)rof range:(float)r delayDamage:(float)delayD delayTime:(float)delayT;

@end



//
//  ProjectileFactory.h
//  towerDefense
//
//  Created by Joey Manso on 7/25/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Projectile.h"

@interface ProjectileFactory : NSObject 
{
	uint projDamage;
	float projSpeed;
	Image *projectileImage;
	Enemy *enemyReference;
	
	@protected
	uint baseProjDamage;
	float baseProjSpeed;
}
@property(nonatomic)uint projDamage;
@property(nonatomic, readonly)float projSpeed;
@property(nonatomic, readonly)Enemy *enemyReference;

-(id)initWithBaseDamage:(uint)baseD baseSpeed:(float)baseS;
-(BOOL)setTargettedEnemy:(Enemy*)enemy;
-(void)assignTargettedEnemy:(Projectile*)p;
-(void)createProjectile:(Point2D*)p rotationAngle:(float)rot direction:(Vector2D*)dir;

@end

@interface PopCanFactory : ProjectileFactory 
{
	float pcExpChance;
	uint pcExpDamage;
}
@property(nonatomic)float pcExpChance;
@property(nonatomic)uint pcExpDamage;

@end

@interface SlopFactory : ProjectileFactory 
{
	uint spDamageOverTime;
	float spDamageDuration;
}
@property(nonatomic)uint spDamageOverTime;
@property(nonatomic)float spDamageDuration;

@end

@interface CookieFactory : ProjectileFactory 
{
	float towerRange;
	uint ckNumDirections;
}
@property(nonatomic)float towerRange;
@property(nonatomic)uint ckNumDirections;

@end

@interface PieFactory : ProjectileFactory 
{
	float piSplashRadius;
	float piSplashDamage;
}
@property(nonatomic)float piSplashRadius;
@property(nonatomic)float piSplashDamage;

@end

@interface KernelFactory : ProjectileFactory 
{
	float kDelayDamage;
	float kDelayTime;
}
-(void)createProjectile:(Point2D*)p rotationAngle:(float)rot direction:(Vector2D*)dir shouldExplode:(BOOL)explode shouldRelease:(BOOL)release;
@property(nonatomic)float kDelayDamage;
@property(nonatomic)float kDelayTime;

@end

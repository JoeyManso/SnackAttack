//
//  ProjectileFactory.m
//  towerDefense
//
//  Created by Joey Manso on 7/25/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ProjectileFactory.h"

// import all specific projectiles so they're not all over the place!
#import "Projectiles.h"

@implementation ProjectileFactory

@synthesize projDamage;
@synthesize projSpeed;
@synthesize enemyReference;

-(id)initWithBaseDamage:(uint)baseD baseSpeed:(float)baseS
{
	if(self = [super init])
	{
		baseProjDamage = projDamage = baseD;
		baseProjSpeed = projSpeed = baseS;
	}
	return self;
}
-(void)createProjectile:(Point2D*)p rotationAngle:(float)rot direction:(Vector2D*)dir
{
	// don't ever call this!
}
-(BOOL)setTargettedEnemy:(Enemy*)enemy
{
	if(![enemy markedForRemoval] && [enemy enemyHitPoints] > 0.5f)
	{
		enemyReference = enemy;
		[enemyReference retain];
		return YES;
	}
	return NO;
}
-(void)setProjDamage:(uint)d
{
	projDamage = d;
}
-(void)dealloc
{
	if(projectileImage)
		[projectileImage release];
	[super dealloc];
}

@end

@implementation PopCanFactory

float const PC_BASE_EXP_CHANCE = 0.1f;
uint const PC_BASE_EXP_DAMAGE = 20;

@synthesize pcExpChance;
@synthesize pcExpDamage;

-(id)init
{
	if(self = [super initWithBaseDamage:15 baseSpeed:150.0f])
	{
		if(!projectileImage)
			projectileImage = [[Image alloc] initWithImage:[UIImage imageNamed:@"PopCan.png"] filter:GL_LINEAR];
		pcExpChance = PC_BASE_EXP_CHANCE;
		pcExpDamage = PC_BASE_EXP_DAMAGE;
	}
	return self;
}
-(void)createProjectile:(Point2D*)p rotationAngle:(float)rot direction:(Vector2D*)dir
{
	PopCan *pop = [[PopCan alloc] initWithPosition:p image:projectileImage damage:(float)projDamage speed:projSpeed expChance:pcExpChance expDamage:pcExpDamage];
	// set the direction (by value to avoid resetting the rotation angle)
	[pop setObjectDirectionX:dir.x y:dir.y];
	
	// add a reference to the target enemy and release the reference
	[pop setTarget:enemyReference];
	[enemyReference release];
	
	// release our reference to this object
	[pop release];
}

@end

@implementation SlopFactory

const uint SP_BASE_TIME_DAMAGE = 7; // how much damage is applied, per second
const float SP_BASE_DAMAGE_DURATION = 3.0; // how much time the damage occurs for

@synthesize spDamageOverTime;
@synthesize spDamageDuration;

-(id)init
{
	if(self = [super initWithBaseDamage:25 baseSpeed:135.0f])
	{
		spDamageOverTime = SP_BASE_TIME_DAMAGE;
		spDamageDuration = SP_BASE_DAMAGE_DURATION;
	}
	return self;
}
-(void)createProjectile:(Point2D*)p rotationAngle:(float)rot direction:(Vector2D*)dir
{
	Slop *s = [[Slop alloc] initWithPosition:p damage:(float)projDamage speed:projSpeed damagePerSec:spDamageOverTime damageDuration:spDamageDuration];
	[s setObjectRotationAngle:rot];
	Vector2D *rightVec = [[Vector2D alloc] initWithX:dir.y y:-dir.x];
	[[s objectPosition] updateWithVector2D:rightVec speed:5.0f deltaT:1.0f];
	[rightVec dealloc];
	
	// set the direction (by value to avoid resetting the rotation angle)
	[s setObjectDirectionX:dir.x y:dir.y];
	
	// add a reference to the target enemy and then release the reference
	[s setTarget:enemyReference];
	[enemyReference release];
	
	// release our reference to this object
	[s release];
}

@end

@implementation CookieFactory

float const CK_BASE_SPEED = 150.0f;
uint const CK_BASE_NUM_DIRECTIONS = 5;

@synthesize towerRange;
@synthesize ckNumDirections;

-(id)init
{
	if(self = [super initWithBaseDamage:15 baseSpeed:150.0f])
	{
		if(!projectileImage)
			projectileImage = [[Image alloc] initWithImage:[UIImage imageNamed:@"Cookie.png"] filter:GL_LINEAR];
		ckNumDirections = CK_BASE_NUM_DIRECTIONS;
		towerRange = 0.0f;
	}
	return self;
}
-(void)createProjectile:(Point2D*)p rotationAngle:(float)rot direction:(Vector2D*)dir
{
	Cookie *c;
	float angle; // angle in radians that the cookie will move towards
	
	for(uint i=0;i<ckNumDirections;++i)
	{
		angle = [Math convertToRadians:((float)i/(float)ckNumDirections) * 360.0f];
		c = [[Cookie alloc] initWithPosition:[[Point2D alloc] initWithX:p.x y:p.y] image:projectileImage 
									  damage:(float)projDamage speed:projSpeed range:towerRange];
		[c setObjectDirectionX:sin(angle) y:cos(angle)];
		// release our reference to this object
		[c release];
	}
	// deallocate the passed point		 
    [p dealloc];
}

@end

@implementation PieFactory

float const PI_BASE_SPLASH_RADIUS = 20.0f;
float const PI_BASE_SPLASH_DAMAGE = 20.0f;

@synthesize piSplashRadius;
@synthesize piSplashDamage;

-(id)init
{
	if(self = [super initWithBaseDamage:35 baseSpeed:130.0f])
	{
		if(!projectileImage)
			projectileImage = [[Image alloc] initWithImage:[UIImage imageNamed:@"Pie.png"] filter:GL_LINEAR];
		piSplashRadius = PI_BASE_SPLASH_RADIUS;
		piSplashDamage = PI_BASE_SPLASH_DAMAGE;
	}
	return self;
}
-(void)createProjectile:(Point2D*)p rotationAngle:(float)rot direction:(Vector2D*)dir
{
	Pie *pie = [[Pie alloc] initWithPosition:p image:projectileImage damage:(float)projDamage speed:projSpeed
							   splashRange:piSplashRadius splashDamage:piSplashDamage];
	
	// set the direction (by value to avoid resetting the rotation angle)
	[pie setObjectDirectionX:dir.x y:dir.y];
	
	// add a reference to the target enemy and release the reference
	[pie setTarget:enemyReference];
	[enemyReference release];
	// release our reference to this object
	[pie release];
}

@end

@implementation KernelFactory

float const K_BASE_DELAY_DAMAGE = 70.0f;
float const K_BASE_DELAY_TIME = 2.4f;

@synthesize kDelayDamage;
@synthesize kDelayTime;

-(id)init
{
	if(self = [super initWithBaseDamage:2 baseSpeed:200.0f])
	{
		if(!projectileImage)
			projectileImage = [[Image alloc] initWithImage:[UIImage imageNamed:@"Kernel.png"] filter:GL_LINEAR];
		kDelayDamage = K_BASE_DELAY_DAMAGE;
		kDelayTime = K_BASE_DELAY_TIME;
	}
	return self;
}
-(void)createProjectile:(Point2D*)p rotationAngle:(float)rot direction:(Vector2D*)dir shouldExplode:(BOOL)explode
{
	Kernel *k;
	if(explode)
	{
		k = [[Kernel alloc] initWithPosition:p image:projectileImage damage:(float)projDamage speed:projSpeed delayDamage:kDelayDamage delayTime:kDelayTime];
		[k setTarget:enemyReference];
		// release the reference to the enemy and set to each kernel (below)
		[enemyReference release];
	}
	else
	{
		k = [[Kernel alloc] initWithPosition:p image:projectileImage damage:(float)projDamage speed:projSpeed delayDamage:0.0f delayTime:0.0f];
		[k setTarget:enemyReference];
	}
	// set the direction (by value to avoid resetting the rotation angle)
	[k setObjectDirectionX:dir.x y:dir.y];
	
	// release our reference to this object
	[k release];
}

@end


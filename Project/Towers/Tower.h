//
//  Tower.h
//  towerDefense
//
//  Created by Joey Manso on 7/5/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameState.h"
#import "AnimationObject.h"
#import "ProjectileFactory.h"
#import "Upgrades.h"
#import "UIManager.h"
#import "UIBars.h"

#define MAX_TOWER_LEVEL 3

// global Register Consts
#define RG_RANGE 110.0f
#define RG_ROF_BOOST 0.15f
#define RG_RANGE_BOOST 0.1f
#define RG_DAMAGE_BOOST 0.25f

// tower state
enum
{
	TOWER_STATE_IDLE,
	TOWER_STATE_SHOOT
};

@interface Tower : AnimationObject 
{	
	GameState *game; // game manager reference
	
	uint towerLevel; // current level of the tower (starts at 1, max is 3)
	float towerRateOfFire; // amount of time in seconds between shots
	float towerRange; // radius of shooting in units
	int towerCost;
	uint towerValue; // total amount invested in the tower (cost + upgrades)
	Upgrade* upgrades[MAX_TOWER_LEVEL]; // array of upgrade (defaults to nil for each entry)
	
	// this text is used to show tower description before purchase
	NSString *towerDescriptionText1;
	NSString *towerDescriptionText2;
	NSString *towerDescriptionText3;
	
	// this text is used to show tower stats
	NSString *towerSpecialText1;
	NSString *towerSpecialText2;
	NSString *towerSpecialText3;
	
	float lastShotTime; // time the tower last shot something
    float shotCooldownRemain;
	
	ProjectileFactory *projectileFactory; // spawns all projectiles
	float const valuePercent; // percent of total cost that a tower is worth for selling
	
	NSString *shootSoundKey;
	
@private
	BOOL isInBoostRadius; // flag for display purposes if a tower is within the Register's area of effect
	float boostRadius;
	float radiusPulseAddition;
    float pulseDir;
	float boostPulseAddition;
	GLfloat radiusRGBA[4];
	GLfloat radiusVertices[720];
    
    GLfloat radiusUpgradesRGBA[4];
    GLfloat radiusUpgradesVertices[MAX_TOWER_LEVEL-1][724];
	
	GLfloat boostRGBA[4];
	GLfloat boostVertices[720];
	
	float boostDamagePercent;
	float boostRangePercent;
	float boostRateOfFirePercent;
    
    TowerStatus *towerStatusBar;
    UIManager *UIMan;
	
@protected
	Animation *aniIdle;
	Animation *aniAttack;
	
	uint towerState;
	uint towerType;
	uint projectileType;
	uint minimumRound; //minimum round this tower can be bought at
	
	float towerBaseDamage;
	float towerBaseRateOfFire;
	float towerBaseRange;
}
@property(nonatomic, readonly)uint towerLevel;
@property(nonatomic)float towerRateOfFire;
@property(nonatomic)float towerRange;
@property(nonatomic, readonly)int towerCost;
@property(nonatomic, readonly)NSString *towerDescriptionText1;
@property(nonatomic, readonly)NSString *towerDescriptionText2;
@property(nonatomic, readonly)NSString *towerDescriptionText3;
@property(nonatomic, readonly)float lastShotTime;
@property(nonatomic, readonly)float shotCooldownRemain;
@property(nonatomic, readonly)uint towerType;
@property(nonatomic, readonly)uint projectileType;
@property(nonatomic)BOOL isInBoostRadius;
@property(nonatomic, readonly)uint minimumRound;

-(id)initWithName:(NSString*)n position:(Point2D*)p projFactory:(ProjectileFactory*)pf rateOfFire:(float)rof range:(float)r cost:(int)c spriteSheet:(SpriteSheet*)ss;

-(uint)towerDamage;
-(void)setTowerDamage:(uint)d;
-(BOOL)targetGameObject:(Enemy*)gameObject;
-(void)targetGameObjectNoRetain:(Enemy*)gameObject;
-(BOOL)canShoot;
-(float)towerMaxUpgradeRange;
-(void)lock;
-(void)overInvalidArea;
-(void)overValidArea;
-(void)shoot;
-(void)applyBoostDamage;
-(void)removeBoost;
-(void)upgrade;
-(void)sell;

@end

//
//  tower.m
//  towerDefense
//
//  Created by Joey Manso on 7/5/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Tower.h"

// private stuff
@interface Tower()

-(float)getBaseDisplayRange;
-(void)displayRange;
-(void)displayRangeUpgrades;
-(void)displayBoost;
-(void)updateStatsBar;
@end

@implementation Tower

@synthesize towerLevel;
@synthesize towerRateOfFire;
@synthesize towerRange;
@synthesize towerCost;
@synthesize towerDescriptionText1;
@synthesize towerDescriptionText2;
@synthesize towerDescriptionText3;
@synthesize lastShotTime;
@synthesize shotCooldownRemain;
@synthesize towerType;
@synthesize projectileType;
@synthesize isInBoostRadius;
@synthesize minimumRound;

float const SELL_PERCENT = 0.5f;

-(id)init
{
	return [self initWithName:nil position:nil projFactory:nil rateOfFire:0 range:0 cost:0 spriteSheet:nil];
}
-(id)initWithName:(NSString*)n position:(Point2D*)p projFactory:(ProjectileFactory*)pf rateOfFire:(float)rof range:(float)r cost:(int)c spriteSheet:(SpriteSheet*)ss
{
	// make sure we initialize the super class
	if (self = [super initWithName:n position:p spriteSheet:ss])
	{
		UIMan = [UIManager getInstance];
		towerStatusBar = [UIMan getTowerStatBarReference];
		game = [GameState sharedGameStateInstance];
		towerState = TOWER_STATE_IDLE;
		
		towerType = 99;
		projectileType = 99;
		
		projectileFactory = pf;
		towerBaseDamage = [self towerDamage];
		towerBaseRateOfFire = towerRateOfFire = rof;
		towerBaseRange = towerRange = r;
		towerCost = c;
		towerValue = c;
		towerLevel = 1;
		boostDamagePercent = boostRangePercent = boostRateOfFirePercent = 0.0f;
		minimumRound = 0;
		
		for(uint i=0; i<MAX_TOWER_LEVEL; ++i)
			upgrades[i]=nil;
		
		lastShotTime = 0.0f;
        shotCooldownRemain = 0.0f;
		canBeMoved = YES;
		isInBoostRadius = NO;
		
		// for range pulsing effect
        radiusPulseAddition = 0.0f;
        pulseDir = 1.0f;
        
		boostRadius = [spriteSheet spriteWidth] * 0.7f;
		
		radiusRGBA[0] = 0.1f;
		radiusRGBA[1] = 0.1f;
		radiusRGBA[2] = 0.55f;
		radiusRGBA[3] = 0.25f;
        
        radiusUpgradesRGBA[0] = 0.1f;
        radiusUpgradesRGBA[1] = 0.1f;
        radiusUpgradesRGBA[2] = 0.1f;
        radiusUpgradesRGBA[3] = 0.2f;
		
		boostRGBA[0] = 1.0f;
		boostRGBA[1] = 0.8f;
		boostRGBA[2] = 0.0f;
		boostRGBA[3] = 0.35f;
		
		shootSoundKey = nil;
		
		// we will definitely have an idle animation, we might not have an attack animation
		aniIdle = [[Animation alloc] init];
		aniAttack = nil;
	}
	return self;
}
-(uint)towerDamage
{
	if(projectileFactory)
		return [projectileFactory projDamage];
	return 0;
}
-(void)setTowerDamage:(uint)d
{
	towerBaseDamage = d;
	if(isInBoostRadius)
		d+=d*boostDamagePercent;
	if(projectileFactory)
		[projectileFactory setProjDamage:d];
}
-(void)setTowerRange:(float)r
{
	// for range pulsing effect
	towerBaseRange = towerRange = r;
	if(isInBoostRadius)
    {
		towerRange+=towerRange*boostRangePercent;
    }
}
-(void)setTowerRateOfFire:(float)rof
{
	towerBaseRateOfFire = rof;
	if(isInBoostRadius)
		rof-=rof*boostRateOfFirePercent;
	towerRateOfFire = rof;
}
-(void)targetGameObjectNoRetain:(Enemy*)gameObject
{
	// direction we want to face, subtract our position from the target
	Vector2D* newDir = [Point2D subtract:gameObject.objectPosition :objectPosition];
	
	// rotate our sprite angle in degrees
	float dot = [Vector2D dot:objectDirection :newDir];
	float angle = [Math convertToDegrees:acos(dot)];
	// i think this is a hack
	if(dot < 0.0f || gameObject.objectDirection.x > gameObject.objectDirection.y)
		angle*=-1;
	
	[self setObjectRotationAngle:[self objectRotationAngle] + angle];
	
	// set our new vector
	[self setObjectDirection:newDir];
	
	// deallocate the new direction we created
	[newDir dealloc];
}
-(BOOL)targetGameObject:(Enemy*)gameObject
{
	// give our projectile factory a reference to the enemy
	if([projectileFactory setTargettedEnemy:gameObject])
	{
		[self targetGameObjectNoRetain:gameObject];
		return YES;
	}
	return NO;
}

-(BOOL)canShoot
{
	return !canBeMoved && shotCooldownRemain <= 0.0f;
}
-(float)towerMaxUpgradeRange
{
    float maxUpgradeRange = towerRange;
    for(int i = 0; i < MAX_TOWER_LEVEL; ++i)
    {
        Upgrade* upgrade = upgrades[i];
        if(upgrade != nil)
        {
            maxUpgradeRange = fmaxf(maxUpgradeRange, [upgrade upgradeRange]);
        }
    }
    return maxUpgradeRange;
}
-(void)lock
{
	canBeMoved = NO;
	// tower is placed, subtract from cash
	[game alterCash:-towerCost];
	
	if(towerType != NONE && [game isBoostTowerInRange:objectPosition])
	{
		isInBoostRadius = YES;
		[self applyBoostDamage];
	}
	else
		isInBoostRadius = NO;
}
-(void)shoot
{
	towerState = TOWER_STATE_SHOOT;
	if(aniAttack)
	{
		aniCurrent = aniAttack;
		[aniAttack setCurrentFrame:0];
		[aniAttack setRunning:YES];
	}
	[projectileFactory createProjectile:[[Point2D alloc] initWithX:objectPosition.x y:objectPosition.y] 
						  rotationAngle:[self objectRotationAngle] direction:[self objectDirection]];
	lastShotTime = [GameObject getCurrentTime];
    shotCooldownRemain = towerRateOfFire;
	[self playSound];
}

-(void)upgrade
{
	int upgradeCost = [upgrades[towerLevel-1] upgradeCost];
	towerValue += upgradeCost;
	[upgrades[towerLevel-1] upgradeTower:self];
	++towerLevel;
	[self updateStatsBar];
	[game alterCash:-upgradeCost];
}

-(void)sell
{
	[game alterCash:(uint)((float)towerValue * SELL_PERCENT)];
	[self remove];
}
-(BOOL)isTouchedAtPoint:(CGPoint)p
{
	BOOL touched = [super isTouchedAtPoint:p];
	// check if this tower is currently selected and we've touched somewhere else
	if(selected && touched)
	{
		// don't reselect the tower
		return NO;
	}
	if(selected && !touched)
	{
		// we've selected something else
		if([UIMan clearBottomStatsBar])
			selected = NO;
	}
	return touched;
}
-(void)updateStatsBar
{
	uint upgradeCost = 0;
	if(upgrades[towerLevel-1])
		upgradeCost = [upgrades[towerLevel-1] upgradeCost];
	
	[towerStatusBar setName:objectName];
	
	[towerStatusBar setStats:towerLevel range:(uint)towerRange damage:[self towerDamage] rof:towerRateOfFire 
				  sellAmount:(uint)((float)towerValue * SELL_PERCENT) upgradeCost:upgradeCost
				specialLine1:towerSpecialText1 specialLine2:towerSpecialText2 specialLine3:towerSpecialText3];
	
	if(![self canShoot])
    {
		[towerStatusBar updateReloadBar:((towerRateOfFire - shotCooldownRemain)/towerRateOfFire)];
    }
	else
    {
		[towerStatusBar updateReloadBar:1.0f];
    }
}
-(void)select
{
	if([UIMan showTowerStats])
	{
		[self updateStatsBar];
		[super select];
	}
}
-(void)overInvalidArea
{
	radiusRGBA[0] = 1.0f;
	radiusRGBA[2] = 0.0f;
    if(towerType != NONE && [game isBoostTowerInRange:objectPosition])
        isInBoostRadius = YES;
    else
        isInBoostRadius = NO;
}
-(void)overValidArea
{
	radiusRGBA[0] = 0.1f;
	radiusRGBA[2] = 0.55f;
	if(towerType != NONE && [game isBoostTowerInRange:objectPosition])
		isInBoostRadius = YES;
	else
		isInBoostRadius = NO;
}
-(void)setIsInBoostRadius:(BOOL)flag
{
	// only set the flag for those not currently under a boost
	if(boostDamagePercent == 0.0f && towerType != NONE)
		isInBoostRadius = flag;
}
-(void)applyBoostDamage
{
	// no multiple boosts!
	if(boostDamagePercent == 0.0f && towerType != NONE)
	{
		boostDamagePercent = RG_DAMAGE_BOOST;
		boostRangePercent = RG_RANGE_BOOST;
		boostRateOfFirePercent = RG_ROF_BOOST;
		// re-set all tower attributes, now to with the boosts set
		[self setTowerDamage:[self towerDamage]];
		[self setTowerRange:towerRange];
		[self setTowerRateOfFire:towerRateOfFire];
	}
}
-(void)removeBoost
{
	if(towerType != NONE && ![game isBoostTowerInRange:objectPosition])
	{
		isInBoostRadius = NO;
		boostDamagePercent = boostRangePercent = boostRateOfFirePercent = 0.0f;
		[self setTowerDamage:towerBaseDamage];
		[self setTowerRange:towerBaseRange];
		[self setTowerRateOfFire:towerBaseRateOfFire];
	}
}
-(float)getBaseDisplayRange
{
    float baseDisplayRange = towerRange;
    if([self isInBoostRadius] && [self canBeMoved])
    {
        // Only alter base radius with boosted value if the tower is being placed
        // Placed towers already have boost bonus baked into 'towerRange'
        baseDisplayRange += baseDisplayRange * RG_RANGE_BOOST;
    }
    baseDisplayRange += radiusPulseAddition;
    return baseDisplayRange;
}
-(void)displayRange
{
    const float baseDisplayRange = [self getBaseDisplayRange];
	for(int i = 0; i < 720; i+=2)
	{
        const float angle = [Math convertToRadians:i];
		radiusVertices[i] = cosf(angle) * baseDisplayRange;
		radiusVertices[i+1] = sinf(angle) * baseDisplayRange;
	}
	
	// Use GL_TRIANGLE_FAN to draw the ellipse.
	glPushMatrix();
	glEnable(GL_BLEND);
	glEnableClientState(GL_VERTEX_ARRAY);
	glColor4f(radiusRGBA[0],radiusRGBA[1],radiusRGBA[2],radiusRGBA[3]);
	glTranslatef(objectPosition.x, objectPosition.y, 0.0f);
	glVertexPointer(2, GL_FLOAT, 0, radiusVertices);
	glDrawArrays(GL_TRIANGLE_FAN, 0, 360); // the ellipse has 360 vertices
	glDisable(GL_BLEND);
	glDisableClientState(GL_VERTEX_ARRAY);
	glPopMatrix();
}
-(void)displayRangeUpgrades
{
    float baseDisplayRange = [self getBaseDisplayRange];
    for(int i = towerLevel-1; i < MAX_TOWER_LEVEL-1; ++i)
    {
        Upgrade* upgrade = upgrades[i];
        if(upgrade != nil)
        {
            float upgradeRadius = [upgrade upgradeRange];
            if([self isInBoostRadius])
            {
                upgradeRadius += upgradeRadius * RG_RANGE_BOOST;
            }
            
            for(int j = 0; j < 720; j+=4)
            {
                const float angle = [Math convertToRadians:j];
                const float cosAngle = cosf(angle);
                const float sinAngle = sinf(angle);
                
                // Vertex of inner radius
                radiusUpgradesVertices[i][j] = cosAngle * baseDisplayRange;
                radiusUpgradesVertices[i][j+1] = sinAngle * baseDisplayRange;
                
                // Vertex of outer radius
                radiusUpgradesVertices[i][j+2] = cosAngle * upgradeRadius;
                radiusUpgradesVertices[i][j+3] = sinAngle * upgradeRadius;
            }
            
            // Add vertices to close strip
            radiusUpgradesVertices[i][720] = radiusUpgradesVertices[i][0];
            radiusUpgradesVertices[i][721] = radiusUpgradesVertices[i][1];
            radiusUpgradesVertices[i][722] = radiusUpgradesVertices[i][2];
            radiusUpgradesVertices[i][723] = radiusUpgradesVertices[i][3];
            
            // Use GL_TRIANGLE_STRIP to draw torus style filled ring.
            glPushMatrix();
            glEnable(GL_BLEND);
            glEnableClientState(GL_VERTEX_ARRAY);
            glColor4f(radiusUpgradesRGBA[0],radiusUpgradesRGBA[1],
                      radiusUpgradesRGBA[2],radiusUpgradesRGBA[3]);
            glTranslatef(objectPosition.x, objectPosition.y, 0.0f);
            glVertexPointer(2, GL_FLOAT, 0, radiusUpgradesVertices[i]);
            glDrawArrays(GL_TRIANGLE_STRIP, 0, 362); // the torus has 360 + 2 vertices
            glDisable(GL_BLEND);
            glDisableClientState(GL_VERTEX_ARRAY);
            glPopMatrix();
        }
    }
}
-(void)displayBoost
{
    const float boostDisplayRadius = boostRadius + boostPulseAddition;
	for(int i = 0; i < 720; i+=2) 
	{
        const float angle = [Math convertToRadians:i];
		boostVertices[i] = cos(angle) * boostDisplayRadius;
		boostVertices[i+1] = sin(angle) * boostDisplayRadius;
	}
	
	// Use GL_TRIANGLE_FAN to draw the ellipse.
	glPushMatrix();
	glEnable(GL_BLEND);
	glEnableClientState(GL_VERTEX_ARRAY);
	glColor4f(boostRGBA[0],boostRGBA[1],boostRGBA[2],boostRGBA[3]);
	glTranslatef(objectPosition.x, objectPosition.y, 0.0f);
	glVertexPointer(2, GL_FLOAT, 0, boostVertices);
	glDrawArrays(GL_TRIANGLE_FAN, 0, 360); // the ellipse has 360 vertices
	glDisable(GL_BLEND);
	glDisableClientState(GL_VERTEX_ARRAY);
	glPopMatrix();
}
-(int)update:(float)deltaT
{
    const float radiusPulseAddMax = towerRange * 0.025f;
    const float boostPulseAddMax = boostRadius * 0.075f;
	radiusPulseAddition += pulseDir * deltaT * radiusPulseAddMax * 2.0f;
	boostPulseAddition += pulseDir * deltaT * boostPulseAddMax * 2.0f;
    radiusPulseAddition = fmaxf(0.0f, fminf(radiusPulseAddition, radiusPulseAddMax));
    boostPulseAddition = fmaxf(0.0f, fminf(boostPulseAddition, boostPulseAddMax));
    shotCooldownRemain = fmaxf(0.0f, shotCooldownRemain - deltaT);
	
	if(radiusPulseAddition <= 0.0f)
    {
		pulseDir = 1.0f;
    }
	else if(radiusPulseAddition >= radiusPulseAddMax)
    {
		pulseDir = -1.0f;
    }

	if(towerState == TOWER_STATE_SHOOT
       && [GameObject getCurrentTime] - lastShotTime > 2.0f*towerRateOfFire)
	{
		aniCurrent = aniIdle;
		towerState = TOWER_STATE_IDLE;
	}
	
	if(selected)
    {
        if(![self canShoot])
        {
            [towerStatusBar updateReloadBar:((towerRateOfFire - shotCooldownRemain)/towerRateOfFire)];
        }
        else
        {
            [towerStatusBar updateReloadBar:1.0f];
        }
    }
				
	return [super update:deltaT];
}
-(int)draw
{
	if(selected || canBeMoved)
    {
        [self displayRangeUpgrades];
		[self displayRange];
    }
	if(isInBoostRadius)
    {
		[self displayBoost];
    }
	return [super draw];
}

-(void)dealloc
{
	for(uint i=0; i<MAX_TOWER_LEVEL; ++i)
		if(upgrades[i])
			[upgrades[i] dealloc];
	
	[projectileFactory dealloc];
	[aniIdle dealloc];
	if(aniAttack)
		[aniAttack dealloc];
	[super dealloc];
}

@end

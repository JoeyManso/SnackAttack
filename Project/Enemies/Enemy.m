//
//  Enemy.m
//  towerDefense
//
//  Created by Joey Manso on 7/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Enemy.h"
#import "ParticleEmitter.h"
#import "UITools.h"

@interface Enemy()

-(void)displaySelection;
@end

@implementation Enemy

@synthesize enemyHitPoints;
@synthesize enemySpeed;
@synthesize deathSoundKey;
@synthesize enemyType;
@synthesize enemyImmunity;
@synthesize kernelCount;

const float DEATH_FADE_TIME_MAX = 0.5f;

-(id)init
{
	return [self initWithName:nil position:nil hitPoints:0 speed:0.0f spriteSheet:nil targetNode:nil];
}
-(id)initWithName:(NSString*)n position:(Point2D*)p hitPoints:(float)hp speed:(float)s spriteSheet:(SpriteSheet*)ss targetNode:(PathNode*)t;
{
	// make sure we initialize the super class
	if (self = [super initWithName:n position:p spriteSheet:ss])
	{
		game = [GameState sharedGameStateInstance];
		UIMan = [UIManager getInstance];
		enemyStatusBar = [UIMan getEnemyStatBarReference];
		
		enemyHitPoints = enemyMaxHitPoints = hp;
		enemySpeed = s;
		enemyType = GROUND; // default type is ground
		enemyImmunity = NONE; // default immunity is none
		deathSoundKey = nil;
		target = t;
		dirToTarget = [[Vector2D alloc] initWithX:objectDirection.x y:objectDirection.y];
		killValue = 0;
		
		isFrozen = NO;
		freezeTimeStamp = freezeDuration = 0.0f;
		
		fadeOut = NO;
		deathFadeTimeCurrent = 0.0f;
		
		takeDamageOverTime = NO;
		addDamageTimeStamp = damageDuration = damagePerSecond = 0.0f;
		damageBurstInterval = 0.0f;
		
		kernelCount = 0;
		
		healthBar = [[StatusBar alloc] initWithPosition:[[Point2D alloc] initWithX:objectPosition.x y:objectPosition.y + 15.0f]
												 height:4.0f width:20.0f];
		[healthBar setColorsStartRed:0.0f startGreen:1.0f startBlue:0.0f startAlpha:0.75f 
							  endRed:1.0f endGreen:0.2f endBlue:0.0f endAlpha:0.75f];
		
		aniWalk = [[Animation alloc] init];
	}
	return self;
}
-(void)multiplyMaxHitPoints:(uint)factor
{
	enemyMaxHitPoints *= factor;
	enemyHitPoints *= factor;
}

-(void)takeDamage:(float)d
{
	enemyHitPoints -= d;
	// if the damage goes below 1, remove
	if(!markedForRemoval && enemyHitPoints < 1)
	{
		markedForRemoval = YES;
		[self playSound];
		[aniCurrent setRunning:NO];
		fadeOut = YES;
		[game enemyDefeated:killValue];
		if(selected)
			[enemyStatusBar setHitPoints:0 total:enemyMaxHitPoints];
		[healthBar setFillRatio:0.0f];
	}
	else
	{
		if(selected)
			[enemyStatusBar setHitPoints:(uint)enemyHitPoints total:enemyMaxHitPoints];
		[healthBar setFillRatio:(enemyHitPoints/(float)enemyMaxHitPoints)];
		[healthBar playScaleAnimation];
	}
}
-(void)addDamageOverTime:(float)duration damage:(float)damage
{
	takeDamageOverTime = YES;
	damageDuration = duration;
	damagePerSecond = damage;
	addDamageTimeStamp = game.time;
	damageBurstInterval = 0.0f;
}
-(void)freeze:(float)duration
{
	isFrozen = YES;
	freezeTimeStamp = game.time;
	freezeDuration = duration;
	[aniCurrent setRed:0.52f green:0.81f blue:0.98f alpha:1.0f];
	[aniCurrent setRunning:NO];
}
-(BOOL)isTouchedAtPoint:(CGPoint)p
{
	BOOL touched = [super isTouchedAtPoint:p];
	// check if this enemy is currently selected and we've touched somewhere else
	if(selected && touched)
	{
		// don't reselect the enemy
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
-(void)select
{
	// assume defaults, then check if the type/immunity is  not
	NSString *type = @"Ground";
	NSString *immunity = @"None";
	if(enemyType == AIR)
		type = @"AIR";
		
	switch (enemyImmunity) 
	{
		case POP:
			immunity = @"Pop Can";
			break;
		case FREEZE:
			immunity = @"Freezer";
			break;
		case SLOP:
			immunity = @"Slop";
			break;
		case COOKIE:
			immunity = @"Cookies";
			break;
		case PIE:
			immunity = @"Pies";
			break;
		case KERNEL:
			immunity = @"Kernels";
			break;
		default:
			break;
	}
		
	if([UIMan showEnemyStats])
	{
		[enemyStatusBar setName:objectName speed:(uint)enemySpeed type:type immunity:immunity];
		[enemyStatusBar setHitPoints:(uint)enemyHitPoints total:enemyMaxHitPoints];
		[super select];
	}
}
-(void)displaySelection
{	
	float radius = [spriteSheet spriteWidth] * 0.55f;
	
	for (int i = 0; i < 720; i+=2) 
	{
		radiusVertices[i]   = cos([Math convertToRadians:i]) * radius;
		radiusVertices[i+1] = sin([Math convertToRadians:i]) * radius;
	}
	
	glPushMatrix();
	glEnable(GL_BLEND);
	glEnableClientState(GL_VERTEX_ARRAY);
	glColor4f(1.0f,0.3f,0.0f,0.25f);
	glTranslatef(objectPosition.x, objectPosition.y, 0.0f);
	glVertexPointer(2, GL_FLOAT, 0, radiusVertices);
	glDrawArrays(GL_TRIANGLE_FAN, 0, 360); // the ellipse has 360 vertices
	glDisable(GL_BLEND);
	glDisableClientState(GL_VERTEX_ARRAY);
	glPopMatrix();
}
-(uint)getTargetNodeValue
{
	if(target)
		return [target value];
	return 0;
}
-(int)update:(float)deltaT;
{
	if(fadeOut)
	{
		if(deathFadeTimeCurrent < DEATH_FADE_TIME_MAX)
		{
			deathFadeTimeCurrent += deltaT;
			[[self aniCurrent] setRed:1.0f green:1.0f blue:1.0f alpha:((DEATH_FADE_TIME_MAX-deathFadeTimeCurrent)/DEATH_FADE_TIME_MAX)];
		}
		else
			[self remove];
	}
	else if(target) // while there is still a target node, do path following
	{
		// check if we've reached our destination, change direction if we can.
		// if the next node is nil, we're at the end of the path. Mark ourselves for removal and subtract from lives.
		[dirToTarget setToPointSubtraction:[target nodePosition] :objectPosition];
		if([Vector2D dot:dirToTarget :objectDirection] < 0)
		{
			if([target next] != nil)
			{
                target = [target next];
				Vector2D *newDir = [Point2D subtract:[target nodePosition] :objectPosition];
				[self setObjectDirection:newDir];
				// deallocate our temporary variable
				[newDir release];
			}
			else
			{
				[self remove];
				[game subtractLife];
			}
		}
		[healthBar updateUIObject:deltaT];
		if(isFrozen)
		{
			if(game.time - freezeTimeStamp > freezeDuration)
			{
				isFrozen = NO;
				[aniCurrent setRed:1.0f green:1.0f blue:1.0f alpha:1.0f];
				[aniCurrent setRunning:YES];
			}
		}
		else
		{
			[objectPosition updateWithVector2D:objectDirection speed:enemySpeed deltaT:deltaT];
			[[healthBar UIObjectPosition] updateWithVector2D:objectDirection speed:enemySpeed deltaT:deltaT];
		}
		if(takeDamageOverTime)
		{
			if(game.time - addDamageTimeStamp < damageDuration)
			{
				[self takeDamage:damagePerSecond*deltaT];
				if(game.time - addDamageTimeStamp > damageBurstInterval)
				{
					ParticleEmitter *p = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:@"texture.png"
																					 position:[[Point2D alloc] initWithX:objectPosition.x y:objectPosition.y]
																	   sourcePositionVariance:[[Point2D alloc] initWithX:5.0f y:5.0f]
																						speed:0.7f
																				speedVariance:0.2f
																			 particleLifeSpan:0.1f	
																	 particleLifespanVariance:0.3f
																						angle:0.0f
																				angleVariance:360.0f
																					  gravity:nil
																				   startColor:Color4fMake(0.9f, 0.1f, 0.1f, 1.0f)
																		   startColorVariance:Color4fMake(0.1f, 0.1f, 0.1f, 0.5f)
																				  finishColor:Color4fMake(0.95f, 0.2f, 0.3f, 0.0f) 
																		  finishColorVariance:Color4fMake(0.1f, 0.1f, 0.1f, 0.0f)
																				 maxParticles:100
																				 particleSize:10
																		 particleSizeVariance:5
																					 duration:0.2
																				blendAdditive:NO];
					[p release];
					++damageBurstInterval;
				}
			}
			else
				takeDamageOverTime = NO;
		}
	}
	
	return [super update:deltaT];
}
-(int)draw
{
	if(selected)
		[self displaySelection];
	[super draw];
	if(!fadeOut)
		[healthBar drawUIObject];
	return 0;
}
-(void)dealloc
{
	// remove the enemy status bar if the enemy is currently selected
	if(selected)
	{
		[enemyStatusBar setHitPoints:0 total:enemyMaxHitPoints];
		[UIMan clearBottomStatsBar];
	}
	[dirToTarget dealloc];
	[healthBar dealloc];
	[aniWalk release];
	[super dealloc];
}			

@end

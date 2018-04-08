//
//  Enemies.m
//  towerDefense
//
//  Created by Joey Manso on 7/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Enemies.h"

@implementation Chubby

float const C_HIT_POINTS = 285.0;
float const C_SPEED = 30.0f;

-(id)initWithPosition:(Point2D*)p spriteSheet:(SpriteSheet*)ss targetNode:(PathNode*)t
{
    return [self initWithPosition:p hitPoints:C_HIT_POINTS spriteSheet:ss targetNode:t];
}
-(id)initWithPosition:(Point2D*)p hitPoints:(float)hp spriteSheet:(SpriteSheet*)ss targetNode:(PathNode*)t
{
    if(self = [super initWithName:@"Chubby" position:p hitPoints:hp hitPointsMax:C_HIT_POINTS speed:C_SPEED spriteSheet:ss targetNode:t])
    {
        // set default animation for chubby
        [self setAni:aniWalk row:0 numFrames:4];
        aniCurrent = aniWalk;
        // set death sound
        deathSoundKey = @"ChubbyDeath";
        // set immunity
        enemyImmunity = KERNEL;
        
        // default sound is death
        objectSound.key = deathSoundKey;
        
        killValue = 6;
    }
    return self;
}

@end

@implementation Jeanie

float const J_HIT_POINTS = 140.0;
float const J_SPEED = 35.0f;

-(id)initWithPosition:(Point2D*)p spriteSheet:(SpriteSheet*)ss targetNode:(PathNode*)t
{
    return [self initWithPosition:p hitPoints:J_HIT_POINTS spriteSheet:ss targetNode:t];
}
-(id)initWithPosition:(Point2D*)p hitPoints:(float)hp spriteSheet:(SpriteSheet*)ss targetNode:(PathNode*)t
{
    if(self = [super initWithName:@"Jeanie" position:p hitPoints:hp hitPointsMax:J_HIT_POINTS speed:J_SPEED spriteSheet:ss targetNode:t])
    {
        // set default animation for jeanie
        [self setAni:aniWalk row:0 numFrames:4];
        aniCurrent = aniWalk;
        // set death sound
        deathSoundKey = @"JeanieDeath";
        // set immunity
        enemyImmunity = PIE;
        
        // default sound is death
        objectSound.key = deathSoundKey;
        
        killValue = 4;
    }
    return self;
}

@end

@implementation Lanky

float const L_HIT_POINTS = 160.0f;
float const L_SPEED = 45.0f;

-(id)initWithPosition:(Point2D*)p spriteSheet:(SpriteSheet*)ss targetNode:(PathNode*)t
{
    return [self initWithPosition:p hitPoints:L_HIT_POINTS spriteSheet:ss targetNode:t];
}
-(id)initWithPosition:(Point2D*)p hitPoints:(float)hp spriteSheet:(SpriteSheet*)ss targetNode:(PathNode*)t
{
    if(self = [super initWithName:@"Lanky" position:p hitPoints:hp hitPointsMax:L_HIT_POINTS speed:L_SPEED spriteSheet:ss targetNode:t])
    {
        // set default animation for lanky
        [self setAni:aniWalk row:0 numFrames:4];
        aniCurrent = aniWalk;
        // set death sound
        deathSoundKey = @"LankyDeath";
        // set immunity
        enemyImmunity = POP;
        
        // default sound is death
        objectSound.key = deathSoundKey;
        
        killValue = 5;
    }
    return self;
}

@end

@implementation Smarty

float const S_HIT_POINTS = 130.0f;
float const S_SPEED = 40.0f;

-(id)initWithPosition:(Point2D*)p spriteSheet:(SpriteSheet*)ss targetNode:(PathNode*)t
{
    return [self initWithPosition:p hitPoints:S_HIT_POINTS spriteSheet:ss targetNode:t];
}
-(id)initWithPosition:(Point2D*)p hitPoints:(float)hp spriteSheet:(SpriteSheet*)ss targetNode:(PathNode*)t
{
    if(self = [super initWithName:@"Smarty" position:p hitPoints:hp hitPointsMax:S_HIT_POINTS speed:S_SPEED spriteSheet:ss targetNode:t])
    {
        // set default animation for smarty
        [self setAni:aniWalk row:0 numFrames:4];
        aniCurrent = aniWalk;
        // set death sound
        deathSoundKey = @"SmartyDeath";
        // set immunity
        enemyImmunity = FREEZE;
        
        // default sound is death
        objectSound.key = deathSoundKey;
        
        killValue = 4;
    }
    return self;
}

@end

@implementation Airplane

float const A_HIT_POINTS = 115.0f;
float const A_SPEED = 45.0f;

-(id)initWithPosition:(Point2D*)p spriteSheet:(SpriteSheet*)ss targetNode:(PathNode*)t
{
	return [self initWithPosition:p hitPoints:A_HIT_POINTS spriteSheet:ss targetNode:t];
}
-(id)initWithPosition:(Point2D*)p hitPoints:(float)hp spriteSheet:(SpriteSheet*)ss targetNode:(PathNode*)t
{
    if(self = [super initWithName:@"Airplane" position:p hitPoints:hp hitPointsMax:A_HIT_POINTS speed:A_SPEED spriteSheet:ss targetNode:t])
    {
        // this is an air enemy type
        enemyType = AIR;
        
        // set default animation for airplane
        [self setAni:aniWalk row:0 numFrames:4];
        aniCurrent = aniWalk;
        // set death sound
        deathSoundKey = @"AirplaneDeath";
        
        // default sound is death
        objectSound.key = deathSoundKey;
        
        killValue = 6;
    }
    return self;
}

@end

@implementation Banner

float const BN_HIT_POINTS = 130.0f;
float const BN_SPEED = 60.0f;

-(id)initWithPosition:(Point2D*)p spriteSheet:(SpriteSheet*)ss targetNode:(PathNode*)t
{
    return [self initWithPosition:p hitPoints:BN_HIT_POINTS spriteSheet:ss targetNode:t];
}
-(id)initWithPosition:(Point2D*)p hitPoints:(float)hp spriteSheet:(SpriteSheet*)ss targetNode:(PathNode*)t
{
    if(self = [super initWithName:@"Banner" position:p hitPoints:hp hitPointsMax:BN_HIT_POINTS speed:BN_SPEED spriteSheet:ss targetNode:t])
    {
        // this is an air enemy type
        enemyType = AIR;
        
        // set default animation for airplane
        [self setAni:aniWalk row:0 numFrames:16 delay:0.04f];
        aniCurrent = aniWalk;
        // set death sound
        deathSoundKey = @"BannerDeath";
        
        // default sound is death
        objectSound.key = deathSoundKey;
        
        killValue = 7;
    }
    return self;
}

@end

@implementation Bandie

float const BD_HIT_POINTS = 275.0f;
float const BD_SPEED = 45.0f;

-(id)initWithPosition:(Point2D*)p spriteSheet:(SpriteSheet*)ss targetNode:(PathNode*)t
{
    return [self initWithPosition:p hitPoints:BD_HIT_POINTS spriteSheet:ss targetNode:t];
}
-(id)initWithPosition:(Point2D*)p hitPoints:(float)hp spriteSheet:(SpriteSheet*)ss targetNode:(PathNode*)t
{
    if(self = [super initWithName:@"Bandie" position:p hitPoints:hp hitPointsMax:BD_HIT_POINTS speed:BD_SPEED spriteSheet:ss targetNode:t])
    {
        // this is an air enemy type
        enemyType = GROUND;
        
        // set default animation for airplane
        [self setAni:aniWalk row:0 numFrames:8 delay:0.08f];
        aniCurrent = aniWalk;
        // set death sound
        deathSoundKey = @"BandieDeath";
        // set immunity
        enemyImmunity = SLOP;
        
        // default sound is death
        objectSound.key = deathSoundKey;
        objectSound.gain = 2.0f;
        
        killValue = 6;
    }
    return self;
}

@end

@implementation Cheerie

float const CH_HIT_POINTS = 60;
float const CH_SPEED = 160.0f;

-(id)initWithPosition:(Point2D*)p spriteSheet:(SpriteSheet*)ss targetNode:(PathNode*)t
{
    return [self initWithPosition:p hitPoints:CH_HIT_POINTS spriteSheet:ss targetNode:t];
}
-(id)initWithPosition:(Point2D*)p hitPoints:(float)hp spriteSheet:(SpriteSheet*)ss targetNode:(PathNode*)t
{
    if(self = [super initWithName:@"Cheerie" position:p hitPoints:hp hitPointsMax:CH_HIT_POINTS speed:CH_SPEED spriteSheet:ss targetNode:t])
    {
        // this is an air enemy type
        enemyType = GROUND;
        
        // set default animation for airplane
        [self setAni:aniWalk row:0 numFrames:16 delay:0.04f];
        aniCurrent = aniWalk;
        // set death sound
        deathSoundKey = @"CheerleaderDeath";
        // set immunity
        enemyImmunity = COOKIE;
        
        // default sound is death
        objectSound.key = deathSoundKey;
        objectSound.gain = 2.0f;
        
        killValue = 3;
    }
    return self;
}

@end

@implementation Punkie

float const P_HIT_POINTS = 215;
float const P_SPEED = 80.0f;

-(id)initWithPosition:(Point2D*)p spriteSheet:(SpriteSheet*)ss targetNode:(PathNode*)t
{
    return [self initWithPosition:p hitPoints:P_HIT_POINTS spriteSheet:ss targetNode:t];
}
-(id)initWithPosition:(Point2D*)p hitPoints:(float)hp spriteSheet:(SpriteSheet*)ss targetNode:(PathNode*)t
{
    if(self = [super initWithName:@"Punkie" position:p hitPoints:hp hitPointsMax:P_HIT_POINTS speed:P_SPEED spriteSheet:ss targetNode:t])
    {
        // this is an air enemy type
        enemyType = GROUND;
        
        // set default animation for airplane
        [self setAni:aniWalk row:0 numFrames:16 delay:0.04f];
        aniCurrent = aniWalk;
        // set death sound
        deathSoundKey = @"PunkDeath";
        // set immunity
        enemyImmunity = KERNEL;
        
        // default sound is death
        objectSound.key = deathSoundKey;
        
        killValue = 4;
    }
    return self;
}

@end

@implementation Mascot

float const M_HIT_POINTS = 350;
float const M_SPEED = 40.0f;

-(id)initWithPosition:(Point2D*)p spriteSheet:(SpriteSheet*)ss targetNode:(PathNode*)t
{
    return [self initWithPosition:p hitPoints:M_HIT_POINTS spriteSheet:ss targetNode:t];
}
-(id)initWithPosition:(Point2D*)p hitPoints:(float)hp spriteSheet:(SpriteSheet*)ss targetNode:(PathNode*)t
{
    if(self = [super initWithName:@"Mascot" position:p hitPoints:hp hitPointsMax:M_HIT_POINTS speed:M_SPEED spriteSheet:ss targetNode:t])
    {
        // this is an air enemy type
        enemyType = GROUND;
        
        // set default animation for airplane
        [self setAni:aniWalk row:0 numFrames:32 delay:0.04f];
        aniCurrent = aniWalk;
        // set death sound
        deathSoundKey = @"MascotDeath";
        // set immunity
        enemyImmunity = POP;
        
        // default sound is death
        objectSound.key = deathSoundKey;
        
        killValue = 6;
    }
    return self;
}

@end

@implementation Queenie

float const Q_HIT_POINTS = 975;
float const Q_SPEED = 45.0f;

-(id)initWithPosition:(Point2D*)p spriteSheet:(SpriteSheet*)ss targetNode:(PathNode*)t
{
    return [self initWithPosition:p hitPoints:Q_HIT_POINTS spriteSheet:ss targetNode:t];
}
-(id)initWithPosition:(Point2D*)p hitPoints:(float)hp spriteSheet:(SpriteSheet*)ss targetNode:(PathNode*)t
{
    if(self = [super initWithName:@"Queenie" position:p hitPoints:hp hitPointsMax:Q_HIT_POINTS speed:Q_SPEED spriteSheet:ss targetNode:t])
    {
        // this is an air enemy type
        enemyType = GROUND;
        
        // set default animation for airplane
        [self setAni:aniWalk row:0 numFrames:32 delay:0.02f];
        aniCurrent = aniWalk;
        // set death sound
        deathSoundKey = @"PromQueenDeath";
        // set immunity
        enemyImmunity = FREEZE;
        
        // default sound is death
        objectSound.key = deathSoundKey;
        objectSound.gain = 1.5f;
        
        killValue = 13;
    }
    return self;
}

@end

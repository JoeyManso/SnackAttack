//
//  Towers.h
//  towerDefense
//
//  Created by Joey Manso on 7/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tower.h"

#define VM_COST 30
#define MT_COST 65
#define CL_COST 75
#define FR_COST 90
#define PM_COST 145
#define PL_COST 165
#define RG_COST 450

@interface VendingMachine : Tower 
{	
}

-(id)initWithPosition:(Point2D*)p spriteSheet:(SpriteSheet*)ss;
-(id)initLoadedWithPosition:(Point2D*)p level:(int)l cooldown:(float)c spriteSheet:(SpriteSheet*)ss;
-(void)setExpRatio:(float)ratio expDamage:(float)damage;

@end

@interface Freezer : Tower 
{
	float freezeDuration;
}
@property(nonatomic)float freezeDuration;

-(id)initWithPosition:(Point2D*)p spriteSheet:(SpriteSheet*)ss;
-(id)initLoadedWithPosition:(Point2D*)p level:(int)l cooldown:(float)c spriteSheet:(SpriteSheet*)ss;

@end

@interface Matron : Tower 
{
	@private
	BOOL matronHasShot;
}

-(id)initWithPosition:(Point2D*)p spriteSheet:(SpriteSheet*)ss;
-(id)initLoadedWithPosition:(Point2D*)p level:(int)l cooldown:(float)c spriteSheet:(SpriteSheet*)ss;
-(void)setTimeDamage:(uint)dmg timeDuration:(float)dur;

@end

@interface CookieLauncher : Tower 
{	
}

-(id)initWithPosition:(Point2D*)p spriteSheet:(SpriteSheet*)ss;
-(id)initLoadedWithPosition:(Point2D*)p level:(int)l cooldown:(float)c spriteSheet:(SpriteSheet*)ss;
-(void)setNumDirections:(uint)dirs;

@end

@interface PieLauncher : Tower 
{
}

-(id)initWithPosition:(Point2D*)p spriteSheet:(SpriteSheet*)ss;
-(id)initLoadedWithPosition:(Point2D*)p level:(int)l cooldown:(float)c spriteSheet:(SpriteSheet*)ss;
-(void)setSplashDamage:(float)damage splashRadius:(float)radius;

@end

@interface PopcornMachine : Tower 
{
	uint kernelCounter;
	float kernelLastShotTime;
}

-(id)initWithPosition:(Point2D*)p spriteSheet:(SpriteSheet*)ss;
-(id)initLoadedWithPosition:(Point2D*)p level:(int)l cooldown:(float)c spriteSheet:(SpriteSheet*)ss;
-(void)setDelayDamage:(float)damage delayTime:(float)time;

@end

static TouchManager *touchMan;

@interface Register : Tower 
{
	GLfloat registerRadialRGBA1[4];
	GLfloat registerRadialRGBA2[4];
	GLfloat registerRadialRGBA3[4];
	
	GLfloat registerRadial1[720];
	GLfloat registerRadial2[720];
	GLfloat registerRadial3[720];
	
	float radius1,radius2,radius3;
}

-(id)initWithPosition:(Point2D*)p spriteSheet:(SpriteSheet*)ss;
-(id)initLoadedWithPosition:(Point2D*)p level:(int)l cooldown:(float)c spriteSheet:(SpriteSheet*)ss;

@end

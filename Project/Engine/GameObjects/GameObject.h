//
//  GameObject.h
//  towerDefense
//
//  Created by Joey Manso on 7/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Math.h"
#import "TouchManager.h"
#import "SoundManager.h"

// attack types
enum
{
	GROUND=1,
	AIR=2
};

// projectile types
enum
{
	NONE,
	POP,
	FREEZE,
	SLOP,
	COOKIE,
	PIE,
	KERNEL
};

struct Sound
{
	NSString *key;
	float gain;
	float pitch;
};

// up vector initialized once for all objects
static Vector2D *up;
@interface GameObject : NSObject 
{
@private
    SoundManager *soundMan;
@public
	NSString *objectName; // name of our object
	float objectRotationAngle; // rotation angle in degrees
	Point2D *objectPosition; // position of this object
	float objectScale;
	Vector2D *objectDirection;
	
	BOOL selected;
	BOOL canBeMoved;
	BOOL markedForRemoval;
	
	struct Sound objectSound;
	
	TouchManager *touchManager;
}

@property(nonatomic, readonly)NSString* objectName;
@property(nonatomic)float objectRotationAngle;
@property(nonatomic, copy)Point2D* objectPosition;
@property(nonatomic)float objectScale;
@property(nonatomic, copy)Vector2D* objectDirection;
@property(nonatomic, readonly)BOOL canBeMoved;
@property(nonatomic)BOOL selected;
@property(nonatomic,readonly)BOOL markedForRemoval;


+(float)getCurrentTime;
+(void)removeUp; // dealloc our static up vector

-(void)playSound;
-(id)initWithName:(NSString*)n position:(Point2D*)p;

-(void)setObjectPositionX:(float)p_x y:(float)p_y;
-(void)setObjectDirectionX:(float)d_x y:(float)d_y;

-(BOOL)isTouchedAtPoint:(CGPoint)p;
-(void)select;

-(CGRect)getObjectHitBox;

-(int)update:(float)deltaT;
-(int)draw;

-(void)remove;
-(void)release;

@end

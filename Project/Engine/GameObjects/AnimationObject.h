//
//  AnimationObject.h
//  towerDefense
//
//  Created by Joey Manso on 7/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameObject.h"
#import "Animation.h"
#import "SpriteSheet.h"

@interface AnimationObject : GameObject 
{	
	SpriteSheet *spriteSheet; // sprite sheet contaning this object's animations
	Animation *aniCurrent; // the current animation that will be displayed
}

@property(nonatomic, readonly)Animation* aniCurrent;

-(id)initWithName:(NSString*)n position:(Point2D*)p spriteSheet:(SpriteSheet*)ss;
-(void)setAni:(Animation*)ani row:(int)row numFrames:(int)frames; // set up a given animation
-(void)setAni:(Animation*)ani row:(int)row numFrames:(int)frames delay:(float)delay;
-(int)update:(float)deltaT;
-(int)draw;

@end


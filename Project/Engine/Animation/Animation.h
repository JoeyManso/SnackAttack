//
//  Animation.h
//  towerDefense
//
//  Created by Joey Manso on 7/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Frame.h"

enum
{
	Direction_Forward = 1,
	Direction_Backward = -1
};

@interface Animation : NSObject 
{
	// Frames for this animation
	NSMutableArray *frames;
	// Accumulate the time a frame is displayed
	float frameTimer;
	// are we running animation?
	BOOL running;
	BOOL repeat;
	// goes in reverse after reaching end of an animation
	BOOL pingPong; 
	
	int direction;
	int currentFrame;
	
	float rotationAngle;
	float scale;
}

@property(nonatomic)BOOL running;
@property(nonatomic)BOOL repeat;
@property(nonatomic)BOOL pingPong;
@property(nonatomic)int direction;
@property(nonatomic)int currentFrame;

@property(nonatomic)float rotationAngle;
@property(nonatomic)float scale;

- (void)addFrameWithImage:(Image*)image delay:(float)delay;
- (int)update:(float)deltaT;
- (void)renderAtPoint:(CGPoint)point;
- (Image*)getCurrentFrameImage;
- (GLuint)getAnimationFrameCount;
- (GLuint)getCurrentFrameNumber;
- (Frame*)getFrame:(GLuint)frameNum;
- (void)setRed:(float)r green:(float)g blue:(float)b alpha:(float)a;

@end

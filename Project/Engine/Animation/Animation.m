//
//  Animation.m
//  towerDefense
//
//  Created by Joey Manso on 7/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Animation.h"


@implementation Animation

@synthesize running;
@synthesize repeat;
@synthesize pingPong;
@synthesize direction;
@synthesize currentFrame;
@synthesize rotationAngle;
@synthesize scale;

-(id)init
{
	if(self = [super init])
	{
		// initialize array to hold the frames
		frames = [[NSMutableArray alloc] init];
		
		// Set default values
		running = NO;
		repeat = NO;
		pingPong = NO;
		direction = Direction_Forward;
		currentFrame = 0;
		frameTimer = 0;
		
		rotationAngle = 0.0f;
		scale = 1.0f;
	}
	return self;
}

- (void)addFrameWithImage:(Image*)image delay:(float)delay
{
	// create a new frame instance to hold the image and delay if applicable
	Frame *frame = [[Frame alloc] initWithImage:image delay:delay];
	
	// add to array
	[frames addObject:frame];
	
	// release the frame because we've already put it in our array
	[frame release];
}

- (void)setRed:(float)r green:(float)g blue:(float)b alpha:(float)a
{
	for(Frame *frame in frames)
		[[frame frameImage] setColorFilterRed:r green:g blue:b alpha:a];
}

- (int)update:(float)deltaT
{
	// If the animation is not running then don't do anything
	if(!running) return 0;
	
	// Update the timer with the delta
	frameTimer += deltaT;
	
	// If the timer has exceed the delay for the current frame, move to the next frame.  If we are at
	// the end of the animation, check to see if we should repeat, pingpong or stop
	if(frameTimer > [[frames objectAtIndex:currentFrame] frameDelay]) 
	{
		currentFrame += direction;
		frameTimer = 0;
		// if we've reached the end or beginning (reverse)
		if(currentFrame > [frames count]-1 || currentFrame < 0) 
		{
			if(pingPong) 
			{
				// If we are ping ponging then change the direction and move the current frame to the
				// next frame based on the direction
				direction = -direction;
				currentFrame += direction;
			}
			else if(repeat && !pingPong)
				// If we should repeat without ping pong then just reset the current frame to 0 and continue
				currentFrame = 0;
			else if(!repeat && !pingPong) 
			{
				// If we are not repeating and no pingPing then set the current frame to 0 and stop the animation
				running = NO;
				currentFrame = 0;
			}
		}
	}
	return 0;
}

- (void)renderAtPoint:(CGPoint)point
{
	// get current frame
	Frame *frame = [frames objectAtIndex:currentFrame];
	
	[frame setRotationAngle:rotationAngle];
	[frame setScale:scale];
	
	// take this image and render it for the point
	[[frame frameImage] renderAtPoint:point centerOfImage:YES];
}

- (Image*)getCurrentFrameImage 
{
	// Return the image which is being used for the current frame
	return [[frames objectAtIndex:currentFrame] frameImage];
}


- (GLuint)getAnimationFrameCount 
{
	// Return the total number of frames in this animation
	return (GLuint)[frames count];
}


- (GLuint)getCurrentFrameNumber 
{
	// Return the current frame within this animation
	return currentFrame;
}


- (Frame*)getFrame:(GLuint)frameNum 
{
	// If a frame number is reuqested outside the range that exists, return nil
	// and log an error
	if(frameNum > [frames count]) 
	{
		NSLog(@"WARNING: Requested frame '%d' is out of bounds", frameNum);
		return nil;
	}
	
	// Return the frame for the requested index
	return [frames objectAtIndex:frameNum];
}


- (void)dealloc 
{
	[frames release];
	[super dealloc];
}
@end

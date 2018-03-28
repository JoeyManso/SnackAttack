//
//  GameObject.m
//  towerDefense
//
//  Created by Joey Manso on 7/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "GameState.h"
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

// private stuff
@interface GameObject()

-(void)rotateSpriteToDirection:(Vector2D*)dir;
-(void)drawNormal;
-(void)drawHitBox;

@end


@implementation GameObject

@synthesize objectName;
@synthesize objectRotationAngle;
@synthesize objectPosition;
@synthesize objectScale;
@synthesize objectDirection;
@synthesize canBeMoved;
@synthesize selected;
@synthesize markedForRemoval;

-(id)init
{
	return [self initWithName:nil position:nil];
}
-(id)initWithName:(NSString*)n position:(Point2D*)p
{
	// make sure we initialize the super class
	if (self = [super init])
	{
		touchManager = [TouchManager getInstance];
        soundMan = [SoundManager getInstance];
		
		objectName = n;
		objectRotationAngle = 0.0f;
		objectPosition = p;
		objectScale = 1.0f;
		objectDirection = [[Vector2D alloc] initWithX:0.0f y:1.0f];
		
		selected = NO;
		canBeMoved = NO;
		markedForRemoval = NO;
		
		// initialize default sound values
		objectSound.key = nil;
		objectSound.gain = 1.0f;
		objectSound.pitch = 1.0f;
		
		// initialize up if it has not been (this is only done once!)
		if(!up)
			up = [[Vector2D alloc] initWithX:0.0f y:1.0f];
		
		// add each object to the game object stack 
		[[GameState sharedGameStateInstance] addObject:self];
	}
	return self;
}
+(float)getCurrentTime
{
	return [[GameState sharedGameStateInstance] time];
}
+(void)removeUp
{
	[up dealloc];
}
-(void)playSound
{
	[soundMan playSoundWithKey:objectSound.key gain:objectSound.gain pitch:objectSound.pitch shouldLoop:NO];
}
-(void)setObjectPosition:(Point2D*)p
{
	// copy coordinates so we don't reassign the pointer
	[objectPosition setX:p.x y:p.y];
}
-(void)setObjectPositionX:(float)p_x y:(float)p_y
{
	[objectPosition setX:p_x y:p_y];
}
-(void)setObjectDirection:(Vector2D*)v
{
	// before we set our direction, rotate the sprite
	[self rotateSpriteToDirection:v];
	// copy coordinates so we don't reassign the pointer
	[objectDirection setX:v.x y:v.y];
}
-(void)setObjectDirectionX:(float)d_x y:(float)d_y
{
	[objectDirection setX:d_x y:d_y];
}
-(void)rotateSpriteToDirection:(Vector2D*)dir
{	
	// dir is the direction we want to face
	// take the dot of up and dir to find our desired angle
	float dot = [Vector2D dot:up :dir];
	float angle = [Math convertToDegrees:acos(dot)];
	// i think this is a hack
	if(dir.x < up.x)
		angle*=-1;
	
	[self setObjectRotationAngle:angle];
}

-(BOOL)isTouchedAtPoint:(CGPoint)p
{
	return NO;
}
-(void)select
{
	// select/deselect
	selected = YES;
}
-(CGRect)getObjectHitBox
{
	// this doesn't do anything because we don't know anything about the object's dimensions. Use the subclass versions!
	return CGRectMake(0,0,0,0);
}

-(int)update:(float)deltaT
{
	return 0;
}
-(int)draw
{
	if([[GameState sharedGameStateInstance] debugMode])
	{	
		[self drawNormal];
		[self drawHitBox];
	}
	
	return 0;
}
-(void)drawNormal
{
	const GLfloat line[] = {objectPosition.x, objectPosition.y,
							objectPosition.x + objectDirection.x* 50.0f, objectPosition.y + objectDirection.y* 50.0f};
	
	glVertexPointer(2, GL_FLOAT,0, line);
	glEnableClientState(GL_VERTEX_ARRAY);
	glDrawArrays(GL_LINES, 0, 2);
	glDisableClientState(GL_VERTEX_ARRAY);
}
-(void)drawHitBox
{
	CGRect box = [self getObjectHitBox];
	
	GLfloat const hitBoxOutline[8] =
	{
		box.origin.x, box.origin.y,
		box.origin.x + box.size.width, box.origin.y,
		box.origin.x + box.size.width, box.origin.y + box.size.height,
		box.origin.x, box.origin.y + box.size.height
	};
	
	//and we will use GL_TRIANGLE_FAN to draw the bar.
	glPushMatrix();
	glEnable(GL_BLEND);
	glEnableClientState(GL_VERTEX_ARRAY);
	
	glColor4f(1.0f, 0.0f, 0.0f, 1.0f);
	glVertexPointer(2, GL_FLOAT, 0, hitBoxOutline);	
	glDrawArrays(GL_LINE_LOOP, 0, 4);
	
	glDisable(GL_BLEND);
	glDisableClientState(GL_VERTEX_ARRAY);
	glPopMatrix();
}
-(void)remove
{
	markedForRemoval = YES;
	[[GameState sharedGameStateInstance] removeObject:self];
}
-(void)dealloc
{
	[objectPosition dealloc];
	[objectDirection dealloc];
	[super dealloc];
}
-(void)release
{
	[super release];
}

@end

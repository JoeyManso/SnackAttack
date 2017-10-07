//
//  SpriteSheet.m
//  towerDefense
//
//  Created by Joey Manso on 7/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SpriteSheet.h"

@interface SpriteSheet()
- (void)initImpl:(GLuint)width spriteHeight:(GLuint)height spacing:(GLuint)space imageScale:(float)scale;
@end

@implementation SpriteSheet

@synthesize image;
@synthesize spriteWidth;
@synthesize spriteHeight;
@synthesize spacing;
@synthesize horizontal;
@synthesize vertical;
@synthesize vertices;
@synthesize texCoords;

- (id)init
{
	return [self initWithImageName:nil spriteWidth:0 spriteHeight:0 spacing:0 imageScale:0.0f];
}

- (id)initWithImageName:(NSString*)spriteSheetName spriteWidth:(GLuint)width spriteHeight:(GLuint)height spacing:(GLuint)space imageScale:(float)scale
{
	if(self = [super init])
	{
		image = [[Image alloc] initWithImage:[UIImage imageNamed:spriteSheetName] scale:scale];
		
		[self initImpl:width spriteHeight:height spacing:space imageScale:scale];
	}
	return self;
}

- (void)initImpl:(GLuint)width spriteHeight:(GLuint)height spacing:(GLuint)space imageScale:(float)scale
{
	spriteWidth = width;
	spriteHeight = height;
	spacing = space;
	horizontal = (int)(([image imageWidth] - spriteWidth)/(spriteWidth + spacing)) + 1;
	vertical = (int)(([image imageHeight] - spriteHeight)/(spriteHeight + spacing)) + 1;
	// add one if we hit a fraction
	if(([image imageHeight] - spriteHeight) % (spriteHeight + spacing) !=0)
	   vertical++;
}

- (Image*)getSpriteAtX:(GLuint)x y:(GLuint)y
{
	// Calculate point from where sprite should be taken on spritesheet
	CGPoint spritePoint = CGPointMake(x * (spriteWidth + spacing), y * (spriteHeight + spacing));
	
	// Return the sub image defined by the parameters and spacing of the spritesheet.
	// Incorperate image scale to make sure all subimages are relative
	return [image getSubImageAtPoint:spritePoint subImageWidth:spriteWidth subImageHeight:spriteHeight scale:[image scale]];
}

- (void)renderSpriteAtX:(GLuint)x y:(GLuint)y point:(CGPoint)point centerOfImage:(BOOL)center
{
	//Calculate the point from which the sprite should be taken within the spritesheet
	CGPoint spritePoint = [self getOffsetForSpriteAtX:x y:y];
	
	// Rather than return a new image for this sprite we are going to just render the specified
	// sprite at the specified location
	[image renderSubImageAtPoint:point offset:spritePoint subImageWidth:spriteWidth subImageHeight:spriteHeight centerOfImage:center];
}


- (Quad2*)getTextureCoordsForSpriteAtX:(GLuint)x y:(GLuint)y 
{
	CGPoint offsetPoint = [self getOffsetForSpriteAtX:x y:y];
	[image calculateTexCoordsAtOffset:offsetPoint subImageWidth:spriteWidth subImageHeight:spriteHeight];
	return [image texCoords];
}


- (Quad2*)getVerticesForSpriteAtX:(GLuint)x y:(GLuint)y point:(CGPoint)point centerOfImage:(BOOL)center 
{
	[image calculateVerticesAtPoint:point subImageWidth:spriteWidth subImageHeight:spriteHeight centerOfImage:center];
	return [image vertices];
}


- (CGPoint)getOffsetForSpriteAtX:(int)x y:(int)y 
{
	return CGPointMake(x * (spriteWidth + spacing), y * (spriteHeight + spacing));	
}

- (void)dealloc
{
	[image dealloc];
	[super dealloc];
}

@end

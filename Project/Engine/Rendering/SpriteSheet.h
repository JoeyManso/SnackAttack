//
//  SpriteSheet.h
//  towerDefense
//
//  Created by Joey Manso on 7/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Image.h"

@interface SpriteSheet : NSObject
{
	Image *image;
	GLuint spriteWidth;
	GLuint spriteHeight;
	GLuint spacing;
	
	// Horizontal/Vertical tiles
	int horizontal;
	int vertical;
	
	// Vertex array
	Quad2 *vertices;
	Quad2 *texCoords;
}

@property(nonatomic, readonly)Image *image;
@property(nonatomic, readonly)GLuint spriteWidth;
@property(nonatomic, readonly)GLuint spriteHeight;
@property(nonatomic, readonly)GLuint spacing;
@property(nonatomic, readonly)int horizontal;
@property(nonatomic, readonly)int vertical;
@property(nonatomic, readonly)Quad2 *vertices;
@property(nonatomic, readonly)Quad2 *texCoords;

// initializers
- (id)init;
- (id)initWithImageName:(NSString*)spriteSheetName spriteWidth:(GLuint)width spriteHeight:(GLuint)height spacing:(GLuint)space imageScale:(float)scale;

// reference sub image in spritesheet
- (Image*)getSpriteAtX:(GLuint)x y:(GLuint)y;
// grabs a subimage and renders it at 'point'
- (void)renderSpriteAtX:(GLuint)x y:(GLuint)y point:(CGPoint)point centerOfImage:(BOOL)center;
// get offset for a sprite at a point
- (CGPoint)getOffsetForSpriteAtX:(int)x y:(int)y;
// get coordinates for a sprite, used for drawing
- (Quad2*)getTextureCoordsForSpriteAtX:(GLuint)x y:(GLuint)y;
- (Quad2*)getVerticesForSpriteAtX:(GLuint)x y:(GLuint)y point:(CGPoint)point centerOfImage:(BOOL)center;


@end

//
//  Image.h
//  towerDefense
//
//  Created by Michael Daley on 03/15/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
/* 
 This Image class is used to wrap the Texture2D class.  It provides our own methods to render the texture to the
 screen as well as being able to rotate and scale the image.  Below is an explanation of how we use texture 
 coordinates to only render the part of the texture returned by Texture2D we are interested in.
 
 When Texture2D takes an image and turns it into a texture, it makes sure that the texture is ^2.  Using the player.png
 image from our current example, it means that the texture created is 64x128px.  Within this texture out player.png 
 image is 48x71px.  This is shown in the diagram below:
 
			 imageWidth
			 48px
			 |------|
 
		-    +------+---+   -
 image  !    |iiiiii|   |   !
 Height !    |iiiiii|   |   !
 71px   !    |iiiiii|   |   ! textureHeight
		-    +------+   |   ! 128px
			 |          |   ! 
			 |          |   !
			 +----------+   -
 
			 |----------|
			 textureWidth
			 64px	
 
 Texture coordinates in OpenGL are defined from 0.0 to 1.0 so within the texture above an x texture coordinate of 
 1.0f would be 64px and a y texture coordinate of 1.0f would be 128px.  We can use this information to calculate
 the texture coordinates we need to use to make sure that just our image 48x71 is used when rendering the texture
 into our quad.  The calculation we use is:
 
 maxTexWidth = width / textureWidth;
 maxTexHeight = height / textureHeight;
 
 For our example image the result would be
 
 maxTexWidth = 48 / 64 = 0.750000
 maxTexHeight = 71 / 128 = 0.554688
 
 We then use these values within the methods that draw the image so that only the image within the texture is
 used and nont of the blank texture is used.  We can use this same approach to select images from a sprite 
 sheet or texture atlas.
 */	

#import <Foundation/Foundation.h>
#import "Texture2D.h"
#import "towerDefenseAppDelegate.h"

typedef struct _Quad2
{
	float tl_x, tl_y;  // top left corner
	float tr_x, tr_y;  // top right corner
	float bl_x, bl_y;  // bottom left corner
	float br_x, br_y;  // bottom right coerner
} Quad2;

@interface Image : NSObject 
{
	Texture2D *texture;
	
	unsigned long imageWidth;
	unsigned long imageHeight;
	
	unsigned long textureWidth;
	unsigned long textureHeight;
	
	float texMaxWidth;
	float texMaxHeight;
	float texWidthRatio; // width to pixel ratio
	float texHeightRatio; // height to pixel ratio
	unsigned long textureOffsetX;
	unsigned long textureOffsetY;
	
	float rotationAngle; // rotation angle in degrees
	float scale;
	
	BOOL flipVertically;
	BOOL flipHorizontally;
	
	float rgba[4]; // filter for rgba
	
	// App Delegate
	towerDefenseAppDelegate *appDelegate;
	
	// Vertex arrays
	Quad2 *vertices;
	Quad2 *texCoords;
	GLushort *indices;
}

@property(nonatomic, readonly)Texture2D *texture;
@property(nonatomic)unsigned long imageWidth;
@property(nonatomic)unsigned long imageHeight;
@property(nonatomic, readonly)unsigned long textureWidth;
@property(nonatomic, readonly)unsigned long textureHeight;
@property(nonatomic, readonly)float texWidthRatio;
@property(nonatomic, readonly)float texHeightRatio;
@property(nonatomic)unsigned long textureOffsetX;
@property(nonatomic)unsigned long textureOffsetY;
@property(nonatomic)float rotationAngle;
@property(nonatomic)float scale;
@property(nonatomic)BOOL flipVertically;
@property(nonatomic)BOOL flipHorizontally;
@property(nonatomic)Quad2 *vertices;
@property(nonatomic)Quad2 *texCoords;

// Initializers
- (id)init;
- (id)initWithTexture:(Texture2D *)tex;
- (id)initWithTexture:(Texture2D *)tex scale:(float)imageScale;
- (id)initWithImage:(UIImage *)image;
- (id)initWithImage:(UIImage *)image filter:(GLenum)filter;
- (id)initWithImage:(UIImage *)image scale:(float)imageScale;
- (id)initWithImage:(UIImage *)image scale:(float)imageScale filter:(GLenum)filter;

// Action methods
- (Image*)getSubImageAtPoint:(CGPoint)point subImageWidth:(GLuint)subImageWidth subImageHeight:(GLuint)subImageHeight scale:(float)subImageScale;
- (void)renderAtPoint:(CGPoint)point centerOfImage:(BOOL)center;
- (void)renderAtPoint:(CGPoint)point rotationAngle:(float)rot centerOfImage:(BOOL)center;
- (void)renderAtPoint:(CGPoint)point rotationAngle:(float)rot centerOfImage:(BOOL)center alpha:(float)a;
- (void)renderAtPoint:(CGPoint)point rotationAngle:(float)rot centerOfImage:(BOOL)center red:(float)r green:(float)g blue:(float)b alpha:(float)a;

- (void)renderSubImageAtPoint:(CGPoint)point offset:(CGPoint)offsetPoint subImageWidth:(GLfloat)subImageWidth 
			   subImageHeight:(GLfloat)subImageHeight centerOfImage:(BOOL)center;
- (void)renderSubImageAtPoint:(CGPoint)point rotationAngle:(float)rot offset:(CGPoint)offsetPoint subImageWidth:(GLfloat)subImageWidth 
			   subImageHeight:(GLfloat)subImageHeight centerOfImage:(BOOL)center red:(float)r green:(float)g blue:(float)b alpha:(float)a;
- (void)calculateVerticesAtPoint:(CGPoint)point subImageWidth:(GLuint)subImageWidth subImageHeight:(GLuint)subImageHeight centerOfImage:(BOOL)center;
- (void)calculateTexCoordsAtOffset:(CGPoint)offsetPoint subImageWidth:(GLuint)subImageWidth subImageHeight:(GLuint)subImageHeight;

// Setters
- (void)setColorFilterRed:(float)r green:(float)g blue:(float)b alpha:(float)a;
- (void)setAlpha:(float)alpha;


@end

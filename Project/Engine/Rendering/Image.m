//
//  Image.m
//  towerDefense
//
//  Created by Michael Daley on 03/15/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Image.h"
#import "GameState.h"

// private methods
@interface Image ()

- (void)initImpl;
- (void)renderAt:(CGPoint)point rotationAngle:(float)r texCoords:(Quad2*)tc quadVertices:(Quad2*)qv red:(float)r green:(float)g blue:(float)b alpha:(float)a;
@end

@implementation Image

@synthesize texture;
@synthesize	imageWidth;
@synthesize imageHeight;
@synthesize textureWidth;
@synthesize textureHeight;
@synthesize texWidthRatio;
@synthesize texHeightRatio;
@synthesize textureOffsetX;
@synthesize textureOffsetY;
@synthesize rotationAngle;
@synthesize scale;
@synthesize flipVertically;
@synthesize flipHorizontally;
@synthesize vertices;
@synthesize texCoords;

- (id)init
{
	return [self initWithTexture:nil];
}

-(id)initWithTexture:(Texture2D*)tex
{
	return [self initWithTexture:tex scale:1.0f];
}

-(id)initWithTexture:(Texture2D*)tex scale:(float)imageScale
{
	if(self = [super init])
	{
		texture = tex;
		[texture retain];
		scale = imageScale;
		[self initImpl];
	}
	return self;
}

-(id)initWithImage:(UIImage*)image
{
	return [self initWithImage:image filter:GL_NEAREST];
}
		
- (id)initWithImage:(UIImage *)image filter:(GLenum)filter
{
	return [self initWithImage:image scale:1.0f filter:filter];
}
	
- (id)initWithImage:(UIImage *)image scale:(float)imageScale
{
	return [self initWithImage:image scale:imageScale filter:GL_NEAREST];
}
	
- (id)initWithImage:(UIImage *)image scale:(float)imageScale filter:(GLenum)filter;
{
	if(self = [super init])
	{
		texture = [[Texture2D alloc] initWithImage:image filter:filter];
		scale = imageScale;
		[self initImpl];
	}
	return self;
}

- (void) initImpl
{
	imageWidth = texture.contentSize.width;
	imageHeight = texture.contentSize.height;
	textureWidth = texture.pixelsWide;
	textureHeight = texture.pixelsHigh;
	texMaxWidth = imageWidth/(float)textureWidth;
	texMaxHeight = imageHeight/(float)textureHeight;
	texWidthRatio = 1.0f/(float)textureWidth;
	texHeightRatio = 1.0f/(float)textureHeight;
	textureOffsetX = 0.0f;
	textureOffsetY = 0.0f;
	rotationAngle = 0.0f;
	flipVertically = NO;
	flipHorizontally = NO;
	rgba[0] = 1.0f;
	rgba[1] = 1.0f;
	rgba[2] = 1.0f;
	rgba[3] = 1.0f;
	
	// initialize application delegate
	appDelegate = (towerDefenseAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	// Init vertex arrays
	int totalQuads = 1;
	texCoords = malloc(sizeof(texCoords[0]) * totalQuads);
	vertices = malloc(sizeof(vertices[0]) * totalQuads);
	indices = malloc(sizeof(indices[0]) * totalQuads * 6);
	
	// fills arrays with zeros (be-zero!)
	bzero(texCoords, sizeof(texCoords[0]) * totalQuads);
	bzero(vertices, sizeof(vertices[0]) * totalQuads);
	bzero(indices, sizeof(indices[0]) * totalQuads * 6);
	
	for( NSUInteger i=0;i<totalQuads;i++) 
	{
		indices[i*6+0] = i*4+0;
		indices[i*6+1] = i*4+1;
		indices[i*6+2] = i*4+2;
		indices[i*6+5] = i*4+1;
		indices[i*6+4] = i*4+2;
		indices[i*6+3] = i*4+3;
	}
}

- (NSString*)description
{
	return [NSString stringWithFormat:@"texture:%d width:%lu height:%lu texWidth:%lu texHeight:%lu maxTexWidth:%f maxTexHeight:%f angle:%f scale:%f", [texture name], imageWidth, imageHeight, textureWidth, textureHeight, texMaxWidth, texMaxHeight, rotationAngle, scale];
}

- (Image*)getSubImageAtPoint:(CGPoint)point subImageWidth:(GLuint)subImageWidth subImageHeight:(GLuint)subImageHeight scale:(float) subImageScale
{
	// create a new Image instance using the texture which has been assigned to this image
	Image *subImage = [[Image alloc] initWithTexture:texture scale:subImageScale];
	
	// define the offset of the sub image using the provided data
	[subImage setTextureOffsetX:point.x];
	[subImage setTextureOffsetY:point.y];
	
	// define width and height of subimage based on provided data
	[subImage setImageWidth:subImageWidth];
	[subImage setImageHeight:subImageHeight];
	
	// set scale of subimage based on provided data
	[subImage setScale:subImageScale];
	
	// set rotation of subimage based on this image's rotation
	[subImage setRotationAngle:rotationAngle];
	
	return subImage;
}

- (void)calculateTexCoordsAtOffset:(CGPoint)offsetPoint subImageWidth:(GLuint)subImageWidth subImageHeight:(GLuint)subImageHeight 
{
	// Calculate the texture coordinates using the offset point from which to start the image and then using the width and height
	// passed in
	
	if(!flipHorizontally && !flipVertically) 
	{
		texCoords[0].br_x = texWidthRatio * subImageWidth + (texWidthRatio * offsetPoint.x);
		texCoords[0].br_y = texHeightRatio * offsetPoint.y;
		
		texCoords[0].tr_x = texWidthRatio * subImageWidth + (texWidthRatio * offsetPoint.x);
		texCoords[0].tr_y = texHeightRatio * subImageHeight + (texHeightRatio * offsetPoint.y);
		
		texCoords[0].bl_x = texWidthRatio * offsetPoint.x;
		texCoords[0].bl_y = texHeightRatio * offsetPoint.y;
		
		texCoords[0].tl_x = texWidthRatio * offsetPoint.x;
		texCoords[0].tl_y = texHeightRatio * subImageHeight + (texHeightRatio * offsetPoint.y);
		return;
	}
	
	if(flipVertically && flipHorizontally) 
	{
		texCoords[0].tl_x = texWidthRatio * subImageWidth + (texWidthRatio * offsetPoint.x);
		texCoords[0].tl_y = texHeightRatio * offsetPoint.y;
		
		texCoords[0].bl_x = texWidthRatio * subImageWidth + (texWidthRatio * offsetPoint.x);
		texCoords[0].bl_y = texHeightRatio * subImageHeight + (texHeightRatio * offsetPoint.y);
		
		texCoords[0].tr_x = texWidthRatio * offsetPoint.x;
		texCoords[0].tr_y = texHeightRatio * offsetPoint.y;
		
		texCoords[0].br_x = texWidthRatio * offsetPoint.x;
		texCoords[0].br_y = texHeightRatio * subImageHeight + (texHeightRatio * offsetPoint.y);
		return;
	}
	
	if(flipHorizontally) 
	{
		texCoords[0].bl_x = texWidthRatio * subImageWidth + (texWidthRatio * offsetPoint.x);
		texCoords[0].bl_y = texHeightRatio * offsetPoint.y;
		
		texCoords[0].tl_x = texWidthRatio * subImageWidth + (texWidthRatio * offsetPoint.x);
		texCoords[0].tl_y = texHeightRatio * subImageHeight + (texHeightRatio * offsetPoint.y);
		
		texCoords[0].br_x = texWidthRatio * offsetPoint.x;
		texCoords[0].br_y = texHeightRatio * offsetPoint.y;
		
		texCoords[0].tr_x = texWidthRatio * offsetPoint.x;
		texCoords[0].tr_y = texHeightRatio * subImageHeight + (texHeightRatio * offsetPoint.y);
		return;
	}
	
	if(flipVertically) 
	{
		texCoords[0].tr_x = texWidthRatio * subImageWidth + (texWidthRatio * offsetPoint.x);
		texCoords[0].tr_y = texHeightRatio * offsetPoint.y;
		
		texCoords[0].br_x = texWidthRatio * subImageWidth + (texWidthRatio * offsetPoint.x);
		texCoords[0].br_y = texHeightRatio * subImageHeight + (texHeightRatio * offsetPoint.y);
		
		texCoords[0].tl_x = texWidthRatio * offsetPoint.x;
		texCoords[0].tl_y = texHeightRatio * offsetPoint.y;
		
		texCoords[0].bl_x = texWidthRatio * offsetPoint.x;
		texCoords[0].bl_y = texHeightRatio * subImageHeight + (texHeightRatio * offsetPoint.y);
		return;
	}
	
	if(flipVertically && flipHorizontally) 
	{
		texCoords[0].tl_x = texWidthRatio * subImageWidth + (texWidthRatio * offsetPoint.x);
		texCoords[0].tl_y = texHeightRatio * offsetPoint.y;
		
		texCoords[0].bl_x = texWidthRatio * subImageWidth + (texWidthRatio * offsetPoint.x);
		texCoords[0].bl_y = texHeightRatio * subImageHeight + (texHeightRatio * offsetPoint.y);
		
		texCoords[0].tr_x = texWidthRatio * offsetPoint.x;
		texCoords[0].tr_y = texHeightRatio * offsetPoint.y;
		
		texCoords[0].br_x = texWidthRatio * offsetPoint.x;
		texCoords[0].br_y = texHeightRatio * subImageHeight + (texHeightRatio * offsetPoint.y);
		return;
	}
}


- (void)calculateVerticesAtPoint:(CGPoint)point subImageWidth:(GLuint)subImageWidth subImageHeight:(GLuint)subImageHeight centerOfImage:(BOOL)center 
{
	
	// Calculate the width and the height of the quad using the current image scale and the width and height
	// of the image we are going to render
	GLfloat quadWidth = subImageWidth * scale;
	GLfloat quadHeight = subImageHeight * scale;
	
	// Define the vertices for each corner of the quad which is going to contain our image.
	// We calculate the size of the quad to match the size of the subimage which has been defined.
	// If center is true, then make sure the point provided is in the center of the image else it will be
	// the bottom left hand corner of the image
	if(center) 
	{
		vertices[0].br_x = point.x + quadWidth / 2;
		vertices[0].br_y = point.y + quadHeight / 2;
		
		vertices[0].tr_x = point.x + quadWidth / 2;
		vertices[0].tr_y = point.y + -quadHeight / 2;
		
		vertices[0].bl_x = point.x + -quadWidth / 2;
		vertices[0].bl_y = point.y + quadHeight / 2;
		
		vertices[0].tl_x = point.x + -quadWidth / 2;
		vertices[0].tl_y = point.y + -quadHeight / 2;
	}
	else 
	{
		vertices[0].br_x = point.x + quadWidth;
		vertices[0].br_y = point.y + quadHeight;
		
		vertices[0].tr_x = point.x + quadWidth;
		vertices[0].tr_y = point.y;
		
		vertices[0].bl_x = point.x;
		vertices[0].bl_y = point.y + quadHeight;
		
		vertices[0].tl_x = point.x;
		vertices[0].tl_y = point.y;
	}				
}

-(void)renderAtPoint:(CGPoint)point centerOfImage:(BOOL)center
{
	[self renderAtPoint:point rotationAngle:rotationAngle centerOfImage:center];
}

-(void)renderAtPoint:(CGPoint)point rotationAngle:(float)rot centerOfImage:(BOOL)center
{
	[self renderAtPoint:point rotationAngle:rot centerOfImage:center alpha:rgba[3]];
}
-(void)renderAtPoint:(CGPoint)point rotationAngle:(float)rot centerOfImage:(BOOL)center alpha:(float)a
{
	[self renderAtPoint:point rotationAngle:rot centerOfImage:center red:rgba[0] green:rgba[1] blue:rgba[2] alpha:a];
}
-(void)renderAtPoint:(CGPoint)point rotationAngle:(float)rot centerOfImage:(BOOL)center red:(float)r green:(float)g blue:(float)b alpha:(float)a
{
	// use textureOffset for x and y along texture width and height
	CGPoint texOffsetPoint = CGPointMake(textureOffsetX, textureOffsetY);
	[self renderSubImageAtPoint:point rotationAngle:rot offset:texOffsetPoint subImageWidth:imageWidth 
				 subImageHeight:imageHeight centerOfImage:center red:r green:g blue:b alpha:a];
}

- (void)renderSubImageAtPoint:(CGPoint)point offset:(CGPoint)offsetPoint subImageWidth:(GLfloat)subImageWidth subImageHeight:(GLfloat)subImageHeight centerOfImage:(BOOL)center
{
		[self renderSubImageAtPoint:point rotationAngle:rotationAngle offset:offsetPoint subImageWidth:subImageWidth 
					 subImageHeight:subImageHeight centerOfImage:center red:rgba[0] green:rgba[1] blue:rgba[2] alpha:rgba[3]];
}

- (void)renderSubImageAtPoint:(CGPoint)point rotationAngle:(float)rot offset:(CGPoint)offsetPoint subImageWidth:(GLfloat)subImageWidth subImageHeight:(GLfloat)subImageHeight centerOfImage:(BOOL)center red:(float)r green:(float)g blue:(float)b alpha:(float)a;
{
	// Calculate the vertex and texture coordinate values for this image
	[self calculateVerticesAtPoint:point subImageWidth:subImageWidth subImageHeight:subImageHeight centerOfImage:center];
	[self calculateTexCoordsAtOffset:offsetPoint subImageWidth:subImageWidth subImageHeight:subImageHeight];
	
	// Now that we have defined the texture coordinates and the quad vertices we can render to the screen 
	// using them
	[self renderAt:point rotationAngle:rot texCoords:texCoords quadVertices:vertices red:r green:g blue:b alpha:a];
}

- (void)renderAt:(CGPoint)point rotationAngle:(float)rot texCoords:(Quad2*)tc quadVertices:(Quad2*)qv red:(float)r green:(float)g blue:(float)b alpha:(float)a
{
	// Save the current matrix to the stack
	glPushMatrix();
	
	// Rotate around the Z axis by the angle define for this image
	
	// move to the point of the image, rotate, and move back
	glTranslatef(point.x, point.y, 0);
	glRotatef(-rot, 0.0f, 0.0f, 1.0f);
	glTranslatef(-point.x, -point.y, 0);
	
	// Set the glColor to apply alpha to the image
	glColor4f(r, g, b, a);
	
	// Set client states so that the Texture Coordinate Array will be used during rendering
	glEnableClientState(GL_VERTEX_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	
	// Enable Texture_2D
	glEnable(GL_TEXTURE_2D);
	
	// Bind to the texture that is associated with this image.  This should only be done if the
	// texture is not currently bound
	
	// if we are using multiple images from one spritesheet, we only bind once to the hardware and
	// can just reference it from there
	
	// update the texture for the game state to ensure we don't rebind textures if we don't need to
	if([texture name] != [[GameState sharedGameStateInstance] currentlyBoundTexture])
	{
		[[GameState sharedGameStateInstance] setCurrentlyBoundTexture:[texture name]];
		glBindTexture(GL_TEXTURE_2D, [texture name]);
	}
	
	// Set up the VertexPointer to point to the vertices we have defined
	glVertexPointer(2, GL_FLOAT, 0, qv);
	
	// Set up the TexCoordPointer to point to the texture coordinates we want to use
	glTexCoordPointer(2, GL_FLOAT, 0, tc);
	
	// Enable blending as we want the transparent parts of the image to be transparent
	glEnable(GL_BLEND);
	
	// Setup how the images are to be blended when rendered.  The setup below is the most common
	// config and handles transparency in images
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	
	// Draw the vertices to the screen
	glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
	
	// Now we are done drawing disable blending
	glDisable(GL_BLEND);
	
	// Disable as necessary
	glDisable(GL_TEXTURE_2D);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	glDisableClientState(GL_VERTEX_ARRAY);
	
	// restore default colors
	glColor4f(1.0f,1.0f,1.0f,1.0f);
	// Restore the saved matrix from the stack
	glPopMatrix();
	
}

- (void)setColorFilterRed:(float)r green:(float)g blue:(float)b alpha:(float)a;
{
	rgba[0] = r;
	rgba[1] = g;
	rgba[2] = b;
	rgba[3] = a;
}

- (void)setAlpha:(float)alpha
{
	rgba[3] = alpha;
}

- (void)dealloc
{
	free(texCoords);
	free(vertices);
	free(indices);
	[texture release];
	[super dealloc];
}

@end

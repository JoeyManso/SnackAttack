//
//  ParticleEmitter.h
//  Tutorial1
//
//  Created by Michael Daley on 17/04/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
// The design and code for the ParticleEmitter were heavely influenced by the design and code
// used in Cocos2D for their particle system.

#import <Foundation/Foundation.h>
#import "Image.h"
#import "GameObject.h"
#import "GameState.h"

typedef struct _Color4f 
{
	GLfloat red;
	GLfloat green;
	GLfloat blue;
	GLfloat alpha;
} Color4f;

typedef struct _Vector2f 
{
	GLfloat x;
	GLfloat y;
} Vector2f;

typedef struct _Quad2f 
{
	GLfloat bl_x, bl_y;
	GLfloat br_x, br_y;
	GLfloat tl_x, tl_y;
	GLfloat tr_x, tr_y;
} Quad2f;

typedef struct _Particle 
{
	Vector2f position;
	Vector2f direction;
	Color4f color;
	Color4f deltaColor;
    GLfloat speed;
	GLfloat particleSize;
	GLfloat timeToLive;
} Particle;


typedef struct _PointSprite
{
	GLfloat x;
	GLfloat y;
	GLfloat size;
} PointSprite;


static inline Vector2f Vector2fMake(GLfloat x, GLfloat y)
{
	return (Vector2f) {x, y};
}

static inline Color4f Color4fMake(GLfloat red, GLfloat green, GLfloat blue, GLfloat alpha)
{
	return (Color4f) {red, green, blue, alpha};
}

static inline Vector2f Vector2fMultiply(Vector2f v, GLfloat s)
{
	return (Vector2f) {v.x * s, v.y * s};
}

static inline Vector2f Vector2fAdd(Vector2f v1, Vector2f v2)
{
	return (Vector2f) {v1.x + v2.x, v1.y + v2.y};
}

static inline Vector2f Vector2fSub(Vector2f v1, Vector2f v2)
{
	return (Vector2f) {v1.x - v2.x, v1.y - v2.y};
}
static inline GLfloat Vector2fDot(Vector2f v1, Vector2f v2)
{
	return (GLfloat) v1.x * v2.x + v1.y * v2.y;
}
static inline GLfloat Vector2fLength(Vector2f v)
{
	return (GLfloat) sqrtf(Vector2fDot(v, v));
}

static inline Vector2f Vector2fNormalize(Vector2f v)
{
	return Vector2fMultiply(v, 1.0f/Vector2fLength(v));
}

@interface ParticleEmitter : GameObject 
{
@private
    GameState *sharedGameState;
@public
	Image *texture;
	
	Point2D* sourcePosition;
	Point2D* sourcePositionVariance;
	GLfloat angle;
	GLfloat angleVariance;
	GLfloat speed;
	GLfloat speedVariance;
	Vector2D* gravity;
	GLfloat particleLifespan;
	GLfloat particleLifespanVariance;
	Color4f startColor;
	Color4f startColorVariance;
	Color4f finishColor;
	Color4f finishColorVariance;
	GLfloat particleSize;
	GLfloat particleSizeVariance;
	GLuint maxParticles;
	GLint particleCount;
	GLfloat emissionRate;
	GLfloat emitCounter;	
	GLuint verticesID;
	GLuint colorsID;	
	Particle *particles;
	PointSprite *vertices;
	Color4f *colors;
	BOOL active;
	GLint particleIndex;
	//	BOOL useTexture;
	GLfloat elapsedTime;
	GLfloat duration;
	BOOL blendAdditive;
}

@property(nonatomic, retain) Image *texture;
@property(nonatomic, copy) Point2D* sourcePosition;
@property(nonatomic, copy) Point2D* sourcePositionVariance;
@property(nonatomic, assign) GLfloat angle;
@property(nonatomic, assign) GLfloat angleVariance;
@property(nonatomic, assign) GLfloat speed;
@property(nonatomic, assign) GLfloat speedVariance;
@property(nonatomic, copy) Vector2D* gravity;
@property(nonatomic, assign) GLfloat particleLifespan;
@property(nonatomic, assign) GLfloat particleLifespanVariance;
@property(nonatomic, assign) Color4f startColor;
@property(nonatomic, assign) Color4f startColorVariance;
@property(nonatomic, assign) Color4f finishColor;
@property(nonatomic, assign) Color4f finishColorVariance;
@property(nonatomic, assign) GLfloat particleSize;
@property(nonatomic, assign) GLfloat particleSizeVariance;
@property(nonatomic, assign) GLuint maxParticles;
@property(nonatomic, assign) GLint particleCount;
@property(nonatomic, assign) GLfloat emissionRate;
@property(nonatomic, assign) GLfloat emitCounter;
@property(nonatomic, assign) BOOL active;
@property(nonatomic, assign) GLfloat duration;
@property(nonatomic, assign) BOOL blendAdditive;

- (id)initParticleEmitterWithImageNamed:(NSString*)inTextureName
							   position:(Point2D*)inPosition 
				 sourcePositionVariance:(Point2D*)inSourcePositionVariance
								  speed:(GLfloat)inSpeed
						  speedVariance:(GLfloat)inSpeedVariance 
					   particleLifeSpan:(GLfloat)inParticleLifeSpan
			   particleLifespanVariance:(GLfloat)inParticleLifeSpanVariance 
								  angle:(GLfloat)inAngle 
						  angleVariance:(GLfloat)inAngleVariance 
								gravity:(Vector2D*)inGravity
							 startColor:(Color4f)inStartColor 
					 startColorVariance:(Color4f)inStartColorVariance
							finishColor:(Color4f)inFinishColor 
					finishColorVariance:(Color4f)inFinishColorVariance
						   maxParticles:(GLuint)inMaxParticles 
						   particleSize:(GLfloat)inParticleSize
				   particleSizeVariance:(GLfloat)inParticleSizeVariance
							   duration:(GLfloat)inDuration
						  blendAdditive:(BOOL)inBlendAdditive;

- (void)initParticle:(Particle*)particle;
- (void)stopParticleEmitter;
- (void)startParticleEmitter:(float)timeToLive;

@end

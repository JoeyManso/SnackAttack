//
//  UITools.h
//  towerDefense
//
//  Created by Joey Manso on 8/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIObject.h"
#import <OpenGLES/ES1/gl.h>

// this class is for UI tools we might need (Buttons, status bars, etc)

@class Image;

@interface Button : UIObject 
{
	Image *buttonImage;
	BOOL active;
	float currentRGB[3];
	NSString *clickSoundKey;
}
@property(nonatomic)BOOL active;
-(id)initWithImage:(Image*)i position:(Point2D*)p;
-(id)initWithImage:(Image*)i position:(Point2D*)p clickSoundKey:(NSString*)soundKey;
-(void)replaceWithImage:(Image*)i;
@end

@interface MenuButton : Button 
{
	int menuButtonType;
}
@property(nonatomic)int menuButtonType;
-(id)initWithImage:(Image*)i position:(Point2D*)p type:(uint)t;
@end

@class AngelCodeFont;

@interface Text : UIObject
{
	@private
	NSString *string;
	NSMutableString *textToDisplay;
	AngelCodeFont *fontDisplay;
}
-(id)initWithString:(NSString*)s position:(Point2D*)p fontName:(NSString*)font;

-(void)setText:(NSString*)t;
-(void)setAlpha:(float)alpha;
-(void)append_uint:(uint)u;
-(void)append_float:(float)f;
-(void)append_divisor:(uint)current max:(uint)max; 
@end

@interface StatusBar : UIObject
{
	float fillRatio; // value between 0 and 1 for how much to fill the bar
	float height;
	float width;
	
	@private
	GLfloat xScale;
	GLfloat yScale;
	BOOL colorChanges;
	float rgba_start[4]; // rgba for when bar is full and empty respectively
	float rgba_end[4];
	float rgba_current[4];
	
}
@property(nonatomic)float fillRatio;
@property(nonatomic, readonly)float height;
@property(nonatomic, readonly)float width;

-(id)initWithPosition:(Point2D*)p height:(float)h width:(float)w;
-(void)setColorsStartRed:(float)sR startGreen:(float)sG startBlue:(float)sB startAlpha:(float)sA
				  endRed:(float)eR endGreen:(float)eG endBlue:(float)eB endAlpha:(float)eA;

@end



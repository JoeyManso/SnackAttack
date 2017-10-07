//
//  UITools.m
//  towerDefense
//
//  Created by Joey Manso on 8/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "UITools.h"
#import "AngelCodeFont.h"
#import "Image.h"
#import "SoundManager.h"
#import "GameState.h"

static SoundManager *soundMan;
@interface Button()
-(CGRect)getControlBounds;
@end

@implementation Button

@synthesize active;

-(id)initWithImage:(Image*)i position:(Point2D*)p
{
	return [self initWithImage:i position:p clickSoundKey:@"Cancel"];
}
-(id)initWithImage:(Image*)i position:(Point2D*)p clickSoundKey:(NSString*)soundKey
{
	if(self = [super initWithPosition:p])
	{
		if(!soundMan)
			soundMan = [SoundManager getInstance];
		buttonImage = i;
		active = YES;
		clickSoundKey = soundKey;
	}
	return self;
}
-(void)replaceWithImage:(Image*)i
{
	if(buttonImage)
		[buttonImage dealloc];
	buttonImage = i;
}
-(CGRect)getControlBounds
{
	return CGRectMake(UIObjectPosition.x - (([buttonImage imageWidth] * UIObjectScale * 0.5f)+10.0f), 
					  UIObjectPosition.y - ([buttonImage imageHeight] * UIObjectScale * 0.5f)-10.0f, 
					  [buttonImage imageWidth] * UIObjectScale + 20.0f, 
					  [buttonImage imageHeight] * UIObjectScale + 20.0f);
}
-(BOOL)respondToTouchAt:(CGPoint)touchPosition
{
	if(active)
	{		
		if(CGRectContainsPoint([self getControlBounds], touchPosition))
		{
			[self playScaleAnimation];
			if(clickSoundKey)
				[soundMan playSoundWithKey:clickSoundKey gain:1.0f pitch:1.0f shouldLoop:NO];
			return YES;
		}
	}
	return NO;
}
-(void)setUIObjectScale:(float)s
{
	[buttonImage setScale:s];
	[super setUIObjectScale:s];
}
-(void)drawUIObject
{
	if([[GameState sharedGameStateInstance] debugMode])
	{
		CGRect box = [self getControlBounds];
		
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
	
	if(!active)
		[buttonImage renderAtPoint:CGPointMake(UIObjectPosition.x, UIObjectPosition.y) rotationAngle:[buttonImage rotationAngle] centerOfImage:YES alpha:0.35f];
	else
		[buttonImage renderAtPoint:CGPointMake(UIObjectPosition.x, UIObjectPosition.y) centerOfImage:YES];
}
-(void)dealloc
{
	[buttonImage dealloc];
	[super dealloc];
}

@end

@implementation MenuButton

@synthesize menuButtonType;

-(id)initWithImage:(Image*)i position:(Point2D*)p
{
	return [self initWithImage:i position:p type:99];
}
-(id)initWithImage:(Image*)i position:(Point2D*)p type:(uint)t
{
	if(self = [super initWithImage:i position:p])
	{
		shouldAnimate = NO;
		menuButtonType = t;
	}
	return self;
}

@end


@implementation Text

-(id)initWithString:(NSString*)s position:(Point2D*)p fontName:(NSString*)font
{
	if(self = [super initWithPosition:p])
	{
		string = s;
		textToDisplay = [[NSMutableString alloc] initWithString:string];
		fontDisplay = [[AngelCodeFont alloc] initWithFontImageNamed:[font stringByAppendingString:@".png"] controlFile:font scale:UIObjectScale filter:GL_NEAREST];
	}
	return self;
}
-(void)setUIObjectScale:(float)s
{
	[fontDisplay setScale:s];
	[super setUIObjectScale:s];
}
-(void)setText:(NSString*)t
{
	[self playScaleAnimation];
	if(t)
		string = t;
	else
		string = @"";
	[textToDisplay setString:string];
}
-(void)setAlpha:(float)alpha
{
	[fontDisplay setAlpha:alpha];
}
-(void)append_uint:(uint)u
{
	[self playScaleAnimation];
	[textToDisplay setString:string];
	[textToDisplay appendFormat:@"%u",u];
}
-(void)append_float:(float)f
{
	[self playScaleAnimation];
	[textToDisplay setString:string];
	[textToDisplay appendFormat:@"%.1f",f];
}
-(void)append_divisor:(uint)current max:(uint)max
{
	[self playScaleAnimation];
	[textToDisplay setString:string];
	[textToDisplay appendFormat:@"%u/%u",current,max];
}
-(void)drawUIObject
{
	[self drawUIObjectAtPoint:UIObjectPosition];
}
-(void)drawUIObjectAtPoint:(Point2D*)p
{
	[fontDisplay drawStringAt:CGPointMake(p.x,p.y) text:textToDisplay];
}
-(void)drawUIObjectAtCGPoint:(CGPoint)p
{
	[fontDisplay drawStringAt:p text:textToDisplay];
}
-(void)dealloc
{
	[textToDisplay dealloc];
	[super dealloc];
}

@end

@interface StatusBar()
-(void)setScaleValues;
@end


@implementation StatusBar

@synthesize fillRatio;
@synthesize height;
@synthesize width;

float const outlineGap = 1.0f; // space between fill area and outline

-(id)initWithPosition:(Point2D*)p height:(float)h width:(float)w
{
	if(self = [super initWithPosition:p])
	{
		fillRatio = 1.0f;
		height = h;
		width = w;
		
		// default rgba values
		rgba_current[0] = 0.1f;
		rgba_current[1] = 0.1f;
		rgba_current[2] = 0.55f;
		rgba_current[3] = 1.0f;
		
		colorChanges = NO;
		
		[self setScaleValues];
	}
	return self;
}
-(void)setUIObjectScale:(float)s
{
	[super setUIObjectScale:s];
	[self setScaleValues];
}
-(void)setFillRatio:(float)ratio
{
	fillRatio = ratio;
	if(colorChanges)
	{
		rgba_current[0] = rgba_start[0] - ((rgba_start[0] - rgba_end[0]) * (1.0f - fillRatio));
		rgba_current[1] = rgba_start[1] - ((rgba_start[1] - rgba_end[1]) * (1.0f - fillRatio));
		rgba_current[2] = rgba_start[2] - ((rgba_start[2] - rgba_end[2]) * (1.0f - fillRatio));
		rgba_current[3] = rgba_start[3] - ((rgba_start[3] - rgba_end[3]) * (1.0f - fillRatio));
	}
}
-(void)setScaleValues
{
	// this is so we scale from the middle
	xScale = 0.5f * width * UIObjectScale;
	yScale = 0.5f * height * UIObjectScale;
}
-(void)setColorsStartRed:(float)sR startGreen:(float)sG startBlue:(float)sB startAlpha:(float)sA
				  endRed:(float)eR endGreen:(float)eG endBlue:(float)eB endAlpha:(float)eA
{
	rgba_start[0] = rgba_current[0] = sR;
	rgba_start[1] = rgba_current[1] = sG;
	rgba_start[2] = rgba_current[2] = sB;
	rgba_start[3] = rgba_current[3] = sA;
	
	rgba_end[0] = eR;
	rgba_end[1] = eG;
	rgba_end[2] = eB;
	rgba_end[3] = eA;
	
	colorChanges = YES;
}
-(void)drawUIObject
{
	GLfloat const fillBar[8] = 
	{
		UIObjectPosition.x - xScale,									 UIObjectPosition.y - yScale,
		UIObjectPosition.x - xScale,									 UIObjectPosition.y + yScale,
		UIObjectPosition.x - xScale + width * fillRatio * UIObjectScale, UIObjectPosition.y + yScale,
		UIObjectPosition.x - xScale + width * fillRatio * UIObjectScale, UIObjectPosition.y - yScale
	};
	
	GLfloat const outlineBar[8] =
	{
		UIObjectPosition.x - xScale - outlineGap, UIObjectPosition.y - yScale - outlineGap,
		UIObjectPosition.x - xScale - outlineGap, UIObjectPosition.y + yScale + outlineGap,
		UIObjectPosition.x + xScale + outlineGap, UIObjectPosition.y + yScale + outlineGap,
		UIObjectPosition.x + xScale + outlineGap, UIObjectPosition.y - yScale - outlineGap
	};
	
	//and we will use GL_TRIANGLE_FAN to draw the bar.
	glPushMatrix();
	glEnable(GL_BLEND);
	glEnableClientState(GL_VERTEX_ARRAY);
	
	glColor4f(rgba_current[0], rgba_current[1], rgba_current[2], rgba_current[3]);
	glVertexPointer(2, GL_FLOAT, 0, fillBar);
	glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
	
	glColor4f(1.0f, 1.0f, 1.0f, 1.0f); // white outline
	glVertexPointer(2, GL_FLOAT, 0, outlineBar);
	glDrawArrays(GL_LINE_LOOP, 0, 4);
	
	glDisable(GL_BLEND);
	glDisableClientState(GL_VERTEX_ARRAY);
	glPopMatrix();
}
@end



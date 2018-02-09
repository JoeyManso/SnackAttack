//
//  TextScreen.m
//  towerDefense
//
//  Created by Joey Manso on 9/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ViewManager.h"
#import "TextView.h"
#import "Image.h"

@implementation TextView

const float DECEL_RATE = 0.9f;

-(id)initWithTitle:(Image*)titleImage images:(NSMutableArray*)imagesArray background:(Image*)backgroundImage backgroundMaskLower:(Image*)maskImageLower backgroundMaskUpper:(Image*)maskImageUpper
{
	if(self = [super init])
	{
        float baseXPos = 0;//(320.0f - screenBounds.size.width) / 2.0f;
        float baseYPos = 0;//(568.0f - screenBounds.size.height) / 2.0f;
        float maskBounds = 70.0f;
        float textImagesHeight = 0.0f;
		textImages = imagesArray;
		for(Image *i in textImages)
        {
			textImagesHeight += (float)[i imageHeight];
        }
        
        float textSpace = (screenBounds.size.height - (maskBounds * 2));
		if(textImagesHeight < textSpace)
        {
            textMinYPos = maskBounds + ((textSpace - textImagesHeight) / 2);
			textMaxYPos = textMinYPos;
        }
        else
        {
            // minimum y position based off total height of images
            textMinYPos = (screenBounds.size.height - maskBounds) - textImagesHeight;
            textMaxYPos = fmaxf(maskBounds, textMinYPos);
        }
        
        textMinYPos += baseYPos;
        textMaxYPos += baseYPos;
        
		textTitle = titleImage;
		textBackground	= backgroundImage;
		textBackgroundMaskLower = maskImageLower;
        textBackgroundMaskUpper = maskImageUpper;
		textDisplayPoint = CGPointMake(baseXPos + 20.0f, textMinYPos);
		titleDisplayPoint = CGPointMake(baseXPos + (screenBounds.size.width / 2),
                                        baseYPos + (screenBounds.size.height - 50.0f));
		backgroundDisplayPointLower = CGPointMake(baseXPos, baseYPos);
        backgroundDisplayPointUpper = CGPointMake(baseXPos,
                                                  baseYPos + (screenBounds.size.height - [maskImageUpper imageHeight]));
		lastTouchedY = touchY = 0.0f;
		heightOffset = 0;
		backButton = [[MenuButton alloc] initWithImage:[[Image alloc] initWithImage:[UIImage imageNamed:@"ButtonBack.png"]  filter:GL_LINEAR] 
											  position:[[Point2D alloc]
                                                        initWithX:baseXPos + (screenBounds.size.width / 2)
                                                        y:baseYPos + 48.0f]
                                                  type:99];
		scrollSpeed = 0.0f;
		isTouching = NO;
	}
	return self;
}

-(void)updateWithTouchLocationBegan:(NSSet*)touches withEvent:(UIEvent*)event withView:(UIView*)view
{
	isTouching = YES;
	UITouch* t = [touches anyObject];
	CGPoint touchPosition = [t locationInView:view];
	// for some reason, OpenGL coordinates are reversed vertically from the touch events, so we have to do this
	touchPosition.y = screenBounds.size.height - touchPosition.y;
	touchY = touchPosition.y;
	
}
-(void)updateWithTouchLocationMoved:(NSSet*)touches withEvent:(UIEvent*)event withView:(UIView*)view
{
	// check if the image is big enough to be moved at all
	if(textMinYPos < 0.0f)
	{
		UITouch* t = [touches anyObject];
		CGPoint touchPosition = [t locationInView:view];
		// for some reason, OpenGL coordinates are reversed vertically from the touch events, so we have to do this
		touchPosition.y = screenBounds.size.height - touchPosition.y;
		
		textDisplayPoint.y +=  touchPosition.y - lastTouchedY;
		touchY = touchPosition.y;
	}
}
-(void)updateWithTouchLocationEnded:(NSSet*)touches withEvent:(UIEvent*)event withView:(UIView*)view
{
	UITouch* t = [touches anyObject];
	CGPoint touchPosition = [t locationInView:view];
	// for some reason, OpenGL coordinates are reversed vertically from the touch events, so we have to do this
	touchPosition.y = screenBounds.size.height - touchPosition.y;
	isTouching = NO;

	if([backButton respondToTouchAt:touchPosition])
	{
		scrollSpeed = 0.0f;
		textDisplayPoint.y = textMinYPos;
		[[ViewManager getInstance] showMainMenu];
	}
}

-(void)updateView:(float)deltaTime
{
	if(!isTouching)
		textDisplayPoint.y += (scrollSpeed * deltaTime);
	else
	{
		scrollSpeed = touchY - lastTouchedY;
		scrollSpeed *= 35.0f;
		if(scrollSpeed < 5.0f && scrollSpeed > -5.0f)
			scrollSpeed = 0.0f;
	}
	lastTouchedY = touchY; // for getting accurate relative positions

	scrollSpeed *= DECEL_RATE;
	if(textDisplayPoint.y > textMaxYPos)
		textDisplayPoint.y = textMaxYPos;
	else if(textDisplayPoint.y < textMinYPos)
		textDisplayPoint.y = textMinYPos;
	[super updateView:deltaTime];
}
-(void)drawView
{	
	[textBackground renderAtPoint:backgroundDisplayPointLower centerOfImage:NO];
	for(Image *i in textImages)
	{
		[i renderAtPoint:CGPointMake(textDisplayPoint.x,textDisplayPoint.y+heightOffset) centerOfImage:NO];
		heightOffset += [i imageHeight];
	}
	[textBackgroundMaskLower renderAtPoint:backgroundDisplayPointLower centerOfImage:NO];
    [textBackgroundMaskUpper renderAtPoint:backgroundDisplayPointUpper centerOfImage:NO];
	[textTitle renderAtPoint:titleDisplayPoint centerOfImage:YES];
	[backButton drawUIObject];
	heightOffset = 0;
}

-(void)dealloc
{
	for(Image *i in textImages)
		[i release];
	[textImages release];
	[backButton dealloc];
	[textTitle dealloc];
	[super dealloc];
}


@end

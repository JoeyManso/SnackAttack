//
//  MenuView.m
//  towerDefense
//
//  Created by Joey Manso on 9/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ViewManager.h"
#import "MapSelectView.h"
#import "Image.h"
#import "UITools.h"

@implementation MapSelectView

-(id)initWithTitle:(Image*)titleImage background:(Image*)backgroundImage backgroundMaskLower:(Image*)maskImageLower backgroundMaskUpper:(Image*)maskImageUpper
{
	if(self = [super init])
	{
        float baseXPos = 0;//(320.0f - screenBounds.size.width) / 2.0f;
        float baseYPos = 0;//(568.0f - screenBounds.size.height) / 2.0f;
        float yScale = (screenBounds.size.height / 568.0f);
        
		menuTitle = titleImage;
		menuBackground	= backgroundImage;
        menuBackgroundMaskLower	= maskImageLower;
        menuBackgroundMaskUpper	= maskImageUpper;
        menuBackground	= backgroundImage;
		menuDisplayPoint = CGPointMake(0.0f,0.0f);
        backgroundDisplayPointLower = CGPointMake(0.0f,0.0f);
        backgroundDisplayPointUpper = CGPointMake(0.0f,
                                                  screenBounds.size.height - [maskImageUpper imageHeight]);
		titleDisplayPoint = CGPointMake(screenBounds.size.width / 2, screenBounds.size.height - 50.0f);
        
        backButton = [[MenuButton alloc] initWithImage:[[Image alloc] initWithImage:[UIImage imageNamed:@"ButtonBack.png"]  filter:GL_LINEAR]
                                              position:[[Point2D alloc]
                                                        initWithX:baseXPos + (screenBounds.size.width / 2)
                                                        y:baseYPos + 48.0f]
                                                  type:99];
        
        startButton = [[MenuButton alloc] initWithImage:[[Image alloc] initWithImage:[UIImage imageNamed:@"ButtonStartBig.png"]  filter:GL_LINEAR]
                                              position:[[Point2D alloc]
                                                        initWithX:baseXPos + (screenBounds.size.width / 2)
                                                        y:baseYPos + 92.0f]
                                                  type:99];
        
        arrowLeftButton = [[MenuButton alloc] initWithImage:[[Image alloc] initWithImage:[UIImage imageNamed:@"ButtonArrowLeft"]  filter:GL_LINEAR]
                                              position:[[Point2D alloc]
                                                        initWithX:baseXPos + 32.0f
                                                        y:baseYPos + (screenBounds.size.height / 2) + 32.0f]
                                                  type:99];
        
        arrowRightButton = [[MenuButton alloc] initWithImage:[[Image alloc] initWithImage:[UIImage imageNamed:@"ButtonArrowRight"]  filter:GL_LINEAR]
                                              position:[[Point2D alloc]
                                                        initWithX:screenBounds.size.width - (baseXPos + 32.0f)
                                                        y:baseYPos + (screenBounds.size.height / 2) + 32.0f]
                                                  type:99];
        
        mapImages = [[NSMutableArray alloc] initWithObjects:
                     [[Image alloc] initWithImage:[UIImage imageNamed:@"map1.png"] scale:0.5f * yScale],
                     [[Image alloc] initWithImage:[UIImage imageNamed:@"map2.png"] scale:0.5f * yScale],
                     [[Image alloc] initWithImage:[UIImage imageNamed:@"map3.png"] scale:0.5f * yScale], nil];
        
        targetMapIdx = 0;
        scrollPadding = screenBounds.size.width * 1.15f;
        scrollPaddingTotal = scrollPadding * (mapImages.count-1);
        scrollSpeed = 1000.0f;
        isScrolling = NO;
        
        for(int i=0; i < mapImages.count; ++i)
        {
            float x = [self getLoopedX:(screenBounds.size.width / 2) + (scrollPadding * i)];
            CGPoint p = CGPointMake(x,
                                    screenBounds.size.height / 2 + 32.0f);
            mapDisplayPoints[i] = p;
            
            
        }
	}
	return self;
}

-(float)getLoopedX:(float)x
{
    if(x <= (screenBounds.size.width / 2) - scrollPaddingTotal * 0.95)
    {
        x += scrollPaddingTotal + scrollPadding;
    }
    else if(x >= (screenBounds.size.width / 2) + scrollPaddingTotal * 0.95)
    {
        x -= scrollPaddingTotal + scrollPadding;
    }
    return x;
}

-(void)incTargetMapIdx
{
    if(!isScrolling)
    {
        targetMapIdx = (targetMapIdx == (mapImages.count-1) ? 0 : targetMapIdx+1);
    }
}
-(void)decTargetMapIdx
{
    if(!isScrolling)
    {
        targetMapIdx = (targetMapIdx == 0 ? (int)mapImages.count - 1 : targetMapIdx-1);
    }
}

-(void)updateView:(float)deltaTime
{
    float targetX = (screenBounds.size.width / 2);
    if(mapDisplayPoints[targetMapIdx].x != targetX)
    {
        isScrolling = true;
        float scrollDir = targetX > mapDisplayPoints[targetMapIdx].x ? 1.0f : -1.0f;
        float deltaX = scrollDir * fminf(scrollSpeed * deltaTime,
                                         fabs(mapDisplayPoints[targetMapIdx].x - targetX));
        for(int i=0; i < mapImages.count; ++i)
        {
            mapDisplayPoints[i].x = [self getLoopedX:(mapDisplayPoints[i].x + deltaX)];
        }
    }
    else
    {
        isScrolling = false;
    }

    [super updateView:deltaTime];
}

-(void)updateWithTouchLocationBegan:(NSSet*)touches withEvent:(UIEvent*)event withView:(UIView*)view
{
    UITouch* t = [touches anyObject];
    CGPoint touchPosition = [t locationInView:view];

    touchXStart = touchPosition.x;
}
-(void)updateWithTouchLocationMoved:(NSSet*)touches withEvent:(UIEvent*)event withView:(UIView*)view
{
    UITouch* t = [touches anyObject];
    CGPoint touchPosition = [t locationInView:view];
    
    if(touchPosition.x - touchXStart > screenBounds.size.width * 0.15f)
    {
        [self decTargetMapIdx];
        touchXStart = touchPosition.x;
    }
    else if(touchPosition.x - touchXStart < screenBounds.size.width * -0.15f)
    {
        [self incTargetMapIdx];
        touchXStart = touchPosition.x;
    }
}
-(void)updateWithTouchLocationEnded:(NSSet*)touches withEvent:(UIEvent*)event withView:(UIView*)view
{
	UITouch* t = [touches anyObject];
	CGPoint touchPosition = [t locationInView:view];
	// for some reason, OpenGL coordinates are reversed vertically from the touch events, so we have to do this
	touchPosition.y = screenBounds.size.height - touchPosition.y;
	
    if([arrowLeftButton respondToTouchAt:touchPosition])
    {
        [self incTargetMapIdx];
    }
    else if([arrowRightButton respondToTouchAt:touchPosition])
    {
        [self decTargetMapIdx];
    }
    else if([startButton respondToTouchAt:touchPosition])
    {
        [[ViewManager getInstance] setGameMapIdx:targetMapIdx];
        [[ViewManager getInstance] newGame];
    }
    else if([backButton respondToTouchAt:touchPosition])
    {
        [[ViewManager getInstance] showMainMenu];
    }
}

-(void)drawView
{	
	[menuBackground renderAtPoint:menuDisplayPoint centerOfImage:NO];
    
    for(int i=0; i < mapImages.count; ++i)
    {
        Image* map = mapImages[i];
        [map renderAtPoint:mapDisplayPoints[i] centerOfImage:YES];
    }
    
    [menuBackgroundMaskLower renderAtPoint:backgroundDisplayPointLower centerOfImage:NO];
    [menuBackgroundMaskUpper renderAtPoint:backgroundDisplayPointUpper centerOfImage:NO];
    [menuTitle renderAtPoint:titleDisplayPoint centerOfImage:YES];
    [backButton drawUIObject];
    [startButton drawUIObject];
    [arrowLeftButton drawUIObject];
    [arrowRightButton drawUIObject];
}

-(void)dealloc
{
    for(Image *i in mapImages)
        [i release];
    [mapImages release];
    [backButton dealloc];
    [startButton dealloc];
	[menuTitle dealloc];
	[super dealloc];
}

@end

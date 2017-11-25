//
//  MenuView.m
//  towerDefense
//
//  Created by Joey Manso on 9/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ViewManager.h"
#import "MenuView.h"
#import "Image.h"
#import "UITools.h"

@implementation MenuView

-(id)initWithTitle:(Image*)titleImage background:(Image*)backgroundImage backgroundMaskLower:(Image*)maskImageLower backgroundMaskUpper:(Image*)maskImageUpper
{
	if(self = [super init])
	{
		menuTitle = titleImage;
		menuButtons = [[NSMutableArray alloc] init];
		menuBackground	= backgroundImage;
        menuBackgroundMaskLower	= maskImageLower;
        menuBackgroundMaskUpper	= maskImageUpper;
        menuBackground	= backgroundImage;
		menuDisplayPoint = CGPointMake(0.0f,0.0f);
        backgroundDisplayPointLower = CGPointMake(0.0f,0.0f);
        backgroundDisplayPointUpper = CGPointMake(0.0f,
                                                  screenBounds.size.height - [maskImageUpper imageHeight]);
		titleDisplayPoint = CGPointMake(screenBounds.size.width / 2, screenBounds.size.height - 50.0f);
	}
	return self;
}
-(void)addButton:(MenuButton*)button
{
	[menuButtons addObject:button];
}

-(void)updateView:(float)deltaTime
{
	for(MenuButton *b in menuButtons)
		[b updateUIObject:deltaTime];
}

-(void)updateWithTouchLocationBegan:(NSSet*)touches withEvent:(UIEvent*)event withView:(UIView*)view
{
}
-(void)updateWithTouchLocationMoved:(NSSet*)touches withEvent:(UIEvent*)event withView:(UIView*)view
{
}
-(void)updateWithTouchLocationEnded:(NSSet*)touches withEvent:(UIEvent*)event withView:(UIView*)view
{
	UITouch* t = [touches anyObject];
	CGPoint touchPosition = [t locationInView:view];
	// for some reason, OpenGL coordinates are reversed vertically from the touch events, so we have to do this
	touchPosition.y = screenBounds.size.height - touchPosition.y;
	
	for(MenuButton *b in menuButtons)
	{
		if([b respondToTouchAt:touchPosition])
		{
			switch([b menuButtonType])
			{
				case MENU_BUTTON_RESUME:
					[[ViewManager getInstance] resumeGame];
					break;
				case MENU_BUTTON_NEWGAME:
					[[ViewManager getInstance] newGame];
					break;
				case MENU_BUTTON_INSTRUCTIONS:
					[[ViewManager getInstance] showInstructions];
					break;
				case MENU_BUTTON_CREDITS:
					[[ViewManager getInstance] showCredits];
					break;
				default:
					break;
			}
			break;
		}
	}
}

-(void)drawView
{	
	[menuBackground renderAtPoint:menuDisplayPoint centerOfImage:NO];
	for(MenuButton *b in menuButtons)
		[b drawUIObject];
    
    [menuBackgroundMaskLower renderAtPoint:backgroundDisplayPointLower centerOfImage:NO];
    [menuBackgroundMaskUpper renderAtPoint:backgroundDisplayPointUpper centerOfImage:NO];
    [menuTitle renderAtPoint:titleDisplayPoint centerOfImage:YES];
}

-(void)dealloc
{
	for(MenuButton *b in menuButtons)
		[b release];
	[menuButtons release];
	[menuTitle dealloc];
	[super dealloc];
}

@end

//
//  MenuView.h
//  towerDefense
//
//  Created by Joey Manso on 9/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BaseView.h"
#import "UITools.h"

enum
{
	MENU_BUTTON_NEWGAME,
	MENU_BUTTON_RESUME,
	MENU_BUTTON_INSTRUCTIONS,
	MENU_BUTTON_CREDITS
};

@interface MenuView : BaseView 
{
	Image *menuTitle;
	Image *menuBackground;
    Image *menuBackgroundMaskLower;
    Image *menuBackgroundMaskUpper;
	NSMutableArray *menuButtons;
	
	CGPoint menuDisplayPoint;
    CGPoint backgroundDisplayPointLower;
    CGPoint backgroundDisplayPointUpper;
	CGPoint titleDisplayPoint;
}
-(id)initWithTitle:(Image*)titleImage background:(Image*)backgroundImage backgroundMaskLower:(Image*)maskImageLower backgroundMaskUpper:(Image*)maskImageUpper;
-(void)addButton:(MenuButton*)button;

@end

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
	NSMutableArray *menuButtons;
	
	CGPoint menuDisplayPoint;
	CGPoint titleDisplayPoint;
}
-(id)initWithTitle:(Image*)titleImage background:(Image*)backgroundImage;
-(void)addButton:(MenuButton*)button;

@end

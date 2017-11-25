//
//  TextScreen.h
//  towerDefense
//
//  Created by Joey Manso on 9/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseView.h"
#import "UITools.h"

@interface TextView : BaseView
{
@private
	float textMinYPos,textMaxYPos, lastTouchedY, touchY;
	int heightOffset;
	
	Image *textTitle;
	NSMutableArray *textImages;
	Image *textBackground;
	Image *textBackgroundMaskLower;
    Image *textBackgroundMaskUpper;
	MenuButton *backButton;
	float scrollSpeed;
	BOOL isTouching;
	
	CGPoint titleDisplayPoint;
	CGPoint textDisplayPoint;
	CGPoint backgroundDisplayPointLower;
    CGPoint backgroundDisplayPointUpper;
}
-(id)initWithTitle:(Image*)titleImage images:(NSMutableArray*)imagesArray background:(Image*)backgroundImage backgroundMaskLower:(Image*)maskImageLower backgroundMaskUpper:(Image*)maskImageUpper;

@end

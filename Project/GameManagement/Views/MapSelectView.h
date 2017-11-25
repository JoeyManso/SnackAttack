//
//  MenuView.h
//  towerDefense
//
//  Created by Joey Manso on 9/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BaseView.h"
#import "UITools.h"

@interface MapSelectView : BaseView
{
	Image *menuTitle;
	Image *menuBackground;
    Image *menuBackgroundMaskLower;
    Image *menuBackgroundMaskUpper;
    MenuButton *backButton;
    MenuButton *startButton;
    MenuButton *arrowLeftButton;
    MenuButton *arrowRightButton;
    NSMutableArray *mapImages;
    CGPoint mapDisplayPoints[3];
    int targetMapIdx;
	
	CGPoint menuDisplayPoint;
    CGPoint backgroundDisplayPointLower;
    CGPoint backgroundDisplayPointUpper;
	CGPoint titleDisplayPoint;
    
    float scrollPadding;
    float scrollPaddingTotal;
    float scrollSpeed;
    BOOL isScrolling;
    float touchXStart;
}
-(id)initWithTitle:(Image*)titleImage background:(Image*)backgroundImage backgroundMaskLower:(Image*)maskImageLower backgroundMaskUpper:(Image*)maskImageUpper;
-(void)incTargetMapIdx;
-(void)decTargetMapIdx;
-(float)getLoopedX:(float)x;

@end

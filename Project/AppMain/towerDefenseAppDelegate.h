//
//  towerDefenseAppDelegate.h
//  towerDefense
//
//  Created by Joey Manso on 7/5/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EAGLView;
@class EAGLViewController;

@interface towerDefenseAppDelegate : NSObject <UIApplicationDelegate> 
{
    UIWindow *window;
    EAGLView *glView;
    EAGLViewController *glViewController;
}
@end

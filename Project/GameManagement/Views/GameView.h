//
//  AppViews.h
//  towerDefense
//
//  Created by Joey Manso on 8/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BaseView.h"
#import "TouchManager.h"
#import "UIManager.h"
#import "Map1.h"

@interface GameView : BaseView 
{
    TouchManager *touchManager;
    UIManager *UIMan;
    Map1 *map;
}

@end

//
//  AppViews.h
//  towerDefense
//
//  Created by Joey Manso on 8/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BaseView.h"
@class TouchManager;
@class UIManager;
@class Map1;

@interface GameView : BaseView 
{
    TouchManager *touchManager;
    UIManager *UIMan;
    Map1 *map;
}
@end

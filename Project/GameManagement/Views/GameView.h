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

@interface GameView : BaseView 
{
    TouchManager *touchManager;
    UIManager *UIMan;
    NSMutableArray *maps;
    int currentMapIdx;
}

-(void)setMapIdx:(int)idx;

@end

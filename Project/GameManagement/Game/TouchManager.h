//
//  TouchManager.h
//  towerDefense
//
//  Created by Joey Manso on 8/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GameObject;
@class Tower;
@class Map;

@interface TouchManager : NSObject 
{
    CGRect screenBounds;
    CGPoint uiOffset;
}

// get instance of this singleton
+(TouchManager*)getInstance;

-(void)objectHasBeenRemoved:(GameObject*)o;

-(BOOL)selectObjectAtPosition:(CGPoint)position;
-(BOOL)moveObjectToPosition:(CGPoint)position;
-(void)unselectObject;

// for creating towers on the map
-(void)setPendingTower:(Tower*)tower;
-(BOOL)hasPendingTower;
-(BOOL)towerIsBeingPlaced;
-(void)putPendingTowerOnMap;
-(BOOL)placeTower;
-(void)removeTower;
-(void)removePendingTower;

// set reference to the current map
-(void)setMap:(Map*)m;

@end

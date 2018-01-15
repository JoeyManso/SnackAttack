//
//  TouchManager.m
//  towerDefense
//
//  Created by Joey Manso on 8/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TouchManager.h"
#import "UIManager.h"
#import "GameState.h"
#import "Tower.h"
#import "Map.h"

//private stuff
@interface TouchManager()
{
UIManager *UIMan;
GameObject *currentlySelectedObject; // current object held by user. nil if nothing is selected
Tower *pendingTower;
Point2D *tileCenterPoint; // center point of the tile to place tower on
Map *currentMap;
BOOL towerBeingPlaced;
float towerDeltaX, towerDeltaY;

BOOL initTowerOnMap; // used to place tower in center of map upon selection
BOOL touchedUI; // flag saying if user started touch on UI
}
-(void)checkTowerPosition;
@end


@implementation TouchManager
 
-(id)init
{
	if(self = [super init])
	{
        screenBounds = [[UIScreen mainScreen] bounds];
        CGPoint mapOffset = CGPointMake(0.0f,0.0f);
        mapOffset.x = (screenBounds.size.width - 320.0f) * 0.5f;
        mapOffset.y = (screenBounds.size.height - 480.0f) * 0.5f;
        
        uiOffset = CGPointMake(mapOffset.x, fmaxf(mapOffset.y, 50.0f));
        
		UIMan = [UIManager getInstance];
		tileCenterPoint = [[Point2D alloc] init];
		currentlySelectedObject = nil;
		towerBeingPlaced = initTowerOnMap = touchedUI = NO;
		towerDeltaX = towerDeltaY = 0.0f;
	}
	return self;
}
+(TouchManager*)getInstance
{
	// return a singleton
	static TouchManager *touchManagerInstance;
	
	// lock the class (for multithreading!)
	@synchronized(self)
	{
		if(!touchManagerInstance)
			touchManagerInstance = [[TouchManager alloc] init];
	}
	
	return touchManagerInstance;
}
-(void)objectHasBeenRemoved:(GameObject*)o
{
	if(currentlySelectedObject == o)
		currentlySelectedObject = nil;
}

-(BOOL)selectObjectAtPosition:(CGPoint)touchPosition
{
	// this logic is for GameObject touch events
	currentlySelectedObject = [[GameState sharedGameStateInstance] findObjectAtPosition:touchPosition];

	// if not nil, select
	if(currentlySelectedObject && !towerBeingPlaced)
	{
		[currentlySelectedObject select];
		if(pendingTower)
		{
			[self removePendingTower];
		}
		return YES;
	}
	else if(towerBeingPlaced)
	{
		if(initTowerOnMap)
			return NO;
		if(touchPosition.y < uiOffset.y + 16.0f
           || touchPosition.y > (screenBounds.size.height - uiOffset.y) - 16.0f)
			touchedUI = YES;
		else if([Math CGdistance:[pendingTower objectPosition] :touchPosition] > [pendingTower towerRange]*1.3)
		{
			[[pendingTower objectPosition] setX:touchPosition.x y:touchPosition.y];
			[self checkTowerPosition];
			return YES;
		}
	}
	return NO;
	
}
-(BOOL)moveObjectToPosition:(CGPoint)position
{
	// if we are holding an object, move it to the new point
	if(!touchedUI)
	{
		if(towerBeingPlaced)
		{
			if(currentlySelectedObject && currentlySelectedObject.canBeMoved)
			{
				[currentlySelectedObject setObjectPositionX:position.x y:position.y];
			}
			else if(!initTowerOnMap)
			{
				// move relative to touch, not on top of it
				if(towerDeltaX == 0.0f)
				{
					towerDeltaX = position.x - [pendingTower objectPosition].x;
					towerDeltaY = position.y - [pendingTower objectPosition].y;
				}
				[pendingTower setObjectPositionX:position.x - towerDeltaX y:position.y - towerDeltaY];
			}
		
			// Prevention from going over UI boundaries
			if([pendingTower objectPosition].y < uiOffset.y)
				[[pendingTower objectPosition] setY:uiOffset.y];
			else if([pendingTower objectPosition].y > (screenBounds.size.height - uiOffset.y))
				[[pendingTower objectPosition] setY:(screenBounds.size.height - uiOffset.y)];
		
			[self checkTowerPosition];
			return YES;
		}
	}
	return NO;
}
-(void)unselectObject
{
	if(towerBeingPlaced)
	{
		towerDeltaX = towerDeltaY = 0.0f;
		if(initTowerOnMap)
			initTowerOnMap = NO;
		// move pending tower over center of tile on release if it's a valid position
		if([currentMap getCenterOfValidTile:[pendingTower objectPosition] originOut:tileCenterPoint] && ![[GameState sharedGameStateInstance] pointIsWithinTower:tileCenterPoint])
			[[pendingTower objectPosition] setX:tileCenterPoint.x y:tileCenterPoint.y];
	}
		
	currentlySelectedObject = nil;
	touchedUI = NO;
}
-(void)setPendingTower:(Tower*)tower
{
	// This method is used to place towers on the map smoothly
	[[tower objectPosition] setX:-400.0f y:0.0f];
	pendingTower = tower;
}
-(BOOL)towerIsBeingPlaced
{
	return towerBeingPlaced;
}
-(BOOL)hasPendingTower
{
	return pendingTower != nil;
}
-(void)putPendingTowerOnMap
{
	if(pendingTower)
	{
		[[pendingTower objectPosition] setX:160.0f y:240.0f];
		towerBeingPlaced = initTowerOnMap = YES;
		[self checkTowerPosition];
	}
}
-(void)setMap:(Map*)m
{
	currentMap = m;
}
-(BOOL)placeTower
{
	// if we have a pending tower and it's over a valid area, lock it on the map and return true
	if(pendingTower)
	{
		if([currentMap getCenterOfValidTile:[pendingTower objectPosition] originOut:tileCenterPoint])
		{
			[[pendingTower objectPosition] setX:tileCenterPoint.x y:tileCenterPoint.y];
			[pendingTower lock];
			pendingTower = nil;
			towerBeingPlaced = NO;
			[currentMap turnOffHighlight];
			return YES;
		}
	}
	return NO;
}
-(void)removeTower
{
	// if we have a pending tower, delete it
	if(pendingTower)
	{
		[self removePendingTower];
		towerBeingPlaced = NO;
		[UIMan setConfirmButton:YES];
		[currentMap turnOffHighlight];
	}
}
-(void)removePendingTower
{
	[pendingTower remove];
	pendingTower = nil;
}
-(void)checkTowerPosition
{	
	if(![currentMap getCenterOfValidTile:[pendingTower objectPosition] originOut:tileCenterPoint] ||
       [[GameState sharedGameStateInstance] pointIsWithinTower:tileCenterPoint])
	{
		[pendingTower overInvalidArea];
		[currentMap setTileHighlightToRed];
		[UIMan setConfirmButton:NO];
	}
	else
	{
		[pendingTower overValidArea];
		[currentMap setTileHighlightToGreen];
		[UIMan setConfirmButton:YES];
	}
}
-(void)dealloc
{
	[tileCenterPoint dealloc];
	[currentlySelectedObject release];
	[pendingTower release];
	[super dealloc];
}

@end

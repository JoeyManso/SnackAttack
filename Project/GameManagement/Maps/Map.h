//
//  Map.h
//  towerDefense
//
//  Created by Joey Manso on 7/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameState.h"
#import "EnemySpawner.h"
#import "TiledMap.h"
#import "Round.h"

@interface Map : NSObject 
{
	GameState *game;
	EnemySpawner *spawnNode;
	TiledMap *tileMap;
	CGPoint mapPoint;
	NSMutableArray *rounds;
    Image *backgroundMap;
    CGPoint mapOffset;
}

-(void)update:(float)deltaTime;
-(void)draw;
-(BOOL)getCenterOfValidTile:(Point2D*)point originOut:(Point2D*)outPoint;
-(void)setTileHighlightToRed;
-(void)setTileHighlightToGreen;
-(void)turnOffHighlight;
-(Round*)getFirstRound;
-(Round*)getNextRound;

-(void)initRounds;
-(void)resetRounds;

@end

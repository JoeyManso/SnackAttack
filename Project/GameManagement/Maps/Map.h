//
//  Map.h
//  towerDefense
//
//  Created by Joey Manso on 7/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameState.h"
#import "TiledMap.h"
#import "Round.h"

@class PathNode;

@interface Map : NSObject 
{
	GameState *game;
	NSMutableArray *spawnNodes;
	TiledMap *tileMap;
	CGPoint tileMapPoint;
	NSMutableArray *rounds;
    Image *backgroundMap;
    CGPoint mapOffset;
    float spawnDelay;
    float lastSpawnTime;
    Round *currentRound;
}

-(void)initMap:(NSString*)mapName tiledFile:(NSString*)fileName;
-(void)update:(float)deltaTime;
-(void)draw;
-(BOOL)getCenterOfValidTile:(Point2D*)point originOut:(Point2D*)outPoint;
-(void)setTileHighlightToRed;
-(void)setTileHighlightToGreen;
-(void)turnOffHighlight;
-(Round*)getFirstRound;
-(Round*)getNextRound;
-(PathNode*)getRandSpawnNode;

-(void)initRounds;
-(void)resetRounds;

@end

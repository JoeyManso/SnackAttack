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
#import "TowerFactory.h"

@class PathNode;

enum EMapSpawn
{
    MS_LOW,
    MS_MED,
    MS_HIGH
};

@interface Map : NSObject 
{
	GameState *game;
    NSString *mapName;
	NSMutableArray *spawnNodes;
	TiledMap *tileMap;
	CGPoint tileMapPoint;
	NSMutableArray *rounds;
    Image *backgroundMap;
    CGPoint mapOffset;
    float spawnCooldown;
    Round *currentRound;
    
    SpriteSheet *chubbySpriteSheet; // sprite sheet shared by all chubbies
    SpriteSheet *jeanieSpriteSheet; // sprite sheet shared by all jeanies
    SpriteSheet *lankySpriteSheet; // sprite sheet shared by all lankies
    SpriteSheet *smartySpriteSheet; // sprite sheet shared by all smarties
    SpriteSheet *airplaneSpriteSheet; // sprite sheet shared by all paper airplanes
    SpriteSheet *bannerSpriteSheet; // you get the idea
    SpriteSheet *bandieSpriteSheet;
    SpriteSheet *cheerieSpriteSheet;
    SpriteSheet *punkieSpriteSheet;
    SpriteSheet *mascotSpriteSheet;
    SpriteSheet *queenieSpriteSheet;
    
    SpriteSheet *vendingSpriteSheet;
    SpriteSheet *matronSpriteSheet;
    SpriteSheet *cookieSpriteSheet;
    SpriteSheet *freezerSpriteSheet;
    SpriteSheet *popcornSpriteSheet;
    SpriteSheet *pieSpriteSheet;
    SpriteSheet *registerSpriteSheet;
}
@property(nonatomic, readonly)NSString *mapName;
@property(nonatomic, readonly)float spawnCooldown;
@property(nonatomic, readonly)enum EMapSpawn mapSpawn;

-(void)initMap:(NSString*)inMapName tiledFile:(NSString*)fileName mapSpawn:(enum EMapSpawn) inMapSpawn;
-(void)update:(float)deltaTime;
-(void)draw;
-(BOOL)getCenterOfValidTile:(Point2D*)point originOut:(Point2D*)outPoint;
-(void)setTileHighlightToRed;
-(void)setTileHighlightToGreen;
-(void)turnOffHighlight;
-(int)adjustSpawn:(int)s;
-(Round*)getCurrentRound;
-(Round*)getFirstRound;
-(Round*)getNextRound:(BOOL)shouldAppend;
-(PathNode*)getRandSpawnNode;
-(PathNode*)getNodeForValue:(int)value;
-(void)loadSave:(int)round spawnCooldown:(float)spawnC
    savedTowers:(NSArray*)towers
   savedEnemies:(NSArray*)enemies
defeatedEnemies:(NSMutableDictionary*)defeated;

-(void)initRounds;
-(void)resetRounds;

@end

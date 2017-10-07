//
//  TileSet.h
//  towerDefense
//
//  Created by Michael Daley on 05/04/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SpriteSheet.h"

@interface TileSet : NSObject 
{
	// ID of tile set
	int tileSetID;
	// Name of the tile set
	NSString *name;
	// First global id for this tile set
	int firstGID;
	// last gloabl ID for this tile set
	int lastGID;
	// Width of the tiles in this tile set
	int tileWidth;
	// Height of the tiles in this tile set
	int tileHeight;
	// Tile spacing
	int spacing;
	// Spritesheet which holds the tiles for this tile set
	SpriteSheet *tiles;
	// Horizontal tiles
	int horizontalTiles;
	// Vertical tiles
	int verticalTiles;
	// Tileset properties
	NSMutableDictionary *tilesetProperties;
}

@property(nonatomic, readonly)int tileSetID;
@property(nonatomic, readonly)NSString *name;
@property(nonatomic, readonly)int firstGID;
@property(nonatomic, readonly)int lastGID;
@property(nonatomic, readonly)int tileWidth;
@property(nonatomic, readonly)int tileHeight;
@property(nonatomic, readonly)int spacing;
@property(nonatomic, readonly)SpriteSheet *tiles;
@property(nonatomic, retain) NSMutableDictionary *tilesetProperties;

- (id)initWithImageNamed:(NSString*)image name:(NSString*)tileSetName tileSetID:(int)tileSetID firstGID:(int)first tileWidth:(int)width tileHeight:(int)height spacing:(int)space;
- (BOOL)containsGlobalID:(int)globalID;
- (int)getTileY:(int)tileID;
- (int)getTileX:(int)tileID;

@end

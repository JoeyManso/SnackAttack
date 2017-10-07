//
//  TiledMap.h
//  towerDefense
//
//  Created by Michael Daley on 05/04/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
/*
 This class will parse the tmx file from the tiled tool available on http://mapeditor.org
 
 The default output embeds the image into the confguration XML file in base64 and gzipped.  This
 current implementation does not support that output and the preferences of the application need
 to be changed so that the file contains just plain text.  I'll get around to adding support for
 this at some point :o)
*/

#import <Foundation/Foundation.h>
#import "DDXML.h"
#import "SpriteSheet.h"
#import "TileSet.h"
#import "Layer.h"
#import "GameState.h"

@interface TiledMap : NSObject 
{	
	// The width of the map in tiles
	unsigned int mapWidth;
	// The height of the map in tiles
	unsigned int mapHeight;
	// The width of a tile
	unsigned int tileWidth;
	// The height of a tile
	unsigned int tileHeight;
	// Current TileSet ID
	unsigned int currentTileSetID;
	// Current TileSet Instance
	TileSet *currentTileSet;
	// Current Layer ID
	unsigned int currentLayerID;
	// Current Layer instance
	Layer *currentLayer;
	// Array of TileSets in this map
	NSMutableArray *tileSets;
	// Array of Layers in this map
	NSMutableArray *layers;
	// Properties
	NSMutableDictionary *mapProperties;
	NSMutableDictionary *tileSetProperties;
	
	// internal vars needed for tilesets while processing the map file
	NSString *tileSetName;
	int tileSetID;
	int tileSetWidth;
	int tileSetHeight;
	int tileSetFirstGID;
	int tileSetSpacing;
	
	// internal vars needed for layers/tiles while processing the map file
	NSString *layerName;
	int layerID;
	int layerWidth;
	int layerHeight;
	int tileX;
	int tileY;
	
	// vertex arrays
	Quad2 *vertices;
	Quad2 *texCoords;
	GLushort *indices;
	
	// square on top of tile that the tower is hovering
	BOOL drawHighlight;
	GLfloat tileHighlight[8];
	GLfloat tileHighlightColor[4];
	
	// Game State
	GameState *sharedGameState;
}

@property(nonatomic, readonly)unsigned int mapWidth;
@property(nonatomic, readonly)unsigned int mapHeight;
@property(nonatomic, readonly)unsigned int tileWidth;
@property(nonatomic, readonly)unsigned int tileHeight;

- (id)initWithTiledFile:(NSString*)tiledFile fileExtension:(NSString*)fileExtension;
- (TileSet*)findTileSetWithGlobalID:(int)gid;
- (void)renderAtPoint:(CGPoint)point mapX:(int)mapX mapY:(int)mapY width:(int)width height:(int)height layer:(int)lid;
- (int)getLayerIndexWithName:(NSString*)name;
- (NSString*)getMapPropertyForKey:(NSString*)key defaultValue:(NSString*)defaultValue;
- (NSString*)getLayerPropertyForKey:(NSString*)key layerID:(int)lid defaultValue:(NSString*)defaultValue;
- (NSString*)getTilePropertyForGlobalTileID:(int)gtid key:(NSString*)key defaultValue:(NSString*)defaultValue;
- (BOOL)isTileValidGetOriginForPoint:(Point2D*)point outPoint:(Point2D*)outPoint invalidTileID:(int)gid;
- (void)highlightGreen;
- (void)highlightRed;
- (void)turnOffHighlight;
@end
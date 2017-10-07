//
//  Layer.h
//  towerDefense
//
//  Created by Michael Daley on 05/04/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MAX_MAP_WIDTH 500
#define MAX_MAP_HEIGHT 500

@interface Layer : NSObject 
{
	int layerID;
	NSString* layerName;
	
	// tile data where third dimension is:
	// index 0 = tileset being used
	// index 1 = tile id (within tileset)
	// index 2 = global id (always unique. ex: for first tileset, incremented as each tile is added
	// for second tileset, starts with count of all previous tiles and then is incremented, etc)
	// hardcoded to max of 1024x1024
	int layerData[MAX_MAP_WIDTH][MAX_MAP_HEIGHT][3];
	// measurements of layer in pixels
	int layerWidth;
	int layerHeight;
	
	NSMutableDictionary *layerProperties;
}

@property(nonatomic, readonly)int layerID;
@property(nonatomic, readonly)NSString *layerName;
@property(nonatomic, readonly)int layerWidth;
@property(nonatomic, readonly)int layerHeight;
@property(nonatomic, retain)NSMutableDictionary *layerProperties;

- (id)initWithName:(NSString*)name layerID:(int)lid layerWidth:(int)width layerHeight:(int)height;
- (void)addTileAtX:(int)x y:(int)y tileSetID:(int)tileSetID tileID:(int)tileID globalID:(int)globalID;
- (int)getTileSetIDAtX:(int)x y:(int)y;
- (int)getGlobalTileIDAtX:(int)x y:(int)y;
- (int)getTileIDAtX:(int)x y:(int)y;

@end

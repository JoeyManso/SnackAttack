//
//  TileSet.m
//  towerDefense
//
//  Created by Michael Daley on 05/04/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TileSet.h"

@implementation TileSet
@synthesize tileSetID;
@synthesize name;
@synthesize firstGID;
@synthesize lastGID;
@synthesize tileWidth;
@synthesize tileHeight;
@synthesize spacing;
@synthesize tiles;
@synthesize tilesetProperties;

-(id)init
{
	return [self initWithImageNamed:nil name:nil tileSetID:0 firstGID:0 tileWidth:0 tileHeight:0 spacing:0];
}
- (id)initWithImageNamed:(NSString*)image name:(NSString*)tileSetName tileSetID:(int)tsID firstGID:(int)first tileWidth:(int)width tileHeight:(int)height spacing:(int)space 
{
	if (self != nil) 
	{
		tiles = [[SpriteSheet alloc] initWithImageName:image spriteWidth:width spriteHeight:height spacing:space imageScale:1.0f];
		tileSetID = tsID;
		name = tileSetName;
		firstGID = first;
		horizontalTiles = [tiles horizontal];
		verticalTiles = [tiles vertical];
		lastGID = horizontalTiles * verticalTiles + firstGID - 1;
		tileWidth = width;
		tileHeight = height;
		spacing = space;
	}
	return self;
}


- (BOOL)containsGlobalID:(int)globalID 
{
	// If the global ID which has been passed is within the global IDs in this
	// tileset then return YES
	return (globalID >= firstGID) && (globalID <= lastGID);
}


// these work based on how the xml file is set up
- (int)getTileX:(int)tileID 
{
	return tileID % horizontalTiles;
}


- (int)getTileY:(int)tileID 
{
	return tileID / horizontalTiles;
}


- (void)dealloc 
{
	[tiles release];
	[tilesetProperties release];
	[super dealloc];
}

@end

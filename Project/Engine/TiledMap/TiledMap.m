//
//  TiledMap.m
//  towerDefense
//
//  Created by Michael Daley on 05/04/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
//  This class is used to read the XML output from Tiled.  It can handle multiple layers,
//  tilesets and properties on each of these.
//
//  It currently can only process the raw XML file and will not process a file which byte encodes
//  and gzips the tile information.
//
//  This class uses the KissXML libxml2 wrapper to process XML on the iPhone.  It is quick but very large 
//  tilemaps can take some time to process.  A double layer 10,000 tile map takes approx 5 seconds.
//


#import "TiledMap.h"

@interface TiledMap ()
- (void)parseMapFile:(NSString*)tiledXML;
@end

@implementation TiledMap

@synthesize mapWidth;
@synthesize mapHeight;
@synthesize tileWidth;
@synthesize tileHeight;

- (id)init
{
    return [self initWithTiledFile:nil fileExtension:nil offset:CGPointMake(0.0f, 0.0f)];
}
- (id)initWithTiledFile:(NSString*)tiledFile fileExtension:(NSString*)fileExtension offset:(CGPoint)offset
{
	if (self = [super init]) 
	{
        screenBounds = [[UIScreen mainScreen] bounds];
        mapOffset = offset;
        
		tileHighlight[0] = 0.0f;
		tileHighlight[1] = 0.0f;
		tileHighlight[2] = 0.0f;
		tileHighlight[3] = 0.0f;
		tileHighlight[4] = 0.0f;
		tileHighlight[5] = 0.0f;
		tileHighlight[6] = 0.0f;
		tileHighlight[7] = 0.0f;
		
		tileHighlightColor[0]=0.0f;
		tileHighlightColor[1]=1.0f;
		tileHighlightColor[2]=0.0f;
		tileHighlightColor[3]=1.0f;
		
		sharedGameState = [GameState sharedGameStateInstance];
		
		// Set up the arrays and default values for layers and tilesets
		tileSets = [[NSMutableArray alloc] init];
		layers = [[NSMutableArray alloc] init];
		
		// Get the path to the tiled config file and parse that file (big ass string)	
        [self parseMapFile:[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:tiledFile ofType:fileExtension] encoding:NSUTF8StringEncoding error:NULL]];
		
		// Calculate the total number of tiles it would take to fill the visible screen.  The values below which define the screen
		// size would need to be changed based on the size of the area you need the tilemap to fill.  I am adding a couple of tiles
		// to the total to cover fractions of a tile which may have resulted in the calculation
		int totalQuads = ((screenBounds.size.width / tileWidth) + 1) * ((screenBounds.size.height / tileHeight) + 1);
		NSLog(@"--> Initializing vertex arrays for '%d' quads.", totalQuads);
		
		// Set up the vertex arrays
		texCoords = malloc( sizeof(texCoords[0]) * totalQuads);
		vertices = malloc( sizeof(vertices[0]) * totalQuads);
		indices = malloc( sizeof(indices[0]) * totalQuads * 6);
		
		// If one of the arrays cannot be allocated, then report a warning and return nil
		if(!(texCoords && vertices && indices)) 
		{
			NSLog(@"WARNING: Tiled - Not enough memory to allocate vertex arrays");
			if(texCoords)
				free(texCoords);
			if(vertices)
				free(vertices);
			if(indices)
				free(indices);
			return nil;
		}
		
		bzero( texCoords, sizeof(texCoords[0]) * totalQuads);
		bzero( vertices, sizeof(vertices[0]) * totalQuads);
		bzero( indices, sizeof(indices[0]) * totalQuads * 6);
		
		for( NSUInteger i=0;i<totalQuads;i++) 
		{
			indices[i*6+0] = i*4+0;
			indices[i*6+1] = i*4+1;
			indices[i*6+2] = i*4+2;
			indices[i*6+5] = i*4+1;
			indices[i*6+4] = i*4+2;
			indices[i*6+3] = i*4+3;			
		}
	}
	return self;
}


- (void)parseMapFile:(NSString*)tiledXML 
{	
	// Allocate and init the properties dictionary for the map
	mapProperties = [[NSMutableDictionary alloc] init];
	
	// theError will store any errors which are returned when using XML
	NSError *theError = nil;
	
	// Init the current layer, tileset and tile x and y
	currentLayerID = 0;
	currentTileSetID = 0;
	tileX = 0;
	tileY = 0;
	
	// Create a DDXMLDocument for the file which has been passed in (DDXML is a wrapper around NSXML)
    DDXMLDocument *theXMLDocument = [[DDXMLDocument alloc] initWithXMLString:tiledXML options:0 error:&theError];
	
	// Process the map element and read the attributes we need
	NSArray *mapElements = [theXMLDocument nodesForXPath:@"/map" error:&theError];
	DDXMLElement *mapElement = [mapElements objectAtIndex:0];
	// parse as ints
	mapWidth = [[[mapElement attributeForName:@"width"] stringValue] intValue];
	mapHeight = [[[mapElement attributeForName:@"height"] stringValue] intValue];
	tileWidth = [[[mapElement attributeForName:@"tilewidth"] stringValue] intValue];
	tileHeight = [[[mapElement attributeForName:@"tileheight"] stringValue] intValue];
	NSLog(@"Tiled: Tilemap map dimensions are %dx%d", mapWidth, mapHeight);
	NSLog(@"Tiled: Tilemap tile dimensions are %dx%d", tileWidth, tileHeight);
	
	// Process any map properties which may exist for this map
	NSArray *mp = [theXMLDocument nodesForXPath:@"/map/properties/property" error:&theError];
	
	for(DDXMLElement *property in mp) 
	{
		NSString *name = [[property attributeForName:@"name"] stringValue];
		NSString *value = [[property attributeForName:@"value"] stringValue];
		[mapProperties setObject:value forKey:name];
		NSLog(@"Tiled: Tilemap property '%@' found with value '%@'", name, value);
	}
	
	// Process the tileset elements and read the attributes we need.
	tileSetProperties = [[NSMutableDictionary alloc] init];
	NSArray *tileSetElements = [theXMLDocument nodesForXPath:@"/map/tileset" error:nil];
	for(DDXMLElement *tileSetElement in tileSetElements) 
	{
		tileSetName = [[tileSetElement attributeForName:@"name"] stringValue];
		tileSetWidth = [[[tileSetElement attributeForName:@"tilewidth"] stringValue] intValue];
		tileSetHeight = [[[tileSetElement attributeForName:@"tileheight"] stringValue] intValue];
		tileSetFirstGID = [[[tileSetElement attributeForName:@"firstgid"] stringValue] intValue];
		tileSetSpacing = [[[tileSetElement attributeForName:@"spacing"] stringValue] intValue];
		
		NSLog(@"--> TILESET found named: %@, width=%d, height=%d, firstgid=%d, spacing=%d, id=%d", tileSetName, tileSetWidth, tileSetHeight, tileSetFirstGID, tileSetSpacing, currentTileSetID);
		
		// Retrieve the image element
		NSArray *imageElements = [tileSetElement nodesForXPath:@"image" error:nil];
		NSString *source = [[[imageElements objectAtIndex:0] attributeForName:@"source"] stringValue];
		NSLog(@"----> Found source for tileset called '%@'.", source);
		
		// Process any tileset properties
		NSArray *tileSetTiles = [tileSetElement nodesForXPath:@"/tileset/tile" error:&theError];
		for(DDXMLElement *tile in tileSetTiles) 
		{
			int tileID = [[[tile attributeForName:@"id"] stringValue] intValue] + tileSetFirstGID;
			NSString *tileIDKey = [NSString stringWithFormat:@"%d", tileID];			
			
			NSMutableDictionary *tileProperties = [[NSMutableDictionary alloc] init];
			NSArray *tstp = [tile nodesForXPath:@"/tile/properties/property" error:nil];
			
			for(DDXMLElement *tileProperty in tstp) 
			{
				NSString *name = [[tileProperty attributeForName:@"name"] stringValue];
				NSString *value = [[tileProperty attributeForName:@"value"] stringValue];
				NSLog(@"----> Property '%@' found with value '%@' for global tile id '%@'", name, value, tileIDKey);
				[tileProperties setObject:value forKey:name];
			}
			[tileSetProperties setObject:tileProperties forKey:tileIDKey];
			[tileProperties release];
		}
		
		// Create a tileset instance based on the retrieved information
		currentTileSet = [[TileSet alloc] initWithImageNamed:source 
														name:tileSetName 
												   tileSetID:currentTileSetID 
													firstGID:tileSetFirstGID 
												   tileWidth:tileSetWidth 
												  tileHeight:tileSetHeight 
													 spacing:tileSetSpacing];
		
		// Add the tileset instance we have just created to the array of tilesets
		[tileSets addObject:currentTileSet];
		
		// Release the current tileset instance as its been added to the array and we do not need it now
		[currentTileSet release];
		
		// Increment the current tileset id
		currentTileSetID++;
	}
	
	// Process the layer elements
	NSArray *layerElements = [theXMLDocument nodesForXPath:@"/map/layer" error:nil];
	for(DDXMLElement *layerElement in layerElements) 
	{
		layerName = [[layerElement attributeForName:@"name"] stringValue];
		layerWidth = [[[layerElement attributeForName:@"width"] stringValue] intValue];
		layerHeight = [[[layerElement attributeForName:@"height"] stringValue] intValue];
		
		currentLayer = [[Layer alloc] initWithName:layerName layerID:currentLayerID layerWidth:layerWidth layerHeight:layerHeight];
		NSLog(@"--> LAYER found called: %@, width=%d, height=%d", layerName, layerWidth, layerHeight);
		
		// Process any layer properties
		NSMutableDictionary *layerProps = [[NSMutableDictionary alloc] init];
		NSArray *layerProperties = [layerElement nodesForXPath:@"/properties/property" error:&theError];
		
		for(DDXMLElement *property in layerProperties) 
		{
			NSString *name = [[property attributeForName:@"name"] stringValue];
			NSString *value = [[property attributeForName:@"value"] stringValue];
			[layerProps setObject:value forKey:name];
			NSLog(@"----> Property '%@' found with value '%@'", name, value);
		}
		[currentLayer setLayerProperties:layerProps];
		[layerProps release];
		
		// Process the data and tile elements
		NSArray *dataElements = [layerElement nodesForXPath:@"data" error:nil];
		
		// As we are starting the data element we need to make sure that the tileX and tileY ivars are
		// reset ready to process the tile elements
		tileX = 0;
		tileY = 0;
		
		// Process the tile elements
		NSArray *tileElements = [[dataElements objectAtIndex:0] nodesForXPath:@"tile" error:nil];
        NSLog(@"----> Found '%lu' tile elements", (unsigned long)[tileElements count]);
		
		for(DDXMLElement *tileElement in tileElements) 
		{
			int globalID = [[[tileElement attributeForName:@"gid"] stringValue] intValue];
			
			// If the globalID is 0 then this is an empty tile else populate the tile array with the 
			// retrieved tile information
			if(globalID == 0)
			{
				[currentLayer addTileAtX:tileX y:tileY tileSetID:-1 tileID:0 globalID:0];
			}
			else 
			{
				TileSet *tileSet = [self findTileSetWithGlobalID:globalID];
				[currentLayer addTileAtX:tileX 
									   y:tileY 
							   tileSetID:[tileSet tileSetID] 
								  tileID:globalID - [tileSet firstGID] 
								globalID:globalID];
			}
			
			// Calculate the next coord within the tiledata array
			tileX++;
			if(tileX > layerWidth - 1) 
			{
				tileX = 0;
				tileY++;
			}
		}
		
		// We have finished processing the layer element so add the current layer to the
		// layers array, release it and increment the current layer ID.
		[layers addObject:currentLayer];
		[currentLayer release];
		currentLayerID++;
	}
	
	// Release the XML Document
	[theXMLDocument release];
}


- (TileSet*)findTileSetWithGlobalID:(int)gid
{
	// Loop through all the tile sets we have and check to see if the supplied global ID
	// is within one of those tile sets.  If the global ID is found then return the tile set
	// in which it was found
	for(TileSet *tileSet in tileSets) 
	{
		if([tileSet containsGlobalID:gid]) 
		{
			return tileSet;
		}
	}
	return nil;
}


- (void)renderAtPoint:(CGPoint)point mapX:(int)mapX mapY:(int)mapY width:(int)width height:(int)height layer:(int)lid 
{	
	/* -- don't draw the tiles!!
	Layer *layer = [layers objectAtIndex:lid];
	int x = point.x;
	int y = point.y;
	// count of tiles
	int currentQuad = 0;
	
	// Enable OGL settings for rendering the tilemap
	glEnable(GL_TEXTURE_2D);
	glEnable(GL_BLEND);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	glEnableClientState(GL_VERTEX_ARRAY);
	
	// Loop through all the tile sets we have.  Moving through the map data and rendering all those
	// tiles which are from the current tile map will stop us switching between textures all the time
	for(TileSet *tileSet in tileSets) 
	{
		// For the current tileset get the texturename and bind it as the texture we are going to render with
		int textureName = (int)[[[[tileSet tiles] image] texture] name];
		if(textureName != [sharedGameState currentlyBoundTexture])
		{
			[sharedGameState setCurrentlyBoundTexture:textureName];
			glBindTexture(GL_TEXTURE_2D, textureName);
		}
		
		// Loop through the map row by row
		for(int mapTileY=mapY; mapTileY < (mapY + height); ++mapTileY) 
		{
			for(int mapTileX=mapX; mapTileX < (mapX + width); ++mapTileX) 
			{
				// If outside the map boundary do nothing, otherwise render the tile
				if(mapTileX < 0 || mapTileY < 0 || mapTileX > mapWidth || mapTileY > mapHeight)
				{
					// out of bounds, do nothing. We can still render blank space.
				} 
				else 
				{
					// Get the tileID and tilesetID for the current map location
					int tileID = [layer getTileIDAtX:mapTileX y:mapTileY];
					int tsid = [layer getTileSetIDAtX:mapTileX y:mapTileY];
					
					// If the tilesetID matches the tileset we are currently processing then add it to the vertex arrays
					// otherwise skip it and it will be drawn when its tileset is being processed
					if([tileSet tileSetID] == tsid)
					{
						// Calculate the texture coordinates and vertices for the current tile and add them to the 
						// vertex arrays
						texCoords[currentQuad] = *[[tileSet tiles] getTextureCoordsForSpriteAtX:[tileSet getTileX:tileID] 
																							  y:[tileSet getTileY:tileID]];
						
						vertices[currentQuad] = *[[tileSet tiles] getVerticesForSpriteAtX:mapTileX 
																						y:mapTileY 
																					point:CGPointMake(x, y) 
																			centerOfImage:NO];
						
						// Increment the number of quads we have defined in our vertex arrays
						currentQuad++;
					}
				}
				// Increment the x location for the next tile to be rendered
				x += tileWidth;			
			}
			// Now we have finished a move to the next row of tiles and reset x
			y -= tileHeight;
			x = point.x;
		}
		
		// Finished processing the current tileset so render the results
		glVertexPointer(2, GL_FLOAT, 0, vertices);
		glTexCoordPointer(2, GL_FLOAT, 0, texCoords);
		glDrawElements(GL_TRIANGLES, currentQuad*6, GL_UNSIGNED_SHORT, indices);
		*/
		if(drawHighlight)
		{
			glPushMatrix();
			glEnableClientState(GL_VERTEX_ARRAY);
			
			glColor4f(tileHighlightColor[0], tileHighlightColor[1], tileHighlightColor[2], tileHighlightColor[3]);
			glVertexPointer(2, GL_FLOAT, 0, tileHighlight);
			glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
			
			glDisableClientState(GL_VERTEX_ARRAY);
			glPopMatrix();
		}
		/*
		// Get ready to loop through any other tilesets we have on this layer
		x = point.x;
		y = point.y;
	}
	
	// Disable OpenGL settings we no longer need to use
	glDisable(GL_TEXTURE_2D);
	glDisable(GL_BLEND);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	glDisableClientState(GL_VERTEX_ARRAY);*/
}
- (BOOL)isTileValidGetOriginForPoint:(Point2D*)point outPoint:(Point2D*)outPoint invalidTileID:(int)gid
{
	for(Layer *layer in layers)
	{
		for(int x = 0; x < layerWidth; ++x)
		{
			for(int y = 0; y < layerHeight; ++y)
			{
				// we have to adjust y here because opengl is dumb
                CGRect tileBounds =
                CGRectMake(mapOffset.x + (x*tileWidth),
                           screenBounds.size.height - (mapOffset.y + (y+1)*tileHeight),
                           tileWidth, tileHeight);
				if(CGRectContainsPoint(tileBounds, CGPointMake(point.x,point.y)))
				{
					// returns origin for the tile
					tileHighlight[0]=tileBounds.origin.x;
					tileHighlight[1]=tileBounds.origin.y;
					tileHighlight[2]=tileHighlight[0];
					tileHighlight[3]=tileHighlight[1]+tileHeight;
					tileHighlight[4]=tileHighlight[0]+tileWidth;
					tileHighlight[5]=tileHighlight[3];
					tileHighlight[6]=tileHighlight[4];
					tileHighlight[7]=tileHighlight[1];
					drawHighlight = YES;
					[outPoint setX:tileHighlight[0] + (0.5f * tileWidth) y:tileHighlight[1] + (0.5f * tileHeight)];
					if([layer getGlobalTileIDAtX:x y:y] == gid)
						return NO;
				}
			}
		}
	}
	return YES;
}

- (void)highlightGreen
{
	tileHighlightColor[0]=0.0f;
	tileHighlightColor[1]=1.0f;
}
- (void)highlightRed
{
	tileHighlightColor[0]=1.0f;
	tileHighlightColor[1]=0.0f;
}
- (void)turnOffHighlight
{
	drawHighlight = NO;
}

- (int)getLayerIndexWithName:(NSString*)name 
{
	// Loop through the names of the layers and pass back the index if found
	for(Layer *layer in layers)
	{
		if([[layer layerName] isEqualToString:name]) 
		{
			return [layer layerID];
		}
	}
	
	// If we reach here then no layer with a matching name was found
	return -1;
}


- (NSString*)getMapPropertyForKey:(NSString*)key defaultValue:(NSString*)defaultValue 
{
	NSString *value = [mapProperties valueForKey:key];
	if(!value)
		return defaultValue;
	return value;
}


- (NSString*)getLayerPropertyForKey:(NSString*)key layerID:(int)lid defaultValue:(NSString*)defaultValue 
{
	if(lid < 0 || lid > [layers count] -1) 
	{
		NSLog(@"TILED ERROR: Request for a property on a layer which is out of range.");
		return nil;
	}
	NSString *value = [[[layers objectAtIndex:lid] layerProperties] valueForKey:key];
	if(!value)
		return defaultValue;
	return value;
}


- (NSString*)getTilePropertyForGlobalTileID:(int)gtid key:(NSString*)key defaultValue:(NSString*)defaultValue 
{
	NSString *value = [[tileSetProperties valueForKey:[NSString stringWithFormat:@"%d", gtid]] valueForKey:key];
	if(!value)
		return defaultValue;
	return value;
}


- (void)dealloc 
{
	free(vertices);
	free(indices);
	free(texCoords);
	[tileSets release];
	[layers release];
	[super dealloc];
}

@end


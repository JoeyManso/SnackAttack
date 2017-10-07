//
//  Map.m
//  towerDefense
//
//  Created by Joey Manso on 7/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Map.h"

@implementation Map

-(id)init
{
	if(self = [super init])
	{
		game = [GameState sharedGameStateInstance];
		tileMap = nil;
		mapPoint = CGPointMake(0,448);
		rounds = [[NSMutableArray alloc] init];
		[self initRounds];
	}
	return self;
}

-(void)update:(float)deltaTime
{
	[spawnNode update:deltaTime];
	[game update:deltaTime];
}
-(void)draw
{
	[tileMap renderAtPoint:mapPoint mapX:0 mapY:0 width:10 height:15 layer:0];
	[game draw];
}
-(BOOL)getCenterOfValidTile:(Point2D*)point originOut:(Point2D*)outPoint
{
	return NO;
}
-(void)setTileHighlightToGreen
{
}
-(void)setTileHighlightToRed
{
}
-(void)turnOffHighlight
{
}
-(Round*)getFirstRound
{
	// use subclasses!
	return nil;
}
-(Round*)getNextRound
{
	// use subclasses!
	return nil;
}
-(void)initRounds
{
	// use subclasses!
}
-(void)resetRounds
{
	for(Round *r in rounds)
		[r release];
	[rounds removeAllObjects];
	[spawnNode release];
	[self initRounds];
}
-(void)dealloc
{
	for(Round *r in rounds)
		[r release];
	[rounds removeAllObjects];
	[rounds release];
	[tileMap dealloc];
	[spawnNode release];
	[super dealloc];
}
@end

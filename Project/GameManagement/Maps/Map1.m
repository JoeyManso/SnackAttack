//
//  Map1.m
//  towerDefense
//
//  Created by Joey Manso on 7/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Map1.h"
#import "TowerFactory.h"

@implementation Map1

-(id)init
{
	if(self = [super init])
	{		
		// init tile map
		tileMap = [[TiledMap alloc] initWithTiledFile:@"Map1TileMap2" fileExtension:@"tmx"];
		backgroundMap = [[Image alloc] initWithImage:[UIImage imageNamed:@"map1.png"]];
		backgroundMapPoint = CGPointMake(0.0f,0.0f);
	}
	return self;
}
-(void)initRounds
{
	// declare our nodes backwards
	PathNode *node11 = [[PathNode alloc] initWithPosition:[[Point2D alloc] initWithX:-20.0f y:368.0f] next:nil value:11];
	PathNode *node10 = [[PathNode alloc] initWithPosition:[[Point2D alloc] initWithX:112.0f y:368.0f] next:node11 value:10];
	PathNode *node09 = [[PathNode alloc] initWithPosition:[[Point2D alloc] initWithX:112.0f y:400.0f] next:node10 value:9];
	PathNode *node08 = [[PathNode alloc] initWithPosition:[[Point2D alloc] initWithX:304.0f y:400.0f] next:node09 value:8];
	PathNode *node07 = [[PathNode alloc] initWithPosition:[[Point2D alloc] initWithX:304.0f y:176.0f] next:node08 value:7];
	PathNode *node06 = [[PathNode alloc] initWithPosition:[[Point2D alloc] initWithX:176.0f y:176.0f] next:node07 value:6];
	PathNode *node05 = [[PathNode alloc] initWithPosition:[[Point2D alloc] initWithX:176.0f y:240.0f] next:node06 value:5];
	PathNode *node04 = [[PathNode alloc] initWithPosition:[[Point2D alloc] initWithX:16.0f y:240.0f] next:node05 value:4];
	PathNode *node03 = [[PathNode alloc] initWithPosition:[[Point2D alloc] initWithX:16.0f y:80.0f] next:node04 value:3];
	PathNode *node02 = [[PathNode alloc] initWithPosition:[[Point2D alloc] initWithX:240.0f y:80.0f] next:node03 value:2];
	spawnNode = [[EnemySpawner alloc] initWithPath:self position:[[Point2D alloc] initWithX:240.0f y:-20.0f] next:node02];
	
	// add all rounds to the game backwards so we can pop them off when completed
	[rounds addObject:[[Round alloc] initWithMessage1:nil //30
											 message2:nil
											 message3:nil
												bonus:0 chubbies:10 jeanies:10 lankies:10 smarties:10 airplanes:10
											  banners:10 bandies:10 cheeries:20 punkies:10 mascots:10 queenies:20]];
	[rounds addObject:[[Round alloc] initWithMessage1:@"130 enemies on their way for"
											 message2:@"one final push. Survive and"
											 message3:@"you've beat the game!"
												bonus:150 chubbies:14 jeanies:0 lankies:0 smarties:0 airplanes:12
											  banners:10 bandies:12 cheeries:0 punkies:0 mascots:7 queenies:5]];
	[rounds addObject:[[Round alloc] initWithMessage1:@"The penultimate round!"
											 message2:@"These kids are getting"
											 message3:@"serious."
												bonus:125 chubbies:0 jeanies:20 lankies:16 smarties:24 airplanes:0
											  banners:0 bandies:0 cheeries:25 punkies:18 mascots:0 queenies:0]];
	[rounds addObject:[[Round alloc] initWithMessage1:@"In the home stretch, soon"
											 message2:@"you can return to playing"
											 message3:@"iMobster!"
												bonus:115 chubbies:6 jeanies:6 lankies:6 smarties:6 airplanes:6
											  banners:6 bandies:6 cheeries:6 punkies:6 mascots:6 queenies:6]];
	[rounds addObject:[[Round alloc] initWithMessage1:@"Six of each enemy type!"
											 message2:@"Hope your layout has"
											 message3:@"some variety"
												bonus:105 chubbies:12 jeanies:0 lankies:0 smarties:0 airplanes:0
											  banners:0 bandies:10 cheeries:0 punkies:0 mascots:8 queenies:3]];	
	[rounds addObject:[[Round alloc] initWithMessage1:@"By now you should have" //25
											 message2:@"enemy types and immunities"
											 message3:@"committed to memory."
												bonus:100 chubbies:0 jeanies:20 lankies:20 smarties:0 airplanes:0
											  banners:0 bandies:0 cheeries:20 punkies:0 mascots:0 queenies:5]];
	[rounds addObject:[[Round alloc] initWithMessage1:@"After this round, enemy"
											 message2:@"hitpoints will triple what"
											 message3:@"they were at round 1."
												bonus:90 chubbies:8 jeanies:0 lankies:0 smarties:0 airplanes:0
											  banners:0 bandies:5 cheeries:5 punkies:0 mascots:10 queenies:5]];
	[rounds addObject:[[Round alloc] initWithMessage1:@"If you haven't invested in a"
											 message2:@"cash register yet, I highly"
											 message3:@"recommend it."
												bonus:85 chubbies:0 jeanies:0 lankies:10 smarties:0 airplanes:0
											  banners:0 bandies:0 cheeries:20 punkies:5 mascots:0 queenies:0]];
	[rounds addObject:[[Round alloc] initWithMessage1:@"The fastest enemies in the"
											 message2:@"game are speeding past. Can"
											 message3:@"you catch them all?"
												bonus:80 chubbies:0 jeanies:0 lankies:0 smarties:0 airplanes:6
											  banners:5 bandies:0 cheeries:0 punkies:0 mascots:0 queenies:0]];
	[rounds addObject:[[Round alloc] initWithMessage1:@"Get ready for an aerial"
											 message2:@"assault!"
											 message3:nil
												bonus:75 chubbies:12 jeanies:0 lankies:0 smarties:0 airplanes:0
											  banners:0 bandies:12 cheeries:0 punkies:0 mascots:12 queenies:0]];
	[rounds addObject:[[Round alloc] initWithMessage1:@"You've passed level 20!" //20
											 message2:@"Must be doing something"
											 message3:@"right."
												bonus:70 chubbies:6 jeanies:4 lankies:3 smarties:6 airplanes:5
											  banners:4 bandies:6 cheeries:15 punkies:2 mascots:3 queenies:1]];
	[rounds addObject:[[Round alloc] initWithMessage1:@"What are these kids heading" 
											 message2:@"towards anyway? It's not"
											 message3:@"important. Stop them!"
												bonus:65 chubbies:3 jeanies:5 lankies:3 smarties:5 airplanes:4
											  banners:4 bandies:4 cheeries:10 punkies:2 mascots:2 queenies:1]];
	[rounds addObject:[[Round alloc] initWithMessage1:@"Finally! The whole roster" 
											 message2:@"comes out to play."
											 message3:nil
												bonus:58 chubbies:0 jeanies:0 lankies:3 smarties:0 airplanes:0
											  banners:0 bandies:0 cheeries:5 punkies:0 mascots:0 queenies:4]];
	[rounds addObject:[[Round alloc] initWithMessage1:@"After round 20 enemy" 
											 message2:@"hitpoints double and"
											 message3:@"after 25 they triple!"
												bonus:55 chubbies:0 jeanies:0 lankies:10 smarties:0 airplanes:0
											  banners:0 bandies:0 cheeries:0 punkies:0 mascots:0 queenies:1]];
	[rounds addObject:[[Round alloc] initWithMessage1:@"The prom queen cometh..." 
											 message2:nil
											 message3:nil
												bonus:50 chubbies:0 jeanies:0 lankies:7 smarties:0 airplanes:0
											  banners:0 bandies:5 cheeries:10 punkies:0 mascots:5 queenies:0]];
	[rounds addObject:[[Round alloc] initWithMessage1:@"The next round has all" //15
											 message2:@"the elements of a sporting" 
											 message3:@"event. Except a sport."
												bonus:48 chubbies:0 jeanies:0 lankies:0 smarties:0 airplanes:0
											  banners:0 bandies:0 cheeries:0 punkies:0 mascots:10 queenies:0]];
	[rounds addObject:[[Round alloc] initWithMessage1:@"Ever wonder if mascots" 
											 message2:@"smile beneath the mask?" 
											 message3:@"Yeah, me neither."
												bonus:46 chubbies:0 jeanies:0 lankies:0 smarties:0 airplanes:0
											  banners:0 bandies:0 cheeries:0 punkies:20 mascots:0 queenies:0]];
	[rounds addObject:[[Round alloc] initWithMessage1:@"Rebellious punkies on the" 
											 message2:@"way, specially imported" 
											 message3:@"from a bad 80s movie."
												bonus:42 chubbies:0 jeanies:0 lankies:0 smarties:0 airplanes:0
											  banners:10 bandies:0 cheeries:0 punkies:0 mascots:0 queenies:0]];
	[rounds addObject:[[Round alloc] initWithMessage1:@"These banners are tough," 
											 message2:@"one might even say," 
											 message3:@"'unflappable'. No? Sorry."
												bonus:40 chubbies:0 jeanies:0 lankies:0 smarties:0 airplanes:0
											  banners:0 bandies:0 cheeries:22 punkies:0 mascots:0 queenies:0]];
	[rounds addObject:[[Round alloc] initWithMessage1:@"A whole bunch of" 
											 message2:@"cheeries are cheering" 
											 message3:@"your way."
												bonus:38 chubbies:0 jeanies:0 lankies:0 smarties:0 airplanes:0
											  banners:0 bandies:5 cheeries:0 punkies:0 mascots:0 queenies:0]];
	[rounds addObject:[[Round alloc] initWithMessage1:@"You've passed level 10!" //10
											 message2:@"Be sure to have all areas"
											 message3:@"of the map covered." 
												bonus:35 chubbies:4 jeanies:6 lankies:4 smarties:7 airplanes:1
											  banners:0 bandies:0 cheeries:0 punkies:0 mascots:0 queenies:0]];
	[rounds addObject:[[Round alloc] initWithMessage1:@"Matron and Vending towers" 
											 message2:@"can hold their own in later"
											 message3:@"levels if upgraded properly"
												bonus:33 chubbies:0 jeanies:0 lankies:0 smarties:0 airplanes:4
											  banners:0 bandies:0 cheeries:0 punkies:0 mascots:0 queenies:0]];
	[rounds addObject:[[Round alloc] initWithMessage1:@"Choosing which tower to" 
											 message2:@"use is just as important as"
											 message3:@"choosing where to place it."
												bonus:30 chubbies:0 jeanies:6 lankies:0 smarties:7 airplanes:0
											  banners:0 bandies:0 cheeries:0 punkies:0 mascots:0 queenies:0]];
	[rounds addObject:[[Round alloc] initWithMessage1:@"Check out the instructions" 
											 message2:@"page for details on enemy" 
											 message3:@"types and immunities."
												bonus:28 chubbies:5 jeanies:0 lankies:2 smarties:0 airplanes:0
											  banners:0 bandies:0 cheeries:0 punkies:0 mascots:0 queenies:0]];
	[rounds addObject:[[Round alloc] initWithMessage1:@"Selling many towers for one" 
											 message2:@"one premium tower is never" 
											 message3:@"a good idea."
												bonus:27 chubbies:0 jeanies:0 lankies:4 smarties:0 airplanes:0
											  banners:0 bandies:0 cheeries:0 punkies:0 mascots:0 queenies:0]];
	[rounds addObject:[[Round alloc] initWithMessage1:@"Airplanes are on their" //5
											 message2:@"way in a few rounds..." 
											 message3:@"The Matron is your friend."
												bonus:26 chubbies:0 jeanies:3 lankies:0 smarties:3 airplanes:0
											  banners:0 bandies:0 cheeries:0 punkies:0 mascots:0 queenies:0]];
	[rounds addObject:[[Round alloc] initWithMessage1:@"Upgrading towers can go" 
											 message2:@"a long way. Be sure to" 
											 message3:@"use it in your strategy."
												bonus:25 chubbies:3 jeanies:0 lankies:0 smarties:0 airplanes:0
											  banners:0 bandies:0 cheeries:0 punkies:0 mascots:0 queenies:0]];
	[rounds addObject:[[Round alloc] initWithMessage1:@"Have you checked out" 
											 message2:@"enemy types and immunities" 
											 message3:@"on the instructions page?" 
												bonus:24 chubbies:0 jeanies:0 lankies:0 smarties:0 airplanes:0
											  banners:0 bandies:0 cheeries:0 punkies:3 mascots:0 queenies:0]];
	[rounds addObject:[[Round alloc] initWithMessage1:@"Some towers are only" 
											 message2:@"available once you've" 
											 message3:@"passed certain rounds." 
												bonus:22 chubbies:0 jeanies:0 lankies:0 smarties:4 airplanes:0
											  banners:0 bandies:0 cheeries:0 punkies:0 mascots:0 queenies:0]];
	[rounds addObject:[[Round alloc] initWithMessage1:@"Be sure to pay attention" //1
											 message2:@"to enemy immunities and" 
											 message3:@"types. Use tower variety!" 
												bonus:20 chubbies:0 jeanies:3 lankies:0 smarties:0 airplanes:0
											  banners:0 bandies:0 cheeries:0 punkies:0 mascots:0 queenies:0]];
}
-(BOOL)getCenterOfValidTile:(Point2D*)point originOut:(Point2D*)outPoint
{
	return [tileMap isTileValidGetOriginForPoint:point outPoint:outPoint invalidTileID:3];
}
-(void)setTileHighlightToGreen
{
	[tileMap highlightGreen];
}
-(void)setTileHighlightToRed
{
	[tileMap highlightRed];
}
-(void)turnOffHighlight
{
	[tileMap turnOffHighlight];
}
-(Round*)getFirstRound
{
	[spawnNode setCurrentRoundInfo:[rounds lastObject]];
	return [rounds lastObject];
}
-(Round*)getNextRound
{
	// release and remove the last round
	Round *previousRound = [rounds lastObject];
	[rounds removeLastObject];
	// check that we have rounds left, and return
	if([rounds count] > 0)
	{
		[spawnNode setCurrentRoundInfo:[[rounds lastObject] appendRound:previousRound]];
		[previousRound release];
		return [rounds lastObject];
	}
	[spawnNode setCurrentRoundInfo:nil];
	[previousRound release];
	return nil;
}
-(void)draw
{
	[backgroundMap renderAtPoint:backgroundMapPoint centerOfImage:NO];
	[super draw];
}
-(void)dealloc
{
	[backgroundMap dealloc];
	[super dealloc];
}

@end
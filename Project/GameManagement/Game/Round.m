//
//  Rounds.m
//  towerDefense
//
//  Created by Joey Manso on 8/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Round.h"

@implementation Round

@synthesize roundBonus;
@synthesize numChubbies;
@synthesize numJeanies;
@synthesize numLankies;
@synthesize numSmarties;
@synthesize numAirplanes;
@synthesize numBanners;
@synthesize numBandies;
@synthesize numCheeries;
@synthesize numPunkies;
@synthesize numMascots;
@synthesize numQueenies;
@synthesize numTotalEnemies;
@synthesize messageLine1;
@synthesize messageLine2;
@synthesize messageLine3;

-(id)initWithMessage1:(NSString*)m1 message2:(NSString*)m2 message3:(NSString*)m3
				bonus:(uint)b chubbies:(uint)c jeanies:(uint)j lankies:(uint)l smarties:(uint)s airplanes:(uint)a
			  banners:(uint)bn bandies:(uint)bd cheeries:(uint)ch punkies:(uint)p mascots:(uint)m queenies:(uint)q
{
	if(self = [super init])
	{
		roundBonus = b;
		
		numChubbies = c;
		numJeanies = j;
		numLankies = l;
		numSmarties = s;
		numAirplanes = a;
		numBanners = bn;
		numBandies = bd;
		numCheeries = ch;
		numPunkies = p;
		numMascots = m;
		numQueenies = q;
		
		messageLine1 = m1;
		messageLine2 = m2;
		messageLine3 = m3;
		
		numTotalEnemies = c+j+l+s+a+bn+bd+ch+p+m+q;
	}
	return self;
}
-(void)appendRound:(Round*)r
{
	numChubbies += [r numChubbies];
	numJeanies += [r numJeanies];
	numLankies += [r numLankies];
	numSmarties += [r numSmarties];
	numAirplanes += [r numAirplanes];
	numBanners += [r numBanners];
	numBandies += [r numBandies];
	numCheeries += [r numCheeries];
	numPunkies += [r numPunkies];
	numMascots += [r numMascots];
	numQueenies += [r numQueenies];
}

@end

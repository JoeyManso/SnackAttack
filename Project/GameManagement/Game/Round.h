//
//  Rounds.h
//  towerDefense
//
//  Created by Joey Manso on 8/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Round : NSObject 
{
	uint roundBonus;
	
	uint numChubbies;
	uint numJeanies;
	uint numLankies;
	uint numSmarties;
	uint numAirplanes;
	uint numBanners;
	uint numBandies;
	uint numCheeries;
	uint numPunkies;
	uint numMascots;
	uint numQueenies;
	
	uint numTotalEnemies;
	
	NSString *messageLine1;
	NSString *messageLine2;
	NSString *messageLine3;
}
@property(nonatomic, readonly)uint roundBonus;
@property(nonatomic)uint numChubbies;
@property(nonatomic)uint numJeanies;
@property(nonatomic)uint numLankies;
@property(nonatomic)uint numSmarties;
@property(nonatomic)uint numAirplanes;
@property(nonatomic)uint numBanners;
@property(nonatomic)uint numBandies;
@property(nonatomic)uint numCheeries;
@property(nonatomic)uint numPunkies;
@property(nonatomic)uint numMascots;
@property(nonatomic)uint numQueenies;
@property(nonatomic, readonly)uint numTotalEnemies;
@property(nonatomic, readonly)NSString *messageLine1;
@property(nonatomic, readonly)NSString *messageLine2;
@property(nonatomic, readonly)NSString *messageLine3;

-(id)initWithMessage1:(NSString*)m1 message2:(NSString*)m2 message3:(NSString*)m3
				bonus:(uint)b chubbies:(uint)c jeanies:(uint)j lankies:(uint)l smarties:(uint)s airplanes:(uint)a
			  banners:(uint)bn bandies:(uint)bd cheeries:(uint)ch punkies:(uint)p mascots:(uint)m queenies:(uint)q;
-(void)appendRound:(Round*)r;

@end

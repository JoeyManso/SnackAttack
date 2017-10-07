//
//  PathNode.m
//  towerDefense
//
//  Created by Joey Manso on 8/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PathNode.h"

@implementation PathNode

@synthesize nodePosition;
@synthesize value;

-(id)initWithPosition:(Point2D*)position next:(PathNode*)n value:(uint)v
{
	if(self = [super init])
	{
		nodePosition = position;
		nextNode = n;
		value = v;
	}
	return self;
}
-(PathNode*)next
{
	return nextNode;
}

-(void)dealloc
{
	[nodePosition release];
	// chain dealloc each node by calling this
	[nextNode release];
	[super dealloc];
}
@end

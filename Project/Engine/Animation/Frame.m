//
//  Frame.m
//  towerDefense
//
//  Created by Joey Manso on 7/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Frame.h"


@implementation Frame

@synthesize frameImage;
@synthesize frameDelay;

- (id)initWithImage:(Image*)image delay:(float)delay
{
	if(self = [super init])
	{
		frameImage = image;
		frameDelay = delay;
	}
	return self;
}

-(void)setRotationAngle:(float)rot
{
	[frameImage setRotationAngle:rot];
}

-(void)setScale:(float)s
{
	[frameImage setScale:s];
}

-(void)dealloc
{
	[frameImage dealloc];
	[super dealloc];
}

@end

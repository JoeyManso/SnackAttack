//
//  PathNode.h
//  towerDefense
//
//  Created by Joey Manso on 8/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Point2D.h"

@interface PathNode : NSObject 
{
	Point2D *nodePosition;
	PathNode *nextNode;
	uint value;
}
@property(nonatomic,readonly)Point2D* nodePosition;
@property(nonatomic,readonly)uint value;

-(id)initWithPosition:(Point2D*)position next:(PathNode*)n value:(uint)v;
-(PathNode*)next;

@end

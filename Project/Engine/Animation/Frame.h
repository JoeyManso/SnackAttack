//
//  Frame.h
//  towerDefense
//
//  Created by Joey Manso on 7/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Image.h"

@interface Frame : NSObject 
{
	// image for this frame
	Image *frameImage;
	float frameDelay;
}

@property(nonatomic, retain)Image *frameImage;
@property(nonatomic, assign)float frameDelay;

-(id)initWithImage:(Image*)image delay:(float)delay;
-(void)setRotationAngle:(float)rot;
-(void)setScale:(float)s;

@end

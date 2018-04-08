//
//  ImageObject.h
//  towerDefense
//
//  Created by Joey Manso on 7/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameObject.h"
#import "Image.h"

@interface ImageObject : GameObject 
{	
	Image *objectImage; // image that represents this object
	float objectAlpha;
    float hitBoxScale;
}
@property(nonatomic, readonly)Image* objectImage;

-(id)initWithName:(NSString*)n position:(Point2D*)p image:(Image*)i;

-(int)update:(float)deltaT;
-(int)draw;

@end


//
//  FontManager.h
//  towerDefense
//
//  Created by Joey Manso on 9/21/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Image.h"

@interface FontManager : NSObject 
{
	NSMutableDictionary *fontImages;
}

+(FontManager*)getInstance;
-(void)addFont:(NSString*)imageName scale:(float)imageScale filter:(GLenum)imageFilter;
-(Image*)getFontImage:(NSString*)imageName;
@end

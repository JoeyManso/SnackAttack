//
//  FontManager.m
//  towerDefense
//
//  Created by Joey Manso on 9/21/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "FontManager.h"

@implementation FontManager

-(id)init
{
	if(self = [super init])
		fontImages = [[NSMutableDictionary alloc] init];
	return self;
}

+(FontManager*)getInstance
{
	// return a singleton
	static FontManager *fontManagerInstance;
	
	// lock the class (for multithreading!)
	@synchronized(self)
	{
		if(!fontManagerInstance)
		{
			fontManagerInstance = [[FontManager alloc] init];
		}
	}
	return fontManagerInstance;
}
-(void)addFont:(NSString*)imageName scale:(float)imageScale filter:(GLenum)imageFilter
{
	// check to see if we have the image already, if not add it
	if([fontImages objectForKey:imageName])
		return;
	[fontImages setObject:[[Image alloc] initWithImage:[UIImage imageNamed:imageName] scale:imageScale filter:imageFilter] forKey:imageName];
}
-(Image*)getFontImage:(NSString*)imageName
{
	return [fontImages objectForKey:imageName];
}
-(void)dealloc
{
	for(NSString *key in fontImages)
		[[fontImages objectForKey:key] release];
	
	[fontImages release];
	[super dealloc];
}
@end

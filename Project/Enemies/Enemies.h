//
//  Enemies.h
//  towerDefense
//
//  Created by Joey Manso on 7/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Enemy.h"

@interface Chubby : Enemy 
{
}
-(id)initWithPosition:(Point2D*)p spriteSheet:(SpriteSheet*)ss targetNode:(PathNode*)t;
-(id)initWithPosition:(Point2D*)p hitPoints:(float)hp spriteSheet:(SpriteSheet*)ss targetNode:(PathNode*)t;

@end

@interface Jeanie : Enemy 
{
}
-(id)initWithPosition:(Point2D*)p spriteSheet:(SpriteSheet*)ss targetNode:(PathNode*)t;
-(id)initWithPosition:(Point2D*)p hitPoints:(float)hp spriteSheet:(SpriteSheet*)ss targetNode:(PathNode*)t;

@end

@interface Lanky : Enemy 
{
}
-(id)initWithPosition:(Point2D*)p spriteSheet:(SpriteSheet*)ss targetNode:(PathNode*)t;
-(id)initWithPosition:(Point2D*)p hitPoints:(float)hp spriteSheet:(SpriteSheet*)ss targetNode:(PathNode*)t;

@end

@interface Smarty : Enemy 
{
}
-(id)initWithPosition:(Point2D*)p spriteSheet:(SpriteSheet*)ss targetNode:(PathNode*)t;
-(id)initWithPosition:(Point2D*)p hitPoints:(float)hp spriteSheet:(SpriteSheet*)ss targetNode:(PathNode*)t;

@end

@interface Airplane : Enemy 
{
}
-(id)initWithPosition:(Point2D*)p spriteSheet:(SpriteSheet*)ss targetNode:(PathNode*)t;
-(id)initWithPosition:(Point2D*)p hitPoints:(float)hp spriteSheet:(SpriteSheet*)ss targetNode:(PathNode*)t;

@end

@interface Banner : Enemy 
{
}
-(id)initWithPosition:(Point2D*)p spriteSheet:(SpriteSheet*)ss targetNode:(PathNode*)t;
-(id)initWithPosition:(Point2D*)p hitPoints:(float)hp spriteSheet:(SpriteSheet*)ss targetNode:(PathNode*)t;

@end

@interface Bandie : Enemy 
{
}
-(id)initWithPosition:(Point2D*)p spriteSheet:(SpriteSheet*)ss targetNode:(PathNode*)t;
-(id)initWithPosition:(Point2D*)p hitPoints:(float)hp spriteSheet:(SpriteSheet*)ss targetNode:(PathNode*)t;

@end

@interface Cheerie : Enemy 
{
}
-(id)initWithPosition:(Point2D*)p spriteSheet:(SpriteSheet*)ss targetNode:(PathNode*)t;
-(id)initWithPosition:(Point2D*)p hitPoints:(float)hp spriteSheet:(SpriteSheet*)ss targetNode:(PathNode*)t;

@end

@interface Punkie : Enemy 
{
}
-(id)initWithPosition:(Point2D*)p spriteSheet:(SpriteSheet*)ss targetNode:(PathNode*)t;
-(id)initWithPosition:(Point2D*)p hitPoints:(float)hp spriteSheet:(SpriteSheet*)ss targetNode:(PathNode*)t;

@end

@interface Mascot : Enemy 
{
}
-(id)initWithPosition:(Point2D*)p spriteSheet:(SpriteSheet*)ss targetNode:(PathNode*)t;
-(id)initWithPosition:(Point2D*)p hitPoints:(float)hp spriteSheet:(SpriteSheet*)ss targetNode:(PathNode*)t;

@end

@interface Queenie : Enemy 
{
}
-(id)initWithPosition:(Point2D*)p spriteSheet:(SpriteSheet*)ss targetNode:(PathNode*)t;
-(id)initWithPosition:(Point2D*)p hitPoints:(float)hp spriteSheet:(SpriteSheet*)ss targetNode:(PathNode*)t;

@end

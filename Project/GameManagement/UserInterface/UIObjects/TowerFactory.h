//
//  TowerFactory.h
//  towerDefense
//
//  Created by Joey Manso on 8/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIObject.h"
#import "UIManager.h"
#import "Towers.h"
#import "UITools.h"
#import "UIBars.h"

@class Text;
@class SpriteSheet;

// reference these bars to jump between them
static TowerDetails *towerDetails;
@interface TowerFactory : UIObject 
{
@private
    TouchManager *touchMan;
@public
    Tower *tower; // pointer to the tower we create (THIS NEEDS TO BE RELEASED TO REMOVE A TOWER)
	SpriteSheet *towerSpriteSheet; // the sprite sheet that all towers created by the factory will share (yey memory!)
	uint towerCost;
	Text *towerCostText;
	BOOL renderOnSelectBar;
}
-(float)detailsBarRelativeX;
-(id)initWithPosition:(Point2D*)p;

@property(nonatomic)BOOL renderOnSelectBar;

@end

@interface VendingMachineFactory : TowerFactory 
{
}

@end

@interface FreezerFactory : TowerFactory 
{
}

@end

@interface MatronFactory : TowerFactory 
{
}

@end

@interface CookieLauncherFactory : TowerFactory 
{
}

@end

@interface PieLauncherFactory : TowerFactory 
{
}

@end

@interface PopcornMachineFactory : TowerFactory 
{
}

@end

@interface RegisterFactory : TowerFactory 
{
}

@end

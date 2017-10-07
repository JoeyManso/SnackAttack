//
//  TowerFactory.m
//  towerDefense
//
//  Created by Joey Manso on 8/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TowerFactory.h"

// private stuff
@interface TowerFactory()

-(void)createTower;
@end

@implementation TowerFactory

@synthesize renderOnSelectBar;

-(id)initWithPosition:(Point2D*)p
{
	// make sure we initialize the super class
	if(self = [super initWithPosition:p])
	{
		towerSpriteSheet = nil;
		tower = nil;
		towerCost = 0;
		towerCostText = nil;
		towerDetails = [[UIManager getInstance] getTowerDetailsBarReference];
		touchMan = [TouchManager getInstance];
		renderOnSelectBar = YES;
	}
		
	return self;
}

-(float)detailsBarRelativeX
{	
	return 0.8f * (float)[towerSpriteSheet spriteWidth];
}
-(void)createTower
{
	// rotate tower to face south
	[tower setObjectRotationAngle:180.0f];
	
	// set tower attributes
	[tower setObjectScale:UIObjectScale];
	[tower setSelected:NO];
	[towerDetails setDescription:[tower objectName] cost:[tower towerCost] range:[tower towerRange] damage:[tower towerDamage] rof:[tower towerRateOfFire] 
					   descLine1:[tower towerDescriptionText1] descLine2:[tower towerDescriptionText2] descLine3:[tower towerDescriptionText3] 
				   requiredRound:[tower minimumRound]];
	[[towerDetails currentPosition] setX:UIObjectPosition.x - [self detailsBarRelativeX]];
	[[towerDetails hidePosition] setX:UIObjectPosition.x - [self detailsBarRelativeX]];
	[[towerDetails displayPosition] setX:UIObjectPosition.x - [self detailsBarRelativeX]];
	
	// move this tower factory to the bar
	[towerDetails setTowerFactory:self];
	
	// here we hand off control of movement/placement to the touch manager
	[touchMan setPendingTower:tower];
	
	// release the initial allocation
	[tower release];
	tower = nil;

}
-(BOOL)respondToTouchAt:(CGPoint)touchPosition
{

	CGRect controlBounds = CGRectMake(UIObjectPosition.x - (([towerSpriteSheet spriteWidth] * UIObjectScale) * 0.5f), 
									  UIObjectPosition.y - (([towerSpriteSheet spriteHeight] * UIObjectScale) * 0.5f), 
									  [towerSpriteSheet spriteWidth] * UIObjectScale, 
									  [towerSpriteSheet spriteHeight] * UIObjectScale);
		
	if(CGRectContainsPoint(controlBounds, touchPosition))
	{
		if(![touchMan hasPendingTower])
			[self createTower];
		else
			return NO;
		[self playScaleAnimation];
		[towerDetails scaleTransitionSpeed:1.0f + ((UIObjectPosition.x/320.0f)-0.1f)];
		return YES;
	}
	return NO;

}
-(void)setUIObjectScale:(float)s
{
	[[towerSpriteSheet image] setScale:s];
	[towerCostText setUIObjectScale:s];
	[super setUIObjectScale:s];
}
-(void)updateUIObject:(float)deltaTime
{
	[[towerCostText UIObjectPosition] setX:UIObjectPosition.x - 10.0f y:UIObjectPosition.y - 14.0f];
	[super updateUIObject:deltaTime];
}
-(void)drawUIObject
{
	// render the first image in our tower sprite sheet for display purposes
	[self drawUIObjectAtPoint:UIObjectPosition];
}
-(void)drawUIObjectAtPoint:(Point2D*)p
{
	[towerSpriteSheet renderSpriteAtX:0 y:0 point:CGPointMake(p.x, p.y) centerOfImage:YES];
	[towerCostText drawUIObjectAtCGPoint:CGPointMake(UIObjectPosition.x - 10.0,UIObjectPosition.y - 14.0f)];
}
-(void)drawUIObjectAtCGPoint:(CGPoint)p
{
	[towerSpriteSheet renderSpriteAtX:0 y:0 point:p centerOfImage:YES];
	[towerCostText drawUIObjectAtCGPoint:CGPointMake(p.x - 10.0,p.y - 14.0f)];
}
-(void)dealloc
{
	[towerSpriteSheet dealloc];
	[towerCostText dealloc];
	[super dealloc];
}

@end

@implementation VendingMachineFactory

-(id)initWithPosition:(Point2D*)p
{
	if(self = [super initWithPosition:p])
	{
		towerSpriteSheet = [[SpriteSheet alloc] initWithImageName:@"VendingMachineSpriteSheet.png" 
													  spriteWidth:32 spriteHeight:32 spacing:0 imageScale:UIObjectScale];
		[[towerSpriteSheet image] setRotationAngle:180.0f];
		towerCost = VM_COST;
		towerCostText = [[Text alloc] initWithString:@"" position:[[Point2D alloc] init] fontName:@"CashFont"];
		[towerCostText append_uint:towerCost];
	}
	return self;
}
-(void)createTower
{
	tower = [[VendingMachine alloc] initWithPosition:[[Point2D alloc] initWithX:UIObjectPosition.x y:UIObjectPosition.y] spriteSheet:towerSpriteSheet];
	[super createTower];
}

@end

@implementation FreezerFactory

-(id)initWithPosition:(Point2D*)p
{
	if(self = [super initWithPosition:p])
	{
		towerSpriteSheet = [[SpriteSheet alloc] initWithImageName:@"FreezerSpriteSheet.png" spriteWidth:32 spriteHeight:32 spacing:0 imageScale:UIObjectScale];
		[[towerSpriteSheet image] setRotationAngle:180.0f];
		towerCost = FR_COST;
		towerCostText = [[Text alloc] initWithString:@"" position:[[Point2D alloc] init] fontName:@"CashFont"];
		[towerCostText append_uint:towerCost];
	}
	return self;
}
-(void)createTower
{
	tower = [[Freezer alloc] initWithPosition:[[Point2D alloc] initWithX:UIObjectPosition.x y:UIObjectPosition.y] spriteSheet:towerSpriteSheet];
	[super createTower];
}

@end

@implementation MatronFactory

-(id)initWithPosition:(Point2D*)p
{
	if(self = [super initWithPosition:p])
	{
		towerSpriteSheet = [[SpriteSheet alloc] initWithImageName:@"MatronSpriteSheet.png" spriteWidth:32 spriteHeight:32 spacing:0 imageScale:UIObjectScale];
		[[towerSpriteSheet image] setRotationAngle:180.0f];
		towerCost = MT_COST;
		towerCostText = [[Text alloc] initWithString:@"" position:[[Point2D alloc] init] fontName:@"CashFont"];
		[towerCostText append_uint:towerCost];
	}
	return self;
}
-(void)createTower
{
	tower = [[Matron alloc] initWithPosition:[[Point2D alloc] initWithX:UIObjectPosition.x y:UIObjectPosition.y] spriteSheet:towerSpriteSheet];
	[super createTower];
}

@end

@implementation CookieLauncherFactory

-(id)initWithPosition:(Point2D*)p
{
	if(self = [super initWithPosition:p])
	{
		towerSpriteSheet = [[SpriteSheet alloc] 
							initWithImageName:@"CookieShellerSpriteSheet.png" spriteWidth:32 spriteHeight:32 spacing:0 imageScale:UIObjectScale];
		[[towerSpriteSheet image] setRotationAngle:180.0f];
		towerCost = CL_COST;
		towerCostText = [[Text alloc] initWithString:@"" position:[[Point2D alloc] init] fontName:@"CashFont"];
		[towerCostText append_uint:towerCost];
	}
	return self;
}
-(void)createTower
{
	tower = [[CookieLauncher alloc] initWithPosition:[[Point2D alloc] initWithX:UIObjectPosition.x y:UIObjectPosition.y] spriteSheet:towerSpriteSheet];
	[super createTower];
}

@end

@implementation PieLauncherFactory

-(id)initWithPosition:(Point2D*)p
{
	if(self = [super initWithPosition:p])
	{
		towerSpriteSheet= [[SpriteSheet alloc] initWithImageName:@"PieLauncherSpriteSheet.png" spriteWidth:32 spriteHeight:32 spacing:0 imageScale:UIObjectScale];
		[[towerSpriteSheet image] setRotationAngle:180.0f];
		towerCost = PL_COST;
		towerCostText = [[Text alloc] initWithString:@"" position:[[Point2D alloc] init] fontName:@"CashFont"];
		[towerCostText append_uint:towerCost];
	}
	return self;
}
-(void)createTower
{
	tower = [[PieLauncher alloc] initWithPosition:[[Point2D alloc] initWithX:UIObjectPosition.x y:UIObjectPosition.y] spriteSheet:towerSpriteSheet];
	[super createTower];
}

@end

@implementation PopcornMachineFactory

-(id)initWithPosition:(Point2D*)p
{
	if(self = [super initWithPosition:p])
	{
		towerSpriteSheet = [[SpriteSheet alloc] initWithImageName:@"PopcornSpriteSheet.png" spriteWidth:32 spriteHeight:32 spacing:0 imageScale:UIObjectScale];
		[[towerSpriteSheet image] setRotationAngle:180.0f];
		towerCost = PM_COST;
		towerCostText = [[Text alloc] initWithString:@"" position:[[Point2D alloc] init] fontName:@"CashFont"];
		[towerCostText append_uint:towerCost];
	}
	return self;
}
-(void)createTower
{
	tower = [[PopcornMachine alloc] initWithPosition:[[Point2D alloc] initWithX:UIObjectPosition.x y:UIObjectPosition.y] spriteSheet:towerSpriteSheet];
	[super createTower];
}

@end

@implementation RegisterFactory

-(id)initWithPosition:(Point2D*)p
{
	if(self = [super initWithPosition:p])
	{
		towerSpriteSheet = [[SpriteSheet alloc] initWithImageName:@"CashRegisterSpriteSheet.png" spriteWidth:32 spriteHeight:32 spacing:0 
													   imageScale:UIObjectScale];
		[[towerSpriteSheet image] setRotationAngle:180.0f];
		towerCost = RG_COST;
		towerCostText = [[Text alloc] initWithString:@"" position:[[Point2D alloc] init] fontName:@"CashFont"];
		[towerCostText append_uint:towerCost];
	}
	return self;
}
-(void)createTower
{
	tower = [[Register alloc] initWithPosition:[[Point2D alloc] initWithX:UIObjectPosition.x y:UIObjectPosition.y] spriteSheet:towerSpriteSheet];
	[super createTower];
}

@end

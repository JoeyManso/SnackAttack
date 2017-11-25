//
//  ViewManager.m
//  towerDefense
//
//  Created by Joey Manso on 8/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ViewManager.h"
#import "GameState.h"
#import "GameView.h"
#import "MenuView.h"
#import "TextView.h"
#import "Image.h"

static Image *baseBackgroundImage;
static Image *baseBackgroundMaskLowerImage;
static Image *baseBackgroundMaskUpperImage;
static MenuButton *resumeButton;
static BOOL ignoreTouchesEnded;

@interface ViewManager()
-(void)initOpenGL;
@end

@implementation ViewManager

@synthesize screenBounds;
@synthesize screenScale;
@synthesize screenSize;

- (id)init 
{
	if(self = [super init])
	{
        screenBounds = [[UIScreen mainScreen] bounds];
        screenScale = [[UIScreen mainScreen] scale];
        screenSize = CGSizeMake(screenBounds.size.width * screenScale,
                                screenBounds.size.height * screenScale);
        
        float buttonYLower = 130;
        float buttonBaseX = screenBounds.size.width / 2;
        float buttonBaseY = screenBounds.size.height - buttonYLower;
        
        float buttonHeight = 64;
        // Space on the main menu used for buttons
        float buttonSpace = buttonBaseY - buttonYLower;
        // Padding between buttons, based on there being 4 buttons displayed
        float buttonTween = buttonHeight + ((buttonSpace - (3 * buttonHeight)) / 3);
        
		// Initialize OpenGL
		[self initOpenGL];
		
		if(!baseBackgroundImage)
			baseBackgroundImage = [[Image alloc] initWithImage:[UIImage imageNamed:@"BackgroundMenu.png"] filter:GL_LINEAR];
        if(!baseBackgroundMaskLowerImage)
            baseBackgroundMaskLowerImage = [[Image alloc] initWithImage:[UIImage imageNamed:@"BackgroundMaskLower.png"] filter:GL_LINEAR];
        if(!baseBackgroundMaskUpperImage)
            baseBackgroundMaskUpperImage = [[Image alloc] initWithImage:[UIImage imageNamed:@"BackgroundMaskUpper.png"] filter:GL_LINEAR];
		
		// initialize the view dictionary
		appViews = [[NSMutableDictionary alloc] init];
		
		MenuView *menu = [[MenuView alloc] initWithTitle:[[Image alloc] initWithImage:[UIImage imageNamed:@"TitleMenu.png"] filter:GL_LINEAR]
											  background:baseBackgroundImage backgroundMaskLower:baseBackgroundMaskLowerImage backgroundMaskUpper:baseBackgroundMaskUpperImage];
		
		resumeButton = [[MenuButton alloc] initWithImage:[[Image alloc] initWithImage:[UIImage imageNamed:@"ButtonResume.png"] filter:GL_LINEAR]
												position:[[Point2D alloc]
                                                          initWithX:buttonBaseX y:buttonBaseY]
                                                    type:MENU_BUTTON_RESUME];
		[resumeButton setActive:NO];
		
		[menu addButton:resumeButton];
		[menu addButton:[[MenuButton alloc] initWithImage:[[Image alloc] initWithImage:[UIImage imageNamed:@"ButtonNewGame.png"] filter:GL_LINEAR]
												 position:[[Point2D alloc]
                                                           initWithX:buttonBaseX y:buttonBaseY - buttonTween]
                                                     type:MENU_BUTTON_NEWGAME]];
		[menu addButton:[[MenuButton alloc] initWithImage:[[Image alloc] initWithImage:[UIImage imageNamed:@"ButtonInstructions.png"] filter:GL_LINEAR]
												 position:[[Point2D alloc]
                                                           initWithX:buttonBaseX y:buttonBaseY - (buttonTween * 2)]
                                                     type:MENU_BUTTON_INSTRUCTIONS]];
		[menu addButton:[[MenuButton alloc] initWithImage:[[Image alloc] initWithImage:[UIImage imageNamed:@"ButtonCredits.png"] filter:GL_LINEAR]
												 position:[[Point2D alloc]
                                                           initWithX:buttonBaseX y:buttonBaseY - (buttonTween * 3)]
                                                     type:MENU_BUTTON_CREDITS]];
		
		// Initialize the game views and add them to our dictionary
		[appViews setObject:[[GameView alloc] init] forKey:@"game"];
		[appViews setObject:menu forKey:@"mainMenu"];
		[appViews setObject:[[TextView alloc] initWithTitle:[[Image alloc] initWithImage:[UIImage imageNamed:@"TitleInstructions.png"]]
													 images:[[NSMutableArray alloc] initWithObjects:
															 [[Image alloc] initWithImage:[UIImage imageNamed:@"TextInstructions4.png"]],
															 [[Image alloc] initWithImage:[UIImage imageNamed:@"TextInstructions3.png"]],
															 [[Image alloc] initWithImage:[UIImage imageNamed:@"TextInstructions2.png"]],
															 [[Image alloc] initWithImage:[UIImage imageNamed:@"TextInstructions1.png"]], nil]
												 background:baseBackgroundImage backgroundMaskLower:baseBackgroundMaskLowerImage backgroundMaskUpper:baseBackgroundMaskUpperImage] forKey:@"instructions"];
		[appViews setObject:[[TextView alloc] initWithTitle:[[Image alloc] initWithImage:[UIImage imageNamed:@"TitleCredits.png"]]
													 images:[[NSMutableArray alloc] initWithObjects:
															 [[Image alloc] initWithImage:[UIImage imageNamed:@"TextCredits.png"]], nil]
												 background:baseBackgroundImage backgroundMaskLower:baseBackgroundMaskLowerImage backgroundMaskUpper:baseBackgroundMaskUpperImage] forKey:@"credits"];
		
		// get the current view we want to start with
		currentView = [appViews objectForKey:@"mainMenu"];
		ignoreTouchesEnded = NO;
	}
	return self;
}

+(ViewManager*)getInstance
{
	// return a singleton
	static ViewManager *sharedViewManagerInstance;
	
	// lock the class (for multithreading!)
	@synchronized(self)
	{
		if(!sharedViewManagerInstance)
			sharedViewManagerInstance = [[ViewManager alloc] init];
	}
	return sharedViewManagerInstance;
}

- (void)initOpenGL 
{
	// Switch to GL_PROJECTION matrix mode and reset the current matrix with the identity matrix
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	
	glOrthof(0, screenBounds.size.width, 0, screenBounds.size.height, -1, 1);
	
	// Switch to GL_MODELVIEW so we can now draw our objects
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
	
	// Setup how textures should be rendered i.e. how a texture with alpha should be rendered ontop of
	// another texture.
	glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_BLEND_SRC);
	
	// We are not using the depth buffer in our 2D game so depth testing can be disabled.  If depth
	// testing was required then a depth buffer would need to be created as well as enabling the depth
	// test
	glDisable(GL_DEPTH_TEST);
	
	// Set the color to use when clearing the screen with glClear
	glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
}

-(void)showMainMenu
{
	ignoreTouchesEnded = YES;
	currentView = [appViews objectForKey:@"mainMenu"];
}
-(void)showMainMenuDeactivateResume
{
	[resumeButton setActive:NO];
	[self showMainMenu];
}
-(void)showMainMenuNoIgnore
{
	currentView = [appViews objectForKey:@"mainMenu"];
}
-(void)newGame
{
	ignoreTouchesEnded = YES;
	[resumeButton setActive:YES];
	currentView = [appViews objectForKey:@"game"];
	[[GameState sharedGameStateInstance] resetGame];
}
-(void)showInstructions
{
	currentView = [appViews objectForKey:@"instructions"];
}
-(void)showCredits
{
	currentView = [appViews objectForKey:@"credits"];
}
-(void)resumeGame
{
	currentView = [appViews objectForKey:@"game"];
}
-(void)updateCurrentView:(float)deltaTime
{
	[currentView updateView:deltaTime];
}

-(void)drawCurrentView
{
	glViewport(0, 0, screenBounds.size.width , screenBounds.size.height);
	
	// Clear the screen
	glClear(GL_COLOR_BUFFER_BIT);
	
	// render current view
	[currentView drawView];
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event withView:(UIView*)view
{
	[currentView updateWithTouchLocationBegan:touches withEvent:event withView:view];
}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event withView:(UIView*)view
{
	[currentView updateWithTouchLocationMoved:touches withEvent:event withView:view];
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event withView:(UIView*)view
{
	if(!ignoreTouchesEnded)
		[currentView updateWithTouchLocationEnded:touches withEvent:event withView:view];
	ignoreTouchesEnded = NO;
}

-(void)dealloc
{
	for(NSString *key in appViews)
		[[appViews objectForKey:key] release];
	[appViews release];
	[baseBackgroundImage dealloc];
    [baseBackgroundMaskLowerImage dealloc];
    [baseBackgroundMaskUpperImage dealloc];
	[super dealloc];
}

@end

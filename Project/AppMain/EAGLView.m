//
//  EAGLView.m
//  Practice1
//
//  Created by Joey Manso on 7/12/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//



#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/EAGLDrawable.h>

#import "EAGLView.h"

#define USE_DEPTH_BUFFER 0

// A class extension to declare private methods
@interface EAGLView ()

@property (nonatomic, retain) EAGLContext *context;

- (BOOL) createFramebuffer;
- (void) destroyFramebuffer;
- (void) drawView;

@end

@implementation EAGLView

@synthesize context;

// You must implement this method
+ (Class)layerClass 
{
    return [CAEAGLLayer class];
}


//The GL view is stored in the nib file. When it's unarchived it's sent -initWithCoder:
- (id)initWithFrame:(CGRect)frame 
{
    if ((self = [super initWithFrame:frame])) 
	{		
        // Get the layer
        CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
        
        eaglLayer.opaque = YES;
        eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8,	kEAGLDrawablePropertyColorFormat, nil];
        
        context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
        
        if (!context || ![EAGLContext setCurrentContext:context]) 
		{
            [self release];
            return nil;
        }
		
		viewMan = [ViewManager getInstance];
        [viewMan postInit];
    }
    return self;
}

- (void)mainLoop
{
	// Create variables to hold the current time and calculated delta
	CFTimeInterval time;
	float deltaTime;
	
	// we're getting a massive first delta time when we load, so we have to do this.
	lastTime = CACurrentMediaTime();
	
	// This is the heart of the game loop and will keep on looping until it is told otherwise
	while(true) 
	{
		// Create an autorelease pool which can be used within this tight loop.  This is a memory
		// leak when using NSString stringWithFormat in the renderScene method.  Adding a specific
		// autorelease pool stops the memory leak
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		
		// I found this trick on iDevGames.com.  The command below pumps events which take place
		// such as screen touches etc so they are handled and then runs our code.  This means
		// that we are always in sync with VBL rather than an NSTimer and VBL being out of sync
		while(CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.002, TRUE) == kCFRunLoopRunHandledSource);
		
		// Get the current time and calculate the delta between the lasttime and now
		time = CACurrentMediaTime();
		deltaTime = MIN((time-lastTime), 0.166666666666667f);
		
		// Go and update the game logic and then render the scene
		[viewMan updateCurrentView:deltaTime];
		[self drawView];
		
		// Set the lasttime to the current time ready for the next pass
		lastTime = time;
		
		// Release the autorelease pool so that it is drained
		[pool release];
	}	
}

- (void)drawView 
{
	// Set the current EAGLContext and bind to the framebuffer.  This will direct all OGL commands to the
	// framebuffer and the associated renderbuffer attachment which is where our scene will be rendered
	[EAGLContext setCurrentContext:context];
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
	
	// Setup how the images are to be blended when rendered.  This could be changed at different points during your
	// render process if you wanted to apply different effects
	//glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	[viewMan drawCurrentView];
	
    // Bind to the renderbuffer and then present this image to the current context
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
    [context presentRenderbuffer:GL_RENDERBUFFER_OES];
}

- (void)layoutSubviews 
{
    [EAGLContext setCurrentContext:context];
    [self destroyFramebuffer];
    [self createFramebuffer];
    [self drawView];
}


- (BOOL)createFramebuffer
{
    glGenFramebuffersOES(1, &viewFramebuffer);
    glGenRenderbuffersOES(1, &viewRenderbuffer);
    
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
    [context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:(CAEAGLLayer*)self.layer];
    glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, viewRenderbuffer);
    
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &backingWidth);
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &backingHeight);
    
    if (USE_DEPTH_BUFFER) {
        glGenRenderbuffersOES(1, &depthRenderbuffer);
        glBindRenderbufferOES(GL_RENDERBUFFER_OES, depthRenderbuffer);
        glRenderbufferStorageOES(GL_RENDERBUFFER_OES, GL_DEPTH_COMPONENT16_OES, backingWidth, backingHeight);
        glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_DEPTH_ATTACHMENT_OES, GL_RENDERBUFFER_OES, depthRenderbuffer);
    }
    
    if(glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES) {
        NSLog(@"failed to make complete framebuffer object %x", glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
        return NO;
    }
    
    return YES;
}


- (void)destroyFramebuffer 
{    
    glDeleteFramebuffersOES(1, &viewFramebuffer);
    viewFramebuffer = 0;
    glDeleteRenderbuffersOES(1, &viewRenderbuffer);
    viewRenderbuffer = 0;
    
    if(depthRenderbuffer) 
	{
        glDeleteRenderbuffersOES(1, &depthRenderbuffer);
        depthRenderbuffer = 0;
    }
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
	//touches is a list of all touch events (multiple fingers)
	[viewMan touchesBegan:touches withEvent:event withView:self];
}
- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
	[viewMan touchesMoved:touches withEvent:event withView:self];
}
- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
	[viewMan touchesEnded:touches withEvent:event withView:self];
}

- (void)dealloc 
{   
    if ([EAGLContext currentContext] == context) 
	{
        [EAGLContext setCurrentContext:nil];
    }
    
	[viewMan release];
    [context release];  
    [super dealloc];
}

@end

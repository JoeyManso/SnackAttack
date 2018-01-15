//
//  AngelCodeFont.m
//  Tutorial1
//
//  Created by Michael Daley on 08/03/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
/*
 Whilst looking for how to render Bitmap Fonts I found this page http://www.angelcode.com/products/bmfont/
 
 They have an application which can take a true type font and turn it into a spritesheet and control file.
 With these files you can then render a string to the screen using the font generated.  I develop of a Mac of
 course so was disappointed that this app was for Windows.  Fear not, luckily a tool has been developed by
 Kev Glass over at http://slick.cokeandcode.com/index.php for use with his open source Java 2D game library.
 The app is called Hiero. 
 
 This generates the necessary image file and control file in the format defined on the AngelCode Font website.
 Hiero has also been updated recently to handle Unicode fonts as well accoriding to the forums and this new 
 versions webstart can be found here http://www.n4te.com/hiero/hiero.jnlp 
 
 Being Java this version will work on any platform :o)
 
 This implementation has been tested against the output from Hiero V2
 */

#import "AngelCodeFont.h"
#import "GameState.h"

@interface AngelCodeFont ()
- (void)parseFont:(NSString*)controlFile;
- (void)parseCharacterDefinition:(NSString*)line charDef:(CharDef*)CharDef;
- (void)parseKerningCapacity:(NSString*)line;
- (void)parseKerningEntry:(NSString*)line;
- (int)kerningAmountForFirst:(unichar)first second:(unichar)second;
- (void)initVertexArrays:(int)totalQuads;

@end

@implementation AngelCodeFont

@synthesize scale;
@synthesize useKerning;

- (id)initWithFontImageNamed:(NSString*)fontImage controlFile:(NSString*)controlFile scale:(float)fontScale filter:(GLenum)filter 
{
	if (self = [self init]) 
	{
		if(!fontMan)
			fontMan = [FontManager getInstance];
	
		fontImageName = [fontImage copy];
		
		// add our image to the manager (so we only allocate it once per font type)
		[fontMan addFont:fontImage scale:fontScale filter:filter];
		
		// Set the scale to be used for the font
		scale = fontScale;
		
		// Set the kerningDictionary to nil.  This will be used when processing any kerning info
		KerningDictionary = nil;
		
		// Default for kerning is off
		useKerning = NO;
		
		rgba[0] = 1.0f;
		rgba[1] = 1.0f;
		rgba[2] = 1.0f;
		rgba[3] = 1.0f;
		// Parse the control file and populate charsArray which the character definitions
		[self parseFont:controlFile];
		
		// Now we have passed the font control file we know how many characters we have so we can set
		// up the vertext arrays
		[self initVertexArrays:kMaxCharsInMessage];
	}
	return self;
}

- (void)parseFont:(NSString*)controlFile 
{
	
	// Read the contents of the file into a string
	NSString *contents = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:controlFile ofType:@"fnt"] encoding:NSUTF8StringEncoding error:NULL];
	
	// Move all lines in the string, which are denoted by \n, into an array
	NSArray *lines = [[NSArray alloc] initWithArray:[contents componentsSeparatedByString:@"\n"]];
	
	// Create an enumerator which we can use to move through the lines read from the control file
	NSEnumerator *nse = [lines objectEnumerator];
	
	// Create a holder for each line we are going to work with
	NSString *line;
	
	// A holder for the number of characters read in from the font file
	int numberOfFontChars = 0;
	
	// Loop through all the lines in the lines array processing each one
	while(line = [nse nextObject]) 
	{
		// Check to see if the start of the line is something we are interested in
		// i can't believe this method exists
		if([line hasPrefix:@"chars c"]) 
		{
			// Ignore this line
		} 
		else if([line hasPrefix:@"char"]) 
		{
			// Parse the current line and create a new CharDef
			CharDef *characterDefinition = [[[CharDef alloc] initCharDefWithFontImage:[fontMan getFontImage:fontImageName] scale:scale] retain];
			[self parseCharacterDefinition:line charDef:characterDefinition];
			
			// Add the CharDef returned to the charArray
			charsArray[[characterDefinition charID]] = characterDefinition;
			//[characterDefinition release];
			
			// Increment the total number of characters
			numberOfFontChars++;
		}
		else if([line hasPrefix:@"kernings count"]) 
		{
			[self parseKerningCapacity:line];
		} 
		else if([line hasPrefix:@"kerning first"]) 
		{
			if(useKerning)
				[self parseKerningEntry:line];
		}
	}
	// Finished with lines so release it
	[lines release];
}


- (void)initVertexArrays:(int)totalQuads 
{
	// Init the texture, vertices and indices arrays ready for taking data.  The size we allocate
	// to these arrays is based on the number of characters (quads) read from the font control file
	texCoords = malloc(sizeof(texCoords[0]) * totalQuads);
	vertices = malloc(sizeof(vertices[0]) * totalQuads);
	indices = malloc(sizeof(indices[0]) * totalQuads * 6);
	
	bzero(texCoords, sizeof(texCoords[0]) * totalQuads);
	bzero(vertices, sizeof(vertices[0]) * totalQuads);
	bzero(indices, sizeof(indices[0]) * totalQuads * 6);
	
	for( NSUInteger i=0;i<totalQuads;i++) 
	{
		indices[i*6+0] = i*4+0;
		indices[i*6+1] = i*4+1;
		indices[i*6+2] = i*4+2;
		indices[i*6+5] = i*4+1;
		indices[i*6+4] = i*4+2;
		indices[i*6+3] = i*4+3;			
	}	
}

- (void)parseKerningCapacity:(NSString*)line 
{
	// Break the values for this line up using =
	NSArray *values = [line componentsSeparatedByString:@"="];
	NSEnumerator *nse = [values objectEnumerator];
	NSString *propertyValue;
	
	// We need to move past the first entry in the array before we start assigning values
	[nse nextObject];
	
	// Get the kerning count
	propertyValue = [nse nextObject];
	int capacity = [propertyValue intValue];
	if(capacity!=-1)
		KerningDictionary = [[NSMutableDictionary dictionaryWithCapacity:[propertyValue intValue]] retain];
}


// Added 07/05/09
- (void)parseKerningEntry:(NSString*)line 
{
	NSArray *values = [line componentsSeparatedByString:@"="];
	NSEnumerator *nse = [values objectEnumerator];
	NSString *propertyValue;
	
	// Move past the first entry before we start assinging values
	[nse nextObject];
	
	// First
	propertyValue = [nse nextObject];
	int first = [propertyValue intValue];
	
	// Second
	propertyValue = [nse nextObject];
	int second = [propertyValue intValue];
	
	// Amount
	propertyValue = [nse nextObject];
	int amount = [propertyValue intValue];
	
	NSString *key = [NSString stringWithFormat:@"%d,%d", first, second];
	NSNumber *value = [NSNumber numberWithInt:amount];
	
	[KerningDictionary setObject:value forKey:key];
}


// Added 07/05/09
- (int)kerningAmountForFirst:(unichar)first second:(unichar)second 
{
	int ret = 0;
	NSString *key = [NSString stringWithFormat:@"%d,%d", first, second];
	NSNumber *value = [KerningDictionary objectForKey:key];
	if(value)
		ret = [value intValue];
	
	return ret;
}

- (void)parseCharacterDefinition:(NSString*)line charDef:(CharDef*)characterDefinition 
{	
	// Grab all individual value for each character
	
	// Break the values for this line up using =
	NSArray *values = [line componentsSeparatedByString:@"="];
	
	// Get the enumerator for the array of components which has been created
	NSEnumerator *nse = [values objectEnumerator];
	
	// We are going to place each value we read from the line into this string
	NSString *propertyValue;
	
	// We need to move past the first entry in the array before we start assigning values
	[nse nextObject];
	
	// Character ID
	propertyValue = [nse nextObject];
	[characterDefinition setCharID:[propertyValue intValue]];
	// Character x
	propertyValue = [nse nextObject];
	[characterDefinition setX:[propertyValue intValue]];
	// Character y
	propertyValue = [nse nextObject];
	[characterDefinition setY:[propertyValue intValue]];
	// Character width
	propertyValue = [nse nextObject];
	[characterDefinition setWidth:[propertyValue intValue]];
	// Character height
	propertyValue = [nse nextObject];
	[characterDefinition setHeight:[propertyValue intValue]];
	// Character xoffset
	propertyValue = [nse nextObject];
	[characterDefinition setXOffset:[propertyValue intValue]];
	// Character yoffset
	propertyValue = [nse nextObject];
	[characterDefinition setYOffset:[propertyValue intValue]];
	// Character xadvance
	propertyValue = [nse nextObject];
	[characterDefinition setXAdvance:[propertyValue intValue]];
}


- (void)drawStringAt:(CGPoint)point text:(NSString*)text 
{
    if(sharedGameState == nil)
    {
        sharedGameState = [GameState sharedGameStateInstance];
    }
	// Renders the given text with this font at the point given	
	
	// Reset the number of quads which are going to be drawn
	int currentQuad = 0;
	
	// Enable those states necessary to draw with textures and allow blending
	glEnable(GL_TEXTURE_2D);
	glEnable(GL_BLEND);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	glEnableClientState(GL_VERTEX_ARRAY);
	
	// Setup how the text is to be blended
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	
	// Bind to the texture which was generated for the spritesheet image used for this font.  We only
	// need to bind once before the drawing as all characters are on the same texture.
	
	// check gamestate to make sure we don't rebind a texture if we don't have to
	if([[[fontMan getFontImage:fontImageName] texture] name] != [sharedGameState currentlyBoundTexture])
	{
		[sharedGameState setCurrentlyBoundTexture:[[[fontMan getFontImage:fontImageName] texture] name]];
		glBindTexture(GL_TEXTURE_2D, [[[fontMan getFontImage:fontImageName] texture] name]);
	}
	
	// Set up the previous character and kerning amount vars
	unichar previousChar = -1;
	int kerningAmount = 0;
	
	// Loop through all the characters in the text
	for(int i=0; i<[text length]; ++i) 
	{
		// Grab the unicode value of the current character
		unichar charID = [text characterAtIndex:i];
		
		// Look up the kerning information for the previous char and this current char
		kerningAmount = [self kerningAmountForFirst:previousChar second:charID];
		
		// Move x based on the kerning info
		point.x += kerningAmount * scale;
		
		// Only render the current character if it is going to be visible otherwise move the variables such as currentQuad and point.x
		// as normal but don't render the character which should save some cycles
		if(point.x > 0 - ([charsArray[charID] width] * scale) || 
		   point.x < [[UIScreen mainScreen] bounds].size.width || 
		   point.y > 0 - ([charsArray[charID] height] * scale) || 
		   point.y < [[UIScreen mainScreen] bounds].size.height) {
			
			// Using the current x and y, calculate the correct position of the character using the x and y offsets for each character.
			// This will cause the characters to all sit on the line correctly with tails below the line etc.
			CGPoint newPoint = CGPointMake(point.x, 
										   point.y - ([charsArray[charID] yOffset] + [charsArray[charID] height]) * [charsArray[charID] scale]);
			
			// Create a point into the bitmap font spritesheet using the coords read from the control file for this character
			CGPoint pointOffset = CGPointMake([charsArray[charID] x], [charsArray[charID] y]);
			
			// Calculate the texture coordinates and quad vertices for the current character
			[[charsArray[charID] image] calculateTexCoordsAtOffset:pointOffset subImageWidth:[charsArray[charID] width] subImageHeight:[charsArray[charID] height]];
			[[charsArray[charID] image] calculateVerticesAtPoint:newPoint subImageWidth:[charsArray[charID] width] subImageHeight:[charsArray[charID] height] centerOfImage:NO];
			
			// Place the calculated texture coordinates and quad vertices into the arrays we will use when drawing out string
			texCoords[currentQuad] = *[[charsArray[charID] image] texCoords];
			vertices[currentQuad] = *[[charsArray[charID] image] vertices];			
			
			// Increment quad count
			currentQuad++;
		}
		
		// Move the x location along by the amount defined for this character in the control file so the charaters are spaced
		// correctly
		point.x += [charsArray[charID] xAdvance] * scale;
		
		// Store the character just processed as the previous char for looking up any kerning info
		previousChar = charID;
	}
	
	// Now that we have calculated all the quads and textures for the string we are drawing we can draw them all
	
	glVertexPointer(2, GL_FLOAT, 0, vertices);
	glTexCoordPointer(2, GL_FLOAT, 0, texCoords);
	glColor4f(rgba[0], rgba[1], rgba[2], rgba[3]);
	glDrawElements(GL_TRIANGLES, currentQuad*6, GL_UNSIGNED_SHORT, indices);
	glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
	glDisable(GL_TEXTURE_2D);
	glDisable(GL_BLEND);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	glDisableClientState(GL_VERTEX_ARRAY);
}


- (int)getWidthForString:(NSString*)string
{
	// Set up stringWidth
	int stringWidth = 0;
	
	// Loop through the characters in the text and sum the xAdvance for each one
	// xAdvance holds how far to move long X for each character so that the correct
	// space is left after each character
	for(int index=0; index<[string length]; ++index) 
	{
		int charID = [string characterAtIndex:index];
		
		// Add the xAdvance value of the current character to stringWidth scaling as necessary
		stringWidth += [charsArray[charID] xAdvance] * scale;
	}	
	// Return the total width calculated
	return stringWidth;
}


- (int)getHeightForString:(NSString*)string 
{
	// Set up stringHeight	
	int stringHeight = 0;
	
	// Loop through the characters in the text and sum the height.  The sum will take into
	// account the offset of the character as some characters sit below the line etc
	for(int i=0; i<[string length]; ++i) 
	{
		int charID = [string characterAtIndex:i];
		
		// Don't bother checking if the character is a space as they have no height
		if(charID == ' ')
			continue;
		
		// Check to see if the height of the current character is greater than the current max height
		// If so then replace the current stringHeight with the height of the current character
		stringHeight = MAX(([charsArray[charID] height] * scale) + ([charsArray[charID] yOffset] * scale), stringHeight);
	}	
	// Return the total height calculated
	return stringHeight;	
}


- (void)setRgba:(float)red green:(float)green blue:(float)blue alpha:(float)alpha 
{
	// Set the colour filter of the spritesheet image used for this font
	rgba[0] = red;
	rgba[1] = green;
	rgba[2] = blue;
	rgba[3] = alpha;
}
-(void)setAlpha:(float)alpha
{
	rgba[3] = alpha;
}


- (void)setScale:(float)newScale 
{
	scale = newScale;
}


- (void)dealloc 
{
	free(texCoords);
	free(vertices);
	free(indices);
	// Free the objects which are being held within the charsArray
	for(int i=0; i < kMaxCharsInFont; i++) 
	{
		[charsArray[i] release];
	}
	
	[KerningDictionary release];
	[super dealloc];
}

@end

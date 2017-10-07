//
//  SoundManager.m
//  towerDefense
//
//  Created by Joey Manso on 8/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SoundManager.h"
#import "MyOpenALSupport.h"
// singleton instance
static SoundManager *soundManagerInstance;

@interface SoundManager()


-(BOOL)initOpenAL;
-(NSUInteger)nextAvailableSource;
-(AudioFileID)openAudioFile:(NSString*)filePath;
-(UInt32)audioFileSize:(AudioFileID)fileDescriptor;

-(void)loadSoundWithKey:(NSString*)k fileName:(NSString*)file fileExt:(NSString*)ext;
-(void)loadMusicWithKey:(NSString*)k fileName:(NSString*)file fileExt:(NSString*)ext;

// Used to set the current state of OpenAL.  Then the game is interrupted the OpenAL state is
// stopped and then restarted when the game becomes active again.
- (void)setActivated:(BOOL)aState;
@end

@implementation SoundManager

// Method which handles an interruption message from the audio session.  It reacts to the
// type of interruption state i.e. beginInterruption or endInterruption
void interruptionListener(	void *inClientData, UInt32 inInterruptionState)
{  
	SoundManager *soundManager = [SoundManager getInstance];
    
    if (inInterruptionState == kAudioSessionBeginInterruption)
	{
        [soundManager setActivated:NO];
	}
	else if	(inInterruptionState == kAudioSessionEndInterruption) 
	{
        OSStatus result = [[AVAudioSession sharedInstance] setActive:YES error:nil];
		if (result) printf("Error setting audio session active! %d\n", result);
        [soundManager setActivated:YES];
	}
}

+(SoundManager*)getInstance
{	
	// lock the class (for multithreading!)
	@synchronized(self)
	{
		if(!soundManagerInstance)
			soundManagerInstance = [[SoundManager alloc] init];
	}
	
	return soundManagerInstance;
}

+(id)allocWithZone:(NSZone*)zone
{
	@synchronized(self)
	{
		if(!soundManagerInstance)
		{
			soundManagerInstance = [super allocWithZone:zone];
			return soundManagerInstance;
		}
	}
	return nil;
}

-(id)copyWithZone:(NSZone*)zone
{
	return self;
}

- (id)init
{
	if(self = [super init]) 
	{
		// Register to be notified of both the UIApplicationWillResignActive and UIApplicationDidBecomeActive.
		// Set up notifications that will let us know if the application resigns being active or becomes active
		/* this is bugging out hard core so we'll take it out for now...
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:) 
                                                     name:@"UIApplicationWillResignActiveNotification" object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) 
                                                     name:@"UIApplicationDidBecomeActiveNotification" object:nil];
		 */
		
		soundSources = [[NSMutableArray alloc] init];
		soundLibrary = [[NSMutableDictionary alloc] init];
		musicLibrary = [[NSMutableDictionary alloc] init];
		
		// Set the default volume for music
		musicVolume = 1.0f;
		
		// Set up the OpenAL
		BOOL result = [self initOpenAL];
		if(!result)	return nil;
		return self;
	}
	[self release];
	return nil;
}

- (BOOL)initOpenAL 
{
    //if (DEBUG) NSLog(@"INFO - Sound Manager: Initializing sound manager");
	
    // Get the device we are going to use for sound.  Using NULL gets the default device
	device = alcOpenDevice(NULL);
	
	// If a device has been found we then need to create a context, make it current and then
	// preload the OpenAL Sources
	if(device) 
	{
		// Use the device we have now got to create a context in which to play our sounds
		context = alcCreateContext(device, NULL);
        
		// Make the context we have just created into the active context
		alcMakeContextCurrent(context);
        
        // Set the distance model to be used
        alDistanceModel(AL_LINEAR_DISTANCE_CLAMPED);
        
		// Pre-create 32 sound sources which can be dynamically allocated to buffers (sounds)
		unsigned int sourceID;
		for(int index = 0; index < kMaxSources; index++)
		{
			// Generate an OpenAL source
			alGenSources(1, &sourceID);
            
            // Configure the generated source so that sounds fade as the player moves
            // away from them
            alSourcef(sourceID, AL_REFERENCE_DISTANCE, 50.0F);
            alSourcef(sourceID, AL_MAX_DISTANCE, 250.0f);
            alSourcef(sourceID, AL_ROLLOFF_FACTOR, 25.0f);
            
            //if (DEBUG) NSLog(@"INFO - Sound Manager: Generated source id '%d'", sourceID);
            
			// Add the generated sourceID to our array of sound sources
			[soundSources addObject:[NSNumber numberWithUnsignedInt:sourceID]];
		}
        
        //if (DEBUG) NSLog(@"INFO - Sound Manager: Finished initializing the sound manager");
		// Return YES as we have successfully initialized OpenAL
		return YES;
	}
	
	// We were unable to obtain a device for playing sound so tell the user and return NO.
    //if(DEBUG) NSLog(@"ERROR - SoundManager: Unable to allocate a device for sound.");
	return NO;
}

-(void)shutdownSoundManager
{
	@synchronized(self)
	{
		if(soundManagerInstance)
			[self dealloc];
	}
}

-(void)loadAllSounds
{
	// UI Sounds
	[self loadSoundWithKey:@"PlaceTower" fileName:@"PlaceTower" fileExt:@"caf"];
	[self loadSoundWithKey:@"Cancel" fileName:@"Cancel" fileExt:@"caf"];
	[self loadSoundWithKey:@"SellTower" fileName:@"SellTower" fileExt:@"caf"];
	[self loadSoundWithKey:@"UpgradeTower" fileName:@"UpgradeTower" fileExt:@"caf"];
	[self loadSoundWithKey:@"EnemyEscape" fileName:@"EnemyEscape" fileExt:@"caf"];
	[self loadSoundWithKey:@"RoundOver" fileName:@"RoundOver" fileExt:@"caf"];
	[self loadSoundWithKey:@"GameWin" fileName:@"GameWin" fileExt:@"caf"];
	[self loadSoundWithKey:@"GameLoss" fileName:@"GameLoss" fileExt:@"caf"];
	
	// enemy deaths
	[self loadSoundWithKey:@"ChubbyDeath" fileName:@"ChubbyDeath" fileExt:@"caf"];
	[self loadSoundWithKey:@"JeanieDeath" fileName:@"JeanieDeath" fileExt:@"caf"];
	[self loadSoundWithKey:@"LankyDeath" fileName:@"LankyDeath" fileExt:@"caf"];
	[self loadSoundWithKey:@"SmartyDeath" fileName:@"SmartyDeath" fileExt:@"caf"];
	[self loadSoundWithKey:@"AirplaneDeath" fileName:@"AirplaneDeath" fileExt:@"caf"];
	[self loadSoundWithKey:@"BandieDeath" fileName:@"BandieDeath" fileExt:@"caf"];
	[self loadSoundWithKey:@"CheerleaderDeath" fileName:@"CheerleaderDeath" fileExt:@"caf"];
	[self loadSoundWithKey:@"BannerDeath" fileName:@"BannerDeath" fileExt:@"caf"];
	[self loadSoundWithKey:@"MascotDeath" fileName:@"MascotDeath" fileExt:@"caf"];
	[self loadSoundWithKey:@"PromQueenDeath" fileName:@"PromQueenDeath" fileExt:@"caf"];
	[self loadSoundWithKey:@"PunkDeath" fileName:@"PunkDeath" fileExt:@"caf"];
	
	// tower shots
	[self loadSoundWithKey:@"VendingShoot" fileName:@"VendingShoot" fileExt:@"caf"];
	[self loadSoundWithKey:@"FreezerShoot" fileName:@"FreezerShoot" fileExt:@"caf"];
	[self loadSoundWithKey:@"CookieShoot" fileName:@"CookieShoot" fileExt:@"caf"];
	[self loadSoundWithKey:@"MatronShoot" fileName:@"MatronShoot" fileExt:@"caf"];
	[self loadSoundWithKey:@"PieShoot" fileName:@"PieShoot" fileExt:@"caf"];
	[self loadSoundWithKey:@"PopcornShoot" fileName:@"PopcornShoot" fileExt:@"caf"];
	
	// projectile hits
	[self loadSoundWithKey:@"PopCanHit" fileName:@"PopCanHit" fileExt:@"caf"];
	[self loadSoundWithKey:@"PopCanExplode" fileName:@"PopCanExplode" fileExt:@"caf"];
	[self loadSoundWithKey:@"CookieHit" fileName:@"CookieHit" fileExt:@"caf"];
	[self loadSoundWithKey:@"SlopHit" fileName:@"SlopHit" fileExt:@"caf"];
	[self loadSoundWithKey:@"PieHit" fileName:@"PieHit" fileExt:@"caf"];
	[self loadSoundWithKey:@"PopcornHit" fileName:@"PopcornHit" fileExt:@"caf"];
	[self loadSoundWithKey:@"PopcornExplode" fileName:@"PopcornExplode" fileExt:@"caf"];
}
- (void)loadSoundWithKey:(NSString*)k fileName:(NSString*)file fileExt:(NSString*)ext
{	
    unsigned int bufferID;
	
	// Generate a buffer within OpenAL for this sound
	alGenBuffers(1, &bufferID);
    
    // Set up the variables which are going to be used to hold the format
    // size and frequency of the sound file we are loading
	ALenum  error = AL_NO_ERROR;
	ALenum  format;
	ALsizei size;
	ALsizei freq;
	ALvoid *data;
    
	NSBundle *bundle = [NSBundle mainBundle];
	
	// Get the audio data from the file which has been passed in
	CFURLRef fileURL = (CFURLRef)[[NSURL fileURLWithPath:[bundle pathForResource:file ofType:ext]] retain];
	
	if (fileURL)
	{	
		data = MyGetOpenALAudioData(fileURL, &size, &format, &freq);
		CFRelease(fileURL);
		
		if((error = alGetError()) != AL_NO_ERROR) 
		{
			NSLog(@"ERROR - SoundManager: Error loading sound: %x\n", error);
			exit(1);
		}
		
		// Use the static buffer data API
		alBufferDataStaticProc(bufferID, format, data, size, freq);
		
		if((error = alGetError()) != AL_NO_ERROR) 
		{
			NSLog(@"ERROR - SoundManager: Error attaching audio to buffer: %x\n", error);
		}		
	}
	else
	{
		NSLog(@"ERROR - SoundManager: Could not find file '%@.%@'", file, ext);
		data = NULL;
	}
	
	// Place the buffer ID into the sound library against |aSoundKey|
	[soundLibrary setObject:[NSNumber numberWithUnsignedInt:bufferID] forKey:k];
}
-(NSUInteger)playSoundWithKey:(NSString*)k gain:(ALfloat)g pitch:(ALfloat)p shouldLoop:(BOOL)loop
{
	ALenum err = alGetError(); // clear error code
	
	// Find the buffer linked to the key which has been passed in
	NSNumber *numVal = [soundLibrary objectForKey:k];
	if(numVal == nil)
		return 0;
	unsigned int bufferID = [numVal unsignedIntValue];
	
	// find an available channel
	unsigned int sourceID = (unsigned int)[self nextAvailableSource];
	
	// make sure the source is clean by resetting the buffer assigned to it to 0
	alSourcei(sourceID, AL_BUFFER, 0);
	// attach the buffer we've looked up to the source we found
	alSourcei(sourceID, AL_BUFFER, bufferID);
	
	// set the pitch and gain
	alSourcef(sourceID, AL_PITCH, p);
	alSourcef(sourceID, AL_GAIN, g);
	
	// set looping value
	if(loop)
		alSourcei(sourceID, AL_LOOPING, AL_TRUE);
	else
		alSourcei(sourceID, AL_LOOPING, AL_FALSE);
	
	// check for errors
	err = alGetError();
	if(err != 0)
	{
		NSLog(@"ERROR SoundManager: %d", err);
		return 0;
	}
	
	// play the sound!
	alSourcePlay(sourceID);
	
	return sourceID;
}
-(void)loadMusicWithKey:(NSString*)k fileName:(NSString*)file fileExt:(NSString*)ext
{
	// this can be used to load a playlist?
	
	// full path of the music file
	NSString *filePath = [[NSBundle mainBundle] pathForResource:file ofType:ext];
	// add the audio path to the library with the given key
	[musicLibrary setObject:filePath forKey:k];
}
-(void)playMusicWithKey:(NSString*)k timesToRepeat:(NSUInteger)x
{
	NSError *err;
	
	NSString *path = [musicLibrary objectForKey:k];
	
	if(!path)
	{
		NSLog(@"Error SoundEngine: The music key %@ could not be found", k);
		return;
	}
	
	// initialize AVAudioPlayer
	musicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:&err];
	
	if(!musicPlayer)
	{
        NSLog(@"Error SoundManager: Could not play music for key %@", err);
		return;
	}
	
	// Set the number of times the music should loop. -1 means forever
	[musicPlayer setNumberOfLoops:x];
	
	// Set volume
	[musicPlayer setVolume:musicVolume];
	
	[musicPlayer play];
}
-(void)stopPlayingMusic
{
	[musicPlayer stop];
}
-(void)setMusicVolume:(ALfloat)v
{
	musicVolume = v;
	
	// check to make sure audio player exists, set it's volume if it does
	if(musicPlayer)
		[musicPlayer setVolume:musicVolume];
	
}
-(AudioFileID)openAudioFile:(NSString*)filePath
{
	AudioFileID outAFID;
	// create an NSURL which will be used to load the file.
	// easier than using a CFURLRef
	NSURL *afUrl = [NSURL fileURLWithPath:filePath];
	
	// open the provided audio file
	OSStatus result = AudioFileOpenURL((CFURLRef)afUrl, kAudioFileReadPermission, 0, &outAFID);
	
	if(result != 0)
	{
		NSLog(@"ERROR SoundEngine: Cannot open file: %@", filePath);
		return nil;
	}
	return outAFID;
}
-(UInt32)audioFileSize:(AudioFileID)fileDescriptor
{
	UInt64 outDataSize = 0;
	UInt32 propertySize = sizeof(UInt64);
	OSStatus result = AudioFileGetProperty(fileDescriptor, kAudioFilePropertyAudioDataByteCount, &propertySize, &outDataSize);
	if(result != 0)
		NSLog(@"Error: cannot allocate file size");
	return (UInt32)outDataSize;
}
-(NSUInteger)nextAvailableSource
{
	// might want to change things here.....
	
	
	// hold the current state of the sound channel
	int sourceState;
	
	// find a channel not being used
	for(NSNumber *sourceNumber in soundSources)
	{
		alGetSourcei([sourceNumber unsignedIntValue], AL_SOURCE_STATE, &sourceState);
		// if this source is not laying then return it
		if(sourceState != AL_PLAYING)
			return [sourceNumber unsignedIntValue];
	}
	
	// If all the sources are being used, we look for the first non looping source and the source associated with that
	int looping;
	for(NSNumber *sourceNumber in soundSources)
	{
		alGetSourcei([sourceNumber unsignedIntValue], AL_LOOPING, &looping);
		if(!looping)
		{
			// we found a looping source currently not looping
			int sourceID = [sourceNumber unsignedIntValue];
			alSourceStop(sourceID);
			return sourceID;
		}
	}
	
	// if no looping sources are available, then just use the first one
	int sourceID = (int)[[soundSources objectAtIndex:0] unsignedIntegerValue];
	alSourceStop(sourceID);
	return sourceID;
}
- (void)setActivated:(BOOL)aState 
{
    if(aState) 
	{
        NSLog(@"INFO - SoundManager: OpenAL Active");
        
        // Set the AudioSession AudioCategory to AmbientSound
        /*UInt32 category = kAudioSessionCategory_AmbientSound;
        result = AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(category), &category);
        if(result) 
		{
            NSLog(@"ERROR - SoundManager: Unable to set the audio session category");
            return;
        }*/
        
        AVAudioSession *session = [AVAudioSession sharedInstance];
        NSError* setCategoryError = nil;
        if(![session setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:&setCategoryError])
        {
            NSLog(@"%@", setCategoryError);
            return;
        }
        
        // Set the audio session state to true and report any errors
        /*result = AudioSessionSetActive(true);
		if (result) 
		{
            NSLog(@"ERROR - SoundManager: Unable to set the audio session state to YES with error %d.", result);
            return;
        }*/
        
        NSError* setActiveError = nil;
        if(![session setActive:YES error:&setActiveError])
        {
            NSLog(@"%@", setActiveError);
            return;
        }
        
        // As we are finishing the interruption we need to bind back to our context.
        alcMakeContextCurrent(context);
    } 
	else 
	{
        NSLog(@"INFO - SoundManager: OpenAL Inactive");
        
        // As we are being interrupted we set the current context to NULL.  If this sound manager is to be
        // compaitble with firmware prior to 3.0 then the context would need to also be destroyed and
        // then re-created when the interruption ended.
        alcMakeContextCurrent(NULL);
    }
}

-(id) retain
{
	return self;
}
-(NSUInteger)retainCount
{
	return UINT_MAX; // denotes an object that can't be released
}
-(id)autorelease
{
	return self;
}
-(void)dealloc
{
	// all OpenAL sources
	for(NSNumber *numVal in soundSources)
	{
		const unsigned int sourceID = [numVal unsignedIntValue];
		alDeleteSources(1, &sourceID);
	}
	
	for(NSNumber *numVal in soundLibrary)
	{
		const unsigned int bufferID = [numVal unsignedIntValue];
		alDeleteBuffers(1, &bufferID);
	}
	
	// release arrays and dictionaries
	[soundLibrary release];
	[soundSources release];
	[musicLibrary release];
	
	// disable and destroy the context
	alcMakeContextCurrent(NULL);
	alcDestroyContext(context);
	
	// close the device
	alcCloseDevice(device);
	
	[super dealloc];
}
@end

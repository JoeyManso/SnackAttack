//
//  SoundManager.h
//  towerDefense
//
//  Created by Joey Manso on 8/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenAL/al.h>
#import <OpenAL/alc.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVAudioPlayer.h>

// maximum amount of channels
#define kMaxSources 32

@interface SoundManager : NSObject 
{
	// OpenAL context for playing sounds
	ALCcontext *context;
	
	// device we will use to play sounds
	ALCdevice *device;
	
	// Array to store the OpenAL buffers to store our sounds
	NSMutableArray *soundSources;
	NSMutableDictionary *soundLibrary;
	NSMutableDictionary *musicLibrary;
	
	// AVAudioPlayer for background music
	AVAudioPlayer *musicPlayer;
	
	ALfloat musicVolume;
}
+(SoundManager*)getInstance;

-(NSUInteger)playSoundWithKey:(NSString*)k gain:(ALfloat)g pitch:(ALfloat)p shouldLoop:(BOOL)loop;
-(void)loadAllSounds;
-(void)playMusicWithKey:(NSString*)k timesToRepeat:(NSUInteger)x;
//-(void)setMusicVolume:(ALfloat)v;
-(void)shutdownSoundManager;
@end

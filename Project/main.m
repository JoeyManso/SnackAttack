//
//  main.m
//  towerDefense
//
//  Created by Joey Manso on 7/5/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tower.h"

int main(int argc, char *argv[]) 
{    
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	// call the app delegate to run everything!
    int retVal = UIApplicationMain(argc, argv, nil, @"towerDefenseAppDelegate");
    [pool release];
    return retVal;
}

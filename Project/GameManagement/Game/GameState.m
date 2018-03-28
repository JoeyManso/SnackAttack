//
//  GameState.m
//  towerDefense
//
//  Created by Joey Manso on 7/20/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "GameKit/GameKit.h"
#import "GameState.h"
#import "SoundManager.h"
#import "ViewManager.h"
#import "UIManager.h"
#import "UIBars.h"

#import "Tower.h"
#import "Enemy.h"
#import "EnemyQueue.h"
#import "Map.h"

static const uint SCORE_MULT_ROUND = 3500;
static const uint SCORE_MULT_CASH = 50;
static const uint SCORE_MULT_LIVES = 5000;
static const uint SCORE_MULT_KILLS = 150;
static UIManager *UIMan;
static SoundManager *soundMan;
static GameStatus *statusBar;
static EnemyQueue *enemyQueue;

// private stuff
@interface GameState()
{

}
-(void)updateStatusBar;
-(void)setBeginningStats;
-(void)findEnemies;
-(void)checkCollisions;
-(void)updateAllObjects:(float)deltaTime;
-(BOOL)allEnemiesAreRemoved;
@end

@implementation GameState

@synthesize currentlyBoundTexture;
@synthesize currentScore;
@synthesize currentLives;
@synthesize currentCash;
@synthesize currentRound;
@synthesize gameSpeed;
@synthesize time;
@synthesize paused;
@synthesize gameCenterEnabled;

const int MAX_SORT_COUNT = 15; // sort every time this count is reached
const float NEXT_ROUND_BUFFER = 1.5f; // time before next round starts after all enemies are removed from map

-(id)init
{
	if(self = [super init])
	{
		debug = enemiesOnMap = paused = NO;
		bonusToApply = 0;
		gameObjects = [[NSMutableArray alloc] init];
		addQueue = [[NSMutableArray alloc] init];
		removeQueue = [[NSMutableArray alloc] init];
		registerPoints = [[NSMutableArray alloc] init];
		enemyQueue = [[EnemyQueue alloc] init];
        defeatedEnemiesMap = [[NSMutableDictionary alloc] init];
		sortCounter = 0;
		roundBuffer = 0.0f;
        gameSpeed = 1.0f;
		
		[self setBeginningStats];
        
        // Get path to documents directory
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        if([paths count] > 0)
        {
            savePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"GameSave.snack"];
            [savePath retain];
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillTerminate:) name:UIApplicationWillTerminateNotification object:nil];
        [self authenticateLocalPlayer];
	}
	return self;
}
+(GameState*)sharedGameStateInstance
{
	// return a singleton
	static GameState *sharedGameStateInstance;
	
	// lock the class (for multithreading!)
	@synchronized(self)
	{
		if(!sharedGameStateInstance)
		{
			sharedGameStateInstance = [[GameState alloc] init];
			// put this here to avoid static initialization errors
			soundMan = [SoundManager getInstance];
			[soundMan loadAllSounds];
			UIMan = [UIManager getInstance];
			statusBar = [UIMan getGameStatBarReference];
			// initialize status bar values
			[statusBar setRound:sharedGameStateInstance.currentRound+1];
			[statusBar setLives:sharedGameStateInstance.currentLives];
			[statusBar setCash:sharedGameStateInstance.currentCash];
			[statusBar setScore:sharedGameStateInstance.currentScore];
            [statusBar setGameSpeed:sharedGameStateInstance.gameSpeed];
		}
	}
	
	return sharedGameStateInstance;
}
-(void)appWillResignActive:(NSNotification*)note
{
    if([self hasGameStarted])
    {
        [self saveGame];
        [UIMan onResignActive];
        [self pause];
    }

}
-(void)appWillTerminate:(NSNotification*)note
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillTerminateNotification object:nil];
}
-(BOOL)debugMode
{
	return debug;
}
-(void)addObject:(GameObject*)o
{
	[addQueue addObject:o];
}
-(void)removeObject:(GameObject*)o
{
	// add this object to the queue for removal
	[removeQueue addObject:o];
}
-(GameObject*)findObjectAtPosition:(CGPoint)p
{	
	// while our selected object does not become nil
	GameObject *touchedObject = nil;
	for(GameObject *o in gameObjects)
	{
		// exit the loop as soon as we find an object
		if([o isTouchedAtPoint:p])
		{
			touchedObject = o;
		}
	}
	return touchedObject;
}
-(BOOL)hasGameStarted
{
    return currentRound > 0;
}
-(BOOL)pointIsWithinTower:(Point2D*)p
{
	for(Tower *t in gameObjects)
	{
		if([t isKindOfClass:[Tower class]])
		{
			if(![t canBeMoved] && CGRectContainsPoint([t getObjectHitBox], CGPointMake(p.x, p.y)))
				return YES;
		}
	}
	return NO;
}

-(void)update:(float)deltaTime
{
	if(!paused)
	{		
		[self updateAllObjects:deltaTime];
		if(enemiesOnMap)
		{
			[self findEnemies];
			[self checkCollisions];
		}
		
		// if it's not empty, add what's in the add queue and remove it from the queue
		if([addQueue count] > 0)
		{
			for(Enemy *e in addQueue)
			{
				if([e isKindOfClass:[Enemy class]])
				{
					[enemyQueue addEnemy:e];
					if(currentRound > 20 && currentRound <= 25)
						[e multiplyMaxHitPoints:2];
					else if(currentRound > 25)
						[e multiplyMaxHitPoints:3];
				}
			}
			[gameObjects addObjectsFromArray:addQueue];
			[addQueue removeAllObjects];
		}
		// if we need to delete an object, dealloc it and remove all references
		if([removeQueue count] > 0)
		{
			// as long as there are no more references to the object, this will deallocate it
			for(GameObject *o in removeQueue)
			{
				[[TouchManager getInstance] objectHasBeenRemoved:o];
				[gameObjects removeObject:o];
				if([o isKindOfClass:[Enemy class]])
				{
					[enemyQueue removeEnemy:(Enemy*)o];
					if([self allEnemiesAreRemoved])
					{
						enemiesOnMap = NO;
						roundBuffer = NEXT_ROUND_BUFFER;
					}
				}
				
			}
			
			[removeQueue removeAllObjects];
		}
		if(roundBuffer > 0)
			roundBuffer -= deltaTime;
		else if(roundBuffer < 0.0f)
		{
			roundBuffer = 0.0f;
			[self goToNextRound];
		}
		
		if(sortCounter > MAX_SORT_COUNT)
		{
			[enemyQueue sort];
			sortCounter = 0;
		}
		++sortCounter;
	}
}
-(void)findEnemies
{
	for(Tower *tower in gameObjects)
	{
		// check if towers should shoot at enemies
		if([tower isKindOfClass:[Tower class]])
		{
			// check if the tower has the option to shoot
			if([tower canShoot])
			{
				// look for enemies in range
				Enemy *enemy = [enemyQueue getClosestEnemyFromPoint:[tower objectPosition] radius:[tower towerRange] towerType:[tower towerType] 
													 projectileType:[tower projectileType]];
				if(enemy)
				{	
					if([tower targetGameObject:enemy])
					{
						[tower shoot];
						// done shooting, break out of this loop
						break;
					}		
				}
			}
		}
	}
}

-(void)checkCollisions
{
	// this checks all projectiles against all enemies
	for(Projectile *projectile in gameObjects)
	{
		if([projectile isKindOfClass:[Projectile class]])
		{
			for(Enemy *enemy in gameObjects)
			{
				if([enemy isKindOfClass:[Enemy class]] && [projectile towerType] >= [enemy enemyType] && [enemy enemyImmunity] != [projectile projectileType])
				{
					if([enemy enemyHitPoints] >= 1 && 
					   CGRectContainsPoint([enemy getObjectHitBox], CGPointMake([projectile objectPosition].x, [projectile objectPosition].y)))
					{
						// give the projectile a reference to the enemy to appy damage and any potential effects
						[projectile hasCollided:enemy];
						// we hit an enemy, break out for this projectile
						break;
					}
				}
			}
		}
		
	}
}
-(void)upgradeSelectedTower
{
	for(Tower *tower in gameObjects)
	{
		// check if towers should shoot at enemies
		if([tower isKindOfClass:[Tower class]] && [tower selected])
		{
			[tower upgrade];
		}
	}
}
-(void)sellSelectedTower
{
	for(Tower *tower in gameObjects)
	{
		// check if towers should shoot at enemies
		if([tower isKindOfClass:[Tower class]] && [tower selected])
		{
			[tower sell];
		}
	}
}

-(void)damageEnemiesInRadius:(float)radius origin:(Point2D*)originPoint damage:(float)damage damageType:(uint)type
{
	for(Enemy *enemy in gameObjects)
	{
		if([enemy isKindOfClass:[Enemy class]] && [enemy enemyType] != AIR && [enemy enemyImmunity] != type)
		{
			if([Math distance:originPoint :enemy.objectPosition] <= radius)
				[enemy takeDamage:damage];
		}
	}
}
-(void)freezeEnemiesInRadius:(float)radius origin:(Point2D*)originPoint duration:(float)duration
{
	for(Enemy *enemy in gameObjects)
	{
		if([enemy isKindOfClass:[Enemy class]] && [enemy enemyType] != AIR && [enemy enemyImmunity] != FREEZE)
		{
			if([Math distance:originPoint :enemy.objectPosition] <= radius)
				[enemy freeze:duration];
		}
	}
}
-(void)showBoostForTowersFromPoint:(Point2D*)originPoint
{
	for(Tower *t in gameObjects)
	{
		if([t isKindOfClass:[Tower class]])
		{
			if([Math distance:originPoint :t.objectPosition] <= RG_RANGE)
				[t setIsInBoostRadius:YES];
			else
				[t setIsInBoostRadius:NO];
		}
	}
}
-(void)applyBoostForTowersFromPoint:(Point2D*)originPoint
{
	for(Tower *t in gameObjects)
	{
		if([t isKindOfClass:[Tower class]])
		{
			if([Math distance:originPoint :t.objectPosition] <= RG_RANGE)
			{
				[t setIsInBoostRadius:YES];
				[t applyBoostDamage];
			}
			else
				[t setIsInBoostRadius:NO];
		}
	}
	[registerPoints addObject:originPoint];
}
-(void)removeBoostForTowersFromPoint:(Point2D*)originPoint
{
	[registerPoints removeObject:originPoint];
	for(Tower *t in gameObjects)
	{
		if([t isKindOfClass:[Tower class]])
		{
			if([Math distance:originPoint :t.objectPosition] <= RG_RANGE)
				[t removeBoost];
		}
	}
}
-(void)messageScreenHasFinished
{
	paused = NO;
	[self alterCash:bonusToApply];
	[statusBar setRound:++currentRound];
	[UIMan roundHasFinished:currentRound currentCash:currentCash];
}
-(BOOL)isBoostTowerInRange:(Point2D*)startPoint
{
	for(Point2D *p in registerPoints)
		if([Math distance:startPoint :p] < RG_RANGE)
			return YES;
	return NO;
}
-(BOOL)allEnemiesAreRemoved
{
	for(Enemy *e in gameObjects)
		if([e isKindOfClass:[Enemy class]])
			return NO;
	return YES;
}
-(void)draw
{
	for(GameObject *o in gameObjects)
		[o draw];
}
-(void)updateAllObjects:(float)deltaTime
{
	for(GameObject *o in gameObjects)
		[o update:deltaTime];
	time += deltaTime;
}
-(void)setMap:(Map*)m
{
	currentMap = m;
}
-(void)goToNextRound
{
	enemiesOnMap = YES;
	uint numberOfEnemiesThisRound;
	// special case for the first round (start button)
	if(currentRound == 0)
	{
		currentRoundInfo = [currentMap getFirstRound];
		[statusBar setRound:++currentRound];
	}
	else
	{			
		[soundMan playSoundWithKey:@"RoundOver" gain:1.0f pitch:1.0f shouldLoop:NO];
		numberOfEnemiesThisRound = [currentRoundInfo numTotalEnemies];
		[UIMan showMessageScreenWithRound:currentRound numEnemiesDefeated:[self enemiesDefeatedThisRound]numEnemiesTotal:numberOfEnemiesThisRound
						   maxBonusAmount:[currentRoundInfo roundBonus] message1:[currentRoundInfo messageLine1] message2:[currentRoundInfo messageLine2] 
								 message3:[currentRoundInfo messageLine3]];
		float bonusPercent;
		if([currentRoundInfo numTotalEnemies] == 0)
			bonusPercent = 0.0f;
		else
			bonusPercent = (float)[self enemiesDefeatedThisRound]/(float)[currentRoundInfo numTotalEnemies];
		bonusToApply = (uint)(bonusPercent * (float)[currentRoundInfo roundBonus]);
        currentRoundInfo = [currentMap getNextRound:YES];
		paused = YES;
	}
	if(!currentRoundInfo)
	{
        [self onGameEnd];
	}
	[defeatedEnemiesMap removeAllObjects];
}
-(void)showMenu
{
	[[ViewManager getInstance] showMainMenu];
}
-(void)showMenuEndGame
{
    [[ViewManager getInstance] setResumeEnabled:false];
	[[ViewManager getInstance] showMainMenu];
}
-(void)subtractLife
{
	if(currentLives > 0)
	{
		[soundMan playSoundWithKey:@"EnemyEscape" gain:0.2f pitch:0.75f shouldLoop:NO];
		[statusBar setLives:--currentLives];
	}
	// check if we've lost all lives, if so, we lose!
	if(currentLives == 0)
	{
        [self onGameEnd];
	}
}
-(void)pause
{
	paused = YES;
    [UIMan onPauseChange:paused];
}
-(void)unpause
{
    paused = NO;
    [UIMan onPauseChange:paused];
}
-(void)speedDown
{
    gameSpeed = MAX(gameSpeed / 2.0f, GAME_SPEED_MIN);
    [[UIMan getGameStatBarReference] setGameSpeed:gameSpeed];
}
-(void)speedUp
{
    gameSpeed = MIN(gameSpeed * 2.0f, GAME_SPEED_MAX);
    [[UIMan getGameStatBarReference] setGameSpeed:gameSpeed];
}
-(void)alterCash:(int)deltaCash
{
	[statusBar setCash:currentCash+=deltaCash];
	[UIMan cashHasChanged:currentCash];
}
-(void)enemyDefeated:(NSString*)enemyName value:(uint)enemyValue
{
    NSNumber *value = [defeatedEnemiesMap objectForKey:enemyName];
    if(value)
    {
        NSNumber *valueInc = [NSNumber numberWithInt:[value intValue] + 1];
        [defeatedEnemiesMap setObject:valueInc forKey:enemyName];
    }
    else
    {
        [defeatedEnemiesMap setObject:[NSNumber numberWithInt:1] forKey:enemyName];
    }
	++currentScore;
	[statusBar setScore:currentScore];
	[self alterCash:enemyValue];
}
-(uint)enemiesDefeatedThisRound
{
    uint enemiesDefeated = 0;
    for (NSString *key in defeatedEnemiesMap)
    {
        NSString* value = [defeatedEnemiesMap valueForKey:key];
        enemiesDefeated += [value intValue];
    }
    return enemiesDefeated;
}
-(void)setBeginningStats
{
    int mapIdx = [[ViewManager getInstance] getMapIdx];
	time = 0.0f;
	roundBuffer = 0.0f;
    gameSpeed = 1.0f;
	currentCash = STARTING_CASH[mapIdx];
	currentScore = 0;
	currentRound = 0;
	currentLives = STARTING_LIVES[mapIdx];
	enemiesOnMap = NO;
	paused = NO;
    [defeatedEnemiesMap removeAllObjects];
}

-(void)resetGame
{
	[self setBeginningStats];
	[currentMap resetRounds];
	currentRoundInfo = nil;
    [self updateStatusBar];
	[UIMan resetGame];
	[gameObjects removeAllObjects];
	[enemyQueue removeAllEnemies];
}
-(void)updateStatusBar
{
    [statusBar setRound:(currentRound == 0 ? 1 : currentRound)];
    [statusBar setLives:currentLives];
    [statusBar setCash:currentCash];
    [statusBar setScore:currentScore];
    [statusBar setGameSpeed:gameSpeed];
}
-(void)saveGame
{
    if(savePath != nil && currentRound > 0 && currentLives > 0)
    {
        NSMutableArray *towers = [[NSMutableArray alloc] init];
        NSMutableArray *enemies = [[NSMutableArray alloc] init];
        
        for(GameObject *object in gameObjects)
        {
            if([object isKindOfClass:[Tower class]])
            {
                Tower *tower = (Tower*)object;
                NSDictionary *towerSave = @
                {   @"TYPE"     : [tower objectName],
                    @"LEVEL"    : [NSNumber numberWithInt:ceil([tower towerLevel])],
                    @"X"        : [NSNumber numberWithInt:[tower objectPosition].x],
                    @"Y"        : [NSNumber numberWithInt:[tower objectPosition].y],
                    @"ROT"      : [NSNumber numberWithInt:[tower objectRotationAngle]],
                    @"COOL"     : [NSNumber numberWithFloat:[tower shotCooldownRemain]]};
                [towers addObject:towerSave];
            }
            else if([object isKindOfClass:[Enemy class]])
            {
                Enemy *enemy = (Enemy*)object;
                if([enemy enemyHitPoints] > 0)
                {
                    NSDictionary *enemySave = @
                    {   @"TYPE"     : [enemy objectName],
                        @"HP"       : [NSNumber numberWithInt:ceil([enemy enemyHitPoints])],
                        @"TARGET"   : [NSNumber numberWithInt:[enemy getTargetNodeValue]],
                        @"X"        : [NSNumber numberWithInt:[enemy objectPosition].x],
                        @"Y"        : [NSNumber numberWithInt:[enemy objectPosition].y]};
                    [enemies addObject:enemySave];
                }
            }
        }
        
        NSLog(@"Saving to %@", savePath);
        int mapIdx = [[ViewManager getInstance] getMapIdx];
        NSDictionary *saveDictionary = @{@"MAP"     : [NSNumber numberWithInt:mapIdx],
                                         @"ROUND"   : [NSNumber numberWithInt:currentRound],
                                         @"COOL"    : [NSNumber numberWithFloat:[currentMap spawnCooldown]],
                                         @"CASH"    : [NSNumber numberWithInt:currentCash],
                                         @"LIVES"   : [NSNumber numberWithInt:currentLives],
                                         @"SCORE"   : [NSNumber numberWithInt:currentScore],
                                         @"DEFEATED": defeatedEnemiesMap,
                                         @"TOWERS"  : towers,
                                         @"ENEMIES" : enemies};
        for (NSString *key in saveDictionary)
        {
            NSLog(@"%@ : %@", key, [saveDictionary valueForKey:key]);
        }
        [saveDictionary writeToFile:savePath atomically:YES];
        [towers release];
        [enemies release];
        NSLog(@"Save complete");
    }
}

-(void)loadGame
{
    if(savePath != nil)
    {
        NSDictionary *loadDictionary = [NSDictionary dictionaryWithContentsOfFile:savePath];
        if(loadDictionary != nil)
        {
            NSLog(@"Loading from %@", savePath);
            NSArray *towers;
            NSArray *enemies;
            float spawnCooldown = 0.0f;
            for (NSString *key in loadDictionary)
            {
                NSString* value = [loadDictionary valueForKey:key];
                NSLog(@"%@ : %@", key, value);
                
                if([key isEqualToString:@"MAP"])
                {
                    int mapIdx = [value intValue];
                    [[ViewManager getInstance] setGameMapIdx:mapIdx];
                }
                else if([key isEqualToString:@"ROUND"])
                {
                    currentRound = [value intValue];
                }
                else if([key isEqualToString:@"COOL"])
                {
                    spawnCooldown = [value floatValue];
                }
                else if([key isEqualToString:@"CASH"])
                {
                    currentCash = [value intValue];
                }
                else if([key isEqualToString:@"LIVES"])
                {
                    currentLives = [value intValue];
                }
                else if([key isEqualToString:@"SCORE"])
                {
                    currentScore = [value intValue];
                }
                else if([key isEqualToString:@"DEFEATED"])
                {
                    NSDictionary* defeatedEnemiesMapLoaded = (NSMutableDictionary*)value;
                    for (NSString *defeatedKey in defeatedEnemiesMapLoaded)
                    {
                        // Create copy of loaded key/value
                        NSNumber* defeatedValue = [defeatedEnemiesMapLoaded objectForKey:defeatedKey];
                        if(defeatedValue)
                        {
                            [defeatedEnemiesMap setObject:[NSNumber numberWithInt:[defeatedValue intValue]]
                                                   forKey:defeatedKey];
                        }
                    }
                }
                else if([key isEqualToString:@"TOWERS"])
                {
                    towers = (NSArray*)value;
                }
                else if([key isEqualToString:@"ENEMIES"])
                {
                    enemies = (NSArray*)value;
                    enemiesOnMap = (enemies.count > 0);
                }
            }
            
            [currentMap loadSave:currentRound spawnCooldown:spawnCooldown
                     savedTowers:towers
                    savedEnemies:enemies
                 defeatedEnemies:defeatedEnemiesMap];
            currentRoundInfo = [currentMap getCurrentRound];
            [UIMan onLoadGame];
            [self updateStatusBar];
            [self update:0.0f];
            for(GameObject *object in gameObjects)
            {
                // Apply register boosts
                if([object isKindOfClass:[Register class]])
                {
                    [self applyBoostForTowersFromPoint:[object objectPosition]];
                }
            }
            [self pause];
            NSLog(@"Load complete");
        }
    }
}

-(BOOL)hasSaveGame
{
    NSDictionary *loadDictionary = [NSDictionary dictionaryWithContentsOfFile:savePath];
    if(loadDictionary != nil)
    {
        NSString* value = [loadDictionary valueForKey:@"ROUND"];
        return [value intValue] > 0;
    }
    return NO;
}
-(void)onGameEnd
{
    const bool bDidWin = (currentLives > 0);
    NSString* gameEndMessage;
    uint completedRound = 0;
    if(bDidWin)
    {
        [soundMan playSoundWithKey:@"GameWin" gain:1.0f pitch:1.0f shouldLoop:NO];
        gameEndMessage = [NSString stringWithFormat:@"Completed Round %u",currentRound];
        completedRound = currentRound;
    }
    else
    {
        [soundMan playSoundWithKey:@"GameLoss" gain:1.0f pitch:1.0f shouldLoop:NO];
        gameEndMessage = [NSString stringWithFormat:@"Failed on Round %u",currentRound];
        completedRound = currentRound - 1;
    }
    
    
    // Calculate score
    const uint scoreRound = completedRound * SCORE_MULT_ROUND;
    const uint scoreCash = currentCash * SCORE_MULT_CASH;
    const uint scoreKills = currentScore * SCORE_MULT_KILLS;
    const uint scoreLives = currentLives * SCORE_MULT_LIVES;
    const uint scoreTotal = scoreRound + scoreCash + scoreKills + scoreLives;
    
    // Display special message screen
    paused = YES;
    [UIMan swapRoundWithReset:[[Image alloc] initWithImage:[UIImage imageNamed:@"ButtonMainMenu.png"] filter:GL_LINEAR]];
    [UIMan showMessageCustomTitle:gameEndMessage
               numEnemiesDefeated:[self enemiesDefeatedThisRound]
                  numEnemiesTotal:[currentRoundInfo numTotalEnemies] maxBonusAmount:0
                         message1:[NSString stringWithFormat:@"%u x %u = %u",
                                   completedRound, SCORE_MULT_ROUND, scoreRound]
                         message2:[NSString stringWithFormat:@"%u x %u = %u",
                                   currentCash, SCORE_MULT_CASH, scoreCash]
                         message3:[NSString stringWithFormat:@"%u x %u = %u",
                                   currentScore, SCORE_MULT_KILLS, scoreKills]
                         message4:[NSString stringWithFormat:@"%u x %u = %u",
                                   currentLives, SCORE_MULT_LIVES, scoreLives]
                         message5:[NSString stringWithFormat:@"Your Score: %u", scoreTotal]];
    
    // Report score to GameCenter
    if(gameCenterEnabled)
    {
        GKScore* newScore = [[GKScore alloc] initWithLeaderboardIdentifier:@"Leaderboard_01"];
        newScore.value = scoreTotal;
        newScore.context = 0;
        
        NSArray* scores = @[newScore];
        [GKScore reportScores:scores withCompletionHandler:^(NSError* error)
         {
         }];
    }
    
    // Delete save file
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    BOOL success = [fileManager removeItemAtPath:savePath error:&error];
    if (!success)
    {
        NSLog(@"Could not save delete file -:%@ ",[error localizedDescription]);
    }
}
-(void)authenticateLocalPlayer
{
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error)
    {
        if(error != nil && error.code == 2)
        {
            // User has cancelled
            return;
        }
        else if(viewController != nil)
        {
            if([self hasGameStarted])
            {
                [UIMan onResignActive];
                [self pause];
            }
            [[ViewManager getInstance] showGCAuthenticate:viewController];
        }
        else if(localPlayer.isAuthenticated)
        {
            gameCenterEnabled = localPlayer.isAuthenticated;
            [[ViewManager getInstance] setLeaderboardEnabled:gameCenterEnabled];
        }
    };
}

-(void)dealloc
{
	// this deletes all objects as long as this is the only remaining reference to them
	[gameObjects removeAllObjects];
	[gameObjects release];
	[enemyQueue dealloc];
	[registerPoints removeAllObjects];
	[registerPoints release];
    [defeatedEnemiesMap removeAllObjects];
    [defeatedEnemiesMap release];
	[addQueue release];
	[removeQueue release];
    [savePath release];
	[super dealloc];
}

@end

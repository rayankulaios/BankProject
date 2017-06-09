//
//  AppDelegate.m
//  MRBank
//
//  Created by manikanta rayankula on 12/07/16.
//  Copyright © 2016 manikanta rayankula. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
     [self getDBPath];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (NSString *)getDBPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    paths = nil;
    NSString *dbPath = [[NSString alloc] initWithString:[documentsDir stringByAppendingPathComponent:CurrentSQLDbName]];
    
    documentsDir = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:dbPath])
        return dbPath;
    else
    {
        [self checkAndCreateDatabase];
        NSLog(@"DbPath %@",dbPath);
        return dbPath;
    }
}

-(NSString *)getDocumentsPath
{
    
    NSArray *paths =
    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    return documentsDir;
}

-(void)checkAndCreateDatabase
{
    NSArray *documentPaths =
    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [documentPaths objectAtIndex:0];
    documentPaths = nil;
    
    NSString *currentDBPath = [documentsDir stringByAppendingPathComponent:CurrentSQLDbName];
    documentsDir = nil;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:currentDBPath]) {
        
    }
    else {
        NSString *CurrentDBPathfromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:CurrentSQLDbName];
        [fileManager copyItemAtPath:CurrentDBPathfromApp
                             toPath:currentDBPath error:nil];
        CurrentDBPathfromApp = nil;
    }
    
    NSDictionary *fileAttributes = [NSDictionary dictionaryWithObject:NSFileProtectionComplete forKey:NSFileProtectionKey];
    if (![[NSFileManager defaultManager] setAttributes:fileAttributes ofItemAtPath:currentDBPath error:nil])
    {
        NSLog(@"protected");
    }
}



@end

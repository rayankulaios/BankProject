//
//  AppDelegate.h
//  MRBank
//
//  Created by manikanta rayankula on 12/07/16.
//  Copyright © 2016 manikanta rayankula. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

#define CurrentSQLDbName    @"MRBank.sqlite"


@property (strong, nonatomic) UIWindow *window;

- (NSString *)getDBPath;

@end


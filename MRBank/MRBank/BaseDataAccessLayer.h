//
//  BaseDataAccessLayer.h
//  Nirmal
//
//  Created by Prashanth v on 18/11/12.
//  Copyright (c) 2012 winit. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <sqlite3.h>

#define GETCOUNT_TABLE(xx) [NSString stringWithFormat:@"SELECT 1 FROM %@ LIMIT 1",xx]

#define SAFE_CONVERSION_TEXT_FROM_DB_TO_OBJECT(_objectVal, _dbVal) { char *chars = (char *)_dbVal; if (chars == NULL) {_objectVal = nil;} else {_objectVal = [[NSString stringWithUTF8String:chars] stringByReplacingOccurrencesOfString:@"__||??||__" withString:@"'"];}}

#define SAFE_INSERT(xx) xx.length?[xx stringByReplacingOccurrencesOfString:@"'" withString:@"__||??||__"]:@"" 

#define DATABASE_NAME @"TimHortons.sqlite"


#define DATABASE_HANDLER  ((BaseDataAccessLayer*)[BaseDataAccessLayer singleton])

@interface BaseDataAccessLayer : NSObject
{
    char      *_dataBaseName;
    sqlite3   *_pdataBaseInstance;
    NSString  *_dataBasePath;
    BOOL _errorExist;
    NSInteger busyRetryTimeout;
}

@property (nonatomic, copy) NSString *dataBasePath;
@property (nonatomic) BOOL errorExist;
@property (readwrite) NSInteger busyRetryTimeout;

+ (BaseDataAccessLayer *)singleton;
- (id)initDB: (char *)sqliteDataBaseName;
- (void)initWithDatabaseName: (char *)sqliteDataBaseName;
- (void)executeQuery:(NSString *)query;
-(NSInteger)getCountTable:(NSString*)strQuery;
// get database instance
-(sqlite3*)getDBInstance;

- (void)createEditableCopyOfDatabaseIfNeeded: (char *)sqliteDataBaseName;
- (NSString*)getDBPath: (char *)sqliteDataBaseName;
+(void)clearDataAccess;
- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL;

// retrieve contents from database
-(NSMutableArray*)getStrings:(NSString*)strQuery;

// string and the sum values
-(NSMutableArray*)getStringAndSum:(NSString*)strQuery isDiet:(BOOL)isDiet;

-(NSString *)getDataBasePath;
@end

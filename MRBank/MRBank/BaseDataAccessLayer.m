//
//  BaseDataAccessLayer.m
//  Nirmal
//
//  Created by Prashanth v on 18/11/12.
//  Copyright (c) 2012 winit. All rights reserved.
//

#import "BaseDataAccessLayer.h"

static BaseDataAccessLayer *singletonEngine = nil;

@implementation BaseDataAccessLayer


@synthesize dataBasePath = _dataBasePath;
@synthesize errorExist = _errorExist;

@synthesize busyRetryTimeout;

#pragma mark -
#pragma mark Singleton definition
+ (BaseDataAccessLayer *)singleton
{
	@synchronized(self) {
		if (singletonEngine == nil) {
            
//			singletonEngine = [[BaseDataAccessLayer alloc] initDB:(char*)[[NSString stringWithFormat:DATABASE_NAME,[UserProfileSettings getUserID]] UTF8String]];
            singletonEngine = [[BaseDataAccessLayer alloc] initDB:(char*)[DATABASE_NAME UTF8String]];

		}
	}
	return singletonEngine;
}

+(void)clearDataAccess
{
    singletonEngine = nil;
}

- (id)initDB: (char *)sqliteDataBaseName {
	self = [super init];
	if (self){
		busyRetryTimeout = 1;
        [self initWithDatabaseName:sqliteDataBaseName];
	}
	
	return self;
}


// get database instance
-(sqlite3*)getDBInstance
{
    return _pdataBaseInstance;
}

- (void)initWithDatabaseName: (char *)sqliteDataBaseName
{
	_errorExist = NO;
	int nreturnCode;
	
	[self createEditableCopyOfDatabaseIfNeeded:sqliteDataBaseName];
	const char *nDatabaseName = [_dataBasePath cStringUsingEncoding:NSUTF8StringEncoding];
	nreturnCode = sqlite3_open(nDatabaseName, &_pdataBaseInstance);
}

#pragma mark ---
#pragma mark Public Methods
//create a copy of the DB with writing access allowed if necessary
- (void)createEditableCopyOfDatabaseIfNeeded: (char *)sqliteDataBaseName {
	NSString *databaseName = [[NSString alloc] initWithCString:sqliteDataBaseName encoding:NSUTF8StringEncoding];
	
//    return;
	// Test de l'existence de la base de données
	BOOL success;
	NSFileManager *fileManager = [NSFileManager defaultManager];
//	NSError *error;
	if(!_dataBasePath) {
		_dataBasePath = [[self getDBPath:sqliteDataBaseName] copy];
	}
	NSString *writableDBPath = _dataBasePath;
	success = [fileManager fileExistsAtPath:writableDBPath];
	if (!success) {
		// La base de données en mode "écriture" n'existe pas, on crée une copie avec ce droit
        
		NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:DATABASE_NAME];
        NSLog(@"%@",defaultDBPath);
//		success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
//		if (!success) {
//			NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
//		}
//        else {
//            NSURL *databaseURL = [NSURL fileURLWithPath:writableDBPath isDirectory:NO];
//            [self addSkipBackupAttributeToItemAtURL:databaseURL];
//        }
	}
	databaseName = nil;
}

- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    if(![[NSFileManager defaultManager] fileExistsAtPath:[URL path]])
        return NO;
    BOOL success=YES;
    NSError *error = nil;
    @try {
//         success = [URL setResourceValue: [NSNumber numberWithBool: YES] forKey: NSURLIsExcludedFromBackupKey error: &error];
        success = true;
        if(!success){
            NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
        }

    }
    @catch (NSException *exception) {
        NSLog(@" %@",exception.description);
    }
    @finally {
        return NO;
    }
    
    return success;
}

//return the real DB path
- (NSString*)getDBPath: (char *)sqliteDataBaseName {
	NSString *databaseName = [[NSString alloc] initWithCString:sqliteDataBaseName encoding:NSUTF8StringEncoding];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *writableDBPath =  [documentsDirectory stringByAppendingPathComponent:databaseName];
	
	databaseName = nil;
	return writableDBPath;
}

//execut one Query
- (void)executeQuery:(NSString *)query
{
        NSLog(@"DB PAth %@",_dataBasePath);
        NSLog(@"Query %@",query);
    @synchronized(self)
    {
        
        int status = sqlite3_exec(_pdataBaseInstance, [query cStringUsingEncoding:NSUTF8StringEncoding], NULL, NULL, NULL);
        if (status == SQLITE_OK)
        {
            _errorExist = NO;
        }
        else
        {
            _errorExist = YES;
         //   MasafiLogs(@"execute Query is %@",query);
            fprintf(stderr, "Error in preparation of query. Error: %s", sqlite3_errmsg(_pdataBaseInstance));
            
        }
    }
}

// to get count
-(NSInteger)getCountTable:(NSString*)strQuery 
{
    @synchronized(self)
    {
        //char *sqlStatement = NULL;
        sqlite3_stmt *statement = NULL;
        int returnValue = 0;
        long lastInserRowId = 0;
        sqlite3 *dataBase;
        sqlite3_open([[self getDataBasePath] UTF8String], &dataBase);
        sqlite3_busy_timeout(dataBase, 2000);
        sqlite3_exec(dataBase, "BEGIN", 0, 0, 0);
        
        //sqlStatement = sqlite3_mprintf([strQuery NSUTF8StringEncoding]);
        
        const char *sqlStatement = [strQuery cStringUsingEncoding:NSUTF8StringEncoding];
        returnValue = sqlite3_prepare_v2(dataBase, sqlStatement, (int)strlen(sqlStatement), &statement, NULL);
        
        //54*45
        
        //	returnValue = sqlite3_prepare_v2(_pdataBaseInstance, sqlStatement, strlen(sqlStatement), &statement, NULL);
        if(returnValue == SQLITE_OK){
            returnValue = sqlite3_step(statement);
            
            if(returnValue == SQLITE_ROW) {
                lastInserRowId = sqlite3_column_int(statement, 0);
            }
        }
        sqlite3_finalize(statement);
        statement = nil;
        sqlite3_exec(dataBase, "COMMIT", 0, 0, 0);
        sqlite3_close(dataBase);
        dataBase = nil;
        
        return lastInserRowId;
    }
}

// retrieve contents from database
-(NSMutableArray*)getStrings:(NSString*)strQuery
{
    @synchronized(self)
    {
        
        sqlite3 *dataBase;
        sqlite3_open([[self getDataBasePath] UTF8String], &dataBase);
        sqlite3_busy_timeout(dataBase, 2000);
        sqlite3_exec(dataBase, "BEGIN", 0, 0, 0);
        
        
        NSMutableArray *allCategoryResult	= nil;
        sqlite3_stmt *statement = NULL;
        int returnValue = 0;
        
        const char *sqlStatement = [strQuery cStringUsingEncoding:NSUTF8StringEncoding];
        returnValue = sqlite3_prepare_v2(dataBase, sqlStatement, (int)strlen(sqlStatement), &statement, NULL);
        
        if(returnValue == SQLITE_OK)
        {
            allCategoryResult = [NSMutableArray array];
            returnValue = sqlite3_step(statement);
            
            while (returnValue == SQLITE_ROW)
            {
                NSString *strValue = @"";
                SAFE_CONVERSION_TEXT_FROM_DB_TO_OBJECT(strValue,sqlite3_column_text(statement, 0));
                [allCategoryResult addObject:strValue];
                strValue = nil;
                returnValue = sqlite3_step(statement);
            }
        }
        
        sqlite3_finalize(statement);
        
        sqlite3_exec(dataBase, "COMMIT", 0, 0, 0);
        sqlite3_close(dataBase);
        dataBase = nil;

        return allCategoryResult;
    }
}

// string and the sum values
-(NSMutableArray*)getStringAndSum:(NSString*)strQuery isDiet:(BOOL)isDiet
{
    @synchronized(self)
    {

    NSMutableArray *allCategoryResult	= nil;
	sqlite3_stmt *statement = NULL;
	int returnValue = 0;
	
        sqlite3 *dataBase;
        sqlite3_open([[self getDataBasePath] UTF8String], &dataBase);
        sqlite3_busy_timeout(dataBase, 2000);
        sqlite3_exec(dataBase, "BEGIN", 0, 0, 0);

        
	const char *sqlStatement = [strQuery cStringUsingEncoding:NSUTF8StringEncoding];
	returnValue = sqlite3_prepare_v2(dataBase, sqlStatement, (int)strlen(sqlStatement), &statement, NULL);
	
	if(returnValue == SQLITE_OK)
    {
		allCategoryResult = [NSMutableArray array];
		returnValue = sqlite3_step(statement);
		
		while (returnValue == SQLITE_ROW)
        {
            
//            ProgressObject *dictValues = [ProgressObject new];
//            
//            NSString *strValue = @"";
//            SAFE_CONVERSION_TEXT_FROM_DB_TO_OBJECT(dictValues.strDate,sqlite3_column_text(statement, 0));
//            NSInteger SumValue = sqlite3_column_int(statement, 1);
//            
//            if(!isDiet)
//                dictValues.workoutValue = SumValue;
//            else
//                dictValues.dietValue = SumValue;
//            
//            [allCategoryResult addObject:dictValues];
//            strValue = nil;
			returnValue = sqlite3_step(statement);
		}
	}
	
	sqlite3_finalize(statement);
        
        sqlite3_exec(dataBase, "COMMIT", 0, 0, 0);
        sqlite3_close(dataBase);
        dataBase = nil;

	return allCategoryResult;
    }
}



- (void) dealloc{
	
	sqlite3_close(_pdataBaseInstance);
	_dataBasePath = nil;
}

-(NSString *)getDataBasePath

{
    NSArray *arrPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [[arrPaths objectAtIndex:0] stringByAppendingPathComponent:DATABASE_NAME];
}

@end

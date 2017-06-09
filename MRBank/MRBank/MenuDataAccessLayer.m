//
//  MenuDataAccessLayer.m
//  TimHortons
//
//  Created by Kiran kumar on 24/09/15.
//  Copyright (c) 2015 WINIT. All rights reserved.
//

#import "MenuDataAccessLayer.h"

@implementation MenuDataAccessLayer


-(NSMutableArray *)getDetailsList
{
    NSMutableArray *arrContacts = [[NSMutableArray alloc]init];
    sqlite3 *dataBase;
    sqlite3_open([[APP_DELEGATE getDBPath] UTF8String], &dataBase);
    // Do Database operation
    sqlite3_stmt *selectStmt = nil;
    NSString *strValue = [NSString stringWithFormat:@"SELECT * FROM tblDetails"];
    const char *sql = [strValue UTF8String];
        if(sqlite3_prepare_v2(dataBase, sql, -1, &selectStmt, NULL) == SQLITE_OK)
        {
            while(sqlite3_step(selectStmt) == SQLITE_ROW)
            {
                
                DetailBO *objItem = [[DetailBO alloc] init];
                
               
                char *chrstrClubName =(char *)sqlite3_column_text(selectStmt, 0);
                if(chrstrClubName !=NULL)
                {
                    objItem.strFirst_Name = [NSString stringWithUTF8String:chrstrClubName];
                }
                chrstrClubName = nil;

                
                char *chrstrName =(char *)sqlite3_column_text(selectStmt, 1);
                if(chrstrName !=NULL)
                {
                    objItem.strLast_Name = [NSString stringWithUTF8String:chrstrName];
                }
                chrstrName = nil;
                
                char *chrstrDOB =(char *)sqlite3_column_text(selectStmt, 2);
                if(chrstrDOB !=NULL)
                {
                    objItem.strEmailId = [NSString stringWithUTF8String:chrstrDOB];
                }
                chrstrDOB = nil;

                
                char *chrstrLastName =(char *)sqlite3_column_text(selectStmt, 3);
                if(chrstrLastName !=NULL)
                {
                    objItem.strUserName = [NSString stringWithUTF8String:chrstrLastName];
                }
                chrstrLastName = nil;
                
                char *chrstrProff =(char *)sqlite3_column_text(selectStmt, 4);
                if(chrstrProff !=NULL)
                {
                    objItem.strAcc_NO = [NSString stringWithUTF8String:chrstrProff];
                }
                chrstrProff = nil;
                
                char *chrstranni =(char *)sqlite3_column_text(selectStmt, 5);
                if(chrstranni !=NULL)
                {
                    objItem.strPassword = [NSString stringWithUTF8String:chrstranni];
                }
                chrstranni = nil;
                
                char *chrstrHobby =(char *)sqlite3_column_text(selectStmt, 6);
                if(chrstrHobby !=NULL)
                {
                    objItem.strAddress = [NSString stringWithUTF8String:chrstrHobby];
                }
                chrstrHobby = nil;
                
               
                
                
                [arrContacts addObject:objItem];
                objItem = nil;
            }
        }
        sqlite3_reset(selectStmt);
        if (selectStmt)
        {
            sqlite3_finalize(selectStmt);
            selectStmt = nil;
        }    

        sqlite3_close(dataBase);
        dataBase = nil;
        return arrContacts;

}

-(NSMutableArray *)getDetailsList:(NSString*)strName
{
    NSMutableArray *arrContacts = [[NSMutableArray alloc]init];
    sqlite3 *dataBase;
    sqlite3_open([[APP_DELEGATE getDBPath] UTF8String], &dataBase);
    // Do Database operation
    sqlite3_stmt *selectStmt = nil;
    NSString *strValue = [NSString stringWithFormat:@"SELECT * FROM tblDetails WHERE Email_Id='%@'",strName];
    const char *sql = [strValue UTF8String];
    if(sqlite3_prepare_v2(dataBase, sql, -1, &selectStmt, NULL) == SQLITE_OK)
    {
        while(sqlite3_step(selectStmt) == SQLITE_ROW)
        {
            DetailBO *objItem = [[DetailBO alloc] init];

            char *chrstrClubName =(char *)sqlite3_column_text(selectStmt, 0);
            if(chrstrClubName !=NULL)
            {
                objItem.strFirst_Name = [NSString stringWithUTF8String:chrstrClubName];
            }
            chrstrClubName = nil;
            
            
            char *chrstrName =(char *)sqlite3_column_text(selectStmt, 1);
            if(chrstrName !=NULL)
            {
                objItem.strLast_Name = [NSString stringWithUTF8String:chrstrName];
            }
            chrstrName = nil;
            
            char *chrstrDOB =(char *)sqlite3_column_text(selectStmt, 2);
            if(chrstrDOB !=NULL)
            {
                objItem.strEmailId = [NSString stringWithUTF8String:chrstrDOB];
            }
            chrstrDOB = nil;
            
            
            char *chrstrLastName =(char *)sqlite3_column_text(selectStmt, 3);
            if(chrstrLastName !=NULL)
            {
                objItem.strUserName = [NSString stringWithUTF8String:chrstrLastName];
            }
            chrstrLastName = nil;
            
            char *chrstrProff =(char *)sqlite3_column_text(selectStmt, 4);
            if(chrstrProff !=NULL)
            {
                objItem.strAcc_NO = [NSString stringWithUTF8String:chrstrProff];
            }
            chrstrProff = nil;
            
            char *chrstranni =(char *)sqlite3_column_text(selectStmt, 5);
            if(chrstranni !=NULL)
            {
                objItem.strPassword = [NSString stringWithUTF8String:chrstranni];
            }
            chrstranni = nil;
            
            char *chrstrHobby =(char *)sqlite3_column_text(selectStmt, 6);
            if(chrstrHobby !=NULL)
            {
                objItem.strAddress = [NSString stringWithUTF8String:chrstrHobby];
            }
            chrstrHobby = nil;
            
            [arrContacts addObject:objItem];
            objItem = nil;

        }
    }
    sqlite3_reset(selectStmt);
    if (selectStmt)
    {
        sqlite3_finalize(selectStmt);
        selectStmt = nil;
    }
    
    sqlite3_close(dataBase);
    dataBase = nil;
    return arrContacts;
    
}


-(void)insertItemIntoTblTotalMembersdetails:(NSMutableArray *)arrObjects
{
    sqlite3 *dataBase;
    sqlite3_open([[APP_DELEGATE getDBPath] UTF8String], &dataBase);
        // Do Database operation
        
        sqlite3_stmt *insertStmt = nil;
    
        
        for(int i=0;i<arrObjects.count;i++)
        {
            
            DetailBO *objItem=[arrObjects objectAtIndex:i];
            if(insertStmt == nil)
            {
                NSString *strInsert = [NSString stringWithFormat:@"INSERT INTO tblDetails (First_Name,Last_Name,Email_Id,UserName,Acc_No,Password,Address) VALUES  (?,?,?,?,?,?,?)"];
                const char *sql = [strInsert UTF8String];
                if(sqlite3_prepare_v2(dataBase, sql, -1, &insertStmt, NULL) != SQLITE_OK)
                {
                    NSLog(@"Error while creating INSERT INTO tblDetails statement. '%s'", sqlite3_errmsg(dataBase));
                }
            }
          
            int rowidentifier = -1;
           
            if (rowidentifier==-1)
            {
                if(sqlite3_bind_text(insertStmt, 1, [objItem.strFirst_Name UTF8String], -1, SQLITE_TRANSIENT)!= SQLITE_OK)
                {
                    NSLog(@"Error while creating Select tblDetails statement. '%s'", sqlite3_errmsg(dataBase));
                }
                if(sqlite3_bind_text(insertStmt, 2, [objItem.strLast_Name UTF8String], -1, SQLITE_TRANSIENT)!= SQLITE_OK)
                {
                    NSLog(@"Error while creating Select tblDetails statement. '%s'", sqlite3_errmsg(dataBase));
                    
                }
                if(sqlite3_bind_text(insertStmt, 3, [objItem.strEmailId UTF8String], -1, SQLITE_TRANSIENT)!= SQLITE_OK)
                {
                    NSLog(@"Error while creating Select tblDetails statement. '%s'", sqlite3_errmsg(dataBase));
                }
                if(sqlite3_bind_text(insertStmt, 4, [objItem.strUserName UTF8String], -1, SQLITE_TRANSIENT)!= SQLITE_OK)
                {
                    NSLog(@"Error while creating Select tblDetails statement. '%s'", sqlite3_errmsg(dataBase));
                }
                if(sqlite3_bind_text(insertStmt, 5, [objItem.strAcc_NO UTF8String], -1, SQLITE_TRANSIENT)!= SQLITE_OK)
                {
                    NSLog(@"Error while creating Select tblDetails statement. '%s'", sqlite3_errmsg(dataBase));
                }
                if(sqlite3_bind_text(insertStmt, 6, [objItem.strPassword UTF8String], -1, SQLITE_TRANSIENT)!= SQLITE_OK)
                {
                    NSLog(@"Error while creating Select tblDetails statement. '%s'", sqlite3_errmsg(dataBase));
                }
                if(sqlite3_bind_text(insertStmt, 7, [objItem.strAddress UTF8String], -1, SQLITE_TRANSIENT)!= SQLITE_OK)
                {
                    NSLog(@"Error while creating Select tblDetails statement. '%s'", sqlite3_errmsg(dataBase));
                }
                
                if(SQLITE_DONE != sqlite3_step(insertStmt))
                {
                    NSLog(@" Error %s",sqlite3_errmsg(dataBase));
                    NSLog(@"Error while inserting data in tblDetails prepare statement.%s", sqlite3_errmsg(dataBase));
                }
                sqlite3_reset(insertStmt);
            }
            
            if (insertStmt)
            {
                sqlite3_finalize(insertStmt);
                insertStmt = nil;
            }
            
            objItem=nil;
        }
        sqlite3_close(dataBase);
        dataBase = nil;
    
}





@end

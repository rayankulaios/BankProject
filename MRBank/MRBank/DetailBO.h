//
//  DetailBO.h
//  MRBank
//
//  Created by manikanta rayankula on 13/07/16.
//  Copyright © 2016 manikanta rayankula. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailBO : NSObject
{
    NSString *strFirst_Name;
    NSString *strLast_Name;
    NSString *strUserName;
    NSString *strEmailId;
    NSString *strPassword;
    NSString *strAddress;
    NSString *strAcc_NO;
}

@property(nonatomic , strong) NSString *strFirst_Name;
@property(nonatomic , strong) NSString *strLast_Name;
@property(nonatomic , strong) NSString *strUserName;
@property(nonatomic , strong) NSString *strEmailId;
@property(nonatomic , strong) NSString *strPassword;
@property(nonatomic , strong) NSString *strAddress;
@property(nonatomic , strong) NSString *strAcc_NO;

@end

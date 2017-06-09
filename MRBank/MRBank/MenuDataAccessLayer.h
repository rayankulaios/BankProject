//
//  MenuDataAccessLayer.h
//  TimHortons
//
//  Created by Kiran kumar on 24/09/15.
//  Copyright (c) 2015 WINIT. All rights reserved.
//

#import "BaseDataAccessLayer.h"
#import "DetailBO.h"

@interface MenuDataAccessLayer : BaseDataAccessLayer

-(NSMutableArray *)getDetailsList;
-(NSMutableArray *)getDetailsList:(NSString*)strName;


-(void)insertItemIntoTblTotalMembersdetails:(NSMutableArray *)arrObjects;



@end

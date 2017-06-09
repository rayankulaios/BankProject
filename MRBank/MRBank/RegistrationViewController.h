//
//  RegistrationViewController.h
//  MRBank
//
//  Created by manikanta rayankula on 13/07/16.
//  Copyright © 2016 manikanta rayankula. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailBO.h"
#import "AccountViewController.h"
#import "MenuDataAccessLayer.h"


@interface RegistrationViewController : UIViewController<UIAlertViewDelegate,UITextFieldDelegate>
{
    DetailBO *objPresent;
}


- (IBAction)btnBackClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIScrollView *scrlView;

@property (strong, nonatomic) IBOutlet UITextField *txtfldFirstName;

@property (strong, nonatomic) IBOutlet UITextField *txtfldLastName;

@property (strong, nonatomic) IBOutlet UITextField *txtfldEmailId;
@property (strong, nonatomic) IBOutlet UITextField *txtfldUsername;
@property (strong, nonatomic) IBOutlet UITextField *txtfldPw;
@property (strong, nonatomic) IBOutlet UITextField *txtfldAccNo;
@property (strong, nonatomic) IBOutlet UITextField *txtfldAddress;

@property (strong, nonatomic) IBOutlet UIButton *btnSend;
- (IBAction)btnSendClicked:(id)sender;
-(void)savingDataInDB:(DetailBO*)objPresent;
@end

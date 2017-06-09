//
//  ForgotPwViewController.h
//  MRBank
//
//  Created by manikanta rayankula on 13/07/16.
//  Copyright © 2016 manikanta rayankula. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuDataAccessLayer.h"

@interface ForgotPwViewController : UIViewController<UIAlertViewDelegate,UITextFieldDelegate>


@property (strong, nonatomic) IBOutlet UITextField *txtfldEmailid;


@property (strong, nonatomic) IBOutlet UIButton *btnSend;
- (IBAction)btnSendClicked:(id)sender;
- (IBAction)btnBackClied:(id)sender;

@end

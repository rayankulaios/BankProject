//
//  HomeViewController.h
//  MRBank
//
//  Created by manikanta rayankula on 13/07/16.
//  Copyright © 2016 manikanta rayankula. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuDataAccessLayer.h"
#import "DetailBO.h"
#import "AccountViewController.h"

@interface HomeViewController : UIViewController<UIAlertViewDelegate,UITextFieldDelegate>


@property (strong, nonatomic) IBOutlet UITextField *txtfldEmailid;
@property (strong, nonatomic) IBOutlet UITextField *txtfldPw;

- (IBAction)btnSigninClicked:(id)sender;


@end

//
//  ForgotPwViewController.m
//  MRBank
//
//  Created by manikanta rayankula on 13/07/16.
//  Copyright © 2016 manikanta rayankula. All rights reserved.
//

#import "ForgotPwViewController.h"

@interface ForgotPwViewController ()
{
    NSMutableArray *arrCheckData;
}
@end

@implementation ForgotPwViewController
@synthesize txtfldEmailid;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark -- validate Email

-(BOOL)vallidateEmail:(NSString *)candidate
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:candidate];
}


-(BOOL)validateEmailAndPassword
{
    
    if(self.txtfldEmailid.text.length==0){
        [self showAlertwithTitle:@"" withMsg:@"Please enter your Email Id." withCancelButtonTitle:@"Ok"];
        return NO;
    }
    else if (!([self vallidateEmail:self.txtfldEmailid.text]))
    {
        [self showAlertwithTitle:@"" withMsg:@"Please enter valid email id." withCancelButtonTitle:@"Ok"];
        return NO;
    }
    else
    {
        arrCheckData = [[NSMutableArray alloc] init];
        MenuDataAccessLayer *Dlayer=[[MenuDataAccessLayer alloc]init];
        arrCheckData = [Dlayer getDetailsList:txtfldEmailid.text];
        if (arrCheckData.count==0)
        {
            [self showAlertwithTitle:@"Alert!" withMsg:@"This Email was not registerd in Our Data Base, Please Register." withCancelButtonTitle:@"Ok"];
            return NO;
        }
        
    }
    
    
    return YES;
}




#pragma mark -
#pragma mark -- UITextField Delegate Methods

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [UIView animateWithDuration:0.3 animations:^{
        
    } completion:^(BOOL finished) {
        
    }];
    
    [textField resignFirstResponder];
    
    return YES;
}



-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.3 animations:^{
        
        
    } completion:^(BOOL finished) {
        
    }];
    return YES;
}

-(void)showAlertwithTitle:(NSString *)strTitle withMsg:(NSString *)strMsg withCancelButtonTitle:(NSString *)strCancel
{
    
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:nil cancelButtonTitle:strCancel otherButtonTitles:nil];
    
    [alert show];
}

- (IBAction)btnSendClicked:(id)sender
{
    if ([self validateEmailAndPassword])
    {
        UIAlertController *alert= [UIAlertController alertControllerWithTitle:@"Alert!"
                                                                      message:@"Sent Successfully!." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"Ok"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 [self.navigationController popViewControllerAnimated:YES];
                                 
                                 
                             }];
        [alert addAction:ok];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    
}

- (IBAction)btnBackClied:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end

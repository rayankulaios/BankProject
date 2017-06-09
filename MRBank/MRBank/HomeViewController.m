//
//  HomeViewController.m
//  MRBank
//
//  Created by manikanta rayankula on 13/07/16.
//  Copyright © 2016 manikanta rayankula. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()
{
    NSMutableArray *arrCheckData;
}

@end

@implementation HomeViewController
@synthesize txtfldEmailid;
@synthesize txtfldPw;

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
    else if(self.txtfldPw.text.length==0){
        [self showAlertwithTitle:@"" withMsg:@"Please enter  password." withCancelButtonTitle:@"Ok"];
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

- (IBAction)btnSigninClicked:(id)sender
{
    if ([self validateEmailAndPassword])
    {
        DetailBO *obj = [[DetailBO alloc] init];
        obj = [arrCheckData objectAtIndex:0];
        arrCheckData=nil;
        if ([obj.strEmailId isEqualToString:txtfldEmailid.text])
        {
            if ([obj.strPassword isEqualToString:txtfldPw.text])
            {
                UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
                AccountViewController *fVw=[storyBoard instantiateViewControllerWithIdentifier:@"AccountViewController"];
                [self.navigationController pushViewController:fVw animated:YES];

            }
            else
            {
                [self showAlertwithTitle:@"Alert!" withMsg:@"Password is incorrect." withCancelButtonTitle:@"Ok"];
            }
            
        }
        else
        {
            [self showAlertwithTitle:@"Alert!" withMsg:@"This Email was not registerd in Our Data Base, Please Register." withCancelButtonTitle:@"Ok"];
        }
            
    }
}
@end

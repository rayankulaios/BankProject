//
//  RegistrationViewController.m
//  MRBank
//
//  Created by manikanta rayankula on 13/07/16.
//  Copyright © 2016 manikanta rayankula. All rights reserved.
//

#import "RegistrationViewController.h"

@interface RegistrationViewController ()

@end

@implementation RegistrationViewController
@synthesize scrlView;
@synthesize txtfldPw;
@synthesize txtfldAccNo;
@synthesize txtfldAddress;
@synthesize txtfldEmailId;
@synthesize txtfldLastName;
@synthesize txtfldUsername;
@synthesize txtfldFirstName;


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
    if (self.txtfldFirstName.text.length==0) {
        [self showAlertwithTitle:@"" withMsg:@"Please enter your First Name." withCancelButtonTitle:@"Ok"];
        return NO;
    }
    if(self.txtfldLastName.text.length==0){
        [self showAlertwithTitle:@"" withMsg:@"Please enter your Last Name." withCancelButtonTitle:@"Ok"];
        return NO;
    }
    if(self.txtfldEmailId.text.length==0){
        [self showAlertwithTitle:@"" withMsg:@"Please enter your Email Id." withCancelButtonTitle:@"Ok"];
        return NO;
    }
    else if (!([self vallidateEmail:self.txtfldEmailId.text]))
    {
        [self showAlertwithTitle:@"" withMsg:@"Please enter valid email id." withCancelButtonTitle:@"Ok"];
        return NO;
    }
    if (self.txtfldUsername.text.length==0){
        [self showAlertwithTitle:@"" withMsg:@"Please enter UserName." withCancelButtonTitle:@"Ok"];
        return NO;
    }
    else if(self.txtfldPw.text.length<6){
        [self showAlertwithTitle:@"" withMsg:@"Please enter  password." withCancelButtonTitle:@"Ok"];
        return NO;
    }
    else if(self.txtfldAccNo.text.length<6){
        [self showAlertwithTitle:@"" withMsg:@"Please enter your Account No ." withCancelButtonTitle:@"Ok"];
        return NO;
    }
    else if(self.txtfldAddress.text.length<6){
        [self showAlertwithTitle:@"" withMsg:@"Please enter Your Address." withCancelButtonTitle:@"Ok"];
        return NO;
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
        
        self.scrlView.contentOffset=CGPointMake(0, 0);
        
    } completion:^(BOOL finished) {
        
    }];
    
    [textField resignFirstResponder];
    
    return YES;
}



-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField==txtfldFirstName || textField==txtfldLastName)
    {
        
    }
    else
    {
        [UIView animateWithDuration:0.3 animations:^{
            
            self.scrlView.contentOffset=CGPointMake(0, 50);
            
        } completion:^(BOOL finished) {
            
        }];
    }
    
    return YES;
}

-(void)showAlertwithTitle:(NSString *)strTitle withMsg:(NSString *)strMsg withCancelButtonTitle:(NSString *)strCancel
{
    
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:nil cancelButtonTitle:strCancel otherButtonTitles:nil];
    
    [alert show];
}


- (IBAction)btnBackClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnSendClicked:(id)sender
{
    if ([self validateEmailAndPassword])
    {
        
        objPresent = [[DetailBO alloc] init];
        objPresent.strFirst_Name = txtfldFirstName.text;
        objPresent.strLast_Name = txtfldLastName.text;
        objPresent.strEmailId = txtfldEmailId.text;
        objPresent.strUserName = txtfldUsername.text;
        objPresent.strPassword = txtfldPw.text;
        objPresent.strAcc_NO = txtfldAccNo.text;
        objPresent.strAddress = txtfldAddress.text;
        
        UIAlertController *alert= [UIAlertController alertControllerWithTitle:@"Thank you!"
                                                                      message:@"Registration Successfully!." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"Ok"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                     [self savingDataInDB:objPresent];
                                 });
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                 AccountViewController *fVw=[storyBoard instantiateViewControllerWithIdentifier:@"AccountViewController"];
                                 [self.navigationController pushViewController:fVw animated:YES];
                                 
                             }];
        [alert addAction:ok];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}

-(void)savingDataInDB:(DetailBO*)objCurrent
{
    MenuDataAccessLayer *Dlayer=[[MenuDataAccessLayer alloc]init];
    NSMutableArray *arr = [[NSMutableArray alloc] initWithObjects:objCurrent, nil];
    [Dlayer insertItemIntoTblTotalMembersdetails:arr];
}

@end

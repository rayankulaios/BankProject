//
//  LocationViewController.m
//  MRBank
//
//  Created by manikanta rayankulaon 13/07/16.
//  Copyright © 2016 manikanta rayankula. All rights reserved.
//

#import "LocationViewController.h"
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)


@interface LocationViewController ()

@end

@implementation LocationViewController
@synthesize mpView,locationManager;
@synthesize txtfld;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [mpView setMapType:MKMapTypeStandard];
    [mpView setZoomEnabled:YES];
    [mpView setScrollEnabled:YES];
    mpView.showsUserLocation= YES;
    mpView.userInteractionEnabled=YES;
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
#ifdef __IPHONE_8_0
    if(IS_OS_8_OR_LATER) {
        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager requestAlwaysAuthorization];
    }
#endif
    [locationManager startUpdatingLocation];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - MKMapView Delegate Methods

//Annotation For Map View
- (MKAnnotationView *)mapView:(MKMapView *)map viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        return nil;
    }
    
   MKPinAnnotationView *pinView=[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pinView"];
    pinView.draggable = YES;
    pinView.canShowCallout = YES;
    pinView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    pinView.image = [UIImage imageNamed:@"mapView.png"];
    [[mpView.subviews objectAtIndex:1] setHidden:YES];
    
    return pinView;
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    
    
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
    return YES;
}


- (IBAction)btnGoClicked:(id)sender
{
    if (!txtfld.text.length)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:@"Please Enter Zipcode/Address." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
        [alert show];
    }
    else
    {
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder geocodeAddressString:txtfld.text
                     completionHandler:^(NSArray* placemarks, NSError* error){
                         if (placemarks && placemarks.count > 0) {
                             CLPlacemark *topResult = [placemarks objectAtIndex:0];
                             MKPlacemark *placemark = [[MKPlacemark alloc] initWithPlacemark:topResult];
                             
                             MKCoordinateRegion region = mpView.region;
                             region.center = placemark.region.center;
                             region.span.longitudeDelta /= 8.0;
                             region.span.latitudeDelta /= 8.0;
                             
                             [self.mpView setRegion:region animated:YES];
                             [self.mpView addAnnotation:placemark];
                         }
                     }
         ];
    }
}

- (IBAction)btnBackClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end

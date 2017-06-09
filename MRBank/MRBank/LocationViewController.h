//
//  LocationViewController.h
//  MRBank
//
//  Created by manikanta rayankula on 13/07/16.
//  Copyright © 2016 manikanta rayankula. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MapKit/MKAnnotation.h"
#import <CoreLocation/CLAvailability.h>

@interface LocationViewController : UIViewController<UITextFieldDelegate,MKMapViewDelegate, CLLocationManagerDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UITextField *txtfld;
@property (strong, nonatomic) IBOutlet MKMapView  *mpView;
@property (nonatomic, retain) CLLocationManager *locationManager;
- (IBAction)btnGoClicked:(id)sender;
- (IBAction)btnBackClicked:(id)sender;

@end

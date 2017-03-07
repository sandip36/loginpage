//
//  AmbulanceLocationMapViewController.m
//  Medipta
//
//  Created by Mac-04 on 22/07/16.
//  Copyright © 2016 Mac-02. All rights reserved.
//

#import "AmbulanceLocationMapViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "APIManager.h"
#import "Constant.h"
#import "Location.h"
#import "DataManager.h"


#define METERS_PER_MILE 1609.344

@interface AmbulanceLocationMapViewController () <CLLocationManagerDelegate,MKMapViewDelegate>
{
    UIAlertController *loadingSpinner;
    NSArray *globalData;
    int flag;
}

@property (weak, nonatomic) IBOutlet UIView *resetToCurrentLocationView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView
;
@end

@implementation AmbulanceLocationMapViewController
{
    CLLocationManager *locationManager;
    NSString *latitude;
    NSString *longitude;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    flag=0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
  _resetToCurrentLocationView.layer.cornerRadius = 20;
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
 locationManager.desiredAccuracy = kCLLocationAccuracyBest;
  [locationManager startUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
//    NSLog(@"didFailWithError: %@", error);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{

//    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude =  currentLocation.coordinate.latitude;
    zoomLocation.longitude= currentLocation.coordinate.longitude;
    
    if (currentLocation != nil) {
        
        longitude = [NSString stringWithFormat:@"%f", currentLocation.coordinate.longitude];
        latitude = [NSString stringWithFormat:@"%f", currentLocation.coordinate.latitude];
        
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
        [_mapView setRegion:viewRegion animated:YES];
    }
    [locationManager stopUpdatingLocation];
    
    NSString *str=[[DataManager sharedInstance] patientLocation];
   // https://aarogyasetu.net/api/method/phr.searchEmergencyDetails
    
    [[APIManager new] getAmbulances:@{@"location_id":str,@"type":@"Ambulance"} WithBlock:^(NSString *message, id response) {
        NSLog(@"api responce for ambulance%@",response);
        [self plotCrimePositions:response];
    }];
}



#pragma mark - Indicator
- (void) showSpinner {
    
    if (([[[UIDevice currentDevice] systemVersion] compare:@"8.0" options:NSNumericSearch] == NSOrderedAscending)) {
        // use UIAlertView
    }
    else {
        loadingSpinner = [Utility showProgress];
        [self.parentViewController presentViewController:loadingSpinner animated:NO completion:nil];
    }
}

- (void) dismissSpinner {
    if (([[[UIDevice currentDevice] systemVersion] compare:@"8.0" options:NSNumericSearch] == NSOrderedAscending)) {
        // use UIAlertView
    }
    else {
        [loadingSpinner dismissViewControllerAnimated:YES completion:nil];
    }
}



- (void)plotCrimePositions:(NSDictionary *)responseDict {
    
    for (id<MKAnnotation> annotation in _mapView.annotations) {
        [_mapView removeAnnotation:annotation];
    }
    globalData = [responseDict valueForKey:kMessage];
    if (globalData.count > 0) {
        
        for (int i = 0;i<globalData.count;i++  ) {
            NSDictionary *row = [globalData objectAtIndex:i];
            NSLog(@"%@",row);
            NSNumber * lati = [row objectForKey:@"latitude"];
            NSNumber * longi = [row objectForKey:@"longitude"];
            NSString * name = [row objectForKey:@"contact_name"];
            NSString * address = [row objectForKey:@"complete_address"];
            NSString * number = [row objectForKey:@"number"];
            
            CLLocationCoordinate2D coordinate;
            coordinate.latitude = lati.doubleValue;
            coordinate.longitude = longi.doubleValue;
            Location *annotation = [[Location alloc] initWithName:name address:address number:number coordinate:coordinate];
            annotation.indexNumber =[NSString stringWithFormat:@"%d",i];
            [_mapView addAnnotation:annotation];
            
            
        }
    }else{
        
    }
    
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    static NSString *identifier = @"MapPoint";
    
    if ([annotation isKindOfClass:[Location class]]) {
        MKAnnotationView *annotationView = (MKAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            annotationView.image = [UIImage imageNamed:@"ambulance"];
            annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        } else {
            annotationView.annotation = annotation;
        }
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        return annotationView;
    }
    return nil;
}
//- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
//{
//    NSLog(@"selected mapview annotation%@",view.annotation);
////    MKAnnotationView *currentAnnotation = view.annotation;
////    // ...
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(calloutTapped:)];
//    [view addGestureRecognizer:tapGesture];
//    
//}
//
//-(void)calloutTapped:(UITapGestureRecognizer *) sender
//{
//    NSLog(@"Callout was tapped");
//    
//    MKAnnotationView *view = (MKAnnotationView*)sender.view;
//    id <MKAnnotation> annotation = [view annotation];
//    if ([annotation isKindOfClass:[MKPointAnnotation class]])
//    {
//        [self performSegueWithIdentifier:@"annotationDetailSegue" sender:annotation];
//    }
//}

- (void)mapView:(MKMapView *)eMapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {

    Location * ann =(Location *)view.annotation;
    
    NSDictionary *dict = [globalData objectAtIndex:[ann.indexNumber intValue]];
    
    NSString *phoneNUMBER = [dict valueForKey:@"number"];
    phoneNUMBER= [phoneNUMBER stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    phoneNUMBER = [phoneNUMBER stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:kMedipta message:@"Ambulance is available for service" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *call = [UIAlertAction actionWithTitle:@"Call" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                           {
                               if (phoneNUMBER) {
                                   NSLog(@"u have change the number %@",phoneNUMBER);
                                   
                                   [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", phoneNUMBER]]];
                                    }else{
                                       
                                   [self presentViewController:[Utility showAlertWithTitle:kMedipta andMessage:@"Call facility is not available"] animated:YES completion:nil];
                                   }

                               
                           }];

    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"CANCEL" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:call];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)resetToCurrentLoc:(id)sender {
    
    if (flag==0) {
        flag=1;
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(latitude.doubleValue, longitude.doubleValue);
        MKCoordinateSpan span = MKCoordinateSpanMake(0.03, 0.20);
        MKCoordinateRegion region = {coord, span};
        //MKCoordinateRegionMakeWithDistance(coord, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
        [_mapView setRegion:region];
    }else{
        flag=0;
        CLLocationCoordinate2D zoomLocation;
        zoomLocation.latitude =  latitude.doubleValue;
        zoomLocation.longitude= longitude.doubleValue;
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
        [_mapView setRegion:viewRegion animated:YES];
    }

}
@end

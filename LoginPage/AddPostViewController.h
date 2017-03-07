//
//  AddPostViewController.h
//  Traveller_ObjC
//
//  Created by Sagar Shirbhate on 13/04/16.
//  Copyright © 2016 Sagar Shirbhate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import <GoogleMaps/GoogleMaps.h>
@interface AddPostViewController : UIViewController<PlaceSearchTextFieldDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextViewDelegate>
{
    
    int selectedIndex;
    
    __weak IBOutlet MKMapView *mapView;
    
    __weak IBOutlet NSLayoutConstraint *heightOfMapView;
    
    __weak IBOutlet UIImageView *postImageView;
    __weak IBOutlet NSLayoutConstraint *postImageViewHeight;
    
    __weak IBOutlet UIButton *btnCamera;
    __weak IBOutlet UIButton *btnGallery;

    __weak IBOutlet UILabel *addImageLbl;
    __weak IBOutlet UILabel *addLocationLbl;
    __weak IBOutlet UILabel *addPostDetailsLbl;
    __weak IBOutlet UILabel *selectPostTypeLbl;
    
    __weak IBOutlet UILabel *logo1;
    __weak IBOutlet UILabel *logo2;
    __weak IBOutlet UILabel *logo3;
    __weak IBOutlet UILabel *logo4;
    
    __weak IBOutlet UITextView *descriptionTextView;
    
    __weak IBOutlet UIScrollView *myScrollView;
    
    NSMutableArray * buttonArray;
    
    UIImagePickerController *ipc;
    UIPopoverController *popover;
}
@property (weak, nonatomic) IBOutlet MVPlaceSearchTextField *txtPlaceSearch;
@property(strong,nonatomic)NSDictionary * selectedCityDict;

@end

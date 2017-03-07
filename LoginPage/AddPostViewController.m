//
//  AddPostViewController.m
//  Traveller_ObjC
//
//  Created by Sagar Shirbhate on 13/04/16.
//  Copyright © 2016 Sagar Shirbhate. All rights reserved.
//

#import "AddPostViewController.h"

@interface AddPostViewController ()

@end

@implementation AddPostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpView];
    [self setUpScrollView];
    [self setUpNavigationBar];
    self.title=@"Places Visited In Agra";
 }

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-( void)setUpScrollView {
    
    NSArray * namesOfMenus =@[@"Place",@"Food",@"Accommodation",@"Shopping"];
    CGFloat scrollWidth = 0.f;
    buttonArray=[[NSMutableArray alloc]init];
    for ( int j=0; j<namesOfMenus.count; j++)
    {
        NSString * name =[namesOfMenus objectAtIndex:j];
        CGSize size = [name sizeWithAttributes:
                       @{NSFontAttributeName: [UIFont fontWithName:font_bold size:font_size_button]}];
        CGSize textSize = CGSizeMake(ceilf(size.width), ceilf(size.height));
        CGFloat strikeWidth;
        if (iPAD) {
            strikeWidth = self.view.frame.size.width/4.5;
        }else{
            strikeWidth = textSize.width+30;
        }
        CGRect frame = CGRectMake(scrollWidth, 0,strikeWidth+10, 40);
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTag:j];
        button.frame = frame;
        [button setBackgroundColor:[UIColor whiteColor]];
        button.titleLabel.textColor=[UIColor whiteColor];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.layer.borderColor=[UIColor whiteColor].CGColor;
        button.titleLabel.textAlignment=NSTextAlignmentCenter;
        [button addTarget:self action:@selector(buttonEvent:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:name forState:UIControlStateNormal];
        
        scrollWidth= scrollWidth+strikeWidth+10;
        
        if (j==selectedIndex) {
            button.backgroundColor= Check_Color;
            [button addWhiteLayerAndCornerRadius:2 AndWidth:1];
            [button addShaddow];
            if (iPhone6||iPhone6plus) {
                button.titleLabel.font=[UIFont fontWithName:font_bold size:font_size_normal_regular];
            }else {
                button.titleLabel.font=[UIFont fontWithName:font_bold size:font_size_normal_regular];
            }
        }else {
            button.backgroundColor= [UIColor blackColor];
            //[self removeShaddowToView:button];
            button.layer.borderColor=[UIColor whiteColor].CGColor;
            if (iPhone6||iPhone6plus) {
                button.titleLabel.font=[UIFont fontWithName:font_bold size:font_size_normal_regular];
            }else{
                button.titleLabel.font=[UIFont fontWithName:font_bold size:font_size_normal_regular];
            }
        }
        
        [buttonArray addObject:button];
        [myScrollView addSubview:button];
        
    }
    myScrollView.contentSize = CGSizeMake(scrollWidth, 30.f);
    myScrollView.pagingEnabled = NO;
    [myScrollView setShowsHorizontalScrollIndicator:NO];
    [myScrollView setShowsVerticalScrollIndicator:NO];

    
}

#pragma mark====================On Selection of Segment===============================
-(void)buttonEvent:(UIButton*)sender
{
    NSInteger index= sender.tag;
    selectedIndex= (int) index;
    
    for(int i=0;i<buttonArray.count;i++)
    {
        UIButton * button =(UIButton*)[buttonArray objectAtIndex:i];
        if (i==selectedIndex) {
            button.backgroundColor= Check_Color;
            [button addWhiteLayerAndCornerRadius:2 AndWidth:1];
            [button addShaddow];
            if (iPhone6||iPhone6plus) {
                button.titleLabel.font=[UIFont fontWithName:font_bold size:font_size_normal_regular];
            }else {
                button.titleLabel.font=[UIFont fontWithName:font_bold size:font_size_normal_regular];
            }
        }else {
            button.backgroundColor= [UIColor blackColor];
            //[self removeShaddowToView:button];
            button.layer.borderColor=[UIColor whiteColor].CGColor;
            if (iPhone6||iPhone6plus) {
                button.titleLabel.font=[UIFont fontWithName:font_bold size:font_size_normal_regular];
            }else{
                button.titleLabel.font=[UIFont fontWithName:font_bold size:font_size_normal_regular];
            }
        }
    }
    
    CGRect frame1 = myScrollView.frame;
    UIButton * bt=(UIButton*)[buttonArray objectAtIndex:index];
    frame1 =bt.frame ;
    [myScrollView scrollRectToVisible:frame1 animated:YES];
    [self segmentSwitch];
}


- (IBAction)segmentSwitch{
    switch (selectedIndex) {
            //==============================1st selected============================
        case 0:
        {
            addLocationLbl.text=@"Add Place Location";
            addPostDetailsLbl.text=@"Add Place Details";
        }break;
             //==============================2nd selected============================
        case 1:
        {
            addLocationLbl.text=@"Add Food Location";
            addPostDetailsLbl.text=@"Add Food Details";
        }break;
             //==============================3rd selected============================
        case 2:
        {
            addLocationLbl.text=@"Add Accommodation Location";
            addPostDetailsLbl.text=@"Add Accommodation Details";
        }break;
             //==============================4th selected============================
        case 3:
        {
            addLocationLbl.text=@"Add Shopping Location";
            addPostDetailsLbl.text=@"Add Shopping Details";
            
        }break;
        default:
            break;
    }
}

-(void)viewDidAppear:(BOOL)animated{
}

-(void)setUpView{

    
    _txtPlaceSearch.strApiKey                           = @"AIzaSyBuQ0Z76oO7IJBaYxF7pWziTZ8-17LWosc";
    _txtPlaceSearch.placeSearchDelegate                 = self;
    _txtPlaceSearch.superViewOfList                     = self.view;  // View, on which Autocompletion list should be appeared.
    _txtPlaceSearch.autoCompleteShouldHideOnSelection   = YES;
    _txtPlaceSearch.maximumNumberOfAutoCompleteRows     = 6;
    _txtPlaceSearch.autoCompleteRegularFontName =  font_regular;
    _txtPlaceSearch.autoCompleteBoldFontName = font_bold;
    _txtPlaceSearch.autoCompleteTableCornerRadius=0.0;
    _txtPlaceSearch.autoCompleteRowHeight=40;
    _txtPlaceSearch.autoCompleteTableCellTextColor=[UIColor blackColor];
    _txtPlaceSearch.autoCompleteFontSize=font_size_normal_regular;
    _txtPlaceSearch.autoCompleteTableBorderWidth=1.0;
    _txtPlaceSearch.autoCompleteTableBorderColor=[UIColor lightGrayColor];
    [_txtPlaceSearch.autoCompleteTableView addShaddow];
    _txtPlaceSearch.showTextFieldDropShadowWhenAutoCompleteTableIsOpen=YES;
    _txtPlaceSearch.autoCompleteShouldHideOnSelection=YES;
    _txtPlaceSearch.autoCompleteShouldHideClosingKeyboard=YES;
    _txtPlaceSearch.autoCompleteShouldSelectOnExactMatchAutomatically = YES;
    _txtPlaceSearch.autoCompleteTableFrame = CGRectMake((self.view.frame.size.width-_txtPlaceSearch.frame.size.width)*0.5, _txtPlaceSearch.frame.size.height+100.0, _txtPlaceSearch.frame.size.width, 300);
    
  
    [mapView addBlackLayerAndCornerRadius:3 AndWidth:1];
    [mapView addShaddow];
    
    
    [postImageView addShaddow];
    postImageViewHeight.constant=0;
    
        [btnCamera addBlackLayerAndCornerRadius:cornerRadius_Button AndWidth:borderWidth_Button];
        [btnGallery addBlackLayerAndCornerRadius:cornerRadius_Button AndWidth:borderWidth_Button];
    btnCamera.titleLabel.font=[UIFont fontWithName:font_button size:font_size_button];
    btnGallery.titleLabel.font=[UIFont fontWithName:font_button size:font_size_button];

    
    btnCamera.backgroundColor=userShouldDOButoonColor;
    btnGallery.backgroundColor=userShouldNOTDOButoonColor;
    [btnCamera addShaddow];
    [btnGallery addShaddow];

    addImageLbl.font=[UIFont fontWithName:font_bold size:font_size_normal_bold];
    addLocationLbl.font=[UIFont fontWithName:font_bold size:font_size_normal_bold];
   addPostDetailsLbl.font=[UIFont fontWithName:font_bold size:font_size_normal_bold];
   selectPostTypeLbl.font=[UIFont fontWithName:font_bold size:font_size_normal_bold];
    
     logo1.font=[UIFont fontWithName:fontIcomoon size:logo_Size_Small];
     logo2.font=[UIFont fontWithName:fontIcomoon size:logo_Size_Small];
     logo3.font=[UIFont fontWithName:fontIcomoon size:logo_Size_Small];
     logo4.font=[UIFont fontWithName:fontIcomoon size:logo_Size_Small];
    
    logo1.text=[NSString stringWithUTF8String:ICOMOON_FAVORITE];
    logo2.text=[NSString stringWithUTF8String:ICOMOON_PHOTO];
    logo3.text=[NSString stringWithUTF8String:ICOMOON_LOCATION];
    logo4.text=[NSString stringWithUTF8String:ICOMOON_USER];
    
    descriptionTextView.font=[UIFont fontWithName:font_regular size:font_size_normal_regular];
    [descriptionTextView addBlackLayerAndCornerRadius:3 AndWidth:1];
    [descriptionTextView addShaddow];
    
    descriptionTextView.text = @"  This place is known for ? How to get it ? Things to do ? Famous things ? etc. ";
    descriptionTextView.textColor = [UIColor lightGrayColor];


}
-(void)setUpNavigationBar{
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont
                                                                           fontWithName:font_bold size:22], NSFontAttributeName,
                                back_btn_Color, NSForegroundColorAttributeName, nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    
    UIButton *btnClose = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnClose setFrame:CGRectMake(0, 0, 30, 30)];
    
    btnClose.titleLabel.font=[UIFont fontWithName:fontIcomoon size:logo_Size_Small];
    btnClose.tintColor=back_btn_Color;
    //  [btnClose setTitle:[FontIcon iconString:ICON_CANCEL] forState:UIControlStateNormal];
    [btnClose addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftbarButton = [[UIBarButtonItem alloc] initWithCustomView:btnClose];
    self.navigationItem.leftBarButtonItem = leftbarButton;
    
    UIButton *btnSend = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnSend setFrame:CGRectMake(0, 0, 30, 30)];
    btnSend.titleLabel.font=[UIFont fontWithName:fontIcomoon size:logo_Size_Small];
    btnSend.tintColor=[UIColor redColor];
    // [btnSend setTitle:[FontIcon iconString:ICON_SEND] forState:UIControlStateNormal];
    [btnSend addTarget:self action:@selector(savePost) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *sendBarBtn = [[UIBarButtonItem alloc] initWithCustomView:btnSend];

    NSMutableArray *buttonArrayForNav=[[NSMutableArray alloc]initWithCapacity:2];
    [buttonArrayForNav addObject:sendBarBtn];
    self.navigationItem.rightBarButtonItems = buttonArrayForNav;
}

-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)savePost{
    
}

#pragma mark - Place search Textfield Delegates

-(void)placeSearch:(MVPlaceSearchTextField*)textField ResponseForSelectedPlace:(GMSPlace*)responseDict{
    [self.view endEditing:YES];
    [self addPin:responseDict];
}
-(void)placeSearchWillShowResult:(MVPlaceSearchTextField*)textField{

}
-(void)placeSearchWillHideResult:(MVPlaceSearchTextField*)textField{
    
}
-(void)placeSearch:(MVPlaceSearchTextField*)textField ResultCell:(UITableViewCell*)cell withPlaceObject:(PlaceObject*)placeObject atIndex:(NSInteger)index{
    cell.contentView.backgroundColor = [UIColor whiteColor];
}

-(void)addPin:(GMSPlace *)place{
    
    [mapView removeAnnotations:mapView.annotations];
    
    CLLocationCoordinate2D coord = place.coordinate;
    NSLog(@"%@",place.name);
    NSLog(@"%@", place.formattedAddress);
    
    MKCoordinateSpan span = MKCoordinateSpanMake(0.01, 0.01);
    MKCoordinateRegion region = {coord, span};
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate:coord];
    [annotation setTitle:place.name];
    [annotation setSubtitle:place.formattedAddress];
    [mapView setRegion:region];
    [mapView addAnnotation:annotation];
}


- (IBAction)btnGalleryClicked:(id)sender
{
    ipc= [[UIImagePickerController alloc] init];
    ipc.delegate = self;
    ipc.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    if(!iPAD)
        [self presentViewController:ipc animated:YES completion:nil];
    else
    {
        ipc.modalPresentationStyle = UIModalPresentationPopover;
        ipc.popoverPresentationController.sourceView = btnGallery;
        [self presentViewController:ipc animated:YES completion:nil];
    }
}

- (IBAction)btnCameraClicked:(id)sender
{
    ipc = [[UIImagePickerController alloc] init];
    ipc.delegate = self;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:ipc animated:YES completion:NULL];
    }
    else
    {
        [self.view makeToast:@"No Camera Available" duration:toastDuration position:toastPositionBottomUp];
    }
}

#pragma mark - ImagePickerController Delegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if(!iPAD) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    } else {
        [popover dismissPopoverAnimated:YES];
    }
    postImageView.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    postImageViewHeight.constant=250;
    [postImageView layoutIfNeeded];
    [self.view layoutIfNeeded];
    
    [postImageView addShaddow];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


# pragma mark  UITextView Delegates
- (void)textViewDidBeginEditing:(UITextView *)textView
{
            if ([textView.text isEqualToString:@"  This place is known for ? How to get it ? Things to do ? Famous things ? etc. "]) {
                textView.text = @"";
                textView.textColor = [UIColor blackColor]; //optional
            }
    [textView becomeFirstResponder];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    [mapView layoutIfNeeded];
    CGPoint windowPoint = [mapView convertPoint:mapView.bounds.origin toView:self.view.window];
    _txtPlaceSearch.autoCompleteTableFrame = CGRectMake(mapView.frame.origin.x, windowPoint.y+15, mapView.frame.size.width, mapView.frame.size.height);
    return YES;
}


- (void)textViewDidEndEditing:(UITextView *)textView
{
             if ([textView.text isEqualToString:@""]) {
                textView.text = @"  This place is known for ? How to get it ? Things to do ? Famous things ? etc. ";
                textView.textColor = [UIColor lightGrayColor];
            }
            [textView resignFirstResponder];
}

#pragma mark ============== Call Webservice ================

-(void)checkValidationsFromForm{
    int pinCount=0;
    for (id<MKAnnotation> annotation in mapView.annotations){
        MKAnnotationView* anView = [mapView viewForAnnotation: annotation];
        if (anView){
                pinCount++;
        }
    }
    if (postImageView.image==nil) {
        [self.view makeToast:@"Please select image" duration:toastDuration position:toastPositionBottomUp];
    }else if(pinCount<=0){
        [self.view makeToast:@"Please select proper location" duration:toastDuration position:toastPositionBottomUp];
    }else if ([descriptionTextView.text isEqualToString:@"  This place is known for ? How to get it ? Things to do ? Famous things ? etc. "]){
        [self.view makeToast:@"Please insert some description about place" duration:toastDuration position:toastPositionBottomUp];
    }else{
        [self.view showLoader];
        [self upload];
    }
}


- (void)upload {
    
    NSString * selectedActivityType=@"";
    
    switch (selectedIndex) {
        case 0:
            selectedActivityType=@"1";
            break;
        case 1:
            selectedActivityType=@"2";
            break;
        case 2:
            selectedActivityType=@"3";
            break;
        case 3:
            selectedActivityType=@"6";
            break;
            
        default:
            break;
    }
    
    NSDictionary *parameters = @{
                                 @"action": ACTION_ADD_ACTIVITY,
                                 @"userId": [UserData getUserID],
                                 @"cityId": [_selectedCityDict valueForKey:@"cityId"],
                                 @"title": _txtPlaceSearch.text,
                                 @"description": descriptionTextView.text,
                                 @"activity_type": selectedActivityType
                                 };
    [[WebHandler sharedHandler]uploadDataWithImage:postImageView.image forKey:@"file1" andParameters:parameters OnUrl:URL_CONST completion:^(NSDictionary * responceDict) {
        if (responceDict) {
            int status =[[responceDict valueForKey:@"status"] intValue];
            if (status == (int)SUCESS) {
                [self.view hideLoader];
                [self.view makeToast:@"Post successfully Posted" duration:toastDuration position:toastPositionBottomUp];
                [self performSelector:@selector(backToCities) withObject:nil afterDelay:2];
            }else{
                [self.view hideLoader];
                 [self.view makeToast:[responceDict valueForKey:@"message"] duration:toastDuration position:toastPositionBottomUp];
            }
        }else{
            [self.view hideLoader];
            [self.view makeToast:no_internet_message duration:toastDuration position:toastPositionBottomUp];
        }
    }];
}
-(void)backToCities{
    [self.navigationController popViewControllerAnimated:YES];
}


@end

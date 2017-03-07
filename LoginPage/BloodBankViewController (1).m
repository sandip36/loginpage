//
//  BloodBankViewController.m
//  Medipta
//
//  Created by medipta on 30/11/16.
//  Copyright © 2016 Mac-02. All rights reserved.
//

#import "BloodBankViewController.h"
#import "BlloodBankTableViewCell.h"
#import "BloodgroupwiseViewController.h"
#import "APIManager.h"
#import "Utility.h"
#include "Constant.h"
#import "DataManager.h"
#import <MessageUI/MessageUI.h>
#import "OtherbloodTableViewCell.h"

@interface BloodBankViewController ()<MFMessageComposeViewControllerDelegate>
{
    NSString *bloodgrouppp;
    BOOL isisbloodgroup;
    BOOL isFilter;
    __weak IBOutlet UILabel *indexone;
    __weak IBOutlet UILabel *indexzero;
    NSMutableArray *arrForSearchbloodbank;
    NSMutableArray *arraforbllod;
    
   // NSMutableArray *lsSearchEmergencyDetails;
    NSMutableDictionary *searchEmergencyDetailsDict;
    UIAlertController *alert;
  NSArray *lsLabelValues;
}
- (IBAction)availableblodgruplistview:(id)sender;
- (IBAction)segmentClick:(id)sender;
@property (nonatomic, strong) NSMutableArray *lsFilteredNames;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constantconstraint;
@property (weak, nonatomic) IBOutlet UISearchBar *searchbarbllodbank;
@property (weak, nonatomic) IBOutlet UISegmentedControl *BloddbankSegment;
@property (weak, nonatomic) IBOutlet UIView *AvialableBloodGroupview;
@property (weak, nonatomic) IBOutlet UITableView *bloodbanktableview;
@end

@implementation BloodBankViewController
- (void)viewDidLoad {
    [super viewDidLoad];
      _AvialableBloodGroupview.hidden=YES;
      self.title = @"Blood Bank";
     _searchbarbllodbank.placeholder = [NSString stringWithFormat:@"Search Blood Bank in %@",[[DataManager sharedInstance]patientLocation]];
    _BloddbankSegment.tintColor=[Utility mediptaBackgroundColor];
    isisbloodgroup=false;
    _lsFilteredNames=[NSMutableArray array];
    self.bloodbanktableview.estimatedRowHeight = 40.0;
    self.bloodbanktableview.rowHeight = UITableViewAutomaticDimension;
    indexone.backgroundColor=[Utility mediptaBackgroundColor];
    indexzero.backgroundColor=[UIColor redColor];
 _searchbarbllodbank.hidden=YES;
    arraforbllod=[NSMutableArray array];
_constantconstraint.constant=2;
    _BloddbankSegment.selectedSegmentIndex=0;
    arrForSearchbloodbank =[NSMutableArray array];
    searchEmergencyDetailsDict=[NSMutableDictionary dictionary];
     lsLabelValues = @[@"A Positive (A+)",@"A Negative (A-)",@"B Positive (B+)",@"B Negative (B-)",@"AB Positive (AB+)",@"AB Negative (AB-)",@"O Positive (O+)",@"O Negative (O-)"];
    [self.bloodbanktableview reloadData];

    }

-(void)viewWillAppear:(BOOL)animated{
         self.navigationItem.title = @"Blood Bank";
}

#pragma mark - TableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{if (isFilter) {
     NSLog(@"%lu",(unsigned long)[_lsFilteredNames count]);
    return [_lsFilteredNames count];
}
 else   if(_BloddbankSegment.selectedSegmentIndex == 1)
    {
        NSLog(@"%lu",(unsigned long)[arrForSearchbloodbank count]);

 //return  0;
    return [arrForSearchbloodbank count];
    }else{
        NSLog(@"%lu",(unsigned long)[lsLabelValues count]);
       return [lsLabelValues count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (isFilter) {
        OtherbloodTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OtherbloodTableViewCell"];
        if (cell == nil) {
            cell = [[OtherbloodTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OtherbloodTableViewCell"];
        }
        cell.contactNameLabel.text=([[_lsFilteredNames [indexPath.row] objectForKey:@"bank_name"]isEqual:[NSNull null]] ? @"-" : [_lsFilteredNames [indexPath.row] objectForKey:@"bank_name"]);
        cell.addressLabel.text=([[_lsFilteredNames [indexPath.row] objectForKey:@"address"]isEqual:[NSNull null]] ? @"-" : [_lsFilteredNames [indexPath.row] objectForKey:@"address"]);
        cell.contactnumber.text=([[_lsFilteredNames [indexPath.row] objectForKey:@"phone"]isEqual:[NSNull null]] ? @"-" : [_lsFilteredNames [indexPath.row] objectForKey:@"phone"]);
        
        [cell.callButton setTag:indexPath.row];
        [cell.callButton addTarget:self action:@selector(clickcall:) forControlEvents:UIControlEventTouchUpInside];
        [cell.messageButton setTag:indexPath.row];
        [cell.messageButton addTarget:self action:@selector(clickmessageInOtherEmergency:) forControlEvents:UIControlEventTouchUpInside];
        return cell;

    }else

        
    if (_BloddbankSegment.selectedSegmentIndex == 1) {
        OtherbloodTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OtherbloodTableViewCell"];
        if (cell == nil) {
            cell = [[OtherbloodTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OtherbloodTableViewCell"];
        }
        cell.contactNameLabel.text=([[arrForSearchbloodbank [indexPath.row] objectForKey:@"bank_name"]isEqual:[NSNull null]] ? @"-" : [arrForSearchbloodbank [indexPath.row] objectForKey:@"bank_name"]);
        cell.addressLabel.text=([[arrForSearchbloodbank [indexPath.row] objectForKey:@"address"]isEqual:[NSNull null]] ? @"-" : [arrForSearchbloodbank [indexPath.row] objectForKey:@"address"]);
        cell.contactnumber.text=([[arrForSearchbloodbank [indexPath.row] objectForKey:@"phone"]isEqual:[NSNull null]] ? @"-" : [arrForSearchbloodbank [indexPath.row] objectForKey:@"phone"]);
        
        [cell.callButton setTag:indexPath.row];
        [cell.callButton addTarget:self action:@selector(clickcall:) forControlEvents:UIControlEventTouchUpInside];
        [cell.messageButton setTag:indexPath.row];
        [cell.messageButton addTarget:self action:@selector(clickmessageInOtherEmergency:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    else{
        BlloodBankTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bloodbankide"];
        if (cell == nil) {
            cell = [[BlloodBankTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bloodbankide"];
        }
       
        cell.contentView.backgroundColor = [UIColor clearColor];
        [cell setBackgroundColor:[UIColor clearColor]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
       // cell.viewforbllodgroup
        [ cell.viewforbllodgroup.layer setCornerRadius:8.0f];
         cell.viewforbllodgroup.layer.borderColor = [UIColor lightGrayColor].CGColor;
         cell.viewforbllodgroup.layer.borderWidth = 2.0f;
        [ cell.viewforbllodgroup.layer setMasksToBounds:YES];
        
     cell.bloodgroupname.text =[lsLabelValues objectAtIndex:indexPath.row];
        cell.bloodgroupname.textColor=[Utility mediptaBackgroundColor];
     
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
        return UITableViewAutomaticDimension;
     }

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (isFilter) {
        
    NSMutableArray * arr=[_lsFilteredNames objectAtIndex:indexPath.row];
         NSLog(@" the array is %@",arr);
        
        NSString *str=[arr valueForKey:@"name"];
        NSDictionary *dict =@{@"name":str};
       [self avialableboodlist:dict];

        
         }
    else if (_BloddbankSegment.selectedSegmentIndex == 0)
    {
            
   NSString* strforselect=[lsLabelValues objectAtIndex:indexPath.row];
    NSLog(@" the array is %@",strforselect);
    [self BloodGroupWiseApi:[lsLabelValues objectAtIndex:indexPath.row]];
   
}
else{
    NSMutableArray * arrforblood=[arrForSearchbloodbank objectAtIndex:indexPath.row];
    NSString *str=[arrforblood valueForKey:@"name"];
    NSDictionary *dict =@{@"name":str};
    [self avialableboodlist:dict];
   
  
}
}

-(void)avialableboodlist:(NSDictionary *)BId
{
    [self showSpinner];
  
[[APIManager new] getavailableBlood :BId withBlock:^(NSString *message, id response) {
         NSLog(@"responce of all bank %@",response);
         if ([message isEqualToString:kSuccess]) {
             [self dismissSpinner];
             if ([response count]>0) {
                 
                 _searchbarbllodbank.hidden=YES;
             _AvialableBloodGroupview.hidden=NO;
                 [ _AvialableBloodGroupview.layer setCornerRadius:8.0f];
                 _AvialableBloodGroupview.layer.borderColor = [UIColor lightGrayColor].CGColor;
                _AvialableBloodGroupview.layer.borderWidth = 2.0f;
                 [ _AvialableBloodGroupview.layer setMasksToBounds:YES];
//             hjdgj
             [arraforbllod removeAllObjects];
             for(NSMutableDictionary *dict in [response objectForKey:@"message"])
             {
                 [arraforbllod addObject:dict];
             }
             NSLog(@"the  value in array %@",[arraforbllod  valueForKey:@"a_pos"]);
             
             self.bloodbanktableview.hidden=YES;
            NSString *ap = [NSString stringWithFormat: @"%@ %@",@"A +ve =",[[arraforbllod  valueForKey:@"a_pos"]objectAtIndex:0]];
             
           
             lblAp.text=ap;
              NSString *an = [NSString stringWithFormat: @"%@ %@",@"A -ve =",[[arraforbllod  valueForKey:@"a_neg"] objectAtIndex:0]];
             lblAN.text=an;
             NSString *Bp = [NSString stringWithFormat: @"%@ %@",@"B +ve =",[[arraforbllod  valueForKey:@"b_pos"]objectAtIndex:0]];
             lblBP.text=Bp;
             NSString *Bn = [NSString stringWithFormat: @"%@ %@",@"B -ve =",[[arraforbllod  valueForKey:@"b_neg"]objectAtIndex:0]];
             lblBN.text=Bn;
             NSString *aBp = [NSString stringWithFormat: @"%@ %@",@"AB +ve =",[[arraforbllod  valueForKey:@"ab_pos"]objectAtIndex:0]];
             lblABP.text=aBp;
             NSString *aBn = [NSString stringWithFormat: @"%@ %@",@"AB -ve =",[[arraforbllod  valueForKey:@"ab_neg"]objectAtIndex:0]];
             lblABN.text=aBn;
             NSString *Op = [NSString stringWithFormat: @"%@ %@",@"O +ve =",[[arraforbllod  valueForKey:@"o_pos"]objectAtIndex:0]];
             lblOP.text=Op;
             NSString *On = [NSString stringWithFormat: @"%@ %@",@"O -ve =",[[arraforbllod  valueForKey:@"o_neg"]objectAtIndex:0]];
             lblON.text=On;
             }else{
                  [Utility displayAlert:kMedipta WithMessage:@"Blood Not Available "];
             }

         }
         else {
             [self dismissSpinner];
             if (![kFailure isEqualToString:message]) {
                 [Utility displayAlert:@"Message" WithMessage:message];
             } else {
                 [self dismissSpinner];
                 [self presentViewController:[Utility showAlertWithTitle:kMedipta andMessage:@"Fetching Error"] animated:YES completion:nil];
             }
         }
     }];
}
    




-(void)BloodGroupWiseApi:(NSString *)blodgroup
{ NSString *bloodgroupp;
    
//    self.navigationItem.title = blodgroup;
    bloodgrouppp=blodgroup;
    if ([blodgroup isEqualToString:@"A Positive (A+)"]) {
        bloodgroupp=@"a_pos";
    }else if ([blodgroup isEqualToString:@"A Negative (A-)"]) {
        bloodgroupp=@"a_neg";
    }else if ([blodgroup isEqualToString:@"B Positive (B+)"]) {
        bloodgroupp=@"b_pos";
    }else if ([blodgroup isEqualToString:@"B Negative (B-)"]) {
        bloodgroupp=@"b_neg";
    }else if ([blodgroup isEqualToString:@"AB Positive (AB+)"]) {
        bloodgroupp=@"ab_pos";
    }else if ([blodgroup isEqualToString:@"AB Negative (AB-)"]) {
        bloodgroupp=@"ab_neg";
    }else if ([blodgroup isEqualToString:@"O Positive (O+)"]) {
        bloodgroupp=@"o_pos";
    }else if ([blodgroup isEqualToString:@"O Negative (O-)"]) {
        bloodgroupp=@"o_neg";
    }
    
    
    
    NSDictionary *dict =@{@"bg_name":bloodgroupp,@"address":[[DataManager sharedInstance] patientLocation]};
    // [_locationBtnView setHidden:true];
    NSLog(@"%@",dict);
    
   
    [self searchbllodbankbybllodgroup:dict];
 

}


-(void)searchbllodbankbybllodgroup:(NSDictionary*)Dict
{
       [self showSpinner];
  
    [[APIManager new] getbloodbankgroupwise:Dict withBlock:^(NSString *message, id response) {
        NSLog(@"responce of all bank %@",response);
        if([response count]>0)
        {
        if ([message isEqualToString:kSuccess]) {
            [self dismissSpinner];
   [self performSegueWithIdentifier:@"BloodgroupwiseViewController" sender:response];
        }
        else {
            [self dismissSpinner];
            if (![kFailure isEqualToString:message]) {
                [Utility displayAlert:@"Message" WithMessage:message];
            } else {
                [self dismissSpinner];
                [self presentViewController:[Utility showAlertWithTitle:kMedipta andMessage:@"Fetching Error"] animated:YES completion:nil];
            }
        }
        }else{
            [Utility displayAlert:@"Message" WithMessage:@" Selected Blood Group Not Available"];
  [self dismissSpinner];
        }
    }];
}



//["a_pos","o_pos","b_pos","ab_pos","a_neg","o_neg","b_neg","ab_neg"]
//
//
//lsLabelValues = @[@"A Positive (A+)",@"A Negative (A-)",@"B Positive (B+)",@"B Negative (B-)",@"AB Positive (AB+)",@"AB Negative (AB-)",@"O Positive (O+)",@"O Negative (O-)"];








#pragma mark - Custom Methods

- (void) clickcall:(UIButton *)sender {
    
    for (int tag = 0; tag < [searchEmergencyDetailsDict count] ; tag++ ) {
        
        if (sender.tag == tag) {
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:kMedipta message:[NSString stringWithFormat:@"Are you sure to make a call to %@?",[[searchEmergencyDetailsDict objectForKey:kMessage][tag]objectForKey:@"phone"]] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",[[searchEmergencyDetailsDict objectForKey:kMessage][tag]objectForKey:@"phone"]]]];
            }];
            
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"CANCEL" style:UIAlertActionStyleDefault handler:nil];
            
            [alertController addAction:ok];
            [alertController addAction:cancel];
            
            [self presentViewController:alertController animated:YES completion:nil];
            break;
        }
    }
}

- (void) clickmessageInOtherEmergency:(UIButton *)sender
{
    for (int tag = 0; tag < [arrForSearchbloodbank count] ; tag++ ) {
        
        if (sender.tag == tag) {
            
            
            if(![MFMessageComposeViewController canSendText]) {
                UIAlertController *warningAlert = [UIAlertController alertControllerWithTitle:kMedipta message:@"Your device doesn't support SMS!" preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:warningAlert animated:YES completion:nil];
                return;
            }
            NSArray *recipents;
//            NSArray *recipents = [NSArray arrayWithObjects:[[searchEmergencyDetailsDict objectForKey:kMessage][tag] objectForKey:@"phone"], nil];
            NSString *message;
            if ([[DataManager sharedInstance] CurrentLatitude] && [[DataManager sharedInstance] CurrentLongitude]) {
                message = [NSString stringWithFormat:@"I am in emergency,Kindly contact me. My current location is (%@ %@).\n %@ %@",[[DataManager sharedInstance] CurrentLatitude],[[DataManager sharedInstance] CurrentLongitude],[[[DataManager sharedInstance] userDefaults] objectForKey:kPrefix],[[[DataManager sharedInstance] userDefaults] objectForKey:kFullName]];
            } else {
                message = [NSString stringWithFormat:@"I am in emergency,Kindly contact me.\n %@ %@",[[[DataManager sharedInstance] userDefaults] objectForKey:kPrefix],[[[DataManager sharedInstance] userDefaults] objectForKey:kFullName]];
            }
            
            MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
            messageController.messageComposeDelegate = self;
            [messageController setRecipients:recipents];
            [messageController setBody:message];
            
            // Present message viewcontroller on screen
            [self presentViewController:messageController animated:YES completion:nil];
            break;
        }
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
 [self dismissViewControllerAnimated:YES completion:nil];

  [self becomeFirstResponder];
}
#pragma mark - Spinner Methods

- (void) showSpinner {
    
    if (([[[UIDevice currentDevice] systemVersion] compare:@"8.0" options:NSNumericSearch] == NSOrderedAscending)) {
    }
    else {
        alert = [Utility showProgress];
        [self.parentViewController presentViewController:alert animated:NO completion:nil];
    }
}

- (void) dismissSpinner {
    
    if (([[[UIDevice currentDevice] systemVersion] compare:@"8.0" options:NSNumericSearch] == NSOrderedAscending)) {
    }
    else {
        [alert dismissViewControllerAnimated:YES completion:nil];    }
}

-(void)searchEmergencyDetails:(NSDictionary*)Dict
{

   [self showSpinner];
    
        [[APIManager new] getAllbllodlocationwise:Dict withBlock:^(NSString *message, id response) {
            NSLog(@"responce of all bank %@",response);
            if ([message isEqualToString:kSuccess]) {
          
           [self dismissSpinner];
            // [searchEmergencyDetailsDict removeAllObjects];
             [arrForSearchbloodbank removeAllObjects];
             for(NSMutableDictionary *dict in [response objectForKey:@"message"])
             {
                 [arrForSearchbloodbank addObject:dict];
             }
             [searchEmergencyDetailsDict setObject:arrForSearchbloodbank forKey:@"message"];
             [self.bloodbanktableview reloadData ];
             
         }
         else {
            [self dismissSpinner];
             if (![kFailure isEqualToString:message]) {
                 [Utility displayAlert:@"Message" WithMessage:message];
             } else {
               [self dismissSpinner];
                 [self presentViewController:[Utility showAlertWithTitle:kMedipta andMessage:@"Fetching Error"] animated:YES completion:nil];
             }
         }
     }];
}

- (IBAction)availableblodgruplistview:(id)sender {
    
     self.bloodbanktableview.hidden=NO;
    _AvialableBloodGroupview.hidden=YES;
     _searchbarbllodbank.hidden=NO;
    
    
}

- (IBAction)segmentClick:(id)sender { NSInteger index = _BloddbankSegment.selectedSegmentIndex;
    if (index == 1) {
         _BloddbankSegment.tintColor=[Utility mediptaBackgroundColor];
        _constantconstraint.constant=45;
        _searchbarbllodbank.hidden=NO;
        //data = {"address":"Pune","name":""}
        NSDictionary *dict =@{@"name":@"",@"address":[[DataManager sharedInstance] patientLocation]};
       // [_locationBtnView setHidden:true];
        self.title = @"Blood Bank";
     indexzero.backgroundColor=[Utility mediptaBackgroundColor];
        indexone.backgroundColor=[UIColor redColor];
        [self searchEmergencyDetails:dict];
        [self.bloodbanktableview reloadData];
    }
    if (index == 0) {
        _constantconstraint.constant=2;
           _searchbarbllodbank.hidden=YES;
     lsLabelValues = @[@"A Positive (A+)",@"A Negative (A-)",@"B Positive (B+)",@"B Negative (B-)",@"AB Positive (AB+)",@"AB Negative (AB-)",@"O Positive (O+)",@"O Negative (O-)"];
          self.title = @"Blood Bank";
        [arrForSearchbloodbank removeAllObjects];
       indexzero.backgroundColor=[UIColor redColor];
       indexone.backgroundColor=[Utility mediptaBackgroundColor];
 _BloddbankSegment.tintColor=[Utility mediptaBackgroundColor];
        [self.bloodbanktableview reloadData];
        
    }

}
-(void)viewDidDisappear:(BOOL)animated{
    self.navigationItem.title=nil;
}
# pragma mark - Search Bar Delegate

- (void) searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
    self.bloodbanktableview.scrollEnabled = YES;
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void) searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if (![searchText isEqualToString:@""]) {
        isFilter = true;
        [_lsFilteredNames removeAllObjects];
        [self searchTextName:searchText];
        
    } else {
        isFilter = false;
        [_lsFilteredNames removeAllObjects];
        [self.bloodbanktableview reloadData];
    }
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}

#pragma mark - Custom Methods

- (void) searchTextName:(NSString *) searchText {
    for(NSMutableDictionary *dict in arrForSearchbloodbank)
    {
        if(![[dict objectForKey:@"bank_name"] isEqual:[NSNull null]])
        {
            NSRange r = [[dict objectForKey:@"bank_name"] rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if(r.length > 0)
            {
                [_lsFilteredNames addObject:dict];
                [self.bloodbanktableview reloadData];
            }
            else{
                [self.bloodbanktableview reloadData];
            }
        }
    }
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"BloodgroupwiseViewController"]) {
        BloodgroupwiseViewController *obj = (BloodgroupwiseViewController *)segue.destinationViewController;
        obj.responce = sender;
          NSLog(@"viewcontroller name %@",bloodgrouppp);
        obj.viewname=bloodgrouppp;
    }
}

@end

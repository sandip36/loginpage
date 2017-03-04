//
//  FirstTableViewController.m
//  LoginPage
//
//  Created by Mac on 03/03/17.
//  Copyright © 2017 Mac. All rights reserved.
//

#import "FirstTableViewController.h"
#import "FirstTableViewCell.h"
#import "Webhandler.h"

@interface FirstTableViewController ()
{
    NSMutableArray *arrForData;
    NSMutableDictionary *dicFordata;
    
    
}
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

@implementation FirstTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self getdata];
   }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}
-(void)getdata
{
     NSDictionary * dict =  [[Webhandler sharedHandler]getDataFromWebservice:@"www.google.com"];
    NSLog(@"%@",dict);
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [arrForData count];    //count number of row from counting array hear cataGorry is An Array
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
        return cell;
}

@end

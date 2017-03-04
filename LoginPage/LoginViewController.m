//
//  LoginViewController.m
//  LoginPage
//
//  Created by Mac on 03/03/17.
//  Copyright © 2017 Mac. All rights reserved.
//

#import "LoginViewController.h"
#import "FirstTableViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated
{
    self.navigationItem.title=@"Login";
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationItem.title=nil;
}


- (IBAction)btnLogin:(id)sender {
    FirstTableViewController *VC=[self.storyboard instantiateViewControllerWithIdentifier:@"FirstTableViewController"];
    [self.navigationController pushViewController:VC animated:YES];
}
@end

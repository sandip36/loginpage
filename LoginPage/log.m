//
//  LoginViewController.m
//  Traveller_ObjC
//
//  Created by Sagar Shirbhate on 07/04/16.
//  Copyright © 2016 Sagar Shirbhate. All rights reserved.
//

#import "LoginViewController.h"
#import "TravellerConstants.h"
#import "HomeViewController.h"
#import "MenuViewController.h"
#import "ForgetPasswordViewController.h"
#import "SignUpViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
#pragma mark====================View Controller Life Cycles===============================

- (void)viewDidLoad {
    [super viewDidLoad];

    //For Intro View
    if ([[UserData checkIntroViewShown]isEqualToString:@"No"]) {
        self.introView = [[ABCIntroView alloc] initWithFrame:self.view.frame];
        self.introView.delegate = self;
        self.introView.backgroundColor = [UIColor colorWithWhite:0.149 alpha:1.000];
        [self.view addSubview:self.introView];
    }
    
    [self setUpView];// To set up View Properly
}

#pragma mark====================Set Up View===============================

-(void)setUpView{
    // Check Whether its lower size or bigger size
    if (iPhone6||iPhone6plus||iPAD) {
        aboveConstraint.constant =100;
        if(iPAD){
            aboveConstraint.constant =200;
        }
        [self.view layoutIfNeeded];
    }
    forgetPasswordBtn.titleLabel.font=[UIFont fontWithName:font_bold size:font_size_button];
    needAnAccountBtn.titleLabel.font=[UIFont fontWithName:font_bold size:font_size_button];
    usernameLogo.font=[UIFont fontWithName:fontIcomoon size:logo_Size_Small];
    passwordLogo.font=[UIFont fontWithName:fontIcomoon size:logo_Size_Small];
    showHidePasswordBtn.titleLabel.font=[UIFont fontWithName:fontIcomoon size:logo_Size_Small];
    loginButton.titleLabel.font=[UIFont fontWithName:font_button size:font_size_button];
    orLbl.font=[UIFont fontWithName:font_bold size:font_size_bold];
    googleBtn.titleLabel.font=[UIFont fontWithName:fontIcomoon size:50];
    faceBookButton.titleLabel.font=[UIFont fontWithName:fontIcomoon size:50];
    usernameLogo.text =[NSString stringWithUTF8String:ICOMOON_USER];
    passwordLogo.text =[NSString stringWithUTF8String:ICOMOON_KEY];
    [showHidePasswordBtn setTitle:[NSString stringWithUTF8String:ICOMOON_EYE_CLOSED] forState:UIControlStateNormal];
    [googleBtn setTitle:[NSString stringWithUTF8String:ICOMOON_GOOGLE] forState:UIControlStateNormal];
    [faceBookButton setTitle:[NSString stringWithUTF8String:ICOMOON_FACEBOOK] forState:UIControlStateNormal];
    [userNameTextField setLeftPadding:leftPadding];
    [passwordTextField setLeftPadding:leftPadding];
     [passwordTextField setRightPadding:leftPadding];
    [loginButton addBlackLayerAndCornerRadius:cornerRadius_Button AndWidth:borderWidth_Button];
    [loginButton addShaddow];
    [userNameTextField addRegx:@"^.{3,30}$" withMsg:@"User name charaters limit should be come between 3-30"];
    [passwordTextField addRegx:@"[A-Za-z0-9]{6,20}" withMsg:@"Password must be alpha numeric"];
    
}


#pragma mark====================Login With Facebook===============================

- (IBAction)facebookClick:(id)sender {
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login
     logInWithReadPermissions: @[@"email"]
     fromViewController:self
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
             NSLog(@"Process error");
         } else if (result.isCancelled) {
             NSLog(@"Cancelled");
         } else {
             NSLog(@"Logged in");
             [self getUserInformation];
         }
     }];
}

-(void)getUserInformation
{
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me"
                                       parameters:@{@"fields": @"picture,email,first_name,last_name,location,birthday"}]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, NSDictionary *result, NSError *error) {
         if (!error) {
             NSDictionary * dict = @{
                                     @"name":[NSString stringWithFormat:@"%@ %@",[result valueForKey:@"first_name"],[result valueForKey:@"last_name"]],
                                      @"fb_id":[result valueForKey:@"id"],
                                        @"email":[result valueForKey:@"email"]
                                     };
             [self loginForFacebook:dict];
         }
         else
         {
             NSLog(@"Failed to get Data: %@", [error localizedDescription]);
         }
     }];
}
// its in developement phase
-(void)loginForFacebook:(NSDictionary*)FBDict{
    NSString * name=[FBDict valueForKey:@"name"];
    NSString * email=[FBDict valueForKey:@"email"];
    NSString * fb_id=[FBDict valueForKey:@"fb_id"];
    NSString * str =[NSString stringWithFormat:@"%@name=%@&email=%@&password=&mobile=&city=&country=&state=&action=%@&signupType=facebook&fb_id=%@",URL_CONST,name,email,fb_id,ACTION_SIGNUP];
    NSDictionary * dict = [[WebHandler sharedHandler]getDataFromWebservice:str];
    if (dict!=nil) {
        NSNumber *status = [NSNumber numberWithInteger:[[dict valueForKey:@"status"] intValue] ] ;
        if ( [status isEqual: SUCESS]) {
            [self performSelectorOnMainThread:@selector(loginSuccessful) withObject:nil waitUntilDone:YES];
        }else{
            NSString * msg =[dict valueForKey:@"message"];
            [self performSelectorOnMainThread:@selector(showToastWithMessage:) withObject:msg waitUntilDone:YES];
        }
    }else{
        [self performSelectorOnMainThread:@selector(showToastWithMessage:) withObject:no_internet_message waitUntilDone:YES];
    }
}

#pragma mark====================Login With Google===============================

- (IBAction)googleClick:(id)sender {
    [GPPSignIn sharedInstance].clientID = @"748214312326-57qjoec3g5762tlcktag90cha9ngj6be.apps.googleusercontent.com";
    [GPPSignIn sharedInstance].scopes= [NSArray arrayWithObjects:kGTLAuthScopePlusLogin, nil];
    [GPPSignIn sharedInstance].shouldFetchGoogleUserID=YES;
    [GPPSignIn sharedInstance].shouldFetchGoogleUserEmail=YES;
    [GPPSignIn sharedInstance].shouldFetchGooglePlusUser = YES;
    [[GPPSignIn sharedInstance] authenticate];
}

- (void)finishedWithAuth: (GTMOAuth2Authentication *)auth
                   error: (NSError *) error {
    NSLog(@"Received error %@ and auth object %@",error, auth);
    if (error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Error: %@", [error localizedDescription]);
            
        });
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            GTLQueryPlus *query = [GTLQueryPlus queryForPeopleGetWithUserId:@"me"];
            NSLog(@"email %@ ", [NSString stringWithFormat:@"Email: %@",[GPPSignIn sharedInstance].authentication.userEmail]);
            NSLog(@"Received error %@ and auth object %@",error, auth);
            GTLServicePlus* plusService = [[GTLServicePlus alloc] init] ;
            plusService.retryEnabled = YES;
            [plusService setAuthorizer:[GPPSignIn sharedInstance].authentication];
            plusService.apiVersion = @"v1";
            [plusService executeQuery:query
                    completionHandler:^(GTLServiceTicket *ticket,
                                        GTLPlusPerson *person,
                                        NSError *error) {
                        if (error) {
                            
                        } else {
                            
                            NSDictionary *dictOfData = [NSDictionary dictionaryWithObjectsAndKeys:[GPPSignIn sharedInstance].authentication.userEmail,@"email",person.image.url,@"image",person.displayName,@"username",@"",@"DOB",@"",@"place",@"",@"mobile", nil];
                            [self performSelectorOnMainThread:@selector(loginForGoogle:) withObject:dictOfData waitUntilDone:YES];
                        }
                    }];
            
        });
        
        
    }
}

-(void)loginForGoogle:(NSDictionary*)googleDict{
    NSString * name=[googleDict valueForKey:@"name"];
    NSString * email=[googleDict valueForKey:@"email"];
    NSString * fb_id=[googleDict valueForKey:@"fb_id"];
    NSString * str =[NSString stringWithFormat:@"%@name=%@&email=%@&password=&mobile=&city=&country=&state=&action=%@&signupType=facebook&fb_id=%@",URL_CONST,name,email,fb_id,ACTION_SIGNUP];
    NSDictionary * dict = [[WebHandler sharedHandler]getDataFromWebservice:str];
    if (dict!=nil) {
        NSNumber *status = [NSNumber numberWithInteger:[[dict valueForKey:@"status"] intValue] ] ;
        if ( [status isEqual: SUCESS]) {
            [self performSelectorOnMainThread:@selector(loginSuccessful) withObject:nil waitUntilDone:YES];
        }else{
            NSString * msg =[dict valueForKey:@"message"];
            [self performSelectorOnMainThread:@selector(showToastWithMessage:) withObject:msg waitUntilDone:YES];
        }
    }else{
        [self performSelectorOnMainThread:@selector(showToastWithMessage:) withObject:no_internet_message waitUntilDone:YES];
    }
}

#pragma mark====================Login With Email===============================
- (IBAction)loginClick:(id)sender {
    

    
#if DEBUG
    userNameTextField.text=@"satishsolan7@gmail.com";
    passwordTextField.text=@"234";

    
   // if ([userNameTextField validate]&&[passwordTextField validate]) {
            [self.view showLoader];
           [self performSelectorInBackground:@selector(callLoginWebservice) withObject:nil];
//    }
  #endif
 
}

-(void)callLoginWebservice{
    NSString * str =[NSString stringWithFormat:@"%@email=%@&password=%@&action=%@",URL_CONST,userNameTextField.text,passwordTextField.text,ACTION_LOGIN];
    NSDictionary * dict = [[WebHandler sharedHandler]getDataFromWebservice:str];
    if (dict!=nil) {
        NSNumber *status = [NSNumber numberWithInteger:[[dict valueForKey:@"status"] intValue] ] ;
        if ( [status isEqual: SUCESS]) {
            [UserData saveUserDict:dict];
            [self performSelectorOnMainThread:@selector(loginSuccessful) withObject:nil waitUntilDone:YES];
        }else{
            NSString * msg =[dict valueForKey:@"message"];
            [self performSelectorOnMainThread:@selector(showToastWithMessage:) withObject:msg waitUntilDone:YES];
        }
    }else{
        [self performSelectorOnMainThread:@selector(showToastWithMessage:) withObject:no_internet_message waitUntilDone:YES];
    }
}

#pragma mark====================Open Home Page===============================
-(void)loginSuccessful{
      [JTProgressHUD hide];
    JASidePanelController * vc = [[JASidePanelController alloc] init];
    vc.leftPanel = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuViewController"];
    HomeViewController * homeVc = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
    AppDelegate *d = [[UIApplication sharedApplication] delegate];
    d.drawerView=vc;
    d.drawerView.panningLimitedToTopViewController=NO;
    d.drawerView.recognizesPanGesture=NO;
    d.drawerView.leftFixedWidth=self.view.frame.size.width/1.5;
    
    vc.centerPanel = [[UINavigationController alloc] initWithRootViewController:homeVc];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark====================Show Hide Password===============================

- (IBAction)showHidePasswordClick:(id)sender {
    if( passwordTextField.secureTextEntry==YES){
        passwordTextField.secureTextEntry=NO;
            [showHidePasswordBtn setTitle:[NSString stringWithUTF8String:ICOMOON_EYE] forState:UIControlStateNormal];
    }else{
        passwordTextField.secureTextEntry=YES;
            [showHidePasswordBtn setTitle:[NSString stringWithUTF8String:ICOMOON_EYE_CLOSED] forState:UIControlStateNormal];
    }
}


#pragma mark====================Forget Password Click===============================

- (IBAction)forgetClick:(id)sender {
    
    ForgetPasswordViewController *newVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ForgetPasswordViewController"];
    [self setPresentationStyleForSelfController:self presentingController:newVC];
    [self presentViewController:newVC animated:YES completion:nil];

}

- (void)setPresentationStyleForSelfController:(UIViewController *)selfController presentingController:(UIViewController *)presentingController
{
    presentingController.providesPresentationContextTransitionStyle = YES;
    presentingController.definesPresentationContext = YES;
    [presentingController setModalPresentationStyle:UIModalPresentationOverCurrentContext];
}

#pragma mark====================SinUp Click===============================

- (IBAction)signUpClick:(id)sender {
    SignUpViewController * vc =[self.storyboard instantiateViewControllerWithIdentifier:@"SignUpViewController"];
    [self.navigationController pushViewController:vc animated:YES];
    
}




#pragma mark - ABCIntroViewDelegate Methods

-(void)onDoneButtonPressed{
    [UserData setIntroShown];
    [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.introView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.introView removeFromSuperview];
    }];
}


-(void)showToastWithMessage:(NSString *)msg{
     [self.view hideLoader];
    [self.view makeToast:msg duration:toastDuration position:toastPositionBottomUp];
}




@end

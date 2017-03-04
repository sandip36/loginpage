//
//  Webhandler.m
//  LoginPage
//
//  Created by Mac on 03/03/17.
//  Copyright © 2017 Mac. All rights reserved.
//

#import "Webhandler.h"


@implementation Webhandler

+(id)sharedHandler
{
    static dispatch_once_t tokan;
    static id sharedobject;
    dispatch_once(&tokan,^{
        sharedobject=[[self alloc]init];
    });
    return sharedobject;
    
    
}
-(NSDictionary *)getDataFromWebservice:(NSString *)urlString{
     urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
        NSURL * url =[NSURL URLWithString:urlString];
        if (url==nil) {
            return nil;
        }
        NSData * data = [NSData dataWithContentsOfURL:url];
        NSError *e = nil;
        if (data!=nil) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &e];
            return dict;
        }else{
            return nil;
        }
    
}
@end

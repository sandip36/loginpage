//
//  Webhandler.h
//  LoginPage
//
//  Created by Mac on 03/03/17.
//  Copyright © 2017 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Webhandler : NSObject
+(id)sharedHandler;
-(NSDictionary *)getDataFromWebservice:(NSString *)urlString;
@end

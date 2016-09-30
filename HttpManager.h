//
//  HttpManager.h
//  Bot
//
//  Created by tiny on 16/9/27.
//  Copyright © 2016年 tiny. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TRRTuringAPIConfig.h"
#import "TRRTuringRequestManager.h"

typedef void(^HttpManagerSucccess)(NSString *string);
typedef void(^HttpManagerFailed)(NSString *string);

#define TuringAPIKey @"8ff886661b0f4bc38c80c02fe4530273"

@interface HttpManager : NSObject
@property (nonatomic,strong)TRRTuringAPIConfig *apiConfig;
@property (nonatomic,strong)TRRTuringRequestManager *apiRequest;
+ (HttpManager *)manager;
- (void)requestInfoWithText:(NSString *)text withSuccess:(HttpManagerSucccess)success withFailed:(HttpManagerFailed)failed;

@end

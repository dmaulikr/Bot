//
//  HttpManager.m
//  Bot
//
//  Created by tiny on 16/9/27.
//  Copyright © 2016年 tiny. All rights reserved.
//

#import "HttpManager.h"

static HttpManager *manager = nil;

@implementation HttpManager

+ (HttpManager *)manager {
    if(!manager) {
        manager = [[super alloc] init];
    }
    return manager;
}

- (TRRTuringAPIConfig *)apiConfig {
    if(!_apiConfig) {
        _apiConfig = [[TRRTuringAPIConfig alloc] initWithAPIKey:TuringAPIKey];
        
    }
    return _apiConfig;
}

- (TRRTuringRequestManager *)apiRequest {
    if(!_apiRequest) {
        _apiRequest = [[TRRTuringRequestManager alloc] initWithConfig:self.apiConfig];
    }
    return _apiRequest;
}

- (void)requestInfoWithText:(NSString *)text withSuccess:(HttpManagerSucccess)success withFailed:(HttpManagerFailed)failed{
    
    [self.apiConfig request_UserIDwithSuccessBlock:^(NSString *str) {

        [self.apiRequest request_OpenAPIWithInfo:text successBlock:^(NSDictionary *dict) {

            NSString *str = dict[@"text"];
            success(str);
        } failBlock:^(TRRAPIErrorType errorType, NSString *infoStr) {
            
            failed(infoStr);
        }];
    }
                                    failBlock:^(TRRAPIErrorType errorType, NSString *infoStr) {
                                        
                                        failed(infoStr);
                                    }];
}

@end

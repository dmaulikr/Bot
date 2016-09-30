//
//  MessageModel.h
//  Bot
//
//  Created by tiny on 16/9/28.
//  Copyright © 2016年 tiny. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    messageType_self = 1,
    messageType_Other
}MessageType;

@interface MessageModel : NSObject
@property(nonatomic,strong)NSString *message;
@property(nonatomic,assign)MessageType messageType;
@end

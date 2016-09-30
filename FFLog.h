//
//  FFLog.h
//  FFLog
//
//  Created by tiny on 16/9/28.
//  Copyright © 2016年 tiny. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FFLog : NSObject

typedef enum
{
    FF_LOG_LEVEL_DEBUG,
    FF_LOG_LEVEL_INFO,
    FF_LOG_LEVEL_WARNING,
    FF_LOG_LEVEL_ERROR,
    
}FF_LOG_LEVEL_E;

typedef enum
{
    FF_LOG_OUTPUT_CONSOLE,
    FF_LOG_OUTPUT_FILE,
}FF_LOG_OUTPUT_E;


// 请优先使用下面的宏进行日志相关操作
#ifndef SETLOGPARAM
#define SETLOGPARAM(LOGLEVEL, OUTPUT)\
{\
[FFLog setLogParam:LOGLEVEL output:OUTPUT];\
}
#endif

#ifndef DEBUGLOG
#define DEBUGLOG(...) \
{\
[FFLog debug:[NSString stringWithUTF8String:__FUNCTION__] line:__LINE__ format:__VA_ARGS__];\
}
#endif

#ifndef INFOLOG
#define INFOLOG(...) \
{\
[FFLog info:[NSString stringWithUTF8String:__FUNCTION__] line:__LINE__ format:__VA_ARGS__];\
}
#endif

#ifndef WARNINGLOG
#define WARNINGLOG(...) \
{\
[   FFLog warning:[NSString stringWithUTF8String:__FUNCTION__] line:__LINE__ format:__VA_ARGS__];\
}
#endif

#ifndef ERRORLOG
#define ERRORLOG(...) \
{\
[FFLog error:[NSString stringWithUTF8String:__FUNCTION__] line:__LINE__ format:__VA_ARGS__];\
}
#endif

/**
 * @function:设置全局默认输出日志级别
 * @param logLevel 日志级别 output 输出位置
 * @return 成功 TRUE 失败 FALSE
 * @description:
 **/
+ (NSInteger) setLogParam:(FF_LOG_LEVEL_E)logLevel output:(FF_LOG_OUTPUT_E)output;
/**
 * @function:打印debug级别日志
 * @param moduleTag 模块标志 logEnable 是否允许输出 function 日志所在函数 line 日志所在行数 format 打印字符串
 * @return
 * @description:
 **/
+ (void) debug:(NSString*)function line:(NSInteger)line format:(NSString*)format, ...;

/**
 * @function:打印info级别日志
 * @param moduleTag 模块标志 logEnable 是否允许输出 function 日志所在函数 line 日志所在行数 format 打印字符串
 * @return
 * @description:
 **/
+ (void) info:(NSString*)function line:(NSInteger)line format:(NSString*)format, ...;

/**
 * @function:打印warning级别日志
 * @param moduleTag 模块标志 logEnable 是否允许输出 function 日志所在函数 line 日志所在行数 format 打印字符串
 * @return
 * @description:
 **/
+ (void) warning:(NSString*)function line:(NSInteger)line format:(NSString*)format, ...;

/**
 * @function:打印error级别日志
 * @param moduleTag 模块标志 logEnable 是否允许输出 function 日志所在函数 line 日志所在行数 format 打印字符串
 * @return
 * @description:
 **/
+ (void) error:(NSString*)function line:(NSInteger)line format:(NSString*)format, ...;

/**
 * @function:获取最近打印的日志信息，如果需要获取全部日志可以设置maxLen 为 -1
 * @param maxLen 输出的最大日志字节数，如果maxLen 超过日志总长度则输出全部日志
 * @return 日志字符串
 * @description:
 **/
+ (NSString*)getRecentlyLog:(NSInteger)maxLen;

+ (void)redirectNSlogToDocumentFolder;

@end


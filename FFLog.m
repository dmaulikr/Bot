//
//  FFLog.m
//  FFLog
//
//  Created by tiny on 16/9/28.
//  Copyright © 2016年 tiny. All rights reserved.
//

#import "FFLog.h"

@implementation FFLog

static FF_LOG_LEVEL_E glocalLogLevel = FF_LOG_LEVEL_DEBUG;
static FF_LOG_OUTPUT_E glbalOutput = FF_LOG_OUTPUT_CONSOLE;

static NSString *logFilePath;


#define LOG_PRINT(logLevel, logLevelStr, function, line, format, ...) \
{\
if (glocalLogLevel <= logLevel) \
{\
va_list argList;\
va_start(argList, format);\
NSString *formatStr = [[NSString alloc] initWithFormat:format arguments:argList];\
va_end(argList);\
NSString *logStr = [NSString stringWithFormat:@"%@|%@|%ld|%@", logLevelStr, function, line,formatStr];\
NSLog(@"%@", logStr);\
NSDate *currentDate = [NSDate date];\
if (glbalOutput == FF_LOG_OUTPUT_FILE)\
{\
logStr = [NSString stringWithFormat:@"%@|%@|%@|%ld|%@", currentDate, logLevelStr, function, line, formatStr];\
}\
}\
}

//if (fileStream)\
//{\
//    [fileStream write:(const uint8_t *)[logStr cStringUsingEncoding:NSUTF8StringEncoding] maxLength:[logStr lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];\
//    [fileStream write:(const uint8_t *)"\n" maxLength:1];\
//}\

static void handleUncaughtException(NSException *exception)
{
    NSString* exceptionName = [exception name];
    NSString* exceptionReason = [exception reason];
    NSArray* symbols = [exception callStackSymbols];
    NSMutableString *strSymbols = [[NSMutableString alloc]init];
    for (NSString*item in symbols)
    {
        [strSymbols appendString:item];
        [strSymbols appendString:@"\r\n"];
    }
    // 打印到console或日志
    [FFLog error:[NSString stringWithUTF8String:__FUNCTION__] line:__LINE__ format:@"Exception%@ %@", exceptionName, exceptionReason];
    [FFLog error:[NSString stringWithUTF8String:__FUNCTION__] line:__LINE__ format:@"Exception%@", strSymbols];
    // 可以参考网商代吗 将log上传到网络
}

+ (NSString*)getRecentlyLog:(NSInteger)maxLen;
{
    if(!logFilePath)
    {
        logFilePath = [FFLog getLogFilePath];
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSFileHandle *fileHandle;
    if([fileManager fileExistsAtPath:logFilePath isDirectory:false])
    {
        fileHandle = [NSFileHandle fileHandleForReadingAtPath:logFilePath];
        [fileHandle seekToEndOfFile];
        long long fileSize  = [fileHandle offsetInFile];
        if(maxLen > 0 && fileSize > maxLen)
        {
            [fileHandle seekToFileOffset:fileSize - maxLen];
        }
        else
        {
            [fileHandle seekToFileOffset:0];
        }
        NSData *data = [fileHandle readDataToEndOfFile];
        [fileHandle closeFile];
        fileHandle = nil;
        NSString *logStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        return logStr;
    }
    else
    {
        return nil;
    }
}

+ (NSString*)getLogFilePath
{
    return [NSTemporaryDirectory() stringByAppendingPathComponent:@"HNABimLogs.log"];
}
/**
 * @function:设置全局默认输出日志级别
 * @param logLevel 日志级别 output 输出位置
 * @return 成功 TRUE 失败 FALSE
 * @description:
 **/
+ (NSInteger) setLogParam:(FF_LOG_LEVEL_E)logLevel output:(FF_LOG_OUTPUT_E)output
{
    if (logLevel > FF_LOG_LEVEL_ERROR || logLevel < FF_LOG_LEVEL_DEBUG
        || output < FF_LOG_OUTPUT_CONSOLE || output > FF_LOG_OUTPUT_FILE)
    {
        return -1;
    }
    
    @synchronized(self)
    {
        glocalLogLevel = logLevel;
        glbalOutput = output;
        if (output == FF_LOG_OUTPUT_FILE)
        {
            [self redirectNSlogToDocumentFolder];
        }
        else
        {
            
        }
        // 设置系统异常捕获函数
        NSSetUncaughtExceptionHandler(handleUncaughtException);
    }
    return 0;
}

/**
 * @function:打印debug级别日志
 * @param moduleTag 模块标志 format 打印字符串
 * @return
 * @description:
 **/
+ (void) debug:(NSString*)function line:(NSInteger)line format:(NSString*)format, ...
{
    LOG_PRINT(FF_LOG_LEVEL_DEBUG, @"debug", function, (long)line, format, ...);
}

/**
 * @function:打印info级别日志
 * @param moduleTag 模块标志 format 打印字符串
 * @return
 * @description:
 **/
+ (void) info:(NSString*)function line:(NSInteger)line format:(NSString*)format, ...
{
    LOG_PRINT(FF_LOG_LEVEL_INFO,  @"info", function, (long)line, format, ...);
}

/**
 * @function:打印warning级别日志
 * @param moduleTag 模块标志 format 打印字符串
 * @return
 * @description:
 **/
+ (void) warning:(NSString*)function line:(NSInteger)line format:(NSString*)format, ...
{
    LOG_PRINT(FF_LOG_LEVEL_WARNING,  @"warning", function, (long)line, format, ...);
}

/**
 * @function:打印error级别日志
 * @param moduleTag 模块标志 format 打印字符串
 * @return
 * @description:
 **/
+ (void) error:(NSString*)function line:(NSInteger)line format:(NSString*)format, ...
{
    LOG_PRINT(FF_LOG_LEVEL_ERROR,  @"error", function, (long)line, format, ...);
}

+ (void)redirectNSlogToDocumentFolder
{
    NSString *logFilePath = [self getLogFilePath];
    // 将log输入到文件
    // 输出 print
    freopen([logFilePath cStringUsingEncoding:NSUTF8StringEncoding], "a+", stdout);
    // 输出 nslog
    freopen([logFilePath cStringUsingEncoding:NSUTF8StringEncoding], "a+", stderr);
}

@end


# CocoaLumberjack

[CocoaLumberjack](https://github.com/CocoaLumberjack/CocoaLumberjack/tree/master)是一个非常经典的日志库，非常有学习的意义

比如，使用`DDLogVerbose`来输出log，其最后调用的是DDLog中的方法，如：

```c
#define DDLogVerbose(frmt, ...) LOG_MAYBE(LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, DDLogFlagVerbose, 0, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)

#define LOG_MAYBE(async, lvl, flg, ctx, tag, fnct, frmt, ...) \
        do { if((lvl & flg) != 0) LOG_MACRO(async, lvl, flg, ctx, tag, fnct, frmt, ##__VA_ARGS__); } while(0)
        
#define LOG_MACRO(isAsynchronous, lvl, flg, ctx, atag, fnct, frmt, ...) \
        [DDLog log : isAsynchronous                                     \
             level : lvl                                                \
              flag : flg                                                \
           context : ctx                                                \
              file : __FILE__                                           \
          function : fnct                                               \
              line : __LINE__                                           \
               tag : atag                                               \
            format : (frmt), ## __VA_ARGS__]        
```

> **打印log非常有用的宏**
>
> + `__PRETTY_FUNCTION__` or `__FUNCTION__`
> + `__LINE__`
> + `__FILE__`
> + `##__VA_ARGS__`



最终会，创建`DDLogMessage`对象，然后加入到queue中，如下：

```objective-c
- (void)log:(BOOL)asynchronous
      level:(DDLogLevel)level
       flag:(DDLogFlag)flag
    context:(NSInteger)context
       file:(const char *)file
   function:(const char *)function
       line:(NSUInteger)line
        tag:(id)tag
     format:(NSString *)format
       args:(va_list)args {
    if (format) {
        // Nullity checks are handled by -initWithMessage:
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnullable-to-nonnull-conversion"
        DDLogMessage *logMessage = [[DDLogMessage alloc] initWithFormat:format
                                                                   args:args
                                                                  level:level
                                                                   flag:flag
                                                                context:context
                                                                   file:@(file)
                                                               function:@(function)
                                                                   line:line
                                                                    tag:tag
                                                                options:(DDLogMessageOptions)0
                                                              timestamp:nil];
#pragma clang diagnostic pop

        [self queueLogMessage:logMessage asynchronously:asynchronous];
    }
}
```
















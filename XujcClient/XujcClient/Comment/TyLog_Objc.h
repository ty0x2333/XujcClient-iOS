/**
 * @file TyLog_Objc.h
 * @brief TyLog For Objc
 *     You can get more help through the following way:
 *     1. My WebSite: http://tianyiyan.com
 *     2. Git@OSC: http://git.oschina.net/luckytianyiyan/TyyClassLibrary
 * @author luckytianyiyan@gmail.com
 * @version 1.0
 * @date 2015-8-24
 */

#pragma mark - Settings

/**
 * @brief 是否开启 XcodeColors 支持
 * @pre  Xcode 需要安装 XcodeColors 插件.
 *        你可以在这里获取它: https://github.com/robbiehanson/XcodeColors
 */
#ifndef LOG_COLORS_ENABLE
    #define LOG_COLORS_ENABLE 1
#endif
/**
 * @brief 默认打印等级
 */
#ifndef LOG_LEVEL
    #define LOG_LEVEL LOG_LEVEL_DEBUG
#endif


#pragma mark - Log Levels

/**
 * @brief  Log Levels
 *
 *  LOG_LEVEL_DEBUG > LOG_LEVEL_INFO > LOG_LEVEL_WARN > LOG_LEVEL_CRITICAL > LOG_LEVEL_FATAL
 *
 *      TyLogDebug  >   TyLogInfo    >  TyLogWarning  >    TyLogCritical   > TyLogFatal
 *
 * @{
 */

#define LOG_FLAG_FATAL      (1 << 0)  // 0...00001
#define LOG_FLAG_CRITICAL   (1 << 1)  // 0...00010
#define LOG_FLAG_WARN       (1 << 2)  // 0...00100
#define LOG_FLAG_INFO       (1 << 3)  // 0...01000
#define LOG_FLAG_DEBUG      (1 << 4)  // 0...10000

#define LOG_LEVEL_NO        0
#define LOG_LEVEL_FATAL     (LOG_FLAG_FATAL)                          // 0...00001
#define LOG_LEVEL_CRITICAL  (LOG_FLAG_CRITICAL  | LOG_LEVEL_FATAL   ) // 0...00011
#define LOG_LEVEL_WARN      (LOG_FLAG_WARN      | LOG_LEVEL_CRITICAL) // 0...00111
#define LOG_LEVEL_INFO      (LOG_FLAG_INFO      | LOG_LEVEL_WARN    ) // 0...01111
#define LOG_LEVEL_DEBUG     (LOG_FLAG_DEBUG     | LOG_LEVEL_INFO    ) // 0...11111

#define LOG_FATAL       (LOG_LEVEL & LOG_FLAG_FATAL     )
#define LOG_CRITICAL    (LOG_LEVEL & LOG_FLAG_CRITICAL  )
#define LOG_WARN        (LOG_LEVEL & LOG_FLAG_WARN      )
#define LOG_INFO        (LOG_LEVEL & LOG_FLAG_INFO      )
#define LOG_DEBUG       (LOG_LEVEL & LOG_FLAG_DEBUG     )

/** @} */

#pragma mark - XcodeColors

#if LOG_COLORS_ENABLE
    /**
    * @brief  XcodeColors
    *
    *  How to apply color formatting to your log statements:
    *
    *  To set the foreground color:
    *  Insert the ESCAPE into your string, followed by "fg124,12,255;" where r=124, g=12, b=255.
    *
    *  To set the background color:
    *  Insert the ESCAPE into your string, followed by "bg12,24,36;" where r=12, g=24, b=36.
    *
    *  To reset the foreground color (to default value):
    *  Insert the ESCAPE into your string, followed by "fg;"
    *
    *  To reset the background color (to default value):
    *  Insert the ESCAPE into your string, followed by "bg;"
    *
    *  To reset the foreground and background color (to default values) in one operation:
    *  Insert the ESCAPE into your string, followed by ";"
    * @{
    */
    #define XCODE_COLORS_ESCAPE @"\033["

    #define XCODE_COLORS_RESET_FG  XCODE_COLORS_ESCAPE @"fg;" // Clear any foreground color
    #define XCODE_COLORS_RESET_BG  XCODE_COLORS_ESCAPE @"bg;" // Clear any background color
    #define XCODE_COLORS_RESET     XCODE_COLORS_ESCAPE @";"   // Clear any foreground or background color

    #define COLOR_DEBUG @"fg209,57,168;"
    #define COLOR_INFO @"fg0,0,0;"
    #define COLOR_WARN @"fg170,85,0;"
    #define COLOR_CRITICAL @"fg220,0,0;"
    #define COLOR_FATAL @"fg255,0,0;"

#else

    #define XCODE_COLORS_ESCAPE

    #define XCODE_COLORS_RESET_FG
    #define XCODE_COLORS_RESET_BG
    #define XCODE_COLORS_RESET

    #define COLOR_DEBUG
    #define COLOR_INFO
    #define COLOR_WARN
    #define COLOR_CRITICAL
    #define COLOR_FATAL

#endif
/** @} */

#pragma mark - Logs
/**
 * @brief  Logs
 *
 * 1. TyLogDebug
 *      用于输出 Debug 信息
 * 2. TyLogInfo
 *      用于输出 可能需要注意的处理过程 信息
 * 3. TyLogWarning
 *      用于输出 警告 信息, 用于 **主动防御时捕获到非法值, 将其设为默认** 的时候输出提醒.
 * 4. TyLogCritical
 *      用于输出 错误 信息
 * 5. TyLogFatal
 *      用于输出 严重错误 信息
 * @{
 */

#define TyLogBase(prefix, color, fmt, ...) NSLog(XCODE_COLORS_ESCAPE color prefix fmt XCODE_COLORS_RESET, ##__VA_ARGS__)

#define TyLogDetail(prefix, color, fmt, ...) NSLog(XCODE_COLORS_ESCAPE color prefix "<%@ (%d)> " fmt XCODE_COLORS_RESET, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, ##__VA_ARGS__)

#define TyLog TyLogDetail

#if LOG_DEBUG
    #define TyLogDebug(fmt, ...) TyLog(@"[D] ", COLOR_DEBUG, fmt, ##__VA_ARGS__)
#else
    #define TyLogDebug(fmt, ...)
#endif

#if LOG_INFO
    #define TyLogInfo(fmt, ...) TyLog(@"[I] ", COLOR_INFO, fmt, ##__VA_ARGS__)
#else
    #define TyLogInfo(fmt, ...)
#endif

#if LOG_WARN
    #define TyLogWarning(fmt, ...) TyLog(@"[W] ", COLOR_WARN, fmt, ##__VA_ARGS__)
#else
    #define TyLogWarning(fmt, ...)
#endif

#if LOG_CRITICAL
    #define TyLogCritical(fmt, ...) TyLog(@"[C] ", COLOR_CRITICAL, fmt, ##__VA_ARGS__)
#else
    #define TyLogCritical(fmt, ...)
#endif

#if LOG_FATAL
    #define TyLogFatal(fmt, ...) TyLog(@"[F] ", COLOR_FATAL, fmt, ##__VA_ARGS__)
#else
    #define TyLogFatal(fmt, ...)
#endif

/** @} */

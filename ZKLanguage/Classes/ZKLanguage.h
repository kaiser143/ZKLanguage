//
//  ZKLanguage.h
//  FBSnapshotTestCase
//
//  Created by Kaiser on 2018/12/23.
//

#import <Foundation/Foundation.h>

#define ZKLocalization(key) [[ZKLanguage sharedInstance] stringWithKey:(key)]

FOUNDATION_EXTERN NSNotificationName const ZKLanguageDidChangedNotification;

NS_ASSUME_NONNULL_BEGIN

@interface ZKLanguage : NSObject

+ (instancetype)sharedInstance;

/*!
 *    @brief    当前语言对应的NSBundle 对象
 */
- (NSBundle *)bundle;

/*!
 *    @brief    当前的应用语言，跟随系统或应用内手动设置
 */
- (NSString *)currentLanguage;

/*!
 *    @brief    获取当前系统语言
 */
- (NSString *)currentSystemLanguage;

/*!
 *    @brief    设置当前语言
 *    @param    language     跟项目中的语言包文件夹 .lproj 的前缀一致
 */
- (void)setLanguage:(NSString *)language;

/*!
 *    @brief    获取对应的多语言
 */
- (NSString *)stringWithKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END

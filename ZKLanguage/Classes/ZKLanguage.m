//
//  ZKLanguage.m
//  FBSnapshotTestCase
//
//  Created by Kaiser on 2018/12/23.
//

#import "ZKLanguage.h"

NSNotificationName const ZKLanguageDidChangedNotification = @"ZKLanguageDidChangedNotification";

static NSBundle *bundle;
static NSString *const kUserLanguage = @"ZKUserLanguage";

@implementation ZKLanguage

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static ZKLanguage *instance;
    dispatch_once(&onceToken, ^{
        instance = [[ZKLanguage alloc] init];
    });
    
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    if (!bundle) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *language = [defaults valueForKey:kUserLanguage];
        if (language.length == 0) {
            NSArray *systemLanguages = [NSLocale preferredLanguages];
            language = systemLanguages.firstObject;
            
            // 移除获取的系统语言中的国家字符
            NSRange nationDashRange = [language rangeOfString:@"-" options:NSBackwardsSearch];
            language = [language substringToIndex:nationDashRange.location];
            if ([[NSBundle mainBundle] pathForResource:language ofType:@"lproj"] == nil) {    // 系统语言没有对应的语言包，先去取通用的“Base.lproj”语言包，没有则去取应用的第一个语言包
                if ([[NSBundle mainBundle] pathForResource:@"Base" ofType:@"lproj"] == nil) {
                    NSArray *bundleLanguages = [[NSBundle mainBundle] preferredLocalizations];
                    NSString *bundleFirstLanguage = bundleLanguages.firstObject;
                    language = bundleFirstLanguage;
                } else {
                    language = @"Base";
                }
            }
        }
        
        NSString *path = [[NSBundle mainBundle] pathForResource:language ofType:@"lproj"];
        bundle = [NSBundle bundleWithPath:path];
    }
    
    return self;
}

- (NSBundle *)bundle {
    return bundle;
}

- (NSString *)currentLanguage {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *language = [defaults valueForKey:kUserLanguage];
    if (language.length == 0) {
        NSString *systemLanguage = [self currentSystemLanguage];
        return systemLanguage;
    }
    return language;
}

- (NSString *)currentSystemLanguage {
    // 先去获取系统语言，返回格式为：语言-国家
    NSArray *systemLanguages = [NSLocale preferredLanguages];
    NSString *currentSystemLanguage = [systemLanguages objectAtIndex:0];
    // 移除获取的系统语言中的国家字符
    NSRange nationDashRange = [currentSystemLanguage rangeOfString:@"-" options:NSBackwardsSearch];
    currentSystemLanguage = [currentSystemLanguage substringToIndex:nationDashRange.location];
    return currentSystemLanguage;
}

- (void)setLanguage:(NSString *)language {
    if (self.currentLanguage == language) return;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *path = [[NSBundle mainBundle] pathForResource:language ofType:@"lproj"];
    bundle = [NSBundle bundleWithPath:path];
    [defaults setValue:language forKey:kUserLanguage];
    [defaults synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ZKLanguageDidChangedNotification object:nil];
}

- (NSString *)stringWithKey:(NSString *)key {
    if (bundle) return [bundle localizedStringForKey:key value:nil table:@"localization"];
    
    return NSLocalizedString(key, nil);
}

@end

//
//  Utilities.m
//  Utility
//
//  Created by ZIYAO YANG on 15/8/20.
//  Copyright (c) 2015年 Zhong Rui. All rights reserved.
//

#import "Utilities.h"

@implementation Utilities

+ (id)getUserDefaults:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

+ (void)setUserDefaults:(NSString *)key content:(id)value
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)removeUserDefaults:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)uniqueVendor
{
    NSString *uniqueIdentifier = [Utilities getUserDefaults:@"kKeyVendor"];
    if (!uniqueIdentifier || uniqueIdentifier.length == 0) {
        NSUUID *uuid = [[UIDevice currentDevice] identifierForVendor];
        uniqueIdentifier = [uuid UUIDString];
        [Utilities setUserDefaults:@"kKeyVendor" content:uniqueIdentifier];
    }
    return uniqueIdentifier;
}

+ (id)getStoryboardInstanceByIdentity:(NSString *)storyboard byIdentity:(NSString*)identity;
{
    UIStoryboard* sb = [UIStoryboard storyboardWithName:storyboard bundle:[NSBundle mainBundle]];
    return [sb instantiateViewControllerWithIdentifier:identity];
}

+ (void)popUpAlertViewWithMsg:(NSString *)msg andTitle:(NSString* )title onView:(UIViewController *)vc
{
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:title == nil ? @"提示" : title message:msg == nil ? @"操作失败" : msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:nil];
    [alertView addAction:cancelAction];
    [vc presentViewController:alertView animated:YES completion:nil];
}

+ (UIActivityIndicatorView *)getCoverOnView:(UIView *)view
{
    UIActivityIndicatorView *aiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    aiv.backgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.4];
    aiv.frame = view.bounds;
    [view addSubview:aiv];
    [aiv startAnimating];
    return aiv;
}

+ (NSString *)notRounding:(float)price afterPoint:(int)position
{
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    
    ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:price];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    return [NSString stringWithFormat:@"%@",roundedOunces];
}

+ (UIImage *)imageUrl:(NSString *)url {
    if ([url isKindOfClass:[NSNull class]] || url == nil) {
        return nil;
    }
    static dispatch_queue_t backgroundQueue;
    if (backgroundQueue == nil) {
        backgroundQueue = dispatch_queue_create("com.beilyton.queue", NULL);
    }
    
    NSArray *directories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [directories objectAtIndex:0];
    __block NSString *filePath = nil;
    filePath = [documentDirectory stringByAppendingPathComponent:[url lastPathComponent]];
    UIImage *imageInFile = [UIImage imageWithContentsOfFile:filePath];
    if (imageInFile) {
        return imageInFile;
    }
    
    __block NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    if (!data) {
        NSLog(@"Error retrieving %@", url);
        return nil;
    }
    UIImage *imageDownloaded = [[UIImage alloc] initWithData:data];
    dispatch_async(backgroundQueue, ^(void) {
        [data writeToFile:filePath atomically:YES];
        //NSLog(@"Wrote to: %@", filePath);
    });
    return imageDownloaded;
}
+ (double)getTextHeight:(NSString *)text textFont:(UIFont *)textFont toViewRange:(int)range{
    CGSize maxSize = CGSizeMake([[UIScreen mainScreen] bounds].size.width - range, 1000);
    CGSize contentLabelSize = [text boundingRectWithSize:maxSize options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:textFont} context:nil].size;
    return contentLabelSize.height;
}
@end

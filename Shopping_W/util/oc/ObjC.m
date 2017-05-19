#import "ObjC.h"
#import <UIKit/UIKit.h>

@implementation ObjC

+ (BOOL)catchException:(void(^)())tryBlock error:(__autoreleasing NSError **)error {
    @try {
        tryBlock();
        return YES;
    }
    @catch (NSException *exception) {
        *error = [[NSError alloc] initWithDomain:exception.name code:0 userInfo:exception.userInfo];
    }
}





+ (void)autoDisappearAlert:(CGFloat)time title:(NSString *)title msg:(NSString *)msg {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    dispatch_queue_t q = dispatch_get_main_queue();
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, time * NSEC_PER_SEC), q, ^{
        [alert dismissWithClickedButtonIndex:0 animated:YES];
    });
}

+ (void)autoDisappearAlert:(UIViewController *)vc time:(CGFloat)time title:(NSString *)title msg:(NSString *)msg {
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        dispatch_queue_t q = dispatch_get_main_queue();
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, time * NSEC_PER_SEC), q, ^{
            [alert dismissWithClickedButtonIndex:0 animated:YES];
        });
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [vc presentViewController:alert animated:YES completion:^{
            //延时执行
            dispatch_queue_t q = dispatch_get_main_queue();
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, time * NSEC_PER_SEC), q, ^{
                [alert dismissViewControllerAnimated:YES completion:nil];
            });
        }];
    }
    
    
}




@end

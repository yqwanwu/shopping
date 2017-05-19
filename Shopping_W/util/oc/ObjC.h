

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

static NSString *host = @"http://123.57.35.40:8080/privilege/";//@"http://kofuf.kofuf.com:8080/privilege/";//

/**s
 *  当前的swift 不能捕获异常，所以用oc捕获，转换成error给swift用
 */
@interface ObjC : NSObject

+ (BOOL)catchException:(void(^)())tryBlock error:(__autoreleasing NSError **)error;


+ (void)autoDisappearAlert:(CGFloat)time title:(NSString *)title msg:(NSString *)msg;

@end

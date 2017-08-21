

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

static NSString *host = @"http://111.161.41.28:8088/czw";
/**s
 *  当前的swift 不能捕获异常，所以用oc捕获，转换成error给swift用
 */
@interface ObjC : NSObject

+ (BOOL)catchException:(void(^)())tryBlock error:(__autoreleasing NSError **)error;


+ (void)autoDisappearAlert:(CGFloat)time title:(NSString *)title msg:(NSString *)msg;

@end


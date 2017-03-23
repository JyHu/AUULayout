//
//  AUUBaseViewController.h
//  VFLFactory
//
//  Created by JyHu on 2017/3/21.
//
//

#import <UIKit/UIKit.h>
#import <Nimbus/NimbusModels.h>
#import <Masonry/Masonry.h>

typedef NS_ENUM(NSUInteger, AUUTestCaseType) {
    AUUTestCaseTypeFactory,
    AUUTestCaseTypeMasonry,
    AUUTestCaseTypeVFL,
};

@interface AUUBaseViewController : UIViewController <NIActionsDataTransition>

- (UIView *)generateViewWithTag:(NSUInteger)tag inView:(UIView *)container;

- (UIView *)generateViewWithTag:(NSUInteger)tag;

@property (assign, nonatomic) AUUTestCaseType testCaseType;

@end

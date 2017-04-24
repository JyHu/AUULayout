//
//  AUUBaseCaseViewController.h
//  AUULayout
//
//  Created by JyHu on 2017/4/23.
//
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, AUUTestCaseType) {
    AUUTestCaseTypePackVFL,
    AUUTestCaseTypeMasonry,
    AUUTestCaseTypeVFL,
};

@interface AUUBaseCaseViewController : UIViewController

- (UIView *)generateViewWithTag:(NSUInteger)tag inView:(UIView *)container;

- (UIView *)generateViewWithTag:(NSUInteger)tag;

@property (retain, nonatomic) id transitionInfo;

@property (assign, nonatomic) AUUTestCaseType testCaseType;

@end

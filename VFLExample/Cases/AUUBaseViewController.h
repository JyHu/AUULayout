//
//  AUUBaseViewController.h
//  VFLFactory
//
//  Created by JyHu on 2017/3/21.
//
//

#import <UIKit/UIKit.h>
#import <Nimbus/NimbusModels.h>

@interface AUUBaseViewController : UIViewController <NIActionsDataTransition>

- (UIView *)generateViewWithTag:(NSUInteger)tag inView:(UIView *)container;

- (UIView *)generateViewWithTag:(NSUInteger)tag;

@end

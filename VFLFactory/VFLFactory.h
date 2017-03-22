//
//  VFLFactory.h
//  VFLFactory
//
//  Created by JyHu on 2017/3/21.
//
//

#import <UIKit/UIKit.h>

/*
 
 [App] if we're in the real pre-commit handler we can't actually add any new fences due to CA restriction
 
 http://blog.csdn.net/ws1836300/article/details/52957056
 
 Edit scheme -> Arguments -> Environment Variables -> OS_ACTIVITY_MODE : disable
 
 */

#import "UIView+AUUVFL.h"
#import "NSString+AUUVFL.h"
#import "NSArray+AUUVFL.h"
#import "UIView+AUUVFLEdge.h"

//! Project version number for VFLFactory.
FOUNDATION_EXPORT double VFLFactoryVersionNumber;

//! Project version string for VFLFactory.
FOUNDATION_EXPORT const unsigned char VFLFactoryVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <VFLFactory/PublicHeader.h>



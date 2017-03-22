//
//  NSObject+AUUVFLPrivate.h
//  VFLFactory
//
//  Created by JyHu on 2017/3/21.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Private)

@property (weak, nonatomic) UIView *base;

//@property (assign, nonatomic) NSInteger hashKeyIndex;

@end

@interface UIView (Private)

@property (retain, nonatomic) NSMutableDictionary *layoutKits;

@property (retain, nonatomic) NSString *releation;

- (NSString *)addHashKey:(UIView *)view;


//@property (weak, nonatomic) UIView *topView;
//@property (assign, nonatomic) CGFloat topMargin;
//
//@property (weak, nonatomic) UIView *leftView;
//@property (assign, nonatomic) CGFloat leftMargin;
//
//@property (weak, nonatomic) UIView *bottomView;
//@property (assign, nonatomic) CGFloat bottomMargin;
//
//@property (weak, nonatomic) UIView *rightView;
//@property (assign, nonatomic) CGFloat rightMargin;

@end

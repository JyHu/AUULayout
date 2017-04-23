//
//  NITableHeaderFooterView+Private.h
//  Nimbus
//
//  Created by JyHu on 2017/3/12.
//
//

#import "NITableViewActions.h"
#import "NITableHeaderFooterView.h"




/*
 
 表头表尾视图的私有类，记录相关的参数，用于点击事件的传递
 
 */




@interface NITableHeaderFooterView ()

@property (weak, nonatomic) UITableView *pri_tableView;

@property (assign, nonatomic) NSUInteger pri_sectionIndex;

@property (weak, nonatomic) id pri_delegate;

@end

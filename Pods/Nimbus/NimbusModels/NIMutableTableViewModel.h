//
// Copyright 2011-2014 NimbusKit
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "NITableViewModel.h"

@class NIMutableTableViewModel;

/**
 * A protocol for NIMutableTableViewModel to handle editing states for objects.
 *
 * @ingroup TableViewModels
 */
@protocol NIMutableTableViewModelDelegate <NSObject, NITableViewModelViewsDelegate>

@optional

/**
 * Asks the receiver whether the object at the given index path should be editable.
 *
 * If this method is not implemented, the default response is assumed to be NO.
 */
- (BOOL)tableViewModel:(NIMutableTableViewModel *)tableViewModel
         canEditObject:(id)object
           atIndexPath:(NSIndexPath *)indexPath
           inTableView:(UITableView *)tableView;

/**
 * Asks the receiver whether the object at the given index path should be moveable.
 *
 * If this method is not implemented, the default response is assumed to be NO.
 */
- (BOOL)tableViewModel:(NIMutableTableViewModel *)tableViewModel
         canMoveObject:(id)object
           atIndexPath:(NSIndexPath *)indexPath
           inTableView:(UITableView *)tableView;

/**
 * Asks the receiver whether the given object should be moved.
 *
 * If this method is not implemented, the default response is assumed to be YES.
 *
 * Returning NO will stop the model from handling the move logic.
 */
- (BOOL)tableViewModel:(NIMutableTableViewModel *)tableViewModel
      shouldMoveObject:(id)object
           atIndexPath:(NSIndexPath *)indexPath
           toIndexPath:(NSIndexPath *)toIndexPath
           inTableView:(UITableView *)tableView;

/**
 * Asks the receiver what animation should be used when deleting the object at the given index path.
 *
 * If this method is not implemented, the default response is assumed to be
 * UITableViewRowAnimationAutomatic.
 */
- (UITableViewRowAnimation)tableViewModel:(NIMutableTableViewModel *)tableViewModel
              deleteRowAnimationForObject:(id)object
                              atIndexPath:(NSIndexPath *)indexPath
                              inTableView:(UITableView *)tableView;

/**
 * Asks the receiver whether the given object should be deleted.
 *
 * If this method is not implemented, the default response is assumed to be YES.
 *
 * Returning NO will stop the model from handling the deletion logic. This is a good opportunity for
 * you to show a UIAlertView or similar feedback prompt to the user before initiating the deletion
 * yourself.
 *
 * If you implement the deletion of the object yourself, your code may resemble the following:
 @code
 NSArray *indexPaths = [self removeObjectAtIndexPath:indexPath];
 [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
 @endcode
 */
- (BOOL)tableViewModel:(NIMutableTableViewModel *)tableViewModel
    shouldDeleteObject:(id)object
           atIndexPath:(NSIndexPath *)indexPath
           inTableView:(UITableView *)tableView;

@end

/**
 * The NIMutableTableViewModel class is a mutable table view model.
 *
 * When modifications are made to the model there are two ways to reflect the changes in the table
 * view.
 *
 * - Call reloadData on the table view. This is the most destructive way to update the table view.
 * - Call insert/delete/reload methods on the table view with the retuned index path arrays.
 *
 * The latter option is the recommended approach to adding new cells to a table view. Each method in
 * the mutable table view model returns a data structure that can be used to inform the table view
 * of the exact modifications that have been made to the model.
 *
 * Example of adding a new section:
 @code
 // Appends a new section to the end of the model.
 NSIndexSet* indexSet = [self.model addSectionWithTitle:@"New section"];
 
 // Appends a cell to the last section in the model (in this case, the new section we just created).
 [self.model addObject:[NITitleCellObject objectWithTitle:@"A cell"]];
 
 // Inform the table view that we've modified the model.
 [self.tableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
 @endcode
 *
 * @ingroup TableViewModels
 */
@interface NIMutableTableViewModel : NITableViewModel

#pragma mark - 添加数据
#pragma mark -


/**
 在所有section的最后一个section插入一个数据，如果当前没有数据，默认的会新建一个section，并把数据方法第一个section里
 
 @param object 要插入的数据
 @return 插入位置的 IndexPath
 */
- (NSArray *)addObject:(id)object;

/**
 在指定的section最后追加一条数据，默认最远是当前所有section的后一个。
 比如当前有4个section，如果要追加到第5个的话，会新建一个section，然后把数据添加到第五个section里。
 如果要插入到第6个的话，就是超出最大的距离了。
 
 @param object 要追加的数据
 @param sectionIndex 要追加的数据所在的section的索引
 @return 追加数据位置的IndexPath
 */
- (NSArray *)addObject:(id)object toSection:(NSUInteger)sectionIndex;

/**
 追加一组数据到最后一个分组，如果当前一个分组也没有，那么先在最后追加一个分组，然后把数据放置进去
 
 @param array 要追加的数据数组
 @return 追加的所有数据的IndexPath
 */
- (NSArray *)addObjectsFromArray:(NSArray *)array;

/**
 插入一条数据到指定的位置
 
 @param object 要插入的数据
 @param indexPath 要插入的数据的位置
 @return 插入数据的IndexPath
 */
- (NSArray *)insertObject:(id)object atIndexPath:(NSIndexPath *)indexPath;

/**
 追加一组数据到指定的分组
 
 @param array 要追加的数据
 @param sectionIndex 要追加数据的分组的索引
 @return 追加的数据的 IndexPath
 */
- (NSArray *)addObjectsFromArray:(NSArray *)array toSection:(NSUInteger)sectionIndex;

/**
 重新添加一个分组内的数据
 
 @param objects 要添加的数据列表
 @param sectionIndex 添加到的分组的索引
 @return 追加的数据的 IndexPath
 */
- (NSArray *)setObjects:(NSArray *)objects toSection:(NSUInteger)sectionIndex;

#pragma mark - 移动数据
#pragma mark -


/**
 移动一个数据到指定位置
 
 @param fIndexPath 开始位置
 @param tIndexPath 目标位置
 @return 移动的结果
 */
- (BOOL)bringObjectFromIndexPath:(NSIndexPath *)fIndexPath toIndexPath:(NSIndexPath *)tIndexPath;


#pragma mark - 删除数据
#pragma mark -


/**
 移除table数据中指定位置的数据
 
 @param indexPath 要移除的数据的位置
 @return 移除位置的 IndexPath
 */
- (NSArray *)removeObjectAtIndexPath:(NSIndexPath *)indexPath;

/**
 完全删除一个分组section
 
 @param sectionIndex 要删除的分组section
 @return 被删除的section的索引集合
 */
- (NSIndexSet *)removeSectionAtIndex:(NSUInteger)sectionIndex;

/**
 清空指定section下的所有数据，但是保留这个section
 
 @param sectionIndex 要清理的section的索引
 @return 被清理掉的section的索引集合
 */
- (NSIndexSet *)removeObjectsInSection:(NSUInteger)sectionIndex;

/**
 根据给定的range删除cell数据

 @param range 限定删除的开始位置和个数
 @return 被清理掉的section的索引集合
 */
- (NSArray *)removeObjectsWithRange:(NSRange)range inSection:(NSUInteger)sectionIndex;

#pragma mark - 追加一个分组，并设置header、footer视图
#pragma mark -
/*
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 给当前的最后一个分组添加一个header、footer视图，如果存在则跳过
 
 title header、footer的标题，默认为使用 NITitle....Object
 object header、footer的object数据，为 NITableHeaderFooterObject 或其子类
 
 返回值是添加的分组的索引集合，如果无效的话，返回nil
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 */
- (NSIndexSet *)addSectionHeaderWithTitle:(NSString *)title;
- (NSIndexSet *)addSectionFooterWithTitle:(NSString *)title;
- (NSIndexSet *)addSectionHeaderWithObject:(id)object;
- (NSIndexSet *)addSectionFooterWithObject:(id)object;


#pragma mark - 追加一个分组，并设置header、footer视图
#pragma mark -
/*
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 追加一个分组，并设置header、footer视图
 
 title header、footer的标题，默认为使用 NITitle....Object
 object header、footer的object数据，为 NITableHeaderFooterObject 或其子类
 
 返回值是追加的分组的索引集合，如果无效的话，返回nil
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 */
- (NSIndexSet *)appendSectionHeaderWithTitle:(NSString *)title;
- (NSIndexSet *)appendSectionFooterWithTitle:(NSString *)title;
- (NSIndexSet *)appendSectionHeaderWithObject:(id)object;
- (NSIndexSet *)appendSectionFooterWithObject:(id)object;


#pragma mark - 给指定的section添加一个section header 或者section footer
#pragma mark -
/*
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 给指定的section添加一个section header 或者section footer，如果已经存在header或者footer则跳过
 
 title 要添加的头标题或者尾标题，会默认的使用 NITitle....Object
 object 要添加的头视图、尾视图的object数据，为 NITableHeaderFooterObject 或其子类
 sectionIndex 要添加到得分组的索引，如果索引有效即可以直接取到，那么直接添加，如果索引比当前table的最后的一个索引多1的话，那么会追加一个分组，然后设置头视图或者尾视图。如果过远，即索引超过最后的一个索引大于1的话，那么跳过。
 
 返回值是添加到的分组的索引集合，如果无效的话，返回nil
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 */
- (NSIndexSet *)addSectionHeaderWithTitle:(NSString *)title toSection:(NSUInteger)sectionIndex;
- (NSIndexSet *)addSectionFooterWithTitle:(NSString *)title toSection:(NSUInteger)sectionIndex;
- (NSIndexSet *)addSectionHeaderWithObject:(id)object toSection:(NSUInteger)sectionIndex;
- (NSIndexSet *)addSectionFooterWithObject:(id)object toSection:(NSUInteger)sectionIndex;



#pragma mark - 根据给定的数据重新设置section的header、footer 视图
#pragma mark -
/**
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 根据给定的数据重新设置section的header、footer 视图
 
 title 要重新设置的header、footer的标题，默认的使用 NITitle....Object
 object 要重新设置的header、footer的object数据，为 NITableHeaderFooterObject 或其子类
 sectionIndex 要添加到得分组的索引，如果索引有效即可以直接取到，那么直接添加，如果索引比当前table的最后的一个索引多1的话，那么会追加一个分组，然后设置头视图或者尾视图。如果过远，即索引超过最后的一个索引大于1的话，那么跳过。
 
 返回值是要操作的分组的索引集合，如果无效的话，返回nil
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 */
- (NSIndexSet *)replaceSectionHeaderWithTitle:(NSString *)title inSection:(NSUInteger)sectionIndex;
- (NSIndexSet *)replaceSectionFooterWithTitle:(NSString *)title inSection:(NSUInteger)sectionIndex;
- (NSIndexSet *)replaceSectionHeaderWithObject:(id)object inSection:(NSUInteger)sectionIndex;
- (NSIndexSet *)replaceSectionFooterWithObject:(id)object inSection:(NSUInteger)sectionIndex;


#pragma mark - 根据给定的索引，删除section的header、footer的视图
#pragma mark -
/**
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 根据给定的索引，删除section的header、footer的视图
 
 sectionIndex 要操作的section的索引
 
 返回值是要操作的分组的索引集合，如果无效的话，返回nil
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 */
- (NSIndexSet *)removeSectionHeaderInSection:(NSUInteger)sectionIndex;
- (NSIndexSet *)removeSectionFooterInSection:(NSUInteger)sectionIndex;

#pragma mark - 其他操作
#pragma mark -

/**
 清理掉所有的cell object的内容，但是保留所有的section实体
 */
- (void)removeAllDatas;
/**
 清空所有的table数据，包括section header、footer一样清理掉
 */
- (void)clearAllDatas;

- (void)updateSectionIndex;

@property (nonatomic, weak) id<NIMutableTableViewModelDelegate> delegate;

@end

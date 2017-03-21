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

#import "NIMutableTableViewModel.h"

#import "NITableViewModel+Private.h"
#import "NIMutableTableViewModel+Private.h"
#import "NimbusCore.h"
#import "NICellFactory.h"
#import "NITableHeaderFooterFactory.h"

@implementation NIMutableTableViewModel

@dynamic delegate;


#pragma mark - 添加数据
#pragma mark -


/**
 在所有section的最后一个section插入一个数据，如果当前没有数据，默认的会新建一个section，并把数据方法第一个section里

 @param object 要插入的数据
 @return 插入位置的 IndexPath
 */
- (NSArray *)addObject:(id)object {
    // 因为是追加，所以直接取最后一个section即可，如果当前没有数据，则追加一个section
    NITableViewModelSection* section = self.sections.count == 0 ? [self _appendSection] : [self.sections lastObject];
    [section.mutableRows addObject:object];
    return [NSArray arrayWithObject:[NSIndexPath indexPathForRow:section.mutableRows.count - 1
                                                       inSection:self.sections.count - 1]];
}

/**
 在指定的section最后追加一条数据，默认最远是当前所有section的后一个。
 比如当前有4个section，如果要追加到第5个的话，会新建一个section，然后把数据添加到第五个section里。
 如果要插入到第6个的话，就是超出最大的距离了。

 @param object 要追加的数据
 @param sectionIndex 要追加的数据所在的section的索引
 @return 追加数据位置的IndexPath
 */
- (NSArray *)addObject:(id)object toSection:(NSUInteger)sectionIndex {
    if (object) {
        NITableViewModelSection *section = [self _effectiveSectionAtIndex:sectionIndex];
        if (section) {
            [section.mutableRows addObject:object];
            return @[ [NSIndexPath indexPathForRow:section.mutableRows.count - 1 inSection:sectionIndex] ];
        }
    }
    
    return nil;
}

/**
 追加一组数据到最后一个分组，如果当前一个分组也没有，那么先在最后追加一个分组，然后把数据放置进去

 @param array 要追加的数据数组
 @return 追加的所有数据的IndexPath
 */
- (NSArray *)addObjectsFromArray:(NSArray *)array {
    NSMutableArray* indices = [NSMutableArray array];
    for (id object in array) {
        [indices addObject:[[self addObject:object] firstObject]];
    }
    return indices;
}

/**
 插入一条数据到指定的位置

 @param object 要插入的数据
 @param indexPath 要插入的数据的位置
 @return 插入数据的IndexPath
 */
- (NSArray *)insertObject:(id)object atIndexPath:(NSIndexPath *)indexPath {
    if (object) {
        NITableViewModelSection *section = [self _effectiveSectionWithIndexPath:indexPath];
        [section.mutableRows insertObject:object atIndex:indexPath.row];
        return @[ indexPath ];
    }
    
    return nil;
}

/**
 追加一组数据到指定的分组

 @param array 要追加的数据
 @param sectionIndex 要追加数据的分组的索引
 @return 追加的数据的 IndexPath
 */
- (NSArray *)addObjectsFromArray:(NSArray *)array toSection:(NSUInteger)sectionIndex
{
    if (array && array.count > 0) {
        NSMutableArray *indexPathes = [NSMutableArray arrayWithCapacity:array.count];
        for (id object in array) {
            [indexPathes addObject:[self addObject:object toSection:sectionIndex]];
        }
        return indexPathes;
    }
    return nil;
}

/**
 重新添加一个分组内的数据

 @param objects 要添加的数据列表
 @param sectionIndex 添加到的分组的索引
 @return 追加的数据的 IndexPath
 */
- (NSArray *)setObjects:(NSArray *)objects toSection:(NSUInteger)sectionIndex
{
    if (objects) {
        // 先取出目标组，如果有效的话，先清空这个分组内的数据，然后再添加数据到这个分组里
        NITableViewModelSection *section = [self _effectiveSectionAtIndex:sectionIndex];
        if (section) {
            [section.mutableRows removeAllObjects];
            return [self addObjectsFromArray:objects toSection:sectionIndex];
        }
    }
    
    return nil;
}



#pragma mark - 移动数据
#pragma mark -

/**
 移动一个数据到指定位置

 @param fIndexPath 开始位置
 @param tIndexPath 目标位置
 @return 移动的结果
 */
- (BOOL)bringObjectFromIndexPath:(NSIndexPath *)fIndexPath toIndexPath:(NSIndexPath *)tIndexPath
{
    if (fIndexPath.section < self.sections.count && tIndexPath.section <= self.sections.count)
    {
        NITableViewModelSection *fSection = [self.sections objectAtIndex:fIndexPath.section];
        NITableViewModelSection *tSection = [self _effectiveSectionAtIndex:tIndexPath.section];
        
        if (fIndexPath.row < fSection.rows.count && tIndexPath.row <= tSection.rows.count)
        {
            id fObject = [fSection.rows objectAtIndex:fIndexPath.row];
            
            [tSection.mutableRows insertObject:fObject atIndex:tIndexPath.row];
            [fSection.mutableRows removeObjectAtIndex:fIndexPath.row];
            
            return YES;
        }
    }
    return NO;
}



#pragma mark - 删除数据
#pragma mark -

/**
 移除table数据中指定位置的数据

 @param indexPath 要移除的数据的位置
 @return 移除位置的 IndexPath
 */
- (NSArray *)removeObjectAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section < self.sections.count) {
        NITableViewModelSection* section = [self.sections objectAtIndex:indexPath.section];
        if (indexPath.row < section.mutableRows.count) {
            [section.mutableRows removeObjectAtIndex:indexPath.row];
            return @[ indexPath ];
        }
    }
    return nil;
}

/**
 清空指定section下的所有数据，但是保留这个section

 @param sectionIndex 要清理的section的索引
 @return 被清理掉的section的索引集合
 */
- (NSIndexSet *)removeObjectsInSection:(NSUInteger)sectionIndex
{
    if (sectionIndex < self.sections.count) {
        NITableViewModelSection *section = [self.sections objectAtIndex:sectionIndex];
        [section.mutableRows removeAllObjects];
        return [NSIndexSet indexSetWithIndex:sectionIndex];
    }
    return nil;
}

/**
 完全删除一个分组section

 @param sectionIndex 要删除的分组section
 @return 被删除的section的索引集合
 */
- (NSIndexSet *)removeSectionAtIndex:(NSUInteger)sectionIndex {
    if (sectionIndex < self.sections.count) {
        [self.sections removeObjectAtIndex:sectionIndex];
        return [NSIndexSet indexSetWithIndex:sectionIndex];
    }
    return nil;
}

/**
 根据给定的range删除cell数据
 
 @param range 限定删除的开始位置和个数
 @return 被清理掉的section的索引集合
 */
- (NSArray *)removeObjectsWithRange:(NSRange)range inSection:(NSUInteger)sectionIndex
{
    if (sectionIndex < self.sections.count) {
        NITableViewModelSection *section = [self.sections objectAtIndex:sectionIndex];
        if (range.location < section.rows.count) {
            NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
            NSUInteger minIndex = MIN(range.location + range.length, section.rows.count);
            for (NSUInteger i = minIndex - 1; i >= range.location; i --) {
                [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:sectionIndex]];
                [section.mutableRows removeObjectAtIndex:i];
            }
            return indexPaths;
        }
    }
    return nil;
}

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
- (NSIndexSet *)addSectionHeaderWithTitle:(NSString *)title
{
    return [self addSectionHeaderWithObject:[NITitleHeaderObject objectWithTitle:title]];
}
- (NSIndexSet *)addSectionFooterWithTitle:(NSString *)title
{
    return [self addSectionFooterWithObject:[NITitleFooterObject objectWithTitle:title]];
}
- (NSIndexSet *)addSectionHeaderWithObject:(id)object
{
    if (self.sections && self.sections.count > 0) {
        NITableViewModelSection *section = [self.sections lastObject];
        if (!section.headerObject) {
            section.headerObject = object;
            return [NSIndexSet indexSetWithIndex:self.sections.count - 1];
        }
    }
    return nil;
}
- (NSIndexSet *)addSectionFooterWithObject:(id)object
{
    if (self.sections && self.sections.count > 0) {
        NITableViewModelSection *section = [self.sections lastObject];
        if (!section.footerObject) {
            section.footerObject = object;
            return [NSIndexSet indexSetWithIndex:self.sections.count - 1];
        }
    }
    return nil;
}


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
- (NSIndexSet *)appendSectionHeaderWithTitle:(NSString *)title
{
    return [self appendSectionHeaderWithObject:[NITitleHeaderObject objectWithTitle:title]];
}
- (NSIndexSet *)appendSectionFooterWithTitle:(NSString *)title
{
    return [self appendSectionFooterWithObject:[NITitleFooterObject objectWithTitle:title]];
}
- (NSIndexSet *)appendSectionHeaderWithObject:(id)object
{
    NITableViewModelSection *section = [self _appendSection];
    section.headerObject = object;
    return [NSIndexSet indexSetWithIndex:self.sections.count - 1];
}
- (NSIndexSet *)appendSectionFooterWithObject:(id)object
{
    NITableViewModelSection *section = [self _appendSection];
    section.footerObject = object;
    return [NSIndexSet indexSetWithIndex:self.sections.count - 1];
}

#pragma mark - 给指定的section添加一个section header 或者section footer
#pragma mark -
/*
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 给指定的section添加一个section header 或者section footer
 
 title 要添加的头标题或者尾标题，会默认的使用 NITitle....Object
 object 要添加的头视图、尾视图的object数据，为 NITableHeaderFooterObject 或其子类
 sectionIndex 要添加到得分组的索引，如果索引有效即可以直接取到，那么直接添加，如果索引比当前table的最后的一个索引多1的话，那么会追加一个分组，然后设置头视图或者尾视图。如果过远，即索引超过最后的一个索引大于1的话，那么跳过。
 
 返回值是添加到的分组的索引集合，如果无效的话，返回nil
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 */
- (NSIndexSet *)addSectionHeaderWithTitle:(NSString *)title toSection:(NSUInteger)sectionIndex
{
    return [self addSectionHeaderWithObject:[NITitleHeaderObject objectWithTitle:title] toSection:sectionIndex];
}
- (NSIndexSet *)addSectionFooterWithTitle:(NSString *)title toSection:(NSUInteger)sectionIndex
{
    return [self addSectionFooterWithObject:[NITitleFooterObject objectWithTitle:title] toSection:sectionIndex];
}
- (NSIndexSet *)addSectionHeaderWithObject:(id)object toSection:(NSUInteger)sectionIndex
{
    NITableViewModelSection *section = [self _effectiveSectionAtIndex:sectionIndex];
    if (section) {
        if (!section.headerObject) {
            section.headerObject = object;
            return [NSIndexSet indexSetWithIndex:sectionIndex];
        }
    }
    return nil;
}
- (NSIndexSet *)addSectionFooterWithObject:(id)object toSection:(NSUInteger)sectionIndex
{
    NITableViewModelSection *section = [self _effectiveSectionAtIndex:sectionIndex];
    if (section) {
        if (!section.footerObject) {
            section.footerObject = object;
            return [NSIndexSet indexSetWithIndex:sectionIndex];
        }
    }
    return nil;
}

#pragma mark - 根据给定的数据重新设置section的header、footer 视图
#pragma mark -
/**
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 根据给定的数据重新设置section的header、footer 视图
 
 title 要重新设置的header、footer的标题，默认的使用 NITitle....Object
 object 要重新设置的header、footer的object数据，为 NITableHeaderFooterObject 或其子类
 sectionIndex 要添加到得分组的索引，如果索引有效即可以直接取到，那么直接添加，如果索引比当前table的最后的一个索引多1的话，那么会追加一个分组，然后设置头视图或者尾视图。如果过远，即索引超过最后的一个索引大于1的话，那么跳过。
 
 返回值是添加到的分组的索引集合，如果无效的话，返回nil
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 */
- (NSIndexSet *)replaceSectionHeaderWithTitle:(NSString *)title inSection:(NSUInteger)sectionIndex
{
    return [self replaceSectionHeaderWithObject:[NITitleHeaderObject objectWithTitle:title] inSection:sectionIndex];
}
- (NSIndexSet *)replaceSectionFooterWithTitle:(NSString *)title inSection:(NSUInteger)sectionIndex
{
    return [self replaceSectionFooterWithObject:[NITitleFooterObject objectWithTitle:title] inSection:sectionIndex];
}
- (NSIndexSet *)replaceSectionHeaderWithObject:(id)object inSection:(NSUInteger)sectionIndex
{
    NITableViewModelSection *section = [self _effectiveSectionAtIndex:sectionIndex];
    if (section) {
        section.headerObject = object;
        return [NSIndexSet indexSetWithIndex:sectionIndex];
    }
    return nil;
}
- (NSIndexSet *)replaceSectionFooterWithObject:(id)object inSection:(NSUInteger)sectionIndex
{
    NITableViewModelSection *section = [self _effectiveSectionAtIndex:sectionIndex];
    if (section) {
        section.footerObject = object;
        return [NSIndexSet indexSetWithIndex:sectionIndex];
    }
    return nil;
}

#pragma mark - 根据给定的索引，删除section的header、footer的视图
#pragma mark -
/**
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 根据给定的索引，删除section的header、footer的视图
 
 sectionIndex 要操作的section的索引
 
 返回值是要操作的分组的索引集合，如果无效的话，返回nil
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 */
- (NSIndexSet *)removeSectionHeaderInSection:(NSUInteger)sectionIndex
{
    if (sectionIndex < self.sections.count) {
        NITableViewModelSection *section = [self.sections objectAtIndex:sectionIndex];
        if (section) {
            section.headerObject = nil;
            return [NSIndexSet indexSetWithIndex:sectionIndex];
        }
    }
    return nil;
}
- (NSIndexSet *)removeSectionFooterInSection:(NSUInteger)sectionIndex
{
    if (sectionIndex < self.sections.count) {
        NITableViewModelSection *section = [self.sections objectAtIndex:sectionIndex];
        if (section) {
            section.footerObject = nil;
            return [NSIndexSet indexSetWithIndex:sectionIndex];
        }
    }
    return nil;
}

#pragma mark - 其他操作
#pragma mark -

/**
 清理掉所有的cell object的内容，但是保留所有的section实体
 */
- (void)removeAllDatas
{
    for (NITableViewModelSection *section in self.sections) {
        [section.mutableRows removeAllObjects];
    }
}

/**
 清空所有的table数据，包括section header、footer一样清理掉
 */
- (void)clearAllDatas {
    [self _setSectionsWithArray:@[]];
}

- (void)updateSectionIndex {
    [self _compileSectionIndex];
}

#pragma mark - Private


/**
 拼接一个空得section
 */
- (NITableViewModelSection *)_appendSection {
    if (nil == self.sections) {
        [self _setSectionsWithArray:[NSMutableArray array]];
    }
    NITableViewModelSection* section = [[NITableViewModelSection alloc] init];
    section.rows = [NSMutableArray array];
    [self.sections addObject:section];
    return section;
}

/*
 在指定的位置插入一个section
 */
- (NITableViewModelSection *)_insertSectionAtIndex:(NSUInteger)index {
    if (nil == self.sections) {
        [self _setSectionsWithArray:[NSMutableArray array]];
    }
    NITableViewModelSection* section = nil;
    section = [[NITableViewModelSection alloc] init];
    section.rows = [NSMutableArray array];
    NIDASSERT(index >= 0 && index <= self.sections.count);
    [self.sections insertObject:section atIndex:index];
    return section;
}

/*
 初始化section列表
 */
- (void)_setSectionsWithArray:(NSArray *)sectionsArray {
    if ([sectionsArray isKindOfClass:[NSMutableArray class]]) {
        self.sections = (NSMutableArray *)sectionsArray;
    } else {
        self.sections = [sectionsArray mutableCopy];
    }
}

- (NITableViewModelSection *)_effectiveSectionAtIndex:(NSUInteger)sectionIndex
{
    return [self _effectiveSectionWithIndexPath:[NSIndexPath indexPathForRow:0 inSection:sectionIndex]];
}

/*
 根据给定的indexPath获取一个有效的section，index.{section, row}最多可以比现有的section数据的最后一条数据的indexPath大1。
 
 比如 indexPath{2,4}，最大的有效IndexPath为 indexPath{3,0}或者 indexPath{2, 5}
 */
- (NITableViewModelSection *)_effectiveSectionWithIndexPath:(NSIndexPath *)indexPath
{
    if (!self.sections || self.sections == 0) {
        if (indexPath.section == 0 && indexPath.row == 0) {
            // 如果当前没有数据，且要追加的section为第一个分组的第一个位置，那么就新建一个section
            // 如果分组的索引过远，则忽略
            return [self _appendSection];
        }
    }
    if (indexPath.section < self.sections.count) {
        // 如果要追加的section的索引在有效范围内，并且，则直接取出即可
        NITableViewModelSection *section = [self.sections objectAtIndex:indexPath.section];
        if (indexPath.row <= section.rows.count) {
            return section;
        }
    }
    if (indexPath.section == self.sections.count && indexPath.row == 0) {
        // 如果要追加的section的索引在分组总数后一个，而且数据是在第一个位置，那么就追加一个section
        return [self _appendSection];
    }
    
    // 要追加数据的索引太远
    return nil;
}

#pragma mark - UITableViewDataSource


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(tableViewModel:canEditObject:atIndexPath:inTableView:)]) {
        id object = [self objectAtIndexPath:indexPath];
        return [self.delegate tableViewModel:self canEditObject:object atIndexPath:indexPath inTableView:tableView];
    } else {
        return NO;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    id object = [self objectAtIndexPath:indexPath];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        BOOL shouldDelete = YES;
        if ([self.delegate respondsToSelector:@selector(tableViewModel:shouldDeleteObject:atIndexPath:inTableView:)]) {
            shouldDelete = [self.delegate tableViewModel:self shouldDeleteObject:object atIndexPath:indexPath inTableView:tableView];
        }
        if (shouldDelete) {
            NSArray *indexPaths = [self removeObjectAtIndexPath:indexPath];
            UITableViewRowAnimation animation = UITableViewRowAnimationAutomatic;
            if ([self.delegate respondsToSelector:@selector(tableViewModel:deleteRowAnimationForObject:atIndexPath:inTableView:)]) {
                animation = [self.delegate tableViewModel:self deleteRowAnimationForObject:object atIndexPath:indexPath inTableView:tableView];
            }
            [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:animation];
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(tableViewModel:canMoveObject:atIndexPath:inTableView:)]) {
        id object = [self objectAtIndexPath:indexPath];
        return [self.delegate tableViewModel:self canMoveObject:object atIndexPath:indexPath inTableView:tableView];
    } else {
        return NO;
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    id object = [self objectAtIndexPath:sourceIndexPath];
    BOOL shouldMove = YES;
    if ([self.delegate respondsToSelector:@selector(tableViewModel:shouldMoveObject:atIndexPath:toIndexPath:inTableView:)]) {
        shouldMove = [self.delegate tableViewModel:self shouldMoveObject:object atIndexPath:sourceIndexPath toIndexPath:destinationIndexPath inTableView:tableView];
    }
    if (shouldMove) {
        [self removeObjectAtIndexPath:sourceIndexPath];
        [self insertObject:object atIndexPath:destinationIndexPath];
    }
}

@end


@implementation NITableViewModelSection (Mutable)

- (NSMutableArray *)mutableRows {
    NIDASSERT([self.rows isKindOfClass:[NSMutableArray class]] || nil == self.rows);
    
    self.rows = self.rows == nil ? [NSMutableArray array] : self.rows;
    return (NSMutableArray *)self.rows;
}

@end

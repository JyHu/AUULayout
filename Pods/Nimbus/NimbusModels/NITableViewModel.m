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
#import "NITableViewModel+Private.h"
#import "NICellFactory+Private.h"
#import "NITableHeaderFooterFactory.h"
#import "NimbusCore.h"
#import "NICellCatalog.h"
#import "NITableHeaderFooterFactory.h"

#if !defined(__has_feature) || !__has_feature(objc_arc)
#error "Nimbus requires ARC support."
#endif

@implementation NITableViewModel

#if NS_BLOCKS_AVAILABLE
#endif // #if NS_BLOCKS_AVAILABLE


- (id)initWithDelegate:(id<NITableViewModelViewsDelegate>)delegate {
    if ((self = [super init])) {
        self.delegate = delegate;
        
        _sectionIndexType = NITableViewModelSectionIndexNone;
        _sectionIndexShowsSearch = NO;
        _sectionIndexShowsSummary = NO;
        
        [self _resetCompiledData];
    }
    return self;
}

- (id)initWithListArray:(NSArray *)listArray delegate:(id<NITableViewModelViewsDelegate>)delegate {
    if ((self = [self initWithDelegate:delegate])) {
        [self _compileDataWithListArray:listArray];
    }
    return self;
}

- (id)initWithSectionedArray:(NSArray *)sectionedArray delegate:(id<NITableViewModelViewsDelegate>)delegate {
    if ((self = [self initWithDelegate:delegate])) {
        [self _compileDataWithSectionedArray:sectionedArray];
    }
    return self;
}

- (id)init {
    return [self initWithDelegate:nil];
}

#pragma mark - Compiling Data

- (NSArray *)_compileDataWithArray:(NSArray *)datasArray {
    NSMutableArray *sections = [[NSMutableArray alloc] init];
    for (id object in datasArray) {
        // 只有当前数据有效，才有进去遍历的意义
        if (object) {
            NITableViewModelSection *curSection = [sections lastObject];
            // 如果是字符串的话，就直接新建一个组，把这个字符串做成一个header赋值给新的组
            if ([object isKindOfClass:[NSString class]]) {
                NITableViewModelSection *tempSection = [NITableViewModelSection section];
                tempSection.headerObject = [NITitleHeaderObject objectWithTitle:object];
                [sections addObject:tempSection];
            }
            // 如果是NITableHeaderFooterObject得话，需要判断是头还是尾
            else if ([object isKindOfClass:[NITableHeaderFooterObject class]]) {
                NITableHeaderFooterObject *headerFooterObject = (NITableHeaderFooterObject *)object;
                // 如果是表头的话，就新建一个组，并把它赋值给新组的表头
                if (headerFooterObject.type == NITableViewHeaderFooterTypeHeader) {
                    NITableViewModelSection *tempSection = [NITableViewModelSection section];
                    tempSection.headerObject = object;
                    [sections addObject:tempSection];
                }
                // 如果是表尾的话，需要判断一下最后一个组有没有尾视图
                else {
                    // 如果存在当前组
                    if (curSection) {
                        // 如果存在尾视图的话，就需要新建一个分组，并把当前值赋值给新的组作为表尾视图
                        if (curSection.footerObject) {
                            NITableViewModelSection *tempSection = [NITableViewModelSection section];
                            tempSection.footerObject = object;
                            [sections addObject:tempSection];
                        }
                        // 如果这个组不存在表尾视图的话，就把这个值赋值给这个组作为表尾视图
                        else {
                            curSection.footerObject = object;
                        }
                    }
                    // 如果当前组不存在的话，就新建一个分组
                    else {
                        curSection = [NITableViewModelSection section];
                        curSection.footerObject = object;
                        [sections addObject:curSection];
                    }
                }
            }
            // 如果不是表头表尾的数据的话，那就是中间的cell的数据了
            else {
                if ([object isKindOfClass:[NSArray class]] || [object isKindOfClass:[NSSet class]]) {
                    // 只有这个集合中有数据，才需要去遍历
                    if ([object count] > 0) {
                        [sections addObject:[self sectionFromListDatas:object]];
                    }
                }
                else
                {
                    // 如果当前的section没有，那就新建一个
                    if (!curSection) {
                        curSection = [NITableViewModelSection section];
                        [sections addObject:curSection];
                    }
                    NSMutableArray *rows = [curSection.rows mutableCopy];
                    [rows addObject:object];
                    curSection.rows = rows;
                }
            }
        }
    }
    
    return sections;
}

// 将一个数组/集合转换成一个section的对象
- (NITableViewModelSection *)sectionFromListDatas:(id)datas
{
    NSArray *subObjects = datas;
    if ([datas isKindOfClass:[NSSet class]]) {
        subObjects = [datas allObjects];
    }
    
    NSUInteger sub_fromIndex = 0;       // 数据截取开始的位置
    NSUInteger sub_length = subObjects.count;   // 数据截取的长度
    
    // 当前要创建的一个section
    NITableViewModelSection *tempSection = [NITableViewModelSection section];
    
    id fobject = [subObjects firstObject];
    id lobject = [subObjects lastObject];
    
    // 如果数组里只有一个数据
    if (subObjects.count == 1) {
        // 如果这个数据是字符串，那么就作为表头视图
        if ([fobject isKindOfClass:[NSString class]]) {
            sub_fromIndex = 1;  // 开始的位置变为1
            sub_length = 0;     // 由于只有1个元素，那么截取的长度就为0
            
            tempSection.headerObject = [NITitleHeaderObject objectWithTitle:fobject];
        }
        // 如果是NITableHeaderFooterObject，说明这个元素是一个有效的表头/表尾视图，那么开始截取位置也是1，长度也是0
        else if ([fobject isKindOfClass:[NITableHeaderFooterObject class]]) {
            sub_fromIndex = 1;
            sub_length = 0;
            
            NITableHeaderFooterObject *headerFooterObject = (NITableHeaderFooterObject *)fobject;
            // 如果是表头的话，就放到表头
            if (headerFooterObject.type == NITableViewHeaderFooterTypeHeader) {
                tempSection.headerObject = headerFooterObject;
            }
            // 如果是表尾的话，就放到表尾
            else {
                tempSection.footerObject = headerFooterObject;
            }
        }
    }
    // 如果数据量不止1个
    else {
        // 先判断第一个数据
        // 如果是字符串，就放到表头，截取的开始位置设置为1，截取的长度减去1
        if ([fobject isKindOfClass:[NSString class]]) {
            sub_fromIndex = 1;
            sub_length -= 1;
            tempSection.headerObject = [NITitleHeaderObject objectWithTitle:fobject];
        }
        // 如果是表头视图的话，就直接放到当前组里，表尾的话就略掉
        else if ([fobject isKindOfClass:[NITableHeaderFooterObject class]]) {
            sub_fromIndex = 1;
            NITableHeaderFooterObject *headerFooterObject = (NITableHeaderFooterObject *)fobject;
            if (headerFooterObject.type == NITableViewHeaderFooterTypeHeader) {
                sub_length -= 1;
                tempSection.headerObject = headerFooterObject;
            }
        }
        
        // 再判断最后一个数据
        // 如果是字符串，就放到表尾
        if ([lobject isKindOfClass:[NSString class]]) {
            sub_length -= 1;
            tempSection.footerObject = [NITitleFooterObject objectWithTitle:lobject];
        }
        // 如果是表尾视图的话，那就直接放到当前分组的表尾
        else if ([lobject isKindOfClass:[NITableHeaderFooterObject class]]) {
            NITableHeaderFooterObject *headerFooterObject = (NITableHeaderFooterObject *)fobject;
            if (headerFooterObject.type == NITableViewHeaderFooterTypeFooter) {
                sub_length -= 1;
                tempSection.footerObject = headerFooterObject;
            }
        }
    }
    
    // 如果可截取的有效长度大于0，那么才能去截取
    if (sub_length > 0) {
        tempSection.rows = [self _uncompressListDatas:[subObjects subarrayWithRange:NSMakeRange(sub_fromIndex, sub_length)]];
    }
    
    return tempSection;
}

- (NSMutableArray *)_uncompressListDatas:(id)datas
{
    NSMutableArray *uncompressDatas = [[NSMutableArray alloc] init];
    
    for (id object in datas)
    {
        // 如果是数组的话，继续解压
        if ([object isKindOfClass:[NSArray class]] || [object isKindOfClass:[NSSet class]])
        {
            [uncompressDatas addObjectsFromArray:[self _uncompressListDatas:object]];
        }
        else
        {
            [uncompressDatas addObject:object];
        }
    }
    
    return uncompressDatas;
}

- (void)_resetCompiledData {
    [self _setSectionsWithArray:nil];
    self.sectionIndexTitles = nil;
    self.sectionPrefixToSectionIndex = nil;
}

- (void)_compileDataWithListArray:(NSArray *)listArray {
    [self _resetCompiledData];
    
    if (nil != listArray && listArray.count > 0) {
        [self _setSectionsWithArray:@[ [self sectionFromListDatas:listArray] ]];
    }
}

- (void)_compileDataWithSectionedArray:(NSArray *)sectionedArray {
    [self _resetCompiledData];
    
    // Update the compiled information for this data source.
    [self _setSectionsWithArray:[self _compileDataWithArray:sectionedArray]];
}

- (void)_compileSectionIndex {
    _sectionIndexTitles = nil;
    
    // Prime the section index and the map
    NSMutableArray* titles = nil;
    NSMutableDictionary* sectionPrefixToSectionIndex = nil;
    if (NITableViewModelSectionIndexNone != _sectionIndexType) {
        titles = [NSMutableArray array];
        sectionPrefixToSectionIndex = [NSMutableDictionary dictionary];
        
        // The search symbol is always first in the index.
        if (_sectionIndexShowsSearch) {
            [titles addObject:UITableViewIndexSearch];
        }
    }
    
    // A dynamic index shows the first letter of every section in the index in whatever order the
    // sections are ordered (this may not be alphabetical).
    if (NITableViewModelSectionIndexDynamic == _sectionIndexType) {
        for (NITableViewModelSection* section in _sections) {
            NITableHeaderFooterObject *headerObject = section.headerObject;
            if (headerObject && [headerObject isKindOfClass:[NITitleHeaderObject class]]) {
                NITitleHeaderObject *titleHeaderObject = (NITitleHeaderObject *)headerObject;
                NSString* headerTitle = titleHeaderObject.title;
                if ([headerTitle length] > 0) {
                    NSString* prefix = [headerTitle substringToIndex:1];
                    [titles addObject:prefix];
                }
            }
        }
        
    } else if (NITableViewModelSectionIndexAlphabetical == _sectionIndexType) {
        // Use the localized indexed collation to create the index. In English, this will always be
        // the entire alphabet.
        NSArray* sectionIndexTitles = [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles];
        
        // The localized indexed collection sometimes includes a # for summaries, but we might
        // not want to show a summary in the index, so prune it out. It's not guaranteed that
        // a # will actually be included in the section index titles, so we always attempt to
        // remove it for consistency's sake and then add it back down below if it is requested.
        for (NSString* letter in sectionIndexTitles) {
            if (![letter isEqualToString:@"#"]) {
                [titles addObject:letter];
            }
        }
    }
    
    // Add the section summary symbol if it was requested.
    if (_sectionIndexShowsSummary) {
        [titles addObject:@"#"];
    }
    
    // Build the prefix => section index map.
    if (NITableViewModelSectionIndexNone != _sectionIndexType) {
        // Map all of the sections to indices.
        NSInteger sectionIndex = 0;
        for (NITableViewModelSection* section in _sections) {
            NITableHeaderFooterObject *headerObject = section.headerObject;
            if (headerObject && [headerObject isKindOfClass:[NITitleHeaderObject class]]) {
                NITitleHeaderObject *titleHeaderObject = (NITitleHeaderObject *)headerObject;
                NSString* headerTitle = titleHeaderObject.title;
                if ([headerTitle length] > 0) {
                    NSString* prefix = [headerTitle substringToIndex:1];
                    if (nil == [sectionPrefixToSectionIndex objectForKey:prefix]) {
                        [sectionPrefixToSectionIndex setObject:[NSNumber numberWithInteger:sectionIndex] forKey:prefix];
                    }
                }
            }
            ++sectionIndex;
        }
        
        // Map the unmapped section titles to the next closest earlier section.
        NSInteger lastIndex = 0;
        for (NSString* title in titles) {
            NSString* prefix = [title substringToIndex:1];
            if (nil != [sectionPrefixToSectionIndex objectForKey:prefix]) {
                lastIndex = [[sectionPrefixToSectionIndex objectForKey:prefix] intValue];
                
            } else {
                [sectionPrefixToSectionIndex setObject:[NSNumber numberWithInteger:lastIndex] forKey:prefix];
            }
        }
    }
    
    self.sectionIndexTitles = titles;
    self.sectionPrefixToSectionIndex = sectionPrefixToSectionIndex;
}

- (void)_setSectionsWithArray:(NSArray *)sectionsArray {
    self.sections = sectionsArray;
}

#pragma mark - UITableViewDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sections.count;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // This is a static model; nothing can be edited.
    return NO;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.sectionIndexTitles;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    if (tableView.tableHeaderView) {
        if (index == 0 && [self.sectionIndexTitles count] > 0
            && [self.sectionIndexTitles objectAtIndex:0] == UITableViewIndexSearch)  {
            // This is a hack to get the table header to appear when the user touches the
            // first row in the section index.  By default, it shows the first row, which is
            // not usually what you want.
            [tableView scrollRectToVisible:tableView.tableHeaderView.bounds animated:NO];
            return -1;
        }
    }
    
    NSString* letter = [title substringToIndex:1];
    NSNumber* sectionIndex = [self.sectionPrefixToSectionIndex objectForKey:letter];
    return (nil != sectionIndex) ? [sectionIndex intValue] : -1;
}

// 获取某一个section的cell的个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ((NSUInteger)section < self.sections.count) {
        return [[[self.sections objectAtIndex:section] rows] count];
    } else {
        return 0;
    }
}

// 根据给定的位置创建一个cell
- (UITableViewCell *)tableView: (UITableView *)tableView
         cellForRowAtIndexPath: (NSIndexPath *)indexPath {
    id object = [self objectAtIndexPath:indexPath];
    
    NITextCell* cell = nil;
    
#if NS_BLOCKS_AVAILABLE
    if (nil != self.createCellBlock) {
        cell = (NITextCell *)self.createCellBlock(tableView, indexPath, object);
    }
#endif
    
    if (nil == cell) {
        cell = (NITextCell *)[self.delegate tableViewModel:self
                            cellForTableView:tableView
                                 atIndexPath:indexPath
                                  withObject:object];
    }
    if ([cell isKindOfClass:[NITextCell class]]) {
        cell.pri_tableView = tableView;
        cell.pri_delegate = (id <NITextCellDelegate>)self.delegate;
    }
    return cell;
}

#pragma mark - Public

// 获取指定位置的cell object
- (id)objectAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath == nil) {
        return nil;
    }
    if ((NSUInteger)indexPath.section < self.sections.count) {
        NSArray *rows = [[self.sections objectAtIndex:indexPath.section] rows];
        if ((NSUInteger)indexPath.row < rows.count) {
            return [rows objectAtIndex:indexPath.row];
        }
    }
    return nil;
}

// 获取section header 的 object
- (id)objectForHeaderInSection:(NSUInteger)section
{
    if (section < self.sections.count) {
        return [[self.sections objectAtIndex:section] headerObject];
    }
    return nil;
}

// 获取section footer 的 object
- (id)objectForFooterInSection:(NSUInteger)section
{
    if (section < self.sections.count) {
        return [[self.sections objectAtIndex:section] footerObject];
    }
    return nil;
}

//获取指定cellobject对象的索引
- (NSIndexPath *)indexPathForObject:(id)object {
    if (nil == object) {
        return nil;
    }
    
    NSArray *sections = self.sections;
    for (NSUInteger sectionIndex = 0; sectionIndex < [sections count]; sectionIndex++) {
        NSArray* rows = [[sections objectAtIndex:sectionIndex] rows];
        for (NSUInteger rowIndex = 0; rowIndex < [rows count]; rowIndex++) {
            if ([object isEqual:[rows objectAtIndex:rowIndex]]) {
                return [NSIndexPath indexPathForRow:rowIndex inSection:sectionIndex];
            }
        }
    }
    
    return nil;
}

// 设置右侧的索引的样式等属性
- (void)setSectionIndexType:(NITableViewModelSectionIndex)sectionIndexType showsSearch:(BOOL)showsSearch showsSummary:(BOOL)showsSummary {
    if (_sectionIndexType != sectionIndexType
        || _sectionIndexShowsSearch != showsSearch
        || _sectionIndexShowsSummary != showsSummary) {
        _sectionIndexType = sectionIndexType;
        _sectionIndexShowsSearch = showsSearch;
        _sectionIndexShowsSummary = showsSummary;
        
        [self _compileSectionIndex];
    }
}

/**
 获取当前tableView Model里的所有的数据
 
 @return 以二维数组的方式返回，每个一位数组为一个section里的所有数据
 */
- (NSArray *)allDatas
{
    NSMutableArray *datas = [[NSMutableArray alloc] initWithCapacity:self.sections.count];
    for (NITableViewModelSection *section in self.sections) {
        if (section.rows && section.rows.count > 0) {
            [datas addObject:[section.rows mutableCopy]];
        }
    }
    return datas;
}

- (NSArray *)objectsInSection:(NSUInteger)sectionIndex
{
    if (self.sections && self.sections.count > 0 && sectionIndex < self.sections.count) {
        NITableViewModelSection *section = [self.sections objectAtIndex:sectionIndex];
        return section.rows;
    }
    return nil;
}

@end


@implementation NITableViewModelSection

+ (id)section {
    NITableViewModelSection *section = [[self alloc] init];
    section.rows = @[];
    return section;
}

@end

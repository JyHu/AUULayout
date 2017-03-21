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

#import "NICellFactory.h"

typedef CGFloat (^NICellDrawRectBlock)(CGRect rect, _Nullable id object,  UITableViewCell* _Nullable  cell);

/**
 * An object that will draw the contents of the cell using a provided block.
 *
 * @ingroup TableCellCatalog
 */
@interface NIDrawRectBlockCellObject : NICellObject
// Designated initializer.
- (nullable id)initWithBlock:(nullable NICellDrawRectBlock)block object:(nullable id)object;
+ (nullable id)objectWithBlock:(nullable NICellDrawRectBlock)block object:(nullable id)object;
@property (nonatomic, copy) _Nullable NICellDrawRectBlock block;
@property (nonatomic, strong) _Nullable id object;
@end

/**
 * An object for displaying a single-line title in a table view cell.
 *
 * This object maps by default to a NITextCell and displays the title with a
 * UITableViewCellStyleDefault cell. You can customize the cell class using the
 * NICellObject methods.
 *
 * @ingroup TableCellCatalog
 */
@interface NITitleCellObject : NICellObject
// Designated initializer.
- (nullable id)initWithTitle:(nullable NSString *)title image:(nullable UIImage *)image;
- (nullable id)initWithTitle:(nullable NSString *)title;
- (nullable id)initWithTitle:(nullable NSString *)title image:(nullable UIImage *)image cellClass:(nullable Class)cellClass userInfo:(nullable id)userInfo;
+ (nullable id)objectWithTitle:(nullable NSString *)title image:(nullable UIImage *)image;
+ (nullable id)objectWithTitle:(nullable NSString *)title;
@property (nonatomic, copy)  NSString* _Nullable  title;
@property (nonatomic, strong)  UIImage* _Nullable  image;
@end

/**
 * An object for displaying two lines of text in a table view cell.
 *
 * This object maps by default to a NITextCell and displays the title with a
 * UITableViewCellStyleSubtitle cell. You can customize the cell class using the
 * NICellObject methods.
 *
 * @ingroup TableCellCatalog
 */
@interface NISubtitleCellObject : NITitleCellObject
// Designated initializer.
- (nullable id)initWithTitle:(nullable NSString *)title subtitle:(nullable NSString *)subtitle image:(nullable UIImage *)image;
- (nullable id)initWithTitle:(nullable NSString *)title subtitle:(nullable NSString *)subtitle;
- (nullable id)initWithTitle:(nullable NSString *)title subtitle:(nullable NSString *)subtitle image:(nullable UIImage *)image cellClass:(nullable Class)cellClass userInfo:(nullable id)userInfo;
+ (nullable id)objectWithTitle:(nullable NSString *)title subtitle:(nullable NSString *)subtitle image:(nullable UIImage *)image;
+ (nullable id)objectWithTitle:(nullable NSString *)title subtitle:(nullable NSString *)subtitle;
@property (nonatomic, copy) NSString* _Nullable subtitle;
@property (nonatomic, assign) UITableViewCellStyle cellStyle;
@end

/**
 * A general-purpose cell for displaying text.
 *
 * When given a NITitleCellObject, will set the textLabel's text with the title.
 * When given a NISubtitleCellObject, will also set the detailTextLabel's text with the subtitle.
 *
 * @ingroup TableCellCatalog
 */
@interface NITextCell : UITableViewCell <NICell>

/**
 在cell中，将自定义的操作信息传递到Viewcontroller里，在viewcontroller里需要
 实现NITextCellDelegate的tableView:transmitUserInfo:atIndexPath:这个协议方法。
 默认的在FTFTableViewController里已经添加了NITextCellDelegate协议，所以只需要实现
 这个协议方法即可。
 
 @param userInfo 需要传递的信息
 */
- (void)transmitUserInfo:(nullable id)userInfo;

/**
 在当前cell里刷新自己

 @param animation 刷新的时候用的动画类型
 */
- (void)reloadSelfWithRowAnimation:(UITableViewRowAnimation)animation;
- (void)reloadSelf;


@end


/**
 * A cell that renders its contents using a block.
 *
 * @ingroup TableCellCatalog
 */
@interface NIDrawRectBlockCell : UITableViewCell <NICell>
@property (nonatomic, strong) UIView* _Nullable blockView;
@end


@protocol NITextCellDelegate <NSObject>

@optional

/**
 点击cell的时候，往viewcontroller里传值的协议方法，如果想要从cell中往viewcontroller传值，
 调用cell的 `- (void)transmitUserInfo:(id)userInfo;` 方法，然后在vc中实现一下协议方法就可
 
 @param tableView cell所在的table
 @param userInfo 传递的信息
 @param indexPath cell的索引
 */
- (void)tableView:(nullable UITableView *)tableView
 transmitUserInfo:(nullable id)userInfo
      atIndexPath:(nullable NSIndexPath *)indexPath;

@end

/**
 * Initializes the NITitleCellObject with the given title, image, cellClass, and userInfo.
 *
 * This is the designated initializer. Use of this initializer allows for customization of the
 * associated cell class for this object.
 *
 * @fn NITitleCellObject::initWithTitle:image:cellClass:userInfo:
 */

/**
 * Initializes the NITitleCellObject with NITextCell as the cell class and the given title text and
 * image.
 *
 * @fn NITitleCellObject::initWithTitle:image:
 */

/**
 * Initializes the NITitleCellObject with NITextCell as the cell class and the given title text.
 *
 * @fn NITitleCellObject::initWithTitle:
 */

/**
 * Convenience method for initWithTitle:image:.
 *
 * @fn NITitleCellObject::objectWithTitle:image:
 * @returns Autoreleased instance of NITitleCellObject.
 */

/**
 * Convenience method for initWithTitle:.
 *
 * @fn NITitleCellObject::objectWithTitle:
 * @returns Autoreleased instance of NITitleCellObject.
 */

/**
 * The text to be displayed in the cell.
 *
 * @fn NITitleCellObject::title
 */

/**
 * Initializes the NISubtitleCellObject with the given title, subtitle, image, cellClass, and
 * userInfo.
 *
 * This is the designated initializer. Use of this initializer allows for customization of the
 * associated cell class for this object.
 *
 * @fn NISubtitleCellObject::initWithTitle:subtitle:image:cellClass:userInfo:
 */

/**
 * Initializes the NICellObject with NITextCell as the cell class and the given title and subtitle
 * text.
 *
 * @fn NISubtitleCellObject::initWithTitle:subtitle:
 */

/**
 * Convenience method for initWithTitle:subtitle:.
 *
 * @fn NISubtitleCellObject::objectWithTitle:subtitle:
 * @returns Autoreleased instance of NISubtitleCellObject.
 */

/**
 * The text to be displayed in the subtitle portion of the cell.
 *
 * @fn NISubtitleCellObject::subtitle
 */

/**
 * The type of UITableViewCell to instantiate.
 *
 * By default this is UITableViewCellStyleSubtitle.
 *
 * @fn NISubtitleCellObject::cellStyle
 */

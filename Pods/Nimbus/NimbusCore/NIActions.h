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

#import <Foundation/Foundation.h>

@class UITableViewHeaderFooterView;
@class UITableView;

/**
 * For attaching actions to objects.
 *
 * @ingroup NimbusCore
 * @defgroup Actions Actions
 * @{
 */

/**
 * @param object An action was performed on this object.
 * @param target The target that was attached to the NIActions instance.
 * @param indexPath The index path of the object.
 */
/*
 如果是对于section的header、footer来说的话，要获取section的索引，应该这样用 ：[indexPath indexAtPosition:0]
 */
typedef BOOL (^NIActionBlock)(id object, id target, NSIndexPath* indexPath);

/**
 * The attachable types of actions for NIAction.
 */
typedef NS_OPTIONS(NSUInteger, NIActionType) {
  NIActionTypeNone      = 0,
  NIActionTypeTap       = 1 << 0,
  NIActionTypeDetail    = 1 << 1,
  NIActionTypeNavigate  = 1 << 2,
};

/**
 * The NIActions class provides a generic interface for attaching actions to objects.
 *
 * NIActions are used to implement user interaction in UITableViews and UICollectionViews via the
 * corresponding classes (NITableViewActions and NICollectionViewActions) in the respective
 * feature. NIActions separates the necessity
 *
 * <h3>Types of Actions</h3>
 *
 * The three primary types of actions are:
 *
 * - buttons,
 * - detail views,
 * - and pushing a new controller onto the navigation controller.
 *
 * <h3>Attaching Actions</h3>
 *
 * Actions may be attached to specific instances of objects or to entire classes of objects. When
 * an action is attached to both a class of object and an instance of that class, only the instance
 * action should be executed.
 *
 * All attachment methods return the object that was provided. This makes it simple to attach
 * actions within an array creation statement.
 *
 * Actions come in two forms: blocks and selector invocations. Both can be attached to an object
 * for each type of action and both will be executed, with the block being executed first. Blocks
 * should be used for simple executions while selectors should be used when the action is complex.
 *
 * The following is an example of using NITableViewActions:
 *
@code
NSArray *objects = @[
  [NITitleCellObject objectWithTitle:@"Implicit tap handler"],
  [self.actions attachToObject:[NITitleCellObject objectWithTitle:@"Explicit tap handler"]
                      tapBlock:
   ^BOOL(id object, id target) {
     NSLog(@"Object was tapped with an explicit action: %@", object);
   }]
];

[self.actions attachToClass:[NITitleCellObject class]
                   tapBlock:
 ^BOOL(id object, id target) {
   NSLog(@"Object was tapped: %@", object);
 }];
@endcode
 *
 */
@interface NIActions : NSObject

// Designated initializer.
- (id)initWithTarget:(id)target;

#pragma mark Mapping Objects

- (id)attachToObject:(id<NSObject>)object tapBlock:(NIActionBlock)action;
- (id)attachToObject:(id<NSObject>)object detailBlock:(NIActionBlock)action;
- (id)attachToObject:(id<NSObject>)object navigationBlock:(NIActionBlock)action;

- (id)attachToObject:(id<NSObject>)object tapSelector:(SEL)selector;
- (id)attachToObject:(id<NSObject>)object detailSelector:(SEL)selector;
- (id)attachToObject:(id<NSObject>)object navigationSelector:(SEL)selector;

#pragma mark Mapping Classes

- (void)attachToClass:(Class)aClass tapBlock:(NIActionBlock)action;
- (void)attachToClass:(Class)aClass detailBlock:(NIActionBlock)action;
- (void)attachToClass:(Class)aClass navigationBlock:(NIActionBlock)action;

- (void)attachToClass:(Class)aClass tapSelector:(SEL)selector;
- (void)attachToClass:(Class)aClass detailSelector:(SEL)selector;
- (void)attachToClass:(Class)aClass navigationSelector:(SEL)selector;

#pragma mark Object State

- (BOOL)isObjectActionable:(id<NSObject>)object;
- (NIActionType)attachedActionTypesForObject:(id<NSObject>)object;

+ (id)objectFromKeyClass:(Class)keyClass map:(NSMutableDictionary *)map;

@end

#if defined __cplusplus
extern "C" {
#endif
    
/*
 
 这个block存在的意义：
 
 假如现在有 A B C D E几个页面需要跳转到页面F
 
 如果这几个页面跳转的时候，传递的数据都是在cell点击的时候传递同样的数据模型，
 比如都是FTFContractCellObject，则就不需要这个block，因为都是传递的同一
 类型的数据，那么跳转到新的页面以后就不需要做额外的判断。
 
 但是，如果这几个页面跳转的时候传递的数据不一样，比如合约点击跳转到合约详情页
 的时候传递的是 FTFContractCellObject，而搜索的时候跳转到合约详情页的是
 FTFContractSearchCellObject ,那么跳转到合约详情页后就无法很准确的知道
 是哪种数据，就需要做一个ifelse的判断，这时候就需要这个block，在页面跳转生
 成action的时候，把主要的数据传递过去，比如contractID，contractName。
 
 当然，如果不用这个block，在跳转到的页面做判断也是可以的
 
 */
typedef id (^NIParameterTransitionBlock) (id cellObject);
    
/**
 生成push的block的方法
 
 @param cls 要跳转的页面的class
 @param info 附带的信息
 @param parameterBlock 参数转换用的block
 @return Block
 */
NIActionBlock NIPushControllerWithBlockAction(Class cls, id info, NIParameterTransitionBlock parameterBlock);
NIActionBlock NIPushControllerWithInfoAction(Class cls, id info);
NIActionBlock NIPushControllerAction(Class cls);

/**
 生成present的block的方法
 
 @param cls 要跳转的页面的class
 @param info 附带的信息
 @param parametersBlock 参数转换用的block
 @return block
 */
NIActionBlock NIPresentControllerWithBlockAction(Class cls, id info, NIParameterTransitionBlock parametersBlock);
NIActionBlock NIPresentControllerWithInfoAction(Class cls, id info);
NIActionBlock NIPresentControllerAction(Class cls);
    
// 设置present时目标页面的navigationController类型
void NISetNavigationControllerClass(Class cls);
    
#if defined __cplusplus
};
#endif

/** The protocol for a data source that can be used with NIActions. */
@protocol NIActionsDataSource <NSObject>

/**
 * The object located at the given indexPath.
 *
 * @param indexPath The index path of the requested object.
 */
- (id)objectAtIndexPath:(NSIndexPath *)indexPath;

/**
 根据给定的分组索引获得section header的object

 @param section 要获得header数据的分组索引
 */
- (id)objectForHeaderInSection:(NSUInteger)section;

/**
 根据给定的分组索引获得section footer的object

 @param section 要获得footer数据的分组索引
 */
- (id)objectForFooterInSection:(NSUInteger)section;

@end

/**
 页面跳转时用到的代理方法
 
 如果你使用 NIPushController....Action 与 NIPresentController....Action 系列方法进行页面的
 跳转的话，可以在目标页面实现这个协议，那么在页面跳转的时候这里就会自动的调用transitionFrom:withObject:userInfo:
 协议方法为你的目标页面传递相应的数据
 
 */
@protocol NIActionsDataTransition <NSObject>

/**
 为你的目标页面传递相应的参数数据

 @param controller 跳转开始的页面
 @param object 相应视图的Object数据
 @param info 附加的用户信息
 */
- (void)transitionFrom:(id)controller withObject:(id)object userInfo:(id)info;

@end

/** @name Creating Table View Actions */

/**
 * Initializes a newly allocated table view actions object with the given controller.
 *
 * @attention This method is deprecated. Use the new method
 *            @link NIActions::initWithTarget: initWithTarget:@endlink.
 *
 * The controller is stored as a weak reference internally.
 *
 * @param controller The controller that will be used in action blocks.
 * @fn NIActions::initWithController:
 */

/**
 * Initializes a newly allocated table view actions object with the given target.
 *
 * This is the designated initializer.
 *
 * The target is stored as a weak reference internally.
 *
 * @param target The target that will be provided to action blocks and on which selectors will
 *                    be performed.
 * @fn NIActions::initWithTarget:
 */

/** @name Mapping Objects */

/**
 * Attaches a tap action to the given object.
 *
 * A cell with an attached tap action will have its selectionStyle set to
 * @c tableViewCellSelectionStyle when the cell is displayed.
 *
 * The action will be executed when the object's corresponding cell is tapped. The object argument
 * of the block will be the object to which this action was attached. The target argument of the
 * block will be this receiver's @c target.
 *
 * Return NO if the tap action is used to present a modal view controller. This provides a visual
 * reminder to the user when the modal controller is dismissed as to which cell was tapped to invoke
 * the modal controller.
 *
 * The tap action will be invoked first, followed by the navigation action if one is attached.
 *
 * @param object The object to attach the action to. This object must be contained within
 *                    an NITableViewModel.
 * @param action The tap action block.
 * @returns The object that you attached this action to.
 * @fn NIActions::attachToObject:tapBlock:
 * @sa NIActions::attachToObject:tapSelector:
 */

/**
 * Attaches a detail action to the given object.
 *
 * When a cell with a detail action is displayed, its accessoryType will be set to
 * UITableViewCellAccessoryDetailDisclosureButton.
 *
 * When a cell's detail button is tapped, the detail action block will be executed. The return
 * value of the block is ignored.
 *
 * @param object The object to attach the action to. This object must be contained within
 *                    an NITableViewModel.
 * @param action The detail action block.
 * @returns The object that you attached this action to.
 * @fn NIActions::attachToObject:detailBlock:
 */

/**
 * Attaches a navigation action to the given object.
 *
 * When a cell with a navigation action is displayed, its accessoryType will be set to
 * UITableViewCellAccessoryDisclosureIndicator if there is no detail action, otherwise the
 * detail disclosure indicator takes precedence.
 *
 * When a cell with a navigation action is tapped the navigation block will be executed.
 *
 * If a tap action also exists for this object then the tap action will be executed first, followed
 * by the navigation action.
 *
 * @param object The object to attach the action to. This object must be contained within
 *                    an NITableViewModel.
 * @param action The navigation action block.
 * @returns The object that you attached this action to.
 * @fn NIActions::attachToObject:navigationBlock:
 */

/**
 * Attaches a tap selector to the given object.
 *
 * The method signature for the selector is:
 @code
 - (BOOL)didTapObject:(id)object;
 @endcode
 *
 * A cell with an attached tap action will have its selectionStyle set to
 * @c tableViewCellSelectionStyle when the cell is displayed.
 *
 * The selector will be performed on the action object's target when a cell with a tap selector is
 * tapped, unless that selector does not exist on the @c target in which case nothing happens.
 *
 * If the selector invocation returns YES then the cell will be deselected immediately after the
 * invocation completes its execution. If NO is returned then the cell's selection will remain.
 *
 * Return NO if the tap action is used to present a modal view controller. This provides a visual
 * reminder to the user when the modal controller is dismissed as to which cell was tapped to invoke
 * the modal controller.
 *
 * The tap action will be invoked first, followed by the navigation action if one is attached.
 *
 * @param object The object to attach the selector to. This object must be contained within
 *                    an NITableViewModel.
 * @param selector The selector that will be invoked by this action.
 * @returns The object that you attached this action to.
 * @fn NIActions::attachToObject:tapSelector:
 * @sa NIActions::attachToObject:tapBlock:
 */

/**
 * Attaches a detail selector to the given object.
 *
 * The method signature for the selector is:
 @code
 - (void)didTapObject:(id)object;
 @endcode
 *
 * A cell with an attached tap action will have its selectionStyle set to
 * @c tableViewCellSelectionStyle and its accessoryType set to
 * @c UITableViewCellAccessoryDetailDisclosureButton when the cell is displayed.
 *
 * The selector will be performed on the action object's target when a cell with a detail selector's
 * accessory indicator is tapped, unless that selector does not exist on the @c target in which
 * case nothing happens.
 *
 * @param object The object to attach the selector to. This object must be contained within
 *                    an NITableViewModel.
 * @param selector The selector that will be invoked by this action.
 * @returns The object that you attached this action to.
 * @fn NIActions::attachToObject:detailSelector:
 * @sa NIActions::attachToObject:detailBlock:
 */

/**
 * Attaches a navigation selector to the given object.
 *
 * The method signature for the selector is:
 @code
 - (void)didTapObject:(id)object;
 @endcode
 *
 * A cell with an attached navigation action will have its selectionStyle set to
 * @c tableViewCellSelectionStyle and its accessoryType set to
 * @c UITableViewCellAccessoryDetailDisclosureButton, unless it also has an attached detail action,
 * in which case its accessoryType will be set to @c UITableViewCellAccessoryDisclosureIndicator
 * when the cell is displayed.
 *
 * The selector will be performed on the action object's target when a cell with a navigation
 * selector is tapped, unless that selector does not exist on the @c target in which case nothing
 * happens.
 *
 * @param object The object to attach the selector to. This object must be contained within
 *                    an NITableViewModel.
 * @param selector The selector that will be invoked by this action.
 * @returns The object that you attached this action to.
 * @fn NIActions::attachToObject:navigationSelector:
 * @sa NIActions::attachToObject:navigationBlock:
 */

/** @name Mapping Classes */

/**
 * Attaches a tap block to a class.
 *
 * This method behaves similarly to attachToObject:tapBlock: except it attaches a tap action to
 * all instances and subclassed instances of a given class.
 *
 * @param aClass The class to attach the action to.
 * @param action The tap action block.
 * @fn NIActions::attachToClass:tapBlock:
 */

/**
 * Attaches a detail block to a class.
 *
 * This method behaves similarly to attachToObject:detailBlock: except it attaches a detail action
 * to all instances and subclassed instances of a given class.
 *
 * @param aClass The class to attach the action to.
 * @param action The detail action block.
 * @fn NIActions::attachToClass:detailBlock:
 */

/**
 * Attaches a navigation block to a class.
 *
 * This method behaves similarly to attachToObject:navigationBlock: except it attaches a navigation
 * action to all instances and subclassed instances of a given class.
 *
 * @param aClass The class to attach the action to.
 * @param action The navigation action block.
 * @fn NIActions::attachToClass:navigationBlock:
 */

/**
 * Attaches a tap selector to a class.
 *
 * This method behaves similarly to attachToObject:tapBlock: except it attaches a tap action to
 * all instances and subclassed instances of a given class.
 *
 * @param aClass The class to attach the action to.
 * @param selector The tap selector.
 * @fn NIActions::attachToClass:tapSelector:
 */

/**
 * Attaches a detail selector to a class.
 *
 * This method behaves similarly to attachToObject:detailBlock: except it attaches a detail action
 * to all instances and subclassed instances of a given class.
 *
 * @param aClass The class to attach the action to.
 * @param selector The tap selector.
 * @fn NIActions::attachToClass:detailSelector:
 */

/**
 * Attaches a navigation selector to a class.
 *
 * This method behaves similarly to attachToObject:navigationBlock: except it attaches a navigation
 * action to all instances and subclassed instances of a given class.
 *
 * @param aClass The class to attach the action to.
 * @param selector The tap selector.
 * @fn NIActions::attachToClass:navigationSelector:
 */

/** @name Object State */

/**
 * Returns whether or not the object has any actions attached to it.
 *
 * @fn NIActions::isObjectActionable:
 */

/**
 * Returns a bitmask of flags indicating the types of actions attached to the provided object.
 *
 * @fn NIActions::attachedActionTypesForObject:
 */

/**
 * Returns a mapped object from the given key class.
 *
 * If the key class is a subclass of any mapped key classes, the nearest ancestor class's mapped
 * object will be returned and keyClass will be added to the map for future accesses.
 *
 * @param keyClass The key class that will be used to find the mapping in map.
 * @param map A map of key classes to classes. May be modified if keyClass is a subclass of
 *                 any existing key classes.
 * @returns The mapped object if a match for keyClass was found in map. nil is returned
 *               otherwise.
 * @fn NIActions::objectFromKeyClass:map:
 */

/**@}*/// End of Actions //////////////////////////////////////////////////////////////////////////

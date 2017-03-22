# VFLFactory

`VFLFactory`是一个使用`VFL + NSLayoutConstraint`完成的一个自动布局的库。

VFL是一个简单而又强大的描述性语言，由于VFL是使用字符串来描述组件间的关系，而字符串又有着天然的不确定性，所以才导致了VFL使用频率的低下。正由于此，同样是受于这种痛点，才萌生了做一个友好的封装的念头。

## 关于使用

暂时可以使用 `pod 'VFLFactory', :git => 'https://github.com/JyHu/VFLFactory.git'` 的方式来进行代码的拉取，之后添加到Pod。

使用的方式跟VFL语言类似，同样的是以一种级联的方式描述一列视图的关系，用描述的方式来进行页面的布局。

详细的文档之后完善，暂时可以看实例代码里的注释。



下面是几个例子:



比如：

```objective-c
self.Hori.interval(10).nextTo(view1.lengthEqual(view2)).interval(10).nextTo(view2).interval(20).end,
```

这条语句描述的是：

从父视图的左边开始间隔10个像素是view1，view1的长度跟view2相等，在间隔十个像素是view2，在间隔20个像素是父视图的右边。



再比如：

```objective-c
[self.Hori.interval(10).nextTo(label1.priority(100, 100)).interval(5).nextTo(label2.priority(100, 200)).interval(10) end];
```

这条语句描述的是：

父视图的左边 --10-- label1(最小宽度为100，优先级100) --5-- label2(最小宽度100，优先级200) --10-- 父视图的右边



再比如：

```objective-c
view3.alignmentCenter().fixedSize(CGSizeMake(100, 100));
```

这条语句描述的是：

view3在父视图上居中，并固定大小为100 * 100



再比如

```objective-c
view2.edge(UIEdgeInsetsMake(30, 40, 50, 60));
```

设置view2在父视图上下左右的边距

## TODO

整个东西也是刚刚做出来，在使用上也算可以满足大部分的自动布局需求了，在细节上还有许多地方以待继续优化改善，最后欢迎各位大佬的指点。

* 优化子视图的releation
* 调整VFL的终点
* 逻辑判断、警告、调试信息的处理
* 级联关系的检查
* 命名的优化
* category中不确定因素的排查

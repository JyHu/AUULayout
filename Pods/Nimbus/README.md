Nimbus is an iOS framework whose feature set grows only as fast as its documentation.

[![Build Status](https://travis-ci.org/jverkoey/nimbus.svg)](https://travis-ci.org/jverkoey/nimbus)

Getting Started
---------------

- Visit the Nimbus website at [nimbuskit.info](http://nimbuskit.info).
- [Add Nimbus to your project](http://wiki.nimbuskit.info/Add-Nimbus-to-your-project).
- Follow Nimbus' development through its [version history](http://docs.nimbuskit.info/group___version-_history.html).
- See the [latest API diffs](http://docs.nimbuskit.info/group___version-9-3.html).
- Read the [Three20 Migration Guide](http://docs.nimbuskit.info/group___three20-_migration-_guide.html).
- Ask questions and get updates via the [Nimbus mailing list](http://groups.google.com/group/nimbusios).



---------------


# NOTICE
本项目源自原项目[nimbus](https://github.com/jverkoey/nimbus.git)，如有问题，请看原项目，本项目中的以下说明性的文件均来自原项目：
* AUTHORS
* DONONRS
* LICENSE
* NOTICE
其中`README`这里的上面一部分是从原有的项目中移植过来；
`Podspec`是从原有项目中修改后移植过来。

---------------------

# DIFFER

以下内容是对于原有项目的修改和一些优化性的说明
---------------------

本项目源自nimbus，主要是由于原有项目过于久远，现在更新不多，还有ios技术的更新，旧的一些实现和API，现在已经有了新的替代方案，所以才抽取出来部分内容。在提取内容的同时，也做了一些优化和功能上的完善。
目前我们的项目使用的也是这套框架。

## USEAGE

`pod 'Nimbus', :git => 'https://github.com/JyHu/nimbus_thin.git'`

里面包含`Subspec`，可以使用例如`Nimbus/Models`的方式选择性的添加自己需要的内容。

## UPDATES

* 清理掉里面过期的无用的framework和API
* 新建了一个项目，调整项目结构，方便查看
* 增加了tableView section header、footer的实现内容
* 增加了一些实用的API
* 增加了一些测试信息
* 增加了一些注释信息
* 解决了一些兼容问题

继续优化。。。



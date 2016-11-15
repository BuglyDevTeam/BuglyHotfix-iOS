# BuglyHotfix iOS SDK 使用指南

[TOC]

>BuglyHotfix 基于 [JSPatch][4]  封装，完全兼容  [JSPatch][4] 编写的脚本文件。


## SDK 集成

BuglyHotfix 提供两种集成方式供开发者选择：

- 通过 CocoaPods 集成
- 手动集成

> BuglyHotfix iOS SDK 最低兼容 iOS 系统版本 iOS 7.0

#### 通过 CocoaPods 集成

在工程的`Podfile`里面添加以下代码：

```ruby
pod 'BuglyHotfix'
```

保存并执行`pod install`,然后用后缀为`.xcworkspace`的文件打开工程。

**注意:**

**命令行下执行`pod search BuglyHotfix`,如无法搜索到或搜索到的`BuglyHotfix`不是最新的版本，请先执行`pod repo update`更新本地的 spec-repositories 。**

> 关于`CocoaPods`的更多信息请查看 [CocoaPods官方网站][1]。

#### 手动集成

* 下载 [BuglyHotfix iOS SDK][2] 
* 拖拽`BuglyHotfix.framework`文件到Xcode工程内(请勾选`Copy items if needed`选项)
* 添加以下依赖库
	- `SystemConfiguration.framework`
	- `Security.framework`
	- `JavascriptCore.framework`
	- `libz.tbd`
	- `libc++.tbd`

## 初始化SDK

#### 导入头文件

在工程的`AppDelegate.m`文件导入头文件

> `#import <BuglyHotfix/Bugly.h>`

**如果是`Swift`工程，请在对应`bridging-header.h`中导入**

#### 初始化 BuglyHotfix

在工程`AppDelegate.m`的`application:didFinishLaunchingWithOptions:`方法中初始化BuglyHotfix，示例代码如下：

- **Objective-C**

```objective-c
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	    [Bugly startWithAppId:@"此处替换为你的AppId"
#ifdef DEBUG
        developmentDevice:YES
#endif
                   config:nil];
	return YES;
}
```

- **Swift**

```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
   #if DEBUG
   Bugly.start(withAppId: "900001055",
               developmentDevice: true,
               config: nil)
   #else
   Bugly.start(withAppId: "900001055",
               developmentDevice: false,
               config: nil)
   #endif
   return true
}
```


## 发布补丁

#### 一. 本地测试

补丁编写规则参见： [JSPatch][4] 

- 将补丁文件`main.js`拖拽到工程内；

- 开启 BuglyConfig 中的热更新本地调试模式；

```objective-c
    BuglyConfig *config = [[BuglyConfig alloc] init];
    config.hotfixDebugMode = YES;
    [Bugly startWithAppId:appId
#ifdef DEBUG
        developmentDevice:YES
#endif
                   config:config];
```

- 运行App测试补丁是否生效且工作正常。

#### 二. 开发环境测试

- 将本地测试通过的`main.js`文件压缩成`zip`，点击 Bugly 平台 `热更新` 功能的`发布新补丁` (`热更新`菜单在`应用升级`模块下)
![](media/14764256478684/14779857594587.jpg)

弹出新建补丁窗口

![](media/14764256478684/14779858073203.jpg)

选择目标版本（即应用版本）及开发设备，其它按默认值进行下发。

**注意：这里的版本列表只显示集成了 BuglyHotfix SDK 的应用版本**

- 移除工程内的`main.js`,关闭 BuglyConfig 中的热更新本地调试模式

```objective-c
    BuglyConfig *config = [[BuglyConfig alloc] init];
    config.hotfixDebugMode = NO;
    config.debugMode = YES;
    [Bugly startWithAppId:kBuglyAppId
#ifdef DEBUG
        developmentDevice:YES
#endif
                   config:config];
```

- 运行应用，测试补丁是否正常下发且生效，如 Bugly 成功应用了补丁，则会在控制台输出加载日志

```shell 
[Bugly][Info] Hotfix: evaluated script [version: 1]
```

#### 三. 正式发布

点击 Bugly 平台上对应补丁的`编辑`按钮，按需选择`全量设备`或`自定义`规则进行正式下发。

---

## 如何使用 JSPatch 扩展

把所需的 JSPatch 扩展导入到工程后，修改扩展的`.h`头文件 

```Objective-C
#import "JPEngine.h"` 
```

更改为 

```Objective-C
#import <BuglyHotfix/JPEngine.h>
```

如 `JPDispatch.h`

```Objective-C
#import <Foundation/Foundation.h>
#import "JPEngine.h"

@interface JPDispatch : JPExtension

@end
```

修改为

```Objective-C
#import <Foundation/Foundation.h>
#import <BuglyHotfix/JPEngine.h>

@interface JPDispatch : JPExtension

@end
```

## 常见问题

- BuglyHotfix SDK 集成后编译冲突

> 为了能保持原编写的 JSPatch 脚本的兼容性，Bugly 没有改变原有符号，所以遇到冲突情况，请移除项目中已有的 JSPatch 文件。

- main.js 上传不了

> 请把 mian.js 压缩成 zip 再进行上传。

- 版本选择列表内没有我的版本

> 目标版本列表只显示集成了 BuglyHotfix SDK 的应用版本，所以如果没有出现请尝试集成SDK后先运行一下App，然后再刷新页面尝试上传。

- 如果我需要按特定时机检查补丁更新该如何操作？

可以通过下述 SDK 提供的 API 发起查询补丁更新请求

```objective-c
+ (void)hotfixCheckUpdate;
```

- 如何获取补丁的信息？

可以通过下述 SDK 提供的 API 查询当前生效的补丁信息，如打开了测试本地 js，则无相关信息

```objective-c
+ (NSDictionary *)currentHotfixPatchInfo;
```

 返回的结构如下：
 
```objective-c
 {
 @"patchVersion":"补丁版本号",
 @"patchDesc":"补丁备注信息",
 @"patchUpdateTime":"补丁更新时间"
 }
```

- 补丁无法应用成功

为了保障补丁下载速度，所有的补丁都是通过 CDN 下发，所以在 iOS 9 以上需要配置允许使用 HTTP 协议通讯，步骤如下：

- 在工程内的 Info.plist 中添加 NSAppTransportSecurity （类型 Dictionary）。
- 在 NSAppTransportSecurity 下添加 NSAllowsArbitraryLoads （类型 Boolean）,值设为 YES

```xml
<key>NSAppTransportSecurity</key>
<dict>
	<key>NSAllowsArbitraryLoads</key>
	<true/>
</dict>
```

[iOS SDK升级指南]:upgrading-2.x-ios.md
[1]:https://cocoapods.org/
[2]:http://softfile.3g.qq.com/myapp/buglysdk/BuglyHotfix-1.0.0.zip
[3]:instruction-manual-ios-app-extension.md
[4]:https://github.com/bang590/JSPatch
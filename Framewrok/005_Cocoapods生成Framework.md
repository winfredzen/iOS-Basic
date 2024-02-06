# Cocoapods生成Framework

下面记录下我自己的实践过程，以期对其有深入的理解



## 动态库

按创建Pod的过程

1.`pod lib create CocoapodsFramework`

注意`pod 'CocoapodsFramework', :path => '../'`，指向的是`CocoapodsFramework.podspec`的位置



2.创建要共享的类（模拟，放在`CocoapodsFramework/Classes`目录下）

3.创建一个头文件`CocoapodsFramework.h`，导入其它类头文件

不做任何其它的修改，这时build后，在demo工程中通过`@import CocoapodsFramework;` 或者 `#import <CocoapodsFramework/CocoapodsFramework.h>` 都可以使用Framework中类







### 查看文件格式

生成的Framework如下：

![032](./images/032.png)



通过file 和 lipo 命令来查看Framework的相关信息

`file ./CocoapodsFramework`

> ./CocoapodsFramework: Mach-O 64-bit dynamically linked shared library arm64

`lipo -info ./CocoapodsFramework `

> Non-fat file: ./CocoapodsFramework is architecture: arm64



### mach-o文件

可使用如下的项目来查看mach-o文件

+ [MachOView](https://github.com/gdbinit/MachOView)



## 静态库

参考：

+ [使用cocoapods插件打包静态库——适用于项目依赖私有库、开源库，私有库又依赖静态库等复杂场景](https://yangjie2.github.io/2018/08/07/%E4%BD%BF%E7%94%A8cocoapods%E6%8F%92%E4%BB%B6%E6%89%93%E5%8C%85%E9%9D%99%E6%80%81%E5%BA%93%E2%80%94%E2%80%94%E9%80%82%E7%94%A8%E4%BA%8E%E9%A1%B9%E7%9B%AE%E4%BE%9D%E8%B5%96%E7%A7%81%E6%9C%89%E5%BA%93%E3%80%81%E5%BC%80%E6%BA%90%E5%BA%93%EF%BC%8C%E7%A7%81%E6%9C%89%E5%BA%93%E5%8F%88%E4%BE%9D%E8%B5%96%E9%9D%99%E6%80%81%E5%BA%93%E7%AD%89%E5%A4%8D%E6%9D%82%E5%9C%BA%E6%99%AF/)



使用[Cocoapods-package](https://github.com/CocoaPods/cocoapods-packager)来打包静态库，**不过我自己尝试是failed**


































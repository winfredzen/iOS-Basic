# Moya学习一

[Moya](https://github.com/Moya/Moya)是对Alamofire的进一步封装，具体的介绍可参考其[中文文档](https://github.com/Moya/Moya/blob/master/Readme_CN.md)，详细介绍可参考[docs_CN](https://github.com/Moya/Moya/tree/master/docs_CN)

## Target

需定义一个遵循`TargetType`协议的枚举类型



## Task

Task为枚举，表示的是一个HTTP Task，表示请求数据的方式：



## Endpoint

最终用来生成请求，有如下的属性：

+ url - 代表请求的url
+ sampleResponseClosure - 一个闭包，复制返回一个`SampleResponseClosure`
+ method - 请求方式
+ task - 请求的Task
+ httpHeaderFields - 请求头

Endpoint有如下的扩展，将一个`Endpoint`转为`URLRequest`

![28](https://github.com/winfredzen/iOS-Basic/blob/master/%E7%BD%91%E7%BB%9C/images/28.png)




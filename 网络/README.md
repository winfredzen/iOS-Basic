# 网络

## HTTP

在HTTP/1.1协议中，定义了8种发送HTTP请求的方法：GET、POST、OPTIONS、HEAD、PUT、DELETE、TRACE、CONNECT、PATCH

根据HTTP协议的设计初衷，不同的方法对资源有不同的操作方式

+ PUT ：增
+ DELETE ：删
+ POST：改
+ GET：查


**GET和POST区别**

内容来自[HTTP 方法：GET 对比 POST](http://www.w3school.com.cn/tags/html_ref_httpmethods.asp)

| | GET | POST |
| ------------- | ------------- | ----- |
| 后退按钮/刷新 | 无害 |数据会被重新提交（浏览器应该告知用户数据会被重新提交） |
| 书签 | 可收藏为书签 | 不可收藏为书签 |
| 缓存 | 能被缓存 | 不能缓存 | 
| 编码类型 | application/x-www-form-urlencoded | application/x-www-form-urlencoded 或 multipart/form-data。为二进制数据使用多重编码 | 
| 历史 | 参数保留在浏览器历史中 | 参数不会保存在浏览器历史中 | 
| 对数据长度的限制 | 是的。当发送数据时，GET 方法向 URL 添加数据；URL 的长度是受限制的（URL 的最大长度是 2048 个字符） | 无限制 | 
| 对数据类型的限制 | 只允许 ASCII 字符 | 没有限制。也允许二进制数据 | 
| 安全性 | 与 POST 相比，GET 的安全性较差，因为所发送的数据是 URL 的一部分。在发送密码或其他敏感信息时绝不要使用 GET ！ | POST 比 GET 更安全，因为参数不会被保存在浏览器历史或 web 服务器日志中 | 
| 可见性 | 数据在 URL 中对所有人都是可见的 | 数据不会显示在 URL 中 | 


## JSON和XML

### JSON

JSON是一种轻量级的数据格式，一般用于数据交互

标准JSON格式的注意点：key必须用双引号

```
{"names" : ["jack", "rose", "jim"]}
```

**JSON与OC转换**

| JSON | OC |
| --------- | -------- |
| 大括号 { } | NSDictionary |
| 中括号 [ ] | NSArray |
| 双引号 " " | NSString |
| 数字 | NSNumber |

**JSON解析**

iOS自带`NSJSONSerialization`

1.JSON转OC对象

```
+ (id)JSONObjectWithData:(NSData *)data options:(NSJSONReadingOptions)opt error:(NSError **)error;
```

`NSJSONReadingOptions`有三个值：

+ `NSJSONReadingMutableContainers`返回的数组和字典都是`NSMutableArray`和`NSMutableDictionay`类型
+ `NSJSONReadingMutableLeaves`返回的的字符串是`NSMutableSting`类型
+ `NSJSONReadingAllowFragments`意思是需要格式化的json字符串最外层可以不是数组和字典，只要是正确的json格式就行

2.OC转JSON对象

```
+ (NSData *)dataWithJSONObject:(id)obj options:(NSJSONWritingOptions)opt error:(NSError **)error;
```






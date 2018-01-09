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





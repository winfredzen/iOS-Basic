# throw与rethrows

> 为了明确一个函数或者方法可以抛出错误，你要在它的声明当中的形式参数后边写上 throws关键字。使用 throws标记的函数叫做*抛出函数*。如果它明确了一个返回类型，那么 throws关键字要在返回箭头 ( ->)之前
>
> ```swift
> func canThrowErrors() throws -> String
> ```

**throw与rethrows的区别**

参考：

+ [错误和异常处理](<https://swifter.tips/error-handle/>)
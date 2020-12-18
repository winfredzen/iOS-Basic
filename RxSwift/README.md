# RxSwift

创建observable，so，什么是observable？

> You’ll see “observable”, “observable sequence” and “sequence” used interchangeably  in Rx. And, really, they’re all the same thing. 
>
>  “Stream” also refers to  the same thing
>
> `Observable`、`observable sequence` 和 `sequence` 在 Rx 都是一个意思。或者在其他 Rx 实现中称之为 `stream`。
>
> 最好称之为 `Observable`，不过翻译过来还是**序列**顺口些。

 `Observables` produce **events** over a period of time, which is referred to as **emitting**.

>  `Observables`产生**event**，称为**emitting**

Events可包含值，例如数字or自定义的实例，or手势，点击事件

**observable生命周期**

当一个observable发出一个element时，被称为`next`事件


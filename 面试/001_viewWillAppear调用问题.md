# viewWillAppear调用问题

如A->B，A push到 B，`viewWillAppear` 和 `viewWillDisappear`调用顺序是什么样的呢？

1.A->B，先调用A的`viewWillDisappear`，再调用B的`viewWillAppear`

2.B->A，B pop到 A，先调用B的`viewWillDisappear`，再调用A的`viewWillAppear`

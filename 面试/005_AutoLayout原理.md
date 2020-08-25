# AutoLayout原理

参考：

+ [Auto Layout 是怎么进行自动布局的，性能如何？](https://time.geekbang.org/column/article/85332?utm_term=zeus1Z0MB&utm_source=weibo&utm_medium=daiming&utm_campaign=presell-161&utm_content=daiming0320)

**原理**
+ 一个是 1997 年，Auto Layout 用到的布局算法 Cassowary 被发明了出来；
+ 另一个是 2011 年，苹果公司将 Cassowary 算法运用到了自家的布局引擎 Auto Layout 中。

Cassowary 能够有效解析线性等式系统和线性不等式系统，用来表示用户界面中那些相等关系和不等关系。基于此，Cassowary 开发了一种规则系统，通过约束来描述视图间的关系。约束就是规则，这个规则能够表示出一个视图相对于另一个视图的位置。

布局引擎系统叫作 Layout Engine ，是 Auto Layout 的核心，主导着整个界面布局。

每个视图在得到自己的布局之前，Layout Engine 会将视图、约束、优先级、固定大小通过计算转换成最终的大小和位置。在 Layout Engine 里，每当约束发生变化，就会触发 Deffered Layout Pass，完成后进入监听约束变化的状态。当再次监听到约束变化，即进入下一轮循环中

Constraints Change 表示的就是约束变化，添加、删除视图时会触发约束变化。Activating 或 Deactivating，设置 Constant 或 Priority 时也会触发约束变化。Layout Engine 在碰到约束变化后会重新计算布局，获取到布局后调用 superview.setNeedLayout()，然后进入 Deferred Layout Pass。

Deferred Layout Pass 的主要作用是做容错处理。如果有些视图在更新约束时没有确定或缺失布局声明的话，会先在这里做容错处理

接下来，Layout Engine 会从上到下调用 layoutSubviews() ，通过 Cassowary 算法计算各个子视图的位置，算出来后将子视图的 frame 从 Layout Engine 里拷贝出来

**性能**

可以看到，优化后的性能，已经基本和手写布局一样可以达到性能随着视图嵌套的数量呈线性增长了。而在此之前的 Auto Layout，视图嵌套的数量对性能的影响是呈指数级增长的。

# alloc init

参考：

+ [alloc and init what do they actually do](https://stackoverflow.com/questions/3848990/alloc-and-init-what-do-they-actually-do)



+ `alloc` allocates a chunk of memory to hold the object, and returns the pointer.
+ `init` sets up the initial condition of the object and returns it.



参考：

+ [对象是如何初始化的（iOS）](https://draveness.me/object-init/)



> 整个对象的初始化过程其实只是**为一个分配内存空间，并且初始化 isa_t 结构体的过程**。
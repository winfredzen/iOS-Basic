# const

一般遇到`const int*`, `const int *`, `const`, 和 `int const *`很难区分

参考：

+ [What is the difference between const int*, const int * const, and int const *?](https://stackoverflow.com/questions/1143262/what-is-the-difference-between-const-int-const-int-const-and-int-const)



通过 [Clockwise/Spiral Rule](http://c-faq.com/decl/spiral.anderson.html)规则

- `int*` - pointer to int
- `int const *` - pointer to const int
- `int * const` - const pointer to int
- `int const * const` - const pointer to const int

Now the first `const` can be on either side of the type so:

- `const int *` == `int const *`
- `const int * const` == `int const * const`




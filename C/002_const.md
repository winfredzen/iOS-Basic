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



![001](https://github.com/winfredzen/iOS-Basic/blob/master/C/images/001.png)



例如

1.`int const * ptr;` 

```c++
#include <stdio.h>  
int main(void) 
{ 
    int i = 10;    
    int j = 20; 
    /* ptr is pointer to constant */
    const int *ptr = &i;     
   
    printf("ptr: %d\n", *ptr);  
    /* error: object pointed cannot be modified 错误
    using the pointer ptr */    
    *ptr = 100; 
   
    ptr = &j;          /* valid  可以*/ 
    printf("ptr: %d\n", *ptr); 
   
    return 0; 
} 
```

2.`int *const ptr;`

```c++
#include <stdio.h> 
   
int main(void) 
{ 
   int i = 10; 
   int j = 20; 
/* constant pointer to integer */
   int *const ptr = &i;     
   
   printf("ptr: %d\n", *ptr); 
   
   *ptr = 100;    /* valid  可以*/
   printf("ptr: %d\n", *ptr); 
   
   ptr = &j;        /* error 错误 */
   return 0; 
}
```










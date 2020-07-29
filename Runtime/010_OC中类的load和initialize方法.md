# OC中类的load和initialize方法

看到[寒哥教你学iOS - 经验漫谈](http://www.jianshu.com/p/cb54054d3add)中有使用load方法来加载第三方类库的情况。在《Effective Objective-C 2.0》中有一节也是讲load与initialize方法的。发现自己并没有理解，就总结下。
参考文档：

+ [NSObject的load和initialize方法](http://www.cocoachina.com/ios/20150104/10826.html)
+ [iOS初探+load和+initialize](http://readus.org/2015/07/29/ios-load-and-initialize/)
+ [Objective-C类初始化:load与initialize](http://wufawei.com/2013/06/load-initialize/)

#### load方法
原型如下

	+ (void)load

load函数调用特点如下：

+ 对于加入运行期系统中的每个类（class）及分类（category）来说，都会调用此方法，且只会调用一次。如果分类和其所属的类都调用了load方法，则先调用类里面的，再调用分类里的。
+ load方法并不像普通方法那样，它并不遵从继承规则。即如果某个类本身没有load方法，那么不管其超类是否实现load方法，系统都不会调用。

下面举个例子说明：
定义一个Pet类继承自NSObject，再定义一个Dog类继承自Pet类，在Pet类中重写laod方法，如下：

	@interface Pet : NSObject
	
	@end
	
	@implementation Pet
	
	+ (void)load
	{
	    NSLog(@"%@ %s", self, __FUNCTION__);
	}
	
	@end
	
	@interface Dog : Pet
	
	@end
	
	@implementation Dog
	
	@end

运行，输出结果如下：

	Pet +[Pet load]

可以发现，子类并没有调用父类的方法。（可以与initialize方法做比较）

#### initialize方法
其原型如下：

	+ (void)initialize

initialize函数的特点是：

+ 对每个类来说，该方法会在程序首次使用该类前调用，且只调用一次。它是由运行期系统来调用的，绝不应该通过代码直接调用。
+ initialize方法与其他消息一样，如果某个类未实现它，而其超类实现了，就会运行超类的实现代码。

同样以一个例子说明：

在Pet类中重写initialize方法，而在Dog类中并不重写initialize方法，在main函数中初始化一个Dog类实例，如下：

	@interface Pet : NSObject
	
	@end
	
	@implementation Pet
	
	+ (void)initialize
	{
	    NSLog(@"%@ %s", self, __FUNCTION__);
	}
	
	@end
	
	@interface Dog : Pet
	
	@end
	
	@implementation Dog
	
	@end
	
	int main(int argc, char * argv[]) {
	    @autoreleasepool {
	        Dog *dog = [[Dog alloc] init];
	        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
	    }
	}

输出的结果如下：

	Pet +[Pet initialize]
	Dog +[Pet initialize]

可以发现，即使Dog类没有实现initialize方法，它也会收到这条消息。这样会很奇怪，当初始化Pet类的时候，Pet类中的定义的initialize方法会运行一遍，而当初始化子类Dog类时，由于该子类并没有重写initialize方法，因此还要把父类的initialize方法再运行一次。所以，通常initialize方法的实现如下：

	+ (void)initialize
	{
	    if(self == [Pet class]){
	        NSLog(@"%@ %s", self, __FUNCTION__);
	    }
	}

#### load和initialize的区别
load和initialize之间的区别如下：

1. initialize是"惰性调用的"，即只有当用到了相关的类时，才会调用。如果某个类一直都没有使用，则其initialize方法就一直不会运行。这也就是说，应用程序无须把每个类的initialize都执行一遍。
这就与load不同，对于load来说，应用程序必须阻塞并等待所有类的load都执行完，才能继续。
2. initialize在运行期系统执行该方法时，是处于正常状态，因此从运行期系统完整度上来讲，此时可以安全使用并调用任意类中的任意方法。而且，运行期系统也能保证initialize方法一定会在“线程安全的环境（thread-safe environment）”中执行，这就是说，只有执行initialize的那个线程可以操作类或者类实例。其他线程都要先阻塞，等着initialize执行完。
load方法的问题在于，执行该方法时，运行期系统处于“脆弱状态（fragile state）”。在执行子类的load方法之前，必定会执行所有超类的load方法。


#### load和initialize方法的使用
load方法的应用场景可参考：

+ [寒哥教你学iOS - 经验漫谈](http://www.jianshu.com/p/cb54054d3add)
+ [Notification Once](http://blog.sunnyxx.com/2015/03/09/notification-once/)

需要注意的是，load方法务必实现的精简一些，也就是要尽量减少其所执行的操作，因为整个应用程序在执行load方法时都会阻塞。如果load方法中包含复杂的代码，那么应用程序在执行期间就会变的无响应。实际上，凡是想通过load在类加载之前执行某些任务的，基本都做得不太对。其真正用途在与调试程序，比如可以在分类中编写此方法，用来判断该分类是否已经正确载入系统中。也许此方法一度很有用处，但现在完全可以说：时下编写Objective-C代码时，不需要用它。

initialize方法只应该用来设置内部数据。不应该在其中调用其他方法，即便是本类自己的方法，也最好别调用。因为稍后可能还要给那些方法添加更多的功能。如果某个全局状态无法在编译期初始化，则可以放在initialize里面来做。下列代码演示了这种用法：


	@interface EOCClass : NSObject
	
	@end
	
	#import "EOCClass.h"
	
	static const int kInterval = 10;
	static NSMutableArray *kSomeObjects;
	
	@implementation EOCClass
	
	+ (void)initialize
	{
	    if (self == [EOCClass class]) {
	        kSomeObjects = [NSMutableArray new];
	    }
	}
	
	@end

整数可以在编译期定义，可变数组不行，因为其是个Objective-C对象，所以创建实例之前必须先激活运行期系统。注意，某些Objective-C对象也可以在编译期创建，例如NSString实例。
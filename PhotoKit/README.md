# PhotoKit

最权威的文档当然是官方文档了，[PhotoKit](https://developer.apple.com/documentation/photokit)

推荐教程：

+ [Getting Started with PhotoKit](https://www.kodeco.com/11764166-getting-started-with-photokit)



## 相关类介绍

### PHAsset

[PHAsset](https://developer.apple.com/documentation/photokit/phasset) 表示： A representation of an image, video, or Live Photo in the Photos library.

继承自[`PHObject`](https://developer.apple.com/documentation/photokit/phobject)

```swift
class PHAsset : PHObject
```

1.Asset只包含元数据（**metadata**）。Asset对应的image或者video数据，可能没有存储在本地设备上。根据我们使用的场景，也许不需要下载这些数据。如果使用缩率图来填充CollectionView，Photos framework 可为每个asset管理下载、生成、缓存缩率图。具体的细节，可参考[`PHImageManager`](https://developer.apple.com/documentation/photokit/phimagemanager)

2.Asset对象是不可变的。为编辑元数据（例如将photo标记为最爱），可使用photo library change block创建一个[`PHAssetChangeRequest`](https://developer.apple.com/documentation/photokit/phassetchangerequest)




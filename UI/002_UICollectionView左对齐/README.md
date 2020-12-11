# UICollectionView左对齐

在实现例如某些搜索记录的时候，需要显示搜索记录标签，这时候一般需要Tag标签左对齐

如果对collectionView不在任何的其它设置，默认一行是均匀分布的，效果如下所示：

![018](https://github.com/winfredzen/iOS-Basic/blob/master/UI/images/018.png)

代码如下：

```swift
class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var tags = [
        "衣服",
        "手机电脑",
        "小孩子的玩具电话",
        "大人的游戏机",
        "塞尔达传说之旷野之息",
        "马里奥",
        "你懂的",
        "电视小米华为",
        "源码艺术插画背景彩绘植物背景",
        "门户网站",
        "源码新闻网站",
        "源码个人网站",
        "源码企业网站"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCell", for: indexPath) as? TagCell else {
            return TagCell()
        }
        cell.textLabel.text = tags[indexPath.item]
        return cell
    }
}
```

所以需要自定义布局，这里使用方式比较简洁，没有考虑到很多的其它情况，但逻辑是一样的：

+ 每行的第一个item，设置其`x`为0（也有可能不是0，如考虑到section的缩进），其它item，在前一个item的后面做拼接，调整其`x`（注意考虑item spacing）

主要逻辑如下：

`TagLayout`

```swift
class TagLayout: UICollectionViewFlowLayout {

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect) else {
            return nil
        }
        
        for i in 0..<attributes.count {
            if attributes[i].representedElementKind == nil {//cell
                if i == 0 {
                    var frame = attributes[i].frame
                    frame.origin.x = 0
                    attributes[i].frame = frame
                    continue
                }
                let currentAttribute = attributes[i]
                let previousAttribute = attributes[i - 1]
                if currentAttribute.frame.origin.y == previousAttribute.frame.origin.y {//同一行的
                    var frame = currentAttribute.frame
                    frame.origin.x = previousAttribute.frame.origin.x + previousAttribute.frame.size.width + 10
                    currentAttribute.frame = frame
                } else { //换行了
                    var frame = currentAttribute.frame
                    frame.origin.x = 0
                    currentAttribute.frame = frame
                }
            }
        }

        return attributes
    }
    
}
```

使用`TagLayout`

```swift
        let tagLayout = TagLayout()
        tagLayout.estimatedItemSize = CGSize(width: 100, height: 40)
        collectionView.collectionViewLayout = tagLayout
```

效果如下：

![019](https://github.com/winfredzen/iOS-Basic/blob/master/UI/images/019.png)
































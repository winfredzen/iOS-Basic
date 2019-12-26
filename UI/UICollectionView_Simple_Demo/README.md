# UICollectionView Simple Demo

内容来自: [Beginning Collection Views](https://www.raywenderlich.com/5429927-beginning-collection-views)中的例子

效果如下：

![017](https://github.com/winfredzen/iOS-Basic/blob/master/UI/images/017.png)

比较简单的例子，主要是想学习下Swift创建`UICollectionView`的方式

1.如何添加section header

自定义View需要继承自`UICollectionReusableView`

使用之前需要注册

形式类似于，来自[Ultimate UICollectionView guide with iOS examples written in Swift](https://theswiftdev.com/2018/04/17/ultimate-uicollectionview-guide-with-ios-examples-written-in-swift/)：

```swift
let sectionNib = UINib(nibName: "Section", bundle: nil)
self.collectionView.register(sectionNib,
                             forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                             withReuseIdentifier: "Section")
```

```swift
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let emojiHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: EmojiHeaderView.reuseIdentifier, for: indexPath) as? EmojiHeaderView else {
            fatalError("Cannot Create EmojiHeaderView")
        }
        
        let category = emoji.sections[indexPath.section]
        emojiHeaderView.textLabel.text = category.rawValue
        
        return emojiHeaderView
        
    }
```


# Compositional Layouts

参考：

+ [Modern Collection Views with Compositional Layouts](https://www.raywenderlich.com/5436806-modern-collection-views-with-compositional-layouts)

iOS13的`UICollectionView`，推出了个Compositional Layouts

从最简单的布局来看，如下：

```swift
  func generateLayout() -> UICollectionViewLayout {
    
    //1
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
    let fullPhotoItem = NSCollectionLayoutItem(layoutSize: itemSize)
    
    //2
    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(2/3))
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: fullPhotoItem, count: 1)
    
    //3
    let section = NSCollectionLayoutSection(group: group)
    let layout = UICollectionViewCompositionalLayout(section: section)
    return layout
  }
```

item的大小充满其所在的group，group的高度为宽度的2/3，每个group有1个item，水平布局，效果如下：

![015](https://github.com/winfredzen/iOS-Basic/blob/master/UI/images/015.png)

当前的布局是1列的，如何实现2列布局？

```swift
    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1/3))
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: fullPhotoItem, count: 2)
```

![016](https://github.com/winfredzen/iOS-Basic/blob/master/UI/images/016.png)






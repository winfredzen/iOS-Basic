# Compositional Layouts

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


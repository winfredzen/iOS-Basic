/// Copyright (c) 2019 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

class AlbumDetailViewController: UIViewController {
  static let syncingBadgeKind = "syncing-badge-kind"

  enum Section {
    case albumBody
  }

  var dataSource: UICollectionViewDiffableDataSource<Section, AlbumDetailItem>! = nil
  var albumDetailCollectionView: UICollectionView! = nil

  var albumURL: URL?

  convenience init(withPhotosFromDirectory directory: URL) {
    self.init()
    albumURL = directory
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.title = albumURL?.lastPathComponent.displayNicely
    configureCollectionView()
    configureDataSource()
  }
}

extension AlbumDetailViewController {
  
  func configureCollectionView() {
    
    let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: generateLayout())
    view.addSubview(collectionView)
    collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    collectionView.backgroundColor = .systemBackground
    collectionView.delegate = self//只设置了delegate，没有设置datasource
    albumDetailCollectionView = collectionView
    
    //注册cell和SupplementaryView
    collectionView.register(PhotoItemCell.self,
                            forCellWithReuseIdentifier: PhotoItemCell.reuseIdentifer)
    collectionView.register(SyncingBadgeView.self,
                            forSupplementaryViewOfKind: AlbumDetailViewController.syncingBadgeKind,
                            withReuseIdentifier:SyncingBadgeView.reuseIdentifier)
    
  }

  //配置数据源
  func configureDataSource() {
    
    dataSource = UICollectionViewDiffableDataSource
      <Section, AlbumDetailItem>(collectionView: albumDetailCollectionView) {
        (collectionView: UICollectionView, indexPath: IndexPath, detailItem: AlbumDetailItem) -> UICollectionViewCell? in
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoItemCell.reuseIdentifer, for: indexPath) as? PhotoItemCell
          else {
            fatalError("Could not create new cell")
        }
        cell.photoURL = detailItem.thumbnailURL
        return cell
    }
    
    dataSource.supplementaryViewProvider = {
      
      (
      collectionView: UICollectionView,
      kind: String,
      indexPath: IndexPath)
        -> UICollectionReusableView? in
      // 1
      if let badgeView = collectionView.dequeueReusableSupplementaryView(
        ofKind: kind,
        withReuseIdentifier: SyncingBadgeView.reuseIdentifier,
        for: indexPath) as? SyncingBadgeView {
        // 2
        let hasSyncBadge = indexPath.row % Int.random(in: 1...6) == 0
        badgeView.isHidden = !hasSyncBadge
        return badgeView
      } else {
        fatalError("Cannot create new supplementary")
      }
      
    }

    let snapshot = snapshotForCurrentState()
    dataSource.apply(snapshot, animatingDifferences: false)
    
    

    
  }

  func generateLayout() -> UICollectionViewLayout {
    
    // Syncing badge
    let syncingBadgeAnchor = NSCollectionLayoutAnchor(
      edges: [.top, .trailing],
      fractionalOffset: CGPoint(x: -0.3, y: 0.3))
    let syncingBadge = NSCollectionLayoutSupplementaryItem(
      layoutSize: NSCollectionLayoutSize(
        widthDimension: .absolute(20),
        heightDimension: .absolute(20)),
      elementKind: AlbumDetailViewController.syncingBadgeKind,
      containerAnchor: syncingBadgeAnchor)
    
    //第一种类型，full size
    let fullPhotoItem = NSCollectionLayoutItem(
    layoutSize: NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .fractionalWidth(2/3)),
    supplementaryItems: [syncingBadge])
    fullPhotoItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2);
    
    //第二种类型
    // Second type: Main with pair
    // 3
    let mainItem = NSCollectionLayoutItem(
      layoutSize: NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(2/3),
        heightDimension: .fractionalHeight(1.0)))

    mainItem.contentInsets = NSDirectionalEdgeInsets(
      top: 2,
      leading: 2,
      bottom: 2,
      trailing: 2)

    // 2
    let pairItem = NSCollectionLayoutItem(
      layoutSize: NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1.0),
        heightDimension: .fractionalHeight(0.5)))

    pairItem.contentInsets = NSDirectionalEdgeInsets(
      top: 2,
      leading: 2,
      bottom: 2,
      trailing: 2)

    let trailingGroup = NSCollectionLayoutGroup.vertical(
      layoutSize: NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1/3),
        heightDimension: .fractionalHeight(1.0)),
      subitem: pairItem,
      count: 2)

    // 1
    let mainWithPairGroup = NSCollectionLayoutGroup.horizontal(
      layoutSize: NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1.0),
        heightDimension: .fractionalWidth(4/9)),
      subitems: [mainItem, trailingGroup])
    
    
    // Third type. Triplet
    let tripletItem = NSCollectionLayoutItem(
      layoutSize: NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1/3),
        heightDimension: .fractionalHeight(1.0)))

    tripletItem.contentInsets = NSDirectionalEdgeInsets(
      top: 2,
      leading: 2,
      bottom: 2,
      trailing: 2)

    let tripletGroup = NSCollectionLayoutGroup.horizontal(
      layoutSize: NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1.0),
        heightDimension: .fractionalWidth(2/9)),
      subitems: [tripletItem, tripletItem, tripletItem])
    
    // Fourth type. Reversed main with pair
    let mainWithPairReversedGroup = NSCollectionLayoutGroup.horizontal(
      layoutSize: NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1.0),
        heightDimension: .fractionalWidth(4/9)),
      subitems: [trailingGroup, mainItem])
    

    let nestedGroup = NSCollectionLayoutGroup.vertical(
      layoutSize: NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1.0),
        heightDimension: .fractionalWidth(16/9)),
      subitems: [
        fullPhotoItem,
        mainWithPairGroup,
        tripletGroup,
        mainWithPairReversedGroup
      ]
    )

    let section = NSCollectionLayoutSection(group: nestedGroup)

    let layout = UICollectionViewCompositionalLayout(section: section)

    
    return layout
  }

  func snapshotForCurrentState() -> NSDiffableDataSourceSnapshot<Section, AlbumDetailItem> {
    var snapshot = NSDiffableDataSourceSnapshot<Section, AlbumDetailItem>()
    snapshot.appendSections([Section.albumBody])
    let items = itemsForAlbum()
    snapshot.appendItems(items)
    return snapshot
  }

  func itemsForAlbum() -> [AlbumDetailItem] {
    guard let albumURL = albumURL else { return [] }
    let fileManager = FileManager.default
    do {
      return try fileManager.albumDetailItemsAtURL(albumURL)
    } catch {
      print(error)
      return []
    }
  }
}

extension AlbumDetailViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
    let photoDetailVC = PhotoDetailViewController(photoURL: item.photoURL)
    navigationController?.pushViewController(photoDetailVC, animated: true)
  }
}

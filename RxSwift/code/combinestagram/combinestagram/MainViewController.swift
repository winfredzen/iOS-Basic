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
import RxSwift
import RxCocoa

class MainViewController: UIViewController {
  
  @IBOutlet weak var imagePreview: UIImageView!
  @IBOutlet weak var buttonClear: UIButton!
  @IBOutlet weak var buttonSave: UIButton!
  @IBOutlet weak var itemAdd: UIBarButtonItem!
  
  private let bag = DisposeBag()
  private let images = BehaviorRelay<[UIImage]>(value: [])
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    images.subscribe(onNext: { [weak self] photos in
      guard let preview = self?.imagePreview else { return }
      preview.image = photos.collage(size: preview.frame.size)
    }).disposed(by: bag)
    
    
    images.subscribe(onNext: { [weak self] photos in
      self?.updateUI(photos: photos)
    }).disposed(by: bag)
    
    
    getRepo("ReactiveX/RxSwift")
      .subscribe(onSuccess: { json in
        print("JSON: ", json)
      },
      onError: { error in
        print("Error: ", error)
      })
      .disposed(by: bag)
    
  }
  
  @IBAction func actionClear() {
    images.accept([])
  }
  
  @IBAction func actionSave() {
    
    guard let image = imagePreview.image else { return }
    
    //    PhotoWriter.save(image)
    //      .asSingle()
    //      .subscribe { [weak self] id in
    //        self?.showMessage("Saved with id: \(id)")
    //        self?.actionClear()
    //
    //      } onError: { [weak self] error in
    //        self?.showMessage("Error", description:error.localizedDescription)
    //      }.disposed(by: bag)
    
    PhotoWriter.save(image).subscribe { [weak self] id in
      self?.showMessage("Saved with id: \(id)")
      self?.actionClear()
    } onError: { [weak self] error in
      self?.showMessage("Error", description:error.localizedDescription)
    }.disposed(by: bag)
    
    
    
  }
  
  @IBAction func actionAdd() {
    //    let newImages = images.value + [UIImage(named: "IMG_1907.jpg")!]
    //    images.accept(newImages)
    
    let photosViewController = storyboard!.instantiateViewController(withIdentifier: "PhotosViewController") as! PhotosViewController
    navigationController!.pushViewController(photosViewController, animated: true)
    
    photosViewController.selectedPhotos.subscribe(
      onNext: { [weak self] newImage in
        guard let images = self?.images else { return }
        images.accept(images.value + [newImage])
      },
      onDisposed: {
        print("Completed photo selection")
      }).disposed(by: bag)
    
  }
  
  func showMessage(_ title: String, description: String? = nil) {
    //原来的使用方式
    /*
    let alert = UIAlertController(title: title, message: description, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Close", style: .default, handler: { [weak self] _ in
                                    self?.dismiss(animated: true, completion: nil)
    }))
    present(alert, animated: true, completion: nil)
     */
    
    alert(title: title, text: description).subscribe().disposed(by: bag)
    
  }
  
  //更新UI
  func updateUI(photos: [UIImage]) {
    buttonSave.isEnabled = photos.count > 0 && photos.count % 2 == 0
    buttonClear.isEnabled = photos.count > 0
    itemAdd.isEnabled = photos.count < 6
    title = photos.count > 0 ? "\(photos.count) photos" :"Collage"
  }
  
  
}

extension MainViewController {
  
  //测试single
  
  enum DataError: Error {
    case cantParseJSON
  }
  
  
  func getRepo(_ repo: String) -> Single<[String : Any]> {
    
    return Single.create { single -> Disposable in
      
      let url = URL(string: "https://api.github.com/repos/\(repo)")!
      let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        
        if let error = error {
          single(.error(error))
          return
        }
        
        guard let data = data,
              let json = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves),
              let result = json as? [String : Any] else {
          single(.error(DataError.cantParseJSON))
          return
        }
        
        single(.success(result))
        
      }
      
      task.resume()
      
      
      return Disposables.create { task.cancel() }
      
    }
    
  }
  
  
}

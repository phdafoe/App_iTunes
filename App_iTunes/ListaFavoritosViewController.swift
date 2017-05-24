//
//  ListaFavoritosViewController.swift
//  App_iTunes
//
//  Created by formador on 24/4/17.
//  Copyright © 2017 formador. All rights reserved.
//

import UIKit
import Kingfisher

class ListaFavoritosViewController: UIViewController {
    
    //MARK: - Variables locales
    var movies = [MovieModel]()
    var collectionViewPadding : CGFloat = 0
    var dataProvider = LocalCoreDataService()
    var tapGR : UITapGestureRecognizer!
    
    
    //MARK: - IBOutlets
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false
        
        setupPadding()
        
        myCollectionView.delegate = self
        myCollectionView.dataSource = self

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    
    //MARK: - UTILS
    func loadData(){
        if let movieData = dataProvider.getFavoriteMovie(){
            movies = movieData
            myCollectionView.reloadData()
        }
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detalleSegue"{
            if let indexPathSelected = myCollectionView.indexPathsForSelectedItems?.last{
                let selectedMovie = movies[indexPathSelected.row]
                let detalleVC = segue.destination as! DetallePeliculaViewController
                detalleVC.movie = selectedMovie
            }
        }
    }

}// FIN DE LA CLASE

extension ListaFavoritosViewController : UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func setupPadding(){
        let anchoPantalla = self.view.frame.width
        collectionViewPadding = (anchoPantalla - (3 * 113))/4
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: collectionViewPadding,
                            left: collectionViewPadding,
                            bottom: collectionViewPadding,
                            right: collectionViewPadding)
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return collectionViewPadding
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if movies.count == 0{
            let imageView = UIImageView(image: #imageLiteral(resourceName: "sin-favoritas"))
            imageView.contentMode = .center
            myCollectionView.backgroundView = imageView
        }else{
            myCollectionView.backgroundView = UIView()
        }
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let customCell = myCollectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PeliculaCustomCell
        
        let movieData = movies[indexPath.row]
        
        //metodo de creacion de celda
        configuredCell(customCell, withMovie: movieData)
        
        return customCell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 113, height: 170)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "detalleSegue", sender: self)
    }


    //MARK: - UTILS - DELEGATE
    func configuredCell(_ cell : PeliculaCustomCell, withMovie movie: MovieModel){
        if let imageData = movie.image{
            cell.myImageMovie?.kf.setImage(with: ImageResource(downloadURL: URL(string: imageData)!),
                                          placeholder: #imageLiteral(resourceName: "img-loading"),
                                          options: nil,
                                          progressBlock: nil,
                                          completionHandler: nil)

        }
    }
    
}



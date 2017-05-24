//
//  DetallePeliculaViewController.swift
//  App_iTunes
//
//  Created by formador on 24/4/17.
//  Copyright © 2017 formador. All rights reserved.
//

import UIKit
import Kingfisher

class DetallePeliculaViewController: UIViewController {
    
    //MARK: - Variables locales
    var movie : MovieModel?
    let dataProvider = LocalCoreDataService()
    
    
    //MARK: - IBOutlets
    @IBOutlet weak var myImagePelicula: UIImageView!
    @IBOutlet weak var myTituloPelicula: UILabel!
    @IBOutlet weak var myDirectorPelicula: UILabel!
    @IBOutlet weak var myCategoriaPelicula: UILabel!
    @IBOutlet weak var myButtonMeInteresaBTN: UIButton!
    @IBOutlet weak var mySinopsisTV: UITextView!
    
    //MARK: - IBActions
    
    @IBAction func peliculaFavoritaACTION(_ sender: Any) {
        if let movieData = movie{
            dataProvider.markUnMarkFavorite(movieData)
            configuredFavoriteBTN()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let movieData = movie{
            //Imagen
            if let imageData = movieData.image{
                myImagePelicula.kf.setImage(with: ImageResource(downloadURL: URL(string: imageData)!))
            }
            //Titulo
            myTituloPelicula.text = movieData.title
            self.title = movieData.title
            //Summary
            mySinopsisTV.text = movieData.summary
            //categoria
            myCategoriaPelicula.text = movieData.category
            //director
            myDirectorPelicula.text = movieData.director
            
            configuredFavoriteBTN()
        }
        
    }

    
    //MARK: - UTILS
    func configuredFavoriteBTN(){
        if let movieData = movie{
            if dataProvider.isFavorite(movieData){
                myButtonMeInteresaBTN.setBackgroundImage(#imageLiteral(resourceName: "btn-on"), for: .normal)
                myButtonMeInteresaBTN.setTitle("Quiero verla!", for: .normal)
            }else{
                myButtonMeInteresaBTN.setBackgroundImage(#imageLiteral(resourceName: "btn-off"), for: .normal)
                myButtonMeInteresaBTN.setTitle("No me interesa!", for: .normal)
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

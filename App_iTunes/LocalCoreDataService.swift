//
//  LocalCoreDataService.swift
//  App_iTunes
//
//  Created by formador on 24/4/17.
//  Copyright © 2017 formador. All rights reserved.
//

import Foundation
import CoreData

class LocalCoreDataService{
    
    //1 -> desde local service se va a invocar a remote service
    let remoteMovieService = RemoteItunesMovieService()
    let stack = CoreDataStack.shared
    
    func searchMovies(_ byTerm : String, remoteHandler : @escaping ([MovieModel]?) -> ()){
        //2
        remoteMovieService.searchMovies(byTerm) { (result) in
            if let movieData = result{
                var modelMovies = [MovieModel]()
                for c_movie in movieData{
                    let obj = MovieModel(pId: c_movie["id"]!,
                                         pTitle: c_movie["title"]!,
                                         pOrder: nil,
                                         pSummary: c_movie["summary"]!,
                                         pImage: c_movie["image"]!,
                                         pCategory: c_movie["category"]!,
                                         pDirector: c_movie["director"]!)
                    modelMovies.append(obj)
                }
                remoteHandler(modelMovies)
            }else{
                print("Error mietras se llama a los servicios de iTunes")
                remoteHandler(nil)
            }
        }
    }
    
    func topMovie(_ localHandler : @escaping ([MovieModel]?) -> (), remoteHandler : @escaping ([MovieModel]?) -> ()){
        
        localHandler(queryTopMovies())
        
        
    }
    
    func queryTopMovies() -> [MovieModel]?{
        let context = stack.persistentContainer.viewContext
        let request : NSFetchRequest<MovieManager> = MovieManager.fetchRequest()
    }
    
    
    
    
    
}

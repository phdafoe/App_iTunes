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
        
        remoteMovieService.getTopMovies { (result) in
            if let moviesData = result{
                //preceso de sync que lo que haga es que nos marque todos los objetos como no sincronizados
                self.markAllMoviesUnsync()
                var order = 1
                for c_movieDiccionario in moviesData{
                    //aqui tenemos que consultar la pelicula si la tenemos en CoreData asi que hacemos otro metodo
                    if let movieData = self.getMovieById(c_movieDiccionario["id"]!, favorito: false){
                        //update
                        self.updateMovie(c_movieDiccionario,
                                         movie: movieData,
                                         order: order)
                    }else{
                        //insert
                        self.insertMovie(c_movieDiccionario,
                                         order: order)
                    }
                    order += 1
                }
                //borrar lo no sincronizado
                self.removeAllnotFavoriteMovies()
                
                remoteHandler(self.queryTopMovies())
                
            }else{
                print("Error mientras se llama a los servicios de iTunes")
                remoteHandler(nil)
            }
        }
    }
    
    func queryTopMovies() -> [MovieModel]?{
        
        let context = stack.persistentContainer.viewContext
        
        let request : NSFetchRequest<MovieManager> = MovieManager.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "order", ascending: true)
        
        request.sortDescriptors = [sortDescriptor]
        
        let customPredicate = NSPredicate(format: "favorito = \(false)")
        
        request.predicate = customPredicate
        
        do{
            let fetchMovies = try context.fetch(request)
            // Creamos un array de pelicula
            var movie = [MovieModel]()
            
            for c_manage in fetchMovies{
                
                movie.append(c_manage.mappedObject())
            }
            return movie
        }catch{
            print("Error mientras se obtienen las peliculas desde CoreData")
            return nil
        }
    }
    
    func markAllMoviesUnsync(){
        let context = stack.persistentContainer.viewContext
        let request : NSFetchRequest<MovieManager> = MovieManager.fetchRequest()
        let customPredicate = NSPredicate(format: "favorito = \(false)")
        request.predicate = customPredicate
        do{
            let fetchMovies = try context.fetch(request)
            for c_manage in fetchMovies{
                //vamos a cambiar su propiedad sync
                c_manage.sync = false
            }
        }catch{
            print("Error mientras se actualizan las peliculas desde CoreData")
        }
    }
    
    func getMovieById(_ id : String, favorito : Bool) -> MovieManager?{
        
        let context = stack.persistentContainer.viewContext
        
        let request : NSFetchRequest<MovieManager> = MovieManager.fetchRequest()
        
        let customPredicate = NSPredicate(format: "id = \(id) and favorito = \(favorito)")
        
        request.predicate = customPredicate
        
        do{
            let fetchmovies = try context.fetch(request)
            // si tiene algun registro me debe retornar uno
            if fetchmovies.count > 0{
                return fetchmovies.last
            }else{
                return nil
            }
        }catch{
            print("Error mientras se obtienen peliculas desde CoreData")
            return nil
        }
    }
    
    func insertMovie(_ movieDiccionario : [String : String], order : Int){
        
        let context = stack.persistentContainer.viewContext
        let movie = MovieManager(context: context)
        movie.id = movieDiccionario["id"]
        updateMovie(movieDiccionario,
                    movie: movie,
                    order: order)
    }
    
    
    func updateMovie(_ movieDiccionario : [String : String], movie : MovieManager, order : Int){
        
        let context = stack.persistentContainer.viewContext
        movie.order = Int16(order)
        movie.title = movieDiccionario["title"]
        movie.summary = movieDiccionario["summary"]
        movie.category = movieDiccionario["category"]
        movie.director = movieDiccionario["director"]
        movie.image = movieDiccionario["image"]
        movie.sync = true
        
        do{
            try context.save()
        }catch{
            print("Error mientras se actualiza el CoreData")
        }
    }
    
    func removeAllnotFavoriteMovies(){
        let context = stack.persistentContainer.viewContext
        let request : NSFetchRequest<MovieManager> = MovieManager.fetchRequest()
        let customPredicate = NSPredicate(format: "favorito = \(false)")
        request.predicate = customPredicate
        do{
            let fetchMovies  = try context.fetch(request)
            for c_manageMovie in fetchMovies{
                if !c_manageMovie.sync{
                    context.delete(c_manageMovie)
                }
            }
            try context.save()
        }catch{
            print("Error mientras se esta borrando del CoreData")
        }
    }
    
    func getFavoriteMovie() -> [MovieModel]?{
        
        let context = stack.persistentContainer.viewContext
        let request : NSFetchRequest<MovieManager> = MovieManager.fetchRequest()
        let customPredicate = NSPredicate(format: "favorito = \(true)")
        request.predicate = customPredicate
        do{
            let fetchMovies = try context.fetch(request)
            var movies = [MovieModel]()
            
            for c_movieData in fetchMovies {
                movies.append(c_movieData.mappedObject())
            }
            return movies
            
        }catch{
            print("Error mientras obtenemos los favoritos")
            return nil
        }
        
        
    }
    
    func isFavorite (_ movie : MovieModel) -> Bool{
        if let _ = getMovieById(movie.id!, favorito: true){
            return true
        }else{
            return false
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}

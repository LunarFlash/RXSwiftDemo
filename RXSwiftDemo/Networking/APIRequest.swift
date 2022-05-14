//
//  APIRequest.swift
//  RXSwiftDemo
//
//  Created by Terry Wang on 5/13/22.
//  https://medium.com/swlh/creating-your-first-rxswift-app-fe1e696c0528

import Foundation
import RxSwift

class APIRequest {
    let baseURL = URL(string: "https://reqres.in/api/users")!
    let session = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask? = nil

    func callAPI<T: Codable>() -> Observable<T> {
        // create an observable and emit the state as per response
        return Observable<T>.create { observer in
            self.dataTask = self.session.dataTask(with: self.baseURL, completionHandler: { data, response, error in
                do {
                    let model: DataModel = try JSONDecoder().decode(DataModel.self, from: data ?? Data())
                    observer.onNext(model.data as! T)
                } catch let error {
                    observer.onError(error)
                }
                observer.onCompleted()
            })
            self.dataTask?.resume()
            return Disposables.create {
                self.dataTask?.cancel()
            }
        }
    }
}

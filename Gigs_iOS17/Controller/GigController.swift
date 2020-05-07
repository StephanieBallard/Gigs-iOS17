//
//  GigController.swift
//  Gigs_iOS17
//
//  Created by Stephanie Ballard on 5/5/20.
//  Copyright © 2020 Stephanie Ballard. All rights reserved.
//

import UIKit

class GigController {
    
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
    }
    
    enum NetworkError: Error {
        case noData
        case failedSignUp
        case failedSignIn
        case noToken
        case failedCreatingGig
    }
    
    var bearer: Bearer?
    var gigs: [Gig] = []
    
    private let baseURL = URL(string: "https://lambdagigapi.herokuapp.com/api")!
    private lazy var signUpURL = baseURL.appendingPathComponent("/users/signup")
    private lazy var logInURL = baseURL.appendingPathComponent("/users/login")
    private lazy var allGigsURL = baseURL.appendingPathComponent("/gigs")
    private lazy var createGigURL = baseURL.appendingPathComponent("/gigs")
    
    private lazy var jsonEncoder = JSONEncoder()
    private lazy var jsonDecoder = JSONDecoder()
    
    func signUp(with user: User, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        print("signUpURL = \(signUpURL.absoluteString)")
        
        var request = URLRequest(url: signUpURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
        } catch {
            print("Error encoding user: \(error)")
            completion(.failure(.failedSignUp))
            return
        }
        
        URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                print("Sign up failed with error: \(error)")
                completion(.failure(.failedSignUp))
                return
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                print("Sign up was unsuccessful")
                completion(.failure(.failedSignUp))
                return
            }
            
            completion(.success(true))
        }.resume()
        
    }
    
    func login(with user: User, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        print("logInURL = \(logInURL.absoluteString)")
        
        var request = URLRequest(url: logInURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
        } catch {
            print("Error encoding user object: \(error)")
            completion(.failure(.failedSignIn))
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Sign in failed with error: \(error)")
                completion(.failure(.failedSignIn))
                return
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                print("Sign in was unsuccessful: \(response)")
                completion(.failure(.failedSignIn))
                return
            }
            
            guard let data = data else {
                print("Data was not received")
                completion(.failure(.noData))
                return
            }
            do {
                let token = try self.jsonDecoder.decode(Bearer.self, from: data)
                self.bearer = token
                print("Sign in function \(self.bearer?.token)")
                completion(.success(true))
            } catch {
                print("Error decoding bearer: \(error)")
                completion(.failure(.failedSignIn))
                return
            }
        }.resume()
    }
    
    func fetchGigs(completion: @escaping (Result<[Gig], NetworkError>) -> Void) {
        print("fetchGigsURL = \(allGigsURL.absoluteString)")
        
        guard let bearer = bearer else {
            completion(.failure(.noToken))
            return
        }
        
        var request = URLRequest(url: allGigsURL)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error receiving Gigs: \(error)")
                completion(.failure(.noData))
                return
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                print("Error receiving \(response)")
                completion(.failure(.noToken))
                return
            }
            
            guard let data = data else {
                print("No data received from fetching gigs")
                completion(.failure(.noData))
                return
            }
            do {
                self.jsonDecoder.dateDecodingStrategy = .iso8601
                let gigs = try self.jsonDecoder.decode([Gig].self, from: data)
                completion(.success(gigs))
            } catch {
                print("Error decoding gigs: \(error)")
                completion(.failure(.noData))
            }
        }.resume()
    }
    
    func createGig(with gig: Gig, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        print("createGigsURL = \(createGigURL)")
        
        var request = URLRequest(url: createGigURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(bearer?.token ?? "0")", forHTTPHeaderField: "Authorization")
        do {
            let jsonData = try jsonEncoder.encode(gig)
            request.httpBody = jsonData
        } catch {
            print("Error encoding gig: \(error)")
            completion(.failure(.failedCreatingGig))
            return
        }
        
        URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                print("Error creating gig: \(error)")
                completion(.failure(.failedCreatingGig))
                return
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                print("Creating gig was unsuccessful: \(response)")
                completion(.failure(.failedCreatingGig))
                return
            }
            
            completion(.success(true))
        }.resume()
    }
}

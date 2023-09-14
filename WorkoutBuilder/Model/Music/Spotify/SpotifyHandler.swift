//
//  SpotifyHandler.swift
//  WorkoutBuilder
//
//  Created by Lilian Grasset on 07/09/2023.
//

import Foundation
import KeychainSwift

class SpotifyHandler: NSObject {
    
    // MARK: Properties
    
    static let shared = SpotifyHandler()
    
    private var responseCode: String? {
        didSet {
            fetchAccessToken { (dictionary, error) in
                if let error = error {
                    print("Fetching token request error \(error)")
                    return
                }
                let accessToken = dictionary!["access_token"] as! String
                DispatchQueue.main.async {
                    self.appRemote.connectionParameters.accessToken = accessToken
                    self.appRemote.connect()
                }
            }
        }
    }
    
    private var accessToken: String? {
        set {
            let keychain = KeychainSwift()
            guard let newValue = newValue else {
                keychain.delete(Constant.kAccessTokenKey)
                return
            }
            keychain.set(newValue, forKey: Constant.kAccessTokenKey)
        }
        
        get {
            let keychain = KeychainSwift()
            return keychain.get(Constant.kAccessTokenKey)
        }
    }
    
    private lazy var sessionManager: SPTSessionManager = {
        let configuration = Constant.spotifyConfiguration
        if let tokenSwapURL = URL(string: "https://localhost:0000/api/token"),
           let tokenRefreshURL = URL(string: "https://localhost:0000/api/refresh_token") {
            configuration.tokenSwapURL = tokenSwapURL
            configuration.tokenRefreshURL = tokenRefreshURL
            configuration.playURI = ""
        }
        let manager = SPTSessionManager(configuration: configuration, delegate: self)
        return manager
    }()
    
    private lazy var appRemote: SPTAppRemote = {
        let configuration = Constant.spotifyConfiguration
        if let tokenSwapURL = URL(string: "https://localhost:0000/api/token"),
           let tokenRefreshURL = URL(string: "https://localhost:0000/api/refresh_token") {
            configuration.tokenSwapURL = tokenSwapURL
            configuration.tokenRefreshURL = tokenRefreshURL
        }
        let appRemote = SPTAppRemote(configuration: configuration, logLevel: .debug)
        appRemote.connectionParameters.accessToken = self.accessToken
        appRemote.delegate = self
        return appRemote
    }()
    
    var currentTrack: SPTAppRemoteTrack?
    var trackImage: UIImage?
    
    // MARK: Initilizer
    
    private override init () {}
    
    // MARK: Functions
    
    func initiate() {
        let scope: SPTScope = [.appRemoteControl]
        sessionManager.initiateSession(with: scope, options: .default)
    }
    
    func connect(url: URL) {
        let parameters = appRemote.authorizationParameters(from: url);
        
        if let access_token = parameters?[SPTAppRemoteAccessTokenKey] {
            appRemote.connectionParameters.accessToken = access_token
            self.accessToken = access_token
        } else if let responseCode = parameters?["code"] {
            self.responseCode = responseCode
        } else if let error_description = parameters?[SPTAppRemoteErrorDescriptionKey] {
            // Show the error
            print(error_description)
        }
    }
    
    func togglePlayPause(isNowPaused: Bool) {
        if isNowPaused {
            appRemote.playerAPI?.pause()
        } else {
            appRemote.playerAPI?.resume()
        }
    }
    
    func next() {
        appRemote.playerAPI?.skip(toNext: nil)
    }
    
    func previous() {
        appRemote.playerAPI?.skip(toPrevious: nil)
    }
}

extension SpotifyHandler: SPTAppRemoteDelegate, SPTAppRemotePlayerStateDelegate {
    func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
        // Connection was successful, you can begin issuing commands
        print("connected")
        self.appRemote.playerAPI?.delegate = self
        self.appRemote.playerAPI?.subscribe(toPlayerState: { (result, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
            }
        })
        let notification = Notification(name: Notification.Name("MusicPlayerConnected"))
        NotificationCenter.default.post(notification)
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
        print("disconnected")
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
        print("failed appRemote")
    }
    
    func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
        currentTrack = playerState.track
        fetchArtwork(for: playerState.track)

        let notificationName = Notification.Name("UpdateMusicPlayer")
        NotificationCenter.default.post(name: notificationName, object: nil)
        
        debugPrint("Track name: \(playerState.track.name)")
        debugPrint("-> \(playerState.track.artist.name)")
    }
}

extension SpotifyHandler: SPTSessionManagerDelegate {
    func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {
        print("failed session", error)
    }
    
    func sessionManager(manager: SPTSessionManager, didRenew session: SPTSession) {
        print("renewed session", session)
    }
    
    func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
        print("initiate", session)
    }
}

extension SpotifyHandler {
    func fetchAccessToken(completion: @escaping ([String: Any]?, Error?) -> Void) {
        let url = URL(string: "https://accounts.spotify.com/api/token")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let spotifyAuthKey = "Basic \((Constant.SpotifyClientID + ":" + Constant.SpotifyClientSecret).data(using: .utf8)!.base64EncodedString())"
        request.allHTTPHeaderFields = ["Authorization": spotifyAuthKey,
                                       "Content-Type": "application/x-www-form-urlencoded"]
        
        var requestBodyComponents = URLComponents()
        let scopeAsString = "appRemoteControl"
        
        requestBodyComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constant.SpotifyClientID),
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: responseCode!),
            URLQueryItem(name: "redirect_uri", value: Constant.SpotifyRedirectURL.absoluteString),
            URLQueryItem(name: "code_verifier", value: ""), // not currently used
            URLQueryItem(name: "scope", value: scopeAsString),
        ]
        
        request.httpBody = requestBodyComponents.query?.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,                              // is there data
                  let response = response as? HTTPURLResponse,  // is there HTTP response
                  (200 ..< 300) ~= response.statusCode,         // is statusCode 2XX
                  error == nil else {                           // was there no error, otherwise ...
                print("Error fetching token \(error?.localizedDescription ?? "")")
                return completion(nil, error)
            }
            let responseObject = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
            print("Access Token Dictionary=", responseObject ?? "")
            completion(responseObject, nil)
        }
        task.resume()
    }
    
    func fetchArtwork(for track: SPTAppRemoteTrack) {
        appRemote.imageAPI?.fetchImage(forItem: track, with: CGSize.zero)
        { [weak self] (image, error) in
            if let error = error {
                print("Error fetching track image: " + error.localizedDescription)
            } else if let image = image as? UIImage {
                self?.trackImage = image
            }
        }
    }
}

//
//  SpotifyHandlerTests.swift
//  WorkoutBuilderTests
//
//  Created by Lilian Grasset on 06/12/2023.
//

import XCTest
@testable import WorkoutBuilder

final class SpotifyHandlerTests: XCTestCase {
    
    func makeSession() -> URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self] + (configuration.protocolClasses ?? [])
        
        return URLSession(configuration: configuration)
    }
    
    func testFetchAccessTokenSuccess() {
        let url = "/api/token"
        let response = HTTPURLResponse(url: URL(string: url)!, statusCode: 200, httpVersion: nil, headerFields: [:])
        let data: Data = try! JSONSerialization.data(withJSONObject: ["access_token": "12345"])
        
        MockURLProtocol.mockURLs[url] = (data: data, response: response, error: nil)
        
        let expectation = XCTestExpectation()
        let spotifyHandler = SpotifyHandler(session: makeSession())
        spotifyHandler.fetchAccessToken { dictionary, error in
            if let error = error {
                XCTFail(error.localizedDescription)
            }
            
            let accessToken = dictionary?["access_token"] as? String
            XCTAssertNotNil(accessToken)
            XCTAssertEqual(accessToken, "12345")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }
    
    func testFetchAccessTokenFailed() {
        let url = "/api/token"
        
        let error = DummyError()
        
        MockURLProtocol.mockURLs[url] = (data: nil, response: nil, error: error)
        
        let expectation = XCTestExpectation()
        let spotifyHandler = SpotifyHandler(session: makeSession())
        spotifyHandler.fetchAccessToken { dictionary, error in
            if let error = error {
                XCTAssertNotNil(error)
            }
            
            let accessToken = dictionary?["access_token"] as? String
            XCTAssertNil(accessToken)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }
    
    func testfetchUserPlaylistsSuccess() {
        let url = "/v1/me/playlists"
        let response = HTTPURLResponse(url: URL(string: url)!, statusCode: 200, httpVersion: nil, headerFields: [:])
        let bundle = Bundle(for: SpotifyHandlerTests.self)
        let dataUrl = bundle.url(forResource: "Playlists", withExtension: "json")
        let data = try! Data(contentsOf: dataUrl!)
        
        MockURLProtocol.mockURLs[url] = (data: data, response: response, error: nil)
        
        let expectation = XCTestExpectation()
        let spotifyHandler = SpotifyHandler(session: makeSession())
        
        spotifyHandler.fetchUserPlaylists { data, error in
            if let error = error {
                XCTFail(error.localizedDescription)
            }
            
            guard let playlists = data?.items else {
                XCTFail("No data")
                return
            }
            
            XCTAssertFalse(playlists.isEmpty)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.5)
    }
    
    func testfetchUserPlaylistsFailed() {
        let url = "/v1/me/playlists"
        let error = DummyError()
        
        MockURLProtocol.mockURLs[url] = (data: nil, response: nil, error: error)
        
        let expectation = XCTestExpectation()
        let spotifyHandler = SpotifyHandler(session: makeSession())
        
        spotifyHandler.fetchUserPlaylists { data, error in
            if let error = error {
                XCTAssertNotNil(error)
            }
            
            guard let _ = data?.items else {
                XCTAssertNil(data)
                expectation.fulfill()
                return
            }
        }
        
        wait(for: [expectation], timeout: 0.5)
    }
    
    func testfetchUserAlbumsSuccess() {
        let url = "/v1/me/albums"
        let response = HTTPURLResponse(url: URL(string: url)!, statusCode: 200, httpVersion: nil, headerFields: [:])
        let bundle = Bundle(for: SpotifyHandlerTests.self)
        let dataUrl = bundle.url(forResource: "Albums", withExtension: "json")
        let data = try! Data(contentsOf: dataUrl!)
        
        MockURLProtocol.mockURLs[url] = (data: data, response: response, error: nil)
        
        let expectation = XCTestExpectation()
        let spotifyHandler = SpotifyHandler(session: makeSession())
        
        spotifyHandler.fetchUserAlbums { data, error in
            if let error = error {
                XCTFail(error.localizedDescription)
            }
            
            guard let albums = data?.albums else {
                XCTFail("No data")
                return
            }
            
            XCTAssertFalse(albums.isEmpty)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.5)
    }
    
    func testfetchUserAlbumsFailed() {
        let url = "/v1/me/albums"
        let error = DummyError()
        
        MockURLProtocol.mockURLs[url] = (data: nil, response: nil, error: error)
        
        let expectation = XCTestExpectation()
        let spotifyHandler = SpotifyHandler(session: makeSession())
        
        spotifyHandler.fetchUserAlbums { data, error in
            if let error = error {
                XCTAssertNotNil(error)
            }
            
            guard let _ = data?.albums else {
                XCTAssertNil(data)
                expectation.fulfill()
                return
            }
        }
        
        wait(for: [expectation], timeout: 0.5)
    }
}

private class DummyError: Error {}

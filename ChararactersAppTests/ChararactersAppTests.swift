//
//  ChararactersAppTests.swift
//  ChararactersAppTests
//
//  Created by Dina Mansour  on 14/10/2024.
//

import Testing
import Combine
@testable import ChararactersApp
import XCTest

struct ChararactersAppTests {

    var charactersVm = CharacterService()
    var cancellable: AnyCancellable?
    
    @Test func testRequestAllCharacters() {
            
            let expectation = XCTestExpectation(description: "Request all characters")
            var assert = false
        let characters = charactersVm.characters
        characters.forEach {
            print("🦸 Character: \($0.name)")
        }
                expectation.fulfill()

        if expectation.expectedFulfillmentCount == 1 {
            assert = true
        }
        XCTAssertTrue(assert)
              
        }
        
    @Test func testRequestFilterCharacters() {
            
            let expectation = XCTestExpectation(description: "Request characters by filter parameter")
            var assert = false
            let characters = charactersVm.filteredCharacters(filter: .alive)
            characters.forEach {
                           print("🦸 Character: \($0.name)")
                       }
            expectation.fulfill()
        if expectation.expectedFulfillmentCount == 1 {
            assert = true
        }
        
          
        XCTAssertTrue(assert)
           
        }
    

}

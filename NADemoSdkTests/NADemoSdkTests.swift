//
//  NADemoSdkTests.swift
//  NADemoSdkTests
//
//  Created by Nageshwar Agrahari on 05/10/23.
//

import XCTest
@testable import NADemoSdk

final class NADemoSdkTests: XCTestCase {
    var naDemoSdk: NSDemoSdk!

      override func setUp() {
          naDemoSdk = NSDemoSdk()
      }

      func testAdd() {
          XCTAssertEqual(naDemoSdk.add(a: 1, b: 1), 2)
      }

}

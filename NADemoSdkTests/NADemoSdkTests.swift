//
//  NADemoSdkTests.swift
//  NADemoSdkTests
//
//  Created by Nageshwar Agrahari on 05/10/23.
//

import XCTest
@testable import NADemoSdk

final class NADemoSdkTests: XCTestCase {
    var naDemoSdk: NADemoSdk!

      override func setUp() {
          naDemoSdk = NADemoSdk()
      }

      func testAdd() {
          XCTAssertEqual(naDemoSdk.add(a: 1, b: 1), 2)
      }

}

import XCTest

import platformTests

var tests = [XCTestCaseEntry]()
tests += platformTests.allTests()
XCTMain(tests)

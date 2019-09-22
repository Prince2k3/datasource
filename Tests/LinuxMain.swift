import XCTest

import DataSourceTests

var tests = [XCTestCaseEntry]()
tests += DataSourceTests.allTests()
XCTMain(tests)

# NearbyWiki

## Description
The NearbyWiki is a simple iOS application to fetch the current location of the device and get nearby English language Wikipedia articles. It allows to show route and steps.
Branch: `develop`

To use this app GOOGLE_API_KEY should be configured under Configurations folder.

## Tech stack
- iOS version: `12.0`
- Swift version: `5`
- Dependencies Manager: `Cococa Pods`
- Architecture patterns: `Model-View-Presenter`, `Coordiantor`, `Dependency Injection`, `Delegate`
- APIs: `Wikipedia`, `Googole Directions API`
- Tests coverage: `Unit Tests`

## Dependencies
##### Main: 
- pod 'SwiftLint' - Linter for Swift
- pod 'SwiftGen' - Resources code generator
- pod 'Swinject' - Dependecy Injection container
- pod 'Moya/RxSwift' - Network layer abstraction

##### Test:
- pod 'Quick' - behavior-driven development framework
- pod 'Nimble' - framework for test expectation
- pod 'MockSix' -  object mocking framework
- pod 'NimbleMockSix' - Nimble extension for MockSix

## Installation
1. Change branch to `develop`
1. Run `pod install`
2. Open `NearbyWiki.xcworkspace`
3. To build project `Command + B`
3. To run project `Command + R`
4. To run tests `Command + U`

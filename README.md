# Restler

[![Package Build Status](https://github.com/railwaymen/restler/workflows/Package%20Actions/badge.svg)](https://github.com/railwaymen/restler/actions)
[![Example App Build Status](https://github.com/railwaymen/restler/workflows/Example%20App%20Actions/badge.svg)](https://github.com/railwaymen/restler/actions)
[![Coverage Status](https://coveralls.io/repos/github/railwaymen/restler/badge.svg?branch=master)](https://coveralls.io/github/railwaymen/restler?branch=master)

The Restler framework has been built to use features of the newest versions of Swift. Inspiration for it is Vapor library for building Server-side with Swift. What we love is functional programming, so you can build your desired request just calling some chained functions. The main goal of the framework is to provide nice interface for making API requests the easiest as possible and the fastest as possible.


## [Full Documentation](Documentation/Reference)

## List of Content

1. [Instalation](#instalation)
2. [Usage](#usage)
  - [Examples](#examples)
  - [Error Parser](#error-parser)
  - [Header](#header)
3. [Contribution](#contribution)
  - [Dependencies](#dependencies)
    - [Gems](#gems)

## Instalation

Nothing is easier there - you just add the framework to the **Swift Package Manager** dependecies if you use one.

Otherwise you can use **CocoaPods**. If you use one simply add to your `Podfile`:

```ruby
...
pod 'Restler'
...
```

and call in your console:

```bash
pod install
```

## Usage

Import the framework to the project:

```swift
import Restler
```

and call it!

### Examples

#### GET

```swift
Restler(baseURL: myBaseURL)
  .get(Endpoint.myProfile)
  // Makes GET request to the given endpoint.

  .query(anEncodableQueryObject)
  // Encodes object and puts it in query for GET request.

  .failureDecode(ErrorToDecodeOnFailure.self)
  // If error will occure, error parser would try to decode the given type.

  .setInHeader("myNewTemporaryToken", forKey: "token")
  // Sets the specified value for given key in the header only for this request.

  .decode(Profile.self)
  // Decodes Profile object on successful response. If it is not optional, still failure handler can be called.

  .onSuccess({ profile in
    updateProfile(with: profile)
  })
  // Handler called if Restler would successfully end request.

  .onCompletion({ _ in
    hideLoadingIndicator()
  })
  // Handler called on completion of the request whatever the result would be.

  .start()
  // Create and start data task.
```

#### POST

```swift
Restler(baseURL: myBaseURL)
  .post(Endpoint.myProfile)
  // Makes POST request to the given endpoint

  .body(anEncodableQueryObject)
  // Encodes object and puts it into body of the request. Ignored if request method doesn't support it.

  .failureDecode(ErrorToDecodeOnFailure.self)   
  .decode(Profile.self)
  .onFailure({ profile in
    updateProfile(with: profile)
  })
  // Handler called if request has failed.

  .onCompletion({ _ in
    hideLoadingIndicator()
  })
  .start()
```

### Error parser

If you don't want to add the same error to be parsed on failure of every request, simply add the error directly to the error parser of the Restler object.

```swift
restler.errorParser.decode(ErrorToDecodeOnFailure.self)
```

If you don't want to decode it anymore, simply stop decoding it:

```swift
restler.errorParser.stopDecoding(ErrorToDecodeOnFailure.self)
```

### Header

Setting header values is very easy. Simply set it as a dictionary:

```swift
restler.header = [
  .contentType: "application/json",
  .cacheControl: "none",
  "customKey": "value"
]
restler.header[.cacheControl] = nil
```

If you're using basic authentication at "Authorization" key, simply provide username and password to header:

```swift
restler.header.setBasicAuthentication(username: "me", password: "password")
```

## Contribution

If you want to contribute in this framework, simply put your pull request here.
If you have found any bug, file it in the issues.
If you would like Restler to do something else, create an issue for feature request.

### Dependencies

#### Gems

- [cocoapods](https://rubygems.org/gems/cocoapods) 1.8.4
- [fastlane](https://rubygems.org/gems/fastlane) 2.143.0
- [slather](https://rubygems.org/gems/slather) 2.4.7
- [xcpretty](https://rubygems.org/gems/xcpretty) 0.3.0

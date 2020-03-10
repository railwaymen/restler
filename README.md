# Restler

Framework for type-safe, functional and easy RESTful API requests.

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

and call it:

```swift
Restler(baseURL: myBaseURL)
  .get(Endpoint.myProfile)
  .query(anEncodableQueryObject)
  .failureDecode(ErrorToDecodeOnFailure.self)
  .decode(Profile.self)
  .onSuccess({ profile in
    updateProfile(with: profile)
  })
  .onCompletion({ _ in
    hideLoadingIndicator()
  })
  .start()
```

## Contribution

### Dependencies

#### Gems

- [cocoapods](https://rubygems.org/gems/cocoapods) 1.8.4
- [fastlane](https://rubygems.org/gems/fastlane) 2.143.0
- [slather](https://rubygems.org/gems/slather) 2.4.7
- [xcpretty](https://rubygems.org/gems/xcpretty) 0.3.0

<img src="art/pspdfkit-swift.png" width="100">

# PSPDFKitSwift

`PSPDFKitSwift.framework` is a set of wrappers and extensions that improve the Swift experience when working with PSPDFKit for iOS. The blog post [First-Class Swift API for Objective-C Frameworks](https://pspdfkit.com/blog/2018/first-class-swift-api-for-objective-c-frameworks/) explains the benefits of and methods used in this project.

**Note**: [PSPDFKit for iOS](https://pspdfkit.com/pdf-sdk/ios/) is a commercial product and requires a [paid license](https://pspdfkit.com/sales/). Please sign up for a [free trial](http://pspdfkit.com/try) to receive an evaluation license if you don’t yet have a production license.

## Usage

To use the Swift wrappers and extensions, you need to import the `PSPDFKitSwift` module:

```swift
import PSPDFKitSwift
```

Once this is done, you can work with the PSPDFKit and PSPDFKitUI frameworks as usual. The only change you will notice is that there are several improvements to the framework APIs when working from Swift. Check out the [documentation](./docs) to discover all the wrapped APIs you may want to adopt in your code.

**Note:** There is no need to import the `PSPDFKit` module separately.

## Getting Started

Make sure you have access to PSPDFKit either as a customer or by signing up for a [free trial](https://pspdfkit.com/try/).

### Using CocoaPods

We assume you are familiar with [CocoaPods](https://cocoapods.org). If not, please consult the [CocoaPods documentation](https://guides.cocoapods.org/) first. 

To get a CocoaPods-based integration up and running, you need to add `PSPDFKitSwift` as a dependency, and then modify your existing [PSPDFKit integration](https://pspdfkit.com/guides/ios/current/getting-started/using-cocoapods/) to use the `PSPDFKit/Swift` subspec.

Your `Podfile` should look like this:

``` Ruby
# Replace `YourAppName` with your app's target name.

pod 'PSPDFKitSwift', :git => 'https://github.com/PSPDFKit/PSPDFKitSwift.git', :tag => '1.0.0'

target :YourAppName do
  use_frameworks!

  # Replace `YOUR_COCOAPODS_KEY` with your own.
  pod 'PSPDFKit/Swift', podspec: 'https://customers.pspdfkit.com/cocoapods/YOUR_COCOAPODS_KEY/latest.podspec'
end
```

**Note:** `PSPDFKitSwift` is not published in the public [CocoaPods Specs](https://github.com/CocoaPods/Specs). You have to reference the pod with the Git repository, as shown in the example above. Also, make sure to replace `YourAppName` with your app name and `YOUR_COCOAPODS_KEY` with your own key provided by PSPDFKit GmbH. You can find your key either in the [customer portal](https://customers.pspdfkit.com/) or by requesting an [evaluation license](https://pspdfkit.com/try/).

Now run `pod install`. Afterward, you should be able to build and run your project without errors.

### Manual Setup

**Note:** Manual setup is only for experts, and you should know what you are doing. If you are unsure of what to do, please use CocoaPods or Carthage instead.

First, build the PSPDFKitSwift framework:

* Clone `git@github.com:PSPDFKit/PSPDFKitSwift.git`
* Copy `PSPDFKit.framework` into `PSPDFKitSwift/Frameworks`
* Copy `PSPDFKitUI.framework` into `PSPDFKitSwift/Frameworks`
* Open the terminal and `cd` into the `PSPDFKitSwift` directory
* Run `rake compile`

You should now have the `PSPDFKitSwift.framework` in the `Build` folder. Next, add `PSPDFKit.framework`, `PSPDFKitUI.framework`, and `PSPDFKitSwift.framework` to your project:

* Follow the [Getting Started](https://pspdfkit.com/guides/ios/current/getting-started/integrating-pspdfkit/) instructions for PSPDFKit.

* Perform the first two steps from the [Integrating the Dynamic Framework](https://pspdfkit.com/guides/ios/current/getting-started/integrating-pspdfkit/#toc_integrating-the-dynamic-framework) section in the above Getting Started guide, and add PSPDFKitSwift to your app, similar to how you did it with PSPDFKit above. You may also want to set up your [test targets](https://pspdfkit.com/guides/ios/current/getting-started/integrating-pspdfkit/#toc_test-targets) accordingly. Be sure to adapt the path for the “Run Script” build phase for PSPDFKitSwift.

You should now be able to build and run your app.

**Important:** Be sure to link against frameworks from the `Frameworks` directory, as those are patched bundles. Compiling PSPDFKitSwift modifies `PSPDFKit.framework` and `PSPDFKitUI.framework` by adding [`.apinotes`](https://pspdfkit.com/blog/2018/first-class-swift-api-for-objective-c-frameworks/) files to both. If you copy those modified frameworks to any other Swift projects, be sure to also include PSPDFKitSwift, as they will cease to work without that additional library.

## Limitations

PSPDFKitSwift is a work in progress, and we have more plans for improving upon it in the future. As such, we do not yet guarantee API stability. However, this shouldn’t stop you from using it, as changes will usually be easy to adopt.

## Contributing

If you want to work on PSPDFKitSwift, perform the following steps:

* Clone `git@github.com:PSPDFKit/PSPDFKitSwift.git`
* Copy `PSPDFKit.framework` into `PSPDFKitSwift/Frameworks`
* Copy `PSPDFKitUI.framework` into `PSPDFKitSwift/Frameworks`
* Open `PSPDFKitSwift.xcodeproj` in Xcode >= 9.2

Please [sign our CLA agreement](https://pspdfkit.com/guides/web/current/miscellaneous/contributing/) so we can accept your pull requests.

Technical notes:

* All PSPDFKitSwift source files live in the `Sources` directory.
* PSPDFKit and PSPDFKitUI modules are re-exported automatically.
* `PSPDFKit.apinotes` and `PSPDFKitUI.apinotes` are textile files that adjust the API visibility.

## Known Issues

**Linker warning when building without Carthage**: In order to support Carthage out of the box with per-customer PSPDFKit URLs, we’ve added the _parent_ Carthage build folder to the “Framework Search Paths.” When building without Carthage, this produces the following warning:

```
ld: warning: directory not found for option '-F/Users/desktopuser/Projects/PSPDFKit/PSPDFKitSwift/../../../Carthage/Build/iOS'
```

## License

PSPDFKitSwift is released under a modified version of the BSD license — see [LICENSE.md](LICENSE.md).

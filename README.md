# Dials
Dials is a desktop app for controlling and debugging your iOS app. It has a simple extensible architecture to make it easy for you to add your own plugins without having to worry about the details of setting up and maintaining a connection between your iOS app and the desktop display. It also comes with several useful built in plugins:

1. A view debugger similar to the Xcode view debugger but it can:
    1. Write properties and not just read them.
    2. Be easily extended to support custom properties for your own views.
    3. Be easily extended for new types of desktop editors.
    4. View the margins between views.

2. A network requests debugger that tells you all about what data your app is sending and receiving.

3. A control panel that lets you connect arbitrary variables to controls on the desktop. In addition to sending the new values back to your running application, you can also save changes directly back to your code with the push of a button.

See it in action:

- [Control Panel](Documentation/control-panel-example-1080.mp4)
- [View Debugger](Documentation/view-debugger-example-1080.mp4)
- [Network Watcher](Documentation/network-requests-example-1080.mp4)

Additionally, check out [Snaps](http://github.com/aleffert/snaps/) a Dials plugin that extends the built in autolayout constraint editor to write your changes back to your code when using the [SnapKit](http://github.com/SnapKit/SnapKit/) library.

## Setup

Dials is an unusual project in that it has an iOS component and a desktop component. As such, you can use Cocoapods or Carthage to fetch and version it, but you'll have to perform some additional manual steps afterward.

### Fetch Using Cocoapods

Add the following to your ``Podfile``:
```
pod 'Dials', '~> 1.0'
```

### Fetch Using Carthage

Add the following to your ``Cartfile``:
```
github "aleffert/Dials"
```

### Fetch Using Submodules

Of course, you can also just add Dials as a submodule directly:
```
git submodule add Libraries/Dials git@github.com:aleffert/dials.git
```

### Configuring Dials in your project
Once you have the files downloaded, you will need to do the following:

1. Find ``Dials.xcodeproj`` and drag it into your project's workspace.
2. Add ``Dials.framework`` as a library dependency for your iOS app in the "Build Phases" section of the target settings.
3. Still within "Build Phases", add a "Copy Files" build phase whose "Destination" is "Frameworks" (your project may already have this).
4. Hit the "+" button and add "Dials.framework".
5. Go to the "Build Settings" pane for your target and ensure "Embedded Content Contains Swift Code" is set to "Yes".
6. Still within the "Build Settings" pane, ensure the "Runtime Search Paths" setting includes ``@executable_path/Frameworks``.
7. Go to your application delegate and inside the ``applicationDidFinishLaunching`` method, call ``DLSDials.shared().start()``.

    Objective-C:

    ```
    #import <Dials/Dials.h>

    - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

        ... your code here ...

    #if DEBUG
        [[DLSDials shared] start];
    #endif

        ... your code here ...

    }
    ```

    Swift:
    ```

    import Dials

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {

        ... your code here ...

    #if DEBUG
        DLSDials.shared().start()
    #endif

        ... your code here ...

    }
    ```

### Running Dials

Once you have Dials configured, you can start it by running your app in the simulator and then, while your app is still running, choosing the ``Dials.app`` scheme from within Xcode and running that at the same time. You can also build ``Dials.app`` and afterward, run that executable from the Finder without involving Xcode.


### Usage

Dials comes with two plugins that require no additional work on your part: The Views plugin and the Network Requests plugin. However, the Views plugin gains additional power if you extend it to support your custom views. See the documentation for more details.


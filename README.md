# Dials
Dials is a desktop app for controlling and debugging your iOS app. It has a simple extensible architecture to make it easy for you to add your own plugins without having to worry about the details of setting up and maintaining a network connection. It also comes with several useful built in plugins:

1. A view debugger similar to the Xcode view debugger but it can:
    #. Write properties and not just read them.
    #. Be easily extended to support custom properties for your own views.
    #. Be easily extended for new types of desktop side editors.
2. A network requests debugger that tells you all about what data your app is sending.
3. A control panel that lets you connect arbitrary pieces of code to controls on the desktop. You can then save changes directly back to your code with the push of a button.


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
2. Add ``Dials.framework`` as a library dependency for your iOS app in the "build phases" section of the target settings.  *Note*: Due to a bug in XCode, it may add this file with a weird path. In the Xcode "File" pane under "Identity and Type", you should see that the location is "Relative to Build Products" and the relative path is just be "Dials.framework". If you don't, you should choose "Relative to Build Products", click the little folder icon next to the path, and choose the actual correct build products folder (typically deep inside ``~/Library/Developer/Xcode/DerivedData/``)
3. Import ``Dials`` and add the following code to ``applicationDidFinishLaunching`` in your app delegate:

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

Once you have Dials configured, you can start it by running your app in the simulator and then choosing the ``Dials.app`` scheme and running that at the same time.


## Using the Control Panel plugin

The Control Panel plugin lets you create screens of controls on the Desktop that will modify values in your running iOS app. It will also save changes to a value back to your code if you press the save button attached to that control.

Here is an example control panel:
![Control Panel Plugin Example](control-panel.png)

You can see that there are several items under "Control Panel" in the left sidebar. The plugin lets you group your controls under a name to organize them.

And [here is a video of the feature in action](control-panel-example-1080.mp4?raw=true).

To create a control, you need to declare it in your code. The DialsExample project that is part of the Dials distribution has a number of [Objective-C examples](../DialsExample/Source/ViewController.m) and [Swift examples](../DialsExample/Source/TestViewController.swift).

To declare a control you can simply call the ``DLSControl`` function. This will create a control in the desktop app that will automatically go away when the calling object gets deallocated. Here's an example that creates a new Slider.

Objective-C:
```
NSColor* aColor = [UIColor blackColor];

@implementation SomeClass

- (void)someMethod {
    DLSControl(@"My Color").colorOf(&aColor);
}

@end
```

Swift:
```
var aColor = UIColor.blackColor()

class SomeClass {

    func someMethod() {
        DLSControl("My Color").colorOf(&aColor)
    }

}

```

When your code gets called your control will show up under the Control Panel tab in the Dials desktop app. You can create groups of controls using ``DLSControlGroupWithName``. That will nest any controls created in the associated block together in a tab within the desktop app with the given group name. If no group is currently specified, controls will appear under the "Top Level" item listed with Control Panel.


There is also a variant of ``DLSControl`` that works with Key-Value coding compliant keypaths.

Objective-C:
```
DLSControlForKeyPath("someProperty").asColor();
```

Swift:
```
DLSControl("someProperty").asColor()
```

You can find a list of built in editors in [``DLSControlPanelPlugin.h``](../iOS/DLSControlPanelPlugin.h) or you can add your own by [writing an editor plugin](new-plugin.md).


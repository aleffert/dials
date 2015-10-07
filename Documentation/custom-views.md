## Adding support for Custom Views

The Views plugin comes configured for editing a number of built in UIKit views. However, if you want to use it to add properties from your own ``UIView`` subclasses, you need to do the following:

1. Inside your app code, create an extension of your subclass that conforms to the ``DLSDescribable`` protocol. 

2. Declare the list of properties that can be edited. Each property can be created by calling ``DLSProperty`` and passing it the name of the property and an instance of ``DLSEditor`` that describes how to edit that property. If you're using Swift, any property you mention here should be marked with ``@objc`` so that it is accessible to the [Key-Value Coding](https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/KeyValueCoding/Articles/KeyValueCoding.html) system. See ``DLSPropertyDescription.h`` and ``DLSDescriptionContext.h`` for some extra ways to modify a property like changing its user facing label or coercing from a ``CGColorRef`` to a ``UIColor``.

Here is an example that adds properties to ``UISwitch``.

Objective-C:
```
#import <Dials/Dials.h>

@implementation UISwitch (DLSDescribable)

+ (void)dls_describe:(id<DLSDescriptionContext>)context {
    [super dls_describe:context];
    [context addGroupWithName:@"Switch"
                   properties:@[
                        DLSProperty(@"onTintColor", [DLSColorEditor editor]),
                        DLSProperty(@"thumbTintColor", [DLSColorEditor editor]),
                        DLSProperty(@"on", [DLSToggleEditor editor]),
    ]];
}

@end
```

Swift:
```
import Dials

extension UISwitch : DLSDescribable {

    func dls_describe(context : DLSDescriptionContext) {
        super.dls_describe(context)
        context.addGroupWithName("Switch", properties: [
            DLSProperty("onTintColor", DLSColorEditor()),
            DLSProperty("thumbTintColor", DLSColorEditor()),
            DLSProperty("on", DLSToggleEditor())
        ])
    }

}
```

The current list of editors is

1. Button - ``DLSActionEditor``
2. Color Swatch - ``DLSColorEditor``
3. CGRect/CGPoint/CGSize/Any Groups of Floats - ``DLSFloatArrayEditor``
4. Image - ``DLSImageEditor``
5. Popup Menu - ``DLSPopupEditor``
6. Slider - ``DLSSliderEditor``
7. Stepper - ``DLSStepperEditor``
8. TextField - ``DLSTextFieldEditor``
9. Switch - ``DLSToggleEditor``


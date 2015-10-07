## Adding support for Custom Views

The Views plugin comes configured for editing a number of built in UIKit views. However, if you want to use it to add properties from your own ``UIView`` subclasses, you need to do the following:

1. Inside your app code, create an extension of your subclass that conforms to the ``DLSDescribable`` protocol. 

2. Declare the list of properties that can be edited. 

Here is an example:

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
3. Image - ``DLSImageEditor``
4. Popup Menu - ``DLSPopupEditor``
5. Slider - ``DLSSliderEditor``
6. Stepper - ``DLSStepperEditor``
7. TextField - ``DLSTextFieldEditor``
8. Switch - ``DLSToggleEditor``
9. CGRect/CGPoint/CGSize/Any Groups of Floats - ``DLSFloatArrayEditor``

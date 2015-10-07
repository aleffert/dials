## Creating a plugin

Dials supports several different plugin types with different capabilities.

If you want to implement a new top level tab, you will need to implement ``Plugin`` and ``DLSPlugin``. If you only want to implement a custom editor for use with the built in Views plugin, you'll need to implement ``DLSEditor`` and ``Editor``. Either way, each of these will have iOS code, desktop code, and code shared across platforms.

Detailed code level documentation can be found in the ``Plugin.h``, ``DLSPlugin.h``, ``Editor.h``, and ``DLSEditor.h`` header files.

If you’re adding a new plugin that is meant to be contributed upstream, you can just add your classes to the ``Dials.framework`` and ``Dials.app`` projects for the iOS code and desktop code, respectively.

If you want to keep your plugin internal to your project or think it should be distributed separately from the core Dials distribution, there is more you’ll need to do. There is an example custom plugin set up as part of the DialsExample project. See the ExamplePlugin target. This project uses a separate desktop target, but builds the iOS component as part of an associated iOS application. This is the simplest way to do it if you just want to add plugins particular to your iOS app.

If you want to build a plugin that is separate from any particular iOS application, you'll need to have an iOS Framework target in addition to your desktop bundle target. See the [Snaps](https://github.com/aleffert/Snaps) project for an example.

In either of these cases, we recommend that you use one Xcode project with multiple targets, rather than separate projects for each platform. This will make it easier to share code between the different components.

### Setting up your Desktop bundle

Whatever type of plugin you write, you will need to create a desktop plugin bundle and build it along with Dials.app. To do this, you can perform the following steps:

0. Ensure Dials is configured as part of your workspace.

1. Choose File > New… > Target. Create a new OS X Bundle target with the "Bundle Extension" ``dialsplugin``. This corresponds to the “Wrapper Extension” field in the target’s build settings.

2. Go to your target's build settings and add ``$(BUILT_PRODUCTS_DIR)/Dials.app/Contents/Headers/`` to the “Additional Header Paths” section. See (Apple's documentation)[https://developer.apple.com/library/ios/recipes/xcode_help-project_editor/Articles/EditingBuildSettings.html] for more information.

3. Chose Product > Schemes > New Scheme… to make a new build scheme with your plugin as the “Target”. This scheme will combine your plugin *and* Dials so they are built together and you can easily run Dials with the latest version of your plugin. Call it something like "Dials.app + <your-plugin-name>".

4. Chose Product > Schemes > Edit Scheme… to bring up the scheme editor. Select your new scheme and tap on the “Build” tab. Add the “Dials” target - make sure it’s above your plugin bundle, so that the app builds first.

5. Still on the "Build" tab, uncheck "Parallelize Build". This prevents your plugin from building at the same time as your app, allowing it to find the headers you added in Step 2.

6. Switch to the "Run" tab and ensure that "Dials.app" is selected as the "Executable."

### Building a top level plugin

A top level plugin has two parts:

1. A class within your iOS code that implements the ``DLSPlugin`` protocol. To get Dials to see this plugin you will need to change your in your application delegate how you start Dials.

    Objective-C:
    ```
    YourPlugin* plugin = [[YourPlugin alloc] init];
    NSArray*<id<DLSPlugin>> plugins = [[[DLSDials shared] defaultPlugins] arrayByAddingObject:plugin];
    [[DLSDials shared] startWithPlugins: plugins];
    ```


    Swift:
    ```
    var plugins = DLSDials.shared.defaultPlugins()
    plugins.append(YourPlugin())
    DLSDials.shared().startWithPlugins(plugins)
    ```

2. A Desktop based plugin that implements the ``Plugin`` protocol. To get Dials to see this plugin, you need edit your bundle's ``Info.plist`` file and ensure its "Principal Class" is set to the name of your ``Plugin`` class. If you're using Swift, make sure to include the module name of your plugin class, for example "ModuleName.ClassName". See [additional documentation here](https://developer.apple.com/library/ios/documentation/General/Reference/InfoPlistKeyReference/Articles/CocoaKeys.html#//apple_ref/doc/uid/TP40009251-SW11).


### Building an editor

An editor plugin supplies a custom way to edit a property. Dials ships with a number of built in editors for things like colors, sliders, and even autolayout constraints. An editor plugin has several parts:

1. A class within your iOS code that implements the ``DLSEditor`` protocol.

2. A desktop based class that implements the ``EditorController`` protocol.

3. A desktop based ``extension`` to your ``DLSEditor`` implementation that conforms to the ``EditorControllerGenerating`` protocol. This is typically just a small factory method that returns your ``EditorController`` subclass.

There are a number of examples of this in the Dials code base just search for those protocol names.

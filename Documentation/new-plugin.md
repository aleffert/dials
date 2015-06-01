## How do I add a new plugin?

A plugin has two parts:

1. A class within your iOS code that implements the ``DLSPlugin`` interface.

2. A Desktop based plugin that implements the ``Plugin`` interface.

Both of those need to have the same ``identifier`` property so that Dials can link them up.

If you’re adding a new plugin that is meant to be shared or contributed upstream, you can just add your classes to the ``Dials.framework`` and ``Dials.app`` projects respectively.

If you want to keep your plugin internal to your project, there is more you’ll need to do. There is an example custom plugin set up as part of the DialsExample project. See the ExamplePlugin target. You will need to follow these steps:

1. Add a new class that implements ``DLSPlugin`` to your iOS project.

2. Create a new bundle target with the extension ``dialsplugin``. This corresponds to the “Wrapper Extension” field in the target’s build settings.

3. Add the path for ``Dials/Desktop/Headers/`` to the “Additional Header Paths” of your bundle target.

4. Create a new class for the desktop part of your plugin.

5. Add the name of that class to the “Principal Class” field of your Info.plist. If you’re using swift, make sure to include the module name of the plugin too, for example, “ModuleName.ClassName”.

6. Make a new Build scheme with your plugin as the “Target”.

7. Edit your scheme and tap on the “Build” tab. Add the “Dials” target - make sure it’s above your plugin bundle, so that the app builds first. Go to the “Run” tab and choose “Dials” as the executable.


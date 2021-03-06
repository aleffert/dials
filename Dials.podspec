Pod::Spec.new do |s|
  s.name        = "Dials"
  s.version     = "1.0.0"
  s.description = <<-DESC
                  Dials is a pluggable debugging framework for writing Mac
                  based tools that communicate with your iOS app. It comes with
                  a number of useful plugins: A view debugger, a network
                  debugger, and a control panel that lets you make changes to
                  arbitrary properties in real time and can even save changes
                  directly to your code. It has a number of extension points,
                  making it easy to add custom editors for your own views, or
                  even your own project specific plugin.
                  DESC
  s.summary     = "Pluggable desktop debugging tools for iOS. Included plugins let you modify views, watch the network, and even send changes back to your code"
  s.homepage    = "https://github.com/aleffert/dials"
  s.license     = { :type => 'MIT', :file => 'LICENSE' }
  s.author      = { "Akiva Leffert" => "aleffert@gmail.com" }
  s.platform    = :ios, '8.0'
  s.source      = { :git => "https://github.com/aleffert/dials.git", :tag => "release/1.0.0" }
  s.preserve_paths = '*'
  s.ios.frameworks = 'CFNetwork'
  s.compiler_flags = '-ObjC'
end

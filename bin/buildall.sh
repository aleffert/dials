xcodebuild -workspace Dials.xcworkspace -scheme Dials.app build test | xcpretty -tc -f `xcpretty-travis-formatter` && exit ${PIPESTATUS[0]} 
xcodebuild -workspace Dials.xcworkspace -scheme Dials.app build test | xcpretty -tc -f `xcpretty-travis-formatter` && exit ${PIPESTATUS[0]}

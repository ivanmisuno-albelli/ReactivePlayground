source 'https://github.com/CocoaPods/Specs.git'

abstract_target 'ReactivePlaygroundAbstractTarget' do

    target 'ReactivePlayground-ios' do
        platform :ios, '8.0'
        use_frameworks!

        # Tests target has its own pods, and also inherits search paths from the main module.
        target 'ReactivePlayground-ios-tests' do
            inherit! :search_paths

            pod 'Quick'
            pod 'Nimble'
        end
    end
end

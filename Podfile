source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'

use_frameworks!

target "Insta3D_iOS-Sample" do
    pod 'MBProgressHUD', '0.9.1'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        puts "#{target.name}"
    end
end

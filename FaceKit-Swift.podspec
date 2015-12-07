Pod::Spec.new do |s|
    s.name         = "FaceKit-Swift"
    s.version      = "1.3"
    s.summary      = "Library to generate a 3D avatar from one single front face photo."

    s.description  = <<-DESC
        FaceKit-Swift is the core technology to generate the a 3D avatar from one single front face photo.
        The main features of FaceKit include:

        * Create 3D avatar from one single front face photo
        * Render the 3D avatar in the iOS device
        * Avatar management
        * Assets (accessories management)
        * Change skin colors

    DESC

    s.homepage     = "http://spe3d.co"

    s.license      = "All rights reserved"


    s.authors      = { "Daniel Lee" => "daniel@spe3d.co", "James Sa" => "james@spe3d.co" }


    s.platform     = :ios
    s.platform     = :ios, "8.0"

    s.ios.deployment_target = "8.0"


    s.source       = { :git => "git@github.com:spe3d/FaceKit-Swift.git", :tag => s.version }


    s.source_files  = "FaceKit/*.swift"


    s.frameworks = "SceneKit", "UIKit"


    s.requires_arc = true

    s.dependency "AFNetworking", "2.6.3"

end

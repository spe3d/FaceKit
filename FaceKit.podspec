Pod::Spec.new do |s|
    s.name         = "FaceKit"
    s.version      = "1.3.12"
    s.summary      = "Library to generate a 3D avatar from one single front face photo."

    s.description  = <<-DESC
        FaceKit-Swift is the core technology to generate the a 3D avatar from one single front face photo.
        The main features of FaceKit include:

        * Create 3D avatar from one single front face photo
        * Render the 3D avatar in the iOS device
        * Avatar management
        * Assets (accessories management)
        * Change skin colors
        * Lip Sync

    DESC

    s.homepage              = "http://spe3d.co"

    s.license               = 'Commercial'

    s.authors               = { "Daniel Lee" => "daniel@spe3d.co", "James Sa" => "james@spe3d.co" }


    s.platform              = :ios, "9.0"
    s.ios.deployment_target = "9.0"
    s.source                = { :git => "https://github.com/spe3d/FaceKit.git", :tag => s.version }

    s.requires_arc          = true

    s.frameworks            = "SceneKit", "UIKit"

    s.vendored_frameworks   = "FaceKit/FaceKit.framework"
    s.dependency 'NumSwift', '1.0.4'

end

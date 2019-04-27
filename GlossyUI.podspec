Pod::Spec.new do |s|
    s.name             = 'GlossyUI'
    s.version          = '0.1.0'
    s.summary          = 'GlossyUI adds surface behaviours (like shine respoding to phone motion) to standard controls  (UILabel, UIButton, UIImageView)'
    s.description      = <<-DESC
                        GlossyUI adds surface behaviours (like shine respoding to phone motion) to standard controls (UILabel, UIButton, UIImageView)
                       DESC

    s.homepage         = 'https://github.com/GirAppe/GlossyUI'
    # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'Andrzej Michnia' => 'amichnia@gmail.com' }
    s.source           = { :git => 'https://github.com/GirAppe/GlossyUI.git', :tag => s.version.to_s }
    s.ios.deployment_target = '10.0'
    s.source_files = 'GlossyUI/Classes/**/*'

    s.resource_bundles = {
        'GlossyUI' => ['GlossyUI/Assets/*.png']
    }
    s.frameworks = 'UIKit', 'CoreMotion'

end

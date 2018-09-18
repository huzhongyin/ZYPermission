Pod::Spec.new do |s|

s.name                = 'ZYPermission'
s.version             = '0.0.1'
s.summary             = 'ZYPermission is a tool'
s.homepage            = 'https://github.com/huzhongyin/ZYPermission'
s.license             = 'MIT'
s.author             = { 'huzhongyin' => '767915479@qq.com' }
s.source              = { :git => 'https://github.com/huzhongyin/ZYPermission.git', :tag => s.version.to_s }
s.source_files        = 'PPPrivacyPermission/*.{h,m}'
s.frameworks       = 'UIKit', 'Foundation'
s.requires_arc     = true
s.ios.deployment_target = '8.0'

end

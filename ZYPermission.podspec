Pod::Spec.new do |s|

s.name                = "ZYPermission"
s.version             = "0.0.1"
s.summary             = "integrate APNs rapidly"
s.homepage            = "https://github.com/huzhongyin/ZYPermission"
s.license             = { :type => "MIT", :file => "LICENSE" }
s.author             = { "胡中银" => "767915479@qq.com" }
s.platform            = :ios, "8.0"
s.source              = { :git => "https://github.com/huzhongyin/ZYPermission.git", :tag => s.version }
s.source_files        = "PPPrivacyPermission/*.{h,m}"

s.requires_arc        = true

end
#
#  Be sure to run `pod spec lint VFLFactory.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = "AUULayout"
  s.version      = "0.4.1"
  s.summary      = "An auto layout framework using VFL."
  s.description  = <<-DESC
    An auto layout framework using VFL and NSLayoutConstraint
                   DESC
  s.homepage     = "https://github.com/JyHu/AUULayout"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "JyHu" => "auu.aug@gmail.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/JyHu/AUULayout.git", :tag => "0.4.1" }
  s.source_files  = "AUULayout/*.{h,m}"
end

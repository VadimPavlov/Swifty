Pod::Spec.new do |s|
  s.name         = "Swifty"
  s.version      = "2.3.0"
  s.summary      = "Awesome Swift helpers"
  s.swift_version = "4.2"
  s.homepage     = "https://github.com/VadimPavlov/Swifty"
  s.license      = { :type => "MIT", :file => "LICENSE.md" }
  s.platform     = :ios, "9.0"
  s.source       = { :git => "https://github.com/VadimPavlov/Swifty.git", :branch => "master" }
  s.source_files  = "Source/**/*.swift"  
  s.author       = { "Vadym Pavlov" => "vadym.pavlov@icloud.com" }
  s.social_media_url   = "https://www.facebook.com/vadim.pavlov.792"

  s.ios.deployment_target = '9.0'
  s.osx.deployment_target = '10.11'
end
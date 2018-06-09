Pod::Spec.new do |s|
  s.name         = "Swifty"
  s.version      = "2.0.0"
  s.summary      = "Awesome Swift helpers"
  s.homepage     = "https://github.com/VadimPavlov/Swifty"
  s.license      = { :type => "MIT", :file => "LICENSE.md" }
  s.platform     = :ios, "9.0"
  s.source       = { :git => "https://github.com/VadimPavlov/Swifty.git", :branch => "master" }
  s.source_files  = "Source/**/*.swift"  
  s.author       = { "Pavlov Vadim" => "vadym.pavlov@icloud.com" }
  s.social_media_url   = "https://www.facebook.com/vadim.pavlov.792"
end

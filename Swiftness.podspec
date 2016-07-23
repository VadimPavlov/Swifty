Pod::Spec.new do |s|
  s.name         = "Swiftness"
  s.version      = "0.0.2"
  s.summary      = "Awesome Swift helpers"
  s.homepage     = "https://github.com/VadimPavlov/Swiftness"
  s.license      = { :type => "MIT", :file => "LICENSE.md" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/VadimPavlov/Swiftness.git", :tag => s.version }
  s.source_files  = "Source/*/*"  
  s.author       = { "Pavlov Vadim" => "vadym.pavlov@icloud.com" }
  s.social_media_url   = "https://www.facebook.com/vadim.pavlov.792"
end

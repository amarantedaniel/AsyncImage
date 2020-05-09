Pod::Spec.new do |spec|

  spec.name         = "AsyncImage"
  spec.version      = "0.0.1"
  spec.summary      = "Yet another SwifUI async image view."

  spec.description  = <<-DESC
  A SwiftUI Image component that can download images from the internet through the URL
                   DESC

  spec.homepage     = "https://amarantedaniel.com"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "amarantedaniel" => "daniel.amarante2@gmail.com" }

  spec.ios.deployment_target = "13.0"
  spec.swift_version = "5"

  spec.source        = { :git => "https://github.com/amarantedaniel/AsyncImage.git", :tag => "#{spec.version}" }
  spec.source_files  = "AsyncImage/**/*.{h,m,swift}"

end

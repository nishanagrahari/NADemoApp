Pod::Spec.new do |spec|

  spec.name         = "NADemoSdk"
  spec.version      = "0.0.1"
  spec.summary      = "A CocoaPods library written in Swift"

  spec.description  = <<-DESC
This CocoaPods library helps you perform calculation.
                   DESC

  spec.homepage     = "https://github.com/nishanagrahari/NADemoApp"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "jeantimex" => "nishanagrahari33@gmail.com" }

  spec.ios.deployment_target = "12.1"
  spec.swift_version = "4.2"

  spec.source        = { :git => "https://github.com/nishanagrahari/NADemoApp.git", :tag => "#{spec.version}" }
  spec.source_files  = "NADemoSdk/**/*.{h,m,swift}"

end

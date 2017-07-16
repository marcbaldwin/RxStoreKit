Pod::Spec.new do |s|
  s.name         = "RxStoreKit"
  s.version      = "1.0.0"
  s.license      = "MIT"
  s.summary      = "RxSwift wrapper for Store Kit"
  s.homepage     = "https://github.com/marcbaldwin/RxStoreKit"
  s.author       = { "marcbaldwin" => "marc.baldwin88@gmail.com" }
  s.source       = { :git => "https://github.com/marcbaldwin/RxStoreKit.git", :tag => s.version }
  s.source_files = "RxStoreKit/*.swift"
  s.platform     = :ios, '8.0'
  s.frameworks   = "Foundation", "UIKit"
  s.requires_arc = true
  s.dependency 'RxSwift'
end
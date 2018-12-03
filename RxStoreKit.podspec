Pod::Spec.new do |s|
  s.name         = "RxStoreKit"
  s.version      = "1.3.0"
  s.license      = "MIT"
  s.summary      = "RxSwift wrapper for Store Kit"
  s.homepage     = "https://github.com/marcbaldwin/RxStoreKit"
  s.author       = { "marcbaldwin" => "marc.baldwin88@gmail.com" }
  s.source       = { :git => "https://github.com/marcbaldwin/RxStoreKit.git", :tag => s.version }
  s.source_files = "RxStoreKit/Source/*.swift"
  s.platform     = :ios, '8.0'
  s.swift_version = '4.2'
  s.frameworks   = "Foundation", "StoreKit"
  s.requires_arc = true
  s.dependency 'RxSwift'
  s.dependency 'Moya'
  s.dependency 'Moya/RxSwift'
end

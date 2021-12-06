Pod::Spec.new do |s|
  s.name          = "RxStoreKit"
  s.version       = "1.7.0"
  s.license       = "MIT"
  s.summary       = "RxSwift wrapper for Store Kit"
  s.homepage      = "https://github.com/marcbaldwin/RxStoreKit"
  s.author        = { "marcbaldwin" => "marc.baldwin88@gmail.com" }
  s.source        = { :git => "https://github.com/marcbaldwin/RxStoreKit.git", :tag => s.version }
  s.source_files  = "RxStoreKit/Source/*.swift"
  s.ios.deployment_target = '13.0'
  s.swift_version = '5'
  s.frameworks    = "Foundation", "StoreKit"
  s.dependency      'RxSwift', '~> 6'
  s.dependency      'Alamofire', '~> 5'
end

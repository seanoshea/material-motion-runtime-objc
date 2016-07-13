Pod::Spec.new do |s|
  s.name         = "MaterialMotionRuntime"
  s.summary      = "Material Motion Runtime for Apple Devices"
  s.version      = "1.0.0"
  s.authors      = "The Material Motion Authors."
  s.license      = "Apache 2.0"
  s.homepage     = "https://github.com/material-motion/material-motion-runtime-objc"
  s.source       = { :path => "./" }
  s.platform     = :ios, "8.0"
  s.requires_arc = true

  s.public_header_files = "src/*.h"
  s.source_files = "src/*.{h,m}", "src/private/*.{h,m}"
  s.header_mappings_dir = "src"
end

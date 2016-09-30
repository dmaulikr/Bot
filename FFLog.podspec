Pod::Spec.new do |s|
s.name = 'FFLog'
s.version = '1.0.0'
s.license = 'MIT'
s.summary = 'FFLog on iOS.'
s.homepage = 'https://github.com/tinytinytiny126/Bot'
s.authors = { 'tiny_tiny_tiny' => 'tiny_tiny_tiny@126.com' }
s.source = { :git => 'https://github.com/tinytinytiny126/Bot.git', :tag => s.version.to_s }
s.requires_arc = true
s.ios.deployment_target = '8.0'
s.source_files = 'FFLog.h'
s.resources = ''
end

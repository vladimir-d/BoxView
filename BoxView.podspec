Pod::Spec.new do |s|
    s.name = 'BoxView'
    s.version = '1.5.0'
    s.swift_versions = [5.0]
    s.summary = 'Easy UIView layout.'
    s.description = <<-DESC
BoxView is the container UIView for laying out a stack of subviews
    DESC
    s.homepage = 'https://github.com/vladimir-d/BoxView'
    s.license = { :type => 'MIT', :file => 'LICENSE' }
    s.author = { 'Vladimir Dudkin' => 'vlad.dudkin@gmail.com' }
    s.source = { :git => 'https://github.com/vladimir-d/BoxView.git', :tag => 'v1.5.0' }
    s.ios.deployment_target = '9.0'
    s.source_files = 'BoxViewLayout/*.swift'
end

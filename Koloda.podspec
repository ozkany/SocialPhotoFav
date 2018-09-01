Pod::Spec.new do |s|
	s.name             = "Kesfet"
	s.version          = '4.4'
	s.summary          = ""

	s.homepage         = ""
	s.license          = 'MIT'
	s.author           = "Ozkan"
	s.source           = { :git => "https://github.com/Yalantis/Koloda.git", :tag => s.version }
	s.social_media_url = ''

	s.platform     = :ios, '8.0'
	s.source_files = 'Pod/Classes/**/*'

	s.frameworks = 'UIKit'
	s.dependency 'pop', '~> 1.0'
end

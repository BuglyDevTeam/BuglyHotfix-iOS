Pod::Spec.new do |s|
  s.name         = "BuglyHotfix"
  s.version      = "2.1.0"
  s.summary      = "BuglyHotfix iOS SDK. Learn more at https://bugly.qq.com."
  s.description  = "iOS library for Bugly App Hotfix Service. Sign up for a service at https://bugly.qq.com."
  s.homepage     = "https://bugly.qq.com/"
  s.authors      = { "Bugly" => "https://github.com/BuglyDevTeam" }
  s.author       = { "Bugly" => "https://github.com/BuglyDevTeam" }
  s.source       = { :http => "http://softfile.3g.qq.com/myapp/buglysdk/BuglyHotfix-2.1.0.zip" }
  s.requires_arc = true  
  s.platform     = :ios
  s.ios.deployment_target = '7.0'
  s.frameworks = 'SystemConfiguration','Security'
  s.library = 'z','c++'
  s.default_subspec = "Core"
  s.subspec "Core" do |ss|
      ss.vendored_frameworks = "BuglyHotfix.framework"
      ss.source_files = "BuglyHotfix.framework/Headers/*.h"
    end
  s.license      = {
    :type => 'Commercial',
    :text => <<-LICENSE
              Copyright (C) 2017 Tencent Bugly, Inc. All rights reserved.
      LICENSE
  }
  end

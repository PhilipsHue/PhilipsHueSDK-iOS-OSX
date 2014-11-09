Pod::Spec.new do |s|
    s.name                   = 'PhilipsHueSDK'
    s.version                = '1.3-beta'
    s.summary                = 'This SDK makes it easy to access the Hue system and control connected lamps.'
    s.description            = <<-DESC
                               The Hue SDK is a set of tools that are designed to make it easy to access
                               the Hue system through the Hue Wi-Fi network connected bridge and control
                               an associated set of connected lamps. The aim of the SDK is to enable you
                               to create your own applications for the Hue system. The tools are provided
                               with documentation for the SDK and example code. They are designed to be
                               flexible, whilst easing the use of the more complex components of the system.
                               DESC
    s.license                = <<-LICENSE
                               Philips releases this SDK with friendly house rules. These friendly house rules
                               are part of a legal framework; this to protect both the developers and hue.
                               The friendly house rules cover e.g. the naming of Philips and of hue which can
                               only be used as a reference (a true and honest statement) and not as a an brand
                               or identity. Also covered is that the hue SDK and API can only be used for hue
                               and for no other application or product. Very common sense friendly rules that
                               are common practice amongst leading brands that have released their SDK’s.

                               Copyright (c) 2012-2014, Philips Electronics N.V. All rights reserved.

                               Redistribution and use in source and binary forms, with or without modification,
                               are permitted provided that the following conditions are met:

                               * Redistributions of source code must retain the above copyright notice, this
                                 list of conditions and the following disclaimer.

                               * Redistributions in binary form must reproduce the above copyright notice,
                                 this list of conditions and the following disclaimer in the documentation
                                 and/or other materials provided with the distribution.

                               * Neither the name of Philips Electronics N.V. , nor the names of its contributors
                                 may be used to endorse or promote products derived from this software
                                 without specific prior written permission.

                               THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS"AS IS" AND
                               ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOTLIMITED TO, THE IMPLIED
                               WARRANTIES OF MERCHANTABILITY AND FITNESS FORA PARTICULAR PURPOSE ARE DISCLAIMED.
                               IN NO EVENT SHALL THE COPYRIGHT OWNER ORCONTRIBUTORS BE LIABLE FOR ANY DIRECT,
                               INDIRECT, INCIDENTAL, SPECIAL,EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
                               BUT NOT LIMITED TO,PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
                               DATA, ORPROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
                               LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDINGNEGLIGENCE OR
                               OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THISSOFTWARE, EVEN IF ADVISED OF
                               THE POSSIBILITY OF SUCH DAMAGE.
                               LICENSE
    s.homepage               = 'http://www.developers.meethue.com'
    s.author                 = 'Philips Electronics N.V.'

    s.ios.deployment_target  = '5.0'
    s.osx.deployment_target  = '10.7'
    s.requires_arc           = false
    s.source                 = {
      :git => 'https://github.com/PhilipsHue/PhilipsHueSDK-iOS-OSX.git',
      :commit => '62115c2'  # NOTE: Switch to "tag" after upstream add coresponding tag
    }

    s.ios.vendored_frameworks = 'HueSDK_iOS.framework'
    s.ios.public_header_files = 'HueSDK_iOS.framework/Versions/A/Headers/**/*.h'

    s.osx.vendored_frameworks = 'HueSDK_OSX.framework'
    s.osx.public_header_files = 'HueSDK_OSX.framework/Versions/A/Headers/**/*.h'

    s.xcconfig                = {
      'OTHER_LDFLAGS' => '-ObjC',
      'FRAMEWORK_SEARCH_PATHS' => '$(inherited)',
    }

    s.dependency 'CocoaLumberjack'
end

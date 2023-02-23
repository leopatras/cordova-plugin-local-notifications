BUNDLE_IDENTIFIER     =  com.4js.localnotif
BUNDLE_IDENTIFIER_GMA =  com.fourjs.localnotif
APPNAME               =  LNotify
MODE                  =  debug
DEVICE                =  simulator
IDENTITY             ?= (59W7RY75ZU)
PROVISIONING_PROFILE ?= /Users/leo/Library/MobileDevice/Provisioning Profiles/4js_wildcard
#$(info IDENTITY=$(IDENTITY) PROVISIONING_PROFILE=$(PROVISIONING_PROFILE))

#we build in-repository
PLUGIN= $(CURDIR)/../..
GMAPLUGIN=LocalNotification
ifneq ($(wildcard ../../fgldemo),)
  PLUGIN=../..
# figure out the directory name of the plugin because 
# gmabuildtool can't handle a plugin name like ../..
# in the scaffold --install-plugin option
  ABSPATH=$(abspath .)
  DEMODIR=$(shell  dirname $(ABSPATH))
  PLUGINDIR=$(shell dirname $(DEMODIR))
  GMAPLUGIN=$(notdir $(PLUGINDIR))
# $(warning ABSPATH=$(ABSPATH),DEMODIR=$(DEMODIR),PLUGINDIR=$(PLUGINDIR),GMAPLUGIN=$(GMAPLUGIN))
endif

MODULES  = $(patsubst %.4gl, %.42m, $(wildcard *.4gl))
FORMS    = $(patsubst %.per, %.42f, $(wildcard *.per))

%.42m: %.4gl
	fglcomp -M $*

%.42f: %.per
	fglform -M $*

all:: $(MODULES) $(FORMS) 

define gmibuild
	gmibuildtool --install=$(1) --app-name=$(APPNAME) --bundle-id=$(BUNDLE_IDENTIFIER) --provisioning='$(PROVISIONING_PROFILE)' --certificate='$(IDENTITY)' --device=$(DEVICE) --mode=$(MODE) --build-cordova=$(PLUGIN)
endef

#just builds build/iphoneos/GMI.ipa
gmi.build: all
	$(call gmibuild,no)
	
#installs the ipa/app on the simulator/device
gmi.install: all
	$(call gmibuild,yes)


gma.build: all
#ifneq ($(wildcard ../../fgldemo),)
#build the plugin out of this repository and do not use the bundled one
#	cd ../../.. && gmabuildtool scaffold --install-plugins $(GMAPLUGIN) && cd -
#endif
	gmabuildtool build --build-quietly --build-cordova $(PLUGIN) --build-app-package-name $(BUNDLE_IDENTIFIER_GMA) 


gma.installsim: gma.build
	$$ANDROID_SDK_ROOT/platform-tools/adb install -r ./gma/project/app/build/app/outputs/apk/app-unsigned.apk

clean::
	rm -rf build gmi
	rm -rf bin distbin gma
#	rm -f gmi/*.a gmi/link_flags.sh
	rm -f *.42* cordovamap.txt gmiignore 

.DEFAULT_GOAL := help
PROJECTNAME=$(shell basename "$(PWD)")
SOURCES=$(sort $(wildcard ./src/*.rs ./src/**/*.rs))

OS_NAME=$(shell uname | tr '[:upper:]' '[:lower:]')
PATH := $(ANDROID_NDK_HOME)/toolchains/llvm/prebuilt/$(OS_NAME)-x86_64/bin:$(PATH)

ANDROID_AARCH64_CC=$(ANDROID_NDK_HOME)/toolchains/llvm/prebuilt/$(OS_NAME)-x86_64/bin/aarch64-linux-android29-clang
ANDROID_AARCH64_CXX=$(ANDROID_NDK_HOME)/toolchains/llvm/prebuilt/$(OS_NAME)-x86_64/bin/aarch64-linux-android29-clang++
ANDROID_AARCH64_AR=$(ANDROID_NDK_HOME)/toolchains/llvm/prebuilt/$(OS_NAME)-x86_64/bin/llvm-ar

ANDROID_ARMV7_CC=$(ANDROID_NDK_HOME)/toolchains/llvm/prebuilt/$(OS_NAME)-x86_64/bin/armv7a-linux-androideabi29-clang
ANDROID_ARMV7_CXX=$(ANDROID_NDK_HOME)/toolchains/llvm/prebuilt/$(OS_NAME)-x86_64/bin/armv7a-linux-androideabi29-clang++
ANDROID_ARMV7_AR=$(ANDROID_NDK_HOME)/toolchains/llvm/prebuilt/$(OS_NAME)-x86_64/bin/llvm-ar

ANDROID_I686_CC=$(ANDROID_NDK_HOME)/toolchains/llvm/prebuilt/$(OS_NAME)-x86_64/bin/i686-linux-android29-clang
ANDROID_I686_CXX=$(ANDROID_NDK_HOME)/toolchains/llvm/prebuilt/$(OS_NAME)-x86_64/bin/i686-linux-android29-clang++
ANDROID_I686_AR=$(ANDROID_NDK_HOME)/toolchains/llvm/prebuilt/$(OS_NAME)-x86_64/bin/llvm-ar

ANDROID_X86_64_CC=$(ANDROID_NDK_HOME)/toolchains/llvm/prebuilt/$(OS_NAME)-x86_64/bin/x86_64-linux-android29-clang
ANDROID_X86_64_CXX=$(ANDROID_NDK_HOME)/toolchains/llvm/prebuilt/$(OS_NAME)-x86_64/bin/x86_64-linux-android29-clang++
ANDROID_X86_64_AR=$(ANDROID_NDK_HOME)/toolchains/llvm/prebuilt/$(OS_NAME)-x86_64/bin/llvm-ar

SHELL := /bin/bash

# ##############################################################################
# # GENERAL
# ##############################################################################

.PHONY: help
help: makefile
	@echo
	@echo " Available actions in "$(PROJECTNAME)":"
	@echo
	@sed -n 's/^##//p' $< | column -t -s ':' |  sed -e 's/^/ /'
	@echo

## init: Install missing dependencies.
.PHONY: init
init:
	rustup target add aarch64-apple-ios x86_64-apple-ios
	rustup target add aarch64-apple-darwin x86_64-apple-darwin
	rustup target add aarch64-apple-ios-sim
	#rustup target add armv7-apple-ios armv7s-apple-ios i386-apple-ios ## deprecated
	rustup target add aarch64-linux-android armv7-linux-androideabi i686-linux-android x86_64-linux-android
	@if [ $$(uname) == "Darwin" ] ; then cargo install cargo-lipo ; fi
	cargo install cbindgen

## :

# ##############################################################################
# # RECIPES
# ##############################################################################

## all: Compile iOS, Android
all: ios macos android

## ios: Compile the iOS universal library
ios: target/universal/release/liblightning_toolkit.a

target/universal/release/liblightning_toolkit.a: $(SOURCES) ndk-home
	@if [ $$(uname) == "Darwin" ] ; then \
		cargo lipo --release ; \
		cp target/universal/release/liblightning_toolkit.a ../ios/liblightning_toolkit.a ; \
		else echo "Skipping iOS compilation on $$(uname)" ; \
	fi
	@echo "[DONE] $@"

## ios: Compile the iOS universal library
iossimulator: target/aarch64-apple-ios-sim/debug/liblightning_toolkit.a
iossimulatorx86: target/x86_64-apple-ios/debug/liblightning_toolkit.a

target/x86_64-apple-ios/debug/liblightning_toolkit.a: $(SOURCES) ndk-home
	@if [ $$(uname) == "Darwin" ] ; then \
		cargo lipo --targets x86_64-apple-ios; \
		cp target/x86_64-apple-ios/debug/liblightning_toolkit.a ../ios/liblightning_toolkit.a ; \
		else echo "Skipping iOS compilation on $$(uname)" ; \
	fi
	@echo "[DONE] $@"

target/aarch64-apple-ios-sim/debug/liblightning_toolkit.a: $(SOURCES) ndk-home
	@if [ $$(uname) == "Darwin" ] ; then \
		cargo lipo --targets aarch64-apple-ios-sim; \
		cp target/aarch64-apple-ios-sim/debug/liblightning_toolkit.a ../ios/liblightning_toolkit.a ; \
		else echo "Skipping iOS compilation on $$(uname)" ; \
	fi
	@echo "[DONE] $@"

## macos: Compile the macOS libraries
macos: target/x86_64-apple-darwin/release/liblightning_toolkit.dylib target/aarch64-apple-darwin/release/liblightning_toolkit.dylib

target/x86_64-apple-darwin/release/liblightning_toolkit.dylib: $(SOURCES)
	@if [ $$(uname) == "Darwin" ] ; then \
		cargo lipo --release --targets x86_64-apple-darwin ; \
		else echo "Skipping macOS compilation on $$(uname)" ; \
	fi
	@echo "[DONE] $@"

target/aarch64-apple-darwin/release/liblightning_toolkit.dylib: $(SOURCES)
	@if [ $$(uname) == "Darwin" ] ; then \
		cargo lipo --release --targets aarch64-apple-darwin ; \
		else echo "Skipping macOS compilation on $$(uname)" ; \
	fi
	@echo "[DONE] $@"

## android: Compile the android targets (arm64, armv7 and i686)
android: target/aarch64-linux-android/release/liblightning_toolkit.so target/armv7-linux-androideabi/release/liblightning_toolkit.so target/i686-linux-android/release/liblightning_toolkit.so target/x86_64-linux-android/release/liblightning_toolkit.so

target/aarch64-linux-android/release/liblightning_toolkit.so: $(SOURCES) ndk-home
	@mkdir -p target/aarch64-linux-android/release/deps
	@echo "INPUT(-lunwind)" > target/aarch64-linux-android/release/deps/libgcc.a
	CC_aarch64_linux_android=$(ANDROID_AARCH64_CC) \
	CXX_aarch64_linux_android=$(ANDROID_AARCH64_CXX) \
	AR_aarch64_linux_android=$(ANDROID_AARCH64_AR) \
	CARGO_TARGET_AARCH64_LINUX_ANDROID_LINKER=$(ANDROID_AARCH64_CC) \
		cargo build --target aarch64-linux-android --release
	mkdir -p ../android/src/main/jniLibs/arm64-v8a/
	cp -a $(ANDROID_NDK_HOME)/sources/cxx-stl/llvm-libc++/libs/arm64-v8a/libc++_shared.so ../android/src/main/jniLibs/arm64-v8a/
	cp target/aarch64-linux-android/release/liblightning_toolkit.so ../android/src/main/jniLibs/arm64-v8a/liblightning_toolkit.so
	@echo "[DONE] $@"

target/armv7-linux-androideabi/release/liblightning_toolkit.so: $(SOURCES) ndk-home
	@mkdir -p target/armv7-linux-androideabi/release/deps
	@echo "INPUT(-lunwind)" > target/armv7-linux-androideabi/release/deps/libgcc.a
	CC_armv7_linux_androideabi=$(ANDROID_ARMV7_CC) \
	CXX_armv7_linux_androideabi=$(ANDROID_ARMV7_CXX) \
	AR_armv7_linux_androideabi=$(ANDROID_ARMV7_AR) \
	CARGO_TARGET_ARMV7_LINUX_ANDROIDEABI_LINKER=$(ANDROID_ARMV7_CC) \
		cargo build --target armv7-linux-androideabi --release
	mkdir -p ../android/src/main/jniLibs/armeabi-v7a/
	cp -a $(ANDROID_NDK_HOME)/sources/cxx-stl/llvm-libc++/libs/armeabi-v7a/libc++_shared.so ../android/src/main/jniLibs/armeabi-v7a/
	cp target/armv7-linux-androideabi/release/liblightning_toolkit.so ../android/src/main/jniLibs/armeabi-v7a/liblightning_toolkit.so
	@echo "[DONE] $@"

target/i686-linux-android/release/liblightning_toolkit.so: $(SOURCES) ndk-home
	@mkdir -p target/i686-linux-android/release/deps
	@echo "INPUT(-lunwind)" > target/i686-linux-android/release/deps/libgcc.a
	CC_i686_linux_android=$(ANDROID_I686_CC) \
	CXX_i686_linux_android=$(ANDROID_I686_CXX) \
	AR_i686_linux_android=$(ANDROID_I686_AR) \
	CARGO_TARGET_I686_LINUX_ANDROID_LINKER=$(ANDROID_I686_CC) \
		cargo  build --target i686-linux-android --release
	mkdir -p ../android/src/main/jniLibs/x86/
	cp -a $(ANDROID_NDK_HOME)/sources/cxx-stl/llvm-libc++/libs/x86/libc++_shared.so ../android/src/main/jniLibs/x86/
	cp target/i686-linux-android/release/liblightning_toolkit.so ../android/src/main/jniLibs/x86/liblightning_toolkit.so
	@echo "[DONE] $@"

target/x86_64-linux-android/release/liblightning_toolkit.so: $(SOURCES) ndk-home
	@mkdir -p target/x86_64-linux-android/release/deps
	@echo "INPUT(-lunwind)" > target/x86_64-linux-android/release/deps/libgcc.a
	CC_x86_64_linux_android=$(ANDROID_X86_64_CC) \
	CXX_x86_64_linux_android=$(ANDROID_X86_64_CXX) \
	AR_x86_64_linux_android=$(ANDROID_X86_64_AR) \
	CARGO_TARGET_X86_64_LINUX_ANDROID_LINKER=$(ANDROID_X86_64_CC) \
		cargo build --target x86_64-linux-android --release
	mkdir -p ../android/src/main/jniLibs/x86_64/
	cp -a $(ANDROID_NDK_HOME)/sources/cxx-stl/llvm-libc++/libs/x86_64/libc++_shared.so ../android/src/main/jniLibs/x86_64/
	cp target/x86_64-linux-android/release/liblightning_toolkit.so ../android/src/main/jniLibs/x86_64/liblightning_toolkit.so
	@echo "[DONE] $@"
		
.PHONY: ndk-home
ndk-home:
	@if [ ! -d "${ANDROID_NDK_HOME}" ] ; then \
		echo "Error: Please, set the ANDROID_NDK_HOME env variable to point to your NDK folder" ; \
		exit 1 ; \
	fi

## :

# ##############################################################################
# # OTHER
# ##############################################################################

## clean:
.PHONY: clean
clean:
	cargo clean
	rm -f target/bindings.h target/bindings.src.h

## test:
.PHONY: test
test:
	cargo test

PROJECTNAME=$(shell basename "$(PWD)")
SOURCES=$(sort $(wildcard ./src/*.rs ./src/**/*.rs))

current_dir := $(shell pwd)

# ##############################################################################
# # GENERAL
# ##############################################################################

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

ios-universal: $(SOURCES)	
	mkdir -p target/universal/release
	cargo build --release --target aarch64-apple-ios ;\
	cargo build --release --target x86_64-apple-ios ;\
	/usr/bin/lipo -create -output target/universal/release/libbreez_sdk_bindings.a target/aarch64-apple-ios/release/libbreez_sdk_bindings.a target/x86_64-apple-ios/release/libbreez_sdk_bindings.a	


aarch64-apple-darwin: $(SOURCES)
	@if [ $$(uname) == "Darwin" ] ; then \
		cargo lipo --release --targets aarch64-apple-darwin ; \
		else echo "Skipping macOS compilation on $$(uname)" ; \
	fi
	@echo "[DONE] $@"

swift-ios: ios-universal
	uniffi-bindgen generate src/breez_sdk.udl -l swift -o binding/swift-ios
	cp $(current_dir)/target/universal/release/libbreez_sdk_bindings.a binding/swift-ios
	cd binding/swift-ios && "swiftc" "-emit-module" "-module-name" "breez_sdk_bindings"  "-Xcc" "-fmodule-map-file=$(current_dir)/binding/swift-ios/breez_sdkFFI.modulemap" "-I" "."  "-L" "." "-lbreez_sdk_bindings" breez_sdk.swift

swift-darwin: aarch64-apple-darwin
	uniffi-bindgen generate src/breez_sdk.udl -l swift -o binding/swift-darwin
	cp $(current_dir)/target/aarch64-apple-darwin/release/libbreez_sdk_bindings.dylib binding/swift-darwin	
	cd binding/swift-darwin && "swiftc" "-emit-module" "-module-name" "breez_sdk_bindings"  "-Xcc" "-fmodule-map-file=$(current_dir)/binding/swift-ios/breez_sdkFFI.modulemap" "-I" "."  "-L" "." "-lbreez_sdk_bindings" breez_sdk.swift

## clean:
.PHONY: clean
clean:
	cargo clean
	rm -rf target
	rm -rf binding/swift-darwin
	rm -rf binding/swift-ios

## test:
.PHONY: test
test:
	cargo test

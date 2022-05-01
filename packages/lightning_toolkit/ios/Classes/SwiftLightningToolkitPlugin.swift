import Flutter
import UIKit

public class SwiftLightningToolkitPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "lightning_toolkit", binaryMessenger: registrar.messenger())
    let instance = SwiftLightningToolkitPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }

  public func dummyMethodToEnforceBundling() {
    test("...");    
    // ...
    // This code will force the bundler to use these functions, but will never be called
  }
}

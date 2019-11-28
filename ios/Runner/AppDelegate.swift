import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    let configurationsFilePath = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist")!
    let configurationDictionary = NSDictionary(contentsOfFile: configurationsFilePath)!
    
    let apiKey = (configurationDictionary["API_KEY"] as? String) ?? ""
    
    GMSServices.provideAPIKey(apiKey)
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

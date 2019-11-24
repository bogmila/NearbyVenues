//
//  AppDelegate.swift
//  NearbyVenues
//
//  Created by Bogumiła Kochańska-Nawojczyk on 19/11/2019.
//
import UIKit

#if DEBUG
    import SBTUITestTunnelServer
#endif

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        #if DEBUG
            SBTUITestTunnelServer.takeOff()
        #endif

        window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = UINavigationController()
        navigationController.pushViewController(SearchViewControllerBuilder.build(), animated: true)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        return true
    }
}

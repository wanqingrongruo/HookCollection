//
//  PathHelper.swift
//  blackboard
//
//  Created by roni on 2018/12/7.
//  Copyright © 2018 xkb. All rights reserved.
//

import Foundation
import UIKit

class PathHelper: NSObject {
    @objc class func getMyViewController(sender: Any, isPush: Bool = false) -> String? {

        func boomStack(navigationController: UINavigationController) -> String? {
            let viewControllers = navigationController.viewControllers
            var vcString = ""
            if let tab = viewControllers[safe: 0]?.tabBarController {
                let tuple = getClassTypeAndKey(sender: tab)
                vcString += String(format: "%@->", tuple.name)
            }
            for (index, vc) in viewControllers.enumerated() {
                if let presentingVC = vc.presentingViewController, let tabVC = presentingVC as? UITabBarController {
                    if let nav = tabVC.selectedViewController as? UINavigationController {
                        vcString += boomStack(navigationController: nav) ?? ""
                    }
                }
                if isPush && index == viewControllers.count - 1 {
                    continue
                }
                let tuple = getClassTypeAndKey(sender: vc)
                let survival = UserDefaults.standard.object(forKey: tuple.key) as? String ?? ""
                vcString += String(format: "%@(%@)->", tuple.name, survival)
            }
            return vcString
        }

        if let view = sender as? UIResponder {
            if let next = view.next {
                if next.isKind(of: UINavigationController.self) {
                    return boomStack(navigationController: next as! UINavigationController)
                } else if next.isKind(of: UIViewController.self) {
                    let viewController =  next as! UIViewController
                    if let nav = viewController.navigationController {
                        return boomStack(navigationController: nav)
                    } else {
                        let tuple = getClassTypeAndKey(sender: viewController)
                        let survival = UserDefaults.standard.object(forKey: tuple.key) as? String ?? ""
                        return String(format: "%@(%@)->", tuple.name, survival)
                    }
                } else {
                    return getMyViewController(sender: next, isPush: isPush)
                }
            }
        } else if let gesture = sender as? UIGestureRecognizer {
            if let view = gesture.view {
                return getMyViewController(sender: view, isPush: isPush)
            }
        }
        return nil
    }

    class func getClassTypeAndKey(sender: Any) -> (name: String, key: String) {
        let name = String(describing: object_getClass(sender) ?? UIViewController.self)
        let nameSpace = Bundle.main.infoDictionary?["CFBundleExecutable"] as? String ?? ""
        let key = nameSpace + "." + name
        return (name, key)
    }
}

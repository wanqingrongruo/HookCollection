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
    @objc class func getMyViewController(sender: Any) -> String {

        func boomStack(navigationController: UINavigationController) -> String {
            let viewControllers = navigationController.viewControllers
            if let vc = viewControllers.last {
                let tuple = getClassTypeAndKey(sender: vc)
                return tuple.name
            }
            return "Unkown"
        }

        func judageName(next: UIResponder) -> String? {
            if next.isKind(of: UINavigationController.self) {
                return boomStack(navigationController: next as! UINavigationController)
            } else if next.isKind(of: UIViewController.self) {
                let vc =  next as! UIViewController
                let tuple = getClassTypeAndKey(sender: vc)
                return tuple.name
            }
            return nil
        }

        if let view = sender as? UIResponder {
            if let next = view.next {
                if let name = judageName(next: next) {
                    return name
                } else {
                    return getMyViewController(sender: next)
                }
            }
        } else if let gesture = sender as? UIGestureRecognizer {
            if let view = gesture.view {
                return getMyViewController(sender: view)
            }
        } else {
            if let view = sender as? UIViewController {
                if view.isKind(of: UINavigationController.self) {
                    return boomStack(navigationController: view as! UINavigationController)
                } else {
                    let tuple = getClassTypeAndKey(sender: view)
                    return tuple.name
                }
            }
        }
        return "Unkown"
    }

    class func getClassTypeAndKey(sender: Any) -> (name: String, key: String) {
        let name = String(describing: object_getClass(sender) ?? UIViewController.self)
        let nameSpace = Bundle.main.infoDictionary?["CFBundleExecutable"] as? String ?? ""
        let key = nameSpace + "." + name
        return (name, key)
    }

   @objc class func getClassType(sender: Any) -> String {
        return String(describing: object_getClass(sender) ?? UIViewController.self)
    }

    @objc class func getTitle(sender: Any) -> String {
        if let button  = sender as? UIButton {
            if let buttonTitle = button.title(for: .normal) {
                return buttonTitle
            } else if button.image(for: .normal) != nil {
                return "图片按钮"
            }
        }
        return ""
    }
}

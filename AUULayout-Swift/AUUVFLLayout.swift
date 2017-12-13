//
//  AUUVFLLayout.swift
//  AUULayout-Swift
//
//  Created by 胡金友 on 2017/12/9.
//

import UIKit

public var H:VFLConstraints {
    get { return VFLConstraints(direction: "H:") }
}

public var V:VFLConstraints {
    get { return VFLConstraints(direction: "V:") }
}

open class LayoutAssistant : NSObject {
    fileprivate var debugEnable = false
    fileprivate var needAutoCover = false
    fileprivate var repetitionLayoutConstrantsHandler:((_ oldConstraint:NSLayoutConstraint, _ newConstraint:NSLayoutConstraint) -> Void)?
    
    // 单例
    fileprivate static let shared = LayoutAssistant()
    private override init(){}
    
    public class func debugEnableLog(enable:Bool) {
        LayoutAssistant.shared.debugEnable = enable
    }
    
    public class func setNeedAutoCoverRepetitionLayoutConstrants(autoCover:Bool) {
        LayoutAssistant.shared.needAutoCover = autoCover
    }
    
    public class func setRepetitionLayoutConstrantsHandler(handler:@escaping (_ oldConstraint:NSLayoutConstraint, _ newConstraint:NSLayoutConstraint) -> Void) {
        LayoutAssistant.shared.repetitionLayoutConstrantsHandler = handler
    }
}

extension NSLayoutConstraint {
    fileprivate func similarTo(constrant:NSLayoutConstraint) -> Bool {
        return  (self.firstItem === constrant.firstItem && self.firstAttribute == constrant.firstAttribute) &&
            ((self.secondItem == nil && constrant.secondItem == nil) || (self.secondItem != nil && constrant.secondItem != nil && self.secondItem === constrant.secondItem && self.secondAttribute == constrant.secondAttribute))
    }
}

open class VFLLayout: NSObject { }

open class SimpleVFLConstraints:VFLLayout {
    fileprivate var sponsorView:UIView!
    fileprivate var VFLString:String!
    fileprivate var layoutKits:[String:UIView] = [:]
    
    fileprivate func cacheView(view:UIView) -> String! {
        if view.superview != nil && view.superview!.isKind(of: UIView.self) {
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let key = "COM_AUU_VFL_\(view.hash)"
        self.layoutKits[key] = view
        return key
    }
}

open class VFLConstraints: SimpleVFLConstraints {
    fileprivate init(direction:String) {
        super.init()
        self.VFLString = direction
    }
    
    public func end() -> String {
        self.VFLString.append("|")
        return self.cut()
    }
    
    public func cut() -> String {
        let currentInstalledConstrants = NSLayoutConstraint.constraints(withVisualFormat: self.VFLString, options: .directionMask, metrics: nil, views: self.layoutKits)
        for view in self.layoutKits.values {
            if let superView = view.superview {
                for oldLayoutConstraints in superView.constraints {
                    for newLayoutConstraints in currentInstalledConstrants {
                        if newLayoutConstraints.similarTo(constrant: oldLayoutConstraints) {
                            if let repetionHandler = LayoutAssistant.shared.repetitionLayoutConstrantsHandler {
                                repetionHandler(oldLayoutConstraints, newLayoutConstraints)
                            } else if LayoutAssistant.shared.needAutoCover {
                                NSLayoutConstraint.deactivate([oldLayoutConstraints])
                            }
                        }
                    }
                }
            }
        }
        
        if LayoutAssistant.shared.debugEnable {
            print("\(self.VFLString)")
        }
        
        self.sponsorView.addConstraints(currentInstalledConstrants)
        return self.VFLString
    }
    
    public subscript(value:Any) -> VFLConstraints {
        return self["\(value)"]
    }
    
    public subscript(value:String) -> VFLConstraints {
        let prefix = self.VFLString != nil && self.VFLString.count == 2 ? "|" : ""
        self.VFLString.append("\(prefix)-(\(value))-")
        return self
    }
    
    public subscript(view:UIView) -> VFLConstraints {
        self.VFLString.append("[\(self.cacheView(view: view) as String)]")
        return self
    }
    
    public subscript(value:SubVFLConstraints) -> VFLConstraints {
        self.layoutKits.merge(value.layoutKits) { (v1, v2) -> UIView in
            return v1
        }
        self.VFLString.append("[\(self.cacheView(view: value.sponsorView) as String)(\(value.VFLString as String))]")
        return self
    }
    
    fileprivate override func cacheView(view: UIView) -> String! {
        if view.superview != nil && view.superview!.isKind(of: UIView.self) {
            self.sponsorView = view.superview
        }
        
        return super.cacheView(view: view)
    }
}

open class SubVFLConstraints:SimpleVFLConstraints {
    public subscript(value:Any) -> SubVFLConstraints {
        if let view:UIView = value as? UIView {
            return self[view]
        }
        return self["\(value)"]
    }
    
    public subscript(view:UIView) -> SubVFLConstraints {
        self.VFLString = "\(self.cacheView(view: view) as String)"
        return self
    }
    
    public subscript(value:String) -> SubVFLConstraints {
        self.VFLString = value
        return self
    }
}

private let kSubVFLKey = "com.auu.vfl.subvfl"

extension UIView {
    public var VFL:SubVFLConstraints {
        get {
            var subVFL = objc_getAssociatedObject(self, kSubVFLKey) as? SubVFLConstraints
            if subVFL == nil {
                subVFL = SubVFLConstraints()
                objc_setAssociatedObject(self, kSubVFLKey, subVFL, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            subVFL?.sponsorView = self
            return subVFL!
        }
    }
    
    public subscript(value:Any) -> SubVFLConstraints {
        return self.VFL[value]
    }
}

extension UIView {
    public func edge(edge:UIEdgeInsets) -> [String] {
        return [
            H[self.VFL[edge.left]][self][edge.right].end(),
            V[self.VFL[edge.top]][self][edge.bottom].end()
        ]
    }
    
    public func fixedSize(size:CGSize) -> [String] {
        return [
            H[self.VFL[size.width]].cut(),
            V[self.VFL[size.height]].cut()
        ]
    }
}










//
//  NotificationViewControllerParent.swift
//  VHFeature-iOS
//
//  Created by Ashish Limje on 20/06/22.
//

import UIKit
import UserNotifications
import UserNotificationsUI
import SnapKit

/// struct for push notification payload keys declaration
struct APNSPayloadKey {
    public static let aps    = "aps"
    public static let alert  = "alert"
    public static let body   = "body"
    public static let title   = "title"
}

open class NotificationViewControllerParent: UIViewController, UNNotificationContentExtension, UITextViewDelegate {

    //MARK:- Variable declarations
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        label.textColor =  .black
        label.font = UIFont.boldSystemFont(ofSize: 14.0)
        view.addSubview(label)
        return label
    }()
    
    fileprivate lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.textColor =  .black
        textView.font = UIFont.systemFont(ofSize: 20.0)
        textView.delegate = self
        view.addSubview(textView)
        return textView
    }()
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
    }
    
    open override func loadView() {
        //initialize the view to get it custom height based on push notification text
        view = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        self.titleLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
        self.descriptionTextView.dataDetectorTypes = .all
        self.descriptionTextView.isEditable = false
        self.descriptionTextView.isScrollEnabled = false
        self.descriptionTextView.linkTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor(netHex: 0x007AFF), NSAttributedString.Key.underlineStyle : NSUnderlineStyle.byWord.rawValue]
        initialSetUp()
    }
    
    fileprivate func  initialSetUp() {
        
        self.view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(1)
            make.leading.equalTo(view).offset(17)
            make.trailing.equalTo(view).inset(10)
        }
        
        self.view.addSubview(descriptionTextView)
        descriptionTextView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.equalTo(view).offset(14)
            make.trailing.equalTo(titleLabel.snp.trailing)
            make.bottom.equalTo(view.snp.bottom).inset(10)
        }
        
    }
    
    open func didReceive(_ notification: UNNotification) {
        var attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black, .font: UIFont.systemFont(ofSize: 16.0)]
        if notification.request.content.categoryIdentifier == "NOTIFICATION_CATEGORY", let aps = notification.request.content.userInfo[APNSPayloadKey.aps] as? [String: Any], let alert = aps[APNSPayloadKey.alert] as? [String: Any], let body = alert[APNSPayloadKey.body] as? String, let title = alert[APNSPayloadKey.title] as? String {
            if self.traitCollection.userInterfaceStyle == .dark {
                self.titleLabel.textColor = .white
                attributes = [ .foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 16.0)]
            }
            self.titleLabel.text = title
            self.descriptionTextView.attributedText = NSAttributedString(string: body,attributes: attributes)
        }
    }
}

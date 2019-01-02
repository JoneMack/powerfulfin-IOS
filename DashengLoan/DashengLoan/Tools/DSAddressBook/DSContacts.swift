//
//  DSContacts.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2019/1/2.
//  Copyright © 2019 powerfulfin. All rights reserved.
//

import UIKit
import AddressBook
import Contacts

enum DSAuthorizationStatus:Int {
    case notDetermined //未定
    case restricted // 限制
    case denied // 拒绝
    case authorized //允许
}
@objc protocol DSContactsDelegate {
    @objc optional func contacts(_ contacts:DSContacts,readContactsStoreFinish contatcsArray:[[String:AnyObject]])
}
class DSContacts: NSObject {
    var authorizationStatus:((DSAuthorizationStatus)->Void)?
    weak var delegate:DSContactsDelegate?
    private lazy var myAddressBook: ABAddressBook = {
        var error:Unmanaged<CFError>?
        let ab: ABAddressBook = ABAddressBookCreateWithOptions(nil, nil).takeRetainedValue()
        return ab;
    }()
    
    @available(iOS 9.0, *)
    private lazy var myContactStore: CNContactStore = {
        let cn:CNContactStore = CNContactStore()
        return cn
    }()
    
    /// 检测通讯录权限，如果是未定，则直接请求权限
    ///
    /// - Parameter complete: 检测结果回调
    func checkContactStoreAuthorization(complete:@escaping((DSAuthorizationStatus)-> Void)) {
        if #available(iOS 9.0, *) {
           checkContactStoreAuthorizationIOS9(complete: complete)
        }else{
           checkContactStoreAuthorizationIOS8(complete: complete)
        }
    }
    
    /// 请求权限
    func requestContactStoreAuthorization() {
        if #available(iOS 9.0, *) {
           requestContactStoreAuthorizationIOS9()
        }else{
          requestContactStoreAuthorizationIOS8()
        }
    }
    func readContactsFromContactStore() {
        if #available(iOS 9.0, *) {
            readContactsFromContactStoreIOS9()
        }else{
            readContactsFromContactStoreIOS8()
        }
    }
}

// MARK: - iOS 8下的操作
extension DSContacts {
   fileprivate func checkContactStoreAuthorizationIOS8(complete:@escaping((DSAuthorizationStatus)-> Void)) {
        switch ABAddressBookGetAuthorizationStatus() {
        case .notDetermined:
            self.authorizationStatus = complete
            requestContactStoreAuthorization()
        case .authorized:
            complete(.authorized)
        case .denied, .restricted:
            complete(.denied)
        }
    }
    fileprivate func requestContactStoreAuthorizationIOS8() {
        ABAddressBookRequestAccessWithCompletion(myAddressBook, {[weak self] (granted, error) in
            if granted {
                self?.authorizationStatus?(.authorized)
            }else{
                self?.authorizationStatus?(.denied)
            }
        })
    }
    fileprivate func readContactsFromContactStoreIOS8() {
        guard ABAddressBookGetAuthorizationStatus() == .authorized else {
            return
        }
        
        let allContacts = ABAddressBookCopyArrayOfAllPeople(myAddressBook).takeRetainedValue() as Array
        
        var contacts = [[String:AnyObject]]()

        for record in allContacts {
            let currentContact: ABRecord = record
            
            var oneContact = [String:AnyObject]()
            
            let name = ABRecordCopyCompositeName(currentContact).takeRetainedValue() as String
            oneContact["FirstName"] = name as AnyObject
            
            var phones = [String]()
            let currentContactPhones: ABMultiValue = ABRecordCopyValue(currentContact, kABPersonPhoneProperty).takeRetainedValue() as ABMultiValue
            for i in 0..<ABMultiValueGetCount(currentContactPhones){
                let phoneNumber = ABMultiValueCopyValueAtIndex(currentContactPhones, i).takeRetainedValue() as! String
                phones.append(phoneNumber)
            }
            oneContact["Phones"] = phones as AnyObject
            contacts.append(oneContact)
        }
        
        delegate?.contacts?(self, readContactsStoreFinish: contacts)

    }
}

// MARK: - iOS 8之后的
@available(iOS 9.0, *)
extension DSContacts {
    fileprivate func checkContactStoreAuthorizationIOS9(complete:@escaping((DSAuthorizationStatus)-> Void)) {
        switch CNContactStore.authorizationStatus(for: .contacts) {
        case .notDetermined:
            self.authorizationStatus = complete
            requestContactStoreAuthorization()
        case .authorized:
            complete(.authorized)
        case .denied, .restricted:
            complete(.denied)
        }
        
    }
    fileprivate func requestContactStoreAuthorizationIOS9() {
        myContactStore.requestAccess(for: .contacts, completionHandler: {[weak self] (granted, error) in
            if granted {
                self?.authorizationStatus?(.authorized)
            }else{
                self?.authorizationStatus?(.denied)
            }
        })
    }
    fileprivate func readContactsFromContactStoreIOS9()  {
        guard CNContactStore.authorizationStatus(for: .contacts) == .authorized else {
            return
        }
        
        let keys = [CNContactFamilyNameKey,CNContactGivenNameKey,CNContactPhoneNumbersKey,CNContactEmailAddressesKey]
        
        let fetch = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
        do {
            var contacts = [[String:AnyObject]]()
            try myContactStore.enumerateContacts(with: fetch, usingBlock: { (contact, stop) in
                var oneContact = [String:AnyObject]()
                
                oneContact["FirstName"] = contact.familyName as AnyObject
                oneContact["LastName"] = contact.givenName as AnyObject
                
                var phones = [String]()
                //电话
                for labeledValue in contact.phoneNumbers {
                    let phoneNumber = (labeledValue.value as CNPhoneNumber).stringValue
                    phones.append(phoneNumber)
                }
                oneContact["Phones"] = phones as AnyObject
                
                var emails = [String]()
                for emailValue in contact.emailAddresses {
                    let email = emailValue.value as String
                    emails.append(email)
                }
                oneContact["Email"] = emails as AnyObject

                contacts.append(oneContact)
            })
            delegate?.contacts?(self, readContactsStoreFinish: contacts)
        } catch let error as NSError {
            print(error)
        }
    }
}

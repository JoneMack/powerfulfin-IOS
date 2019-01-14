//
//  DSAddressBookPicker.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2019/1/9.
//  Copyright © 2019 powerfulfin. All rights reserved.
//

import UIKit

struct DSContact {
    var name:String?
    var phone:String?
}
import AddressBookUI
import ContactsUI
class DSAddressBookPicker: NSObject {
    fileprivate var pickerHandler:((DSContact)->Void)?
    func presentPage(onTarget target:UIViewController,complete:@escaping((DSContact)->Void)) {
        UINavigationBar.appearance().barTintColor = UIColor.ds_redText
        UINavigationBar.appearance().tintColor = UIColor.ds_blackText
        
        if #available(iOS 9.0, *) {
            presentContactView(onTarget: target, complete: complete)
        }else{
            presentPeoplePicker(onTarget: target, complete: complete)
        }
    }
}

// MARK: - iOS 8 下的通讯录选择器
@available(iOS 8.0, *)
extension DSAddressBookPicker {
    fileprivate func presentPeoplePicker(onTarget target:UIViewController,complete:@escaping((DSContact)->Void)) {
        
        self.pickerHandler = complete
        let picker = ABPeoplePickerNavigationController()
        picker.peoplePickerDelegate = self
        picker.displayedProperties = [NSNumber(value: kABPersonPhoneProperty)]
        picker.predicateForSelectionOfPerson = NSPredicate(value: false)
        target.present(picker, animated: true, completion: nil)
    }
    
}
@available(iOS 8.0, *)
extension DSAddressBookPicker :ABPeoplePickerNavigationControllerDelegate {
    func peoplePickerNavigationController(_ peoplePicker: ABPeoplePickerNavigationController, didSelectPerson person: ABRecord, property: ABPropertyID, identifier: ABMultiValueIdentifier) {
        
        var contactInfo = DSContact()

        let compositeName = ABRecordCopyCompositeName(person)
        if let name = compositeName?.takeRetainedValue() as String? {
           contactInfo.name = name
        }
        
        if let unmanagedPhones = ABRecordCopyValue(person, kABPersonPhoneProperty) {
            let phones: ABMultiValue = Unmanaged.fromOpaque(unmanagedPhones.toOpaque()).takeUnretainedValue() as NSObject as ABMultiValue
            let index = ABMultiValueGetIndexForIdentifier(phones, identifier)
            if let unmanagedPhone = ABMultiValueCopyValueAtIndex(phones, index) {
                let phone: String = Unmanaged.fromOpaque(unmanagedPhone.toOpaque()).takeUnretainedValue() as NSObject as! String
                contactInfo.phone = phone
                contactInfo.phone = contactInfo.phone?.correctionPhoneNum()

            }
            
        }
        self.pickerHandler?(contactInfo)
    }
}
// MARK: - iOS 9 下的通讯录选择器
@available(iOS 9.0, *)
extension DSAddressBookPicker {
    fileprivate func presentContactView(onTarget target:UIViewController,complete:@escaping((DSContact)->Void)) {
       

        self.pickerHandler = complete
        let picker = CNContactPickerViewController()
        picker.delegate = self
        picker.displayedPropertyKeys = [CNContactPhoneNumbersKey]
        /// 选中人之后是否进入详情，设置YES是进入详情
        picker.predicateForSelectionOfContact = NSPredicate(value: false)
        picker.predicateForSelectionOfProperty = NSPredicate(value: true)
        target.present(picker, animated: true, completion: nil)
    }
}
@available(iOS 9.0, *)
extension DSAddressBookPicker:CNContactPickerDelegate {
    /// 取消
    
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        print("取消了")
    }
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contactProperty: CNContactProperty) {
        let contact = contactProperty.contact
        var contactInfo = DSContact()
        contactInfo.name = "\(contact.familyName)\(contact.givenName)"
        if contactProperty.key == CNContactPhoneNumbersKey {
            if let phone = contactProperty.value as? CNPhoneNumber {
                contactInfo.phone = phone.stringValue
                contactInfo.phone = contactInfo.phone?.correctionPhoneNum()
            }
        }
        self.pickerHandler?(contactInfo)
    }
}


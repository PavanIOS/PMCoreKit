//
//  LanguageKeys.swift
//  Regent
//
//  Created by sn99 on 19/01/21.
//  Copyright © 2021 sn99. All rights reserved.
//

import Foundation


class LanguageKeys {
    static let shared = LanguageKeys()
    
    func getSelectedLanguage() -> String{
        let currentLanguage = LanguageManager.shared.currentLanguage
        
        if currentLanguage == .en {
            return "English".localiz()
        }
       
        return "English".localiz()
    }
    
    // Common
    let Login = "Login"
    let Email = "Email"
    let UserName = "Username"
    let Password = "Password"
    let Forgot_Password = "Forgot Password?"
        
    let Reset_Password = "Please check your mail for new password."
    let Please_enter_Password = "Please enter Password".localiz()
    let Please_enter_userName = "Please enter userName".localiz()
    let Valid_Details = "Please enter Valid Credentails".localiz()
    let Network_Check = "Please Check your Network Connection".localiz()
    let Network_Title = "No Internet Connection".localiz()
    let Server_Alert = "Server is not responding".localiz()
    let Network_Alert = "Make sure your device is connected to the internet.".localiz()
    
    // Logout
    let Logout_Title = "Log out?"
    let Logout_Message = "You can always access your content by signing back in"
    
    
    let Home = "Home"
    let Profile = "Profile"
    let Settings = "Settings"
    
    let Documents = "Documents".localiz()
    
    
    // PlaceHolders
    let Department = "Department"
    
    
    
    
    //Deferrals
    let Current_Intake = "Current Intake".localiz()
    let Intake = "Intake".localiz()
    let Year_Of_Programme = "Year Of Programme".localiz()
    
    let cell = "Cell".localiz()
    let Email_Val = "Email".localiz()
    let Examination_Type = "Examination Type".localiz()
    let Supply_Examination_Type = "Supply Examination Type".localiz()
    let Preferred_Intake = "Preferred Intake".localiz()
    let Deferral_year = "Deferral for  year".localiz()
    let Deferral_sem_year = "Deferral for semester or year".localiz()
    let Date_Application = "Date of Application".localiz()

    
    
    let Examination_Venue = "Examination Venue".localiz()
    let Reasons_for_Request = "Reason's for Request".localiz()
    let Supporting_Documents_txt = "Supporting Documents attached to this form :(at least one file should selected)".localiz()
    
    let Limit_of_Attachment = "(Limit of each attachment size is 5mb and supported file formats are pdf,rtf,doc/docx,png,jpeg,gif only)".localiz()
    let Document_Type = "Document Type".localiz()
    let  Select_Document_Type = "Please Select Document Type".localiz()
    
    
    let Verfication_Code = "Verfication Code".localiz()
    let verfication_Code_Alert  = "Please type the verfication Code sent".localiz()
    let Agrotat_sucess_Message = "Agrotat submitted successfully".localiz()
    
    let Upload_file = "Are you sure you want upload file?".localiz()
    let Fill_Reason = "Please fill Reason".localiz()
    let  Atleast_One_Module_ALert = "Atleast One Module with one Attachment Should be Selected".localiz()

    let  Atleast_One_Attachment_ALert = "Atleast One  Attachment Should be Selected".localiz()

    
    
    
    let Learning_Mode = "Learning Mode".localiz()
    let Method_Of_Testing = "Method Of Testing".localiz()
    
    let Campus = "Campus".localiz()
    let Registration_Number = "Registration Number".localiz()
    
    
    let Sur_name = "Sur Name".localiz()
    let First_Name = "First Name".localiz()
    let FullName = "Full Name".localiz()
    
    let Program_Category = "Program Category".localiz()
    let Program = "Program".localiz()
    
    let Year_of_Program = "Year of Program".localiz()
    let Structure_Intake = "Structure Intake".localiz()
    
    let Student_Type = "Student Type".localiz()
    let Student_Status = "Student Status".localiz()
    
    let Is_RPL_Application = "Is RPL Application".localiz()
    
    
    let Date_of_Request = "Date of Request".localiz()
    
    let Registration_to_Tuitions = "Registration to Tuitions".localiz()

    
    
    let Method_of_Teaching  = "Method of Teaching".localiz()
    let New_Student_Intake = "New Student Intake".localiz()
    
    let New_Structure_Intake = "New Structure Intake".localiz()
    
    let Program_Sub_Category = "Program Sub Category".localiz()
    let Citizenship = "Citizenship".localiz()
    
   

    
}

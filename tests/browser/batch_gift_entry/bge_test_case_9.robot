*** Settings ***

Resource        tests/NPSP.robot
Library           DateTime
Suite Setup     Open Test Browser
#Suite Teardown  Delete Records and Close Browser

*** Test Cases ***

Delete a Data Import
    [tags]  unstable
    ${ns} =  Get NPSP Namespace Prefix
    &{batch} =       API Create DataImportBatch    Batch_Process_Size__c=50    Batch_Description__c=Created via API    Donation_Matching_Behavior__c=Single Match or Create    Donation_Matching_Rule__c=donation_amount__c;donation_date__c    RequireTotalMatch__c=false    Run_Opportunity_Rollups_while_Processing__c=true   GiftBatch__c=true    Active_Fields__c=[{"label":"Donation Amount","name":"${ns}Donation_Amount__c","sObjectName":"Opportunity","defaultValue":null,"required":true,"hide":false,"sortOrder":0,"type":"number","options":null},{"label":"Donation Date","name":"${ns}Donation_Date__c","sObjectName":"Opportunity","defaultValue":null,"required":false,"hide":false,"sortOrder":1,"type":"date","options":null}] 
    &{account} =     API Create Organization Account
    &{data_import} =  API Create DataImport    &{batch}[Id]    Account1Imported__c=&{account}[Id]    Donation_Donor__c=Account1
    Select App Launcher Tab   Batch Gift Entry
    Click Link  &{batch}[Name]
    # Click Element    //tbody/tr/td//div//lightning-button-menu
    # Set Focus To Element    //span[text()='Delete']
    # # Sleep    2
    # Click Link    Delete
    Select BGE Row     &{account}[Name]
    Sleep    2
    Click Element    //span[text()='Delete']   
    Page Should Contain    Total Count: 0
    
    
    # &{verify_data_import} =     Salesforce Get  DataImport__c  &{data_import}[Id]
    # Should Be Equal As Strings    &{verify_data_import}[Id]    ${Empty}
    
     
      

    
    
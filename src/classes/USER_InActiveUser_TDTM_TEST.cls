/*
    Copyright (c) 2017, Salesforce.org
    All rights reserved.
    
    Redistribution and use in source and binary forms, with or without
    modification, are permitted provided that the following conditions are met:
    
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of Salesforce.org nor the names of
      its contributors may be used to endorse or promote products derived
      from this software without specific prior written permission.

    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
    "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 
    LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS 
    FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE 
    COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, 
    INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, 
    BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; 
    LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER 
    CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT 
    LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN 
    ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
    POSSIBILITY OF SUCH DAMAGE.
*/

/**
* @author Salesforce.org
* @date 2017
* @group User
* @description Test class for the USER_InActiveUser_TDTM trigger handler.
*/

@isTest
public with sharing class USER_InActiveUser_TDTM_TEST {
    @TestSetup
    static void testSetup() {
        insert TDTM_DefaultConfig.getDefaultRecords();
    }
    /*********************************************************************************************************
    * @description Tests the handling of deactivating a System Administrator via the TDTM_Runnable.Action 
    *               for AfterUpdate.
    * @return void
    **********************************************************************************************************/
    private static testMethod void testHandlingDeactivatedSysAdmin() {
        List<User> newUsers = USER_UserService_TEST.createUsers();

        Error_Settings__c errorSettings = UTIL_CustomSettingsFacade.getErrorSettings();
        errorSettings.Error_Notifications_To__c = newUsers[1].Id;
        Database.insert(errorSettings, true);

        System.assertEquals(newUsers[1].Id, errorSettings.Error_Notifications_To__c);

        Test.startTest();
        Database.update(newUsers[1], true);
        Test.stopTest();

        Error_Settings__c errorSettingsSysAdmin = UTIL_CustomSettingsFacade.getErrorSettings();
        System.assertEquals(ERR_Notifier.ERROR_NOTIFICATION_RECIPIENT_ALL_SYS_ADMINS, errorSettingsSysAdmin.Error_Notifications_To__c);
    }


}
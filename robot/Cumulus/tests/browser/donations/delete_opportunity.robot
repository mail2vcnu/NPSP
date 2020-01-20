*** Settings ***

Resource        robot/Cumulus/resources/NPSP.robot
Library         cumulusci.robotframework.PageObjects
...             robot/Cumulus/resources/ContactPageObject.py
...             robot/Cumulus/resources/AccountPageObject.py
...             robot/Cumulus/resources/OpportunityPageObject.py
...             robot/Cumulus/resources/NPSP.py
Suite Setup     Run keywords
...             Open Test Browser
...             Setup Test Data
Suite Teardown  Delete Records and Close Browser

***Keywords***
# Sets test data contact and an opportunity for the contact
Setup Test Data
    Setupdata   contact   ${contact1_fields}     ${opportunity_fields}

*** Variables ***
&{contact1_fields}       Email=test@example.com
&{opportunity_fields}    Type=Donation   Name=Delete Auto test $100 Donation   Amount=100  StageName=Closed Won


*** Test Cases ***

Create Donation from a Contact and Delete Opportunity
    [Documentation]                      Create an opportunity using API for a contact. Navigate to Opportunities listings, select the
    ...                                  new opportunity > click on dropdown and select Delete

    [tags]                               W-038461                 feature:Donations

    Go To Page                           Detail
    ...                                  Opportunity
    ...                                  object_id=${data}[contact_opportunity][Id]

    ${donation_name}                     Get Main Header
    Go To Page                           Listing

    ...                                  Opportunity
    Wait Until Loading Is Complete
    Perform Delete Menu Operation On     ${donation_name}          Delete
    Verify Toast Message                 Opportunity "${donation_name}" was deleted. Undo


    Go To Page                           Details
    ...                                  Contact
    ...                                  object_id=${data}[contact][AccountId]

    Select Tab                           Details

    # Perform Validations
    Validate Field Value Under Section   Membership Information    Total Gifts                 $0.00
    Validate Field Value Under Section   Membership Information    Total Number of Gifts       0


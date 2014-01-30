<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Notify_Change_Request_Owner_when_Final_Task_Linked_to_Change_Request_is_Closed</fullName>
        <description>Notify change request owner when final task linked to change request is closed</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SDE_Emails/All_Tasks_closed_for_Change_Request</template>
    </alerts>
    <rules>
        <fullName>Notify change request owner when final task linked to change request is closed</fullName>
        <actions>
            <name>Notify_Change_Request_Owner_when_Final_Task_Linked_to_Change_Request_is_Closed</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Notify change request owner when final task linked to change request is closed</description>
        <formula>AND( State__c,  NOT( Inactive__c ) , ISCHANGED(AllTaskCloseController__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>

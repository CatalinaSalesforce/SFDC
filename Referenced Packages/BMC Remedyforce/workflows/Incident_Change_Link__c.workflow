<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>notifies_the_Incident_Owner_when_cr_linked_to_incident_is_closed</fullName>
        <description>Notify incident owner when change request linked to incident is closed</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SDE_Emails/Change_Request_Closed_Template</template>
    </alerts>
    <alerts>
        <fullName>notifies_the_client_that_an_incident_linked_change_request</fullName>
        <description>Notifies the client that an incident of the client is linked to a change request.</description>
        <protected>false</protected>
        <recipients>
            <field>FKContact__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>FKClient__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SDE_Emails/Incident_Change_Link_Template</template>
    </alerts>
    <rules>
        <fullName>Notify client when incident is linked to change request</fullName>
        <actions>
            <name>notifies_the_client_that_an_incident_linked_change_request</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Notifies the client that an incident of the client is linked to a change request.</description>
        <formula>ISBLANK(FKIncident__r.FKRequestDetail__c)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Notify incident owner when change request linked to incident is closed</fullName>
        <actions>
            <name>notifies_the_Incident_Owner_when_cr_linked_to_incident_is_closed</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Notify incident owner when change request linked to incident is closed</description>
        <formula>AND(NOT(FKChange__r.State__c),ISBLANK(FKIncident__r.FKRequestDetail__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>

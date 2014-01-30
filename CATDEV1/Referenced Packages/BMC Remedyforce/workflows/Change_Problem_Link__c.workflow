<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Notify_problem_owner_when_change_request_linked_to_problem_is_closed</fullName>
        <description>Notify problem owner when change request linked to problem is closed</description>
        <protected>false</protected>
        <recipients>
            <field>FKProblem_Owner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SDE_Emails/Change_Request_of_Problem_is_closed</template>
    </alerts>
    <rules>
        <fullName>Notify problem owner when change request linked to problem is closed</fullName>
        <actions>
            <name>Notify_problem_owner_when_change_request_linked_to_problem_is_closed</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Notify problem owner when change request linked to problem is closed</description>
        <formula>AND( NOT( FKChange__r.State__c),   Not(ISCHANGED( FKProblem_Owner__c ))  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>

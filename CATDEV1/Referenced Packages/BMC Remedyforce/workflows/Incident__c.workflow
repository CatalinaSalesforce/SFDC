<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Notify_Incident_Owner_when_final_Task_Linked_to_Incident_is_Closed</fullName>
        <description>Notify incident owner when final task linked to incident is closed</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SDE_Emails/All_Tasks_closed_for_Incident</template>
    </alerts>
    <alerts>
        <fullName>Notify_client_when_service_request_status_changes</fullName>
        <description>Notify_client_when_service_request_status_changes</description>
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
        <template>SDE_Emails/SRM_Status_Change</template>
    </alerts>
    <alerts>
        <fullName>Notify_owner_when_linked_task_is_closed</fullName>
        <description>Notify incident owner when linked task is closed</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SDE_Emails/Linked_Task_for_an_incident_is_closed</template>
    </alerts>
    <alerts>
        <fullName>call_status_from_email</fullName>
        <description>call_status_from_email</description>
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
        <template>SDE_Emails/Incident_Email_Template_5_Version_2</template>
    </alerts>
    <alerts>
        <fullName>notify_assign_to_on_ticket_followup</fullName>
        <description>notify_assign_to_on_ticket_followup</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SDE_Emails/Incident_Email_Template_2_Version_2</template>
    </alerts>
    <alerts>
        <fullName>notify_assign_to_on_ticket_reopen</fullName>
        <description>notify_assign_to_on_ticket_reopen</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SDE_Emails/Incident_Email_Template_8_Version_2</template>
    </alerts>
    <alerts>
        <fullName>notify_client_on_service_request_reopen</fullName>
        <description>notify_client_on_service_request_reopen</description>
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
        <template>SDE_Emails/SRM_Reopened</template>
    </alerts>
    <alerts>
        <fullName>notify_client_on_ticket_reopen</fullName>
        <description>notify_client_on_ticket_reopen</description>
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
        <template>SDE_Emails/Incident_Email_Template_8_Version_2</template>
    </alerts>
    <alerts>
        <fullName>notify_client_when_incident_is_closed</fullName>
        <description>notify_client_when_incident_is_closed</description>
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
        <template>SDE_Emails/Incident_Email_Template_6_Version_2</template>
    </alerts>
    <alerts>
        <fullName>notify_client_when_incident_is_created</fullName>
        <description>notify_client_when_incident_is_created</description>
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
        <template>SDE_Emails/Incident_Email_Template_1_Version_2</template>
    </alerts>
    <alerts>
        <fullName>notify_client_when_service_request_is_closed</fullName>
        <description>notify_client_when_service_request_is_closed</description>
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
        <template>SDE_Emails/SRM_Closed</template>
    </alerts>
    <alerts>
        <fullName>notify_client_when_service_request_is_created</fullName>
        <description>notify_client_when_service_request_is_created</description>
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
        <template>SDE_Emails/SRM_Created</template>
    </alerts>
    <alerts>
        <fullName>notify_staff_of_incident_due_in_1_hour</fullName>
        <description>notify_staff_of_incident_due_in_1_hour</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SDE_Emails/Incident_Email_Template_9_Version_2</template>
    </alerts>
    <alerts>
        <fullName>notify_staff_of_incident_nearing_due_date</fullName>
        <description>notify_staff_of_incident_nearing_due_date</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SDE_Emails/Incident_Email_Template_4_Version_2</template>
    </alerts>
    <alerts>
        <fullName>notify_staff_when_incident_is_assigned_to_them</fullName>
        <description>notify_staff_when_incident_is_assigned_to_them</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SDE_Emails/Incident_Email_Template_7_Version_2</template>
    </alerts>
    <alerts>
        <fullName>notify_staff_when_incident_is_created</fullName>
        <description>notify_staff_when_incident_is_created</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SDE_Emails/Incident_Email_Template_1_Version_2</template>
    </alerts>
    <alerts>
        <fullName>notify_staff_when_no_action_has_occurred_for_24_hours</fullName>
        <description>notify_staff_when_no_action_has_occurred_for_24_hours</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SDE_Emails/Incident_Email_Template_3_Version_2</template>
    </alerts>
    <fieldUpdates>
        <fullName>Apply_BBSA_Template</fullName>
        <field>TemplateName__c</field>
        <name>Apply BBSA Template</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Apply_BSA_Template</fullName>
        <field>TemplateName__c</field>
        <name>Apply BSA Template</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Apply_EUEM_Template</fullName>
        <field>TemplateName__c</field>
        <name>Apply EUEM Template</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Asset_Core_Approval_Status_Approved</fullName>
        <description>Update Asset Core Approval Status with Approved after successful operational rule deployment</description>
        <field>ACApprovalStatus__c</field>
        <literalValue>Approved</literalValue>
        <name>Asset Core Approval Status Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Asset_Core_Approval_Status_Rejected</fullName>
        <description>Update Asset Core Approval Status with Rejected after failed operational rule deployment</description>
        <field>ACApprovalStatus__c</field>
        <literalValue>Rejected</literalValue>
        <name>Asset Core Approval Status Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Service_Request_as_Approved</fullName>
        <description>Updates the flag approved to TRUE on final approval</description>
        <field>Approved__c</field>
        <literalValue>1</literalValue>
        <name>Update Service Request as Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_the_ShowDueDateDialog_Field</fullName>
        <field>ShowDueDateDialog__c</field>
        <literalValue>1</literalValue>
        <name>Update the ShowDueDateDialog Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Apply template to BMC Server Automation created incident</fullName>
        <actions>
            <name>Apply_BSA_Template</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Incident__c.incidentDescription__c</field>
            <operation>contains</operation>
            <value>Job id:</value>
        </criteriaItems>
        <criteriaItems>
            <field>Incident__c.incidentDescription__c</field>
            <operation>contains</operation>
            <value>Name:</value>
        </criteriaItems>
        <criteriaItems>
            <field>Incident__c.incidentDescription__c</field>
            <operation>contains</operation>
            <value>Job Group id:</value>
        </criteriaItems>
        <criteriaItems>
            <field>Incident__c.incidentDescription__c</field>
            <operation>contains</operation>
            <value>Job Run id:</value>
        </criteriaItems>
        <criteriaItems>
            <field>Incident__c.incidentDescription__c</field>
            <operation>contains</operation>
            <value>Start Time:</value>
        </criteriaItems>
        <description>This workflow will apply a template to the incident created by BMC Server Automation</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Apply template to End User Experience Management created incident</fullName>
        <actions>
            <name>Apply_EUEM_Template</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5 AND 6 AND 7 AND 8</booleanFilter>
        <criteriaItems>
            <field>Incident__c.incidentDescription__c</field>
            <operation>contains</operation>
            <value>Date:</value>
        </criteriaItems>
        <criteriaItems>
            <field>Incident__c.incidentDescription__c</field>
            <operation>contains</operation>
            <value>Source:</value>
        </criteriaItems>
        <criteriaItems>
            <field>Incident__c.incidentDescription__c</field>
            <operation>contains</operation>
            <value>Incident type:</value>
        </criteriaItems>
        <criteriaItems>
            <field>Incident__c.incidentDescription__c</field>
            <operation>contains</operation>
            <value>Incident detection rule:</value>
        </criteriaItems>
        <criteriaItems>
            <field>Incident__c.incidentDescription__c</field>
            <operation>contains</operation>
            <value>Watchpoint:</value>
        </criteriaItems>
        <criteriaItems>
            <field>Incident__c.incidentDescription__c</field>
            <operation>contains</operation>
            <value>Urgency rating:</value>
        </criteriaItems>
        <criteriaItems>
            <field>Incident__c.incidentDescription__c</field>
            <operation>contains</operation>
            <value>Sessions:</value>
        </criteriaItems>
        <criteriaItems>
            <field>Incident__c.incidentDescription__c</field>
            <operation>contains</operation>
            <value>Description:</value>
        </criteriaItems>
        <description>This workflow will apply a template to the incident created by End User Experience Management</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Notify incident owner when each linked task is closed</fullName>
        <actions>
            <name>Notify_owner_when_linked_task_is_closed</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Notifies incident owner when each linked task of the incident is closed.</description>
        <formula>AND( ISCHANGED( Task_Closed_Controller__c), NOT(ISBLANK( Task_Closed_Controller__c) ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Notify incident owner when final task linked to incident is closed</fullName>
        <actions>
            <name>Notify_Incident_Owner_when_final_Task_Linked_to_Incident_is_Closed</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Notify incident owner when final task linked to incident is closed</description>
        <formula>AND( state__c, NOT( inactive__c ), IF(AllTaskCloseController__c, ISCHANGED(AllTaskCloseController__c), false) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Notify staff of incident due in 1 hour</fullName>
        <active>true</active>
        <description>Notify staff of incident due in 1 hour</description>
        <formula>state__c  = True  &amp;&amp;  NOT(ISBLANK(dueDateTime__c) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Notify staff of incident nearing due date</fullName>
        <active>false</active>
        <description>Notify staff of incident nearing due date</description>
        <formula>state__c  = True  &amp;&amp;  NOT(ISBLANK(dueDateTime__c) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Notify staff when no action has occurred for 24 hours</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Incident__c.state__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Notifies the assigned staff member if the staff member has not taken any action on the incident for 24 Hours</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Notify the assigned staff member when an incident has been marked for follow up</fullName>
        <actions>
            <name>notify_assign_to_on_ticket_followup</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Notifies the staff member when an incident assigned to the staff member has been marked for follow up</description>
        <formula>followUp__c  = True &amp;&amp;  state__c  = False &amp;&amp;  PRIORVALUE( state__c )  = True</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Notify the assigned staff member when an incident is created and assigned to the staff member</fullName>
        <actions>
            <name>notify_staff_when_incident_is_created</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Notifies the staff member when an incident is created and assigned to the staff member</description>
        <formula>$User.Id  &lt;&gt;  OwnerId  &amp;&amp;  state__c  = True</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Notify the assigned staff member when an incident is reassigned to the staff member</fullName>
        <actions>
            <name>notify_staff_when_incident_is_assigned_to_them</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Notifies the staff member when an incident is reassigned to the staff member</description>
        <formula>OwnerId &lt;&gt; $User.Id  &amp;&amp;  ISCHANGED( OwnerId )  &amp;&amp;   NOT(ISNEW() ) &amp;&amp; state__c  = True</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Notify the assigned staff member when an incident is reopened</fullName>
        <actions>
            <name>notify_assign_to_on_ticket_reopen</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Notifies the staff member when a closed incident is reopened and assigned to the staff member</description>
        <formula>$User.Id  &lt;&gt;  OwnerId  &amp;&amp;  state__c  = True &amp;&amp;  PRIORVALUE( state__c ) = False</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Notify the client when a service request is closed</fullName>
        <actions>
            <name>notify_client_when_service_request_is_closed</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Notifies the client that the client’s service request is closed</description>
        <formula>(state__c  =  false) &amp;&amp; NOT( ISBLANK( FKRequestDetail__c) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Notify the client when a service request is created</fullName>
        <actions>
            <name>notify_client_when_service_request_is_created</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Notifies the client that the service request requested by the client is created</description>
        <formula>(state__c = True) &amp;&amp; (NOT( ISBLANK( FKRequestDetail__c ) || ISBLANK(  FKRequestDefinition__c  )  ))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Notify the client when a service request is reopened</fullName>
        <actions>
            <name>notify_client_on_service_request_reopen</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Notifies the client that the client’s service request is reopened</description>
        <formula>state__c  = True &amp;&amp;  PRIORVALUE( state__c ) = False &amp;&amp;   NOT(ISBLANK( FKRequestDetail__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Notify the client when a service request status is changed</fullName>
        <actions>
            <name>Notify_client_when_service_request_status_changes</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Notifies the client that the client’s service request status has changed</description>
        <formula>( FKStatus__c &lt;&gt; PRIORVALUE( FKStatus__c)) &amp;&amp; NOT(ISBLANK( FKRequestDetail__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Notify the client when an incident is closed</fullName>
        <actions>
            <name>notify_client_when_incident_is_closed</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Notifies the client that the client’s incident is closed</description>
        <formula>(state__c  = False) &amp;&amp; (followUp__c = False) &amp;&amp; (ISBLANK( FKRequestDetail__c) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Notify the client when an incident is created</fullName>
        <actions>
            <name>notify_client_when_incident_is_created</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Notifies the client that the incident requested by the client is created</description>
        <formula>(state__c = True) &amp;&amp; (ISBLANK( FKRequestDetail__c)  &amp;&amp; ISBLANK(  FKRequestDefinition__c  ))</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Notify the client when an incident is reopened</fullName>
        <actions>
            <name>notify_client_on_ticket_reopen</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Notifies the client that the client’s incident is reopened</description>
        <formula>state__c  = True &amp;&amp;  PRIORVALUE( state__c ) = False &amp;&amp;  ISBLANK( FKRequestDetail__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Open popup dialog for recalculating due date when priority of incident changes</fullName>
        <actions>
            <name>Update_the_ShowDueDateDialog_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>This rule has been deprecated. If the rule is active, deactivate it.</description>
        <formula>ISCHANGED( FKPriority__c ) &amp;&amp; IF( ShowDueDateDialog__c   = false,true, false)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update the incident%E2%80%99s status through email</fullName>
        <actions>
            <name>call_status_from_email</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Sends the status of the incident to the sender of the email</description>
        <formula>ISCHANGED( WorkflowController__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>

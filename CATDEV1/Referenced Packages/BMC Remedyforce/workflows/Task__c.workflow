<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>notify_client_when_an_task_is_reopened</fullName>
        <description>notify_client_when_an_task_is_reopened</description>
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
        <template>SDE_Emails/Task_Email_Template_2_Version_2</template>
    </alerts>
    <alerts>
        <fullName>notify_client_when_task_is_closed</fullName>
        <description>notify_client_when_task_is_closed</description>
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
        <template>SDE_Emails/Task_Email_Template_3_Version_2</template>
    </alerts>
    <alerts>
        <fullName>notify_client_when_task_is_created</fullName>
        <description>notify_client_when_task_is_created</description>
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
        <template>SDE_Emails/Task_Email_Template_1_Version_2</template>
    </alerts>
    <alerts>
        <fullName>notify_staff_when_a_task_has_been_assigned_to_them</fullName>
        <description>notify_staff_when_a_task_has_been_assigned_to_them</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SDE_Emails/Task_Email_Template_1_Version_2</template>
    </alerts>
    <alerts>
        <fullName>notify_staff_when_an_task_is_reopened</fullName>
        <description>notify_staff_when_an_task_is_reopened</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SDE_Emails/Task_Email_Template_2_Version_2</template>
    </alerts>
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
        <fullName>Notify the assigned staff member when a task is created and assigned to the staff member</fullName>
        <actions>
            <name>notify_staff_when_a_task_has_been_assigned_to_them</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Notifies the staff member when an incident is created and assigned to the staff member</description>
        <formula>$User.Id  &lt;&gt;  OwnerId  &amp;&amp;  state__c  = True</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Notify the assigned staff member when a task is reopened</fullName>
        <actions>
            <name>notify_staff_when_an_task_is_reopened</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Notifies the staff member when a closed task is reopened and assigned to the staff member</description>
        <formula>$User.Id  &lt;&gt;  OwnerId  &amp;&amp;  state__c  = True &amp;&amp;  PRIORVALUE( state__c )  = False</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Notify the client when a task is closed</fullName>
        <actions>
            <name>notify_client_when_task_is_closed</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Task__c.state__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Notifies the client that the client’s task is closed</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Notify the client when a task is created</fullName>
        <actions>
            <name>notify_client_when_task_is_created</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Task__c.state__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Notifies the client that the task requested by the client is created</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Notify the client when a task is reopened</fullName>
        <actions>
            <name>notify_client_when_an_task_is_reopened</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Notifies the client that the client’s task is reopened</description>
        <formula>state__c  = True &amp;&amp;  PRIORVALUE( state__c )  = False</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Open popup dialog for recalculating due date when priority of task changes</fullName>
        <actions>
            <name>Update_the_ShowDueDateDialog_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>This rule has been deprecated. If the rule is active, deactivate it.</description>
        <formula>ISCHANGED( FKPriority__c ) &amp;&amp;  IF( ShowDueDateDialog__c  = false,true, false)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>

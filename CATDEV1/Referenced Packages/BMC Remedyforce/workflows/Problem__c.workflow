<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Notify_problem_owner_when_each_linked_task_is_closed</fullName>
        <description>Notify problem owner when each linked task is closed</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SDE_Emails/Linked_task_for_a_problem_is_closed</template>
    </alerts>
    <alerts>
        <fullName>Notify_problem_owner_when_final_task_linked_to_problem_is_closed</fullName>
        <description>Notify problem owner when final task linked to problem is closed</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SDE_Emails/All_tasks_closed_for_problem</template>
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
        <fullName>Notify problem owner when each linked task is closed</fullName>
        <actions>
            <name>Notify_problem_owner_when_each_linked_task_is_closed</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Notify problem owner when each linked task is closed</description>
        <formula>AND( ISCHANGED( Task_Closed_Controller__c), NOT(ISBLANK( Task_Closed_Controller__c) ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Notify problem owner when final task linked to problem is closed</fullName>
        <actions>
            <name>Notify_problem_owner_when_final_task_linked_to_problem_is_closed</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Notify problem owner when final task linked to problem is closed</description>
        <formula>AND( State__c, NOT( Inactive__c ) , IF(AllTaskCloseController__c,  ISCHANGED(AllTaskCloseController__c) , false) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Open popup dialog for recalculating due date when priority of problem changes</fullName>
        <actions>
            <name>Update_the_ShowDueDateDialog_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>This rule has been deprecated. If the rule is active, deactivate it.</description>
        <formula>ISCHANGED( FKPriority__c ) &amp;&amp; IF( ShowDueDateDialog__c  = false, true, false)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>

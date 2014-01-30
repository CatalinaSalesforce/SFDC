<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Notify_Author_that_Article_is_due_for_review</fullName>
        <description>Notify author that knowledge article is due for review</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SDE_Emails/KM_Article_Due_for_Review</template>
    </alerts>
    <alerts>
        <fullName>Send_email_when_article_is_due_for_review</fullName>
        <description>Send email when article is due for review</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SDE_Emails/KM_Article_Due_for_Review</template>
    </alerts>
    <alerts>
        <fullName>Send_email_when_article_is_published</fullName>
        <description>Send email when article is published</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SDE_Emails/Notify_User_When_Article_is_published</template>
    </alerts>
    <rules>
        <fullName>Notify Author that Article is due for review</fullName>
        <active>true</active>
        <criteriaItems>
            <field>KM_KnowledgeArticle__c.Status__c</field>
            <operation>equals</operation>
            <value>Published</value>
        </criteriaItems>
        <description>Sends an email to the author of the knowledge article that the knowledge article is due for review in a month’s time.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Notify User Article is Published</fullName>
        <active>false</active>
        <description>[Deprecated] Sends an email to the user that the article has been published.</description>
        <formula>false</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Notify user that knowledge article is published</fullName>
        <actions>
            <name>Send_email_when_article_is_published</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>KM_KnowledgeArticle__c.Status__c</field>
            <operation>equals</operation>
            <value>Published</value>
        </criteriaItems>
        <description>Sends an email to the user that the article has been published</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>

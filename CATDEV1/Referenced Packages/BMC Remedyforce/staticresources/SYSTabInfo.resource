<rows>
<SYSTABINFO__C>
	<ID>id</ID>
	<OWNERID>reference</OWNERID>
	<ISDELETED>boolean</ISDELETED>
	<NAME>string</NAME>
	<CREATEDDATE>datetime</CREATEDDATE>
	<CREATEDBYID>reference</CREATEDBYID>
	<LASTMODIFIEDDATE>datetime</LASTMODIFIEDDATE>
	<LASTMODIFIEDBYID>reference</LASTMODIFIEDBYID>
	<SYSTEMMODSTAMP>datetime</SYSTEMMODSTAMP>
	<FKEY__C>string</FKEY__C>
	<SEQUENCE__C>string</SEQUENCE__C>
	<CHILDOBJECT__C>string</CHILDOBJECT__C>
	<EDITLINK__C>string</EDITLINK__C>
	<FORMNAME__C>string</FORMNAME__C>
	<NEWEDITLINK__C>string</NEWEDITLINK__C>
	<PARENTOBJECT__C>string</PARENTOBJECT__C>
	<TABNAME__C>string</TABNAME__C>
	<TABSEQUENCE__C>double</TABSEQUENCE__C>
</SYSTABINFO__C>
<row>
  <NAME>Incident History</NAME>
  <FKEY__C>FKIncident__c</FKEY__C>
  <CHILDOBJECT__C>IncidentHistory__c</CHILDOBJECT__C>
  <FORMNAME__C></FORMNAME__C>
  <NEWEDITLINK__C>searchPage?popupId=Action</NEWEDITLINK__C>
  <PARENTOBJECT__C>Incident__c</PARENTOBJECT__C>
  <TABNAME__C>History</TABNAME__C>
  <TABSEQUENCE__C>1.0</TABSEQUENCE__C>
  <EDITLINK__C>IncidentHistoryPage</EDITLINK__C>
  <SEQUENCE__C>1</SEQUENCE__C>
</row>
<row>
  <NAME>Incident Task</NAME>
  <FKEY__C>FKIncident__c</FKEY__C>
  <CHILDOBJECT__C>Task__c</CHILDOBJECT__C>
  <FORMNAME__C></FORMNAME__C>
  <NEWEDITLINK__C>taskPage</NEWEDITLINK__C>
  <PARENTOBJECT__C>Incident__c</PARENTOBJECT__C>
  <TABNAME__C>Tasks</TABNAME__C>
  <TABSEQUENCE__C>2.0</TABSEQUENCE__C>
  <EDITLINK__C>taskPage</EDITLINK__C>
  <SEQUENCE__C>2</SEQUENCE__C>
</row>
<row>
  <NAME>Incident Documentation</NAME>
  <FKEY__C>parentId__c</FKEY__C>
  <CHILDOBJECT__C>CustomAttachment__c</CHILDOBJECT__C>
  <FORMNAME__C></FORMNAME__C>
  <NEWEDITLINK__C>DocumentationPage</NEWEDITLINK__C>
  <PARENTOBJECT__C>Incident__c</PARENTOBJECT__C>
  <TABNAME__C>Documentation</TABNAME__C>
  <TABSEQUENCE__C>6.0</TABSEQUENCE__C>
  <EDITLINK__C></EDITLINK__C>
  <SEQUENCE__C>3</SEQUENCE__C>
</row>
<row>
  <NAME>Incident Auditing</NAME>
  <FKEY__C>ParentId</FKEY__C>
  <CHILDOBJECT__C>Incident__History</CHILDOBJECT__C>
  <FORMNAME__C></FORMNAME__C>
  <NEWEDITLINK__C>dummy</NEWEDITLINK__C>
  <PARENTOBJECT__C>Incident__c</PARENTOBJECT__C>
  <TABNAME__C>Auditing</TABNAME__C>
  <TABSEQUENCE__C>7.0</TABSEQUENCE__C>
  <EDITLINK__C></EDITLINK__C>
  <SEQUENCE__C>4</SEQUENCE__C>
</row>
<row>
  <NAME>Task History</NAME>
  <FKEY__C>FKWO__c</FKEY__C>
  <CHILDOBJECT__C>TaskHistory__c</CHILDOBJECT__C>
  <FORMNAME__C></FORMNAME__C>
  <NEWEDITLINK__C>searchPage?popupId=Action</NEWEDITLINK__C>
  <PARENTOBJECT__C>Task__c</PARENTOBJECT__C>
  <TABNAME__C>History</TABNAME__C>
  <TABSEQUENCE__C>1.0</TABSEQUENCE__C>
  <EDITLINK__C>taskHistoryPage</EDITLINK__C>
  <SEQUENCE__C>5</SEQUENCE__C>
</row>
<row>
  <NAME>Task Configuration Items</NAME>
  <FKEY__C>dummy</FKEY__C>
  <CHILDOBJECT__C>BMC_BaseElement__c</CHILDOBJECT__C>
  <FORMNAME__C></FORMNAME__C>
  <NEWEDITLINK__C>dummy</NEWEDITLINK__C>
  <PARENTOBJECT__C>Task__c</PARENTOBJECT__C>
  <TABNAME__C>Services and CIs</TABNAME__C>
  <TABSEQUENCE__C>2.0</TABSEQUENCE__C>
  <EDITLINK__C></EDITLINK__C>
  <SEQUENCE__C>6</SEQUENCE__C>
</row>
<row>
  <NAME>Task Documentation</NAME>
  <FKEY__C>parentId__c</FKEY__C>
  <CHILDOBJECT__C>CustomAttachment__c</CHILDOBJECT__C>
  <FORMNAME__C></FORMNAME__C>
  <NEWEDITLINK__C>DocumentationPage</NEWEDITLINK__C>
  <PARENTOBJECT__C>Task__c</PARENTOBJECT__C>
  <TABNAME__C>Documentation</TABNAME__C>
  <TABSEQUENCE__C>3.0</TABSEQUENCE__C>
  <EDITLINK__C></EDITLINK__C>
  <SEQUENCE__C>7</SEQUENCE__C>
</row>
<row>
  <NAME>Task Auditing</NAME>
  <FKEY__C>ParentId</FKEY__C>
  <CHILDOBJECT__C>Task__History</CHILDOBJECT__C>
  <FORMNAME__C></FORMNAME__C>
  <NEWEDITLINK__C>dummy</NEWEDITLINK__C>
  <PARENTOBJECT__C>Task__c</PARENTOBJECT__C>
  <TABNAME__C>Auditing</TABNAME__C>
  <TABSEQUENCE__C>4.0</TABSEQUENCE__C>
  <EDITLINK__C></EDITLINK__C>
  <SEQUENCE__C>8</SEQUENCE__C>
</row>
<row>
  <NAME>Broadcast History</NAME>
  <FKEY__C>FKBroadcast__c</FKEY__C>
  <CHILDOBJECT__C>BroadcastHistory__c</CHILDOBJECT__C>
  <FORMNAME__C></FORMNAME__C>
  <NEWEDITLINK__C>searchPage?popupId=Action</NEWEDITLINK__C>
  <PARENTOBJECT__C>Broadcasts__c</PARENTOBJECT__C>
  <TABNAME__C>History</TABNAME__C>
  <TABSEQUENCE__C>1.0</TABSEQUENCE__C>
  <EDITLINK__C>BroadcastHistoryPage</EDITLINK__C>
  <SEQUENCE__C>9</SEQUENCE__C>
</row>
<row>
  <NAME>Broadcast Incident</NAME>
  <FKEY__C>FKBroadcast__c</FKEY__C>
  <CHILDOBJECT__C>Incident__c</CHILDOBJECT__C>
  <FORMNAME__C></FORMNAME__C>
  <NEWEDITLINK__C>IncidentPage</NEWEDITLINK__C>
  <PARENTOBJECT__C>Broadcasts__c</PARENTOBJECT__C>
  <TABNAME__C>Incidents</TABNAME__C>
  <TABSEQUENCE__C>2.0</TABSEQUENCE__C>
  <EDITLINK__C>IncidentPage</EDITLINK__C>
  <SEQUENCE__C>10</SEQUENCE__C>
</row>
<row>
  <NAME>Broadcast Auditing</NAME>
  <FKEY__C>ParentId</FKEY__C>
  <CHILDOBJECT__C>Broadcasts__History</CHILDOBJECT__C>
  <FORMNAME__C></FORMNAME__C>
  <NEWEDITLINK__C>dummy</NEWEDITLINK__C>
  <PARENTOBJECT__C>Broadcasts__c</PARENTOBJECT__C>
  <TABNAME__C>Auditing</TABNAME__C>
  <TABSEQUENCE__C>3.0</TABSEQUENCE__C>
  <EDITLINK__C></EDITLINK__C>
  <SEQUENCE__C>11</SEQUENCE__C>
</row>
<row>
  <NAME>Client Incident</NAME>
  <FKEY__C>FKClient__c</FKEY__C>
  <CHILDOBJECT__C>Incident__c</CHILDOBJECT__C>
  <FORMNAME__C></FORMNAME__C>
  <NEWEDITLINK__C>IncidentPage</NEWEDITLINK__C>
  <PARENTOBJECT__C>User</PARENTOBJECT__C>
  <TABNAME__C>Incidents</TABNAME__C>
  <TABSEQUENCE__C>1.0</TABSEQUENCE__C>
  <EDITLINK__C>IncidentPage</EDITLINK__C>
  <SEQUENCE__C>12</SEQUENCE__C>
</row>
<row>
  <NAME>Approvals</NAME>
  <FKEY__C>TargetObjectId</FKEY__C>
  <CHILDOBJECT__C>ProcessInstance</CHILDOBJECT__C>
  <FORMNAME__C></FORMNAME__C>
  <NEWEDITLINK__C>dummy</NEWEDITLINK__C>
  <PARENTOBJECT__C>Incident__c</PARENTOBJECT__C>
  <TABNAME__C>IApprovals</TABNAME__C>
  <TABSEQUENCE__C>4.0</TABSEQUENCE__C>
  <EDITLINK__C>Changeapproval</EDITLINK__C>
  <SEQUENCE__C>54</SEQUENCE__C>
</row>
<row>
  <NAME>Client Configuraton Items</NAME>
  <FKEY__C>dummy</FKEY__C>
  <CHILDOBJECT__C>BMC_BaseElement__c</CHILDOBJECT__C>
  <FORMNAME__C></FORMNAME__C>
  <NEWEDITLINK__C>dummy</NEWEDITLINK__C>
  <PARENTOBJECT__C>User</PARENTOBJECT__C>
  <TABNAME__C>Services and CIs</TABNAME__C>
  <TABSEQUENCE__C>2.0</TABSEQUENCE__C>
  <EDITLINK__C>CMDBManager</EDITLINK__C>
  <SEQUENCE__C>13</SEQUENCE__C>
</row>
<row>
  <NAME>Client Auditing</NAME>
  <FKEY__C>id</FKEY__C>
  <CHILDOBJECT__C>User</CHILDOBJECT__C>
  <FORMNAME__C></FORMNAME__C>
  <NEWEDITLINK__C>dummy</NEWEDITLINK__C>
  <PARENTOBJECT__C>User</PARENTOBJECT__C>
  <TABNAME__C>Auditing</TABNAME__C>
  <TABSEQUENCE__C>3.0</TABSEQUENCE__C>
  <EDITLINK__C></EDITLINK__C>
  <SEQUENCE__C>14</SEQUENCE__C>
</row>
<row>
  <NAME>Organization Client</NAME>
  <FKEY__C>dummy</FKEY__C>
  <CHILDOBJECT__C>User</CHILDOBJECT__C>
  <FORMNAME__C></FORMNAME__C>
  <NEWEDITLINK__C>ClientPage</NEWEDITLINK__C>
  <PARENTOBJECT__C>Account</PARENTOBJECT__C>
  <TABNAME__C>Clients</TABNAME__C>
  <TABSEQUENCE__C>1.0</TABSEQUENCE__C>
  <EDITLINK__C>ClientPage</EDITLINK__C>
  <SEQUENCE__C>15</SEQUENCE__C>
</row>
<row>
  <NAME>Organization Child Organization</NAME>
  <FKEY__C>ParentId</FKEY__C>
  <CHILDOBJECT__C>Account</CHILDOBJECT__C>
  <FORMNAME__C></FORMNAME__C>
  <NEWEDITLINK__C>OrganizationPage</NEWEDITLINK__C>
  <PARENTOBJECT__C>Account</PARENTOBJECT__C>
  <TABNAME__C>Child Accounts</TABNAME__C>
  <TABSEQUENCE__C>2.0</TABSEQUENCE__C>
  <EDITLINK__C>OrganizationPage</EDITLINK__C>
  <SEQUENCE__C>16</SEQUENCE__C>
</row>
<row>
  <NAME>Organization Documentation</NAME>
  <FKEY__C>parentId__c</FKEY__C>
  <CHILDOBJECT__C>CustomAttachment__c</CHILDOBJECT__C>
  <FORMNAME__C></FORMNAME__C>
  <NEWEDITLINK__C>DocumentationPage</NEWEDITLINK__C>
  <PARENTOBJECT__C>Account</PARENTOBJECT__C>
  <TABNAME__C>Documentation</TABNAME__C>
  <TABSEQUENCE__C>4.0</TABSEQUENCE__C>
  <EDITLINK__C></EDITLINK__C>
  <SEQUENCE__C>17</SEQUENCE__C>
</row>
<row>
  <NAME>Category Child Categories</NAME>
  <FKEY__C>FKParentCategory__c</FKEY__C>
  <CHILDOBJECT__C>Category__c</CHILDOBJECT__C>
  <FORMNAME__C></FORMNAME__C>
  <NEWEDITLINK__C>categoryPage</NEWEDITLINK__C>
  <PARENTOBJECT__C>Category__c</PARENTOBJECT__C>
  <TABNAME__C>Child Categories</TABNAME__C>
  <TABSEQUENCE__C>1.0</TABSEQUENCE__C>
  <EDITLINK__C>categoryPage</EDITLINK__C>
  <SEQUENCE__C>18</SEQUENCE__C>
</row>
<row>
  <NAME>Category Standard Description</NAME>
  <FKEY__C>FKCategory__c</FKEY__C>
  <CHILDOBJECT__C>StandardDescription__c</CHILDOBJECT__C>
  <FORMNAME__C></FORMNAME__C>
  <NEWEDITLINK__C>StandardDescriptionPage</NEWEDITLINK__C>
  <PARENTOBJECT__C>Category__c</PARENTOBJECT__C>
  <TABNAME__C>Standard Descriptions</TABNAME__C>
  <TABSEQUENCE__C>2.0</TABSEQUENCE__C>
  <EDITLINK__C>StandardDescriptionPage</EDITLINK__C>
  <SEQUENCE__C>19</SEQUENCE__C>
</row>
<row>
  <NAME>Category Support Experts</NAME>
  <FKEY__C>FKCategory__c</FKEY__C>
  <CHILDOBJECT__C>SupportAssignments__c</CHILDOBJECT__C>
  <FORMNAME__C></FORMNAME__C>
  <NEWEDITLINK__C>searchPage?popupId=Client</NEWEDITLINK__C>
  <PARENTOBJECT__C>Category__c</PARENTOBJECT__C>
  <TABNAME__C>Support Experts</TABNAME__C>
  <TABSEQUENCE__C>4.0</TABSEQUENCE__C>
  <EDITLINK__C>dummy</EDITLINK__C>
  <SEQUENCE__C>21</SEQUENCE__C>
</row>
<row>
  <NAME>Category Types Categories</NAME>
  <FKEY__C>FKCategoryType__c</FKEY__C>
  <CHILDOBJECT__C>Category__c</CHILDOBJECT__C>
  <FORMNAME__C></FORMNAME__C>
  <NEWEDITLINK__C>categorypage</NEWEDITLINK__C>
  <PARENTOBJECT__C>CategoryTypes__c</PARENTOBJECT__C>
  <TABNAME__C>Categories</TABNAME__C>
  <TABSEQUENCE__C>1.0</TABSEQUENCE__C>
  <EDITLINK__C>categorypage</EDITLINK__C>
  <SEQUENCE__C>22</SEQUENCE__C>
</row>
<row>
  <NAME>Standard Description Resolution</NAME>
  <FKEY__C>FKStandardDescription__C</FKEY__C>
  <CHILDOBJECT__C>StandardResolution__c</CHILDOBJECT__C>
  <FORMNAME__C></FORMNAME__C>
  <NEWEDITLINK__C>StandardResolutionPage</NEWEDITLINK__C>
  <PARENTOBJECT__C>StandardDescription__c</PARENTOBJECT__C>
  <TABNAME__C>Standard Resolution</TABNAME__C>
  <TABSEQUENCE__C>1.0</TABSEQUENCE__C>
  <EDITLINK__C>StandardResolutionPage</EDITLINK__C>
  <SEQUENCE__C>23</SEQUENCE__C>
</row>
<row>
  <NAME>Template Tasks</NAME>
  <FKEY__C>Id</FKEY__C>
  <CHILDOBJECT__C>IncidentTemplate__C</CHILDOBJECT__C>
  <FORMNAME__C></FORMNAME__C>
  <NEWEDITLINK__C>TemplatePage</NEWEDITLINK__C>
  <PARENTOBJECT__C>IncidentTemplate__C</PARENTOBJECT__C>
  <TABNAME__C>Tasks</TABNAME__C>
  <TABSEQUENCE__C>1.0</TABSEQUENCE__C>
  <EDITLINK__C>TemplatePage</EDITLINK__C>
  <SEQUENCE__C>24</SEQUENCE__C>
</row>
<row>
  <NAME>Change History</NAME>
  <FKEY__C>FKChange__c</FKEY__C>
  <CHILDOBJECT__C>Change_History__c</CHILDOBJECT__C>
  <FORMNAME__C></FORMNAME__C>
  <NEWEDITLINK__C>searchPage?popupId=Action</NEWEDITLINK__C>
  <PARENTOBJECT__C>Change_Request__c</PARENTOBJECT__C>
  <TABNAME__C>History</TABNAME__C>
  <TABSEQUENCE__C>1.0</TABSEQUENCE__C>
  <EDITLINK__C>ObjectHistoryPage</EDITLINK__C>
  <SEQUENCE__C>25</SEQUENCE__C>
</row>
<row>
  <NAME>Change Problem</NAME>
  <FKEY__C>dummy</FKEY__C>
  <CHILDOBJECT__C>Problem__c</CHILDOBJECT__C>
  <FORMNAME__C></FORMNAME__C>
  <NEWEDITLINK__C>ProblemPage</NEWEDITLINK__C>
  <PARENTOBJECT__C>Change_Request__c</PARENTOBJECT__C>
  <TABNAME__C>Problems</TABNAME__C>
  <TABSEQUENCE__C>2.0</TABSEQUENCE__C>
  <EDITLINK__C>ProblemPage</EDITLINK__C>
  <SEQUENCE__C>26</SEQUENCE__C>
</row>
<row>
  <NAME>Change Configuration Items</NAME>
  <FKEY__C>dummy</FKEY__C>
  <CHILDOBJECT__C>BMC_BaseElement__c</CHILDOBJECT__C>
  <FORMNAME__C></FORMNAME__C>
  <NEWEDITLINK__C>dummy</NEWEDITLINK__C>
  <PARENTOBJECT__C>Change_Request__c</PARENTOBJECT__C>
 <TABNAME__C>Services and CIs</TABNAME__C>
  <TABSEQUENCE__C>3.0</TABSEQUENCE__C>
  <EDITLINK__C>dummy</EDITLINK__C>
  <SEQUENCE__C>27</SEQUENCE__C>
</row>
<row>
  <NAME>Change Assessments</NAME>
  <FKEY__C>FKChange__c</FKEY__C>
  <CHILDOBJECT__C>Change_Assessment__c</CHILDOBJECT__C>
  <FORMNAME__C></FORMNAME__C>
  <NEWEDITLINK__C>ChangeAssessmentPage</NEWEDITLINK__C>
  <PARENTOBJECT__C>Change_Request__c</PARENTOBJECT__C>
  <TABNAME__C>Assessments</TABNAME__C>
  <TABSEQUENCE__C>4.0</TABSEQUENCE__C>
  <EDITLINK__C>ChangeAssessmentPage</EDITLINK__C>
  <SEQUENCE__C>28</SEQUENCE__C>
</row>
<row>
  <NAME>Approvals</NAME>
  <FKEY__C>TargetObjectId</FKEY__C>
  <CHILDOBJECT__C>ProcessInstance</CHILDOBJECT__C>
  <FORMNAME__C></FORMNAME__C>
  <NEWEDITLINK__C>dummy</NEWEDITLINK__C>
  <PARENTOBJECT__C>Change_Request__c</PARENTOBJECT__C>
  <TABNAME__C>CApprovals</TABNAME__C>
  <TABSEQUENCE__C>5.0</TABSEQUENCE__C>
  <EDITLINK__C>Changeapproval</EDITLINK__C>
  <SEQUENCE__C>29</SEQUENCE__C>
</row>
<row>
  <NAME>Change Documentation</NAME>
  <FKEY__C>parentId__c</FKEY__C>
  <CHILDOBJECT__C>CustomAttachment__c</CHILDOBJECT__C>
  <FORMNAME__C></FORMNAME__C>
  <NEWEDITLINK__C>DocumentationPage</NEWEDITLINK__C>
  <PARENTOBJECT__C>Change_Request__c</PARENTOBJECT__C>
  <TABNAME__C>Documentation</TABNAME__C>
  <TABSEQUENCE__C>8.0</TABSEQUENCE__C>
  <EDITLINK__C></EDITLINK__C>
  <SEQUENCE__C>30</SEQUENCE__C>
</row>
<row>
  <NAME>Change Tasks</NAME>
  <FKEY__C>FKChange__c</FKEY__C>
  <CHILDOBJECT__C>Task__c</CHILDOBJECT__C>
  <FORMNAME__C></FORMNAME__C>
  <NEWEDITLINK__C>taskPage</NEWEDITLINK__C>
  <PARENTOBJECT__C>Change_Request__c</PARENTOBJECT__C>
  <TABNAME__C>Tasks</TABNAME__C>
  <TABSEQUENCE__C>6.0</TABSEQUENCE__C>
  <EDITLINK__C>taskPage</EDITLINK__C>
  <SEQUENCE__C>31</SEQUENCE__C>
</row>
<row>
  <NAME>Change Incidents</NAME>
  <FKEY__C>dummy</FKEY__C>
  <CHILDOBJECT__C>Incident__c</CHILDOBJECT__C>
  <FORMNAME__C></FORMNAME__C>
  <NEWEDITLINK__C>incidentpage</NEWEDITLINK__C>
  <PARENTOBJECT__C>Change_Request__c</PARENTOBJECT__C>
  <TABNAME__C>Incidents</TABNAME__C>
  <TABSEQUENCE__C>7.0</TABSEQUENCE__C>
  <EDITLINK__C>incidentpage</EDITLINK__C>
  <SEQUENCE__C>32</SEQUENCE__C>
</row>
<row>
  <NAME>Change Auditing</NAME>
  <FKEY__C>ParentId</FKEY__C>
  <CHILDOBJECT__C>Change_Request__History</CHILDOBJECT__C>
  <FORMNAME__C></FORMNAME__C>
  <NEWEDITLINK__C>dummy</NEWEDITLINK__C>
  <PARENTOBJECT__C>Change_Request__c</PARENTOBJECT__C>
  <TABNAME__C>Auditing</TABNAME__C>
  <TABSEQUENCE__C>9.0</TABSEQUENCE__C>
  <EDITLINK__C>dummy</EDITLINK__C>
  <SEQUENCE__C>33</SEQUENCE__C>
</row>
<row>
  <NAME>Problem History</NAME>
  <FKEY__C>FKProblem__c</FKEY__C>
  <CHILDOBJECT__C>Problem_History__c</CHILDOBJECT__C>
  <FORMNAME__C></FORMNAME__C>
  <NEWEDITLINK__C>searchPage?popupId=Action</NEWEDITLINK__C>
  <PARENTOBJECT__C>Problem__c</PARENTOBJECT__C>
  <TABNAME__C>History</TABNAME__C>
  <TABSEQUENCE__C>1.0</TABSEQUENCE__C>
  <EDITLINK__C>ObjectHistoryPage</EDITLINK__C>
  <SEQUENCE__C>34</SEQUENCE__C>
</row>
<row>
  <NAME>Problem Incidents</NAME>
  <FKEY__C>dummy</FKEY__C>
  <CHILDOBJECT__C>Incident__c</CHILDOBJECT__C>
  <FORMNAME__C></FORMNAME__C>
  <NEWEDITLINK__C>IncidentPage</NEWEDITLINK__C>
  <PARENTOBJECT__C>Problem__c</PARENTOBJECT__C>
  <TABNAME__C>Incidents</TABNAME__C>
  <TABSEQUENCE__C>2.0</TABSEQUENCE__C>
  <EDITLINK__C>IncidentPage</EDITLINK__C>
  <SEQUENCE__C>35</SEQUENCE__C>
</row>
<row>
  <NAME>Problem Changes</NAME>
  <FKEY__C>dummy</FKEY__C>
  <CHILDOBJECT__C>Change_Request__c</CHILDOBJECT__C>
  <FORMNAME__C></FORMNAME__C>
  <NEWEDITLINK__C>ChangeRequestPage</NEWEDITLINK__C>
  <PARENTOBJECT__C>Problem__c</PARENTOBJECT__C>
  <TABNAME__C>Changes</TABNAME__C>
  <TABSEQUENCE__C>3.0</TABSEQUENCE__C>
  <EDITLINK__C>ChangeRequestPage</EDITLINK__C>
  <SEQUENCE__C>36</SEQUENCE__C>
</row>
<row>
  <NAME>Problem Configuration Items</NAME>
  <FKEY__C>dummy</FKEY__C>
  <CHILDOBJECT__C>BMC_BaseElement__c</CHILDOBJECT__C>
  <FORMNAME__C></FORMNAME__C>
  <NEWEDITLINK__C>dummy</NEWEDITLINK__C>
  <PARENTOBJECT__C>Problem__c</PARENTOBJECT__C>
  <TABNAME__C>Services and CIs</TABNAME__C>
  <TABSEQUENCE__C>4.0</TABSEQUENCE__C>
  <EDITLINK__C>dummy</EDITLINK__C>
  <SEQUENCE__C>37</SEQUENCE__C>
</row>
<row>
  <NAME>Problem Tasks</NAME>
  <FKEY__C>FKProblem__c</FKEY__C>
  <CHILDOBJECT__C>Task__c</CHILDOBJECT__C>
  <FORMNAME__C></FORMNAME__C>
  <NEWEDITLINK__C>TaskPage</NEWEDITLINK__C>
  <PARENTOBJECT__C>Problem__c</PARENTOBJECT__C>
  <TABNAME__C>Tasks</TABNAME__C>
  <TABSEQUENCE__C>5.0</TABSEQUENCE__C>
  <EDITLINK__C>TaskPage</EDITLINK__C>
  <SEQUENCE__C>38</SEQUENCE__C>
</row>
<row>
  <NAME>Problem Documentation</NAME>
  <FKEY__C>parentId__c</FKEY__C>
  <CHILDOBJECT__C>CustomAttachment__c</CHILDOBJECT__C>
  <FORMNAME__C></FORMNAME__C>
  <NEWEDITLINK__C>DocumentationPage</NEWEDITLINK__C>
  <PARENTOBJECT__C>Problem__c</PARENTOBJECT__C>
  <TABNAME__C>Documentation</TABNAME__C>
  <TABSEQUENCE__C>6.0</TABSEQUENCE__C>
  <EDITLINK__C>dummy</EDITLINK__C>
  <SEQUENCE__C>39</SEQUENCE__C>
</row>
<row>
  <NAME>Problem Auditing</NAME>
  <FKEY__C>ParentId</FKEY__C>
  <CHILDOBJECT__C>Problem__History</CHILDOBJECT__C>
  <FORMNAME__C></FORMNAME__C>
  <NEWEDITLINK__C>dummy</NEWEDITLINK__C>
  <PARENTOBJECT__C>Problem__c</PARENTOBJECT__C>
  <TABNAME__C>Auditing</TABNAME__C>
  <TABSEQUENCE__C>7.0</TABSEQUENCE__C>
  <EDITLINK__C></EDITLINK__C>
  <SEQUENCE__C>40</SEQUENCE__C>
</row>
<row>
  <NAME>Incident Change</NAME>
  <FKEY__C>dummy</FKEY__C>
  <CHILDOBJECT__C>Change_Request__c</CHILDOBJECT__C>
  <FORMNAME__C></FORMNAME__C>
  <NEWEDITLINK__C>ChangeRequestPage</NEWEDITLINK__C>
  <PARENTOBJECT__C>Incident__c</PARENTOBJECT__C>
  <TABNAME__C>Changes</TABNAME__C>
  <TABSEQUENCE__C>5.0</TABSEQUENCE__C>
  <EDITLINK__C>ChangeRequestPage</EDITLINK__C>
  <SEQUENCE__C>41</SEQUENCE__C>
</row>
<row>
  <NAME>Configuration Item Incident</NAME>
  <FKEY__C>FKBMC_BaseElement__c</FKEY__C>
  <CHILDOBJECT__C>Incident__c</CHILDOBJECT__C>
  <FORMNAME__C></FORMNAME__C>
  <NEWEDITLINK__C>Incidentpage</NEWEDITLINK__C>
  <PARENTOBJECT__C>BMC_BaseElement__c</PARENTOBJECT__C>
  <TABNAME__C>Incidents</TABNAME__C>
  <TABSEQUENCE__C>5.0</TABSEQUENCE__C>
  <EDITLINK__C>Incidentpage</EDITLINK__C>
  <SEQUENCE__C>42</SEQUENCE__C>
</row>
<row>
  <NAME>Configuration Item Documentation</NAME>
  <FKEY__C>parentId__c</FKEY__C>
  <CHILDOBJECT__C>CustomAttachment__c</CHILDOBJECT__C>
  <FORMNAME__C></FORMNAME__C>
  <NEWEDITLINK__C>DocumentationPage</NEWEDITLINK__C>
  <PARENTOBJECT__C>BMC_BaseElement__c</PARENTOBJECT__C>
  <TABNAME__C>Documentation</TABNAME__C>
  <TABSEQUENCE__C>10.0</TABSEQUENCE__C>
  <EDITLINK__C></EDITLINK__C>
  <SEQUENCE__C>43</SEQUENCE__C>
</row>
<row>
  <NAME>Service SLA</NAME>
  <FKEY__C>FKBusinessService__c</FKEY__C>
  <CHILDOBJECT__C>ServiceLevelAgreement__c</CHILDOBJECT__C>
  <FORMNAME__C></FORMNAME__C>
  <NEWEDITLINK__C>SLAPage</NEWEDITLINK__C>
  <PARENTOBJECT__C>BMC_BaseElement__c</PARENTOBJECT__C>
  <TABNAME__C>Agreements</TABNAME__C>
  <TABSEQUENCE__C>2.0</TABSEQUENCE__C>
  <EDITLINK__C>SLAPage</EDITLINK__C>
  <SEQUENCE__C>44</SEQUENCE__C>
</row>
<row>
  <NAME>Configuration Item Change Request</NAME>
  <FKEY__C>dummy</FKEY__C>
  <CHILDOBJECT__C>Change_Request__c</CHILDOBJECT__C>
  <FORMNAME__C></FORMNAME__C>
  <NEWEDITLINK__C>ChangeRequestPage</NEWEDITLINK__C>
  <PARENTOBJECT__C>BMC_BaseElement__c</PARENTOBJECT__C>
  <TABNAME__C>Changes</TABNAME__C>
  <TABSEQUENCE__C>6.0</TABSEQUENCE__C>
  <EDITLINK__C>ChangeRequestPage</EDITLINK__C>
  <SEQUENCE__C>45</SEQUENCE__C>
</row>
<row>
  <NAME>Configuration Item Problem</NAME>
  <FKEY__C>dummy</FKEY__C>
  <CHILDOBJECT__C>Problem__c</CHILDOBJECT__C>
  <FORMNAME__C></FORMNAME__C>
  <NEWEDITLINK__C>ProblemPage</NEWEDITLINK__C>
  <PARENTOBJECT__C>BMC_BaseElement__c</PARENTOBJECT__C>
  <TABNAME__C>Problems</TABNAME__C>
  <TABSEQUENCE__C>7.0</TABSEQUENCE__C>
  <EDITLINK__C>ProblemPage</EDITLINK__C>
  <SEQUENCE__C>46</SEQUENCE__C>
</row>
<row>
  <NAME>Configuration Item History</NAME>
  <FKEY__C>FKBMC_BaseElement__c</FKEY__C>
  <CHILDOBJECT__C>BMC_BaseElement_History__c</CHILDOBJECT__C>
  <FORMNAME__C></FORMNAME__C>
  <NEWEDITLINK__C>searchPage?popupId=Action</NEWEDITLINK__C>
  <PARENTOBJECT__C>BMC_BaseElement__c</PARENTOBJECT__C>
  <TABNAME__C>History</TABNAME__C>
  <TABSEQUENCE__C>1.0</TABSEQUENCE__C>
  <EDITLINK__C>ObjectHistoryPage</EDITLINK__C>
  <SEQUENCE__C>47</SEQUENCE__C>
</row>
<row>
  <NAME>Configuration Item Client</NAME>
  <FKEY__C>dummy</FKEY__C>
  <CHILDOBJECT__C>User</CHILDOBJECT__C>
  <FORMNAME__C></FORMNAME__C>
  <NEWEDITLINK__C>dummy</NEWEDITLINK__C>
  <PARENTOBJECT__C>BMC_BaseElement__c</PARENTOBJECT__C>
  <TABNAME__C>Clients</TABNAME__C>
  <TABSEQUENCE__C>3.0</TABSEQUENCE__C>
  <EDITLINK__C>ClientPage</EDITLINK__C>
  <SEQUENCE__C>48</SEQUENCE__C>
</row>
<row>
  <NAME>SLA History</NAME>
  <FKEY__C>FKSLA__c</FKEY__C>
  <CHILDOBJECT__C>SLA_History__c</CHILDOBJECT__C>
  <FORMNAME__C></FORMNAME__C>
  <NEWEDITLINK__C>searchPage?popupId=Action</NEWEDITLINK__C>
  <PARENTOBJECT__C>ServiceLevelAgreement__c</PARENTOBJECT__C>
  <TABNAME__C>History</TABNAME__C>
  <TABSEQUENCE__C>1.0</TABSEQUENCE__C>
  <EDITLINK__C>ObjectHistoryPage</EDITLINK__C>
  <SEQUENCE__C>49</SEQUENCE__C>
</row>
<row>
  <NAME>SLA Incident</NAME>
  <FKEY__C>dummy</FKEY__C>
  <CHILDOBJECT__C>Incident__c</CHILDOBJECT__C>
  <FORMNAME__C></FORMNAME__C>
  <NEWEDITLINK__C>dummy</NEWEDITLINK__C>
  <PARENTOBJECT__C>ServiceLevelAgreement__c</PARENTOBJECT__C>
  <TABNAME__C>Incidents</TABNAME__C>
  <TABSEQUENCE__C>2.0</TABSEQUENCE__C>
  <EDITLINK__C>dummy</EDITLINK__C>
  <SEQUENCE__C>50</SEQUENCE__C>
</row>
<row>
  <NAME>SLA Change Request</NAME>
  <FKEY__C>dummy</FKEY__C>
  <CHILDOBJECT__C>Change_Request__c</CHILDOBJECT__C>
  <FORMNAME__C></FORMNAME__C>
  <NEWEDITLINK__C>dummy</NEWEDITLINK__C>
  <PARENTOBJECT__C>ServiceLevelAgreement__c</PARENTOBJECT__C>
  <TABNAME__C>Changes</TABNAME__C>
  <TABSEQUENCE__C>3.0</TABSEQUENCE__C>
  <EDITLINK__C>dummy</EDITLINK__C>
  <SEQUENCE__C>51</SEQUENCE__C>
</row>

<row>
  <NAME>SLA Auditing</NAME>
  <FKEY__C>ParentId</FKEY__C>
  <CHILDOBJECT__C>ServiceLevelAgreement__History</CHILDOBJECT__C>
  <FORMNAME__C></FORMNAME__C>
  <NEWEDITLINK__C>dummy</NEWEDITLINK__C>
  <PARENTOBJECT__C>ServiceLevelAgreement__c</PARENTOBJECT__C>
  <TABNAME__C>Auditing</TABNAME__C>
  <TABSEQUENCE__C>6.0</TABSEQUENCE__C>
  <EDITLINK__C></EDITLINK__C>
  <SEQUENCE__C>52</SEQUENCE__C>
</row>
<row>
  <NAME>SLA Documentation</NAME>
  <FKEY__C>parentId__c</FKEY__C>
  <CHILDOBJECT__C>CustomAttachment__c</CHILDOBJECT__C>
  <FORMNAME__C></FORMNAME__C>
  <NEWEDITLINK__C>DocumentationPage</NEWEDITLINK__C>
  <PARENTOBJECT__C>ServiceLevelAgreement__c</PARENTOBJECT__C>
  <TABNAME__C>Documentation</TABNAME__C>
  <TABSEQUENCE__C>5.0</TABSEQUENCE__C>
  <EDITLINK__C></EDITLINK__C>
  <SEQUENCE__C>53</SEQUENCE__C>
</row>


<!-- Addition of new tab Additional Configuration Items on Incident form -->
<row>
  <NAME>Incident Configuration Items</NAME>
  <FKEY__C>dummy</FKEY__C>
  <CHILDOBJECT__C>BMC_BaseElement__c</CHILDOBJECT__C>
  <FORMNAME__C></FORMNAME__C>
  <NEWEDITLINK__C>dummy</NEWEDITLINK__C>
  <PARENTOBJECT__C>Incident__c</PARENTOBJECT__C>
  <TABNAME__C>Additional CIs</TABNAME__C>
  <TABSEQUENCE__C>3.0</TABSEQUENCE__C>
  <EDITLINK__C></EDITLINK__C>
  <SEQUENCE__C>55</SEQUENCE__C>
</row>
<row>
  <NAME>Account Configuration Items</NAME>
  <FKEY__C>dummy</FKEY__C>
  <CHILDOBJECT__C>BMC_BaseElement__c</CHILDOBJECT__C>
  <FORMNAME__C></FORMNAME__C>
  <NEWEDITLINK__C>dummy</NEWEDITLINK__C>
  <PARENTOBJECT__C>Account</PARENTOBJECT__C>
  <TABNAME__C>Services and CIs</TABNAME__C>
  <TABSEQUENCE__C>3.0</TABSEQUENCE__C>
  <EDITLINK__C>dummy</EDITLINK__C>
  <SEQUENCE__C>56</SEQUENCE__C>
</row>
<row>
  <NAME>Configuration Item Accounts</NAME>
  <FKEY__C>dummy</FKEY__C>
  <CHILDOBJECT__C>Account</CHILDOBJECT__C>
  <FORMNAME__C></FORMNAME__C>
  <NEWEDITLINK__C>dummy</NEWEDITLINK__C>
  <PARENTOBJECT__C>BMC_BaseElement__c</PARENTOBJECT__C>
  <TABNAME__C>Accounts</TABNAME__C>
  <TABSEQUENCE__C>4.0</TABSEQUENCE__C>
  <EDITLINK__C>dummy</EDITLINK__C>
  <SEQUENCE__C>57</SEQUENCE__C>
</row>
<row>
  <NAME>Configuration Item Release</NAME>
  <FKEY__C>dummy</FKEY__C>
  <CHILDOBJECT__C>Release__c</CHILDOBJECT__C>
  <FORMNAME__C></FORMNAME__C>
  <NEWEDITLINK__C>dummy</NEWEDITLINK__C>
  <PARENTOBJECT__C>BMC_BaseElement__c</PARENTOBJECT__C>
  <TABNAME__C>Releases</TABNAME__C>
  <TABSEQUENCE__C>8.0</TABSEQUENCE__C>
  <EDITLINK__C>ReleasePage</EDITLINK__C>
  <SEQUENCE__C>58</SEQUENCE__C>
</row>
<row>
  <NAME>Configuration Item Auditing</NAME>
  <FKEY__C>ParentId</FKEY__C>
  <CHILDOBJECT__C>BMC_BaseElement__History</CHILDOBJECT__C>
  <FORMNAME__C></FORMNAME__C>
  <NEWEDITLINK__C>dummy</NEWEDITLINK__C>
  <PARENTOBJECT__C>BMC_BaseElement__c</PARENTOBJECT__C>
  <TABNAME__C>Auditing</TABNAME__C>
  <TABSEQUENCE__C>11.0</TABSEQUENCE__C>
  <EDITLINK__C></EDITLINK__C>
  <SEQUENCE__C>59</SEQUENCE__C>
</row>
<row>
  <NAME>SLA Problem</NAME>
  <FKEY__C>dummy</FKEY__C>
  <CHILDOBJECT__C>Problem__c</CHILDOBJECT__C>
  <FORMNAME__C></FORMNAME__C>
  <NEWEDITLINK__C>dummy</NEWEDITLINK__C>
  <PARENTOBJECT__C>ServiceLevelAgreement__c</PARENTOBJECT__C>
  <TABNAME__C>Problems</TABNAME__C>
  <TABSEQUENCE__C>4.0</TABSEQUENCE__C>
  <EDITLINK__C>dummy</EDITLINK__C>
  <SEQUENCE__C>60</SEQUENCE__C>
</row>
<row>
  <NAME>Configuration Item Knowledge Article</NAME>
  <FKEY__C>dummy</FKEY__C>
  <CHILDOBJECT__C>KM_KnowledgeArticle__c</CHILDOBJECT__C>
  <FORMNAME__C></FORMNAME__C>
  <NEWEDITLINK__C>dummy</NEWEDITLINK__C>
  <PARENTOBJECT__C>BMC_BaseElement__c</PARENTOBJECT__C>
  <TABNAME__C>Knowledge Articles</TABNAME__C>
  <TABSEQUENCE__C>9.0</TABSEQUENCE__C>
  <EDITLINK__C></EDITLINK__C>
  <SEQUENCE__C>61</SEQUENCE__C>
</row>
</rows>
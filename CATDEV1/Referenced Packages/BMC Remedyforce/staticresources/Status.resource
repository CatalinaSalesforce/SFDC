<rows>
	<STATUS__C>
		<ID>id</ID>
		<OWNERID>reference</OWNERID>
		<ISDELETED>boolean</ISDELETED>
		<NAME>string</NAME>
		<CREATEDDATE>datetime</CREATEDDATE>
		<CREATEDBYID>reference</CREATEDBYID>
		<LASTMODIFIEDDATE>datetime</LASTMODIFIEDDATE>
		<LASTMODIFIEDBYID>reference</LASTMODIFIEDBYID>
		<SYSTEMMODSTAMP>datetime</SYSTEMMODSTAMP>
		<FKSYSSTAGE__C>reference</FKSYSSTAGE__C>
		<SEQUENCE__C>string</SEQUENCE__C>
		<APPLIESTOBROADCASTS__C>boolean</APPLIESTOBROADCASTS__C>
		<APPLIESTOCHANGEAPPROVALS__C>boolean</APPLIESTOCHANGEAPPROVALS__C>
		<APPLIESTOCHANGEASSESSMENT__C>boolean</APPLIESTOCHANGEASSESSMENT__C>
		<APPLIESTOCHANGE__C>boolean</APPLIESTOCHANGE__C>
		<APPLIESTOCONFIGURATIONITEMS__C>boolean</APPLIESTOCONFIGURATIONITEMS__C>
		<APPLIESTOINCIDENT__C>boolean</APPLIESTOINCIDENT__C>
		<APPLIESTOPROBLEM__C>boolean</APPLIESTOPROBLEM__C>
		<APPLIESTOPREVENTIVEMAINTENANCE__C>boolean</APPLIESTOPREVENTIVEMAINTENANCE__C>
		<APPLIESTOPURCHASING__C>boolean</APPLIESTOPURCHASING__C>
		<APPLIESTOSLA__C>boolean</APPLIESTOSLA__C>
		<APPLIESTOSERVICES__C>boolean</APPLIESTOSERVICES__C>
		<APPLIESTOTASK__C>boolean</APPLIESTOTASK__C>
		<APPLIESTORELEASE__C>boolean</APPLIESTORELEASE__C>
		<DEFAULTSTATUS__C>boolean</DEFAULTSTATUS__C>
		<INACTIVE__C>boolean</INACTIVE__C>
		<STAGEPROGRESSION__C>string</STAGEPROGRESSION__C>
		<STATE__C>boolean</STATE__C>
		<SYSTEM__C>boolean</SYSTEM__C>
	</STATUS__C>
	<row>
		<SEQUENCE__C>1</SEQUENCE__C>
		<INACTIVE__C>0</INACTIVE__C>
		<NAME>OPENED</NAME>
		<STATE__C>1</STATE__C>
		<DEFAULTSTATUS__C>1</DEFAULTSTATUS__C>
		<SYSTEM__C>1</SYSTEM__C>
		<APPLIESTOINCIDENT__C>1</APPLIESTOINCIDENT__C>
		<APPLIESTOPROBLEM__C>1</APPLIESTOPROBLEM__C>
		<APPLIESTOTASK__C>1</APPLIESTOTASK__C>
		<APPLIESTOCONFIGURATIONITEMS__C>0</APPLIESTOCONFIGURATIONITEMS__C>
		<APPLIESTOCHANGE__C>1</APPLIESTOCHANGE__C>
		<APPLIESTOSERVICES__C>0</APPLIESTOSERVICES__C>
		<APPLIESTOBROADCASTS__C>1</APPLIESTOBROADCASTS__C>
		<APPLIESTORELEASE__C>1</APPLIESTORELEASE__C>
		<FKSYSStage__C>1</FKSYSStage__C>
	</row>
	<row>
		<SEQUENCE__C>2</SEQUENCE__C>
		<INACTIVE__C>0</INACTIVE__C>
		<NAME>CLOSED</NAME>
		<STATE__C>0</STATE__C>
		<DEFAULTSTATUS__C>1</DEFAULTSTATUS__C>
		<SYSTEM__C>1</SYSTEM__C>
		<APPLIESTOINCIDENT__C>1</APPLIESTOINCIDENT__C>
		<APPLIESTOPROBLEM__C>1</APPLIESTOPROBLEM__C>		
		<APPLIESTOTASK__C>1</APPLIESTOTASK__C>
		<APPLIESTOCONFIGURATIONITEMS__C>0</APPLIESTOCONFIGURATIONITEMS__C>
		<APPLIESTOCHANGE__C>1</APPLIESTOCHANGE__C>
		<APPLIESTOSERVICES__C>0</APPLIESTOSERVICES__C>
		<APPLIESTOBROADCASTS__C>1</APPLIESTOBROADCASTS__C>
		<APPLIESTORELEASE__C>1</APPLIESTORELEASE__C>
		<FKSYSStage__C>4</FKSYSStage__C>
	</row>
	<row>
		<SEQUENCE__C>3</SEQUENCE__C>
		<INACTIVE__C>0</INACTIVE__C>
		<NAME>CLOSED/NO CONTACT</NAME>
		<STATE__C>0</STATE__C>
		<DEFAULTSTATUS__C>0</DEFAULTSTATUS__C>
		<SYSTEM__C>1</SYSTEM__C>
		<APPLIESTOINCIDENT__C>1</APPLIESTOINCIDENT__C>
		<APPLIESTOPROBLEM__C>0</APPLIESTOPROBLEM__C>		
		<APPLIESTOTASK__C>0</APPLIESTOTASK__C>
		<APPLIESTOCONFIGURATIONITEMS__C>0</APPLIESTOCONFIGURATIONITEMS__C>
		<APPLIESTOCHANGE__C>0</APPLIESTOCHANGE__C>
		<APPLIESTOSERVICES__C>0</APPLIESTOSERVICES__C>
		<APPLIESTOBROADCASTS__C>0</APPLIESTOBROADCASTS__C>
		<APPLIESTORELEASE__C>0</APPLIESTORELEASE__C>
		<FKSYSStage__C>4</FKSYSStage__C>
	</row>
	<row>
		<SEQUENCE__C>4</SEQUENCE__C>
		<INACTIVE__C>0</INACTIVE__C>
		<NAME>REGISTERED</NAME>
		<STATE__C>1</STATE__C>
		<DEFAULTSTATUS__C>0</DEFAULTSTATUS__C>
		<SYSTEM__C>1</SYSTEM__C>
		<APPLIESTOINCIDENT__C>0</APPLIESTOINCIDENT__C>
		<APPLIESTOPROBLEM__C>0</APPLIESTOPROBLEM__C>		
		<APPLIESTOTASK__C>1</APPLIESTOTASK__C>
		<APPLIESTOCONFIGURATIONITEMS__C>0</APPLIESTOCONFIGURATIONITEMS__C>
		<APPLIESTOCHANGE__C>1</APPLIESTOCHANGE__C>
		<APPLIESTOSERVICES__C>0</APPLIESTOSERVICES__C>
		<APPLIESTOBROADCASTS__C>0</APPLIESTOBROADCASTS__C>
		<APPLIESTORELEASE__C>1</APPLIESTORELEASE__C>
		<FKSYSStage__C>2</FKSYSStage__C>
	</row>
	<row>
		<SEQUENCE__C>5</SEQUENCE__C>
		<INACTIVE__C>0</INACTIVE__C>
		<NAME>RISK &amp; IMPACT</NAME>
		<STATE__C>1</STATE__C>
		<DEFAULTSTATUS__C>0</DEFAULTSTATUS__C>
		<SYSTEM__C>1</SYSTEM__C>
		<APPLIESTOINCIDENT__C>0</APPLIESTOINCIDENT__C>
		<APPLIESTOPROBLEM__C>0</APPLIESTOPROBLEM__C>		
		<APPLIESTOTASK__C>0</APPLIESTOTASK__C>
		<APPLIESTOCONFIGURATIONITEMS__C>0</APPLIESTOCONFIGURATIONITEMS__C>
		<APPLIESTOCHANGE__C>1</APPLIESTOCHANGE__C>
		<APPLIESTOSERVICES__C>0</APPLIESTOSERVICES__C>
		<APPLIESTOBROADCASTS__C>0</APPLIESTOBROADCASTS__C>
		<APPLIESTORELEASE__C>0</APPLIESTORELEASE__C>
		<FKSYSStage__C>3</FKSYSStage__C>
	</row>
	<row>
		<SEQUENCE__C>6</SEQUENCE__C>
		<INACTIVE__C>0</INACTIVE__C>
		<NAME>PENDING APPROVAL</NAME>
		<STATE__C>1</STATE__C>
		<DEFAULTSTATUS__C>0</DEFAULTSTATUS__C>
		<SYSTEM__C>1</SYSTEM__C>
		<APPLIESTOINCIDENT__C>0</APPLIESTOINCIDENT__C>
		<APPLIESTOPROBLEM__C>0</APPLIESTOPROBLEM__C>		
		<APPLIESTOTASK__C>0</APPLIESTOTASK__C>
		<APPLIESTOCONFIGURATIONITEMS__C>0</APPLIESTOCONFIGURATIONITEMS__C>
		<APPLIESTOCHANGE__C>1</APPLIESTOCHANGE__C>
		<APPLIESTOSERVICES__C>0</APPLIESTOSERVICES__C>
		<APPLIESTOBROADCASTS__C>0</APPLIESTOBROADCASTS__C>
		<APPLIESTORELEASE__C>0</APPLIESTORELEASE__C>
		<FKSYSStage__C>3</FKSYSStage__C>
	</row>
	<row>
		<SEQUENCE__C>7</SEQUENCE__C>
		<INACTIVE__C>0</INACTIVE__C>
		<NAME>APPROVED</NAME>
		<STATE__C>1</STATE__C>
		<DEFAULTSTATUS__C>0</DEFAULTSTATUS__C>
		<SYSTEM__C>1</SYSTEM__C>
		<APPLIESTOINCIDENT__C>0</APPLIESTOINCIDENT__C>
		<APPLIESTOPROBLEM__C>0</APPLIESTOPROBLEM__C>		
		<APPLIESTOTASK__C>0</APPLIESTOTASK__C>
		<APPLIESTOCONFIGURATIONITEMS__C>0</APPLIESTOCONFIGURATIONITEMS__C>
		<APPLIESTOCHANGE__C>1</APPLIESTOCHANGE__C>
		<APPLIESTOSERVICES__C>0</APPLIESTOSERVICES__C>
		<APPLIESTOBROADCASTS__C>0</APPLIESTOBROADCASTS__C>
		<APPLIESTORELEASE__C>1</APPLIESTORELEASE__C>
		<FKSYSStage__C>3</FKSYSStage__C>
	</row>
	<row>
		<SEQUENCE__C>8</SEQUENCE__C>
		<INACTIVE__C>0</INACTIVE__C>
		<NAME>FAILED</NAME>
		<STATE__C>0</STATE__C>
		<DEFAULTSTATUS__C>0</DEFAULTSTATUS__C>
		<SYSTEM__C>1</SYSTEM__C>
		<APPLIESTOINCIDENT__C>0</APPLIESTOINCIDENT__C>
		<APPLIESTOPROBLEM__C>0</APPLIESTOPROBLEM__C>		
		<APPLIESTOTASK__C>1</APPLIESTOTASK__C>
		<APPLIESTOCONFIGURATIONITEMS__C>0</APPLIESTOCONFIGURATIONITEMS__C>
		<APPLIESTOCHANGE__C>0</APPLIESTOCHANGE__C>
		<APPLIESTOSERVICES__C>0</APPLIESTOSERVICES__C>
		<APPLIESTOBROADCASTS__C>0</APPLIESTOBROADCASTS__C>
		<APPLIESTORELEASE__C>0</APPLIESTORELEASE__C>
		<FKSYSStage__C>4</FKSYSStage__C>
	</row>
	<row>
		<SEQUENCE__C>9</SEQUENCE__C>
		<INACTIVE__C>0</INACTIVE__C>
		<NAME>CANCELLED</NAME>
		<STATE__C>0</STATE__C>
		<DEFAULTSTATUS__C>0</DEFAULTSTATUS__C>
		<SYSTEM__C>1</SYSTEM__C>
		<APPLIESTOINCIDENT__C>0</APPLIESTOINCIDENT__C>
		<APPLIESTOPROBLEM__C>0</APPLIESTOPROBLEM__C>		
		<APPLIESTOTASK__C>1</APPLIESTOTASK__C>
		<APPLIESTOCONFIGURATIONITEMS__C>0</APPLIESTOCONFIGURATIONITEMS__C>
		<APPLIESTOCHANGE__C>0</APPLIESTOCHANGE__C>
		<APPLIESTOSERVICES__C>0</APPLIESTOSERVICES__C>
		<APPLIESTOBROADCASTS__C>0</APPLIESTOBROADCASTS__C>
		<APPLIESTORELEASE__C>0</APPLIESTORELEASE__C>
		<FKSYSStage__C>4</FKSYSStage__C>
	</row>
	<row>
		<SEQUENCE__C>10</SEQUENCE__C>
		<INACTIVE__C>0</INACTIVE__C>
		<NAME>DISCONTINUED</NAME>
		<STATE__C>0</STATE__C>
		<DEFAULTSTATUS__C>0</DEFAULTSTATUS__C>
		<SYSTEM__C>1</SYSTEM__C>
		<APPLIESTOINCIDENT__C>0</APPLIESTOINCIDENT__C>
		<APPLIESTOPROBLEM__C>0</APPLIESTOPROBLEM__C>				
		<APPLIESTOTASK__C>0</APPLIESTOTASK__C>
		<APPLIESTOCONFIGURATIONITEMS__C>0</APPLIESTOCONFIGURATIONITEMS__C>
		<APPLIESTOCHANGE__C>0</APPLIESTOCHANGE__C>
		<APPLIESTOSERVICES__C>1</APPLIESTOSERVICES__C>
		<APPLIESTOBROADCASTS__C>0</APPLIESTOBROADCASTS__C>
		<APPLIESTORELEASE__C>0</APPLIESTORELEASE__C>
		<FKSYSStage__C>4</FKSYSStage__C>
	</row>
	<row>
		<SEQUENCE__C>11</SEQUENCE__C>
		<INACTIVE__C>0</INACTIVE__C>
		<NAME>DEVELOPMENT</NAME>
		<STATE__C>1</STATE__C>
		<DEFAULTSTATUS__C>0</DEFAULTSTATUS__C>
		<SYSTEM__C>1</SYSTEM__C>
		<APPLIESTOINCIDENT__C>0</APPLIESTOINCIDENT__C>
		<APPLIESTOPROBLEM__C>0</APPLIESTOPROBLEM__C>				
		<APPLIESTOTASK__C>0</APPLIESTOTASK__C>
		<APPLIESTOCONFIGURATIONITEMS__C>1</APPLIESTOCONFIGURATIONITEMS__C>
		<APPLIESTOCHANGE__C>0</APPLIESTOCHANGE__C>
		<APPLIESTOSERVICES__C>1</APPLIESTOSERVICES__C>
		<APPLIESTOBROADCASTS__C>0</APPLIESTOBROADCASTS__C>
		<APPLIESTORELEASE__C>1</APPLIESTORELEASE__C>
		<FKSYSStage__C>3</FKSYSStage__C>
	</row>
	<row>
		<SEQUENCE__C>12</SEQUENCE__C>
		<INACTIVE__C>0</INACTIVE__C>
		<NAME>TEST</NAME>
		<STATE__C>1</STATE__C>
		<DEFAULTSTATUS__C>0</DEFAULTSTATUS__C>
		<SYSTEM__C>1</SYSTEM__C>
		<APPLIESTOINCIDENT__C>0</APPLIESTOINCIDENT__C>
		<APPLIESTOPROBLEM__C>0</APPLIESTOPROBLEM__C>				
		<APPLIESTOTASK__C>0</APPLIESTOTASK__C>
		<APPLIESTOCONFIGURATIONITEMS__C>1</APPLIESTOCONFIGURATIONITEMS__C>
		<APPLIESTOCHANGE__C>0</APPLIESTOCHANGE__C>
		<APPLIESTOSERVICES__C>0</APPLIESTOSERVICES__C>
		<APPLIESTOBROADCASTS__C>0</APPLIESTOBROADCASTS__C>
		<APPLIESTORELEASE__C>1</APPLIESTORELEASE__C>
		<FKSYSStage__C>3</FKSYSStage__C>
	</row>
	<row>
		<SEQUENCE__C>13</SEQUENCE__C>
		<INACTIVE__C>0</INACTIVE__C>
		<NAME>PRODUCTION</NAME>
		<STATE__C>1</STATE__C>
		<DEFAULTSTATUS__C>0</DEFAULTSTATUS__C>
		<SYSTEM__C>1</SYSTEM__C>
		<APPLIESTOINCIDENT__C>0</APPLIESTOINCIDENT__C>
		<APPLIESTOPROBLEM__C>0</APPLIESTOPROBLEM__C>				
		<APPLIESTOTASK__C>0</APPLIESTOTASK__C>
		<APPLIESTOCONFIGURATIONITEMS__C>1</APPLIESTOCONFIGURATIONITEMS__C>
		<APPLIESTOCHANGE__C>0</APPLIESTOCHANGE__C>
		<APPLIESTOSERVICES__C>1</APPLIESTOSERVICES__C>
		<APPLIESTOBROADCASTS__C>0</APPLIESTOBROADCASTS__C>
		<APPLIESTORELEASE__C>0</APPLIESTORELEASE__C>
		<FKSYSStage__C>3</FKSYSStage__C>
	</row>
	<row>
		<SEQUENCE__C>14</SEQUENCE__C>
		<INACTIVE__C>0</INACTIVE__C>
		<NAME>MAINTENANCE</NAME>
		<STATE__C>1</STATE__C>
		<DEFAULTSTATUS__C>0</DEFAULTSTATUS__C>
		<SYSTEM__C>1</SYSTEM__C>
		<APPLIESTOINCIDENT__C>0</APPLIESTOINCIDENT__C>
		<APPLIESTOPROBLEM__C>0</APPLIESTOPROBLEM__C>				
		<APPLIESTOTASK__C>0</APPLIESTOTASK__C>
		<APPLIESTOCONFIGURATIONITEMS__C>1</APPLIESTOCONFIGURATIONITEMS__C>
		<APPLIESTOCHANGE__C>0</APPLIESTOCHANGE__C>
		<APPLIESTOSERVICES__C>0</APPLIESTOSERVICES__C>
		<APPLIESTOBROADCASTS__C>1</APPLIESTOBROADCASTS__C>
		<APPLIESTORELEASE__C>0</APPLIESTORELEASE__C>
		<FKSYSStage__C>3</FKSYSStage__C>
	</row>
	<row>
		<SEQUENCE__C>15</SEQUENCE__C>
		<INACTIVE__C>0</INACTIVE__C>
		<NAME>OFF-LINE</NAME>
		<STATE__C>1</STATE__C>
		<DEFAULTSTATUS__C>0</DEFAULTSTATUS__C>
		<SYSTEM__C>1</SYSTEM__C>
		<APPLIESTOINCIDENT__C>0</APPLIESTOINCIDENT__C>
		<APPLIESTOPROBLEM__C>0</APPLIESTOPROBLEM__C>				
		<APPLIESTOTASK__C>0</APPLIESTOTASK__C>
		<APPLIESTOCONFIGURATIONITEMS__C>1</APPLIESTOCONFIGURATIONITEMS__C>
		<APPLIESTOCHANGE__C>0</APPLIESTOCHANGE__C>
		<APPLIESTOSERVICES__C>0</APPLIESTOSERVICES__C>
		<APPLIESTOBROADCASTS__C>1</APPLIESTOBROADCASTS__C>
		<APPLIESTORELEASE__C>0</APPLIESTORELEASE__C>
		<FKSYSStage__C>3</FKSYSStage__C>
	</row>
	<row>
		<SEQUENCE__C>16</SEQUENCE__C>
		<INACTIVE__C>0</INACTIVE__C>
		<NAME>ARCHIVED</NAME>
		<STATE__C>0</STATE__C>
		<DEFAULTSTATUS__C>0</DEFAULTSTATUS__C>
		<SYSTEM__C>1</SYSTEM__C>
		<APPLIESTOINCIDENT__C>0</APPLIESTOINCIDENT__C>
		<APPLIESTOPROBLEM__C>0</APPLIESTOPROBLEM__C>				
		<APPLIESTOTASK__C>0</APPLIESTOTASK__C>
		<APPLIESTOCONFIGURATIONITEMS__C>1</APPLIESTOCONFIGURATIONITEMS__C>
		<APPLIESTOCHANGE__C>0</APPLIESTOCHANGE__C>
		<APPLIESTOSERVICES__C>0</APPLIESTOSERVICES__C>
		<APPLIESTOBROADCASTS__C>0</APPLIESTOBROADCASTS__C>
		<APPLIESTORELEASE__C>0</APPLIESTORELEASE__C>
		<FKSYSStage__C>4</FKSYSStage__C>
	</row>
	<row>
		<SEQUENCE__C>17</SEQUENCE__C>
		<INACTIVE__C>0</INACTIVE__C>
		<NAME>DRAFT</NAME>
		<STATE__C>1</STATE__C>
		<DEFAULTSTATUS__C>0</DEFAULTSTATUS__C>
		<SYSTEM__C>1</SYSTEM__C>
		<APPLIESTOINCIDENT__C>0</APPLIESTOINCIDENT__C>
		<APPLIESTOPROBLEM__C>0</APPLIESTOPROBLEM__C>				
		<APPLIESTOTASK__C>0</APPLIESTOTASK__C>
		<APPLIESTOCONFIGURATIONITEMS__C>0</APPLIESTOCONFIGURATIONITEMS__C>
		<APPLIESTOCHANGE__C>0</APPLIESTOCHANGE__C>
		<APPLIESTOSERVICES__C>0</APPLIESTOSERVICES__C>
		<APPLIESTOBROADCASTS__C>0</APPLIESTOBROADCASTS__C>
		<APPLIESTORELEASE__C>0</APPLIESTORELEASE__C>
		<FKSYSStage__C>3</FKSYSStage__C>
	</row>
	<row>
		<SEQUENCE__C>18</SEQUENCE__C>
		<INACTIVE__C>0</INACTIVE__C>
		<NAME>DISABLED</NAME>
		<STATE__C>0</STATE__C>
		<DEFAULTSTATUS__C>0</DEFAULTSTATUS__C>
		<SYSTEM__C>1</SYSTEM__C>
		<APPLIESTOINCIDENT__C>0</APPLIESTOINCIDENT__C>
		<APPLIESTOPROBLEM__C>0</APPLIESTOPROBLEM__C>				
		<APPLIESTOTASK__C>0</APPLIESTOTASK__C>
		<APPLIESTOCONFIGURATIONITEMS__C>0</APPLIESTOCONFIGURATIONITEMS__C>
		<APPLIESTOCHANGE__C>0</APPLIESTOCHANGE__C>
		<APPLIESTOSERVICES__C>0</APPLIESTOSERVICES__C>
		<APPLIESTOBROADCASTS__C>1</APPLIESTOBROADCASTS__C>
		<APPLIESTORELEASE__C>0</APPLIESTORELEASE__C>
		<FKSYSStage__C>4</FKSYSStage__C>
	</row>
	<row>
		<SEQUENCE__C>19</SEQUENCE__C>
		<INACTIVE__C>0</INACTIVE__C>
		<NAME>ACTIVE</NAME>
		<STATE__C>1</STATE__C>
		<DEFAULTSTATUS__C>0</DEFAULTSTATUS__C>
		<SYSTEM__C>1</SYSTEM__C>
		<APPLIESTOINCIDENT__C>0</APPLIESTOINCIDENT__C>
		<APPLIESTOPROBLEM__C>0</APPLIESTOPROBLEM__C>				
		<APPLIESTOTASK__C>0</APPLIESTOTASK__C>
		<APPLIESTOCONFIGURATIONITEMS__C>0</APPLIESTOCONFIGURATIONITEMS__C>
		<APPLIESTOCHANGE__C>0</APPLIESTOCHANGE__C>
		<APPLIESTOSERVICES__C>0</APPLIESTOSERVICES__C>
		<APPLIESTOBROADCASTS__C>0</APPLIESTOBROADCASTS__C>
		<APPLIESTORELEASE__C>0</APPLIESTORELEASE__C>
		<FKSYSStage__C>3</FKSYSStage__C>
	</row>
	<row>
		<SEQUENCE__C>20</SEQUENCE__C>
		<INACTIVE__C>0</INACTIVE__C>
		<NAME>ORDERED</NAME>
		<STATE__C>1</STATE__C>
		<DEFAULTSTATUS__C>0</DEFAULTSTATUS__C>
		<SYSTEM__C>1</SYSTEM__C>
		<APPLIESTOINCIDENT__C>0</APPLIESTOINCIDENT__C>
		<APPLIESTOPROBLEM__C>0</APPLIESTOPROBLEM__C>				
		<APPLIESTOTASK__C>0</APPLIESTOTASK__C>
		<APPLIESTOCONFIGURATIONITEMS__C>1</APPLIESTOCONFIGURATIONITEMS__C>
		<APPLIESTOCHANGE__C>0</APPLIESTOCHANGE__C>
		<APPLIESTOSERVICES__C>0</APPLIESTOSERVICES__C>
		<APPLIESTOBROADCASTS__C>0</APPLIESTOBROADCASTS__C>
		<APPLIESTORELEASE__C>0</APPLIESTORELEASE__C>
		<FKSYSStage__C>3</FKSYSStage__C>
	</row>
	<row>
		<SEQUENCE__C>21</SEQUENCE__C>
		<INACTIVE__C>0</INACTIVE__C>
		<NAME>IN STOCK</NAME>
		<STATE__C>1</STATE__C>
		<DEFAULTSTATUS__C>0</DEFAULTSTATUS__C>
		<SYSTEM__C>1</SYSTEM__C>
		<APPLIESTOINCIDENT__C>0</APPLIESTOINCIDENT__C>
		<APPLIESTOPROBLEM__C>0</APPLIESTOPROBLEM__C>				
		<APPLIESTOTASK__C>0</APPLIESTOTASK__C>
		<APPLIESTOCONFIGURATIONITEMS__C>1</APPLIESTOCONFIGURATIONITEMS__C>
		<APPLIESTOCHANGE__C>0</APPLIESTOCHANGE__C>
		<APPLIESTOSERVICES__C>0</APPLIESTOSERVICES__C>
		<APPLIESTOBROADCASTS__C>0</APPLIESTOBROADCASTS__C>
		<APPLIESTORELEASE__C>0</APPLIESTORELEASE__C>
		<FKSYSStage__C>3</FKSYSStage__C>
	</row>
	<row>
		<SEQUENCE__C>22</SEQUENCE__C>
		<INACTIVE__C>0</INACTIVE__C>
		<NAME>RESERVED</NAME>
		<STATE__C>1</STATE__C>
		<DEFAULTSTATUS__C>0</DEFAULTSTATUS__C>
		<SYSTEM__C>1</SYSTEM__C>
		<APPLIESTOINCIDENT__C>0</APPLIESTOINCIDENT__C>
		<APPLIESTOPROBLEM__C>0</APPLIESTOPROBLEM__C>				
		<APPLIESTOTASK__C>0</APPLIESTOTASK__C>
		<APPLIESTOCONFIGURATIONITEMS__C>1</APPLIESTOCONFIGURATIONITEMS__C>
		<APPLIESTOCHANGE__C>0</APPLIESTOCHANGE__C>
		<APPLIESTOSERVICES__C>0</APPLIESTOSERVICES__C>
		<APPLIESTOBROADCASTS__C>0</APPLIESTOBROADCASTS__C>
		<APPLIESTORELEASE__C>0</APPLIESTORELEASE__C>
		<FKSYSStage__C>3</FKSYSStage__C>
	</row>
	<row>
		<SEQUENCE__C>23</SEQUENCE__C>
		<INACTIVE__C>0</INACTIVE__C>
		<NAME>INSTALLED</NAME>
		<STATE__C>1</STATE__C>
		<DEFAULTSTATUS__C>0</DEFAULTSTATUS__C>
		<SYSTEM__C>1</SYSTEM__C>
		<APPLIESTOINCIDENT__C>0</APPLIESTOINCIDENT__C>
		<APPLIESTOPROBLEM__C>0</APPLIESTOPROBLEM__C>				
		<APPLIESTOTASK__C>0</APPLIESTOTASK__C>
		<APPLIESTOCONFIGURATIONITEMS__C>1</APPLIESTOCONFIGURATIONITEMS__C>
		<APPLIESTOCHANGE__C>0</APPLIESTOCHANGE__C>
		<APPLIESTOSERVICES__C>0</APPLIESTOSERVICES__C>
		<APPLIESTOBROADCASTS__C>0</APPLIESTOBROADCASTS__C>
		<APPLIESTORELEASE__C>0</APPLIESTORELEASE__C>
		<FKSYSStage__C>3</FKSYSStage__C>
	</row>
	<row>
		<SEQUENCE__C>24</SEQUENCE__C>
		<INACTIVE__C>0</INACTIVE__C>
		<NAME>STANDBY FOR CONTINUITY</NAME>
		<STATE__C>1</STATE__C>
		<DEFAULTSTATUS__C>0</DEFAULTSTATUS__C>
		<SYSTEM__C>1</SYSTEM__C>
		<APPLIESTOINCIDENT__C>0</APPLIESTOINCIDENT__C>
		<APPLIESTOPROBLEM__C>0</APPLIESTOPROBLEM__C>				
		<APPLIESTOTASK__C>0</APPLIESTOTASK__C>
		<APPLIESTOCONFIGURATIONITEMS__C>1</APPLIESTOCONFIGURATIONITEMS__C>
		<APPLIESTOCHANGE__C>0</APPLIESTOCHANGE__C>
		<APPLIESTOSERVICES__C>0</APPLIESTOSERVICES__C>
		<APPLIESTOBROADCASTS__C>0</APPLIESTOBROADCASTS__C>
		<APPLIESTORELEASE__C>0</APPLIESTORELEASE__C>
		<FKSYSStage__C>3</FKSYSStage__C>
	</row>
	<row>
		<SEQUENCE__C>25</SEQUENCE__C>
		<INACTIVE__C>0</INACTIVE__C>
		<NAME>ON LOAN</NAME>
		<STATE__C>1</STATE__C>
		<DEFAULTSTATUS__C>0</DEFAULTSTATUS__C>
		<SYSTEM__C>1</SYSTEM__C>
		<APPLIESTOINCIDENT__C>0</APPLIESTOINCIDENT__C>
		<APPLIESTOPROBLEM__C>0</APPLIESTOPROBLEM__C>				
		<APPLIESTOTASK__C>0</APPLIESTOTASK__C>
		<APPLIESTOCONFIGURATIONITEMS__C>1</APPLIESTOCONFIGURATIONITEMS__C>
		<APPLIESTOCHANGE__C>0</APPLIESTOCHANGE__C>
		<APPLIESTOSERVICES__C>0</APPLIESTOSERVICES__C>
		<APPLIESTOBROADCASTS__C>0</APPLIESTOBROADCASTS__C>
		<APPLIESTORELEASE__C>0</APPLIESTORELEASE__C>
		<FKSYSStage__C>3</FKSYSStage__C>
	</row>
	<row>
		<SEQUENCE__C>26</SEQUENCE__C>
		<INACTIVE__C>0</INACTIVE__C>
		<NAME>UNDERGOING MAINTENANCE</NAME>
		<STATE__C>1</STATE__C>
		<DEFAULTSTATUS__C>0</DEFAULTSTATUS__C>
		<SYSTEM__C>1</SYSTEM__C>
		<APPLIESTOINCIDENT__C>0</APPLIESTOINCIDENT__C>
		<APPLIESTOPROBLEM__C>0</APPLIESTOPROBLEM__C>				
		<APPLIESTOTASK__C>0</APPLIESTOTASK__C>
		<APPLIESTOCONFIGURATIONITEMS__C>1</APPLIESTOCONFIGURATIONITEMS__C>
		<APPLIESTOCHANGE__C>0</APPLIESTOCHANGE__C>
		<APPLIESTOSERVICES__C>0</APPLIESTOSERVICES__C>
		<APPLIESTOBROADCASTS__C>1</APPLIESTOBROADCASTS__C>
		<APPLIESTORELEASE__C>0</APPLIESTORELEASE__C>
		<FKSYSStage__C>3</FKSYSStage__C>
	</row>
	<row>
		<SEQUENCE__C>27</SEQUENCE__C>
		<INACTIVE__C>0</INACTIVE__C>
		<NAME>BROKEN DOWN</NAME>
		<STATE__C>1</STATE__C>
		<DEFAULTSTATUS__C>0</DEFAULTSTATUS__C>
		<SYSTEM__C>1</SYSTEM__C>
		<APPLIESTOINCIDENT__C>0</APPLIESTOINCIDENT__C>
		<APPLIESTOPROBLEM__C>0</APPLIESTOPROBLEM__C>				
		<APPLIESTOTASK__C>0</APPLIESTOTASK__C>
		<APPLIESTOCONFIGURATIONITEMS__C>1</APPLIESTOCONFIGURATIONITEMS__C>
		<APPLIESTOCHANGE__C>0</APPLIESTOCHANGE__C>
		<APPLIESTOSERVICES__C>0</APPLIESTOSERVICES__C>
		<APPLIESTOBROADCASTS__C>0</APPLIESTOBROADCASTS__C>
		<APPLIESTORELEASE__C>0</APPLIESTORELEASE__C>
		<FKSYSStage__C>3</FKSYSStage__C>
	</row>
	<row>
		<SEQUENCE__C>28</SEQUENCE__C>
		<INACTIVE__C>0</INACTIVE__C>
		<NAME>REPAIRED</NAME>
		<STATE__C>0</STATE__C>
		<DEFAULTSTATUS__C>0</DEFAULTSTATUS__C>
		<SYSTEM__C>1</SYSTEM__C>
		<APPLIESTOINCIDENT__C>0</APPLIESTOINCIDENT__C>
		<APPLIESTOPROBLEM__C>0</APPLIESTOPROBLEM__C>				
		<APPLIESTOTASK__C>0</APPLIESTOTASK__C>
		<APPLIESTOCONFIGURATIONITEMS__C>1</APPLIESTOCONFIGURATIONITEMS__C>
		<APPLIESTOCHANGE__C>0</APPLIESTOCHANGE__C>
		<APPLIESTOSERVICES__C>0</APPLIESTOSERVICES__C>
		<APPLIESTOBROADCASTS__C>0</APPLIESTOBROADCASTS__C>
		<APPLIESTORELEASE__C>0</APPLIESTORELEASE__C>
		<FKSYSStage__C>4</FKSYSStage__C>
	</row>
	<row>
		<SEQUENCE__C>29</SEQUENCE__C>
		<INACTIVE__C>0</INACTIVE__C>
		<NAME>LOST OR STOLEN</NAME>
		<STATE__C>1</STATE__C>
		<DEFAULTSTATUS__C>0</DEFAULTSTATUS__C>
		<SYSTEM__C>1</SYSTEM__C>
		<APPLIESTOINCIDENT__C>0</APPLIESTOINCIDENT__C>
		<APPLIESTOPROBLEM__C>0</APPLIESTOPROBLEM__C>				
		<APPLIESTOTASK__C>0</APPLIESTOTASK__C>
		<APPLIESTOCONFIGURATIONITEMS__C>1</APPLIESTOCONFIGURATIONITEMS__C>
		<APPLIESTOCHANGE__C>0</APPLIESTOCHANGE__C>
		<APPLIESTOSERVICES__C>0</APPLIESTOSERVICES__C>
		<APPLIESTOBROADCASTS__C>0</APPLIESTOBROADCASTS__C>
		<APPLIESTORELEASE__C>0</APPLIESTORELEASE__C>
		<FKSYSStage__C>3</FKSYSStage__C>
	</row>
	<row>
		<SEQUENCE__C>30</SEQUENCE__C>
		<INACTIVE__C>0</INACTIVE__C>
		<NAME>REMOVED</NAME>
		<STATE__C>0</STATE__C>
		<DEFAULTSTATUS__C>0</DEFAULTSTATUS__C>
		<SYSTEM__C>1</SYSTEM__C>
		<APPLIESTOINCIDENT__C>0</APPLIESTOINCIDENT__C>
		<APPLIESTOPROBLEM__C>0</APPLIESTOPROBLEM__C>				
		<APPLIESTOTASK__C>0</APPLIESTOTASK__C>
		<APPLIESTOCONFIGURATIONITEMS__C>1</APPLIESTOCONFIGURATIONITEMS__C>
		<APPLIESTOCHANGE__C>0</APPLIESTOCHANGE__C>
		<APPLIESTOSERVICES__C>0</APPLIESTOSERVICES__C>
		<APPLIESTOBROADCASTS__C>0</APPLIESTOBROADCASTS__C>
		<APPLIESTORELEASE__C>0</APPLIESTORELEASE__C>
		<FKSYSStage__C>4</FKSYSStage__C>
	</row>
	<row>
		<SEQUENCE__C>31</SEQUENCE__C>
		<INACTIVE__C>0</INACTIVE__C>
		<NAME>ACCEPTED</NAME>
		<STATE__C>1</STATE__C>
		<DEFAULTSTATUS__C>0</DEFAULTSTATUS__C>
		<SYSTEM__C>1</SYSTEM__C>
		<APPLIESTOINCIDENT__C>1</APPLIESTOINCIDENT__C>
		<APPLIESTOPROBLEM__C>1</APPLIESTOPROBLEM__C>				
		<APPLIESTOTASK__C>1</APPLIESTOTASK__C>
		<APPLIESTOCONFIGURATIONITEMS__C>0</APPLIESTOCONFIGURATIONITEMS__C>
		<APPLIESTOCHANGE__C>0</APPLIESTOCHANGE__C>
		<APPLIESTOSERVICES__C>0</APPLIESTOSERVICES__C>
		<APPLIESTOBROADCASTS__C>0</APPLIESTOBROADCASTS__C>
		<APPLIESTORELEASE__C>0</APPLIESTORELEASE__C>
		<FKSYSStage__C>2</FKSYSStage__C>
	</row>
	<row>
		<SEQUENCE__C>32</SEQUENCE__C>
		<INACTIVE__C>0</INACTIVE__C>
		<NAME>IN PROGRESS</NAME>
		<STATE__C>1</STATE__C>
		<DEFAULTSTATUS__C>0</DEFAULTSTATUS__C>
		<SYSTEM__C>1</SYSTEM__C>
		<APPLIESTOINCIDENT__C>1</APPLIESTOINCIDENT__C>
		<APPLIESTOPROBLEM__C>1</APPLIESTOPROBLEM__C>				
		<APPLIESTOTASK__C>1</APPLIESTOTASK__C>
		<APPLIESTOCONFIGURATIONITEMS__C>0</APPLIESTOCONFIGURATIONITEMS__C>
		<APPLIESTOCHANGE__C>1</APPLIESTOCHANGE__C>
		<APPLIESTOSERVICES__C>0</APPLIESTOSERVICES__C>
		<APPLIESTOBROADCASTS__C>0</APPLIESTOBROADCASTS__C>
		<APPLIESTORELEASE__C>1</APPLIESTORELEASE__C>
		<FKSYSStage__C>3</FKSYSStage__C>
	</row>
	<row>
		<SEQUENCE__C>33</SEQUENCE__C>
		<INACTIVE__C>0</INACTIVE__C>
		<NAME>COMPLETED</NAME>
		<STATE__C>0</STATE__C>
		<DEFAULTSTATUS__C>0</DEFAULTSTATUS__C>
		<SYSTEM__C>1</SYSTEM__C>
		<APPLIESTOINCIDENT__C>1</APPLIESTOINCIDENT__C>
		<APPLIESTOPROBLEM__C>0</APPLIESTOPROBLEM__C>				
		<APPLIESTOTASK__C>1</APPLIESTOTASK__C>
		<APPLIESTOCONFIGURATIONITEMS__C>0</APPLIESTOCONFIGURATIONITEMS__C>
		<APPLIESTOCHANGE__C>1</APPLIESTOCHANGE__C>
		<APPLIESTOSERVICES__C>0</APPLIESTOSERVICES__C>
		<APPLIESTOBROADCASTS__C>0</APPLIESTOBROADCASTS__C>
		<APPLIESTORELEASE__C>1</APPLIESTORELEASE__C>
		<FKSYSStage__C>4</FKSYSStage__C>
	</row>
	<row>
		<SEQUENCE__C>34</SEQUENCE__C>
		<INACTIVE__C>0</INACTIVE__C>
		<NAME>REJECTED</NAME>
		<STATE__C>0</STATE__C>
		<DEFAULTSTATUS__C>0</DEFAULTSTATUS__C>
		<SYSTEM__C>1</SYSTEM__C>
		<APPLIESTOINCIDENT__C>1</APPLIESTOINCIDENT__C>
		<APPLIESTOPROBLEM__C>1</APPLIESTOPROBLEM__C>				
		<APPLIESTOTASK__C>1</APPLIESTOTASK__C>
		<APPLIESTOCONFIGURATIONITEMS__C>0</APPLIESTOCONFIGURATIONITEMS__C>
		<APPLIESTOCHANGE__C>1</APPLIESTOCHANGE__C>
		<APPLIESTOSERVICES__C>0</APPLIESTOSERVICES__C>
		<APPLIESTOBROADCASTS__C>0</APPLIESTOBROADCASTS__C>
		<APPLIESTORELEASE__C>0</APPLIESTORELEASE__C>
		<FKSYSStage__C>4</FKSYSStage__C>
	</row>
	<row>
		<SEQUENCE__C>35</SEQUENCE__C>
		<INACTIVE__C>0</INACTIVE__C>
		<NAME>ASSIGNED</NAME>
		<STATE__C>1</STATE__C>
		<DEFAULTSTATUS__C>0</DEFAULTSTATUS__C>
		<SYSTEM__C>1</SYSTEM__C>
		<APPLIESTOINCIDENT__C>1</APPLIESTOINCIDENT__C>
		<APPLIESTOPROBLEM__C>1</APPLIESTOPROBLEM__C>				
		<APPLIESTOTASK__C>1</APPLIESTOTASK__C>
		<APPLIESTOCONFIGURATIONITEMS__C>0</APPLIESTOCONFIGURATIONITEMS__C>
		<APPLIESTOCHANGE__C>0</APPLIESTOCHANGE__C>
		<APPLIESTOSERVICES__C>0</APPLIESTOSERVICES__C>
		<APPLIESTOBROADCASTS__C>0</APPLIESTOBROADCASTS__C>
		<APPLIESTORELEASE__C>0</APPLIESTORELEASE__C>
		<FKSYSStage__C>2</FKSYSStage__C>
	</row>
	<row>
		<SEQUENCE__C>36</SEQUENCE__C>
		<INACTIVE__C>0</INACTIVE__C>
		<NAME>WAITING FOR…</NAME>
		<STATE__C>1</STATE__C>
		<DEFAULTSTATUS__C>0</DEFAULTSTATUS__C>
		<SYSTEM__C>1</SYSTEM__C>
		<APPLIESTOINCIDENT__C>1</APPLIESTOINCIDENT__C>
		<APPLIESTOPROBLEM__C>1</APPLIESTOPROBLEM__C>				
		<APPLIESTOTASK__C>1</APPLIESTOTASK__C>
		<APPLIESTOCONFIGURATIONITEMS__C>0</APPLIESTOCONFIGURATIONITEMS__C>
		<APPLIESTOCHANGE__C>0</APPLIESTOCHANGE__C>
		<APPLIESTOSERVICES__C>0</APPLIESTOSERVICES__C>
		<APPLIESTOBROADCASTS__C>0</APPLIESTOBROADCASTS__C>
		<APPLIESTORELEASE__C>0</APPLIESTORELEASE__C>
		<FKSYSStage__C>3</FKSYSStage__C>
	</row>
	<row>
		<SEQUENCE__C>37</SEQUENCE__C>
		<INACTIVE__C>0</INACTIVE__C>
		<NAME>PENDING</NAME>
		<STATE__C>1</STATE__C>
		<DEFAULTSTATUS__C>0</DEFAULTSTATUS__C>
		<SYSTEM__C>1</SYSTEM__C>
		<APPLIESTOINCIDENT__C>1</APPLIESTOINCIDENT__C>
		<APPLIESTOPROBLEM__C>0</APPLIESTOPROBLEM__C>				
		<APPLIESTOTASK__C>0</APPLIESTOTASK__C>
		<APPLIESTOCONFIGURATIONITEMS__C>0</APPLIESTOCONFIGURATIONITEMS__C>
		<APPLIESTOCHANGE__C>0</APPLIESTOCHANGE__C>
		<APPLIESTOSERVICES__C>0</APPLIESTOSERVICES__C>
		<APPLIESTOBROADCASTS__C>0</APPLIESTOBROADCASTS__C>
		<APPLIESTORELEASE__C>0</APPLIESTORELEASE__C>
		<FKSYSStage__C>3</FKSYSStage__C>
	</row>
	<row>
		<SEQUENCE__C>38</SEQUENCE__C>
		<INACTIVE__C>0</INACTIVE__C>
		<NAME>KNOWN ERROR</NAME>
		<STATE__C>0</STATE__C>
		<DEFAULTSTATUS__C>0</DEFAULTSTATUS__C>
		<SYSTEM__C>1</SYSTEM__C>
		<APPLIESTOINCIDENT__C>0</APPLIESTOINCIDENT__C>
		<APPLIESTOPROBLEM__C>1</APPLIESTOPROBLEM__C>				
		<APPLIESTOTASK__C>0</APPLIESTOTASK__C>
		<APPLIESTOCONFIGURATIONITEMS__C>0</APPLIESTOCONFIGURATIONITEMS__C>
		<APPLIESTOCHANGE__C>0</APPLIESTOCHANGE__C>
		<APPLIESTOSERVICES__C>0</APPLIESTOSERVICES__C>
		<APPLIESTOBROADCASTS__C>0</APPLIESTOBROADCASTS__C>
		<APPLIESTORELEASE__C>0</APPLIESTORELEASE__C>
		<FKSYSStage__C>4</FKSYSStage__C>
	</row>
	<row>
		<SEQUENCE__C>39</SEQUENCE__C>
		<INACTIVE__C>0</INACTIVE__C>
		<NAME>ANALYZED</NAME>
		<STATE__C>1</STATE__C>
		<DEFAULTSTATUS__C>0</DEFAULTSTATUS__C>
		<SYSTEM__C>1</SYSTEM__C>
		<APPLIESTOINCIDENT__C>0</APPLIESTOINCIDENT__C>
		<APPLIESTOPROBLEM__C>1</APPLIESTOPROBLEM__C>				
		<APPLIESTOTASK__C>0</APPLIESTOTASK__C>
		<APPLIESTOCONFIGURATIONITEMS__C>0</APPLIESTOCONFIGURATIONITEMS__C>
		<APPLIESTOCHANGE__C>0</APPLIESTOCHANGE__C>
		<APPLIESTOSERVICES__C>0</APPLIESTOSERVICES__C>
		<APPLIESTOBROADCASTS__C>0</APPLIESTOBROADCASTS__C>
		<APPLIESTORELEASE__C>0</APPLIESTORELEASE__C>
		<FKSYSStage__C>2</FKSYSStage__C>
	</row>
	<row>
		<SEQUENCE__C>40</SEQUENCE__C>
		<INACTIVE__C>0</INACTIVE__C>
		<NAME>REQUESTED</NAME>
		<STATE__C>1</STATE__C>
		<DEFAULTSTATUS__C>0</DEFAULTSTATUS__C>
		<SYSTEM__C>1</SYSTEM__C>
		<APPLIESTOINCIDENT__C>0</APPLIESTOINCIDENT__C>
		<APPLIESTOPROBLEM__C>0</APPLIESTOPROBLEM__C>				
		<APPLIESTOTASK__C>0</APPLIESTOTASK__C>
		<APPLIESTOCONFIGURATIONITEMS__C>0</APPLIESTOCONFIGURATIONITEMS__C>
		<APPLIESTOCHANGE__C>0</APPLIESTOCHANGE__C>
		<APPLIESTOSERVICES__C>0</APPLIESTOSERVICES__C>
		<APPLIESTOBROADCASTS__C>0</APPLIESTOBROADCASTS__C>
		<APPLIESTORELEASE__C>0</APPLIESTORELEASE__C>
		<FKSYSStage__C>2</FKSYSStage__C>
	</row>
	<row>
		<SEQUENCE__C>41</SEQUENCE__C>
		<INACTIVE__C>0</INACTIVE__C>
		<NAME>NO RESOLUTION</NAME>
		<STATE__C>0</STATE__C>
		<DEFAULTSTATUS__C>0</DEFAULTSTATUS__C>
		<SYSTEM__C>1</SYSTEM__C>
		<APPLIESTOINCIDENT__C>0</APPLIESTOINCIDENT__C>
		<APPLIESTOPROBLEM__C>1</APPLIESTOPROBLEM__C>				
		<APPLIESTOTASK__C>0</APPLIESTOTASK__C>
		<APPLIESTOCONFIGURATIONITEMS__C>0</APPLIESTOCONFIGURATIONITEMS__C>
		<APPLIESTOCHANGE__C>0</APPLIESTOCHANGE__C>
		<APPLIESTOSERVICES__C>0</APPLIESTOSERVICES__C>
		<APPLIESTOBROADCASTS__C>0</APPLIESTOBROADCASTS__C>
		<APPLIESTORELEASE__C>0</APPLIESTORELEASE__C>
		<FKSYSStage__C>4</FKSYSStage__C>
	</row>
	<row>
		<SEQUENCE__C>42</SEQUENCE__C>
		<INACTIVE__C>0</INACTIVE__C>
		<NAME>SOLVED</NAME>
		<STATE__C>0</STATE__C>
		<DEFAULTSTATUS__C>0</DEFAULTSTATUS__C>
		<SYSTEM__C>1</SYSTEM__C>
		<APPLIESTOINCIDENT__C>0</APPLIESTOINCIDENT__C>
		<APPLIESTOPROBLEM__C>1</APPLIESTOPROBLEM__C>				
		<APPLIESTOTASK__C>0</APPLIESTOTASK__C>
		<APPLIESTOCONFIGURATIONITEMS__C>0</APPLIESTOCONFIGURATIONITEMS__C>
		<APPLIESTOCHANGE__C>0</APPLIESTOCHANGE__C>
		<APPLIESTOSERVICES__C>0</APPLIESTOSERVICES__C>
		<APPLIESTOBROADCASTS__C>0</APPLIESTOBROADCASTS__C>
		<APPLIESTORELEASE__C>0</APPLIESTORELEASE__C>
		<FKSYSStage__C>4</FKSYSStage__C>
	</row>
	<row>
		<SEQUENCE__C>43</SEQUENCE__C>
		<INACTIVE__C>0</INACTIVE__C>
		<NAME>PLAN</NAME>
		<STATE__C>1</STATE__C>
		<DEFAULTSTATUS__C>0</DEFAULTSTATUS__C>
		<SYSTEM__C>0</SYSTEM__C>
		<APPLIESTOINCIDENT__C>0</APPLIESTOINCIDENT__C>
		<APPLIESTOPROBLEM__C>0</APPLIESTOPROBLEM__C>				
		<APPLIESTOTASK__C>0</APPLIESTOTASK__C>
		<APPLIESTOCONFIGURATIONITEMS__C>0</APPLIESTOCONFIGURATIONITEMS__C>
		<APPLIESTOCHANGE__C>0</APPLIESTOCHANGE__C>
		<APPLIESTOSERVICES__C>0</APPLIESTOSERVICES__C>
		<APPLIESTOBROADCASTS__C>0</APPLIESTOBROADCASTS__C>
		<APPLIESTORELEASE__C>1</APPLIESTORELEASE__C>
		<FKSYSStage__C>2</FKSYSStage__C>
	</row>
	<row>
		<SEQUENCE__C>44</SEQUENCE__C>
		<INACTIVE__C>0</INACTIVE__C>
		<NAME>DEPLOY</NAME>
		<STATE__C>1</STATE__C>
		<DEFAULTSTATUS__C>0</DEFAULTSTATUS__C>
		<SYSTEM__C>0</SYSTEM__C>
		<APPLIESTOINCIDENT__C>0</APPLIESTOINCIDENT__C>
		<APPLIESTOPROBLEM__C>0</APPLIESTOPROBLEM__C>				
		<APPLIESTOTASK__C>0</APPLIESTOTASK__C>
		<APPLIESTOCONFIGURATIONITEMS__C>0</APPLIESTOCONFIGURATIONITEMS__C>
		<APPLIESTOCHANGE__C>0</APPLIESTOCHANGE__C>
		<APPLIESTOSERVICES__C>0</APPLIESTOSERVICES__C>
		<APPLIESTOBROADCASTS__C>0</APPLIESTOBROADCASTS__C>
		<APPLIESTORELEASE__C>1</APPLIESTORELEASE__C>
		<FKSYSStage__C>3</FKSYSStage__C>
	</row>
	<row>
		<SEQUENCE__C>45</SEQUENCE__C>
		<INACTIVE__C>0</INACTIVE__C>
		<NAME>WAITING FOR CUSTOMER</NAME>
		<STATE__C>1</STATE__C>
		<DEFAULTSTATUS__C>0</DEFAULTSTATUS__C>
		<SYSTEM__C>1</SYSTEM__C>
		<APPLIESTOINCIDENT__C>1</APPLIESTOINCIDENT__C>
		<APPLIESTOPROBLEM__C>0</APPLIESTOPROBLEM__C>				
		<APPLIESTOTASK__C>0</APPLIESTOTASK__C>
		<APPLIESTOCONFIGURATIONITEMS__C>0</APPLIESTOCONFIGURATIONITEMS__C>
		<APPLIESTOCHANGE__C>0</APPLIESTOCHANGE__C>
		<APPLIESTOSERVICES__C>0</APPLIESTOSERVICES__C>
		<APPLIESTOBROADCASTS__C>0</APPLIESTOBROADCASTS__C>
		<APPLIESTORELEASE__C>0</APPLIESTORELEASE__C>
		<FKSYSStage__C>3</FKSYSStage__C>
	</row>
	<row>
		<SEQUENCE__C>46</SEQUENCE__C>
		<INACTIVE__C>0</INACTIVE__C>
		<NAME>CHANGE PENDING</NAME>
		<STATE__C>1</STATE__C>
		<DEFAULTSTATUS__C>0</DEFAULTSTATUS__C>
		<SYSTEM__C>1</SYSTEM__C>
		<APPLIESTOINCIDENT__C>1</APPLIESTOINCIDENT__C>
		<APPLIESTOPROBLEM__C>1</APPLIESTOPROBLEM__C>				
		<APPLIESTOTASK__C>0</APPLIESTOTASK__C>
		<APPLIESTOCONFIGURATIONITEMS__C>0</APPLIESTOCONFIGURATIONITEMS__C>
		<APPLIESTOCHANGE__C>0</APPLIESTOCHANGE__C>
		<APPLIESTOSERVICES__C>0</APPLIESTOSERVICES__C>
		<APPLIESTOBROADCASTS__C>0</APPLIESTOBROADCASTS__C>
		<APPLIESTORELEASE__C>0</APPLIESTORELEASE__C>
		<FKSYSStage__C>3</FKSYSStage__C>
	</row>
	<row>
		<SEQUENCE__C>47</SEQUENCE__C>
		<INACTIVE__C>0</INACTIVE__C>
		<NAME>CLOSEDMAIL</NAME>
		<STATE__C>1</STATE__C>
		<DEFAULTSTATUS__C>0</DEFAULTSTATUS__C>
		<SYSTEM__C>1</SYSTEM__C>
		<APPLIESTOINCIDENT__C>1</APPLIESTOINCIDENT__C>
		<APPLIESTOPROBLEM__C>0</APPLIESTOPROBLEM__C>				
		<APPLIESTOTASK__C>0</APPLIESTOTASK__C>
		<APPLIESTOCONFIGURATIONITEMS__C>0</APPLIESTOCONFIGURATIONITEMS__C>
		<APPLIESTOCHANGE__C>0</APPLIESTOCHANGE__C>
		<APPLIESTOSERVICES__C>0</APPLIESTOSERVICES__C>
		<APPLIESTOBROADCASTS__C>0</APPLIESTOBROADCASTS__C>
		<APPLIESTORELEASE__C>0</APPLIESTORELEASE__C>
		<FKSYSStage__C>4</FKSYSStage__C>
	</row>
	<row>
		<SEQUENCE__C>48</SEQUENCE__C>
		<INACTIVE__C>0</INACTIVE__C>
		<NAME>CHANGE REQUESTED</NAME>
		<STATE__C>1</STATE__C>
		<DEFAULTSTATUS__C>0</DEFAULTSTATUS__C>
		<SYSTEM__C>1</SYSTEM__C>
		<APPLIESTOINCIDENT__C>0</APPLIESTOINCIDENT__C>
		<APPLIESTOPROBLEM__C>1</APPLIESTOPROBLEM__C>				
		<APPLIESTOTASK__C>0</APPLIESTOTASK__C>
		<APPLIESTOCONFIGURATIONITEMS__C>0</APPLIESTOCONFIGURATIONITEMS__C>
		<APPLIESTOCHANGE__C>0</APPLIESTOCHANGE__C>
		<APPLIESTOSERVICES__C>0</APPLIESTOSERVICES__C>
		<APPLIESTOBROADCASTS__C>0</APPLIESTOBROADCASTS__C>
		<APPLIESTORELEASE__C>0</APPLIESTORELEASE__C>
		<FKSYSStage__C>2</FKSYSStage__C>
	</row>
	<row>
		<SEQUENCE__C>49</SEQUENCE__C>
		<INACTIVE__C>0</INACTIVE__C>
		<NAME>CHANGE COMPLETED</NAME>
		<STATE__C>1</STATE__C>
		<DEFAULTSTATUS__C>0</DEFAULTSTATUS__C>
		<SYSTEM__C>1</SYSTEM__C>
		<APPLIESTOINCIDENT__C>0</APPLIESTOINCIDENT__C>
		<APPLIESTOPROBLEM__C>1</APPLIESTOPROBLEM__C>				
		<APPLIESTOTASK__C>0</APPLIESTOTASK__C>
		<APPLIESTOCONFIGURATIONITEMS__C>0</APPLIESTOCONFIGURATIONITEMS__C>
		<APPLIESTOCHANGE__C>0</APPLIESTOCHANGE__C>
		<APPLIESTOSERVICES__C>0</APPLIESTOSERVICES__C>
		<APPLIESTOBROADCASTS__C>0</APPLIESTOBROADCASTS__C>
		<APPLIESTORELEASE__C>0</APPLIESTORELEASE__C>
		<FKSYSStage__C>3</FKSYSStage__C>
	</row>
	<row>
		<SEQUENCE__C>50</SEQUENCE__C>
		<INACTIVE__C>0</INACTIVE__C>
		<NAME>DEAD END</NAME>
		<STATE__C>1</STATE__C>
		<DEFAULTSTATUS__C>0</DEFAULTSTATUS__C>
		<SYSTEM__C>1</SYSTEM__C>
		<APPLIESTOINCIDENT__C>0</APPLIESTOINCIDENT__C>
		<APPLIESTOPROBLEM__C>1</APPLIESTOPROBLEM__C>				
		<APPLIESTOTASK__C>0</APPLIESTOTASK__C>
		<APPLIESTOCONFIGURATIONITEMS__C>0</APPLIESTOCONFIGURATIONITEMS__C>
		<APPLIESTOCHANGE__C>0</APPLIESTOCHANGE__C>
		<APPLIESTOSERVICES__C>0</APPLIESTOSERVICES__C>
		<APPLIESTOBROADCASTS__C>0</APPLIESTOBROADCASTS__C>
		<APPLIESTORELEASE__C>0</APPLIESTORELEASE__C>
		<FKSYSStage__C>4</FKSYSStage__C>
	</row>
	<row>
		<SEQUENCE__C>51</SEQUENCE__C>
		<INACTIVE__C>0</INACTIVE__C>
		<NAME>TO BE APPROVED</NAME>
		<STATE__C>1</STATE__C>
		<DEFAULTSTATUS__C>0</DEFAULTSTATUS__C>
		<SYSTEM__C>1</SYSTEM__C>
		<APPLIESTOINCIDENT__C>0</APPLIESTOINCIDENT__C>
		<APPLIESTOPROBLEM__C>0</APPLIESTOPROBLEM__C>				
		<APPLIESTOTASK__C>0</APPLIESTOTASK__C>
		<APPLIESTOCONFIGURATIONITEMS__C>0</APPLIESTOCONFIGURATIONITEMS__C>
		<APPLIESTOCHANGE__C>1</APPLIESTOCHANGE__C>
		<APPLIESTOSERVICES__C>0</APPLIESTOSERVICES__C>
		<APPLIESTOBROADCASTS__C>0</APPLIESTOBROADCASTS__C>
		<APPLIESTORELEASE__C>1</APPLIESTORELEASE__C>
		<FKSYSStage__C>3</FKSYSStage__C>
	</row>
	<row>
		<SEQUENCE__C>52</SEQUENCE__C>
		<INACTIVE__C>0</INACTIVE__C>
		<NAME>APPROVAL REQUESTED</NAME>
		<STATE__C>1</STATE__C>
		<DEFAULTSTATUS__C>0</DEFAULTSTATUS__C>
		<SYSTEM__C>1</SYSTEM__C>
		<APPLIESTOINCIDENT__C>0</APPLIESTOINCIDENT__C>
		<APPLIESTOPROBLEM__C>0</APPLIESTOPROBLEM__C>				
		<APPLIESTOTASK__C>0</APPLIESTOTASK__C>
		<APPLIESTOCONFIGURATIONITEMS__C>0</APPLIESTOCONFIGURATIONITEMS__C>
		<APPLIESTOCHANGE__C>1</APPLIESTOCHANGE__C>
		<APPLIESTOSERVICES__C>0</APPLIESTOSERVICES__C>
		<APPLIESTOBROADCASTS__C>0</APPLIESTOBROADCASTS__C>
		<APPLIESTORELEASE__C>0</APPLIESTORELEASE__C>
		<FKSYSStage__C>2</FKSYSStage__C>
	</row>
</rows>

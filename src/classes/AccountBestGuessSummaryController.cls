/*
@Name           : AccountBestGuessSummaryController
@Author         : customersuccess@cloud62.com
@Date           : 11/21/2012
@Description    : Controller for Account Best Guess Summary
*/
public with sharing class AccountBestGuessSummaryController {
    //Variables
    public Account_Best_Guess_Summary__c accBestGuess{get;set;}
    public List<Account_Best_Guess_Summary__c> accBestGuessList{get;set;}
    public Account a{get;set;}
    public List<AccountBestGuessRow> accHistoricalbestGuessList {get;set;}
    public String gstrManufacturer {get;set;}
    public String gstrSave {get;set;}
    public List<AccountBestGuessRow> bestGuessList {get;set;}
    public List<Account_Best_Guess_Summary__c> absummaryList{get;set;}   
    public List<Historical_Account_Best_Guess_Summary__c> histAccBestGuessSummary {get;set;}
    public List<DeliveryChannelBaseWrapper> deliveryChannelWrapperList{get;set;}
    public Decimal abgsQ1{get;set;}
    public Decimal abgsQ2{get;set;}
    public Decimal abgsQ3{get;set;}
    public Decimal abgsQ4{get;set;}
    public Decimal q1Booked{get;set;}
    public Decimal q2Booked{get;set;}
    public Decimal q3Booked{get;set;}
    public Decimal q4Booked{get;set;}
    public Decimal q1BookedWgt{get;set;}
    public Decimal q2BookedWgt{get;set;}
    public Decimal q3BookedWgt{get;set;}
    public Decimal q4BookedWgt{get;set;}
    public Decimal q1BookedFull{get;set;}
    public Decimal q2BookedFull{get;set;}
    public Decimal q3BookedFull{get;set;}
    public Decimal q4BookedFull{get;set;}
    public Decimal bookedTotal{get;set;}
    public Decimal bookedWgtTotal{get;set;}
    public Decimal bookedFullTotal{get;set;}
    public String userId{get;set;}
    public String selected{get;set;}
    public List<Account> congChildAccountsList{get;set;}
    public List<account> accIds{get;set;}
    public Boolean isCoglomerateAcc{get;set;}
    public String currAccRT{get;set;}
    public Boolean q1Edit{get;set;}
    public Boolean q2Edit{get;set;}
    public Boolean q3Edit{get;set;}
    public Boolean q4Edit{get;set;}
    
    //Constructor
    public AccountBestGuessSummaryController(ApexPages.StandardController controller){
        this.a = [select Id, Name, Owner.Name, Type, ParentId, Parent.OwnerId, Recordtype.name from Account where Id=:ApexPages.currentPage().getParameters().get('Id')];
        currAccRT = a.Recordtype.name;
        accBestGuess = new Account_Best_Guess_Summary__c();
        accBestGuess.Year__c = String.valueOf(system.today().year());
        //set the Delivery Channel Total to default
        selected ='Total';
        accHistoricalbestGuessList = new List<AccountBestGuessRow>();
        absummaryList = new List<Account_Best_Guess_Summary__c>();
        accIds = new List<account>();
        accIds.add(a);
        if(a.Type == 'Conglomerate'){
            isCoglomerateAcc = true;
            congChildAccountsList = getConglomerateChildAccounts();
            accIds.addall(congChildAccountsList);
        } else {
            isCoglomerateAcc = false;
        }
        /*absummaryList= [SELECT 
                            Id, Q1__c, Q2__c , Q3__c , Q4__c,Owner.Name, Owner__r.Name, Comments__c,Delivery_Channel__c,
                            Year__c, Booked_Q1__c, Booked_Q2__c, Booked_Q3__c, Booked_Q4__c, a.Wgt_Proposal_Q4__c, 
                            a.Wgt_Proposal_Q3__c, a.Wgt_Proposal_Q2__c, a.Wgt_Proposal_Q1__c, a.Full_Proposal_Q4__c, 
                            a.Full_Proposal_Q3__c, a.Full_Proposal_Q2__c, a.Full_Proposal_Q1__c, a.Conglomerate_Account_Best_Guess_Summary__c,
                            a.Booked_Wgt_Q4__c, a.Booked_Wgt_Q3__c, a.Booked_Wgt_Q2__c, Booked_Wgt_Q1__c , a.Booked_Full_Q4__c, 
                            a.Booked_Full_Q3__c, a.Booked_Full_Q2__c, a.Booked_Full_Q1__c , Account__r.Name, Account__r.ID, Account__r.Recordtype.Name
                            FROM 
                                Account_Best_Guess_Summary__c a 
                            WHERE 
                                Account__c IN :accIds and Year__c=:accBestGuess.Year__c order by Owner.Name,Delivery_Channel__c asc];  
        Set<String> setReqDeliveryChannels = new Set<String>();                  
        Set<String> setCurrDeliveryChannel = new Set<String>();
        for(Account_Best_Guess_Summary__c ABG : absummaryList){            
            if(ABG.Owner.Name == Userinfo.getName()){
                setCurrDeliveryChannel.add(ABG.delivery_Channel__c);
            }
        }
        if (!isCoglomerateAcc){         
            if(currAccRT == 'Manufacturing' || currAccRT == 'Retail'){
                setReqDeliveryChannels.add('Base');
                setReqDeliveryChannels.add('Mobile');
                setReqDeliveryChannels.add('Digital O&O');
                setReqDeliveryChannels.add('Audience Network');
            } Else{
                setReqDeliveryChannels.add('Base');
                setReqDeliveryChannels.add('Digital');
                setReqDeliveryChannels.add('Overprint');
            }
        }
        Boolean hasMatch = false;
        for(String reqDC : setReqDeliveryChannels){
            hasMatch = false;
            for(String curDC : setCurrDeliveryChannel){
                if(curDC == reqDC){
                    hasMatch = true;                        
                    break;                      
                }
            }
            if(hasMatch == false){
                Account_Best_Guess_Summary__c newABGS = new Account_Best_Guess_Summary__c();
                newABGS.Year__c = accBestGuess.Year__c;
                newABGS.Account__c = a.ID;
                newABGS.Delivery_Channel__c = reqDC;
                absummaryList.add(newABGS);
            }
        }
        if(absummaryList.size()>0){
            accBestGuess = absummaryList[0];
        }
        if(absummaryList.size()<=0){
            msgDisplay();
        }
        accBestGuessList =  absummaryList;
        createDataStringsFromRepGuess(absummaryList);  
        displayRevenue(); 
        setHistorical();*/
        search();
        userId = UserInfo.getUserId();     
    }
    
    public void setQuaterEdit(String selectedYear){
        Integer selYear = Integer.valueOf(selectedYear);
        q1Edit = False;
        q2Edit = False;
        q3Edit = False;
        q4Edit = False;
        if((selYear == system.today().year()  && system.today().month()>=1 && system.today().month()<=3) || (selYear > system.Today().Year())){
            q1Edit = True;
        }
        if((selYear == system.today().year() && system.today().month()>=4 && system.today().month()<=6) || (selYear > system.Today().Year())){
            q2Edit = True;
        }
        if((selYear == system.today().year() && system.today().month()>=7 && system.today().month()<=9) || (selYear > system.Today().Year())){
            q3Edit = True;
        }
        if((selYear == system.today().year() && system.today().month()>=10 && system.today().month()<=12) || (selYear > system.Today().Year())){
            q4Edit = True;
        }
        if(q1Edit){q2Edit=true;q3Edit=true;q4Edit=true;}
        if(q2Edit){q3Edit=true;q4Edit=true;}
        if(q3Edit){q4Edit=true;}
    }
    
    //get all the child accounts of the conglomerate account
    public List<account> getConglomerateChildAccounts(){
        return [select Id, Name from Account where ParentId= :a.Id];
    }
    
    //method to display info message
    public pagereference msgDisplay(){
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'There are no Account Best Guess.'));
        return null;
    }
    
    //method to create data string for Manufacturer grid 
    public void createDataStringsFromRepGuess(List<Account_Best_Guess_Summary__c> abgSummary){
        setQuaterEdit(accBestGuess.Year__c);
        gstrManufacturer = '[';
        for(Account_Best_Guess_Summary__c abg:abgSummary){
            String u = abg.Owner.Name;
            if(u == null){
                u = Userinfo.getName();
            }
            if(a.Type=='Conglomerate'){
                gstrManufacturer += '{rowName:"",owner:"'+abg.Account__r.Name+'"';
            }else{
                gstrManufacturer += '{rowName:"",owner:"'+u+'"';
            }
            if(abg.Delivery_Channel__c!=null){
                if( a.Type=='Conglomerate'){
                    gstrManufacturer += ',channel:"' +u+'-'+ abg.Delivery_Channel__c+ '"';
                }else{
                    gstrManufacturer += ',channel:"' + abg.Delivery_Channel__c+ '"';
                }    
            }
            gstrManufacturer += ',bsgid:"' + abg.Id + '"';
            if(abg.Q1__c!=null){ 
                gstrManufacturer += ',q1:"' + abg.Q1__c + '"';
            }
            if(abg.Q2__c!=null){ 
                gstrManufacturer += ',q2:"' + abg.Q2__c + '"';
            }           
            if(abg.Q3__c!=null){ 
                gstrManufacturer += ',q3:"' + abg.Q3__c + '"';
            }           
            if(abg.Q4__c!=null){ 
                gstrManufacturer += ',q4:"' + abg.Q4__c + '"';
            }
            gstrManufacturer += '},';           
        }
        gstrManufacturer += ']';        
    }
    //Set the dynamic input field
    public Component.Apex.inputTextarea getManCommentField(){
        Component.Apex.inputTextarea ifComments = new Component.Apex.inputTextarea();
        String strComments = '';
        if(accBestGuess== null){
            return null;
        }
        strComments = 'accBestGuess.Comments__c'; 
        ifComments.expressions.value = '{!' + strComments + '}';
        ifComments.rows = 3;
        ifComments.style = 'width:90%';
        return ifComments;
    }

    //Save the updated values in the grid
    public void saveBestGuess(){
        Integer i =0;
        absummaryList= [SELECT 
                            Id, Account__r.Name, Q1__c, Q2__c , Q3__c , Q4__c,Owner.Name, Owner__r.Name, Comments__c,Delivery_Channel__c, 
                            Year__c, Booked_Q1__c, Booked_Q2__c, Booked_Q3__c, Booked_Q4__c, a.Wgt_Proposal_Q4__c, 
                            a.Wgt_Proposal_Q3__c, a.Wgt_Proposal_Q2__c, a.Wgt_Proposal_Q1__c, a.Full_Proposal_Q4__c, 
                            a.Full_Proposal_Q3__c, a.Full_Proposal_Q2__c, a.Full_Proposal_Q1__c, a.Conglomerate_Account_Best_Guess_Summary__c, 
                            a.Booked_Wgt_Q4__c, a.Booked_Wgt_Q3__c, a.Booked_Wgt_Q2__c, Booked_Wgt_Q1__c , a.Booked_Full_Q4__c, 
                            a.Booked_Full_Q3__c, a.Booked_Full_Q2__c, a.Booked_Full_Q1__c, Account__r.ID, Account__r.Recordtype.Name 
                            FROM 
                                Account_Best_Guess_Summary__c a 
                            WHERE 
                                Account__c IN :accIds and Year__c=:accBestGuess.Year__c order by Owner.Name,Delivery_Channel__c asc];  
        //removed by Warren - not needed as we requery later
        /*if(absummaryList.size()<=0){
            msgDisplay();
        }*/          
        Map<String,String>commentsMap = new Map<String, String>();
        for(CommentWrapper cw: bgComments){
            commentsMap.put(cw.abg.Id,cw.abg.Comments__c);
        }
        
        if(gstrSave != null){
            List<Account_Best_Guess_Summary__c> bsgUpdateList = new List<Account_Best_Guess_Summary__c>();
            String[] splitString = gstrSave.split('~');
            for (Integer counter = 0; counter < splitString.size(); counter++){
                Boolean found = false;
                String[] sarrSave = splitString[counter].split(':');
                String bsgId = sarrSave[i + 1];
                for(Account_Best_Guess_Summary__c bsg : absummaryList){
                    system.debug(LoggingLevel.ERROR, '***bsg: ' + bsg.Id);
                    system.debug(LoggingLevel.ERROR, '***bsg: ' + bsgId);
                    String currentID = bsg.Id;
                    if(bsg.Id != null){
                        if(bsgId == currentID){
                            found = true;
                            try{bsg.Q1__c = Decimal.valueOf(sarrSave[i+2]);}catch(Exception e){}
                            try{bsg.Q2__c = Decimal.valueOf(sarrSave[i+3]);}catch(Exception e){}
                            try{bsg.Q3__c = Decimal.valueOf(sarrSave[i+4]);}catch(Exception e){}
                            try{bsg.Q4__c = Decimal.valueOf(sarrSave[i+5]);}catch(Exception e){}
                            if(commentsMap.get(bsg.Id) !=null){bsg.Comments__c = commentsMap.get(bsg.Id);}
                            bsgUpdateList.add(bsg);    
                            accBestGuess = bsg;
                            break;
                        }
                    }
                }
                
                if (!found){
                    Account_Best_Guess_Summary__c newABGS = new Account_Best_Guess_Summary__c();
                    newABGS.OwnerId = UserInfo.getUserID();
                    newABGS.Account__c = a.Id;
                    newABGS.Year__c = accBestGuess.Year__c;
                    newABGS.Delivery_Channel__c = sarrSave[i];
                    //createCongBGRecord(newABGS.Delivery_Channel__c);
                    Boolean saveRecord = false;
                    if (Decimal.valueOf(sarrSave[i+2]) != 0) saveRecord = true;
                    if (Decimal.valueOf(sarrSave[i+3]) != 0) saveRecord = true;
                    if (Decimal.valueOf(sarrSave[i+4]) != 0) saveRecord = true;
                    if (Decimal.valueOf(sarrSave[i+5]) != 0) saveRecord = true;
                    try{newABGS.Q1__c = Decimal.valueOf(sarrSave[i+2]);}catch(Exception e){}
                    try{newABGS.Q2__c = Decimal.valueOf(sarrSave[i+3]);}catch(Exception e){}
                    try{newABGS.Q3__c = Decimal.valueOf(sarrSave[i+4]);}catch(Exception e){}
                    try{newABGS.Q4__c = Decimal.valueOf(sarrSave[i+5]);}catch(Exception e){}
                    system.debug(LoggingLevel.ERROR, '***not found');
                    system.debug(LoggingLevel.ERROR, '***sarrSave: ' + sarrSave[i]);
                    system.debug(LoggingLevel.ERROR, '***sarrSave: ' + sarrSave[i+1]);
                    system.debug(LoggingLevel.ERROR, '***sarrSave: ' + sarrSave[i+2]);
                    system.debug(LoggingLevel.ERROR, '***sarrSave: ' + sarrSave[i+3]);
                    system.debug(LoggingLevel.ERROR, '***sarrSave: ' + sarrSave[i+4]);
                    system.debug(LoggingLevel.ERROR, '***sarrSave: ' + sarrSave[i+5]);
                    if (saveRecord)bsgUpdateList.add(newABGS);
                }   
            }
            
            upsert bsgUpdateList; 
            setHistorical();
            //utility to link conglomerate record
            AccountBestGuessUtility.linkConglomerates(a.Id, a.ParentId, accBestGuess.Year__c, UserInfo.getUserID());       
        }
        //reload data after save
        /*absummaryList= [SELECT 
                            Id, Account__r.Name, Q1__c, Q2__c , Q3__c , Q4__c,Owner.Name, Owner__r.Name, Comments__c,Delivery_Channel__c, 
                            Year__c, Booked_Q1__c, Booked_Q2__c, Booked_Q3__c, Booked_Q4__c, a.Wgt_Proposal_Q4__c, 
                            a.Wgt_Proposal_Q3__c, a.Wgt_Proposal_Q2__c, a.Wgt_Proposal_Q1__c, a.Full_Proposal_Q4__c, 
                            a.Full_Proposal_Q3__c, a.Full_Proposal_Q2__c, a.Full_Proposal_Q1__c, a.Conglomerate_Account_Best_Guess_Summary__c, 
                            a.Booked_Wgt_Q4__c, a.Booked_Wgt_Q3__c, a.Booked_Wgt_Q2__c, Booked_Wgt_Q1__c , 
                            a.Booked_Full_Q4__c, a.Booked_Full_Q3__c, a.Booked_Full_Q2__c, a.Booked_Full_Q1__c, Account__r.ID, Account__r.Recordtype.Name 
                            FROM 
                                Account_Best_Guess_Summary__c a 
                            WHERE 
                                Account__c IN :accIds and Year__c=:accBestGuess.Year__c order by Owner.Name,Delivery_Channel__c asc]; 
                               
        Set<String> setReqDeliveryChannels = new Set<String>();                  
        Set<String> setCurrDeliveryChannel = new Set<String>();
        for(Account_Best_Guess_Summary__c ABG : absummaryList){            
            if(ABG.Owner.Name == Userinfo.getName()){
                setCurrDeliveryChannel.add(ABG.delivery_Channel__c);
            }
        }  
        if (!isCoglomerateAcc){      
            if(currAccRT == 'Manufacturing' || currAccRT == 'Retail'){
                setReqDeliveryChannels.add('Base');
                setReqDeliveryChannels.add('Mobile');
                setReqDeliveryChannels.add('Digital O&O');
                setReqDeliveryChannels.add('Audience Network');
            } Else{
                setReqDeliveryChannels.add('Base');
                setReqDeliveryChannels.add('Digital');
                setReqDeliveryChannels.add('Overprint');
            }
        }
        Boolean hasMatch = false;
        for(String reqDC : setReqDeliveryChannels){
            hasMatch = false;
            for(String curDC : setCurrDeliveryChannel){
                if(curDC == reqDC){
                    hasMatch = true;                        
                    break;                      
                }
            }
            if(hasMatch == false){
                Account_Best_Guess_Summary__c newABGS = new Account_Best_Guess_Summary__c();
                newABGS.Year__c = accBestGuess.Year__c;
                newABGS.Account__c = a.ID;
                newABGS.Delivery_Channel__c = reqDC;
                absummaryList.add(newABGS);
            }
        }*/                         
        search();         
        //createDataStringsFromRepGuess(absummaryList);
    }  
    
    //search method based on year and delivery channel
    public PageReference search(){
        String year = accBestGuess.Year__c;
        absummaryList = new List<Account_Best_Guess_Summary__c>();            
        absummaryList= [SELECT 
                            Id, Account__r.Name, Q1__c, Q2__c , Q3__c , Q4__c,Owner.Name, Owner__r.Name, Comments__c,Delivery_Channel__c, 
                            Year__c, Booked_Q1__c, Booked_Q2__c, Booked_Q3__c, Booked_Q4__c, a.Wgt_Proposal_Q4__c, 
                            a.Wgt_Proposal_Q3__c, a.Wgt_Proposal_Q2__c, a.Wgt_Proposal_Q1__c, a.Full_Proposal_Q4__c, 
                            a.Full_Proposal_Q3__c, a.Full_Proposal_Q2__c, a.Full_Proposal_Q1__c, a.Conglomerate_Account_Best_Guess_Summary__c, 
                            a.Booked_Wgt_Q4__c, a.Booked_Wgt_Q3__c, a.Booked_Wgt_Q2__c, Booked_Wgt_Q1__c , a.Booked_Full_Q4__c, 
                            a.Booked_Full_Q3__c, a.Booked_Full_Q2__c, a.Booked_Full_Q1__c, Account__r.ID, Account__r.Recordtype.Name 
                            FROM 
                                Account_Best_Guess_Summary__c a 
                            WHERE 
                                Account__c IN :accIds and Year__c=:accBestGuess.Year__c order by Owner.Name,Delivery_Channel__c asc];    
                               
        Set<String> setReqDeliveryChannels = new Set<String>();                  
        Set<String> setCurrDeliveryChannel = new Set<String>();
        for(Account_Best_Guess_Summary__c ABG : absummaryList){            
            if(ABG.Owner.Name == Userinfo.getName()){
                setCurrDeliveryChannel.add(ABG.delivery_Channel__c);
            }
        }
        if (!isCoglomerateAcc){        
            if(currAccRT == 'Manufacturing' || currAccRT == 'Retail'){
                setReqDeliveryChannels.add('Base');
                setReqDeliveryChannels.add('Mobile');
                setReqDeliveryChannels.add('Digital O&O');
                setReqDeliveryChannels.add('Audience Network');
            } Else{
                setReqDeliveryChannels.add('Base');
                setReqDeliveryChannels.add('Digital');
                setReqDeliveryChannels.add('Overprint');
            }
        }
        Boolean hasMatch = false;
        for(String reqDC : setReqDeliveryChannels){
            hasMatch = false;
            for(String curDC : setCurrDeliveryChannel){
                if(curDC == reqDC){
                    hasMatch = true;                        
                    break;                      
                }
            }
            if(hasMatch == false){
                Account_Best_Guess_Summary__c newABGS = new Account_Best_Guess_Summary__c();
                newABGS.Year__c = accBestGuess.Year__c;
                newABGS.Account__c = a.ID;
                newABGS.Delivery_Channel__c = reqDC;
                absummaryList.add(newABGS);
            }
        }                         
                                 
        if(absummaryList.size()>0 && absummaryList.size()==1){
            accBestGuess = absummaryList[0];
        }
        if(absummaryList.size()<=0){
            msgDisplay();
        }
        accBestGuessList =  absummaryList;     
        createDataStringsFromRepGuess(absummaryList); 
        displayRevenue();
        setHistorical();   
        return null;
    } 
    
    //set conglomerate history
    public void setConglomerateHistory(){
        Decimal bookedQ1 = 0;
        Decimal bookedQ2 = 0;
        Decimal bookedQ3 = 0;
        Decimal bookedQ4 = 0;
        Decimal bookedTotal = 0;
        Decimal Q1 = 0;
        Decimal Q2 = 0;
        Decimal Q3 = 0;
        Decimal Q4 = 0;
        Decimal QTotal = 0;
        
        Map<String, String> m = new Map<String, String>();
        for(Historic_Conglomerate_Best_Guess_Summary__c chbg: [SELECT 
                                                    h.Name, h.OwnerId, h.Owner.Name, h.Year__c, h.Booked_Full_Q1__c
                                                   ,h.Wgt_Proposal_Q4__c, h.Wgt_Proposal_Q3__c, h.Wgt_Proposal_Q2__c
                                                   ,h.Wgt_Proposal_Q1__c, h.Q4__c, h.Q3__c, h.Q2__c, h.Q1__c,h.Full_Proposal_Q4__c
                                                   , h.Full_Proposal_Q3__c, h.Full_Proposal_Q2__c, h.Full_Proposal_Q1__c
                                                   , h.Booked_Wgt_Q4__c, h.Booked_Wgt_Q3__c, h.Booked_Wgt_Q2__c
                                                   , h.Booked_Wgt_Q1__c, h.Booked_Q4__c, h.Booked_Q3__c
                                                   , h.Booked_Q2__c, h.Booked_Q1__c, h.Booked_Full_Q4__c
                                                   , h.Booked_Full_Q3__c, h.Booked_Full_Q2__c, h.Account__c, h.Delivery_Channel__c 
                                                   FROM 
                                                       Historic_Conglomerate_Best_Guess_Summary__c h 
                                                   WHERE 
                                                       ACCOUNT__C =: a.Id AND Year__c =: accBestGuess.Year__c 
                                                   ORDER BY 
                                                       Archive_Date__c desc]){
            
           if(chbg.Booked_Q1__c ==null){chbg.Booked_Q1__c = 0;} 
           if(chbg.Booked_Q2__c ==null){chbg.Booked_Q2__c = 0;}                                        
           if(chbg.Booked_Q3__c ==null){chbg.Booked_Q3__c = 0;}
           if(chbg.Booked_Q4__c ==null){chbg.Booked_Q4__c = 0;}
           if(chbg.Q1__c ==null){chbg.Q1__c = 0;} 
           if(chbg.Q2__c ==null){chbg.Q2__c = 0;}                                        
           if(chbg.Q3__c ==null){chbg.Q3__c = 0;}
           if(chbg.Q4__c ==null){chbg.Q4__c = 0;}

           String key = chbg.Year__c+chbg.Delivery_Channel__c;
           if(!m.containskey(key)){
               m.put(chbg.Year__c+chbg.Delivery_Channel__c,chbg.Year__c+chbg.Delivery_Channel__c);
               bookedQ1 += chbg.Booked_Q1__c;
               bookedQ2 += chbg.Booked_Q2__c;
               bookedQ3 += chbg.Booked_Q3__c;
               bookedQ4 += chbg.Booked_Q4__c;
               bookedTotal = bookedQ1+bookedQ2+bookedQ3+bookedQ4;
               Q1 += chbg.Q1__c;
               Q2 += chbg.Q2__c;
               Q3 += chbg.Q3__c;
               Q4 += chbg.Q4__c;
               QTotal = Q1+Q2+Q3+Q4;
            }         
        }
        AccountBestGuessRow abr = new AccountBestGuessRow();
        abr.bookedQ1 = bookedQ1;
        abr.bookedQ2 = bookedQ2;
        abr.bookedQ3 = bookedQ3;
        abr.bookedQ4 = bookedQ4;
        abr.bookedtotal = bookedTotal;
        abr.bestGuessQ1 = Q1;
        abr.bestGuessQ2 = Q2;
        abr.bestGuessQ3 = Q3;
        abr.bestGuessQ4 = Q4;
        abr.bestGuesstotal = QTotal;
        abr.bestGuessQ1Change = abgsQ1 - Q1;
        abr.bestGuessQ2Change = abgsQ2 - Q2;
        abr.bestGuessQ3Change = abgsQ3 - Q3;
        abr.bestGuessQ4Change = abgsQ4 - Q4;
        abr.bookedQ1Change = q1Booked - bookedQ1 ;
        abr.bookedQ2Change = q2Booked - bookedQ2 ;
        abr.bookedQ3Change = q3Booked - bookedQ3 ;
        abr.bookedQ4Change = q4Booked - bookedQ4 ;
        abr.bookedYearChange =  abr.bookedQ1Change + abr.bookedQ2Change + abr.bookedQ3Change + abr.bookedQ4Change;
        abr.bestGuessYearChange = abr.bestGuessQ1Change + abr.bestGuessQ2Change + abr.bestGuessQ3Change + abr.bestGuessQ4Change;
        bestGuessList.add(abr);  
    }
    
    //set the data for historical section
    public void setHistorical(){
        bestGuessList = new List<AccountBestGuessRow>();
        Map<String, String> tempMAP = new Map<String, String>();
        if(a.Type == 'Conglomerate'){
            //calcualte Historical Conglomerate Account Best Guess
            setConglomerateHistory();
        }else{
            Map<String, Decimal> bookedQ1TotalByUser = new Map<String, Decimal>();
            Map<String, Decimal> bookedQ2TotalByUser = new Map<String, Decimal>();
            Map<String, Decimal> bookedQ3TotalByUser = new Map<String, Decimal>();
            Map<String, Decimal> bookedQ4TotalByUser = new Map<String, Decimal>();
            Map<String, Decimal> Q1TotalByUser = new Map<String, Decimal>();  
            Map<String, Decimal> Q2TotalByUser = new Map<String, Decimal>();
            Map<String, Decimal> Q3TotalByUser = new Map<String, Decimal>();
            Map<String, Decimal> Q4TotalByUser = new Map<String, Decimal>();
            Map<String, String> tempHistMap = new Map<String, String>();
                
            for(Historical_Account_Best_Guess_Summary__c h : [Select 
                        h.Name, h.OwnerId, Owner.Name, h.Year__c, h.Delivery_Channel__c , h.Booked_Full_Q1__c, 
                        h.Wgt_Proposal_Q4__c, h.Wgt_Proposal_Q3__c, h.Wgt_Proposal_Q2__c, h.Wgt_Proposal_Q1__c, 
                        h.Q4__c, h.Q3__c, h.Q2__c, h.Q1__c, h.Full_Proposal_Q4__c, h.Full_Proposal_Q3__c, 
                        h.Full_Proposal_Q2__c, h.Full_Proposal_Q1__c, h.Booked_Wgt_Q4__c, h.Booked_Wgt_Q3__c, 
                        h.Booked_Wgt_Q2__c, h.Booked_Wgt_Q1__c, h.Booked_Q4__c, h.Booked_Q3__c, h.Booked_Q2__c, 
                        h.Booked_Q1__c, h.Booked_Full_Q4__c, h.Booked_Full_Q3__c, h.Booked_Full_Q2__c, h.Account__c 
                        From 
                            Historical_Account_Best_Guess_Summary__c h 
                        where 
                            ACCOUNT__C =: a.Id AND Year__c =: accBestGuess.Year__c order by Archive_Date__c desc]){
                if(!tempHistMap.containsKey(h.OwnerId+h.Delivery_Channel__c)){   
                    if(h.Booked_Q1__c == null){h.Booked_Q1__c = 0;}
                    if(h.Booked_Q2__c == null){h.Booked_Q2__c = 0;}
                    if(h.Booked_Q3__c == null){h.Booked_Q3__c = 0;}
                    if(h.Booked_Q4__c == null){h.Booked_Q4__c = 0;}
                    if(h.Q1__c == null){h.Q1__c = 0;}
                    if(h.Q2__c == null){h.Q2__c = 0;}
                    if(h.Q3__c == null){h.Q3__c = 0;}
                    if(h.Q4__c == null){h.Q4__c = 0;}
                 
                    if(bookedQ1TotalByUser.containsKey(h.OwnerId)){
                         Decimal bookedd = bookedQ1TotalByUser.get(h.OwnerId);
                         bookedd = bookedd+h.Booked_Q1__c;
                         bookedQ1TotalByUser.put(h.OwnerId, bookedd);
                    }else{
                        bookedQ1TotalByUser.put(h.OwnerId, h.Booked_Q1__c);
                    }
                    if(bookedQ2TotalByUser.containsKey(h.OwnerId)){
                        Decimal bookedd = bookedQ2TotalByUser.get(h.OwnerId);
                        bookedd = bookedd+h.Booked_Q2__c;
                        bookedQ2TotalByUser.put(h.OwnerId, bookedd);
                    }else{
                        bookedQ2TotalByUser.put(h.OwnerId, h.Booked_Q2__c);
                    }
                    if(bookedQ3TotalByUser.containsKey(h.OwnerId)){
                        Decimal bookedd = bookedQ3TotalByUser.get(h.OwnerId);
                        bookedd = bookedd+h.Booked_Q3__c;
                        bookedQ3TotalByUser.put(h.OwnerId, bookedd);
                    }else{
                        bookedQ3TotalByUser.put(h.OwnerId, h.Booked_Q3__c);
                    }    
                    if(bookedQ4TotalByUser.containsKey(h.OwnerId)){
                        Decimal bookedd = bookedQ4TotalByUser.get(h.OwnerId);
                        bookedd = bookedd+h.Booked_Q4__c;
                        bookedQ4TotalByUser.put(h.OwnerId, bookedd);
                    }else{
                        bookedQ4TotalByUser.put(h.OwnerId, h.Booked_Q4__c);
                    }
                    if(Q1TotalByUser.containsKey(h.OwnerId)){
                        Decimal bookedd = Q1TotalByUser.get(h.OwnerId);
                        bookedd = bookedd+h.Q1__c;
                        Q1TotalByUser.put(h.OwnerId, bookedd);
                    }else{
                        Q1TotalByUser.put(h.OwnerId, h.Q1__c);
                    }             
                    if(Q2TotalByUser.containsKey(h.OwnerId)){
                        Decimal bookedd = Q2TotalByUser.get(h.OwnerId);
                        bookedd = bookedd+h.Q2__c;
                        Q2TotalByUser.put(h.OwnerId, bookedd);
                    }else{
                        Q2TotalByUser.put(h.OwnerId, h.Q2__c);
                    }             
                    if(Q3TotalByUser.containsKey(h.OwnerId)){
                        Decimal bookedd = Q3TotalByUser.get(h.OwnerId);
                        bookedd = bookedd+h.Q3__c;
                        Q3TotalByUser.put(h.OwnerId, bookedd);
                    }else{
                        Q3TotalByUser.put(h.OwnerId, h.Q3__c);
                    }             
                    if(Q4TotalByUser.containsKey(h.OwnerId)){
                        Decimal bookedd = Q4TotalByUser.get(h.OwnerId);
                        bookedd = bookedd+h.Q4__c;
                        Q4TotalByUser.put(h.OwnerId, bookedd);
                    }else{
                        Q4TotalByUser.put(h.OwnerId, h.Q4__c);
                    }
                    tempHistMap.put(h.OwnerId+h.Delivery_Channel__c,h.OwnerId+h.Delivery_Channel__c);
                }               
            }
              
            Map<String, Decimal> ABGbookedQ1TotalByUser = new Map<String, Decimal>();
            Map<String, Decimal> ABGbookedQ2TotalByUser = new Map<String, Decimal>();
            Map<String, Decimal> ABGbookedQ3TotalByUser = new Map<String, Decimal>();
            Map<String, Decimal> ABGbookedQ4TotalByUser = new Map<String, Decimal>();
            Map<String, Decimal> ABGQ1TotalByUser = new Map<String, Decimal>(); 
            Map<String, Decimal> ABGQ2TotalByUser = new Map<String, Decimal>();
            Map<String, Decimal> ABGQ3TotalByUser = new Map<String, Decimal>();
            Map<String, Decimal> ABGQ4TotalByUser = new Map<String, Decimal>();          
            
            for(Account_Best_Guess_Summary__c h: absummaryList){
                if(h.Booked_Q1__c == null){h.Booked_Q1__c = 0;}
                if(h.Booked_Q2__c == null){h.Booked_Q2__c = 0;}
                if(h.Booked_Q3__c == null){h.Booked_Q3__c = 0;}
                if(h.Booked_Q4__c == null){h.Booked_Q4__c = 0;}
                if(h.Q1__c == null){h.Q1__c = 0;}
                if(h.Q2__c == null){h.Q2__c = 0;}
                if(h.Q3__c == null){h.Q3__c = 0;}
                if(h.Q4__c == null){h.Q4__c = 0;}
                   
                if(ABGbookedQ1TotalByUser.containsKey(h.OwnerId)){
                    Decimal bookedd = ABGbookedQ1TotalByUser.get(h.OwnerId);
                    bookedd = bookedd+h.Booked_Q1__c;
                    ABGbookedQ1TotalByUser.put(h.OwnerId, bookedd);
                }else{
                    ABGbookedQ1TotalByUser.put(h.OwnerId, h.Booked_Q1__c);
                }
                if(ABGbookedQ2TotalByUser.containsKey(h.OwnerId)){
                    Decimal bookedd = ABGbookedQ2TotalByUser.get(h.OwnerId);
                    bookedd = bookedd+h.Booked_Q2__c;
                    ABGbookedQ2TotalByUser.put(h.OwnerId, bookedd);
                }else{
                    ABGbookedQ2TotalByUser.put(h.OwnerId, h.Booked_Q2__c);
                }
                if(ABGbookedQ3TotalByUser.containsKey(h.OwnerId)){
                    Decimal bookedd = ABGbookedQ3TotalByUser.get(h.OwnerId);
                    bookedd = bookedd+h.Booked_Q3__c;
                    ABGbookedQ3TotalByUser.put(h.OwnerId, bookedd);
                }else{
                    ABGbookedQ3TotalByUser.put(h.OwnerId, h.Booked_Q3__c);
                }
                if(ABGbookedQ4TotalByUser.containsKey(h.OwnerId)){
                    Decimal bookedd = ABGbookedQ4TotalByUser.get(h.OwnerId);
                    bookedd = bookedd+h.Booked_Q4__c;
                    ABGbookedQ4TotalByUser.put(h.OwnerId, bookedd);
                }else{
                    ABGbookedQ4TotalByUser.put(h.OwnerId, h.Booked_Q4__c);
                }
                if(ABGQ1TotalByUser.containsKey(h.OwnerId)){
                    Decimal bookedd = ABGQ1TotalByUser.get(h.OwnerId);
                    bookedd = bookedd+h.Q1__c;
                    ABGQ1TotalByUser.put(h.OwnerId, bookedd);
                }else{
                    ABGQ1TotalByUser.put(h.OwnerId, h.Q1__c);
                }            
                if(ABGQ2TotalByUser.containsKey(h.OwnerId)){
                    Decimal bookedd = ABGQ2TotalByUser.get(h.OwnerId);
                    bookedd = bookedd+h.Q2__c;
                    ABGQ2TotalByUser.put(h.OwnerId, bookedd);
                }else{
                    ABGQ2TotalByUser.put(h.OwnerId, h.Q2__c);
                }            
                if(ABGQ3TotalByUser.containsKey(h.OwnerId)){
                    Decimal bookedd = ABGQ3TotalByUser.get(h.OwnerId);
                    bookedd = bookedd+h.Q3__c;
                    ABGQ3TotalByUser.put(h.OwnerId, bookedd);
                }else{
                    ABGQ3TotalByUser.put(h.OwnerId, h.Q3__c);
                }             
                if(ABGQ4TotalByUser.containsKey(h.OwnerId)){
                    Decimal bookedd = ABGQ4TotalByUser.get(h.OwnerId);
                    bookedd = bookedd+h.Q4__c;
                    ABGQ4TotalByUser.put(h.OwnerId, bookedd);
                }else{
                    ABGQ4TotalByUser.put(h.OwnerId, h.Q4__c);
                }             
            }
    
            for(Historical_Account_Best_Guess_Summary__c h : [Select 
                                    h.Name, h.OwnerId, Owner.Name, h.Delivery_Channel__c , h.Year__c, h.Booked_Full_Q1__c, h.Wgt_Proposal_Q4__c, 
                                    h.Wgt_Proposal_Q3__c, h.Wgt_Proposal_Q2__c, h.Wgt_Proposal_Q1__c, h.Q4__c, h.Q3__c, h.Q2__c, h.Q1__c, 
                                    h.Full_Proposal_Q4__c, h.Full_Proposal_Q3__c, h.Full_Proposal_Q2__c, h.Full_Proposal_Q1__c, 
                                    h.Booked_Wgt_Q4__c, h.Booked_Wgt_Q3__c, h.Booked_Wgt_Q2__c, h.Booked_Wgt_Q1__c, h.Booked_Q4__c, 
                                    h.Booked_Q3__c, h.Booked_Q2__c, h.Booked_Q1__c, h.Booked_Full_Q4__c, h.Booked_Full_Q3__c, 
                                    h.Booked_Full_Q2__c, h.Account__c 
                                    From 
                                        Historical_Account_Best_Guess_Summary__c h 
                                    where 
                                        ACCOUNT__C =: a.Id AND Year__c =: accBestGuess.Year__c order by Archive_Date__c desc]){                 
                for(Account_Best_Guess_Summary__c bgs : absummaryList){
                    if(h.OwnerId == bgs.OwnerId && !tempMAP.containsKey(h.OwnerId)){
                        tempMAP.put(h.OwnerId, h.OwnerId);
                        AccountBestGuessRow abr = new AccountBestGuessRow();
                        abr.bookedQ1Change = ABGbookedQ1TotalByUser.get(bgs.OwnerId) - bookedQ1TotalByUser.get(h.OwnerId) ;
                        abr.bookedQ2Change = ABGbookedQ2TotalByUser.get(bgs.OwnerId) - bookedQ2TotalByUser.get(h.OwnerId) ;
                        abr.bookedQ3Change = ABGbookedQ3TotalByUser.get(bgs.OwnerId) - bookedQ3TotalByUser.get(h.OwnerId) ;
                        abr.bookedQ4Change = ABGbookedQ4TotalByUser.get(bgs.OwnerId) - bookedQ4TotalByUser.get(h.OwnerId) ;
                        abr.bestGuessQ1Change = ABGQ1TotalByUser.get(bgs.OwnerId) - Q1TotalByUser.get(h.OwnerId) ;
                        abr.bestGuessQ2Change = ABGQ2TotalByUser.get(bgs.OwnerId) - Q2TotalByUser.get(h.OwnerId) ;
                        abr.bestGuessQ3Change = ABGQ3TotalByUser.get(bgs.OwnerId) - Q3TotalByUser.get(h.OwnerId) ;
                        abr.bestGuessQ4Change = ABGQ4TotalByUser.get(bgs.OwnerId) - Q4TotalByUser.get(h.OwnerId) ;
                        abr.bestGuessQ1 = Q1TotalByUser.get(h.OwnerId);
                        abr.bestGuessQ2 = Q2TotalByUser.get(h.OwnerId);
                        abr.bestGuessQ3 = Q3TotalByUser.get(h.OwnerId);
                        abr.bestGuessQ4 = Q4TotalByUser.get(h.OwnerId);
                        abr.bookedQ1= bookedQ1TotalByUser.get(h.OwnerId);
                        abr.bookedQ2= bookedQ2TotalByUser.get(h.OwnerId);
                        abr.bookedQ3= bookedQ3TotalByUser.get(h.OwnerId);
                        abr.bookedQ4= bookedQ4TotalByUser.get(h.OwnerId);
                        abr.bestGuesstotal = Q1TotalByUser.get(h.OwnerId)+Q2TotalByUser.get(h.OwnerId)+Q3TotalByUser.get(h.OwnerId)+Q4TotalByUser.get(h.OwnerId);  
                        abr.bookedtotal = bookedQ1TotalByUser.get(h.OwnerId)+bookedQ2TotalByUser.get(h.OwnerId)+bookedQ3TotalByUser.get(h.OwnerId)+bookedQ4TotalByUser.get(h.OwnerId);
                        abr.bookedYearChange = ABGbookedQ1TotalByUser.get(bgs.OwnerId) - bookedQ1TotalByUser.get(h.OwnerId) + ABGbookedQ2TotalByUser.get(bgs.OwnerId) 
                                                    - bookedQ2TotalByUser.get(h.OwnerId) + ABGbookedQ3TotalByUser.get(bgs.OwnerId) - bookedQ3TotalByUser.get(h.OwnerId) 
                                                    + ABGbookedQ4TotalByUser.get(bgs.OwnerId) - bookedQ4TotalByUser.get(h.OwnerId);
                        abr.bestGuessYearChange = ABGQ1TotalByUser.get(bgs.OwnerId) - Q1TotalByUser.get(h.OwnerId) + ABGQ2TotalByUser.get(bgs.OwnerId) - Q2TotalByUser.get(h.OwnerId) 
                                                    + ABGQ3TotalByUser.get(bgs.OwnerId) - Q3TotalByUser.get(h.OwnerId) + ABGQ4TotalByUser.get(bgs.OwnerId) - Q4TotalByUser.get(h.OwnerId);
                        abr.owner = h.Owner.Name;
                        bestGuessList.add(abr);
                    }
                }
            }  
        }
    }
    /*
    Description - this method finds the appropriate matching Conglomerate BG record using
                    page parameters and the supplied delivery Channel
    param - String representing the delivery channel
    return - ID of the record to be linked to
    */
    private void createCongBGRecord(String delChannel){
        List<Conglomerate_Account_Best_Guess_Summary__c> congList = [SELECT ID
            FROM Conglomerate_Account_Best_Guess_Summary__c
            WHERE ACCOUNT__C =: a.ParentId
            AND Year__c =: accBestGuess.Year__c
            AND DELIVERY_CHANNEL__C =: delChannel];
        if (congList.size() > 0){
            //d nothing
        } else {
            Conglomerate_Account_Best_Guess_Summary__c newCong = new Conglomerate_Account_Best_Guess_Summary__c();
            newCong.Account__c = a.ParentId;
            newCong.Year__c = accBestGuess.Year__c;
            newCong.DELIVERY_CHANNEL__C = delChannel;
            newCong.OwnerId = a.Parent.OwnerId;
            insert newCong;
        }
    }
    
    //method to display revenue information
    public void displayRevenue(){
        List<Account_Best_Guess_Summary__c> abgs  = new List<Account_Best_Guess_Summary__c>();
        List<Conglomerate_Account_Best_Guess_Summary__c> cong  = new List<Conglomerate_Account_Best_Guess_Summary__c>();
        deliveryChannelWrapperList = new List<DeliveryChannelBaseWrapper>();
        Map<String, DeliveryChannelBaseWrapper> tempDChannelMAP = new Map<String, DeliveryChannelBaseWrapper>();
        tempDChannelMAP.put('Base', new DeliveryChannelBaseWrapper(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Base'));
        tempDChannelMAP.put('Mobile', new DeliveryChannelBaseWrapper(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Mobile'));
        tempDChannelMAP.put('Digital O&O', new DeliveryChannelBaseWrapper(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Digital O&O'));
        tempDChannelMAP.put('Audience Network', new DeliveryChannelBaseWrapper(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Audience Network'));
        if((selected == 'Total')||(selected == 'All')){
            if(a.Type!='Conglomerate'){
            abgs = [SELECT 
                        Id, Q1__c, Q2__c , Q3__c , Q4__c,Owner.Name, Owner__r.Name, Comments__c,Delivery_Channel__c, 
                        Year__c, Booked_Q1__c, Booked_Q2__c, Booked_Q3__c, Booked_Q4__c, a.Wgt_Proposal_Q4__c, 
                        a.Wgt_Proposal_Q3__c, a.Wgt_Proposal_Q2__c, a.Wgt_Proposal_Q1__c, a.Full_Proposal_Q4__c, 
                        a.Full_Proposal_Q3__c, a.Full_Proposal_Q2__c, a.Full_Proposal_Q1__c, a.Conglomerate_Account_Best_Guess_Summary__c, 
                        a.Booked_Wgt_Q4__c, a.Booked_Wgt_Q3__c, a.Booked_Wgt_Q2__c, Booked_Wgt_Q1__c , a.Booked_Full_Q4__c, a.Booked_Full_Q3__c, 
                        a.Booked_Full_Q2__c, a.Booked_Full_Q1__c 
                        FROM 
                            Account_Best_Guess_Summary__c a 
                        WHERE 
                            Account__c = :a.Id and Year__c=:accBestGuess.Year__c order by Year__c desc];
            }else{
                cong = [SELECT 
                            Id, c.Year__c, c.Wgt_Proposal_Q4__c, c.Wgt_Proposal_Q3__c, c.Wgt_Proposal_Q2__c, c.Wgt_Proposal_Q1__c, c.Q4__c, 
                            c.Q3__c, c.Q2__c, c.Q1__c, c.Full_Proposal_Q4__c, c.Full_Proposal_Q3__c, c.Full_Proposal_Q2__c, c.Full_Proposal_Q1__c, 
                            c.Delivery_Channel__c, c.Booked_Wgt_Q4__c, c.Booked_Wgt_Q3__c, c.Booked_Wgt_Q2__c, c.Booked_Wgt_Q1__c, c.Booked_Q4__c, 
                            c.Booked_Q3__c, c.Booked_Q2__c, c.Booked_Q1__c, c.Booked_Full_Q4__c, c.Booked_Full_Q3__c, c.Booked_Full_Q2__c, 
                            c.Booked_Full_Q1__c, c.Account__c 
                            FROM 
                                Conglomerate_Account_Best_Guess_Summary__c c 
                            WHERE 
                                Account__c = :a.Id and Year__c=:accBestGuess.Year__c order by Year__c desc];
            }                   
        }else{
            if(a.Type!='Conglomerate'){
                abgs = [SELECT 
                            Id, Q1__c, Q2__c , Q3__c , Q4__c,Owner.Name, Owner__r.Name, Comments__c,Delivery_Channel__c, 
                            Year__c, Booked_Q1__c, Booked_Q2__c, Booked_Q3__c, Booked_Q4__c, a.Wgt_Proposal_Q4__c, 
                            a.Wgt_Proposal_Q3__c, a.Wgt_Proposal_Q2__c, a.Wgt_Proposal_Q1__c, a.Full_Proposal_Q4__c, 
                            a.Full_Proposal_Q3__c, a.Full_Proposal_Q2__c, a.Full_Proposal_Q1__c, a.Conglomerate_Account_Best_Guess_Summary__c, 
                            a.Booked_Wgt_Q4__c, a.Booked_Wgt_Q3__c, a.Booked_Wgt_Q2__c, Booked_Wgt_Q1__c , a.Booked_Full_Q4__c, a.Booked_Full_Q3__c, 
                            a.Booked_Full_Q2__c, a.Booked_Full_Q1__c 
                            FROM 
                                Account_Best_Guess_Summary__c a 
                            WHERE 
                                Account__c = :a.Id and Year__c=:accBestGuess.Year__c and Delivery_Channel__c=:selected order by Year__c desc];  
            }else{
                cong = [SELECT 
                            Id, c.Year__c, c.Wgt_Proposal_Q4__c, c.Wgt_Proposal_Q3__c, c.Wgt_Proposal_Q2__c, c.Wgt_Proposal_Q1__c, c.Q4__c, 
                            c.Q3__c, c.Q2__c, c.Q1__c, c.Full_Proposal_Q4__c, c.Full_Proposal_Q3__c, c.Full_Proposal_Q2__c, c.Full_Proposal_Q1__c, 
                            c.Delivery_Channel__c, c.Booked_Wgt_Q4__c, c.Booked_Wgt_Q3__c, c.Booked_Wgt_Q2__c, c.Booked_Wgt_Q1__c, c.Booked_Q4__c, 
                            c.Booked_Q3__c, c.Booked_Q2__c, c.Booked_Q1__c, c.Booked_Full_Q4__c, c.Booked_Full_Q3__c, c.Booked_Full_Q2__c, 
                            c.Booked_Full_Q1__c, c.Account__c 
                            FROM 
                                Conglomerate_Account_Best_Guess_Summary__c c 
                            WHERE 
                                Account__c = :a.Id and Year__c=:accBestGuess.Year__c and Delivery_Channel__c=:selected order by Year__c desc];
            }
        }
        abgsQ1=0;
        abgsQ2=0;
        abgsQ3=0;
        abgsQ4=0;
        q1Booked = 0;
        q2Booked = 0;
        q3Booked = 0;
        q4Booked = 0;
        q1BookedWgt = 0;
        q2BookedWgt = 0;
        q3BookedWgt = 0;
        q4BookedWgt = 0;
        q1BookedFull = 0;
        q2BookedFull = 0;
        q3BookedFull = 0;
        q4BookedFull = 0;
        bookedTotal = 0;
        bookedWgtTotal = 0;
        bookedFullTotal = 0;
        if(a.Type!='Conglomerate'){
            for(Account_Best_Guess_Summary__c bgs : abgs){
                if(bgs.Booked_Q1__c == null){bgs.Booked_Q1__c = 0;}
                if(bgs.Booked_Q2__c == null){bgs.Booked_Q2__c = 0;}
                if(bgs.Booked_Q3__c == null){bgs.Booked_Q3__c = 0;}
                if(bgs.Booked_Q4__c == null){bgs.Booked_Q4__c = 0;}

                if(!tempDChannelMAP.containsKey(bgs.Delivery_Channel__c)){
                    DeliveryChannelBaseWrapper wrapper = new DeliveryChannelBaseWrapper(bgs.Booked_Q1__c, bgs.Booked_Q2__c,bgs.Booked_Q3__c,bgs.Booked_Q4__c, bgs.Booked_Q1__c+bgs.Booked_Q1__c+bgs.Booked_Q1__c+bgs.Booked_Q1__c,
                                                      bgs.Booked_Wgt_Q1__c, bgs.Booked_Wgt_Q2__c,bgs.Booked_Wgt_Q3__c,bgs.Booked_Wgt_Q4__c, bgs.Booked_Wgt_Q1__c+bgs.Booked_Wgt_Q2__c+bgs.Booked_Wgt_Q3__c+bgs.Booked_Wgt_Q4__c,
                                                      bgs.Booked_Full_Q1__c, bgs.Booked_Full_Q2__c,bgs.Booked_Full_Q3__c,bgs.Booked_Full_Q4__c, bgs.Booked_Full_Q1__c+bgs.Booked_Full_Q2__c+bgs.Booked_Full_Q3__c+bgs.Booked_Full_Q4__c,bgs.Delivery_Channel__c);
                    tempDChannelMAP.put(bgs.Delivery_Channel__c,wrapper);
                }else{
                    DeliveryChannelBaseWrapper wrapper = tempDChannelMAP.get(bgs.Delivery_Channel__c);
                    wrapper.bookedQ1 = wrapper.bookedQ1 + bgs.Booked_Q1__c;
                    wrapper.bookedQ2 = wrapper.bookedQ2 + bgs.Booked_Q2__c;
                    wrapper.bookedQ3 = wrapper.bookedQ3 + bgs.Booked_Q3__c;
                    wrapper.bookedQ4 = wrapper.bookedQ4 + bgs.Booked_Q4__c;
                    wrapper.bookedTotal = wrapper.bookedTotal + bgs.Booked_Q1__c + bgs.Booked_Q2__c + bgs.Booked_Q3__c + bgs.Booked_Q4__c;
                    
                    wrapper.bookedWgtQ1 = wrapper.bookedWgtQ1 + bgs.Booked_Wgt_Q1__c;
                    wrapper.bookedWgtQ2 = wrapper.bookedWgtQ2 + bgs.Booked_Wgt_Q2__c;
                    wrapper.bookedWgtQ3 = wrapper.bookedWgtQ3 + bgs.Booked_Wgt_Q3__c;
                    wrapper.bookedWgtQ4 = wrapper.bookedWgtQ4 + bgs.Booked_Wgt_Q4__c;
                    wrapper.bookedWgtTotal = wrapper.bookedWgtTotal + bgs.Booked_Wgt_Q1__c + bgs.Booked_Wgt_Q2__c + bgs.Booked_Wgt_Q3__c + bgs.Booked_Wgt_Q4__c;
                    
                    wrapper.bookedFullQ1 = wrapper.bookedFullQ1 + bgs.Booked_Full_Q1__c;
                    wrapper.bookedFullQ2 = wrapper.bookedFullQ2 + bgs.Booked_Full_Q2__c;
                    wrapper.bookedFullQ3 = wrapper.bookedFullQ3 + bgs.Booked_Full_Q3__c;
                    wrapper.bookedFullQ4 = wrapper.bookedFullQ4 + bgs.Booked_Full_Q4__c;
                    wrapper.bookedFullTotal = wrapper.bookedFullTotal + bgs.Booked_Full_Q1__c + bgs.Booked_Full_Q2__c + bgs.Booked_Full_Q3__c + bgs.Booked_Full_Q4__c;
                    
                    wrapper.dChannel = bgs.Delivery_Channel__c;
                    
                    tempDChannelMAP.put(bgs.Delivery_Channel__c, wrapper);
                
                }
                if(bgs.Q1__c!=null){
                    abgsQ1 += bgs.Q1__c;
                }
                if(bgs.Q2__c!=null){
                    abgsQ2 += bgs.Q2__c;
                }
                if(bgs.Q3__c!=null){
                    abgsQ3 += bgs.Q3__c;
                }
                if(bgs.Q4__c!=null){
                    abgsQ4 += bgs.Q4__c;
                }
                if(bgs.Booked_Q1__c!=null){
                    q1Booked += bgs.Booked_Q1__c;
                }
                if(bgs.Booked_Q2__c!=null){
                    q2Booked += bgs.Booked_Q2__c;
                }
                if(bgs.Booked_Q3__c!=null){
                    q3Booked += bgs.Booked_Q3__c;
                }
                if(bgs.Booked_Q4__c!=null){
                    q4Booked += bgs.Booked_Q4__c;
                }
                if(bgs.Booked_Wgt_Q1__c!=null){
                    q1BookedWgt += bgs.Booked_Wgt_Q1__c;
                }
                if(bgs.Booked_Wgt_Q2__c!=null){
                    q2BookedWgt += bgs.Booked_Wgt_Q2__c;
                }
                if(bgs.Booked_Wgt_Q3__c!=null){
                    q3BookedWgt += bgs.Booked_Wgt_Q3__c;
                }
                if(bgs.Booked_Wgt_Q4__c!=null){
                    q4BookedWgt += bgs.Booked_Wgt_Q4__c;
                }
                if(bgs.Booked_Full_Q1__c!=null){
                    q1BookedFull += bgs.Booked_Full_Q1__c;
                }
                if(bgs.Booked_Full_Q2__c!=null){
                    q2BookedFull += bgs.Booked_Full_Q2__c;
                }
                if(bgs.Booked_Full_Q3__c!=null){
                    q3BookedFull += bgs.Booked_Full_Q3__c;
                }
                if(bgs.Booked_Full_Q4__c!=null){
                    q4BookedFull += bgs.Booked_Full_Q4__c;
                }
            }  
        }else{
            for(Conglomerate_Account_Best_Guess_Summary__c bgs : cong){
                if(bgs.Booked_Q1__c == null){bgs.Booked_Q1__c = 0;}
                if(bgs.Booked_Q2__c == null){bgs.Booked_Q2__c = 0;}
                if(bgs.Booked_Q3__c == null){bgs.Booked_Q3__c = 0;}
                if(bgs.Booked_Q4__c == null){bgs.Booked_Q4__c = 0;}


                if(!tempDChannelMAP.containsKey(bgs.Delivery_Channel__c)){
                    DeliveryChannelBaseWrapper wrapper = new DeliveryChannelBaseWrapper(bgs.Booked_Q1__c, bgs.Booked_Q2__c,bgs.Booked_Q3__c,bgs.Booked_Q4__c, bgs.Booked_Q1__c+bgs.Booked_Q1__c+bgs.Booked_Q1__c+bgs.Booked_Q1__c,
                                                      bgs.Booked_Wgt_Q1__c, bgs.Booked_Wgt_Q2__c,bgs.Booked_Wgt_Q3__c,bgs.Booked_Wgt_Q4__c, bgs.Booked_Wgt_Q1__c+bgs.Booked_Wgt_Q2__c+bgs.Booked_Wgt_Q3__c+bgs.Booked_Wgt_Q4__c,
                                                      bgs.Booked_Full_Q1__c, bgs.Booked_Full_Q2__c,bgs.Booked_Full_Q3__c,bgs.Booked_Full_Q4__c, bgs.Booked_Full_Q1__c+bgs.Booked_Full_Q2__c+bgs.Booked_Full_Q3__c+bgs.Booked_Full_Q4__c,bgs.Delivery_Channel__c);
                    tempDChannelMAP.put(bgs.Delivery_Channel__c,wrapper);
                }else{
                    DeliveryChannelBaseWrapper wrapper = tempDChannelMAP.get(bgs.Delivery_Channel__c);
                    wrapper.bookedQ1 = wrapper.bookedQ1 + bgs.Booked_Q1__c;
                    wrapper.bookedQ2 = wrapper.bookedQ2 + bgs.Booked_Q2__c;
                    wrapper.bookedQ3 = wrapper.bookedQ3 + bgs.Booked_Q3__c;
                    wrapper.bookedQ4 = wrapper.bookedQ4 + bgs.Booked_Q4__c;
                    wrapper.bookedTotal = wrapper.bookedTotal + bgs.Booked_Q1__c + bgs.Booked_Q2__c + bgs.Booked_Q3__c + bgs.Booked_Q4__c;
                    
                    wrapper.bookedWgtQ1 = wrapper.bookedWgtQ1 + bgs.Booked_Wgt_Q1__c;
                    wrapper.bookedWgtQ2 = wrapper.bookedWgtQ2 + bgs.Booked_Wgt_Q2__c;
                    wrapper.bookedWgtQ3 = wrapper.bookedWgtQ3 + bgs.Booked_Wgt_Q3__c;
                    wrapper.bookedWgtQ4 = wrapper.bookedWgtQ4 + bgs.Booked_Wgt_Q4__c;
                    wrapper.bookedWgtTotal = wrapper.bookedWgtTotal + bgs.Booked_Wgt_Q1__c + bgs.Booked_Wgt_Q2__c + bgs.Booked_Wgt_Q3__c + bgs.Booked_Wgt_Q4__c;
                    
                    wrapper.bookedFullQ1 = wrapper.bookedFullQ1 + bgs.Booked_Full_Q1__c;
                    wrapper.bookedFullQ2 = wrapper.bookedFullQ2 + bgs.Booked_Full_Q2__c;
                    wrapper.bookedFullQ3 = wrapper.bookedFullQ3 + bgs.Booked_Full_Q3__c;
                    wrapper.bookedFullQ4 = wrapper.bookedFullQ4 + bgs.Booked_Full_Q4__c;
                    wrapper.bookedFullTotal = wrapper.bookedFullTotal + bgs.Booked_Full_Q1__c + bgs.Booked_Full_Q2__c + bgs.Booked_Full_Q3__c + bgs.Booked_Full_Q4__c;
                    
                    wrapper.dChannel = bgs.Delivery_Channel__c;
                    
                    tempDChannelMAP.put(bgs.Delivery_Channel__c, wrapper);
                
                }
                if(bgs.Q1__c!=null){
                    abgsQ1 += bgs.Q1__c;
                }    
                if(bgs.Q2__c!=null){
                    abgsQ2 += bgs.Q2__c;
                }
                if(bgs.Q3__c!=null){
                    abgsQ3 += bgs.Q3__c;
                }
                if(bgs.Q4__c!=null){
                    abgsQ4 += bgs.Q4__c;
                }
                if(bgs.Booked_Q1__c!=null){
                    q1Booked += bgs.Booked_Q1__c;
                }
                if(bgs.Booked_Q2__c!=null){
                    q2Booked += bgs.Booked_Q2__c;
                }
                if(bgs.Booked_Q3__c!=null){
                    q3Booked += bgs.Booked_Q3__c;
                }
                if(bgs.Booked_Q4__c!=null){
                    q4Booked += bgs.Booked_Q4__c;
                }
                if(bgs.Booked_Wgt_Q1__c!=null){
                    q1BookedWgt += bgs.Booked_Wgt_Q1__c;
                }
                if(bgs.Booked_Wgt_Q2__c!=null){
                    q2BookedWgt += bgs.Booked_Wgt_Q2__c;
                }
                if(bgs.Booked_Wgt_Q3__c!=null){
                    q3BookedWgt += bgs.Booked_Wgt_Q3__c;
                }
                if(bgs.Booked_Wgt_Q4__c!=null){
                    q4BookedWgt += bgs.Booked_Wgt_Q4__c;
                }
                if(bgs.Booked_Full_Q1__c!=null){
                    q1BookedFull += bgs.Booked_Full_Q1__c;
                }
                if(bgs.Booked_Full_Q2__c!=null){
                    q2BookedFull += bgs.Booked_Full_Q2__c;
                }
                if(bgs.Booked_Full_Q3__c!=null){
                    q3BookedFull += bgs.Booked_Full_Q3__c;
                }
                if(bgs.Booked_Full_Q4__c!=null){
                    q4BookedFull += bgs.Booked_Full_Q4__c;
                }
            }
        }
        bookedTotal = q1Booked + q2Booked + q3Booked + q4Booked;
        bookedWgtTotal = q1BookedWgt + q2BookedWgt + q3BookedWgt + q4BookedWgt;
        bookedFullTotal = q1BookedFull + q2BookedFull + q3BookedFull + q4BookedFull;
        deliveryChannelWrapperList = tempDChannelMAP.values();
    }
    
    //method to display delivery channel field on page
    public List<SelectOption> getDeliveryChannel(){
        List<SelectOption> lstReturn = new List<SelectOption>();
        lstReturn.add(new SelectOption('Total','Total'));
        lstReturn.add(new SelectOption('All','All'));
        Schema.DescribeFieldResult F = Account_Best_Guess_Summary__c.Delivery_Channel__c.getDescribe();
        List<Schema.PicklistEntry> P = F.getPicklistValues();
        for (Schema.PicklistEntry pe : P) {
            lstReturn.add(new SelectOption(pe.getValue(),pe.getValue()));
        }
        return lstReturn;
    }
    
    //wrapper
    public List<CommentWrapper> bgComments{get;set;}
    public List<CommentWrapper> getCommentsList(){
        bgComments = new List<CommentWrapper>();
        for(Account_Best_Guess_Summary__c bg : absummaryList){
            Boolean edit=false;
            if(bg.OwnerId == Userinfo.getUserId()){
                edit = true;
            }
            String label = bg.Owner.Name+'-'+bg.Delivery_Channel__c +' Comments:';
            Boolean rendered = false;
            if(bg.Comments__c!=null || bg.OwnerId == Userinfo.getUserId()){
                rendered = true;
            }
            bgComments.add(new CommentWrapper(bg, label,edit,rendered));   
        }
        return bgComments;
    }
    
    //wrapper class
    public Class CommentWrapper{
        public Account_Best_Guess_Summary__c abg{get;set;}
        public String commentLabel{get;set;}
        public Boolean edit{get;set;}
        public Boolean rendered{get;set;}
        public CommentWrapper(Account_Best_Guess_Summary__c bg, String label, Boolean e, Boolean rend){
            this.abg = bg;
            this.commentLabel = label;
            this.edit = e;
            this.rendered = rend;
        }
    }
    
    //wrapper class
    public Class DeliveryChannelBaseWrapper{
        //wrapper class variables
        public Decimal bookedQ1{get;set;}
        public Decimal bookedQ2{get;set;}
        public Decimal bookedQ3{get;set;}
        public Decimal bookedQ4{get;set;}
        public Decimal bookedTotal{get;set;}
        public Decimal bookedWgtQ1{get;set;}
        public Decimal bookedWgtQ2{get;set;}
        public Decimal bookedWgtQ3{get;set;}
        public Decimal bookedWgtQ4{get;set;}
        public Decimal bookedWgtTotal{get;set;}
        public Decimal bookedFullQ1{get;set;}
        public Decimal bookedFullQ2{get;set;}
        public Decimal bookedFullQ3{get;set;}
        public Decimal bookedFullQ4{get;set;}
        public Decimal bookedFullTotal{get;set;}
        public String dChannel{get;set;}
        
        //wrapper class constructor
        public DeliveryChannelBaseWrapper(Decimal bBQ1,Decimal bBQ2,Decimal bBQ3,Decimal bBQ4,Decimal bBT,Decimal bBWQ1,Decimal bBWQ2,Decimal bBWQ3,Decimal bBWQ4,Decimal bBWT,Decimal bBFQ1,Decimal bBFQ2,Decimal bBFQ3,Decimal bBFQ4,Decimal bBFT,String dc){
            this.bookedQ1 = bBQ1;
            this.bookedQ2 = bBQ2;
            this.bookedQ3 = bBQ3;
            this.bookedQ4 = bBQ4;
            this.bookedTotal = bBT;
            this.bookedWgtQ1 = bBWQ1;
            this.bookedWgtQ2 = bBWQ2;
            this.bookedWgtQ3 = bBWQ3;
            this.bookedWgtQ4 = bBWQ4;
            this.bookedWgtTotal = bBWT;
            this.bookedFullQ1 = bBFQ1;
            this.bookedFullQ2 = bBFQ2;
            this.bookedFullQ3 = bBFQ3;
            this.bookedFullQ4 = bBFQ4;
            this.bookedFullTotal = bBFT;
            this.dChannel = dc;
        }
    }
              
}
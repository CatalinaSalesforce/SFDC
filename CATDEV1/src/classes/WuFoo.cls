public class WuFoo {

    public String os { get; set; }

    public String browser { get; set; }


    public String tversion {get; set;}
    public String output {get; set;}
    public Boolean showForm1 {get; set;}
    public Boolean showForm2 {get; set;}
    public Boolean showForm3 {get; set;}
    public String selected {get; set;}
    public String tProb {get; set;}
    
    
    public String userAgent;
    public String ipaddress;
    public String cookies {get; set;}
    
    public String getIpAddress(){
        return ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP');
    }
    public String getUserAgent(){
        return ApexPages.currentPage().getHeaders().get('User-Agent');
    }
    public String getResponse(){
        return choiceMap.get(selected);
    }
    
    Map<String,String> choiceMap;
    
    public String getUserID(){
        Map<String, String> paramMap = ApexPages.currentPage().getParameters();
        if(paramMap.get('iduser') != null){
            return paramMap.get('iduser');
        } else{
            return '';
        }
    }
    
    public String getparentToSave(){
        Map<String, String> paramMap = ApexPages.currentPage().getParameters();
        if(paramMap.get('website') != null){
            return paramMap.get('website');
        } else {
            return null;
        }
    }
    
    public void run() {
        system.debug(ApexPages.currentPage().getUrl());
        output = 'starting...';   
        choicemap = new Map<String,String>();

        choiceMap.put('1','Je ne parviens pas à imprimer');
        choiceMap.put('2','Il manque des données sur le coupon imprimé');
        choiceMap.put('3','J’ai des problèmes avec mon imprimante ou ses paramètres');
        choiceMap.put('4','Je ne parviens pas à utiliser les coupons dans mon commerce');
        choiceMap.put('5','Je ne trouve pas de coupon correspondant à ma marque/mon commerce préféré');
        choiceMap.put('6','Mon enseigne n’est pas proposée / Je n’ai pas de carte de fidélité');
        choiceMap.put('7','Je n’ai pas reçu mon remboursement');
        choiceMap.put('8','Mon achat n’a pas été validé');
        choiceMap.put('9','Le paiement du remboursement a été refusé');
        choiceMap.put('10','Je ne parviens pas à m’inscrire ou à m\'identifier');
        choiceMap.put('11','J’ai perdu mon mot de passe d’identification');
        choiceMap.put('12','Mon navigateur ou mon système d’exploitation ne sont pas compatibles');
        choicemap.put('13','Autres demandes');
        
        
        Map<String, String> paramMap = ApexPages.currentPage().getParameters();
        
        for(String s : paramMap.keySet()){
            system.debug('### ' + s +', ' + paramMap.get(s));
        }      
        String handshakeToken = paramMap.get('HandshakeKey');
        system.debug(ApexPages.currentPage().getURL());
        List<String> formFieldNames = new List<String>();
        if(handshakeToken != 'Form1' || handshakeToken != 'Form2' || handshakeToken != 'Form3'){
            
            system.debug(parammap.get('FieldStructure'));
            System.jsonparser j = system.json.createparser(paramMap.get('FieldStructure'));
            String key = '';
            String value = '';
            Map<String, String> IDtoTitle = new Map<String,String>();
            while(j.nextToken() != null){
                if(j.getCurrentToken() == jsontoken.Start_array){
                    while(j.nextToken() != null){
                        
                        if(j.getCurrentToken() == jsontoken.field_name){ 
                            if(j.getText() == 'Title'){
                                j.nextToken();
                                value = j.getText();
                                system.debug(j.gettext());
                            }
                            if(j.getText() == 'SubFields'){
                                j.nextToken();
                                while(j.getCurrentToken() != jsontoken.end_array){
                                    if(j.getText() == 'ID'){
                                        j.nextToken();
                                        key = j.getText();
                                        j.nextToken();
                                        j.nextToken();
                                        value = j.getText();
                                        IDtoTitle.put(key,value);
                                    }
                                    j.nextToken();
                                }
                            }
                            
                            if(j.getText() == 'ID'){
                                j.nextToken();
                                key = j.getText();
                                system.debug(j.gettext());
                            }
                            
                        }
                        if(j.getCurrentToken() == jsontoken.end_object && !IDtoTitle.containsKey(key))
                            IDtoTitle.put(key,value);
                    }
                }            
            }
            system.debug(IDtoTitle);
            Map<String,String> titleIdMap = new Map<String,String>();
            String out = '';
            for(String s : idtotitle.keyset()){
                titleIdMap.put(idtotitle.get(s),s);
                out+=idtotitle.get(s)+'='+s+', ';
            }
            //system.debug(titleidmap);
            system.debug(out);
            List<WuFoo_Map__c> wmapList = [select Name,Case_Field_API_Name__c, Wufoo_Field__c, Field_Type__c from Wufoo_Map__c where Name = :handShakeToken];
            Case c = new Case();
            c.Origin = 'Web';
            
            try{ 
            c.RecordTypeId = [select Id from RecordType where Name = 'France Case'].Id;
            }
            catch(Exception e){
                system.debug('Record Type Assignment failed');
            }
            
            for(WuFoo_Map__c wm : wmapList){
                
                system.debug('titleIdMap.get('+wm.Wufoo_Field__c);
                system.debug(titleIdMap.get(wm.Wufoo_Field__c));
                system.debug(paramMap.get(titleIdMap.get(wm.Wufoo_Field__c)));
                
                String wufooValue = paramMap.get(titleIdMap.get(wm.Wufoo_Field__c)); //use wufoo field to key the field id.
                                                                     // name=>field id
                                                                     //paramMap fieldid=> value
                String sfdcField = wm.Case_Field_API_Name__c;
                if(wm.Field_Type__c == 'Text'){
                
                    if(sfdcField == 'Subject'){
                    system.debug('looking for ' + wufooValue +' in choice map');
                        wufooValue = choicemap.get(wufooValue);
                    }
                    system.debug('We will try to put ' + wufooValue + ' into field ' + sfdcField);
                    try{
                        if(sfdcField == 'User_Agent__c'){
                            if(wufooValue.contains('Windows NT 6.2')){
                                tversion = 'Windows 8';
                            } else if(wufooValue.contains('Windows NT 6.1')){
                                tversion = 'Windows 7';
                            } else if(wufooValue.contains('Windows NT 6.0')){
                                tversion = 'Windows Vista';
                            } else if(wufooValue.contains('Windows NT 5.2')){
                                tversion = 'Windows XP x64 / Windows Server 2003';
                            } else if(wufooValue.contains('Windows NT 5.1')){
                                tversion = 'Windows XP';
                            } else if(wufooValue.contains('Windows NT 5.01')){
                                tversion = 'Windows 2000, Service Pack 1 (SP1)';
                            } else if(wufooValue.contains('Windows NT 5.0')){
                                tversion = 'Windows 2000';
                            } else if(wufooValue.contains('Windows NT 4.0')){
                                tversion = 'Microsoft Windows NT 4.0';
                            } else if(wufooValue.contains('Win 9x 4.90')){
                                tversion = 'Windows ME';
                            } else if(wufooValue.contains('Windows 98')){
                                tversion = 'Windows 98';
                            } else if(wufooValue.contains('Windows 95')){
                                tversion = 'Windows 95';
                            }
                            
                            
                            
                        }
                    
                        c.put(sfdcField, wufooValue);
                        system.debug('Success.');
                    } catch(Exception e){
                        try{
                            if(e.getMessage() == 'Illegal assignment from String to Boolean'){
                                if(wufooValue == 'true' || wufooValue == 'True'){
                                    c.put(sfdcField, true);
                                } else {
                                    c.put(sfdcField, false);
                                }
                            }
                        } catch(Exception ex){
                            
                        }
                       // system.debug('Didnt work. Exception:');
                      //  system.debug(e);
                    }
                } else if(wm.Field_Type__c == 'Checkbox') {
                    if(wufooValue != ''){
                    system.debug('It looks like ' + wm.Wufoo_Field__c + ':' + wufooValue + ' was checked.');
                        /*
                        try{
                            c.put(sfdcField, true);
                        } catch(Exception e){
                        
                        } */
                        tprob += wm.Wufoo_Field__c+',';
                        
                    }else{
                        system.debug(wm.Wufoo_Field__c + ' was not checked');
                    }
                }
            }
            
            if(paramMap.get('website') != null){
                c.from_url__c = paramMap.get('website');
            }
            
            //Case Ownership
            France_Case_Assignment__c f = France_Case_Assignment__c.getInstance('Default');
            try{
                User u = [select id from user where Name = :f.Owner_Name__c limit 1];
                system.debug(u.id);
                c.ownerId = u.Id;
//                c.OwnerId = [select Id from User where Name = :f.Owner_Name__c].Id;
                system.debug('what');
                    system.debug(c.ownerid);
            }catch(Exception e){}
            
            
           //do we need to make a new contact?
           
           List<Contact> contactList = [select Id, AccountId from Contact where Email = :c.suppliedEmail];
           Contact con = new Contact();
           if(contactList.size() < 1){
               //we need to make a new contact
               con.OwnerId = c.OwnerId;
               system.debug(con.ownerid);
               
               con.FirstName = c.Web_First_Name__c;
               con.LastName = c.Web_Last_Name__c;
               con.Email = c.suppliedEmail;
               con.RecordTypeID = [select Id from RecordType where Name = 'France Case Contact'].id;
               //'012Z00000004QKy';
               
               Account a = [select Id from Account where Name = 'Case Account'][0];
               
               con.AccountId = a.Id;
               
               try{ 
                   insert con;
               }catch(Exception e){
                   
               }
           } else {
                //use the first contact that we found.
                con = contactList.get(0);       
           }
           
            if(con != null) c.ContactId = con.Id;  
            if(con.AccountId == null){
                con.AccountId = [select Id from Account where Name = 'Case Account'].Id;
                update con;    
            }
            try{
                c.SuppliedName = c.Web_First_Name__c + ' ' + c.Web_Last_Name__c;
                if(tversion != null){
                    c.User_Operating_System__c = tversion;
                    system.debug(tversion);
                }
                
                if(tprob != null){
                    if(tprob.endswith(',')){
                        tprob = tprob.substring(0,(tprob.length()-1));
                    }
                    if(tprob.startswith('null')){
                        tprob = tprob.substring(4);
                    }
                    c.Problem_with__c = tprob;
                }
                if(paramMap.get('HandshakeKey') == 'Form3'){
                    if(paramMap.get('Field4') != null){
                        c.Problem_with__c = paramMap.get('Field4');
                    }
                    c.Description = paramMap.get('Field7');
                 }
                 
                 if(c.From_Url__c.contains('couponnetwork')){
                     c.From_Url__c = 'CouponNetwork.fr';
                 } else if(c.From_Url__c.contains('orangecoupons')){
                     c.From_Url__c = 'Orange Coupons';
                 } else if(c.From_Url__c.contains('cwallet')){
                     c.From_Url__c = 'Cwallet.fr';
                 }
                
                insert c;
                system.debug('Inserted Case ' + c.Id);
            }catch(Exception e){
            
            }              
        } else {
            system.debug('No Handshake Token');
        }
    }
    public void showiFrame(){
    //need to change this to reflect changes in the VF page. this is hard coded..
        system.debug(getResponse());
        system.debug('showForm1 :' +showForm1 );
        system.debug('showForm2 :' + showForm2);
        system.debug('showForm3 :' + showForm3);
        if(Integer.valueOf(selected) < 6) showForm1 = true;
        if(Integer.valueOf(selected) <= 9 && Integer.valueOf(selected) >= 6 ) showForm2 = true;
        if(Integer.valueOf(selected) <= 13 && Integer.valueOf(selected) >= 10 ) showForm3 = true;
        system.debug('showForm1 :' + showForm1);
        system.debug('showForm2 :' + showForm2);
        system.debug('showForm3 :' + showForm3);
       // system.debug(parentToSave); 
    }

    public String getPriority(){
        if(Integer.valueOf(selected) == 1){
            return 'High';
        }
        if(Integer.valueOf(selected) == 2){
            return 'High';
        }
        if(Integer.valueOf(selected) == 3){
            return 'High';
        }
        if(Integer.valueOf(selected) == 4){
            return 'Medium';
        }    
        if(Integer.valueOf(selected) == 5){
            return 'Low';
        }
        if(Integer.valueOf(selected) == 6){
            return 'Medium';
        }
        if(Integer.valueOf(selected) == 7){
            return 'High';
        }
        if(Integer.valueOf(selected) == 8){
            return 'High';
        }
        if(Integer.valueOf(selected) == 9){
            return 'High';
        }
        if(Integer.valueOf(selected) == 10){
            return 'High';
        }
        if(Integer.valueOf(selected) == 11){
            return 'High';
        }
        if(Integer.valueOf(selected) == 12){
            return 'Medium';
        }
        if(Integer.valueOf(selected) == 13){
            return 'Low';
        }
        
        return 'Medium';
    }
    
    public WuFoo(){
        showForm1 = false;
        showForm2 = false;
        showForm3 = false;
       // parentToSave = '';
        /*
        Account a = new Account();
        a.Name = 'a';
        insert a;*/

        choicemap = new Map<String,String>();

        choiceMap.put('1','Je ne parviens pas à imprimer');
        choiceMap.put('2','Il manque des données sur le coupon imprimé');
        choiceMap.put('3','J’ai des problèmes avec mon imprimante ou ses paramètres');
        choiceMap.put('4','Je ne parviens pas à utiliser les coupons dans mon commerce');
        choiceMap.put('5','Je ne trouve pas de coupon correspondant à ma marque/mon commerce préféré');
        choiceMap.put('6','Mon enseigne n’est pas proposée / Je n’ai pas de carte de fidélité');
        choiceMap.put('7','Je n’ai pas reçu mon remboursement');
        choiceMap.put('8','Mon achat n’a pas été validé');
        choiceMap.put('9','Le paiement du remboursement a été refusé');
        choiceMap.put('10','Je ne parviens pas à m’inscrire ou à m\'identifier');
        choiceMap.put('11','J’ai perdu mon mot de passe d’identification');
        choiceMap.put('12','Mon navigateur ou mon système d’exploitation ne sont pas compatibles');
        choicemap.put('13','Autres demandes');
        
        }

}
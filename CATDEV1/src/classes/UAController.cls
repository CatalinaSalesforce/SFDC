public with sharing class UAController {

    public String nameFile { get; set; }

    public String tag { get; set; }

    public Blob loyaltyCard { get; set; }
    
    public String messageCSS{get;set;}
    
    public String password { get; set; }

    public String userName { get; set; }
    
    public String[] cardNumbers = new String[]{}; 
    
    public List<String> aliases;
    
    public String message{get;set;}
    
    public UAController(){
       
      messageCSS = 'color:red';
    
    }

    public PageReference Submit() {
        cardNumbers = new String[]{};
        aliases= new List<String>();
        message  = '';
        namefile = loyaltyCard.toString();
        system.debug('file name'+ namefile);
        cardNumbers = namefile.split('\n'); 
         system.debug('cardnumbers '+ cardNumbers );
        UrbanAirshipCallouts ua = new UrbanAirshipCallouts(userName, password); 
        HttpResponse  res = ua.deleteTags(tag);
     
        if(res.getStatusCode()==204){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info,'The tag has been removed.'));
        }
        else if(res.getStatusCode()==401){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'The authorization credentials are incorrect'));
        }else if(res.getStatusCode()==404){
         // messageCSS = 'color:black';
         // ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info,'The tag was not found or has already been removed.'));
         
        }
       
      
      if(cardNumbers !=null){
         if(cardNumbers.size()>0){
         
          for(String s: cardNumbers){
           s = s.trim();
           aliases.add(UrbanAirshipCallouts.gethashedValue(s));
          }
         }
         
      }else{
          
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'The Loyalty card file is Empty'));

      }
      System.debug('aliases size is' + aliases.size());
       String body = '';
       if(aliases !=null){
         if(aliases.size()>0){
          body =  ua.createTagBody(aliases);
         }
       
       }else{
         
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'aliases are null'));

       }
       System.debug('Tag body is ' + body);
      HttpResponse response ; 
      if(body!=''){
      
       response =  ua.createTag(tag,body);
      }else{
       
       ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Create tag body is null '+ body));

      }
      
      if(response !=null){
        if(response.getStatusCode()==200){
          
          message = 'Tag is added successfully ';
        }else if(response.getStatusCode()==401){
        
         
          ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'The authorization credentials are incorrect '));
        }else if(response.getstatusCode()==400){
            
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Bad Request or empty body  ' ));
        
        }
       
      
      }
      PageReference pr =  new PageReference('/apex/Catalinamessaging');
       // pr.setRedirect(true); 
       //  tag = cardNumbers[0];
        return pr ;
    }

  

    
    public String getloyaltycard(){
    
  
     return null;
    
    }
}
/*2012-12-20 - Edit by Anjana - Changed brands to be a single drop down(Brand__c) instead of multi picklist(Brands_List__c).*/
public class AccountCalculations {
    
    
    public static void getBrandRevenue(String x){
        String accId = x;
        Map<Id, Map<String, Account_Brand_Revenue__c>> abrMap = new Map<Id, Map<String, Account_Brand_Revenue__c>>();
        List<Program_Amount__c> amtList = [SELECT QUARTER__C, BOOKED_aMOUNT__C, PROGRAM__R.BRAND__C
            FROM PROGRAM_AMOUNT__C
            WHERE PROGRAM__R.OPPORTUNITY__r.ACCOUNT.PARENTID =: accId];
        List<Account_Brand_Revenue__c> abrList = [SELECT ID, ACCOUNT__C, BRAND__C, CURRENT_YEAR__C,
            YEAR_M_1__C, YEAR_M_2__C, YEAR_M_3__C, YEAR_M_4__C, YEAR_P_1__C
            FROM ACCOUNT_BRAND_REVENUE__C
            WHERE ACCOUNT__C =: accId];
            
        delete abrList;
        
        abrList = new List<Account_Brand_Revenue__c>();
        
        for (Program_Amount__c pa : amtList){
            Account_Brand_Revenue__c abr;
            if (!abrMap.containsKey(x)){
            abrMap.put(x, new Map<String, Account_Brand_Revenue__c>());
            }
            if (abrMap.get(x).containsKey(pa.Program__r.Brand__c)){
                abr = abrMap.get(x).get(pa.Program__r.Brand__c);
            } else {
                Account_Brand_Revenue__c newAbr = new Account_Brand_Revenue__c();
                newAbr.Account__c = x;
                newAbr.Brand__c = pa.Program__r.Brand__c;
                newAbr.CURRENT_YEAR__C = 0;
                newAbr.YEAR_M_1__C = 0;
                newAbr.YEAR_M_2__C = 0;
                newAbr.YEAR_M_3__C = 0;
                newAbr.YEAR_M_4__C = 0;
                newAbr.YEAR_P_1__C = 0;
                abrMap.get(x).put(pa.Program__r.Brand__c, newAbr);
                abrList.add(newAbr);
                abr = newAbr;
            }
            Integer year = Integer.valueOf(pa.Quarter__c.substring(2,pa.Quarter__c.length()));
            Integer cy = Date.today().year();
            if (year == cy - 4){
                abr.Year_M_4__c += pa.Booked_Amount__c;
            } else if (year == cy - 3){
                abr.Year_M_3__c += pa.Booked_Amount__c;
            } else if (year == cy - 2){
                system.debug('***abr: ' + abr);
                system.debug('***abr.Year_2: ' + abr.Year_M_2__c);
                system.debug('***pa.Booked_Amount__c: ' + pa.Booked_Amount__c);
                if (abr.Year_M_2__c == null) abr.Year_M_2__c = 0;
                abr.Year_M_2__c += pa.Booked_Amount__c;
            } else if (year == cy - 1){
                abr.Year_M_1__c += pa.Booked_Amount__c;
            } else if (year == cy){
                abr.Current_Year__c += pa.Booked_Amount__c;
            } else if (year == cy + 1){
                abr.Year_P_1__c += pa.Booked_Amount__c;
            }
        }
        
        insert abrList;
    }

}
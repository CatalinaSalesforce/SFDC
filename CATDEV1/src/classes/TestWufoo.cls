/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
 
@isTest
public class TestWufoo{
    static testMethod void myUnitTest() {
      France_Case_Assignment__c f = new France_Case_Assignment__c();
      f.Name = 'Default';
      f.Owner_Name__c = 'Marc-Antoine Laussu';
      insert f;
      
      String profileID = [Select ID From Profile Where Name =: 'France Case User' Limit 1][0].Id;
      
      User u = new User();
      u.FirstName = 'Marc-Antoine';
      u.LastName = 'Laussu';
      u.Email = 'u@catalinamarketing.com.testuser';
      u.Username = 'u@catalinamarketing.com.testuser';
      u.Alias = 'u';
      u.CommunityNickname = 'u';
      u.TimeZoneSidKey = 'GMT';
      u.LocaleSidKey = 'en_US';
      u.EmailEncodingKey = 'UTF-8';
      u.LanguageLocaleKey = 'en_US';
      u.ProfileId = profileID;
      insert u;
      
      Contact c = new Contact();
      c.FirstName = 'Matt';
      c.LastName = 'Dennis';
      c.Email = 'matt@cloud62.com';
      
      Account a = new Account();
      a.Name = 'Case Account';
      insert a;
      
      List<Wufoo_Map__c> wminsertList = new List<Wufoo_Map__c>();
      
      Wufoo_Map__c wm = new Wufoo_Map__c();
      wm.Name = 'Form2';
      wm.Case_Field_API_Name__c = 'Web_Last_Name__c';
      wm.Wufoo_Field__c = 'Votre nom :';
      wm.Field_Type__c = 'Text';
        wminsertlist.add(wm);
//      insert wm;
      Wufoo_Map__c wm2 = new Wufoo_Map__c();
      wm2.Name = 'Form2';
      wm2.Case_Field_API_Name__c = 'SuppliedEmail';
      wm2.Wufoo_Field__c = 'Votre adresse email :';
      wm2.Field_Type__c = 'Text';
      wminsertlist.add(wm2);
      Wufoo_Map__c wm3 = new Wufoo_Map__c();
      wm3.Name = 'Form2';
      wm3.Case_Field_API_Name__c = 'From_Url__c';
      wm3.Wufoo_Field__c = 'Initial URL';
      wm3.Field_Type__c = 'Text';
      //insert wm3;
      wminsertlist.add(wm3);
      wm3 = new Wufoo_Map__c();
      wm3.Name = 'Form2';
      wm3.Case_Field_API_Name__c = 'User_Agent__c';
      wm3.Wufoo_Field__c = 'user-agent';
      wm3.Field_Type__c = 'Text';
      //insert wm3;
      wminsertlist.add(wm3);
      wm3 = new Wufoo_Map__c();
      wm3.Name = 'Form2';
      wm3.Case_Field_API_Name__c = 'Cookies_Enabled__c';
      wm3.Wufoo_Field__c = 'Cookies';
      wm3.Field_Type__c = 'Checkbox';
      //insert wm3;
      wminsertlist.add(wm3);
      wm3 = new Wufoo_Map__c();
      wm3.Name = 'Form2';
      wm3.Case_Field_API_Name__c = 'ACookies_Enabled__c';
      wm3.Wufoo_Field__c = 'Cookies';
      wm3.Field_Type__c = 'Checkbox';
      //insert wm3;
      wminsertlist.add(wm3);
      wm3 = new Wufoo_Map__c();
      wm3.Name = 'Form2';
      wm3.Case_Field_API_Name__c = 'Problem_with__c';
      wm3.Wufoo_Field__c = 'le site C-Wallet';
      wm3.Field_Type__c = 'Checkbox';
      //insert wm3;
      wminsertlist.add(wm3);
      wm3 = new Wufoo_Map__c();
      wm3.Name = 'Form2';
      wm3.Case_Field_API_Name__c = 'Problem_with__c';
      wm3.Wufoo_Field__c = 'l’application mobile iPhone C-Wallet';
      wm3.Field_Type__c = 'Checkbox';
      //insert wm3;
      wminsertlist.add(wm3);
      
      
      insert wminsertlist;
     
      
      
      Wufoo w = new Wufoo();
      
      String wufoourl = '/apex/WufooTest';
      
      //----//
      
      wufoourl +='/apex/WufooPost?CreatedBy=public&DateCreated=2012-11-01+14%3A37%3A09&EntryId=66&Field1=Matt&Field136=9&Field138=Chrome+22&Field139=Windows&Field141=&Field17=Mozilla%2F5.0+%28Windows+NT+6.1%3B+WOW64%29+AppleWebKit%2F537.4+%28KHTML%2C+like+Gecko%29+Chrome%2F22.0.1229.94+Safari%2F537.4&Field18=couponnetwork.fr&Field19=107.9.206.159&Field2=Dennis&Field20=true&Field22=matt%40cloud62.com&Field24=1234&Field26=High&Field28=akjaskjd&Field29=sdlakjd&Field30=sldakjd&Field31=sdalkjsd&Field33=Sahara+Occidental&Field35=le+site+C-Wallet&Field36=&Field37=&Field6=error&Field8=E.Leclerc&Field9=sdlak&FieldStructure=%7B%22Fields%22%3A%5B%7B%22Title%22%3A%22subject%22%2C%22Instructions%22%3A%22%22%2C%22IsRequired%22%3A%220%22%2C%22ClassNames%22%3A%22hide%22%2C%22DefaultVal%22%3A%22%22%2C%22Page%22%3A%221%22%2C%22Type%22%3A%22text%22%2C%22ID%22%3A%22Field141%22%7D%2C%7B%22Title%22%3A%22Votre+pr%5Cu00e9nom+%3A%22%2C%22Instructions%22%3A%22%22%2C%22IsRequired%22%3A%221%22%2C%22ClassNames%22%3A%22%22%2C%22DefaultVal%22%3A%22%22%2C%22Page%22%3A%221%22%2C%22Type%22%3A%22text%22%2C%22ID%22%3A%22Field1%22%7D%2C%7B%22Title%22%3A%22Votre+nom+%3A%22%2C%22Instructions%22%3A%22%22%2C%22IsRequired%22%3A%221%22%2C%22ClassNames%22%3A%22%22%2C%22DefaultVal%22%3A%22%22%2C%22Page%22%3A%221%22%2C%22Type%22%3A%22text%22%2C%22ID%22%3A%22Field2%22%7D%2C%7B%22Title%22%3A%22Votre+adresse+email+%3A%22%2C%22Instructions%22%3A%22%22%2C%22IsRequired%22%3A%221%22%2C%22ClassNames%22%3A%22%22%2C%22DefaultVal%22%3A%22%22%2C%22Page%22%3A%221%22%2C%22Type%22%3A%22email%22%2C%22ID%22%3A%22Field22%22%7D%2C%7B%22Title%22%3A%22Vous+rencontrez+un+probl%5Cu00e8me+sur%5Cu00a0%3A%22%2C%22Instructions%22%3A%22%22%2C%22IsRequired%22%3A%220%22%2C%22ClassNames%22%3A%22%22%2C%22DefaultVal%22%3A%220%22%2C%22Page%22%3A%221%22%2C%22SubFields%22%3A%5B%7B%22DefaultVal%22%3A%220%22%2C%22ID%22%3A%22Field35%22%2C%22Label%22%3A%22le+site+C-Wallet%22%7D%2C%7B%22DefaultVal%22%3A%220%22%2C%22ID%22%3A%22Field36%22%2C%22Label%22%3A%22l%5Cu2019application+mobile+iPhone+C-Wallet%22%7D%2C%7B%22DefaultVal%22%3A%220%22%2C%22ID%22%3A%22Field37%22%2C%22Label%22%3A%22l%5Cu2019application+mobile+Android+C-Wallet%22%7D%5D%2C%22Type%22%3A%22checkbox%22%2C%22ID%22%3A%22Field35%22%7D%2C%7B%22Title%22%3A%22Priority%22%2C%22Instructions%22%3A%22%22%2C%22IsRequired%22%3A%220%22%2C%22ClassNames%22%3A%22hide%22%2C%22DefaultVal%22%3A%22%22%2C%22Page%22%3A%221%22%2C%22Type%22%3A%22text%22%2C%22ID%22%3A%22Field26%22%7D%2C%7B%22Title%22%3A%22osversion%22%2C%22Instructions%22%3A%22%22%2C%22IsRequired%22%3A%220%22%2C%22ClassNames%22%3A%22hide%22%2C%22DefaultVal%22%3A%22%22%2C%22Page%22%3A%221%22%2C%22Type%22%3A%22text%22%2C%22ID%22%3A%22Field139%22%7D%2C%7B%22Title%22%3A%22browser%22%2C%22Instructions%22%3A%22%22%2C%22IsRequired%22%3A%220%22%2C%22ClassNames%22%3A%22hide%22%2C%22DefaultVal%22%3A%22%22%2C%22Page%22%3A%221%22%2C%22Type%22%3A%22text%22%2C%22ID%22%3A%22Field138%22%7D%2C%7B%22Title%22%3A%22initial%22%2C%22Instructions%22%3A%22%22%2C%22IsRequired%22%3A%220%22%2C%22ClassNames%22%3A%22hide%22%2C%22DefaultVal%22%3A%22%22%2C%22Page%22%3A%221%22%2C%22Type%22%3A%22text%22%2C%22ID%22%3A%22Field136%22%7D%2C%7B%22Title%22%3A%22userid%22%2C%22Instructions%22%3A%22%22%2C%22IsRequired%22%3A%220%22%2C%22ClassNames%22%3A%22hide%22%2C%22DefaultVal%22%3A%22%22%2C%22Page%22%3A%221%22%2C%22Type%22%3A%22text%22%2C%22ID%22%3A%22Field24%22%7D%2C%7B%22Title%22%3A%22user-agent%22%2C%22Instructions%22%3A%22%22%2C%22IsRequired%22%3A%220%22%2C%22ClassNames%22%3A%22hide%22%2C%22DefaultVal%22%3A%22%22%2C%22Page%22%3A%221%22%2C%22Type%22%3A%22text%22%2C%22ID%22%3A%22Field17%22%7D%2C%7B%22Title%22%3A%22IP+Address%22%2C%22Instructions%22%3A%22%22%2C%22IsRequired%22%3A%220%22%2C%22ClassNames%22%3A%22hide%22%2C%22DefaultVal%22%3A%22%22%2C%22Page%22%3A%221%22%2C%22Type%22%3A%22text%22%2C%22ID%22%3A%22Field19%22%7D%2C%7B%22Title%22%3A%22Initial+URL%22%2C%22Instructions%22%3A%22%22%2C%22IsRequired%22%3A%220%22%2C%22ClassNames%22%3A%22hide%22%2C%22DefaultVal%22%3A%22%22%2C%22Page%22%3A%221%22%2C%22Type%22%3A%22text%22%2C%22ID%22%3A%22Field18%22%7D%2C%7B%22Title%22%3A%22Cookies%22%2C%22Instructions%22%3A%22%22%2C%22IsRequired%22%3A%220%22%2C%22ClassNames%22%3A%22hide%22%2C%22DefaultVal%22%3A%22%22%2C%22Page%22%3A%221%22%2C%22Type%22%3A%22text%22%2C%22ID%22%3A%22Field20%22%7D%2C%7B%22Title%22%3A%22Indiquez-nous+l%5Cu2019offre+concern%5Cu00e9e+ou+la+page+que+vous+consultez+%3A%22%2C%22Instructions%22%3A%22%22%2C%22IsRequired%22%3A%220%22%2C%22ClassNames%22%3A%22%22%2C%22DefaultVal%22%3A%22%22%2C%22Page%22%3A%221%22%2C%22Type%22%3A%22text%22%2C%22ID%22%3A%22Field6%22%7D%2C%7B%22Title%22%3A%22S%5Cu00e9lectionnez+dans+la+liste+le+nom+du+magasin+dans+lequel+vous+avez+effectu%5Cu00e9+vos+achats+%3A%22%2C%22Instructions%22%3A%22%22%2C%22IsRequired%22%3A%220%22%2C%22ClassNames%22%3A%22%22%2C%22DefaultVal%22%3A%22%22%2C%22Page%22%3A%221%22%2C%22Choices%22%3A%5B%7B%22Label%22%3A%22%22%7D%2C%7B%22Label%22%3A%228+%5Cu00e0+Huit%22%7D%2C%7B%22Label%22%3A%22Aldi%22%7D%2C%7B%22Label%22%3A%22Atac%22%7D%2C%7B%22Label%22%3A%22Auchan%22%7D%2C%7B%22Label%22%3A%22Carrefour%22%7D%2C%7B%22Label%22%3A%22Carrefour+city%22%7D%2C%7B%22Label%22%3A%22Carrefour+contact%22%7D%2C%7B%22Label%22%3A%22Carrefour+express%22%7D%2C%7B%22Label%22%3A%22Carrefour+market%22%7D%2C%7B%22Label%22%3A%22Carrefour+montagne%22%7D%2C%7B%22Label%22%3A%22Carrefour+planet%22%7D%2C%7B%22Label%22%3A%22Casino%22%7D%2C%7B%22Label%22%3A%22Champion%22%7D%2C%7B%22Label%22%3A%22Cora%22%7D%2C%7B%22Label%22%3A%22Dia%22%7D%2C%7B%22Label%22%3A%22E.Leclerc%22%7D%2C%7B%22Label%22%3A%22Franprix%22%7D%2C%7B%22Label%22%3A%22G20%22%7D%2C%7B%22Label%22%3A%22G%5Cu00e9ant+Casino%22%7D%2C%7B%22Label%22%3A%22Hyper+U%22%7D%2C%7B%22Label%22%3A%22Intermarch%5Cu00e9%22%7D%2C%7B%22Label%22%3A%22Leader+Price%22%7D%2C%7B%22Label%22%3A%22Lidl%22%7D%2C%7B%22Label%22%3A%22March%5Cu00e9+Plus%22%7D%2C%7B%22Label%22%3A%22Match%22%7D%2C%7B%22Label%22%3A%22Monoprix%22%7D%2C%7B%22Label%22%3A%22Proxi%22%7D%2C%7B%22Label%22%3A%22Shopi%22%7D%2C%7B%22Label%22%3A%22Simply+Market%22%7D%2C%7B%22Label%22%3A%22Spar%22%7D%2C%7B%22Label%22%3A%22Super+U%22%7D%2C%7B%22Label%22%3A%22Autres%22%7D%5D%2C%22Type%22%3A%22select%22%2C%22ID%22%3A%22Field8%22%2C%22HasOtherField%22%3Afalse%7D%2C%7B%22Title%22%3A%22Adresse+%3A%22%2C%22Instructions%22%3A%22%22%2C%22IsRequired%22%3A%220%22%2C%22ClassNames%22%3A%22%22%2C%22DefaultVal%22%3A%22%22%2C%22Page%22%3A%221%22%2C%22Type%22%3A%22text%22%2C%22ID%22%3A%22Field28%22%7D%2C%7B%22Title%22%3A%22Compl%5Cu00e9ment+Adresse+%3A%22%2C%22Instructions%22%3A%22%22%2C%22IsRequired%22%3A%220%22%2C%22ClassNames%22%3A%22%22%2C%22DefaultVal%22%3A%22%22%2C%22Page%22%3A%221%22%2C%22Type%22%3A%22text%22%2C%22ID%22%3A%22Field29%22%7D%2C%7B%22Title%22%3A%22Code+postal+%3A%22%2C%22Instructions%22%3A%22%22%2C%22IsRequired%22%3A%220%22%2C%22ClassNames%22%3A%22leftHalf%22%2C%22DefaultVal%22%3A%22%22%2C%22Page%22%3A%221%22%2C%22Type%22%3A%22text%22%2C%22ID%22%3A%22Field30%22%7D%2C%7B%22Title%22%3A%22Ville+%3A%22%2C%22Instructions%22%3A%22%22%2C%22IsRequired%22%3A%220%22%2C%22ClassNames%22%3A%22rightHalf%22%2C%22DefaultVal%22%3A%22%22%2C%22Page%22%3A%221%22%2C%22Type%22%3A%22text%22%2C%22ID%22%3A%22Field31%22%7D%2C%7B%22Title%22%3A%22Pays+%3A%22%2C%22Instructions%22%3A%22%22%2C%22IsRequired%22%3A%220%22%2C%22ClassNames%22%3A%22%22%2C%22DefaultVal%22%3A%22%22%2C%22Page%22%3A%221%22%2C%22Choices%22%3A%5B%7B%22Label%22%3A%22France%22%7D%2C%7B%22Label%22%3A%22Afghanistan%22%7D%2C%7B%22Label%22%3A%22Afrique+Centrale%22%7D%2C%7B%22Label%22%3A%22Afrique+du+Sud%22%7D%2C%7B%22Label%22%3A%22Albanie%22%7D%2C%7B%22Label%22%3A%22Algerie%22%7D%2C%7B%22Label%22%3A%22Allemagne%22%7D%2C%7B%22Label%22%3A%22Andorre%22%7D%2C%7B%22Label%22%3A%22Angola%22%7D%2C%7B%22Label%22%3A%22Anguilla%22%7D%2C%7B%22Label%22%3A%22Arabie+Saoudite%22%7D%2C%7B%22Label%22%3A%22Argentine%22%7D%2C%7B%22Label%22%3A%22Armenie%22%7D%2C%7B%22Label%22%3A%22Australie%22%7D%2C%7B%22Label%22%3A%22Autriche%22%7D%2C%7B%22Label%22%3A%22Azerbaidjan%22%7D%2C%7B%22Label%22%3A%22Bahamas%22%7D%2C%7B%22Label%22%3A%22Bangladesh%22%7D%2C%7B%22Label%22%3A%22Barbade%22%7D%2C%7B%22Label%22%3A%22Bahrein%22%7D%2C%7B%22Label%22%3A%22Belgique%22%7D%2C%7B%22Label%22%3A%22Belize%22%7D%2C%7B%22Label%22%3A%22Benin%22%7D%2C%7B%22Label%22%3A%22Bermudes%22%7D%2C%7B%22Label%22%3A%22Bielorussie%22%7D%2C%7B%22Label%22%3A%22Bolivie%22%7D%2C%7B%22Label%22%3A%22Botswana%22%7D%2C%7B%22Label%22%3A%22Bhoutan%22%7D%2C%7B%22Label%22%3A%22Boznie+Herzegovine%22%7D%2C%7B%22Label%22%3A%22Bresil%22%7D%2C%7B%22Label%22%3A%22Brunei%22%7D%2C%7B%22Label%22%3A%22Bulgarie%22%7D%2C%7B%22Label%22%3A%22Burkina+Faso%22%7D%2C%7B%22Label%22%3A%22Burundi%22%7D%2C%7B%22Label%22%3A%22Caiman%22%7D%2C%7B%22Label%22%3A%22Cambodge%22%7D%2C%7B%22Label%22%3A%22Cameroun%22%7D%2C%7B%22Label%22%3A%22Canada%22%7D%2C%7B%22Label%22%3A%22Canaries%22%7D%2C%7B%22Label%22%3A%22Cap+Vert%22%7D%2C%7B%22Label%22%3A%22Chili%22%7D%2C%7B%22Label%22%3A%22Chine%22%7D%2C%7B%22Label%22%3A%22Chypre%22%7D%2C%7B%22Label%22%3A%22Colombie%22%7D%2C%7B%22Label%22%3A%22Colombie%22%7D%2C%7B%22Label%22%3A%22Congo%22%7D%2C%7B%22Label%22%3A%22Congo+democratique%22%7D%2C%7B%22Label%22%3A%22Cook%22%7D%2C%7B%22Label%22%3A%22Coree+du+Nord%22%7D%2C%7B%22Label%22%3A%22Coree+du+Sud%22%7D%2C%7B%22Label%22%3A%22Costa+Rica%22%7D%2C%7B%22Label%22%3A%22C%5Cu00f4te+d+Ivoire%22%7D%2C%7B%22Label%22%3A%22Croatie%22%7D%2C%7B%22Label%22%3A%22Cuba%22%7D%2C%7B%22Label%22%3A%22Danemark%22%7D%2C%7B%22Label%22%3A%22Djibouti%22%7D%2C%7B%22Label%22%3A%22Dominique%22%7D%2C%7B%22Label%22%3A%22Egypte%22%7D%2C%7B%22Label%22%3A%22Emirats+Arabes+Unis%22%7D%2C%7B%22Label%22%3A%22Equateur%22%7D%2C%7B%22Label%22%3A%22Erythree%22%7D%2C%7B%22Label%22%3A%22Espagne%22%7D%2C%7B%22Label%22%3A%22Estonie%22%7D%2C%7B%22Label%22%3A%22Etats+Unis%22%7D%2C%7B%22Label%22%3A%22Ethiopie%22%7D%2C%7B%22Label%22%3A%22Falkland%22%7D%2C%7B%22Label%22%3A%22Feroe%22%7D%2C%7B%22Label%22%3A%22Fidji%22%7D%2C%7B%22Label%22%3A%22Finlande%22%7D%2C%7B%22Label%22%3A%22France%22%7D%2C%7B%22Label%22%3A%22Gabon%22%7D%2C%7B%22Label%22%3A%22Gambie%22%7D%2C%7B%22Label%22%3A%22Georgie%22%7D%2C%7B%22Label%22%3A%22Ghana%22%7D%2C%7B%22Label%22%3A%22Gibraltar%22%7D%2C%7B%22Label%22%3A%22Grece%22%7D%2C%7B%22Label%22%3A%22Grenade%22%7D%2C%7B%22Label%22%3A%22Groenland%22%7D%2C%7B%22Label%22%3A%22Guadeloupe%22%7D%2C%7B%22Label%22%3A%22Guam%22%7D%2C%7B%22Label%22%3A%22Guatemala%22%7D%2C%7B%22Label%22%3A%22Guernesey%22%7D%2C%7B%22Label%22%3A%22Guinee%22%7D%2C%7B%22Label%22%3A%22Guinee+Bissau%22%7D%2C%7B%22Label%22%3A%22Guinee+Equatoriale%22%7D%2C%7B%22Label%22%3A%22Guyana%22%7D%2C%7B%22Label%22%3A%22Guyane+Francaise%22%7D%2C%7B%22Label%22%3A%22Haiti%22%7D%2C%7B%22Label%22%3A%22Hawaii%22%7D%2C%7B%22Label%22%3A%22Honduras%22%7D%2C%7B%22Label%22%3A%22Hong+Kong%22%7D%2C%7B%22Label%22%3A%22Hongrie%22%7D%2C%7B%22Label%22%3A%22Inde%22%7D%2C%7B%22Label%22%3A%22Indonesie%22%7D%2C%7B%22Label%22%3A%22Iran%22%7D%2C%7B%22Label%22%3A%22Iraq%22%7D%2C%7B%22Label%22%3A%22Irlande%22%7D%2C%7B%22Label%22%3A%22Islande%22%7D%2C%7B%22Label%22%3A%22Israel%22%7D%2C%7B%22Label%22%3A%22italie%22%7D%2C%7B%22Label%22%3A%22Jamaique%22%7D%2C%7B%22Label%22%3A%22Jan+Mayen%22%7D%2C%7B%22Label%22%3A%22Japon%22%7D%2C%7B%22Label%22%3A%22Jersey%22%7D%2C%7B%22Label%22%3A%22Jordanie%22%7D%2C%7B%22Label%22%3A%22Kazakhstan%22%7D%2C%7B%22Label%22%3A%22Kenya%22%7D%2C%7B%22Label%22%3A%22Kirghizistan%22%7D%2C%7B%22Label%22%3A%22Kiribati%22%7D%2C%7B%22Label%22%3A%22Koweit%22%7D%2C%7B%22Label%22%3A%22Laos%22%7D%2C%7B%22Label%22%3A%22Lesotho%22%7D%2C%7B%22Label%22%3A%22Lettonie%22%7D%2C%7B%22Label%22%3A%22Liban%22%7D%2C%7B%22Label%22%3A%22Liberia%22%7D%2C%7B%22Label%22%3A%22Liechtenstein%22%7D%2C%7B%22Label%22%3A%22Lituanie%22%7D%2C%7B%22Label%22%3A%22Luxembourg%22%7D%2C%7B%22Label%22%3A%22Lybie%22%7D%2C%7B%22Label%22%3A%22Macao%22%7D%2C%7B%22Label%22%3A%22Macedoine%22%7D%2C%7B%22Label%22%3A%22Madagascar%22%7D%2C%7B%22Label%22%3A%22Mad%5Cu00e8re%22%7D%2C%7B%22Label%22%3A%22Malaisie%22%7D%2C%7B%22Label%22%3A%22Malawi%22%7D%2C%7B%22Label%22%3A%22Maldives%22%7D%2C%7B%22Label%22%3A%22Mali%22%7D%2C%7B%22Label%22%3A%22Malte%22%7D%2C%7B%22Label%22%3A%22Man%22%7D%2C%7B%22Label%22%3A%22Mariannes+du+Nord%22%7D%2C%7B%22Label%22%3A%22Maroc%22%7D%2C%7B%22Label%22%3A%22Marshall%22%7D%2C%7B%22Label%22%3A%22Martinique%22%7D%2C%7B%22Label%22%3A%22Maurice%22%7D%2C%7B%22Label%22%3A%22Mauritanie%22%7D%2C%7B%22Label%22%3A%22Mayotte%22%7D%2C%7B%22Label%22%3A%22Mexique%22%7D%2C%7B%22Label%22%3A%22Micronesie%22%7D%2C%7B%22Label%22%3A%22Midway%22%7D%2C%7B%22Label%22%3A%22Moldavie%22%7D%2C%7B%22Label%22%3A%22Monaco%22%7D%2C%7B%22Label%22%3A%22Mongolie%22%7D%2C%7B%22Label%22%3A%22Montserrat%22%7D%2C%7B%22Label%22%3A%22Mozambique%22%7D%2C%7B%22Label%22%3A%22Namibie%22%7D%2C%7B%22Label%22%3A%22Nauru%22%7D%2C%7B%22Label%22%3A%22Nepal%22%7D%2C%7B%22Label%22%3A%22Nicaragua%22%7D%2C%7B%22Label%22%3A%22Niger%22%7D%2C%7B%22Label%22%3A%22Nigeria%22%7D%2C%7B%22Label%22%3A%22Niue%22%7D%2C%7B%22Label%22%3A%22Norfolk%22%7D%2C%7B%22Label%22%3A%22Norvege%22%7D%2C%7B%22Label%22%3A%22Nouvelle+Caledonie%22%7D%2C%7B%22Label%22%3A%22Nouvelle+Zelande%22%7D%2C%7B%22Label%22%3A%22Oman%22%7D%2C%7B%22Label%22%3A%22Ouganda%22%7D%2C%7B%22Label%22%3A%22Ouzbekistan%22%7D%2C%7B%22Label%22%3A%22Pakistan%22%7D%2C%7B%22Label%22%3A%22Palau%22%7D%2C%7B%22Label%22%3A%22Palestine%22%7D%2C%7B%22Label%22%3A%22Panama%22%7D%2C%7B%22Label%22%3A%22Papouasie+Nouvelle+Guinee%22%7D%2C%7B%22Label%22%3A%22Paraguay%22%7D%2C%7B%22Label%22%3A%22Pays+Bas%22%7D%2C%7B%22Label%22%3A%22Perou%22%7D%2C%7B%22Label%22%3A%22Philippines%22%7D%2C%7B%22Label%22%3A%22Pologne%22%7D%2C%7B%22Label%22%3A%22Polynesie%22%7D%2C%7B%22Label%22%3A%22Porto+Rico%22%7D%2C%7B%22Label%22%3A%22Portugal%22%7D%2C%7B%22Label%22%3A%22Qatar%22%7D%2C%7B%22Label%22%3A%22Republique+Dominicaine%22%7D%2C%7B%22Label%22%3A%22Republique+Tcheque%22%7D%2C%7B%22Label%22%3A%22Reunion%22%7D%2C%7B%22Label%22%3A%22Roumanie%22%7D%2C%7B%22Label%22%3A%22Royaume+Uni%22%7D%2C%7B%22Label%22%3A%22Russie%22%7D%2C%7B%22Label%22%3A%22Rwanda%22%7D%2C%7B%22Label%22%3A%22Sahara+Occidental%22%7D%2C%7B%22Label%22%3A%22Sainte+Lucie%22%7D%2C%7B%22Label%22%3A%22Saint+Marin%22%7D%2C%7B%22Label%22%3A%22Salomon%22%7D%2C%7B%22Label%22%3A%22Salvador%22%7D%2C%7B%22Label%22%3A%22Samoa+Occidentales%22%7D%2C%7B%22Label%22%3A%22Samoa+Americaine%22%7D%2C%7B%22Label%22%3A%22Sao+Tome+et+Principe%22%7D%2C%7B%22Label%22%3A%22Senegal%22%7D%2C%7B%22Label%22%3A%22Seychelles%22%7D%2C%7B%22Label%22%3A%22Sierra+Leone%22%7D%2C%7B%22Label%22%3A%22Singapour%22%7D%2C%7B%22Label%22%3A%22Slovaquie%22%7D%2C%7B%22Label%22%3A%22Slovenie%22%7D%2C%7B%22Label%22%3A%22Somalie%22%7D%2C%7B%22Label%22%3A%22Soudan%22%7D%2C%7B%22Label%22%3A%22Sri+Lanka%22%7D%2C%7B%22Label%22%3A%22Suede%22%7D%2C%7B%22Label%22%3A%22Suisse%22%7D%2C%7B%22Label%22%3A%22Surinam%22%7D%2C%7B%22Label%22%3A%22Swaziland%22%7D%2C%7B%22Label%22%3A%22Syrie%22%7D%2C%7B%22Label%22%3A%22Tadjikistan%22%7D%2C%7B%22Label%22%3A%22Taiwan%22%7D%2C%7B%22Label%22%3A%22Tonga%22%7D%2C%7B%22Label%22%3A%22Tanzanie%22%7D%2C%7B%22Label%22%3A%22Tchad%22%7D%2C%7B%22Label%22%3A%22Thailande%22%7D%2C%7B%22Label%22%3A%22Tibet%22%7D%2C%7B%22Label%22%3A%22Timor+Oriental%22%7D%2C%7B%22Label%22%3A%22Togo%22%7D%2C%7B%22Label%22%3A%22Trinite+et+Tobago%22%7D%2C%7B%22Label%22%3A%22Tristan+de+cuncha%22%7D%2C%7B%22Label%22%3A%22Tunisie%22%7D%2C%7B%22Label%22%3A%22Turmenistan%22%7D%2C%7B%22Label%22%3A%22Turquie%22%7D%2C%7B%22Label%22%3A%22Ukraine%22%7D%2C%7B%22Label%22%3A%22Uruguay%22%7D%2C%7B%22Label%22%3A%22Vanuatu%22%7D%2C%7B%22Label%22%3A%22Vatican%22%7D%2C%7B%22Label%22%3A%22Venezuela%22%7D%2C%7B%22Label%22%3A%22Vierges+Americaines%22%7D%2C%7B%22Label%22%3A%22Vierges+Britanniques%22%7D%2C%7B%22Label%22%3A%22Vietnam%22%7D%2C%7B%22Label%22%3A%22Wake%22%7D%2C%7B%22Label%22%3A%22Wallis+et+Futuma%22%7D%2C%7B%22Label%22%3A%22Yemen%22%7D%2C%7B%22Label%22%3A%22Yougoslavie%22%7D%2C%7B%22Label%22%3A%22Zambie%22%7D%2C%7B%22Label%22%3A%22Zimbabwe%22%7D%5D%2C%22Type%22%3A%22select%22%2C%22ID%22%3A%22Field33%22%2C%22HasOtherField%22%3Afalse%7D%2C%7B%22Title%22%3A%22D%5Cu00e9crivez-nous+en+d%5Cu00e9tails+le%28s%29+probl%5Cu00e8me%28s%29+que+vous+rencontrez+%28%5Cu00e9tapes+r%5Cu00e9alis%5Cu00e9es+sur+le+site%2C+messages+d%5Cu2019erreur%2C+type+d%5Cu2019imprimante...%29+%3A%22%2C%22Instructions%22%3A%22%22%2C%22IsRequired%22%3A%221%22%2C%22ClassNames%22%3A%22%22%2C%22DefaultVal%22%3A%22%22%2C%22Page%22%3A%221%22%2C%22Type%22%3A%22textarea%22%2C%22ID%22%3A%22Field9%22%7D%5D%7D&FormStructure=%7B%22Name%22%3A%22Form+2%22%2C%22Description%22%3Anull%2C%22RedirectMessage%22%3A%22Votre+demande+a+bien+%5Cu00e9t%5Cu00e9+envoy%5Cu00e9e+%5Cu00e0+nos+%5Cu00e9quipes+et+sera+trait%5Cu00e9e+dans+les+meilleurs+d%5Cu00e9lais.%22%2C%22Url%22%3A%22form-2%22%2C%22Email%22%3Anull%2C%22IsPublic%22%3A%221%22%2C%22Language%22%3A%22french%22%2C%22StartDate%22%3A%222000-01-01+12%3A00%3A00%22%2C%22EndDate%22%3A%222030-01-01+12%3A00%3A00%22%2C%22EntryLimit%22%3A%220%22%2C%22DateCreated%22%3A%222012-10-05+13%3A36%3A28%22%2C%22DateUpdated%22%3A%222012-10-22+21%3A20%3A23%22%2C%22Hash%22%3A%22m7x3q1%22%7D&HandshakeKey=Form2&IP=107.9.206.159';
      PageReference p = new PageReference(wufoourl);
      p.getParameters().put('website','cwallet');
      
      
      Test.setCurrentPage(p);
      
      w.run();
      w.getipaddress();
      w.getuseragent();
      w.getparenttosave();
      w.getuserid();
      
      /*w.selected = '1';
      w.showIframe();
      w.selected = '6';
      w.showIframe();
      w.selected = '11';
      w.showIframe();
      */
      for(Integer i = 1; i < 13; i ++){
          w.selected = i.format();
          w.showIframe();
          w.getPriority();
      }
    //  w.saveParent();

    }
  
}
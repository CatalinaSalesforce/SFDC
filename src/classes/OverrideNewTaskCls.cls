/*
@Name           : OverrideNewTaskCls
@Author         : customersuccess@cloud62.com
@Date           : 02/01/2013
@Description    : Controller for skipping recordtype selection screen for tasks
@Revision History
*/
public class OverrideNewTaskCls{
    /*
    @Name :ProductTrackerCls
    @Description :Standard controller constructor used by vf pages
    */
    public OverrideNewTaskCls(ApexPages.StandardController controller){
    }   
    
    /*
    @Name    createNoRT
    @Description    skips the recordtype select screen while maintaining all params
    */
    public PageReference createNoRT(){
        PageReference pgReturn = new PageReference('/00T/e');
        //add all the current url parameters to the return page to preserve all data
        for(String param : ApexPages.currentPage().getParameters().keySet()){
            //some params need to be removed
            if(param != 'save_new'){
                pgReturn.getParameters().put(param,ApexPages.currentPage().getParameters().get(param));
            }
        }
        pgReturn.getParameters().put('nooverride','0');
        return pgReturn;
    }
}
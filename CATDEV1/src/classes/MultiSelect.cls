/*
@Name            : MultiSelect
@Author          : customersuccess@cloud62.com
@Date            : May 9, 2012
@Description     : Class to support custom Multi Select picklists
*/
public class MultiSelect{

    public List<string> leftselected{get;set;}
    public List<string> rightselected{get;set;}
    public Set<string> leftvalues = new Set<string>();
    public Set<string> rightvalues = new Set<string>();
    
    public multiselect(Set<String> unselectedValues, Set<String> selectedValues){
        leftselected = new List<String>();
        rightselected = new List<String>();
        leftvalues = unselectedValues;
        rightvalues = selectedValues;
    }
    
    public void selectclick(){
        rightselected.clear();
        for(String s : leftselected){
            leftvalues.remove(s);
            rightvalues.add(s);
        }
    }
    
    public void unselectclick(){
        leftselected.clear();
        for(String s : rightselected){
            rightvalues.remove(s);
            leftvalues.add(s);
        }
    }

    public List<SelectOption> getUnSelectedValues(){
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(leftvalues);
        tempList.sort();
        for(string s : tempList)
            options.add(new SelectOption(s,s));
        return options;
    }

    public List<SelectOption> getSelectedValues(){
        List<SelectOption> options1 = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(rightvalues);
        tempList.sort();
        for(String s : tempList)
            options1.add(new SelectOption(s,s));
        return options1;
    }
}
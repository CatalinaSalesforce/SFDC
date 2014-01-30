public class HM_TreeController{

  static testMethod void testClass () {
        HM_TreeController h = new HM_TreeController();
        System.debug(h.jSonString );
  }

    public static integer iCount = 0;
    public String         jSonString { get; set; }  
    Map<id,TreeNode>      RoleIdMap;
    Map<id,List<User>>    RoleUserMap;


    public class TreeNode{
        string            nodeName;
        Id                nodeId;
        Id                parentNodeId;
        integer           iPosition = 0;
        List<TreeNode>    childList {get; set;}  
        
        TreeNode(Id id, string name, Id pId){
            nodeId = id;
            nodeName = name;
            parentNodeId = pId;
            childList = new List<TreeNode>();
        }      
        
        void AddChildNode(TreeNode node){
            childList.add(node);
        }
        
        TreeNode getNextChild(){
            TreeNode retNode;
            
            if(iPosition >= childList.size())
                retNode = null;
            else{
                retNode = childList[iPosition];
                iPosition++;
                }
            return retNode;
        }
        
        boolean wasFirstChild(){
            if(iPosition == 1)
                return true;
            else
                return false;
        }
        
        boolean wasLastChild(){
            if(iPosition == childList.size())
                return true;
            else
                return false;
        }
        
        boolean hasMoreChildren(){
            if((iPosition - 1) < childList.size())
                return true;
            else
                return false;
        }
    }
    
    
    TreeNode getNextNode(TreeNode theNode){
    
        if((theNode.parentNodeId == NULL) || (RoleIdMap.get(theNode.parentNodeId).wasFirstChild()))
                jSonString += '[';
        else if(RoleIdMap.get(theNode.parentNodeId).hasMoreChildren())
                jSonString += ',';
 
   
 //       jSonString += '{"data":' + '"' + theNode.nodeName + '"';
        jSonString += '{"data" : { "attr" : {"id" : "'+theNode.nodeId+'"}, "title" : "' + theNode.nodeName ;
        TreeNode nextNode = theNode.getNextChild();

        if(nextNode != NULL && theNode.wasFirstChild())
            jSonString += '"}';
        else 
            jSonString += '", "icon" : "http://www.jstree.com/static/v.1.0pre/_demo/file.png"}';
        

        
        if(nextNode != NULL && theNode.wasFirstChild())
            jSonString += ',"children":';
            
        while(nextNode == null){
            jSonString += '}';
            
            if((theNode.parentNodeId == NULL) || (RoleIdMap.get(theNode.parentNodeId).wasLastChild()))
                jSonString += ']';
                
            theNode = RoleIdMap.get(theNode.parentNodeId);            
            if(theNode == NULL)
                return null;                
            nextNode = theNode.getNextChild();
        }        
        return nextNode;
    }
    
    public HM_TreeController(){ 
    
        TreeNode nextNode;
        
        jSonString = '{"data":';
        RoleIdMap  = new Map<id,TreeNode>();  
        RoleUserMap  = new Map<id,List<User>>();  
        
        List<UserRole>  urList = [Select id,Name,ParentRoleId from UserRole];           
        for(UserRole ur:urList){                    
            /*if(ur.Id == '00EZ0000000LvgO'){ // Set Parent to NULL to start tree from a certain point               
                ur.ParentRoleId = NULL;    
            }    
            
            if(ur.Id == '00EF0000000P49y'){ // Set Parent to NULL to start tree from a certain point
                ur.ParentRoleId = '00EZ000000000kO';    
            }  */ 
            
            if((ur.Id == '00EF0000000OevC') || (ur.Id == '00EF0000000P49y') || (ur.Id == '00EF0000000Nh9b') || (ur.Id == '00EA0000000UVqO') || 
               (ur.Id == '00EF0000000P3iE') || (ur.Id == '00EF0000000P3m1') || (ur.Id == '00EF0000000P3lr') || (ur.Id == '00EF0000000OhE7') || (ur.Id == '00EF0000000P3lm') ||
               (ur.Id == '00EF0000000P3lw') || (ur.Id == '00EA0000000ZRun') || (ur.Id == '00EA0000000UVqJ') || (ur.id == '00EA0000000UVqE') || (ur.Id == '00EZ0000000LvgO'))
                continue;  
            
            TreeNode node = new TreeNode(ur.Id,ur.Name,ur.ParentRoleId);             
            RoleIdMap.put(ur.Id,node);            
        }
        
        List<User>  allUsersList = [Select id,Name,UserRoleId from User];           
        for(User user:allUsersList){                    
            List<User> roleUsers = RoleUserMap.get(user.UserRoleId);
            if(roleUsers == NULL)
                roleUsers = new List<User>();
                
            roleUsers.add(user);
            //System.debug('Role Id and name is - ' + user.UserRoleId + ' - ' + user.Name);                       
            RoleUserMap.put(user.UserRoleId,roleUsers);            
        }

        for(TreeNode chNode: RoleIdMap.values()) {     
            if(chNode.parentNodeId == NULL) 
                nextNode = chNode; 
            
            TreeNode parentNode = RoleIdMap.get(chNode.parentNodeId);
            
            List<User> UserList = RoleUserMap.get(chNode.NodeId);
            if(UserList != NULL){            
                for(User u : UserList){
                    //System.debug('New user being added under a role is - ' + u.Name + ' For the role - ' + chNode.nodeName);
                    TreeNode newNode = new TreeNode(u.Id,u.Name,chNode.NodeId);  
                    RoleIdMap.put(u.Id,newNode); 
                    chNode.addChildNode(newNode);  
                } 
            }   
                
            if(parentNode != NULL)
                parentNode.addChildNode(chNode);
        }     
        
        while(nextNode!= NULL){            
            nextNode = getNextNode(nextNode);
        }        
        jSonString += '}';
        
    }    
 
  Integer count = 0;
                        
    public PageReference incrementCounter() {
            count++;
            return null;
    }
                    
    public Integer getCount() {
        return count;
    }
    
}
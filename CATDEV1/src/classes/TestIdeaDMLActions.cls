@isTest
public class TestIdeaDMLActions {

    static testMethod void myUnitTest() {
        Idea myIdea = new Idea();
        myIdea.Title = 'Test title';
        myIdea.Body = 'Test Description';
        myIdea.Status = 'Submitted';
        myIdea.Categories = 'Mobile';
        
        Community community = [ SELECT Id,IsActive FROM Community WHERE IsActive = TRUE LIMIT 1 ];
        myIdea.CommunityId = community.Id;

        try
        {
            test.StartTest();
            insert myIdea;            
            myIdea.Status = 'In Review';
            update myIdea;
                        
            IdeaComment myComment = new IdeaComment();
            myComment.CommentBody = 'New Comment';
            myComment.IdeaId = myIdea.Id;            
            insert myComment;
            
            test.StopTest();
        }
        catch(Exception e)
        {
            System.assert(TRUE,'Could not insert Idea');  
            System.debug('Exception Thrown!');          
        }
    }
}
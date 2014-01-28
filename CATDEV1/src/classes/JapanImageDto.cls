/*
@Name            : JapanImageDto
@Author          : Satoshi Haga
@Date            : July 1, 2013
@Description     : Data Tranfer Object for Program Image View
@version         : 07/01/2013 First Creation
*/
public class JapanImageDto {

  //Instances of sub class. Each have a message string for one cell
  public SubJapanImageDto dto1 { get; set; }
  public SubJapanImageDto dto2 { get; set; }
  public SubJapanImageDto dto3 { get; set; }
  public SubJapanImageDto dto4 { get; set; }

  /**
   * Constructor with no argment
   */
  public JapanImageDto(){

  }

  /**
   * Constructor with the following argment
   * @param imageNo1     3D Image Number 1
   * @param imageDesc1   3D Image Description 1
   * @param imageNo2     3D Image Number 2
   * @param imageDesc2   3D Image Description 2
   * @param imageNo3     3D Image Number 3
   * @param imageDesc3   3D Image Description 3
   * @param imageNo4     3D Image Number 4
   * @param imageDesc4   3D Image Description 4
   */
  public JapanImageDto(String imageNo1, String imageDesc1,
             String imageNo2, String imageDesc2,
             String imageNo3, String imageDesc3,
             String imageNo4, String imageDesc4){

    //Initialize each member valiable with parameter
    dto1 = new SubJapanImageDto(imageNo1, imageDesc1, '');
    dto2 = new SubJapanImageDto(imageNo2, imageDesc2, '');
    dto3 = new SubJapanImageDto(imageNo3, imageDesc3, '');
    dto4 = new SubJapanImageDto(imageNo4, imageDesc4, '');

  }

  /**
   * Instance each member valiable with sequential numnber.
   * @param cnt       sequential number
   * @param imageNo     3D Image Number
   * @param imageDesc   3D Image Description
   * @param imageNumber   3D Image Number
   */
  public void createSub(Integer cnt, String imageNo, String imageDesc, String imageNumber){
    if(cnt == 1){
      dto1 = new SubJapanImageDto(imageNo, imageDesc, imageNumber);
    }else if(cnt == 2){
      dto2 = new SubJapanImageDto(imageNo, imageDesc, imageNumber);
    }else if(cnt == 3){
      dto3 = new SubJapanImageDto(imageNo, imageDesc, imageNumber);
    }else if(cnt == 4){
      dto4 = new SubJapanImageDto(imageNo, imageDesc, imageNumber);
    }
  }

  /*
  @Name            : SubJapanImageDto
  @Author          : Satoshi Haga
  @Date            : July 1, 2013
  @Description     : Sub Class. This have detailed 3D Image Information.
  @version         : 07/01/2013 First Creation
  */
  public class SubJapanImageDto{
    public String imageNo{ get; set; }
    public String imageDesc{ get; set; }
    public String ImageSrc{ get; set; }
    public String imageNumber{ get; set; }

    /**
     * Constructor with the following argment
     * @param imageNo     3D Image Number
     * @param imageDesc   3D Image Description
     * @param imageNumber   3D Image Number
     */
    public SubJapanImageDto(String imageNo, String imageDesc, String imageNumber){
      this.imageNo = imageNo;
      this.imageDesc = imageDesc;
      this.ImageSrc = '/servlet/servlet.FileDownload?file=' + this.imageNo;
      this.imageNumber = imageNumber;
    }
  }


      @isTest(SeeAllData=false)
    public static void unitTest() {

      JapanImageDto dto = new JapanImageDto();
      System.assert(dto.dto1 == null);
      System.assert(dto.dto2 == null);
      System.assert(dto.dto3 == null);
      System.assert(dto.dto4 == null);

      dto = new JapanImageDto('1111', 'Imgage1', '2222', 'Imgage2','3333', 'Imgage3','4444', 'Imgage4');
      System.assert(dto.dto1 != null);
      System.assert(dto.dto2 != null);
      System.assert(dto.dto3 != null);
      System.assert(dto.dto4 != null);

      dto.createSub(1, '5555', 'Test5555', '5555');
      dto.createSub(2, '6666', 'Test6666', '6666');
      dto.createSub(3, '7777', 'Test7777', '7777');
      dto.createSub(4, '8888', 'Test8888', '8888');

      System.assert('5555'.equals(dto.dto1.imageNo));
      System.assert('6666'.equals(dto.dto2.imageNo));
      System.assert('7777'.equals(dto.dto3.imageNo));
      System.assert('8888'.equals(dto.dto4.imageNo));


    }

}
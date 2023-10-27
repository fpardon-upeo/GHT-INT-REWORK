/**
 * @Version: 1.0
 * @Author: Frederik
 * @Copyright: 2021 Upeo Consulting
 * @Uses:
 *
 * -----------------------------------------------------------------------------------------------
 * Description: 
 *
 *
 * Created: 10/10/2023
 * Last Updated: 10/10/2023
 *
 * Unit tests:
 *
 * Change log:
 * -----------------------------------------------------------------------------------------------
*/
/**
@Description:

@Change Log:

@Dependencies:

@Test Classes:

*/

public class EurotracsResponse {
    public Boolean HasErrors;
    public Boolean HasWarnings;
    public List<Data> Data;
    public class Data {
        public Integer CustomerID;
        public String CustomerName;
        public String CustomerName2;
        public Boolean HasErrors;
        public Boolean HasWarnings;
        public List<Object> ResponseMessages;
    }

    public static EurotracsResponse parse(String json){
        return (EurotracsResponse) System.JSON.deserialize(json, EurotracsResponse.class);
    }
}
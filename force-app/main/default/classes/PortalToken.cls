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
 * Created: 11/10/2023
 * Last Updated: 11/10/2023
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

public class PortalToken {

    public String access_token;

    public static PortalToken parse(String json) {
        return (PortalToken) System.JSON.deserialize(json, PortalToken.class);
    }

}
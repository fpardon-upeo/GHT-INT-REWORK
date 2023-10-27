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

public class ET_Token {
    public String access_token;
    public String token_type;
    public Integer expires_in;

    public static ET_Token parse(String json) {
        System.debug('json: ' + json);
        return (ET_Token) System.JSON.deserialize(json, ET_Token.class);
    }
}
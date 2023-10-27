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

public class PortalAccount {
    public String CustomerName;
    public Integer CustomerID;
    public String CustomerStreet;
    public String CustomerCity;
    public String CustomerCountry;
    public String CustomerPC;
    public String CustomerPhone;
    public String CustomerEmail;
    public String UserEmail;
    public List<String> UserRoles;
    public String CustomerComment;
    public String CustomerVAT;
    public Integer CustomerStatusID;
    public String IsActive;
    public Integer InternalCompanyID;
    public Integer PlanDepotID;
    public Integer AllowNeutral;
    public Boolean CustomerPOD;
    public String ExtensionEDI;
    public Boolean ADRAllowed;
    public Boolean loadingToTMS;

    public static PortalAccount parse(String json) {
        return (PortalAccount) System.JSON.deserialize(json, PortalAccount.class);
    }
}
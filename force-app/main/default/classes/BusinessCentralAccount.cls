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

public class BusinessCentralAccount {
    public String displayName;
    public String type;
    public String id;
    public String addressLine1;
    public String addressLine2;
    public String city;
    public String state;
    public String country;
    public String postalCode;
    public String phoneNumber;
    public String email;
    public Boolean taxLiable;
    public Integer creditLimit;
    public String taxRegistrationNumber;
    public String genBusPostingGroup;
    public String vatBusPostingGroup;
    public String custPostingGroup;
    public String currencyCode;
    public String blocked;
    public String paymentTermsId;
    public String number_x;
    public String taxAreaId;
    public String paymentMethodId;

    public static BusinessCentralAccount parse(String json) {
        return (BusinessCentralAccount) System.JSON.deserialize(json, BusinessCentralAccount.class);
    }

}
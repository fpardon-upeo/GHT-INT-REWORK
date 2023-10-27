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
 * Created: 16/05/2023
 * Last Updated: 16/05/2023
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

public with sharing class AccountCreateInvocable {

    @InvocableMethod(label='Create Account' description='Creates an account in BC and ET')
    public static void createAccount(List<AccountCreate> accountCreateList) {
        List<Account> accountList = new List<Account>();
        for (AccountCreate accountCreate : accountCreateList) {
            AccountService.accountRequest(accountCreate.Id, 'create', accountCreate.legalEntity, accountCreate.environmentType, false);
        }
    }

    public class AccountCreate {
        @InvocableVariable(required=true)
        public String Id;
        @InvocableVariable(required=true)
        public String legalEntity;
        @InvocableVariable(required=true)
        public String environmentType;
    }

}
/**
@Description:

@Change Log:

@Dependencies:

@Test Classes: AccountServiceTest

*/
public with sharing class AccountPortalCreateInvocable {

    @InvocableMethod(label='Create Account' description='Creates an account on the GHT Portal')
    public static void createAccount(List<AccountCreate> accountCreateList) {
        List<Account> accountList = new List<Account>();
        for (AccountCreate accountCreate : accountCreateList) {
            AccountService.createPortalAccount(accountCreate.Id, 'create', accountCreate.environmentType, accountCreate.legalEntity);
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
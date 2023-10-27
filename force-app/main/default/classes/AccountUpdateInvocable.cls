/**
@Description: Invocable method to update the account in the external system

@Change Log:
Date        Developer        Description
----------  --------------   --------------------------------------------------------------------
12/10/2023  Frederik Pardon  Created

@Dependencies: AccountExternalService

@Test Classes:

*/

public with sharing class AccountUpdateInvocable {

    /**
    * @Description: Invocable method to update the account in the external system
    * @Param: accountCreateList - List of accounts to update
    */

    @InvocableMethod(label='Update External Account' description='Updates in the External Systems')
    public static void updateAccount(List<AccountUpdate> accountCreateList) {
        System.debug('AccountUpdateInvocable.updateAccount()');
        System.debug('accountCreateList: ' + accountCreateList);

        Boolean isSandbox = [SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox;
        System.debug('isSandbox: ' + isSandbox);

        String environmentType = isSandbox == true ? 'UAT' : 'Production';

        for (AccountUpdate accountCreate : accountCreateList) {
            AccountExternalService.accountRequest(accountCreate.account.Id, 'update', accountCreate.account.Legal_Entities__c, environmentType);
        }

    }

    public class AccountUpdate {
        @InvocableVariable(required=true)
        public Account account;
    }

}
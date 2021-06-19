public class BitlyShortenURLInvocable {
    
    @InvocableMethod(
        label = 'BitlyShortenURLInvocable'
        description = 'Given account IDs then generates a bitly short url for them'
    )
    public static List<String> shorten( List<ID> accountIds ) {
        shortenAsync( accountIds );
        
		return new List<String>();
    }
    
    @Future( callout = true )
    private static void shortenAsync( List<ID> accountIds ) {
      
        List<Account> accounts = new List<Account>(
        	[SELECT id, 
        		Short_Url__c, 
        		Welcome_Text_Link__c 
        	FROM Account 
        	WHERE id IN :accountIds ]);
      
		BitlyService service = new BitlyService();
        for ( Account accountObj : accounts ) {
            accountObj.short_url__c = service.shorten(accountObj.Welcome_Text_Link__c);
        }

        if ( accounts.size() > 0 ) {
            update accounts;
        }        
    }
}
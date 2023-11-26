global class DesativarContasBatch implements Database.Batchable<sObject> {
    private string query;

    global DesativarContasBatch(String query){
        this.query = query;
    }

    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(this.query);
    }

    global void execute(Database.BatchableContext bc, List<Account> records){
        List<Account> accountsToDeactivate = new List<Account>();
        for(Account acc : records){
            if(acc.Tasks.isEmpty() && acc.Opportunities.isEmpty()){
                acc.Inativa__c = true;
                accountsToDeactivate.add(acc);
            }
        }

        if(!accountsToDeactivate.isEmpty()){
            update accountsToDeactivate;
        }
    }  

    global void finish(Database.BatchableContext BC){

    }
}
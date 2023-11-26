public with sharing class AccountTriggerHandler implements TriggerHandler {
    private final string PARCEIRO_RECORDTYPE_ID = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Parceiro').getRecordTypeId();
    private final string CONSUMIDOR_FINAL_RECORDTYPE_ID = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('ConsumidorFinal').getRecordTypeId();

    public void beforeInsert(List<Account> newAccounts){
        this.validateAccountNumber(newAccounts);
    }

    public void beforeUpdate(List<Account> oldAccounts, List<Account> newAccounts, Map<Id, SObject> oldAccountMap, Map<Id, SObject> newAccountMap){
        this.validateAccountNumber(newAccounts);
    }
    
    public void afterInsert(List<Account> newAccounts){
        this.createAdditionalRecords(newAccounts);
    }

    private void validateAccountNumber(List<Account> accountsList){
        for(Account acc : accountsList){
            if(acc.AccountNumber != null && acc.AccountNumber != ''){
                Boolean isValid = false;
                if(acc.Type == 'CPF'){
                    isValid = Utils.ValidaCPF(acc.AccountNumber);
                }
                else if(acc.Type == 'CNPJ'){
                    isValid = Utils.ValidaCNPJ(acc.AccountNumber);
                } 
                else{
                    isValid = true;
                }
        
                if(!isValid){
                    acc.AccountNumber.addError('Número do cliente é inválido');
                }
            }
        }
    }

    private void createAdditionalRecords(List<Account> accountsList){
        List<Opportunity> oppList = new List<Opportunity>();
        List<Task> taskList = new List<Task>();

        for(Account acc : accountsList){
            if(acc.RecordTypeId == this.PARCEIRO_RECORDTYPE_ID){
                Opportunity opp = new Opportunity();
                opp.Name = acc.Name + ' - opp Parceiro';
                opp.CloseDate = System.today().addDays(30);
                opp.StageName = 'Qualification';
                opp.AccountId = acc.Id;
                oppList.add(opp);
            }
            else if(acc.RecordTypeId == this.CONSUMIDOR_FINAL_RECORDTYPE_ID){
                Task task = new Task();
                task.Subject = 'Consumidor final';
                task.WhatId = acc.id;
                task.Status = 'Not Started';
                task.Priority = 'Normal';
                taskList.add(task);
            }
        }

        if(!oppList.isEmpty()){
            insert oppList;
        }

        if(!taskList.isEmpty()){
            insert taskList;
        }
    }
}
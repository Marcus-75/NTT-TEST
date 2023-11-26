@isTest
public class AccountTriggerTest {  
    @isTest
    static void InsertBulkTest(){
        Integer numberOfRecords = 50;
        id consumidorFinalId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('ConsumidorFinal').getRecordTypeId();
        id parceiroId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Parceiro').getRecordTypeId();
        
        List<Account> accList = new List<Account>();
        
        for(Integer i = 0; i < numberOfRecords; i++){
            Account acc = new Account();
            acc.RecordTypeId = Math.mod(i, 2) == 0 ? parceiroId : consumidorFinalId;
            acc.Type = Math.mod(i, 2) == 0 ? 'CPF' : 'CNPJ';
            acc.Name = 'Account Name Test - ' + i;
            acc.AccountNumber = String.valueOf(i);
            accList.add(acc);
        }
                
        Test.startTest();
        insert accList;
        Test.stopTest();
        
        List<Account> insertedAccountsList = [SELECT id, Type FROM Account WHERE Name LIKE 'Account Name Test - %'];
        System.assertEquals(numberOfRecords, insertedAccountsList.size());

        Integer cnpjAccounts = 0;
        Integer cpfAccounts = 0;
        for(Account acc : insertedAccountsList){
            if(acc.Type == 'CPF')
                cpfAccounts++;
            else if(acc.Type == 'CNPJ')
                cnpjAccounts++;
        }
        System.assertEquals(numberOfRecords/2 , cnpjAccounts);
        System.assertEquals(numberOfRecords/2 , cpfAccounts);
    }
    
    @isTest
    static void updateBulkTest(){
        Integer numberOfRecords = 50;
        id consumidorFinalId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('ConsumidorFinal').getRecordTypeId();
        id parceiroId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Parceiro').getRecordTypeId();
        
        List<Account> accList = new List<Account>();
        
        for(Integer i = 0; i < numberOfRecords; i++){
            Account acc = new Account();
            acc.RecordTypeId = Math.mod(i, 2) == 0 ? parceiroId : consumidorFinalId;
            acc.Type = Math.mod(i, 2) == 0 ? 'CPF' : 'CNPJ';
            acc.Name = 'Account Name Test - ' + i;
            acc.AccountNumber = String.valueOf(i);
            accList.add(acc);
        }
        
        insert accList;
        
        for(Account acc : accList){
            acc.AccountNumber = acc.AccountNumber + 'Updated';
        }
                
        Test.startTest();
        update accList;
        Test.stopTest();
        
        List<Account> updatedAccountsList = [SELECT AccountNumber, Type FROM Account WHERE Name LIKE 'Account Name Test - %'];
        Integer cnpjAccounts = 0;
        Integer cpfAccounts = 0;
        for(Account acc : updatedAccountsList){
            System.assert(acc.AccountNumber.contains('Updated'));
            if(acc.Type == 'CPF')
                cpfAccounts++;
            else if(acc.Type == 'CNPJ')
                cnpjAccounts++;
        }
        System.assertEquals(numberOfRecords/2 , cnpjAccounts);
        System.assertEquals(numberOfRecords/2 , cpfAccounts);
    }

    @isTest
    static void insertParceiroTest(){
        Account acc = new Account();
        acc.Name = 'Account Name Test';
        acc.AccountNumber = '11263846661';
        acc.Type = 'CPF';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Parceiro').getRecordTypeId();
        
        Test.startTest();
        insert acc;
        Test.stopTest();
        
        List<Opportunity> oppList = [SELECT id FROM Opportunity WHERE AccountId =: acc.Id];
        System.assert(!oppList.isEmpty());
    }
    
    @isTest
    static void insertConsumidorFinalTest(){
        Account acc = new Account();
        acc.Name = 'Account Name Test';
        acc.AccountNumber = '11263846661';
        acc.Type = 'CNPJ';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('ConsumidorFinal').getRecordTypeId();
        
        Test.startTest();
        insert acc;
        Test.stopTest();
        
        List<Task> taskList = [SELECT id FROM Task WHERE WhatId =: acc.Id];
        System.assert(!taskList.isEmpty());
    }
    
    @isTest
    static void insertParceiroInvalidTest(){
        Account acc = new Account();
        acc.Name = 'Account Name Test';
        acc.AccountNumber = '11263846661@@@';
        acc.Type = 'CNPJ';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Parceiro').getRecordTypeId();
        
        Test.startTest();
        Try{
            insert acc;
        }
        catch(Exception e){
            System.assert(e.getMessage().contains('Número do cliente é inválido'));
        }
        Test.stopTest();
    }
    
    @isTest
    static void insertConsumidorFinalInvalidTest(){
        Account acc = new Account();
        acc.Name = 'Account Name Test';
        acc.AccountNumber = '11263846661@@@';
        acc.Type = 'CPF';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('ConsumidorFinal').getRecordTypeId();
        
        Test.startTest();
        Try{
            insert acc;
        }
        catch(Exception e){
            System.assert(e.getMessage().contains('Número do cliente é inválido'));
        }
        Test.stopTest();
    }
    
    @isTest
    static void insertNotCPForCNPJTest(){
        Account acc = new Account();
        acc.Name = 'Account Name Test';
        acc.AccountNumber = '11263846661@@@';
        acc.Type = 'Other';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Parceiro').getRecordTypeId();
        
        Test.startTest();
        insert acc;
        Test.stopTest();
        
        List<Opportunity> oppList = [SELECT id FROM Opportunity WHERE AccountId =: acc.Id];
        System.assert(!oppList.isEmpty());
    }
    
    @isTest
    static void updateCPFTest(){
        Account acc = new Account();
        acc.Name = 'Account Name Test';
        acc.AccountNumber = '11263846661';
        acc.Type = 'CPF';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Parceiro').getRecordTypeId();
        insert acc;
        
        acc.AccountNumber = '321';
        
        Test.startTest();
        update acc;
        Test.stopTest();
        
        Account updatedAccount = [SELECT AccountNumber FROM Account WHERE id =: acc.Id];
        System.assertEquals('321', updatedAccount.AccountNumber);
    }
    
    @isTest
    static void updateCNPJTest(){
        Account acc = new Account();
        acc.Name = 'Account Name Test';
        acc.AccountNumber = '11263846661';
        acc.Type = 'CNPJ';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('ConsumidorFinal').getRecordTypeId();
        insert acc;
        
        acc.AccountNumber = '321';
        
        Test.startTest();
        update acc;
        Test.stopTest();
        
        Account updatedAccount = [SELECT AccountNumber FROM Account WHERE id =: acc.Id];
        System.assertEquals('321', updatedAccount.AccountNumber);
    }
    
    @isTest
    static void updateCPFInvalidTest(){
        Account acc = new Account();
        acc.Name = 'Account Name Test';
        acc.AccountNumber = '11263846661';
        acc.Type = 'CPF';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Parceiro').getRecordTypeId();
        insert acc;
        
        acc.AccountNumber = acc.AccountNumber + '@@@';
        
        Test.startTest();
        Try{
            update acc;
        }
        catch(Exception e){
            System.assert(e.getMessage().contains('Número do cliente é inválido'));
        }
        Test.stopTest();
    }
    
    @isTest
    static void updateCNPJInvalidTest(){
        Account acc = new Account();
        acc.Name = 'Account Name Test';
        acc.AccountNumber = '11263846661';
        acc.Type = 'CNPJ';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('ConsumidorFinal').getRecordTypeId();
        insert acc;
        
        acc.AccountNumber = acc.AccountNumber + '@@@';
        
        Test.startTest();
        Try{
            update acc;
        }
        catch(Exception e){
            System.assert(e.getMessage().contains('Número do cliente é inválido'));
        }
        Test.stopTest();
    }
}
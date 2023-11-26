import { LightningElement, api } from 'lwc';
import NAME_FIELD from '@salesforce/schema/Account.Name';
import NUMBER_FIELD from '@salesforce/schema/Account.AccountNumber';
import TYPE_FIELD from '@salesforce/schema/Account.Type';

export default class UpdateAccount extends LightningElement {
    @api recordId;
    @api objectApiName;

    fields = {
        name: NAME_FIELD, 
        accountNumber: NUMBER_FIELD, 
        type: TYPE_FIELD
    };
}
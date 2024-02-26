import { LightningElement, track, } from 'lwc';
import getCurrency from '@salesforce/apexContinuation/CurrencyService.getCurrency';
import getAccountData from '@salesforce/apex/ContactController.getAccountData';
import sendPdf from '@salesforce/apex/ContactController.sendPdf';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class ExchangeRates extends LightningElement {


    _selected = [];

    _date = '';
    content=''
    @track exchangeRates = [];
    @track results=[];
    get options() {
        return [
            { label: 'AUD', value: 'AUD' },
            { label: 'USD', value: 'USD' },
            { label: 'BGN', value: 'BGN' },
            { label: 'INR', value: 'INR' }
           
        ];
    }
    
    get selected() {
        return this._selected.length ? this._selected : 'none';
    }

    handleChange(e) {
        this._selected = e.detail.value;
        

    }

    handleDateChange(event) {
        this._date = event.target.value;
    }

     getExchangeRates() {
        if (!this._date || this._selected.length === 0) {
            console.log('Please select a date and currencies');
            return;
        }
        
      const tag=JSON.stringify(this._selected)
      console.log(typeof(tag));
        getCurrency({targetCurrency:tag,getDate:this._date})
        .then((data)=> {
            this.results = [];
            for (const date in data) {
                const currencies = data[date];
                
                
                for (const currency in currencies) {
                  const currencyObject = {
                    date: date,
                    currency: currency,
                    value: currencies[currency]
                  };
                  this.results.push(currencyObject);
              
                 
                  console.log(`Date: ${date}, Currency: ${currency}, Value: ${currencies[currency]}`);
                }
              }
              
        }).catch((error)=>{
            console.log(error);
        })
}
disabledButton=true

searchKey;
@track accounts;
@track selectedContact=''

handelSearchKey(event){
    this.searchKey = event.target.value;
}


SearchAccountHandler(){
    
    getAccountData({textkey: this.searchKey})
    .then(result => {
            this.accounts = result;
            
            result.forEach(contact => {
                this.selectedContact=contact.Id;
            });
            console.log(this.selectedContact)
    })
    .catch( error=>{
        this.accounts = null;
    });

}
cols = [
    {label:'Last Name', fieldName:'LastName' , type:'text'} ,
    {label:'First Name', fieldName:'FirstName' , type:'Phone'} ,
    {label:'Industry', fieldName:'Email' , type:'text'}
          
]

sendPdf(){
    this.content =this.template.querySelector(".container")
    sendPdf({selectedContact: this.selectedContact,results:this.content.outerHTML})
    .then(() => {
        const event = new ShowToastEvent({
            title: 'Success',
            message: 'Mail sent successfully',
            variant: 'success',
        });
        this.dispatchEvent(event);
    })
    .catch(error => {
        console.error('Error sending mail:', error);
        const event = new ShowToastEvent({
            title: 'Error',
            message: 'Failed to send mail',
            variant: 'error',
        });
        this.dispatchEvent(event);
    });
}
}

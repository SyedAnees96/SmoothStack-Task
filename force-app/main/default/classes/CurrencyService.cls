/*Name: Syed Anees
 *Date: 22/02/2024
 *Desc: Used to retrieve Callout currency information from Freecurrencyapi
 * 
 */ 
public with sharing class CurrencyService {
    public CurrencyService() {}
    //accepts two string parameters date and currency ex: YYYY/MM/DD & AUD, USD
   @AuraEnabled(cacheable=true continuation=true)
    public static Object getCurrency(String targetCurrency,String getDate) {

		
		System.debug(targetCurrency); // Outputs: AUD,CAD
        //instanting the class by specifying the timeout
        Continuation c = new Continuation(100);
        
        //callback method
        c.ContinuationMethod = 'processResponse';
            
        c.state = 'My own data';
        
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();
        System.debug('https://api.freecurrencyapi.com/v1/historical?apikey=fca_live_fjaTkHhBn5RbYuLvdWbZTKClkmb2EurA0njkBJWZ&date='+getDate+'&currencies='+targetCurrency.replaceAll('[\\[\\],"]', ''));
       
        //EX: api.freecurrencyapi.com/v1/historical?apikey=MYKEY&date='+getDate+'&currencies='+targetCurrency.replaceAll('[\\[\\]"]', ''));
        req.setEndpoint('https://api.freecurrencyapi.com/v1/historical?apikey=fca_live_fjaTkHhBn5RbYuLvdWbZTKClkmb2EurA0njkBJWZ&date='+getDate+'&currencies='+targetCurrency.replaceAll('[\\[\\]"]', ''));
        //req.setEndpoint('https://api.freecurrencyapi.com/v1/historical?apikey=fca_live_fjaTkHhBn5RbYuLvdWbZTKClkmb2EurA0njkBJWZ&Date='+getDate);
        req.setMethod('GET');
        c.addHttpRequest(req);
        return c;
        
        //req.setHeader('apikey', 'xxxx');
        //res = http.send(req);
	//system.debug('res'+res);
       // Map<string, object> responseMap = (Map<string, object>) JSON.deserializeUntyped(res.getbody());
        //system.debug('reponseMap'+responseMap);
      //system.debug()
       // return responseMap.get('data');
    }
     
    @AuraEnabled(cacheable=true)
    public static Object processResponse(List<String> labels, Object state){
        //used to get continuation response
        HttpResponse response = Continuation.getResponse(labels[0]);
        //String result = response.getBody();
        Map<string, object> responseMap = (Map<string, object>) JSON.deserializeUntyped(response.getbody());
        //return result;
        return responseMap.get('data');
    }
}
public with sharing class ContactController {
    
   /* @AuraEnabled(cacheable=true)
    public static List<Contact> searchContacts(String searchTerm) {
        return [SELECT Id, Name FROM Contact WHERE Name LIKE :('%' + searchTerm + '%') LIMIT 10];
    }
    */
    //Retrieve the selected contact
     @AuraEnabled(Cacheable = true)
    public static list<Contact> getAccountData(String textkey) {
        textkey = '%' + textkey + '%';
        list<Contact> accLst = [SELECT  Id, FirstName, LastName, Email From Contact WHERE LastName LIKE :textkey Limit 1];
        
        if(accLst.isEmpty()) {
            throw new AuraHandledException('No Record Found..');
        }
        return accLst; 
    }
    //To send the PDF add attachment to selected contact
    @AuraEnabled(Cacheable = true)
    public static String sendPdf(String selectedContact,String results){
        Contact accLst = [SELECT  Id, FirstName, LastName, Email From Contact WHERE id=:selectedContact Limit 1];
        Pagereference pg = Page.pdfVf;
        pg.getParameters().put('displayText', results);
         // Create email
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setToAddresses(new String[]{ accLst.Email });
        message.setSubject('Exchange summary for ' + accLst.LastName);
        message.setHtmlBody('Here\'s a summary for the ' + accLst.LastName + ' account.');
        Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
        attachment.setContentType('application/pdf');
        attachment.setFileName('AccountSummary-' + accLst.LastName + '.pdf');
        attachment.setInline(false);
        attachment.setBody(pg.getContentaspdf());
        message.setFileAttachments(new Messaging.EmailFileAttachment[]{ attachment });
        Messaging.sendEmail(new Messaging.SingleEmailMessage[]{ message });
        return 'Success';
    }
}
Salesforce Developer Test Task
You need to create a LWC Tab that allows you to get Exchange Rates from an external API for some date for some list of currencies (ex: USD-CAD, USD-CHF, USD-EUR, USD-GBP) and send them as a PDF attachment to a particular Contact.
Login to SF
Open Tab with LWC Component
You see Date Input, Multi-Select List of Currencies Pairs and button “Get Exchange Rates” 
LWC Component calls the Apex method that returns exchange rates for selected date and currencies and shows results on the page. (as example you can use this API to get exchange rates - https://currencylayer.com/)
When Rates received Contacts Lookup and “Send as PDF for Contact” button appears on the page.
You can select some Contact and click “Send as PDF for Contact” to call another Apex method that builds PDF with rates results received earlier and sends it as attachment to the Contact email.
Show notification with send email results.
Add tests with code coverage for Apex part 75%+

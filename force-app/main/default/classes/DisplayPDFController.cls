public class DisplayPDFController {

//Display PDF controller
    public String displayText {get; set;}
    public DisplayPDFController() {
        displayText = String.escapeSingleQuotes(
            ApexPages.currentPage().getParameters().get('displayText'));
    }
}
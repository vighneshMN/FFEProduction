@isTest
public class Test_CustomizeEmails {
@isTest
    public static void method1(){
        CustomizeEmails.sendEmailMessages('niladrikundu1993','Msg');
        CustomizeEmails.sendmobileSMS('7003084139', 'Msg');
        CustomizeEmails.sendEmail('niladrikundu1993','Msg');
        CustomizeEmails.sendEmail('niladrikundu1993,','Msg');
        CustomizeEmails.sendSMS('7003084139', 'Msg');
    }
    @isTest
    public static void method2(){
        CustomizeEmails.sendEmail(',Email','Msg');
        CustomizeEmails.sendEmailMessages('niladrikundu1993,niladrikundu1993','Msg');
        CustomizeEmails.sendmobileSMS('7003084139,7003084139', 'Msg');
        CustomizeEmails.sendmobileSMS(',7003084139', 'Msg');
    }
    
}
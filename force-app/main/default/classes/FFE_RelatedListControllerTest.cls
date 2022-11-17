@isTest
public class FFE_RelatedListControllerTest {
    @isTest public static void testInit(){
        Account acc = new Account(Name = 'test');
        insert acc;
        Contact cnt = new Contact(LastName = 'test', AccountId = acc.Id);
        insert cnt;
                
        Map<String, Object> requestMap = new Map<String, Object>(); 
        requestMap.put(FFE_RelatedListController.FIELDS_PARAM, 'Name, Title, Email, Phone');
        requestMap.put(FFE_RelatedListController.RELATED_FIELD_API_NAME_PARAM, 'AccountId');
        requestMap.put(FFE_RelatedListController.RECORD_ID_PARAM, acc.Id);
        requestMap.put(FFE_RelatedListController.NUMBER_OF_RECORDS_PARAM, 1);
        requestMap.put(FFE_RelatedListController.SOBJECT_API_NAME_PARAM, 'Contact');
        requestMap.put(FFE_RelatedListController.SORTED_BY_PARAM, 'Name');
        requestMap.put(FFE_RelatedListController.SORTED_DIRECTION_PARAM, 'ASC');
                
        String jsonData = FFE_RelatedListController.initData(JSON.serialize(requestMap));
        Map<String, Object> responseMap = (Map<String, Object>)JSON.deserializeUntyped(jsonData);
        List<Object> records = (List<Object>)responseMap.get(FFE_RelatedListController.RECORDS_PARAM);
        System.assert(!records.isEmpty());
        String iconName = (String)responseMap.get(FFE_RelatedListController.ICON_NAME_PARAM);
        System.assert(String.isNotBlank(iconName));
    }
}
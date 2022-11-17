public class FFEBatchController {

    public FFEBatchController(ApexPages.StandardSetController controller) {
        system.debug('starting batch');
	    Database.executeBatch(new TrainingResult_Batch(),100); 
    }


    
}
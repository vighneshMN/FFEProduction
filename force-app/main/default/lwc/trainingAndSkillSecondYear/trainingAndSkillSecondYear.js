import { LightningElement,api } from 'lwc';

export default class TrainingAndSkillSecondYear extends LightningElement {
    @api studentlist;
    @api preandpostasses;
    @api studentwithtraininglist;
    @api displayenglishdata;
    @api studentwithall;
    @api displayalldata;
    @api studentwithaptitude;
    @api displayaptitudedata;
}
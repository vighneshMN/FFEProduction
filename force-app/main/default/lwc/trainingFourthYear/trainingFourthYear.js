import { LightningElement,api } from 'lwc';

export default class TrainingFourthYear extends LightningElement {
    @api preandpostassesendline;
    @api studentlist;
    @api fourthyearhr;
    @api studenthrlist;

    @api fourthyeartech;
    @api studentfourthtechlist;
    @api fourthyeartechandhr;
    @api studentfourthrtechlist;
    @api displayplacementdata;
    @api studentplacementlist;
}
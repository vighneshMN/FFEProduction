import { LightningElement } from 'lwc';
import headerImg from '@salesforce/resourceUrl/FFEbanner';
import homeImg from '@salesforce/resourceUrl/home';

export default class Header extends LightningElement {
    headerImage = headerImg;
    homeButtonImage = homeImg;
}
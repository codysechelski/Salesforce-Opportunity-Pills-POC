import { api, LightningElement } from "lwc";

export default class OpportunityPill extends LightningElement {
  @api id;
  @api label;
  @api backgroundColor;
  @api useDarkText;
  @api iconName;

  get style() {
    return `background-color: ${
      this.backgroundColor
    }; color: ${this.generateTextColor()}`;
  }

  get iconVariant() {
    return this.useDarkText ? "" : "inverse";
  }

  generateTextColor() {
    if (this.useDarkText) {
      return "#181818";
    }
    return "#ffffff";
  }
}

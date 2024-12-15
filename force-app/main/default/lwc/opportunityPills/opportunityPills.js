import { api, LightningElement } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import getData from "@salesforce/apex/PillsController.getPills";

export default class OpportunityPills extends LightningElement {
  @api recordId;
  isWorking = false;
  pills;

  connectedCallback() {
    // console.log("recordId", this.recordId);
    this.init();
  }

  init() {
    this.isWorking = true;
    this.getDataFromServer();
  }

  async getDataFromServer() {
    try {
      const result = await getData({ opportunityId: this.recordId });
      console.log("result", structuredClone(result));
      this.pills = result.pills;
      this.isWorking = false;
    } catch (error) {
      console.error(error);
      this.dispatchEvent(
        new ShowToastEvent({
          title: "Error",
          message: "An error occurred file fetching the pills.",
          variant: "error"
        })
      );
    }
  }
}

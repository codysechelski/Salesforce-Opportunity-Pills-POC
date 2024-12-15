/**
 * @description       :
 * @author            : codysechelski@mecanoconsulting.com
 * @group             :
 * @last modified on  : 08-23-2024
 * @last modified by  : codysechelski@mecanoconsulting.com
 **/
public with sharing class PillsController {
  @AuraEnabled
  public static ClientModel getPills(Id opportunityId) {
    try {
      return getActivePills(opportunityId);
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }

  public static ClientModel getActivePills(Id opportunityId) {
    ClientModel model = new ClientModel();
    Opportunity oppt = queryOpportunity(opportunityId);

    model.pills.add(renderClosedPill(oppt));
    model.pills.add(renderWonPill(oppt));
    model.pills.add(renderLostPill(oppt));
    model.pills.add(renderHighValuePill(oppt));
    model.pills.add(renderWebPill(oppt));

    return model;
  }

  public static Pill renderClosedPill(Opportunity oppt) {
    if (oppt.IsClosed) {
      return new Pill('closed', 'Closed', '#706e6b', false, 'utility:ban');
    }
    return null;
  }

  public static Pill renderWonPill(Opportunity oppt) {
    if (oppt.IsWon) {
      return new Pill('won', 'Won', '#2e844a', false, 'utility:success');
    }
    return null;
  }

  public static Pill renderLostPill(Opportunity oppt) {
    if (oppt.IsClosed && !oppt.IsWon) {
      return new Pill('lost', 'Lost', '#ba0517', false, 'utility:clear');
    }
    return null;
  }

  public static Pill renderWebPill(Opportunity oppt) {
    if (oppt.LeadSource == 'Web') {
      return new Pill('web', 'Web', '#fdb6c5', true, 'utility:world');
    }
    return null;
  }

  public static Pill renderHighValuePill(Opportunity oppt) {
    if (oppt.Amount > 200000) {
      return new Pill(
        'hightValue',
        'High Value',
        '#fe9339',
        false,
        'utility:moneybag'
      );
    }
    return null;
  }

  public static Opportunity queryOpportunity(Id opportunityId) {
    return [
      SELECT Id, Name, Amount, StageName, CloseDate, IsClosed, IsWon, LeadSource
      FROM Opportunity
      WHERE Id = :opportunityId
      LIMIT 1
    ];
  }

  class ClientModel {
    @AuraEnabled
    public List<Pill> pills { get; set; }

    public ClientModel() {
      this.pills = new List<Pill>();
    }
  }

  class Pill {
    @AuraEnabled
    public String id { get; set; }
    @AuraEnabled
    public String label { get; set; }
    @AuraEnabled
    public String backgroundColor { get; set; }
    @AuraEnabled
    public Boolean useDarkText { get; set; }
    @AuraEnabled
    public String iconName { get; set; }

    public Pill(
      string id,
      string label,
      string backgroundColor,
      Boolean useDarkText,
      string iconName
    ) {
      this.id = id;
      this.label = label;
      this.backgroundColor = backgroundColor;
      this.useDarkText = useDarkText;
      this.iconName = iconName;
    }
  }
}

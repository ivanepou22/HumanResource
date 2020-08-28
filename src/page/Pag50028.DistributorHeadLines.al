page 50028 "Distributor HeadLines"
{
    PageType = HeadlinePart;
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            group("AppName Headline")
            {
                Visible = AppNameHeadlineVisible;
                ShowCaption = false;
                Editable = false;

                field(FirstInsight; FirstInsightText)
                {
                    ApplicationArea = Basic, Suite;
                    trigger OnDrillDown();
                    var
                    begin
                        OnDrillDownFirstInsight();
                    end;

                }
                field(SecondInsight; SecondInsightText)
                {
                    ApplicationArea = Basic, Suite;
                    trigger OnDrillDown();
                    var
                    begin
                        OnDrillDownSecondInsight();
                    end;
                }

            }
        }
    }

    var
        [InDataSet]
        AppNameHeadlineVisible: Boolean;
        FirstInsightText: Text;
        SecondInsightText: Text;

    trigger OnOpenPage()
    begin
        HandleVisibility();

        HandleFirstInsight();
        HandleSecondInsight();

        OnSetVisibility(AppNameHeadlineVisible);
    end;

    local procedure HandleVisibility()
    var
    begin
        AppNameHeadlineVisible := true;
    end;

    local procedure HandleFirstInsight();
    var
        HeadlineManagement: Codeunit Headlines;
        PayloadText: Text;
        QualifierText: Text;
        UserName: Code[100];
        User: Record User;
    begin
        User.Reset();
        User.SetRange(User."User Name", UserId);
        if User.FindFirst() then
            UserName := User."Full Name";

        PayloadText := HeadlineManagement.Emphasize('') + 'Hi, ' + UserName;
        QualifierText := 'UserName';
        HeadlineManagement.GetHeadlineText(QualifierText, PayloadText, FirstInsightText);
    end;

    local procedure HandleSecondInsight();
    var
        HeadlineManagement: Codeunit Headlines;
        PayloadText: Text;
        QualifierText: Text;
        UserIDFilter: Code[50];
        SalesHeader: Record "Sales Header";
        SalesOrdersAmount: Decimal;
    begin
        //Calculate the sales amount
        SalesHeader.Reset();
        SalesHeader.SetRange(SalesHeader."Document Type", SalesHeader."Document Type"::Order);
        SalesHeader.SetRange(SalesHeader."USER ID", UserId);
        if SalesHeader.FindFirst() then
            repeat
                SalesHeader.CalcFields("Amount Including VAT");
                SalesOrdersAmount += SalesHeader."Amount Including VAT";
            until SalesHeader.Next() = 0;

        PayloadText := HeadlineManagement.Emphasize('') + 'Sales Orders Amount ' + format(SalesOrdersAmount);
        QualifierText := 'Sales Orders Amount';
        HeadlineManagement.GetHeadlineText(QualifierText, PayloadText, SecondInsightText);

    end;

    local procedure OnDrillDownFirstInsight();
    var
    begin

    end;

    local procedure OnDrillDownSecondInsight();
    var
    begin

    end;

    [IntegrationEvent(false, false)]
    local procedure OnSetVisibility(var AppNameHeadlineVisible: Boolean)
    begin
    end;
}
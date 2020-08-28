page 50001 "Headline RC Human Resource"
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
        NoOfEMployee: Decimal;
        NoOfInactiveEmp: Decimal;
        NoOfTerminatedEmployees: Decimal;
        Employee: Record Employee;
        Employee1: Record Employee;
        Employee2: Record Employee;
    begin
        NoOfEMployee := 0;
        NoOfInactiveEmp := 0;
        Employee.Reset();
        Employee.SetRange(Employee.Status, Employee.Status::Active);
        Employee.SetRange(Employee."Status 1", Employee."Status 1"::Active);
        if Employee.FindFirst() then
            repeat
                NoOfEMployee := Employee.Count;
            until Employee.Next() = 0;

        Employee1.Reset();
        Employee1.SetRange(Employee1.Status, Employee1.Status::Inactive);
        Employee1.SetRange(Employee1."Status 1", Employee1."Status 1"::Inactive);
        if Employee1.FindFirst() then
            repeat
                NoOfInactiveEmp := Employee1.Count;
            until Employee1.Next() = 0;

        Employee2.Reset();
        Employee2.SetRange(Employee2.Status, Employee2.Status::Terminated);
        Employee2.SetRange(Employee2."Status 1", Employee2."Status 1"::Terminated);
        if Employee2.FindFirst() then
            repeat
                NoOfTerminatedEmployees := Employee2.Count();
            until Employee2.Next() = 0;

        PayloadText := HeadlineManagement.Emphasize(format(NoOfEMployee)) + ' Active Employees and ' + HeadlineManagement.Emphasize(Format(NoOfInactiveEmp)) + ' InActive Employees';
        QualifierText := 'Employees';
        HeadlineManagement.GetHeadlineText(QualifierText, PayloadText, FirstInsightText);

    end;

    local procedure HandleSecondInsight();
    var
        HeadlineManagement: Codeunit Headlines;
        PayloadText: Text;
        QualifierText: Text;
        User: Record User;
        UserName: Code[50];
    begin
        User.Reset();
        User.SetRange(User."User Name", UserId);
        if User.FindFirst() then
            UserName := User."Full Name";

        PayloadText := HeadlineManagement.Emphasize('Hi  ') + Format(UserName) + ' Welcome To HR Role Center';
        QualifierText := '';
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
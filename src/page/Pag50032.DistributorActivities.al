page 50032 "Distributor Activities"
{
    Caption = 'Distributor Activities';
    PageType = CardPart;
    RefreshOnActivate = true;
    SourceTable = "Sales Cue";
    ShowFilter = false;

    layout
    {
        area(Content)
        {
            cuegroup("Sales Order Amounts")
            {
                CuegroupLayout = Wide;
                field("Sales Order - OpenA"; OpenSalesAmount)
                {
                    Caption = 'Open Orders Amounts';
                    ApplicationArea = Basic, Suite;
                    DrillDownPageId = "Dist Sales Order List";
                }
                field("Sales Order PendingA"; PendingSalesAmount)
                {
                    Caption = 'Pending Approval Orders Amounts';
                    ApplicationArea = Basic, Suite;
                    DrillDownPageId = "Dist Sales Order List";
                }

                field("Sales Order PrepaymentA"; PrepaymentSalesAmount)
                {
                    Caption = 'Pending Prepayment Orders Amounts';
                    ApplicationArea = Basic, Suite;
                    DrillDownPageId = "Dist Sales Order List";
                }
                field("Released Sales OrdersA"; ReleaseSalesAmount)
                {
                    Caption = 'Released Orders Amounts';
                    ApplicationArea = Basic, Suite;
                    DrillDownPageId = "Dist Sales Order List";
                }
            }

            cuegroup("Distributor Activity")
            {
                ShowCaption = false;
                field("Sales Order - Open"; "Sales Order - Open")
                {
                    Caption = 'Open - Sales Orders';
                    ApplicationArea = Basic, Suite;
                    DrillDownPageId = "Dist Sales Order List";
                    ToolTip = 'Shows the open sales orders created by the Distributor';
                }

                field("Sales Order Pending"; "Sales Order Pending")
                {
                    Caption = 'Sales Orders Pending Approval';
                    ApplicationArea = Basic, Suite;
                    DrillDownPageId = "Dist Sales Order List";
                    ToolTip = 'Shows the sales orders Pending Approval created by the Distributor';
                }

                field("Sales Order Prepayment"; "Sales Order Prepayment")
                {
                    Caption = 'Sales Orders Pending Prepayment';
                    ApplicationArea = Basic, Suite;
                    DrillDownPageId = "Dist Sales Order List";
                    ToolTip = 'Shows the sales orders Pending Prepayment created by the Distributor';
                }

                field("Released Sales Orders"; "Released Sales Orders")
                {
                    Caption = 'Released Sales Orders';
                    ApplicationArea = Basic, Suite;
                    DrillDownPageId = "Dist Sales Order List";
                    ToolTip = 'Shows the Released sales orders created by the Distributor';
                }

            }


        }
    }

    trigger OnOpenPage()
    var
        SalesHeader: Record "Sales Header";
    begin
        Reset();
        If newProcedure() then begin
            Init();
            Insert();
        end;
        SetFilter("User ID Filter", UserId);
        SalesHeader.CalcFields(Amount);
    end;

    trigger OnAfterGetRecord()
    begin
        CalculateCueFieldValues();
        CalculateOpenSales();
    end;

    local procedure CalculateCueFieldValues()
    begin

    end;

    local procedure newProcedure() returnValue: Boolean
    begin
        returnValue := not Get();
    end;

    var
        UserNameId: Code[30];
        OpenSalesAmount: Decimal;
        PendingSalesAmount: Decimal;
        PrepaymentSalesAmount: Decimal;
        ReleaseSalesAmount: Decimal;

    procedure CalculateOpenSales()
    var
        SalesHeader: Record "Sales Header";
        SalesHeader1: Record "Sales Header";
        SalesHeader2: Record "Sales Header";
        SalesHeader3: Record "Sales Header";
    begin

        //OpenSalesAmount
        SalesHeader.Reset();
        SalesHeader.SetRange(SalesHeader."Document Type", SalesHeader."Document Type"::Order);
        SalesHeader.SetRange(SalesHeader.Status, SalesHeader.Status::Open);
        SalesHeader.SetRange(SalesHeader."USER ID", UserId);
        if SalesHeader.FindFirst() then
            repeat
                SalesHeader.CalcFields("Amount Including VAT");
                OpenSalesAmount += SalesHeader."Amount Including VAT";
            until SalesHeader.Next() = 0;

        //PendingSalesAmount
        SalesHeader1.Reset();
        SalesHeader1.SetRange(SalesHeader1."Document Type", SalesHeader1."Document Type"::Order);
        SalesHeader1.SetRange(SalesHeader1.Status, SalesHeader1.Status::"Pending Approval");
        SalesHeader1.SetRange(SalesHeader1."USER ID", UserId);
        if SalesHeader1.FindFirst() then
            repeat
                SalesHeader1.CalcFields("Amount Including VAT");
                PendingSalesAmount += SalesHeader1."Amount Including VAT";
            until SalesHeader1.Next() = 0;

        //PrepaymentSalesAmount.
        SalesHeader2.Reset();
        SalesHeader2.SetRange(SalesHeader2."Document Type", SalesHeader2."Document Type"::Order);
        SalesHeader2.SetRange(SalesHeader2.Status, SalesHeader2.Status::"Pending Prepayment");
        SalesHeader2.SetRange(SalesHeader2."USER ID", UserId);
        if SalesHeader2.FindFirst() then
            repeat
                SalesHeader2.CalcFields("Amount Including VAT");
                PrepaymentSalesAmount += SalesHeader2."Amount Including VAT";
            until SalesHeader2.Next() = 0;


        //ReleaseSalesAmount
        SalesHeader3.Reset();
        SalesHeader3.SetRange(SalesHeader3."Document Type", SalesHeader3."Document Type"::Order);
        SalesHeader3.SetRange(SalesHeader3.Status, SalesHeader3.Status::Released);
        SalesHeader3.SetRange(SalesHeader3."USER ID", UserId);
        if SalesHeader3.FindFirst() then
            repeat
                SalesHeader3.CalcFields("Amount Including VAT");
                ReleaseSalesAmount += SalesHeader3."Amount Including VAT";
            until SalesHeader3.Next() = 0;
    end;

}
report 50013 "Batch Post Sales Orders POS"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    ProcessingOnly = true;

    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            DataItemTableView = SORTING("Document Type", "No.") WHERE("Document Type" = CONST(Order));
            RequestFilterFields = "No.", Status;

            //Triggers
            trigger OnPreDataItem()
            var
                myInt: Integer;
            begin
                IF ReplacePostingDate AND (PostingDateReq = 0D) THEN
                    ERROR(Text000);

                CounterTotal := COUNT;
                Window.OPEN(Text001);
            end;

            trigger OnAfterGetRecord()
            var
                ApprovalsMgmt: Codeunit "Approvals Mgmt.";
            begin
                IF ApprovalsMgmt.IsSalesApprovalsWorkflowEnabled("Sales Header") OR (Status = Status::"Pending Approval") THEN
                    CurrReport.SKIP;

                IF CalcInvDisc THEN
                    CalculateInvoiceDiscount;

                Counter := Counter + 1;
                Window.UPDATE(1, "No.");
                Window.UPDATE(2, ROUND(Counter / CounterTotal * 10000, 1));
                Ship := ShipReq;
                Invoice := InvReq;
                CLEAR(SalesPost);
                //SalesPost.SetPostingDate(ReplacePostingDate, ReplaceDocumentDate, PostingDateReq);
                IF IsApprovedForPostingBatch THEN
                    IF SalesPost.RUN("Sales Header") THEN BEGIN
                        CounterOK := CounterOK + 1;
                        IF MARKEDONLY THEN
                            MARK(FALSE);
                    END;
            end;

            trigger OnPostDataItem()
            var
                myInt: Integer;
            begin
                Window.CLOSE;
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    // field(Name; SourceExpression)
                    // {
                    //     ApplicationArea = All;

                    // }
                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    var
        SalesLine: Record "Sales Line";
        SalesSetup: Record "Sales & Receivables Setup";
        SalesCalcDisc: Codeunit "Sales-Calc. Discount";
        SalesPost: Codeunit "Sales-Post";
        Window: Dialog;
        ShipReq: Boolean;
        InvReq: Boolean;
        PostingDateReq: Date;
        CounterTotal: Integer;
        Counter: Integer;
        CounterOK: Integer;
        ReplacePostingDate: Boolean;
        ReplaceDocumentDate: Boolean;
        CalcInvDisc: Boolean;
        Text000: Label 'Enter the posting date.';
        Text001: Label 'Posting orders  #1########## @2@@@@@@@@@@@@@';
        Text002: Label '%1 orders out of a total of %2 have now been posted.';
        Text003: Label 'The exchange rate associated with the new posting date on the sales header will not apply to the sales lines.';

    local procedure CalculateInvoiceDiscount()
    var
        myInt: Integer;
    begin
        SalesLine.RESET;
        SalesLine.SETRANGE("Document Type", "Sales Header"."Document Type");
        SalesLine.SETRANGE("Document No.", "Sales Header"."No.");
        IF SalesLine.FINDFIRST THEN
            IF SalesCalcDisc.RUN(SalesLine) THEN BEGIN
                "Sales Header".GET("Sales Header"."Document Type", "Sales Header"."No.");
                COMMIT;
            END;
    end;

    procedure InitializeRequest(ShipParam: Boolean;
       InvoiceParam: Boolean;
       PostingDateParam: Date;
       ReplacePostingDateParam: Boolean;
       ReplaceDocumentDateParam: Boolean;
       CalcInvDiscParam: Boolean)
    var
        myInt: Integer;
    begin
        ShipReq := ShipParam;
        InvReq := InvoiceParam;
        PostingDateReq := PostingDateParam;
        ReplacePostingDate := ReplacePostingDateParam;
        ReplaceDocumentDate := ReplaceDocumentDateParam;
        CalcInvDisc := CalcInvDiscParam;
    end;
}
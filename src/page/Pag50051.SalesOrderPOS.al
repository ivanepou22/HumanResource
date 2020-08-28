page 50051 "Sales Order POS"
{
    PageType = Document;
    SourceTable = "Sales Header";
    SourceTableView = WHERE("Document Type" = FILTER(Order));
    DeleteAllowed = false;
    ShowFilter = false;
    LinksAllowed = false;
    RefreshOnActivate = true;
    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                ShowCaption = false;

                part(SalesLines2; "Sales Order Subform POS Coded")
                {
                    ApplicationArea = Basic, Suite;
                    SubPageLink = "Document No." = FIELD("No.");
                    Editable = DynamicEditable;
                    UpdatePropagation = Both;
                }
            }
            group(options)
            {
                ShowCaption = false;
                grid(main)
                {
                    ShowCaption = false;
                    group(Option)
                    {
                        ShowCaption = false;

                        field("Invoice Discount Amount"; "Invoice Discount Amount")
                        {
                            ApplicationArea = All;
                        }

                        field("Cash Tendered"; "Cash Tendered")
                        {
                            ApplicationArea = All;

                            trigger OnValidate()
                            begin
                                Change := "Cash Tendered" - "Amount Including VAT";
                            end;
                        }
                    }
                    group(Money)
                    {
                        ShowCaption = false;
                        field("Amount Including VAT"; "Amount Including VAT")
                        {
                            ApplicationArea = All;
                            Caption = 'Total';
                            trigger OnValidate()
                            begin
                                Change := "Amount Including VAT" - "Cash Tendered";
                            end;
                        }
                        field(Change; Change)
                        {
                            ApplicationArea = All;
                        }
                    }
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Post and &Print")
            {
                ApplicationArea = All;
                Caption = 'Post and &Print';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = PostPrint;
                Ellipsis = true;
                ShortcutKey = 'F9';
                trigger OnAction()
                var
                    ReceiptHeader: Record "Sales Header";
                    InvoiceNo: Code[20];
                    OrderNo: Code[20];
                begin
                    CheckReceiptAmount();
                    CheckUserSetupAndDrawer();
                    OrderNo := CreateAndPostPOSOrder(Rec);
                    InvoiceNo := GetPostedInvoice(OrderNo);
                    CreateAndPostCashReceipt(InvoiceNo);
                    CurrPage.SalesLines2.PAGE.SetAllowPriceChange();
                end;
            }
        }
    }

    var
        CopySalesDoc: Report "Copy Sales Document";
        MoveNegSalesLines: Report "Move Negative Sales Lines";
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        ReportPrint: Codeunit "Test Report-Print";
        DocPrint: Codeunit "Document-Print";
        ArchiveManagement: Codeunit ArchiveManagement;
        SalesCalcDiscountByType: Codeunit "Sales - Calc Discount By Type";
        ChangeExchangeRate: Page "Change Exchange Rate";
        UserMgt: Codeunit "User Setup Management";
        Usage: Option "Order Confirmation","Work Order","Pick Instruction";
        JobQueueVisible: Boolean;
        DynamicEditable: Boolean;
        HasIncomingDocument: Boolean;
        DocNoVisible: Boolean;
        ExternalDocNoMandatory: Boolean;
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        CRMIntegrationEnabled: Boolean;
        CRMIsCoupledToRecord: Boolean;
        ShowWorkflowStatus: Boolean;
        CrossReferenceNo: Code[20];
        CrossReferenceNo2: Code[20];
        CrossReferenceNo3: Code[20];
        CrossReferenceNo4: Code[20];
        CrossReferenceNo5: Code[20];
        Payment: Decimal;
        Change: Decimal;
        setdate: Record "Sales Invoice Header";
        UserSetup: Record "User Setup";
        CustomerRec: Record Customer;
        Text001: Label 'Do you want to change %1 in all related records in the warehouse?';
        Text002: Label 'The update has been interrupted to respect the warning.';

    //=========Trigger========
    trigger OnInit()
    var
        myInt: Integer;
    begin
        SetExtDocNoMandatoryCondition;
    end;

    trigger OnOpenPage()
    var
        CRMIntegrationManagement: Codeunit "CRM Integration Management";
    begin
        IF UserMgt.GetSalesFilter <> '' THEN BEGIN
            FILTERGROUP(2);
            SETRANGE("Responsibility Center", UserMgt.GetSalesFilter);
            FILTERGROUP(0);
        END;

        SETRANGE("Date Filter", 0D, WORKDATE - 1);

        SetDocNoVisible;
        CRMIntegrationEnabled := CRMIntegrationManagement.IsCRMIntegrationEnabled;

    end;

    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin
        SetControlVisibility;
        Change := "Cash Tendered" - "Amount Including VAT";
        ResetDates();
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        myInt: Integer;
    begin
        "Responsibility Center" := UserMgt.GetSalesFilter;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        myInt: Integer;
    begin
        CheckCreditMaxBeforeInsert;
    end;

    trigger OnDeleteRecord(): Boolean
    var
        myInt: Integer;
    begin
        CurrPage.SAVERECORD;
        EXIT(ConfirmDeletion);
    end;

    trigger OnAfterGetCurrRecord()
    var
        myInt: Integer;
    begin
        DynamicEditable := CurrPage.EDITABLE;
    end;


    //==========Functions===========
    local procedure Post(PostingCodeunitID: Integer)
    var
        myInt: Integer;
    begin
        SendToPosting(PostingCodeunitID);
        IF "Job Queue Status" = "Job Queue Status"::"Scheduled for Posting" THEN
            CurrPage.CLOSE;
        CurrPage.UPDATE(FALSE);
    end;

    local procedure ApproveCalcInvDisc()
    var
        myInt: Integer;
    begin
        //CurrPage.SalesLines.PAGE.ApproveCalcInvDisc;
    end;

    local procedure SelltoCustomerNoOnAfterValidat()
    var
        myInt: Integer;
    begin
        IF GETFILTER("Sell-to Customer No.") = xRec."Sell-to Customer No." THEN
            IF "Sell-to Customer No." <> xRec."Sell-to Customer No." THEN
                SETRANGE("Sell-to Customer No.");
        CurrPage.UPDATE;
    end;

    local procedure SalespersonCodeOnAfterValidate()
    var
        myInt: Integer;
    begin
        //CurrPage.SalesLines.PAGE.UpdateForm(TRUE);
    end;

    local procedure BilltoCustomerNoOnAfterValidat()
    var
        myInt: Integer;
    begin
        CurrPage.UPDATE;
    end;

    local procedure ShortcutDimension1CodeOnAfterV()
    var
        myInt: Integer;
    begin
        CurrPage.UPDATE;
    end;

    local procedure ShortcutDimension2CodeOnAfterV()
    var
        myInt: Integer;
    begin
        CurrPage.UPDATE;
    end;

    local procedure PricesIncludingVATOnAfterValid()
    var
        myInt: Integer;
    begin
        CurrPage.UPDATE;
    end;

    local procedure Prepayment37OnAfterValidate()
    var
        myInt: Integer;
    begin
        CurrPage.UPDATE;
    end;

    local procedure SetDocNoVisible()
    var
        DocumentNoVisibility: Codeunit DocumentNoVisibility;
        DocType: Option Quote,Order,Invoice,"Credit Memo","Blanket Order","Return Order",Reminder,FinChMemo;
    begin
        DocNoVisible := DocumentNoVisibility.SalesDocumentNoIsVisible(DocType::Order, "No.");
    end;

    local procedure SetExtDocNoMandatoryCondition()
    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
    begin
        SalesReceivablesSetup.GET;
        ExternalDocNoMandatory := SalesReceivablesSetup."Ext. Doc. No. Mandatory"
    end;

    local procedure ShowPreview()
    var
        SalesPostYesNo: Codeunit "Sales-Post (Yes/No)";
    begin
        SalesPostYesNo.Preview(Rec);
    end;

    local procedure SetControlVisibility()
    var
        myInt: Integer;
    begin

        JobQueueVisible := "Job Queue Status" = "Job Queue Status"::"Scheduled for Posting";
        HasIncomingDocument := "Incoming Document Entry No." <> 0;
        SetExtDocNoMandatoryCondition;

        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(RECORDID);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(RECORDID);
    end;
}
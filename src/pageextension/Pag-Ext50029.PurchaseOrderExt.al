pageextension 50029 "Purchase Order Ext" extends "Purchase Order"
{
    layout
    {
        // Add changes to page layout here
        modify("Quote No.")
        {
            Caption = 'Request No.';
        }
        addafter("Posting Description")
        {
            field("Raw Milk"; "Raw Milk")
            {
                ApplicationArea = All;
            }

        }
        addafter(Status)
        {
            field("Warm Milk"; "Warm Milk")
            {
                ApplicationArea = All;
            }
            field("Making Adjustments"; "Making Adjustments")
            {
                ApplicationArea = All;
            }
            field("Working Description"; "Working Description")
            {
                ApplicationArea = All;
                MultiLine = true;
            }

        }
    }

    actions
    {
        // Add changes to page actions here
        modify(Post)
        {
            Enabled = false;
            Visible = false;
        }
        modify("&Print")
        {
            Visible = false;
            Enabled = false;
        }
        addfirst("P&osting")
        {
            action("Post Order")
            {
                ApplicationArea = Suite;
                Caption = 'P&ost';
                Ellipsis = true;
                Image = PostOrder;
                Promoted = true;
                PromotedCategory = Category6;
                PromotedIsBig = true;
                ShortCutKey = 'F9';
                ToolTip = 'Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.';

                trigger OnAction()
                var
                    PurchaseOrder: Page "Purchase Order";
                begin
                    PostDocumentMod(CODEUNIT::"Purch.-Post Modified", NavigateAfterPost::"Posted Document");
                end;
            }

            action("Print Order")
            {
                ApplicationArea = Suite;
                Caption = '&Print';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Category10;
                ToolTip = 'Prepare to print the document. The report request window for the document opens where you can specify what to include on the print-out.';
                trigger OnAction()
                var
                    PurchaseInvHeader: Record "Purchase Header";
                    PurchaseOrderPrint: Report "Purchase Order - Print";
                begin
                    PurchaseInvHeader.RESET;
                    PurchaseInvHeader.SETRANGE(PurchaseInvHeader."No.", Rec."No.");
                    PurchaseInvHeader.SetRange(PurchaseInvHeader."Document Type", Rec."Document Type");
                    PurchaseInvHeader.SetRange(PurchaseInvHeader."Buy-from Vendor No.", Rec."Buy-from Vendor No.");
                    PurchaseOrderPrint.SETTABLEVIEW(PurchaseInvHeader);
                    PurchaseOrderPrint.RUN;
                end;
            }
        }


    }

    var
        CopyPurchDoc: Report "Copy Purchase Document";
        MoveNegPurchLines: Report "Move Negative Purchase Lines";
        ReportPrint: Codeunit "Test Report-Print";
        UserMgt: Codeunit "User Setup Management";
        ArchiveManagement: Codeunit ArchiveManagement;
        PurchCalcDiscByType: Codeunit "Purch - Calc Disc. By Type";
        FormatAddress: Codeunit "Format Address";
        ChangeExchangeRate: Page "Change Exchange Rate";
        NavigateAfterPost: Option "Posted Document","New Document","Do Nothing";
        [InDataSet]
        JobQueueVisible: Boolean;
        [InDataSet]
        JobQueueUsed: Boolean;
        HasIncomingDocument: Boolean;
        DocNoVisible: Boolean;
        VendorInvoiceNoMandatory: Boolean;
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        ShowWorkflowStatus: Boolean;
        CanCancelApprovalForRecord: Boolean;
        DocumentIsPosted: Boolean;
        OpenPostedPurchaseOrderQst: Label 'The order is posted as number %1 and moved to the Posted Purchase Invoices window.\\Do you want to open the posted invoice?', Comment = '%1 = posted document number';
        CanRequestApprovalForFlow: Boolean;
        CanCancelApprovalForFlow: Boolean;
        ShowShippingOptionsWithLocation: Boolean;
        IsSaaS: Boolean;
        IsBuyFromCountyVisible: Boolean;
        IsPayToCountyVisible: Boolean;
        IsShipToCountyVisible: Boolean;


    //trigger
    trigger OnopenPage()
    var
        PurchaserHeader: Record "Purchase Header";
        purchaseLine: Record "Purchase Line";
        PurchaseReceiptLine: Record "Purch. Rcpt. Line";
        PurchaseInvoiceLines: Record "Purch. Inv. Line";
    begin

        purchaseLine.Reset();
        purchaseLine.SetRange(purchaseLine."Document No.", Rec."No.");
        purchaseLine.SetRange(purchaseLine."Document Type", purchaseLine."Document Type"::Order);
        if purchaseLine.FindFirst() then
            repeat
                purchaseLine.validate("Buy-from Vendor No.", Rec."Buy-from Vendor No.");
                purchaseLine.Validate("Pay-to Vendor No.", Rec."Pay-to Vendor No.");
                purchaseLine.Modify();
            until purchaseLine.Next() = 0;

        // //Purchase ReceiptLines
        // PurchaseReceiptLine.Reset();
        // PurchaseReceiptLine.SetRange(PurchaseReceiptLine."Order No.", Rec."No.");
        // if PurchaseReceiptLine.FindFirst() then
        //     repeat
        //         PurchaseReceiptLine.validate(PurchaseReceiptLine."Buy-from Vendor No.", Rec."Buy-from Vendor No.");
        //         PurchaseReceiptLine.Validate(PurchaseReceiptLine."Pay-to Vendor No.", Rec."Pay-to Vendor No.");
        //         PurchaseReceiptLine.Modify();
        //     until PurchaseReceiptLine.Next() = 0;

        // //PurchaseInvoiceLines
        // PurchaseInvoiceLines.Reset();
        // PurchaseInvoiceLines.SetRange(PurchaseInvoiceLines."Order No.", Rec."No.");
        // if PurchaseInvoiceLines.FindFirst() then
        //     repeat
        //         PurchaseInvoiceLines.Validate(PurchaseInvoiceLines."Buy-from Vendor No.", Rec."Buy-from Vendor No.");
        //         PurchaseInvoiceLines.Validate(PurchaseInvoiceLines."Pay-to Vendor No.", Rec."Pay-to Vendor No.");
        //         PurchaseInvoiceLines.Modify();
        //     until PurchaseInvoiceLines.Next() = 0;
    end;

    local procedure PostDocumentMod(PostingCodeunitID: Integer; Navigate: Option)
    var
        PurchaseHeader: Record "Purchase Header";
        InstructionMgt: Codeunit "Instruction Mgt.";
        ApplicationAreaMgmtFacade: Codeunit "Application Area Mgmt. Facade";
        LinesInstructionMgt: Codeunit "Lines Instruction Mgt.";
        IsScheduledPosting: Boolean;
    begin
        if ApplicationAreaMgmtFacade.IsFoundationEnabled then
            LinesInstructionMgt.PurchaseCheckAllLinesHaveQuantityAssigned(Rec);

        SendToPosting(PostingCodeunitID);

        IsScheduledPosting := "Job Queue Status" = "Job Queue Status"::"Scheduled for Posting";
        DocumentIsPosted := (not PurchaseHeader.Get("Document Type", "No.")) or IsScheduledPosting;

        if IsScheduledPosting then
            CurrPage.Close;
        CurrPage.Update(false);

        if PostingCodeunitID <> CODEUNIT::"Purch.-Post Modified" then
            exit;

        case Navigate of
            NavigateAfterPost::"Posted Document":
                if InstructionMgt.IsEnabled(InstructionMgt.ShowPostedConfirmationMessageCode) then
                    ShowPostedConfirmationMessageMod();
            NavigateAfterPost::"New Document":
                if DocumentIsPosted then begin
                    Clear(PurchaseHeader);
                    PurchaseHeader.Init();
                    PurchaseHeader.Validate("Document Type", PurchaseHeader."Document Type"::Order);
                    PurchaseHeader.Insert(true);
                    PAGE.Run(PAGE::"Purchase Order", PurchaseHeader);
                end;
        end;
    end;

    local procedure ShowPostedConfirmationMessageMod()
    var
        OrderPurchaseHeader: Record "Purchase Header";
        PurchInvHeader: Record "Purch. Inv. Header";
        InstructionMgt: Codeunit "Instruction Mgt.";
    begin
        if not OrderPurchaseHeader.Get("Document Type", "No.") then begin
            PurchInvHeader.SetRange("No.", "Last Posting No.");
            if PurchInvHeader.FindFirst then
                if InstructionMgt.ShowConfirm(StrSubstNo(OpenPostedPurchaseOrderQst, PurchInvHeader."No."),
                     InstructionMgt.ShowPostedConfirmationMessageCode)
                then
                    PAGE.Run(PAGE::"Posted Purchase Invoice", PurchInvHeader);
        end;
    end;

}
pageextension 50024 "Sales Order Ext" extends "Sales Order"
{
    layout
    {
        // Add changes to page layout here
        addafter("Sell-to Customer Name")
        {
            field("Branch Code"; "Branch Code")
            {
                ApplicationArea = All;
            }

        }
        addafter("Posting Description")
        {
            field("Truck No."; "Truck No.")
            {
                ApplicationArea = All;
            }

            field("Seal No."; "Seal No")
            {
                ApplicationArea = All;
            }
            field("Shipping No. Series"; "Shipping No. Series")
            {
                ApplicationArea = All;
                Editable = true;
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
        addfirst("P&osting")
        {
            action("Post Order")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'P&ost';
                Ellipsis = true;
                Image = PostOrder;
                Promoted = true;
                PromotedCategory = Category6;
                PromotedIsBig = true;
                ShortCutKey = 'F9';
                ToolTip = 'Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.';

                trigger OnAction()
                begin
                    PostDocumentModified(CODEUNIT::"Sales-Post Modified", NavigateAfterPost::"Posted Document");
                end;
            }
            action(POS)
            {
                ApplicationArea = All;
                Caption = 'POS';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = report "Create POS";
                Image = Sales;
                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        NavigateAfterPost: Option "Posted Document","New Document","Do Nothing";

    local procedure PostDocumentModified(PostingCodeunitID: Integer; Navigate: Option)
    var
        SalesHeader: Record "Sales Header";
        LinesInstructionMgt: Codeunit "Lines Instruction Mgt.";
        InstructionMgt: Codeunit "Instruction Mgt.";
        DocumentIsScheduledForPosting: Boolean;
        ApplicationAreaMgmtFacade: Codeunit "Application Area Mgmt. Facade";
        DocumentIsPosted: Boolean;
    begin
        if ApplicationAreaMgmtFacade.IsFoundationEnabled then
            LinesInstructionMgt.SalesCheckAllLinesHaveQuantityAssigned(Rec);

        SendToPosting(PostingCodeunitID);

        DocumentIsScheduledForPosting := "Job Queue Status" = "Job Queue Status"::"Scheduled for Posting";
        DocumentIsPosted := (not SalesHeader.Get("Document Type", "No.")) or DocumentIsScheduledForPosting;


        CurrPage.Update(false);

        if PostingCodeunitID <> CODEUNIT::"Sales-Post Modified" then
            exit;

        case Navigate of
            NavigateAfterPost::"Posted Document":
                begin
                    if InstructionMgt.IsEnabled(InstructionMgt.ShowPostedConfirmationMessageCode) then
                        ShowPostedConfirmationMessageMod();

                    if DocumentIsScheduledForPosting then
                        CurrPage.Close();
                end;
            NavigateAfterPost::"New Document":
                if DocumentIsPosted then begin
                    Clear(SalesHeader);
                    SalesHeader.Init();
                    SalesHeader.Validate("Document Type", SalesHeader."Document Type"::Order);
                    SalesHeader.Insert(true);
                    PAGE.Run(PAGE::"Sales Order", SalesHeader);
                end;
        end;
    end;

    local procedure ShowPostedConfirmationMessageMod()
    var
        OrderSalesHeader: Record "Sales Header";
        SalesInvoiceHeader: Record "Sales Invoice Header";
        InstructionMgt: Codeunit "Instruction Mgt.";
        OpenPostedSalesOrderQst: Label 'The order is posted as number %1 and moved to the Posted Sales Invoices window.\\Do you want to open the posted invoice?', Comment = '%1 = posted document number';
    begin
        if not OrderSalesHeader.Get("Document Type", "No.") then begin
            SalesInvoiceHeader.SetRange("No.", "Last Posting No.");
            if SalesInvoiceHeader.FindFirst then
                if InstructionMgt.ShowConfirm(StrSubstNo(OpenPostedSalesOrderQst, SalesInvoiceHeader."No."),
                     InstructionMgt.ShowPostedConfirmationMessageCode)
                then
                    PAGE.Run(PAGE::"Posted Sales Invoice", SalesInvoiceHeader);
        end;
    end;


}
pageextension 50065 "Sales Return Order Ext" extends "Sales Return Order"
{
    layout
    {
        // Add changes to page layout here
        addafter("Assigned User ID")
        {
            field("Branch Code"; Rec."Branch Code")
            {
                ApplicationArea = All;
                Importance = Standard;
            }

        }
        // Add changes to page layout here
        modify("Salesperson Code")
        {
            ShowMandatory = true;
        }
    }

    actions
    {
        // Add changes to page actions here
        modify(Post)
        {
            Visible = false;
        }

        addafter(Post)
        {
            action(PostReturnOrder)
            {
                ApplicationArea = SalesReturnOrder;
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
                    Rec.TestField(Rec."Branch Code");
                    PostDocument(CODEUNIT::"Sales-Post (Yes/No)");
                end;
            }
        }
    }

    var
        DocumentIsPosted: Boolean;
        OpenPostedSalesReturnOrderQst: Label 'The return order is posted as number %1 and moved to the Posted Sales Credit Memos window.\\Do you want to open the posted credit memo?', Comment = '%1 = posted document number';

    local procedure PostDocument(PostingCodeunitID: Integer)
    var
        SalesHeader: Record "Sales Header";
        InstructionMgt: Codeunit "Instruction Mgt.";
    begin
        Rec.SendToPosting(PostingCodeunitID);

        DocumentIsPosted := not SalesHeader.Get(Rec."Document Type", Rec."No.");

        if Rec."Job Queue Status" = Rec."Job Queue Status"::"Scheduled for Posting" then
            CurrPage.Close;
        CurrPage.Update(false);

        if PostingCodeunitID <> CODEUNIT::"Sales-Post (Yes/No)" then
            exit;

        if InstructionMgt.IsEnabled(InstructionMgt.ShowPostedConfirmationMessageCode) then
            ShowPostedConfirmationMessage;
    end;

    local procedure ShowPostedConfirmationMessage()
    var
        ReturnOrderSalesHeader: Record "Sales Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        InstructionMgt: Codeunit "Instruction Mgt.";
    begin
        if not ReturnOrderSalesHeader.Get(Rec."Document Type", Rec."No.") then begin
            SalesCrMemoHeader.SetRange("No.", Rec."Last Posting No.");
            if SalesCrMemoHeader.FindFirst then
                if InstructionMgt.ShowConfirm(StrSubstNo(OpenPostedSalesReturnOrderQst, SalesCrMemoHeader."No."),
                     InstructionMgt.ShowPostedConfirmationMessageCode)
                then
                    PAGE.Run(PAGE::"Posted Sales Credit Memo", SalesCrMemoHeader);
        end;
    end;
}
pageextension 50001 "Cash Receipt Journal Ext" extends "Cash Receipt Journal"
{
    layout
    {
        // Add changes to page layout here
        addafter("Bal. Account No.")
        {

            field("Paid To/Received From"; "Paid To/Received From")
            {
                ApplicationArea = All;
            }
            field("Requested by"; "Requested by")
            {
                ApplicationArea = All;
            }
            field("Authorised by"; "Authorised by")
            {
                ApplicationArea = All;
            }
            field("Approved by"; "Approved by")
            {
                ApplicationArea = All;
            }
            field("Reviewed by"; "Reviewed by")
            {
                ApplicationArea = All;
            }
            field("GL Name"; "GL Name")
            {
                ApplicationArea = All;

            }
        }
    }

    actions
    {
        // Add changes to page actions here
        addfirst("P&osting")
        {
            /* action("Post Receipt")
             {
                 ApplicationArea = All;
                 Promoted = true;
                 PromotedCategory = Process;
                 PromotedIsBig = true;
                 Image = PostedOrder;
                 trigger OnAction()
                 var
                     DocumentNoMinMax: Code[40];
                     Filter: Code[255];
                 begin
                     Filter := GETFILTER("Document No.");
                     InsertReceipt();
                     CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post", Rec);
                     CurrentJnlBatchName := GETRANGEMAX("Journal Batch Name");
                     CurrPage.UPDATE(FALSE);
                     ChangeReceiptStatus(FALSE, Filter);
                 end;
             }*/

            action("Print Receipt")
            {
                ApplicationArea = Basic, Suite;
                Promoted = true;
                PromotedCategory = Category6;
                PromotedIsBig = true;
                Image = PostPrint;
                trigger OnAction()
                var
                    DocNo: Code[20];
                    AppManagement: Codeunit "Approvals Mgmt.";
                    InternalReceipt: Report "Internal Receipt";
                    JournalTemplate: Code[10];
                    JournalBatch: Code[10];
                    Receipt: Record "Voucher And Receipt";
                    PostingDate: Date;
                    GenJnlBatch: Record "Gen. Journal Batch";
                    DocumentNoMinMax: Code[40];
                    Filter: Code[255];
                begin
                    GenJournalLine.COPY(Rec);
                    DocNo := "Document No.";
                    JournalBatch := "Journal Batch Name";
                    PostingDate := "Posting Date";
                    TransferJournalToReceipt(Rec);
                    COMMIT;
                    InternalReceipt.SetPrintDocumentNo(DocNo);
                    InternalReceipt.RUN;
                    CurrentJnlBatchName := GETRANGEMAX("Journal Batch Name");

                    SETRANGE("Document No.");
                    SETRANGE("Posting Date");
                    SETRANGE("Journal Template Name", "Journal Template Name");
                    SETRANGE("Journal Batch Name", CurrentJnlBatchName);
                end;
            }
        }
    }

    var
        CurrentJnlBatchName: Code[10];
        SalesHeader: Record "Loan and Advance Header";
        DocumentNo: Code[20];
        GenJournalLine: Record "Gen. Journal Line";
        SalesCommentLine: Record "Voucher And Receipt";
        UserSetup: Record "User Setup";
        GenBatch: Record "Gen. Journal Batch";
        JournalBatch: Record "Gen. Journal Batch";
        ASL001: Label 'Your not Allow to Access %1 Journal. Please Contact Your Administrator.';


    trigger OnOpenPage()
    begin
        JournalBatch.Reset();
        JournalBatch.SetRange(JournalBatch.Name, Rec."Journal Batch Name");
        if JournalBatch.FindFirst() then begin
            if JournalBatch."Batch User" <> '' then begin
                if JournalBatch."Batch User" <> UserId then begin
                    Error(ASL001, JournalBatch.Name);
                end;
            end;
        end;
    end;
}
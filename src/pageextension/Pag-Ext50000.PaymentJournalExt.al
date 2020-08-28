pageextension 50000 "Payment Journal Ext" extends "Payment Journal"
{
    layout
    {
        // Add changes to page layout here
        addafter("Bal. Account No.")
        {
            field("Line No."; "Line No.")
            {
                ApplicationArea = All;
                Editable = false;
            }

            field("FA Posting Type"; "FA Posting Type")
            {
                ApplicationArea = All;
            }

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
            //Print Voucher
            action("Print Voucher")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Category8;
                PromotedIsBig = true;
                Image = PrintCheck;
                trigger OnAction()
                var
                    DocNo: Code[20];
                    PaymentVoucher: Report "Payment Voucher";
                    SalesCommentLine: Record "Voucher And Receipt";
                    GenJnlBatch: Record "Gen. Journal Batch";
                    JournalBatch: Code[10];
                    PostingDate: Date;
                    Voucher: Integer;
                    CurrentJnlBatchName: Code[10];
                    GenJournalLine: Record "Gen. Journal Line";
                    UserSetup: Record "User Setup";
                    GJourlines: Record "Gen. Journal Line";
                    TotalAmount: Decimal;
                    countNumber: Integer;
                begin
                    countNumber := 0;
                    TotalAmount := 0;
                    CurrentJnlBatchName := GETRANGEMAX("Journal Batch Name");
                    GenJournalLine.COPY(Rec);
                    DocNo := GenJournalLine."Document No.";
                    JournalBatch := GenJournalLine."Journal Batch Name";
                    PostingDate := GenJournalLine."Posting Date";
                    //SalesCommentLine.CopyJournalToVoucher(GenJournalLine);

                    TransferJournalToVoucher(GenJournalLine);
                    COMMIT;
                    PaymentVoucher.SetPrintDocumentNo(DocNo);
                    PaymentVoucher.RUN;

                    GenJournalLine.RESET;
                    GenJournalLine.SETRANGE("Document No.", DocNo);
                    IF GenJournalLine.FINDSET THEN
                        REPEAT
                        BEGIN
                            GenJournalLine.Printed := TRUE;
                            GenJournalLine.MODIFY;
                        END;
                        UNTIL GenJournalLine.NEXT = 0;

                    SETRANGE("Document No.");
                    SETRANGE("Posting Date");
                    SETRANGE("Journal Template Name", "Journal Template Name");
                    SETRANGE("Journal Batch Name", CurrentJnlBatchName);
                end;
            }
        }
    }

    var
        myInt: Integer;
}
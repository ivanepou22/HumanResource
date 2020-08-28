report 50010 "Inventory Issue Note"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'InventoryIssueNote.rdl';

    dataset
    {
        dataitem("Sales Comment Line"; "Voucher And Receipt")
        {

            Column(CompanyInfo_Name; CompanyInfo.Name) { }
            Column(CompanyInfo_Address; CompanyInfo.Address) { }
            Column(CompanyInfo_City; CompanyInfo.City) { }
            Column(CompanyInfo_PhoneNo; CompanyInfo."Phone No.") { }
            Column(CompanyInfo_EMail; CompanyInfo."E-Mail") { }
            Column(CompanyInfo_HomePage; CompanyInfo."Home Page") { }
            Column(CompanyInfo_Picture; CompanyInfo.Picture) { }
            Column(Activity_Name; ActivityName) { }
            Column(JournalTemplateName_ItemJournalLine; "Sales Comment Line"."Journal Template Name") { }
            Column(JournalBatchName_ItemJournalLine; "Sales Comment Line"."Journal Batch Name") { }
            Column(LineNo_ItemJournalLine; "Sales Comment Line"."Line No.") { }
            Column(ItemNo_ItemJournalLine; "Sales Comment Line".Item) { }
            Column(PostingDate_ItemJournalLine; "Sales Comment Line"."Posting Date") { }
            Column(DocumentNo_ItemJournalLine; "Sales Comment Line"."No.") { }
            Column(Description_ItemJournalLine; "Sales Comment Line".Description) { }
            Column(DocumentDate_ItemJournalLine; "Sales Comment Line"."Document Date") { }
            Column(DocumentLineNo_ItemJournalLine; "Sales Comment Line"."Document Line No.") { }
            Column(LocationCode_ItemJournalLine; "Sales Comment Line".Branch) { }
            Column(Quantity_ItemJournalLine; "Sales Comment Line"."Item Quantity") { }
            Column(Amount_ItemJournalLine; "Sales Comment Line".Amount) { }
            Column(ShortcutDimension1Code_ItemJournalLine; "Sales Comment Line"."Shortcut Dimension 1 Code") { }
            Column(ShortcutDimension2Code_ItemJournalLine; "Sales Comment Line"."Shortcut Dimension 2 Code") { }
            Column(DocumentType_ItemJournalLine; "Sales Comment Line"."Document Type") { }
            Column(UnitofMeasureCode_ItemJournalLine; "Sales Comment Line"."Unit of Measure Code") { }
            Column(Approvers_1; Approvers[1]) { }
            Column(Approvers_2; Approvers[2]) { }
            Column(Approvers_3; Approvers[3]) { }
            Column(Approvers_4; Approvers[4]) { }
            Column(ApprovalDate_1; ApprovalDate[1]) { }
            Column(ApprovalDate_2; ApprovalDate[2]) { }
            Column(ApprovalDate_3; ApprovalDate[3]) { }
            Column(ApprovalDate_4; ApprovalDate[4]) { }

            //===========================
            trigger OnPreDataItem()
            begin
                "Sales Comment Line".SETRANGE("No.", ReceiptNo);
            end;

            //==========================
            trigger OnAfterGetRecord()
            var
                myInt: Integer;
            begin
                ApprovalEntry.RESET;
                ApprovalEntry.SETRANGE("Document No.", "Sales Comment Line"."No.");
                ApprovalEntry.SETRANGE(Status, ApprovalEntry.Status::Approved);
                IF ApprovalEntry.FINDFIRST THEN BEGIN
                    I := 1;
                    REPEAT
                        Approvers[I] := COPYSTR(ApprovalEntry."Approver ID", (STRPOS(ApprovalEntry."Approver ID", '\') + 1));
                        ApprovalDate[I] := ApprovalEntry."Last Date-Time Modified";
                        I += 1;
                    UNTIL ApprovalEntry.NEXT = 0;
                END;
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

        CompanyInfo: Record "Company Information";
        FormatAddr: Codeunit "Format Address";
        CompanyAddr: array[8] of Text[50];
        VendorInfo: Record Vendor;
        VendorName: Text[50];
        DimValue: Record "Dimension Value";
        ActivityName: Text[100];
        ReceiptNo: Code[20];
        ApprovalEntry: Record "Approval Entry";
        ApprovalDate: array[8] of DateTime;
        Approvers: array[8] of Code[20];
        I: Integer;

    //============================================
    trigger OnPreReport()
    begin
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(CompanyInfo.Picture);
    end;

    //==============================================
    procedure SetDocumentNo(DocumentNo: Code[20])
    begin
        ReceiptNo := DocumentNo;
    end;

}
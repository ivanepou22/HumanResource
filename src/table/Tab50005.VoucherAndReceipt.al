//In place of Sales CommentLine
table 50005 "Voucher And Receipt"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Document Type"; Option)
        {
            OptionMembers = Quote,Order,Invoice,"Credit Memo","Blanket Order","Return Order",Shipment,"Posted Invoice","Posted Credit Memo","Posted Return Receipt","Payment Voucher","Internal Receipt","Item Mapping",Make,Model,Destination,"Vehicle Location","Driver Incidence","Fleet Voucher",Incidence,"Body Type","Vehicle Type",Receipt,"Store Voucher","Asset Classification","Accountability Expense",Drawer;
        }
        field(2; "No."; Code[20]) { }
        field(3; "Line No."; Integer) { }
        field(4; Date; Date) { }
        field(5; Code; Code[10]) { }
        field(6; Comment; Text[80]) { }
        field(7; "Document Line No."; Integer) { }
        field(50000; "Posting Date"; Date) { }
        field(50010; "Document Date"; Date) { }
        field(50020; "External Doc. No."; Code[20]) { }
        field(50030; "Requested by"; Text[100]) { }
        field(50040; "Received by"; Text[100]) { }
        field(50045; "Reviewed by"; Text[100]) { }
        field(50050; "Authorised by"; Text[100]) { }
        field(50060; "Account Type"; Option)
        {
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";
        }
        field(50070; "Account No."; Code[20]) { }
        field(50080; Description; Text[100]) { }
        field(50090; Amount; Decimal) { }
        field(50100; "Amount (LCY)"; Decimal) { }
        field(50105; "WHT Amount"; Decimal) { }
        field(50110; "Bal. Account Type"; Option)
        {
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";
        }
        field(50120; "Bal. Account No."; Code[20]) { }
        field(50130; "Shortcut Dimension 1 Code"; Code[30])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(50140; "Shortcut Dimension 2 Code"; Code[30])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(50141; "Shortcut Dimension 3 Code"; Code[30])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3));
        }
        field(50150; "Journal Template Name"; Code[20]) { }
        field(50160; "Journal Batch Name"; Code[20]) { }
        field(50170; "Currency Code"; Code[10]) { }
        field(50180; "Currency Factor"; Decimal) { }
        field(50190; Posted; Boolean) { }
        field(50200; "Payment Method"; Code[10]) { }
        field(50210; User; Code[50])
        {
            TableRelation = "User Setup"."User ID";
        }
        field(50215; "Dimension Set ID"; Integer)
        {
            TableRelation = "Dimension Set Entry";
        }
        field(50220; Make; Code[20])
        {
            TableRelation = "Voucher And Receipt"."No." WHERE("Document Type" = CONST(Make));
        }
        field(50230; Center; Code[20]) { }
        field(50240; Distance; Decimal) { }
        field(50250; "Voucher Type"; Option)
        {
            OptionMembers = " ",Maintainance,Fuel;
        }
        field(50260; "Fuel Worth(Ltrs)"; Integer) { }
        field(50270; "Fuel Worht(LCY)"; Decimal) { }
        field(50280; "Maintenance Worth(LCY)"; Decimal) { }
        field(50290; Used; Boolean) { }
        field(50300; Driver; Code[20]) { }
        field(50310; "Date Filter"; Date) { }
        field(50320; "Vehicle No"; Code[20]) { }
        field(50330; "No. Series"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(50340; "Body Type"; Code[20])
        {
            TableRelation = "Voucher And Receipt"."No." WHERE("Document Type" = CONST("Body Type"));
        }
        field(50350; "Vehicle Type"; Code[20])
        {
            TableRelation = "Voucher And Receipt"."No." WHERE("Document Type" = CONST("Vehicle Type"));
        }
        field(50360; "Date Create"; Date) { }
        field(50370; "Last Date Modified"; Date) { }
        field(50380; "Created By"; Code[20])
        {
            TableRelation = User."User Name";
        }
        field(50390; "Last Modified By"; Code[20])
        {
            TableRelation = User."User Name";
        }
        field(50400; Item; Code[20])
        {
            TableRelation = Item."No.";
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                CALCFIELDS("Available Quantity");
            end;
        }
        field(50405; "Item Description"; Text[50])
        {
            FieldClass = FlowField;
            CalcFormula = Min (Item.Description WHERE("No." = FIELD(Item)));
        }
        field(50407; "Unit Cost"; Decimal) { }
        field(50410; "Available Quantity"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum ("Item Ledger Entry"."Remaining Quantity" WHERE("Item No." = FIELD(Item), "Location Code" = FIELD(Branch), "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"), "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter")));
        }
        field(50415; "Unit of Measure Code"; Code[10])
        {
            TableRelation = "Item Unit of Measure".Code WHERE("Item No." = FIELD(Item));

            trigger OnValidate()
            var
                myInt: Integer;
            begin
                CALCFIELDS("Available Quantity");
            end;

        }
        field(50420; Branch; Code[20])
        {
            TableRelation = Location.Code;

            trigger OnValidate()
            var
                myInt: Integer;
            begin
                CALCFIELDS("Available Quantity");
            end;
        }
        field(50425; Price; Decimal) { }
        field(50430; "Global Dimension 1 Filter"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            var
                myInt: Integer;
            begin
                CALCFIELDS("Available Quantity");
            end;
        }
        field(50435; "Global Dimension 2 Filter"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(50440; "Location Filter"; Code[10])
        {
            TableRelation = Location;
        }
        field(50445; "Branch Bank"; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = Min ("Bank Account"."No." WHERE("Global Dimension 1 Code" = FIELD("Shortcut Dimension 1 Code")));
        }
        field(50450; "Approved by"; Code[50])
        {
            TableRelation = "User Setup"."User ID";
        }
        field(50455; "Prepared by"; Code[50])
        {
            TableRelation = "User Setup"."User ID";
        }
        field(50456; "Applied Invoices"; Text[250]) { }
        field(50460; "Item Journal Template Name"; Code[10])
        {
            TableRelation = "Item Journal Template";
        }
        field(50470; "Item Journal Batch Name"; Code[10])
        {
            TableRelation = "Item Journal Batch".Name WHERE("Journal Template Name" = FIELD("Journal Template Name"));
        }
        field(50480; "Item Quantity"; Decimal) { }
        field(50490; "To Post"; Boolean) { }
    }

    keys
    {
        key(PK; "Document Type", "No.", "Document Line No.", "Line No.", Amount, "Amount (LCY)")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;
        DimMgt: Codeunit DimensionManagement;
        SalesSetup: Record "Sales & Receivables Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

    //-----------------------------------
    procedure SetUpNewLine()
    var
        myInt: Integer;
        VoucherReceipt: Record "Voucher And Receipt";
    begin

        VoucherReceipt.SETRANGE("Document Type", "Document Type");
        VoucherReceipt.SETRANGE("No.", "No.");
        VoucherReceipt.SETRANGE("Document Line No.", "Document Line No.");
        VoucherReceipt.SETRANGE(Date, WORKDATE);
        IF NOT VoucherReceipt.FINDFIRST THEN
            Date := WORKDATE;
    end;

    //------------------------------------
    procedure CopyComments(FromDocumentType: Integer;
       ToDocumentType: Integer;
       FromNumber: Code[20];
       ToNumber: Code[20])
    var
        myInt: Integer;
        VoucherReceipt: Record "Voucher And Receipt";
        VoucherReceipt1: Record "Voucher And Receipt";
    begin

        VoucherReceipt.SETRANGE("Document Type", FromDocumentType);
        VoucherReceipt.SETRANGE("No.", FromNumber);
        IF VoucherReceipt.FINDSET THEN
            REPEAT
                VoucherReceipt1 := VoucherReceipt;
                VoucherReceipt1."Document Type" := ToDocumentType;
                VoucherReceipt1."No." := ToNumber;
                VoucherReceipt1.INSERT;
            UNTIL VoucherReceipt.NEXT = 0;
    end;

    //-------------------------------------
    procedure DeleteComments(DocType: Option; DocNo: Code[20])
    var
        myInt: Integer;
    begin
        SETRANGE("Document Type", DocType);
        SETRANGE("No.", DocNo);
        IF NOT ISEMPTY THEN
            DELETEALL;
    end;

    //--------------------------------------
    procedure ShowComments(DocType: Option;
       DocNo: Code[20];
       DocLineNo: Integer)
    var
        myInt: Integer;
        SalesCommentSheet: Page "Sales Comment Sheet";
    begin

        SETRANGE("Document Type", DocType);
        SETRANGE("No.", DocNo);
        SETRANGE("Document Line No.", DocLineNo);
        CLEAR(SalesCommentSheet);
        SalesCommentSheet.SETTABLEVIEW(Rec);
        SalesCommentSheet.RUNMODAL;
    end;

    //--------------------------------------
    procedure UpdatePostedVoucher(DocumentNo: Code[20];
           JnlBatch: Code[10];
           PostingDate: Date)
    var
        myInt: Integer;
        GlEntry: Record "G/L Entry";
    begin
        GlEntry.RESET;
        GlEntry.SETRANGE("Document No.", DocumentNo);
        GlEntry.SETRANGE("Journal Batch Name", JnlBatch);
        GlEntry.SETRANGE("Posting Date", PostingDate);
        IF GlEntry.FINDFIRST THEN BEGIN
            SETRANGE("Document Type", "Document Type"::"Payment Voucher");
            SETRANGE("No.", DocumentNo);
            IF FINDFIRST THEN
                REPEAT
                    Posted := TRUE;
                    MODIFY;
                    COMMIT;
                UNTIL NEXT = 0;
        END;
    end;

    //-------------------------------------
    procedure ShowDimensions()
    var
        myInt: Integer;
    begin

        "Dimension Set ID" :=
          DimMgt.EditDimensionSet(
            "Dimension Set ID", STRSUBSTNO('%1 %2 %3', "Journal Template Name", "Journal Batch Name", "Line No."),
            "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
    end;

    //----------------------------------
    procedure ValidateShortcutDimCode(FieldNumber: Integer; VAR ShortcutDimCode: Code[20])
    var
        myInt: Integer;
    begin
        //TESTFIELD("Check Printed",FALSE);
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
    end;


    //-------------------------------
    procedure UpdateItemPostedVoucher(DocumentNo: Code[20];
        JnlBatch: Code[10];
        PostingDate: Date)
    var
        myInt: Integer;
        GlEntry: Record "G/L Entry";
    begin
        GlEntry.RESET;
        GlEntry.SETRANGE("Document No.", DocumentNo);
        GlEntry.SETRANGE("Journal Batch Name", JnlBatch);
        GlEntry.SETRANGE("Posting Date", PostingDate);
        IF GlEntry.FINDFIRST THEN BEGIN
            SETRANGE("Document Type", "Document Type"::"Store Voucher");
            SETRANGE("No.", DocumentNo);
            IF FINDFIRST THEN
                REPEAT
                    Posted := TRUE;
                    MODIFY;
                    COMMIT;
                UNTIL NEXT = 0;
        END;
    end;


    //---------------------------------------
    procedure CopyJournalToVoucher(GenJournalLine: Record "Gen. Journal Line")
    var
        VoucherLines: Record "Voucher And Receipt";
        ReceiptLine: Record "Voucher And Receipt";
        GeneralJournal: Record "Gen. Journal Line";
        JournalLine: Record "Gen. Journal Line";
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        LineNo: Integer;
        InvoiceArray: array[10] of Code[20];
        Invoices: Code[250];
        I: Integer;
        J: Integer;
        K: Integer;
        L: Integer;
        M: Integer;

    begin
        VoucherLines.RESET;
        VoucherLines.SETRANGE("Document Type", VoucherLines."Document Type"::"Payment Voucher");
        VoucherLines.SETRANGE("No.", GenJournalLine."Document No.");
        IF NOT VoucherLines.FINDFIRST THEN BEGIN
            GeneralJournal.RESET;
            GeneralJournal.SETRANGE("Document No.", GenJournalLine."Document No.");
            IF GeneralJournal.FINDFIRST THEN BEGIN
                // Create the Receipt Header
                VoucherLines.INIT;
                VoucherLines."Document Type" := VoucherLines."Document Type"::Receipt;
                VoucherLines."No." := GeneralJournal."Document No.";
                VoucherLines."Received by" := GeneralJournal."Paid To/Received From";
                VoucherLines."Posting Date" := GeneralJournal."Posting Date";
                VoucherLines.Description := GeneralJournal.Description;
                VoucherLines."Journal Template Name" := GeneralJournal."Journal Template Name";
                VoucherLines."Journal Batch Name" := GeneralJournal."Journal Batch Name";
                VoucherLines."WHT Amount" := GeneralJournal."WHT Amount";

                FOR K := 1 TO 10 DO BEGIN
                    InvoiceArray[K] := '';
                END;
                Invoices := '';

                VendorLedgerEntry.RESET;
                VendorLedgerEntry.SETFILTER(VendorLedgerEntry.Amount, '<>0');
                VendorLedgerEntry.SETRANGE(VendorLedgerEntry."Applies-to ID", GeneralJournal."Document No.");
                IF VendorLedgerEntry.FINDFIRST THEN BEGIN
                    I := 1;
                    Invoices := '';
                    REPEAT
                        //Invoices := CustLedgerEntry."Document No.";
                        InvoiceArray[I] := VendorLedgerEntry."Document No.";
                        //ERROR(InvoiceArray[I] + CustLedgerEntry."Document No.");
                        //Invoices += InvoiceArray[I];
                        I += 1;
                    UNTIL VendorLedgerEntry.NEXT = 0;
                    FOR L := 1 TO 10 DO BEGIN
                        //Invoices += InvoiceArray[L];
                    END;
                    VoucherLines."Applied Invoices" := InvoiceArray[1] + '  ' + InvoiceArray[2] + '  ' + InvoiceArray[3] + '  ' + InvoiceArray[4] + '  '
                                                        + InvoiceArray[5] + '  ' + InvoiceArray[6] + '  ' + InvoiceArray[7] + '  ' + InvoiceArray[8]
                                                        + '  ' + InvoiceArray[9] + '  ' + InvoiceArray[10];
                END ELSE BEGIN // Get Applied Invoices from the General Journal Line
                    JournalLine.RESET;
                    JournalLine.SETRANGE(JournalLine."Journal Template Name", GeneralJournal."Journal Template Name");
                    JournalLine.SETRANGE(JournalLine."Journal Batch Name", GeneralJournal."Journal Batch Name");
                    JournalLine.SETRANGE(JournalLine."Document No.", GeneralJournal."Document No.");
                    JournalLine.SETFILTER(JournalLine."Applies-to Doc. No.", '<>%1', '');
                    IF JournalLine.FINDFIRST THEN BEGIN
                        J := 1;
                        REPEAT
                            InvoiceArray[J] := JournalLine."Applies-to Doc. No." + ' ';
                            J += 1;
                        UNTIL JournalLine.NEXT = 0;
                        FOR M := 1 TO 10 DO BEGIN
                            //Invoices += InvoiceArray[M] + ', ';
                        END;
                        VoucherLines."Applied Invoices" := InvoiceArray[1] + '  ' + InvoiceArray[2] + '  ' + InvoiceArray[3] + '  ' + InvoiceArray[4]
                                                            + '  ' + InvoiceArray[5] + '  ' + InvoiceArray[6] + '  ' + InvoiceArray[7] + '  ' +
                                                            InvoiceArray[8] + '  ' + InvoiceArray[9] + '  ' + InvoiceArray[10];
                    END;
                END;
                VoucherLines.INSERT;
                REPEAT
                    LineNo += 10000;
                    // Create the Receipt Lines
                    VoucherLines.INIT;
                    VoucherLines."Document Type" := ReceiptLine."Document Type"::"Payment Voucher";
                    //VoucherLines."Document No."        := GeneralJournal."Document No.";
                    //VoucherLines."Line No."            := LineNo;
                    //VoucherLines."Receipt Line Amount" := ABS(GeneralJournal.Amount);
                    //ReceiptLine."Applies-to Code"
                    //VoucherLines."Slip No."            := GeneralJournal."External Document No.";
                    //VoucherLines."Receipt Description" := GeneralJournal.Description;
                    //VoucherLines."Payment Method"      := GeneralJournal."Payment Method Code";
                    //VoucherLines."Account Type"        := GeneralJournal."Account Type";
                    //VoucherLines."Account No."         := GeneralJournal."Account No.";
                    VoucherLines."Bal. Account Type" := GeneralJournal."Bal. Account Type";
                    VoucherLines."Bal. Account No." := GeneralJournal."Bal. Account No.";
                    VoucherLines."WHT Amount" := GeneralJournal."WHT Amount";
                    VoucherLines.INSERT;
                UNTIL GeneralJournal.NEXT = 0;
            END;
        END;
    end;

}
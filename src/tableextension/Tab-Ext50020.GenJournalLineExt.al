tableextension 50020 "Gen. Journal Line Ext" extends "Gen. Journal Line"
{
    fields
    {
        // Add changes to table fields here
        field(50030; "Branch Code"; Code[50])
        {
            TableRelation = Confidential.Code where(Type = const(Branch));
        }
        field(50080; "WHT Amount"; Decimal) { }
        field(50500; "Authorised by"; Text[100]) { }
        field(50510; "Paid To/Received From"; Text[50]) { }
        field(50520; "Requested by"; Text[100]) { }
        field(50525; "Reviewed by"; Text[100]) { }
        field(50540; "Approved by"; Code[100])
        {
            TableRelation = "User Setup"."User ID";
        }
        field(50541; "GL Name"; Text[100]) { }
        field(50545; "Prepared by"; Code[50])
        {
            TableRelation = "User Setup"."User ID";
        }
        field(50600; "HR Account"; Boolean) { }
        field(50650; "Loan No."; Code[20]) { }
        field(50790; "Paid To / By"; Text[50]) { }
        field(50800; "Booking No."; Code[20])
        {
            TableRelation = "Sales Header"."No." WHERE("Document Type" = FILTER(Quote));
        }
        field(50810; "Voucher Document No."; Code[20])
        {
            TableRelation = "Voucher And Receipt"."No." WHERE("Document Type" = CONST("Payment Voucher"), Posted = CONST(true));
        }
        field(50820; "Total Expenses"; Decimal) { }
        field(50830; "Budgeted Amount"; Decimal)
        {

        }
        field(50840; "Budgeted Balance"; Decimal) { }
        field(50850; "Total Budgeted Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum ("G/L Budget Entry".Amount WHERE("G/L Account No." = FIELD("Account No."), "Global Dimension 1 Code" = FIELD("Shortcut Dimension 1 Code"), "Global Dimension 2 Code" = FIELD("Shortcut Dimension 2 Code")));
        }
        field(50860; Printed; Boolean) { }
        field(50870; "Requisition No."; Code[20])
        {
            TableRelation = "Purchase Header"."No." WHERE("Document Type" = CONST(Quote));
        }
        field(50871; "Contract Purch. Agreement No."; Code[20]) { }
        field(50872; "Certificate No."; Code[20]) { }
        field(50873; "LPA No."; Code[20]) { }
        field(50874; "Budget Change Type"; Option)
        {
            OptionMembers = " ","Re-allocation",Virement;
        }
        field(50875; "Budget Name"; Code[10])
        {
            TableRelation = "G/L Budget Name";
        }
        field(50900; "Loan Transaction Type"; Option)
        {
            OptionMembers = " ","Loan Receipt","Loan Repayment","Interest Payment";
        }
        field(51000; "Shortcut Dimension 3 Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3));
        }
        field(51010; "Shortcut Dimension 4 Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4));
        }
        field(51020; "Shortcut Dimension 5 Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5));
        }
        field(51030; "Shortcut Dimension 6 Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6));
        }
        field(51040; "Shortcut Dimension 7 Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(7));
        }
        field(51050; "Shortcut Dimension 8 Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(8));
        }
        field(51051; "Activity Total Budget"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum ("G/L Budget Entry".Amount WHERE("Global Dimension 1 Code" = FIELD("Shortcut Dimension 1 Code"), "Global Dimension 2 Code" = FIELD("Shortcut Dimension 2 Code")));
        }
        field(51052; "Activity Total Expense"; Decimal)
        {
        }
        field(51053; "Activity Budget Balance"; Decimal) { }
        field(51054; "Activity Budgeted Amount"; Decimal) { }
    }

    var
        GLBudgetEntryTemp: Record "G/L Budget Entry";
        GLBudgetEntryTemp2: Record "G/L Budget Entry";
        GeneralJournal: Record "Gen. Journal Line";
        JournalLine: Record "Gen. Journal Line";
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        LineNo: Integer;
        InvoiceArray: array[300] of Code[20];
        Invoices: Code[250];
        I: Integer;
        J: Integer;
        K: Integer;
        L: Integer;
        M: Integer;
        CustomerLedgerEntry: Record "Cust. Ledger Entry";
        GLBudgetEntry1: Record "G/L Budget Entry";
        GLEntry1: Record "G/L Entry";
        GLEntry2: Record "G/L Entry";
        ATotalBudget: Decimal;
        ATotalExpenses: Decimal;
        ATotalBudgetBalance: Decimal;
        GLBudgetEntry2: Record "G/L Budget Entry";

    trigger OnInsert()
    var
        myInt: Integer;
        GLAccount: Record "G/L Account";
    begin
        if "Account Type" = "Account Type"::"G/L Account" then begin
            GLAccount.Reset();
            GLAccount.SetRange(GLAccount."No.", "Account No.");
            if GLAccount.FindFirst then
                Validate("GL Name", GLAccount.Name);
        end;

        "Prepared by" := UserId;
    end;


    //--------------------------------------------
    procedure TransferJournalToVoucher(GenJnlLine: Record "Gen. Journal Line")
    var
        PaymentVoucher: Record "Voucher And Receipt";
        PaymentVoucher1: Record "Voucher And Receipt";
        PaymentVoucher2: Record "Voucher And Receipt";
        PaymentVoucher3: Record "Voucher And Receipt";
        DimensionSetEntry: Record "Dimension Set Entry";
        LineNo: Integer;
    begin
        PaymentVoucher3.RESET;
        PaymentVoucher3.SetRange(PaymentVoucher3."Document Type", PaymentVoucher3."Document Type"::"Payment Voucher");
        PaymentVoucher3.SetRange(PaymentVoucher3."Journal Template Name", GenJnlLine."Journal Template Name");
        PaymentVoucher3.SetRange(PaymentVoucher3."Journal Batch Name", GenJnlLine."Journal Batch Name");
        PaymentVoucher3.SetRange(PaymentVoucher3."No.", GenJnlLine."Document No.");
        IF PaymentVoucher3.FINDSET THEN
            REPEAT
                PaymentVoucher3.DELETEALL;
            UNTIL PaymentVoucher3.NEXT = 0;

        PaymentVoucher2.RESET;
        PaymentVoucher2.SetRange(PaymentVoucher2."Document Type", PaymentVoucher2."Document Type"::"Payment Voucher");
        PaymentVoucher2.SetRange(PaymentVoucher2."Journal Template Name", GenJnlLine."Journal Template Name");
        PaymentVoucher2.SetRange(PaymentVoucher2."Journal Batch Name", GenJnlLine."Journal Batch Name");
        PaymentVoucher2.SetRange(PaymentVoucher2."No.", GenJnlLine."Document No.");
        IF NOT PaymentVoucher2.FINDFIRST THEN BEGIN
            RESET;
            SetRange("Journal Template Name", GenJnlLine."Journal Template Name");
            SetRange("Journal Batch Name", GenJnlLine."Journal Batch Name");
            SetRange("Document No.", GenJnlLine."Document No.");
            IF FINDFIRST THEN
                REPEAT
                    PaymentVoucher1.RESET;
                    PaymentVoucher1.SetFilter("No.", '=%1', GenJnlLine."Document No.");
                    PaymentVoucher1.SetFilter("Line No.", '<>%1', 0);
                    IF PaymentVoucher1.FINDLAST THEN
                        LineNo := PaymentVoucher1."Line No." + 10000
                    ELSE
                        LineNo := 10000;
                    //
                    FOR K := 1 TO 10 DO BEGIN
                        InvoiceArray[K] := '';
                    END;
                    Invoices := '';
                    /*
                       { VendorLedgerEntry.RESET;
                        VendorLedgerEntry.SetFilter(VendorLedgerEntry.Amount,'<>0');
                        VendorLedgerEntry.SetRange(VendorLedgerEntry."Applies-to ID", GenJnlLine."Document No.");
                        IF VendorLedgerEntry.FINDFIRST THEN BEGIN
                          I := 1;
                          Invoices := '';
                          REPEAT
                            //Invoices := VendorLedgerEntry."Document No.";
                            InvoiceArray[I] := VendorLedgerEntry."Document No.";
                            I += 1;
                          UNTIL VendorLedgerEntry.NEXT = 0;
                          FOR L := 1 TO 10 DO BEGIN
                            //Invoices += InvoiceArray[L];
                          END;
                          PaymentVoucher."Applied Invoices" := InvoiceArray[1]+'  '+InvoiceArray[2]+'  '+InvoiceArray[3]+'  '+InvoiceArray[4]+'  '
                                                              +InvoiceArray[5]+'  '+InvoiceArray[6]+'  '+InvoiceArray[7]+'  '+InvoiceArray[8]
                                                              +'  '+InvoiceArray[9]+'  '+InvoiceArray[10];
                        END ELSE BEGIN // Get Applied Invoices from the General Journal Line
                          GenJnlLine.RESET;
                          GenJnlLine.SetRange(GenJnlLine."Journal Template Name", GeneralJournal."Journal Template Name");
                          GenJnlLine.SetRange(GenJnlLine."Journal Batch Name", GeneralJournal."Journal Batch Name");
                          GenJnlLine.SetRange(GenJnlLine."Document No.", GeneralJournal."Document No.");
                          GenJnlLine.SetFilter(GenJnlLine."Applies-to Doc. No.", '<>%1', '');
                          IF GenJnlLine.FINDFIRST THEN BEGIN
                            J := 1;
                            REPEAT
                              InvoiceArray[J] := JournalLine."Applies-to Doc. No." + ' ';
                              J += 1;
                            UNTIL GenJnlLine.NEXT = 0;
                            FOR M := 1 TO 10 DO BEGIN
                              //Invoices += InvoiceArray[M] + ', ';
                            END;
                            PaymentVoucher."Applied Invoices" := InvoiceArray[1]+'  '+InvoiceArray[2]+'  '+InvoiceArray[3]+'  '+InvoiceArray[4]
                                                                +'  '+InvoiceArray[5]+'  '+InvoiceArray[6]+'  '+InvoiceArray[7]+'  '+
                                                                InvoiceArray[8]+'  '+InvoiceArray[9]+'  '+InvoiceArray[10];
                          END;
                        END;
                        }*/
                    //customer applied entries

                    //
                    PaymentVoucher.INIT;
                    PaymentVoucher.Validate(PaymentVoucher."Document Type", PaymentVoucher."Document Type"::"Payment Voucher");
                    PaymentVoucher.Validate(PaymentVoucher."No.", "Document No.");
                    PaymentVoucher.Validate(PaymentVoucher."Document Line No.", 0);
                    PaymentVoucher.Validate(PaymentVoucher."Line No.", LineNo);
                    PaymentVoucher.Validate(PaymentVoucher.Date, WORKDATE);
                    PaymentVoucher.Validate(PaymentVoucher.Code, '');
                    PaymentVoucher.Validate(PaymentVoucher.Comment, '');
                    PaymentVoucher.Validate(PaymentVoucher."Posting Date", "Posting Date");
                    PaymentVoucher.Validate(PaymentVoucher."Document Date", "Document Date");
                    PaymentVoucher.Validate(PaymentVoucher."External Doc. No.", "External Document No.");
                    PaymentVoucher.Validate(PaymentVoucher."Requested by", "Requested by");
                    PaymentVoucher.Validate(PaymentVoucher."Received by", "Paid To/Received From");
                    PaymentVoucher.Validate(PaymentVoucher."Reviewed by", "Reviewed by");
                    PaymentVoucher.Validate(PaymentVoucher."Authorised by", "Authorised by");
                    PaymentVoucher.Validate(PaymentVoucher.Description, Description);
                    PaymentVoucher.Validate(PaymentVoucher."Account Type", "Account Type");
                    PaymentVoucher.Validate(PaymentVoucher."Account No.", "Account No.");
                    PaymentVoucher.Validate(PaymentVoucher.Amount, Amount);
                    PaymentVoucher.Validate(PaymentVoucher."Amount (LCY)", "Amount (LCY)");
                    PaymentVoucher.Validate(PaymentVoucher."WHT Amount", "WHT Amount");
                    PaymentVoucher.Validate(PaymentVoucher."Bal. Account Type", "Bal. Account Type");
                    PaymentVoucher.Validate(PaymentVoucher."Bal. Account No.", "Bal. Account No.");
                    PaymentVoucher.Validate(PaymentVoucher."Shortcut Dimension 1 Code", "Shortcut Dimension 1 Code");
                    PaymentVoucher.Validate(PaymentVoucher."Shortcut Dimension 2 Code", "Shortcut Dimension 2 Code");
                    //Transfer All Dimensions
                    // PaymentVoucher.Validate(PaymentVoucher."Dimension Set ID", "Dimension Set ID");
                    // IF DimensionSetEntry.FINDFIRST THEN
                    //     REPEAT
                    //         IF DimensionSetEntry."Dimension Code" = 'STAFF' THEN
                    //             PaymentVoucher.Validate("Shortcut Dimension 3 Code", DimensionSetEntry."Dimension Value Code");
                    //     UNTIL DimensionSetEntry.NEXT = 0;
                    //Transfer All Dimensions
                    PaymentVoucher.Validate(PaymentVoucher."Journal Template Name", "Journal Template Name");
                    PaymentVoucher.Validate(PaymentVoucher."Journal Batch Name", "Journal Batch Name");
                    PaymentVoucher.Validate(PaymentVoucher."Currency Code", "Currency Code");
                    PaymentVoucher.Validate(PaymentVoucher."Currency Factor", "Currency Factor");
                    PaymentVoucher.Validate(PaymentVoucher.User, USERID);
                    PaymentVoucher.Validate(PaymentVoucher."To Post", TRUE);
                    PaymentVoucher.INSERT(TRUE);
                UNTIL NEXT = 0;
        END;
    end;

    //-------------------------------------------
    procedure JournalLineExists(): Boolean
    var
        GenJnlLine: Record "Gen. Journal Line";
    begin
        GenJnlLine.RESET;
        GenJnlLine.SetRange(GenJnlLine."Journal Template Name", "Journal Template Name");
        GenJnlLine.SetRange(GenJnlLine."Journal Batch Name", "Journal Batch Name");
        GenJnlLine.SetRange(GenJnlLine."Line No.", "Line No.");
        EXIT(GenJnlLine.FINDFIRST);
    end;

    //---------------------------------------------
    procedure TransferJournalToReceipt(GenJnlLine: Record "Gen. Journal Line")
    var
        PaymentVoucher: Record "Voucher And Receipt";
        PaymentVoucher1: Record "Voucher And Receipt";
        PaymentVoucher2: Record "Voucher And Receipt";
        PaymentVoucher3: Record "Voucher And Receipt";
        LineNo: Integer;
        InvoicedAmount: Decimal;
        DimensionSetEntry: Record "Dimension Set Entry";
    begin
        PaymentVoucher3.RESET;
        PaymentVoucher3.SetRange(PaymentVoucher3."Document Type", PaymentVoucher3."Document Type"::"Internal Receipt");
        PaymentVoucher3.SetRange(PaymentVoucher3."Journal Template Name", GenJnlLine."Journal Template Name");
        PaymentVoucher3.SetRange(PaymentVoucher3."Journal Batch Name", GenJnlLine."Journal Batch Name");
        PaymentVoucher3.SetRange(PaymentVoucher3."No.", GenJnlLine."Document No.");
        IF PaymentVoucher3.FINDSET THEN
            REPEAT
                PaymentVoucher3.DELETEALL;
            UNTIL PaymentVoucher3.NEXT = 0;

        PaymentVoucher2.RESET;
        PaymentVoucher2.SetRange(PaymentVoucher2."Document Type", PaymentVoucher2."Document Type"::"Internal Receipt");
        PaymentVoucher2.SetRange(PaymentVoucher2."Journal Template Name", GenJnlLine."Journal Template Name");
        PaymentVoucher2.SetRange(PaymentVoucher2."Journal Batch Name", GenJnlLine."Journal Batch Name");
        PaymentVoucher2.SetRange(PaymentVoucher2."No.", GenJnlLine."Document No.");
        IF NOT PaymentVoucher2.FINDFIRST THEN BEGIN
            RESET;
            SetRange("Journal Template Name", GenJnlLine."Journal Template Name");
            SetRange("Journal Batch Name", GenJnlLine."Journal Batch Name");
            SetRange("Document No.", GenJnlLine."Document No.");
            IF FINDFIRST THEN
                REPEAT
                    PaymentVoucher1.RESET;
                    //PaymentVoucher1.SetFilter("No.", '<>%1', '');
                    PaymentVoucher1.SetFilter("No.", '=%1', GenJnlLine."Document No.");
                    PaymentVoucher1.SetFilter("Line No.", '<>%1', 0);
                    IF PaymentVoucher1.FINDLAST THEN
                        LineNo := PaymentVoucher1."Line No." + 10000
                    ELSE
                        LineNo := 10000;

                    PaymentVoucher.Init;
                    PaymentVoucher.Validate(PaymentVoucher."Document Type", PaymentVoucher."Document Type"::"Internal Receipt");
                    PaymentVoucher.Validate(PaymentVoucher."No.", "Document No.");
                    PaymentVoucher.Validate(PaymentVoucher."Document Line No.", 0);
                    PaymentVoucher.Validate(PaymentVoucher."Line No.", LineNo);
                    PaymentVoucher.Validate(PaymentVoucher.Date, WORKDATE);
                    PaymentVoucher.Validate(PaymentVoucher.Code, '');
                    PaymentVoucher.Validate(PaymentVoucher.Comment, '');
                    PaymentVoucher.Validate(PaymentVoucher."Posting Date", "Posting Date");
                    PaymentVoucher.Validate(PaymentVoucher."Document Date", "Document Date");
                    PaymentVoucher.Validate(PaymentVoucher."External Doc. No.", "External Document No.");
                    PaymentVoucher.Validate(PaymentVoucher."Requested by", "Requested by");
                    PaymentVoucher.Validate(PaymentVoucher."Reviewed by", "Reviewed by");
                    PaymentVoucher.Validate(PaymentVoucher."Received by", "Paid To/Received From");
                    PaymentVoucher.Validate(PaymentVoucher."Authorised by", "Authorised by");
                    PaymentVoucher.Validate(PaymentVoucher."Account Type", "Account Type");
                    PaymentVoucher.Validate(PaymentVoucher."Account No.", "Account No.");
                    PaymentVoucher.Validate(PaymentVoucher.Description, Description);
                    PaymentVoucher.Validate(PaymentVoucher.Amount, Amount);
                    PaymentVoucher.Validate(PaymentVoucher."Amount (LCY)", "Amount (LCY)");
                    PaymentVoucher.Validate(PaymentVoucher."WHT Amount", "WHT Amount");
                    PaymentVoucher.Validate(PaymentVoucher."Bal. Account Type", "Bal. Account Type");
                    PaymentVoucher.Validate(PaymentVoucher."Bal. Account No.", "Bal. Account No.");
                    PaymentVoucher.Validate(PaymentVoucher."Shortcut Dimension 1 Code", "Shortcut Dimension 1 Code");
                    PaymentVoucher.Validate(PaymentVoucher."Shortcut Dimension 2 Code", "Shortcut Dimension 2 Code");
                    PaymentVoucher.Validate(PaymentVoucher."Dimension Set ID", "Dimension Set ID");

                    // DimensionSetEntry.RESET;
                    // DimensionSetEntry.SetRange(DimensionSetEntry."Dimension Set ID", "Dimension Set ID");
                    // IF DimensionSetEntry.FINDFIRST THEN
                    //     REPEAT
                    //         IF DimensionSetEntry."Dimension Code" = 'STAFF' THEN
                    //             PaymentVoucher.Validate("Shortcut Dimension 3 Code", DimensionSetEntry."Dimension Value Code");
                    //     UNTIL DimensionSetEntry.NEXT = 0;

                    PaymentVoucher.Validate(PaymentVoucher."Journal Template Name", "Journal Template Name");
                    PaymentVoucher.Validate(PaymentVoucher."Journal Batch Name", "Journal Batch Name");
                    PaymentVoucher.Validate(PaymentVoucher."Currency Code", "Currency Code");
                    PaymentVoucher.Validate(PaymentVoucher."Currency Factor", "Currency Factor");
                    PaymentVoucher.Validate(PaymentVoucher."Payment Method", "Payment Method Code");
                    PaymentVoucher.Validate(PaymentVoucher."To Post", TRUE);
                    PaymentVoucher.Validate(PaymentVoucher.User, USERID);
                    PaymentVoucher.INSERT(TRUE);
                UNTIL NEXT = 0;
        END;
    end;

    //---------------------------------------------
    procedure InitialiseReceipt()
    var
        GenJnlLine: Record "Gen. Journal Line";
        GenLedgerSetup: Record "General Ledger Setup";
        LineNo: Integer;
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        GenLedgerSetup.GET;
        GenLedgerSetup.TESTFIELD(GenLedgerSetup."Internal Receipt Jnl. Template");
        GenLedgerSetup.TESTFIELD(GenLedgerSetup."Internal Receipt Jnl. Batch");

        GenJnlLine.RESET;
        GenJnlLine.SetRange("Journal Template Name", GenLedgerSetup."Internal Receipt Jnl. Template");
        GenJnlLine.SetRange("Journal Batch Name", GenLedgerSetup."Internal Receipt Jnl. Batch");
        GenJnlLine.SetFilter("Line No.", '<>%1', 0);
        IF GenJnlLine.FINDLAST THEN
            LineNo := GenJnlLine."Line No." + 10000
        ELSE
            LineNo := 10000;

        INIT;
        Validate("Journal Template Name", GenLedgerSetup."Internal Receipt Jnl. Template");
        Validate("Journal Batch Name", GenLedgerSetup."Internal Receipt Jnl. Batch");
        Validate("Line No.", LineNo);
    end;

    //--------------------------------------------------
    procedure SetUpNewLineInternalReceipt(LastGenJnlLine: Record "Gen. Journal Line"; Balance: Decimal; BottomLine: Boolean)
    var
        myInt: Integer;
        GenLedgerSetup: Record "General Ledger Setup";
        GenJnlTemplate: Record "Gen. Journal Template";
        GenJnlBatch: Record "Gen. Journal Batch";
        GenJnlLine: Record "Gen. Journal Line";
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        GenLedgerSetup.GET;
        GenLedgerSetup.TESTFIELD(GenLedgerSetup."Internal Receipt Jnl. Template");
        GenLedgerSetup.TESTFIELD(GenLedgerSetup."Internal Receipt Jnl. Batch");

        GenJnlTemplate.GET("Journal Template Name");
        GenJnlBatch.GET("Journal Template Name", "Journal Batch Name");
        GenJnlLine.SetRange("Journal Template Name", "Journal Template Name");
        GenJnlLine.SetRange("Journal Batch Name", "Journal Batch Name");
        IF GenJnlLine.FINDFIRST THEN BEGIN
            "Posting Date" := LastGenJnlLine."Posting Date";
            "Document Date" := LastGenJnlLine."Posting Date";
            "Document Type" := LastGenJnlLine."Document Type";
            "Document No." := LastGenJnlLine."Document No.";
            IF BottomLine AND
               (Balance - LastGenJnlLine."Balance (LCY)" = 0) AND
               NOT LastGenJnlLine.EmptyLine
            THEN
                "Document No." := INCSTR("Document No.");
        END ELSE BEGIN
            "Posting Date" := WORKDATE;
            "Document Date" := WORKDATE;
            IF GenJnlBatch."No. Series" <> '' THEN BEGIN
                CLEAR(NoSeriesMgt);
                "Document No." := NoSeriesMgt.TryGetNextNo(GenJnlBatch."No. Series", "Posting Date");
            END;
        END;
        IF GenJnlTemplate.Recurring THEN
            "Recurring Method" := LastGenJnlLine."Recurring Method";
        "Account Type" := LastGenJnlLine."Account Type";
        "Document Type" := LastGenJnlLine."Document Type";
        "Source Code" := GenJnlTemplate."Source Code";
        "Reason Code" := GenJnlBatch."Reason Code";
        "Posting No. Series" := GenJnlBatch."Posting No. Series";
        "Bal. Account Type" := GenJnlBatch."Bal. Account Type";
        IF ("Account Type" IN ["Account Type"::Customer, "Account Type"::Vendor, "Account Type"::"Fixed Asset"]) AND
           ("Bal. Account Type" IN ["Bal. Account Type"::Customer, "Bal. Account Type"::Vendor, "Bal. Account Type"::"Fixed Asset"])
        THEN
            "Account Type" := "Account Type"::"G/L Account";
        Validate("Bal. Account No.", GenJnlBatch."Bal. Account No.");
        Description := '';
    end;

    //--------------------------------------------
    procedure CheckReceiptExists(DocumentNo: Code[20]): Boolean
    var
        myInt: Integer;
    begin
        /*
        DocumentNo := "Document No.";
        IF SalesHeader.GET(SalesHeader."Document Type"::Receipt, DocumentNo) THEN
            EXIT(TRUE)
            */
    end;

    //-------------------------------------------------
    procedure InsertPaymentVoucher(): Code[40]
    var
        GeneralJournalLine: Record "Gen. Journal Line";
        GeneralJournalLineCopy: Record "Gen. Journal Line";
        GeneralJournalLineTemp: Record "Gen. Journal Line";
        Count: Integer;
    begin
        GeneralJournalLineCopy.RESET;
        GeneralJournalLineCopy.COPY(Rec);
        GeneralJournalLineCopy.COPYFILTERS(Rec);
        Count := GeneralJournalLineCopy.COUNT;
        GeneralJournalLineTemp.INIT;
        REPEAT
            GeneralJournalLine.TransferJournalToVoucher(GeneralJournalLineCopy);
            GeneralJournalLineTemp.TRANSFERFIELDS(GeneralJournalLineCopy, TRUE);
            GeneralJournalLineTemp.INSERT;
            Count -= 1;
        UNTIL (GeneralJournalLineCopy.NEXT = 0) OR (Count = 0);
        COMMIT;
    end;

    //------------------------------------
    procedure ChangePaymentVoucherStatus(Print: Boolean;
       DocNoFilter: Code[255])
    var
        PaymentVoucher: Report "Payment Voucher";
        Voucher: Record "Voucher And Receipt";
        DocumentNoMin: Code[20];
        DocumentNoMax: Code[20];
        GenVocLine: Record "Gen. Journal Line";
        GeneralLedgerEntry1: Record "G/L Entry";
    begin

        Voucher.RESET;
        Voucher.SetRange("Document Type", Voucher."Document Type"::"Payment Voucher");
        Voucher.SetRange("To Post", TRUE);
        Voucher.SetFilter("No.", DocNoFilter);
        IF Voucher.FINDFIRST THEN
            REPEAT
                // Check if Payment Voucher is posted from general journal using Journal Template Name, Journal Batch Name and DocNoFilter 
                // If it is not yet posted then call the EXIT function
                GeneralLedgerEntry1.RESET;
                GeneralLedgerEntry1.SetRange(GeneralLedgerEntry1."Journal Batch Name", "Journal Batch Name");
                GeneralLedgerEntry1.SetRange("Document No.", Voucher."No.");
                GeneralLedgerEntry1.SetRange("Posting Date", Voucher."Posting Date");
                IF GeneralLedgerEntry1.FINDFIRST THEN BEGIN
                    //Change the Payment Voucher status
                    Voucher.Posted := TRUE;
                    Voucher."To Post" := FALSE;
                    Voucher.MODIFY;
                END;
                IF Print THEN BEGIN
                    PaymentVoucher.SetPrintDocumentNo(Voucher."No.");
                    PaymentVoucher.USEREQUESTPAGE(FALSE);
                    PaymentVoucher.RUN;
                END;
            UNTIL Voucher.NEXT = 0;
    end;

    //---------------------------------------------------------
    procedure InsertReceipt(): Code[40]
    var
        myInt: Integer;
        GeneralJournalLine: Record "Gen. Journal Line";
        GeneralJournalLineCopy: Record "Gen. Journal Line";
        GeneralJournalLineTemp: Record "Gen. Journal Line";
        Count: Integer;
    begin
        GeneralJournalLineCopy.RESET;
        GeneralJournalLineCopy.COPY(Rec);
        GeneralJournalLineCopy.COPYFILTERS(Rec);
        Count := GeneralJournalLineCopy.COUNT;
        GeneralJournalLineTemp.INIT;
        REPEAT
            GeneralJournalLine.TransferJournalToReceipt(GeneralJournalLineCopy);
            GeneralJournalLineTemp.TRANSFERFIELDS(GeneralJournalLineCopy, TRUE);
            GeneralJournalLineTemp.INSERT;
            Count -= 1;
        UNTIL (GeneralJournalLineCopy.NEXT = 0) OR (Count = 0);
        COMMIT;
    end;

    //-------------------------------------------
    procedure ChangeReceiptStatus(Print: Boolean; DocNoFilter: Code[255])
    var
        myInt: Integer;
        ReceiptReport: Report "Internal Receipt";
        Receipt: Record "Voucher And Receipt";
        DocumentNoMin: Code[20];
        DocumentNoMax: Code[20];
        GeneralLedgerEntry: Record "G/L Entry";
    begin
        Receipt.RESET;
        Receipt.SetRange("Document Type", Receipt."Document Type"::"Internal Receipt");
        Receipt.SetRange("To Post", TRUE);
        Receipt.SetFilter("No.", DocNoFilter);
        IF Receipt.FINDFIRST THEN
            REPEAT
                // Check if receipt is posted from general journal using Journal Template Name, Journal Batch Name and DocNoFilter 
                // If it is not yet posted then call the EXIT function
                // Use G/L Entry table; filters: Document No., Document Type(Payment), Journal Batch Name, Posting Date
                GeneralLedgerEntry.RESET;
                GeneralLedgerEntry.SetRange(GeneralLedgerEntry."Journal Batch Name", "Journal Batch Name");
                GeneralLedgerEntry.SetRange("Document No.", Receipt."No.");
                GeneralLedgerEntry.SetRange("Posting Date", Receipt."Posting Date");
                IF GeneralLedgerEntry.FINDFIRST THEN BEGIN
                    //Change the receipt status
                    Receipt.Posted := TRUE;
                    Receipt."To Post" := FALSE;
                    Receipt.MODIFY;
                END;
                IF Print THEN BEGIN
                    ReceiptReport.SetPrintDocumentNo(Receipt."No.");
                    ReceiptReport.USEREQUESTPAGE(FALSE);
                    ReceiptReport.RUN;
                END;
            UNTIL Receipt.NEXT = 0;
    end;

    //-------------------------------------------
    procedure ShowDimensions2()
    var
        myInt: Integer;
        DimensionManagement: Codeunit DimensionManagement;
    begin
        DimensionManagement.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
    end;

    //----------------------------------------------
    procedure TransferJournalToAccountability(GenJnlLine: Record "Gen. Journal Line")
    var
        PaymentVoucher: Record "Voucher And Receipt";
        PaymentVoucher1: Record "Voucher And Receipt";
        PaymentVoucher2: Record "Voucher And Receipt";
        PaymentVoucher3: Record "Voucher And Receipt";
        DimensionSetEntry: Record "Dimension Set Entry";
        LineNo: Integer;
    begin
        PaymentVoucher3.RESET;
        PaymentVoucher3.SetRange(PaymentVoucher3."Document Type", PaymentVoucher3."Document Type"::"Accountability Expense");
        PaymentVoucher3.SetRange(PaymentVoucher3."Journal Template Name", GenJnlLine."Journal Template Name");
        PaymentVoucher3.SetRange(PaymentVoucher3."Journal Batch Name", GenJnlLine."Journal Batch Name");
        PaymentVoucher3.SetRange(PaymentVoucher3."No.", GenJnlLine."Document No.");
        IF PaymentVoucher3.FINDSET THEN
            REPEAT
                PaymentVoucher3.DELETEALL;
            UNTIL PaymentVoucher3.NEXT = 0;

        PaymentVoucher2.RESET;
        PaymentVoucher2.SetRange(PaymentVoucher2."Document Type", PaymentVoucher2."Document Type"::"Accountability Expense");
        PaymentVoucher2.SetRange(PaymentVoucher2."Journal Template Name", GenJnlLine."Journal Template Name");
        PaymentVoucher2.SetRange(PaymentVoucher2."Journal Batch Name", GenJnlLine."Journal Batch Name");
        PaymentVoucher2.SetRange(PaymentVoucher2."No.", GenJnlLine."Document No.");
        IF NOT PaymentVoucher2.FINDFIRST THEN BEGIN
            RESET;
            SetRange("Journal Template Name", GenJnlLine."Journal Template Name");
            SetRange("Journal Batch Name", GenJnlLine."Journal Batch Name");
            SetRange("Document No.", GenJnlLine."Document No.");
            IF FINDFIRST THEN
                REPEAT
                    PaymentVoucher1.RESET;
                    PaymentVoucher1.SetFilter("No.", '=%1', GenJnlLine."Document No.");
                    PaymentVoucher1.SetFilter("Line No.", '<>%1', 0);
                    IF PaymentVoucher1.FINDLAST THEN
                        LineNo := PaymentVoucher1."Line No." + 10000
                    ELSE
                        LineNo := 10000;
                    //
                    FOR K := 1 TO 10 DO BEGIN
                        InvoiceArray[K] := '';
                    END;
                    Invoices := '';

                    VendorLedgerEntry.RESET;
                    VendorLedgerEntry.SetFilter(VendorLedgerEntry.Amount, '<>0');
                    VendorLedgerEntry.SetRange(VendorLedgerEntry."Applies-to ID", GenJnlLine."Document No.");
                    IF VendorLedgerEntry.FINDFIRST THEN BEGIN
                        I := 1;
                        Invoices := '';
                        REPEAT
                            //Invoices := VendorLedgerEntry."Document No.";
                            InvoiceArray[I] := VendorLedgerEntry."Document No.";
                            I += 1;
                        UNTIL VendorLedgerEntry.NEXT = 0;
                        FOR L := 1 TO 10 DO BEGIN
                            //Invoices += InvoiceArray[L];
                        END;
                        PaymentVoucher."Applied Invoices" := InvoiceArray[1] + '  ' + InvoiceArray[2] + '  ' + InvoiceArray[3] + '  ' + InvoiceArray[4] + '  '
                                                            + InvoiceArray[5] + '  ' + InvoiceArray[6] + '  ' + InvoiceArray[7] + '  ' + InvoiceArray[8]
                                                            + '  ' + InvoiceArray[9] + '  ' + InvoiceArray[10];
                    END ELSE BEGIN // Get Applied Invoices from the General Journal Line
                        GenJnlLine.RESET;
                        GenJnlLine.SetRange(GenJnlLine."Journal Template Name", GeneralJournal."Journal Template Name");
                        GenJnlLine.SetRange(GenJnlLine."Journal Batch Name", GeneralJournal."Journal Batch Name");
                        GenJnlLine.SetRange(GenJnlLine."Document No.", GeneralJournal."Document No.");
                        GenJnlLine.SetFilter(GenJnlLine."Applies-to Doc. No.", '<>%1', '');
                        IF GenJnlLine.FINDFIRST THEN BEGIN
                            J := 1;
                            REPEAT
                                InvoiceArray[J] := JournalLine."Applies-to Doc. No." + ' ';
                                J += 1;
                            UNTIL GenJnlLine.NEXT = 0;
                            FOR M := 1 TO 10 DO BEGIN
                                //Invoices += InvoiceArray[M] + ', ';
                            END;
                            PaymentVoucher."Applied Invoices" := InvoiceArray[1] + '  ' + InvoiceArray[2] + '  ' + InvoiceArray[3] + '  ' + InvoiceArray[4]
                                                                + '  ' + InvoiceArray[5] + '  ' + InvoiceArray[6] + '  ' + InvoiceArray[7] + '  ' +
                                                                InvoiceArray[8] + '  ' + InvoiceArray[9] + '  ' + InvoiceArray[10];
                        END;
                    END;
                    //customer applied entries

                    //
                    PaymentVoucher.INIT;
                    PaymentVoucher.Validate(PaymentVoucher."Document Type", PaymentVoucher."Document Type"::"Accountability Expense");
                    PaymentVoucher.Validate(PaymentVoucher."No.", "Document No.");
                    PaymentVoucher.Validate(PaymentVoucher."Document Line No.", 0);
                    PaymentVoucher.Validate(PaymentVoucher."Line No.", LineNo);
                    PaymentVoucher.Validate(PaymentVoucher.Date, WORKDATE);
                    PaymentVoucher.Validate(PaymentVoucher.Code, '');
                    PaymentVoucher.Validate(PaymentVoucher.Comment, '');
                    PaymentVoucher.Validate(PaymentVoucher."Posting Date", "Posting Date");
                    PaymentVoucher.Validate(PaymentVoucher."Document Date", "Document Date");
                    PaymentVoucher.Validate(PaymentVoucher."External Doc. No.", "External Document No.");
                    PaymentVoucher.Validate(PaymentVoucher."Requested by", "Requested by");
                    PaymentVoucher.Validate(PaymentVoucher."Received by", "Paid To/Received From");
                    PaymentVoucher.Validate(PaymentVoucher."Reviewed by", "Reviewed by");
                    PaymentVoucher.Validate(PaymentVoucher."Authorised by", "Authorised by");
                    PaymentVoucher.Validate(PaymentVoucher.Description, Description);
                    PaymentVoucher.Validate(PaymentVoucher."Account Type", "Account Type");
                    PaymentVoucher.Validate(PaymentVoucher."Account No.", "Account No.");
                    PaymentVoucher.Validate(PaymentVoucher.Amount, Amount);
                    PaymentVoucher.Validate(PaymentVoucher."Amount (LCY)", "Amount (LCY)");
                    PaymentVoucher.Validate(PaymentVoucher."Bal. Account Type", "Bal. Account Type");
                    PaymentVoucher.Validate(PaymentVoucher."Bal. Account No.", "Bal. Account No.");
                    PaymentVoucher.Validate(PaymentVoucher."Shortcut Dimension 1 Code", "Shortcut Dimension 1 Code");
                    PaymentVoucher.Validate(PaymentVoucher."Shortcut Dimension 2 Code", "Shortcut Dimension 2 Code");
                    //Transfer All Dimensions
                    PaymentVoucher.Validate(PaymentVoucher."Dimension Set ID", "Dimension Set ID");
                    IF DimensionSetEntry.FINDFIRST THEN
                        REPEAT
                            IF DimensionSetEntry."Dimension Code" = 'STAFF' THEN
                                PaymentVoucher.Validate("Shortcut Dimension 3 Code", DimensionSetEntry."Dimension Value Code");
                        UNTIL DimensionSetEntry.NEXT = 0;
                    //Transfer All Dimensions
                    PaymentVoucher.Validate(PaymentVoucher."Journal Template Name", "Journal Template Name");
                    PaymentVoucher.Validate(PaymentVoucher."Journal Batch Name", "Journal Batch Name");
                    PaymentVoucher.Validate(PaymentVoucher."Currency Code", "Currency Code");
                    PaymentVoucher.Validate(PaymentVoucher."Currency Factor", "Currency Factor");
                    PaymentVoucher.Validate(PaymentVoucher.User, USERID);
                    PaymentVoucher.Validate(PaymentVoucher."To Post", TRUE);
                    PaymentVoucher.INSERT(TRUE);
                UNTIL NEXT = 0;
        END;
    end;

    //---------------------------------
    procedure InsertAccountability(): Code[40]
    var
        GeneralJournalLine: Record "Gen. Journal Line";
        GeneralJournalLineCopy: Record "Gen. Journal Line";
        GeneralJournalLineTemp: Record "Gen. Journal Line";
        Count: Integer;
    begin
        GeneralJournalLineCopy.RESET;
        GeneralJournalLineCopy.COPY(Rec);
        GeneralJournalLineCopy.COPYFILTERS(Rec);
        Count := GeneralJournalLineCopy.COUNT;
        GeneralJournalLineTemp.INIT;
        REPEAT
            GeneralJournalLine.TransferJournalToAccountability(GeneralJournalLineCopy);
            GeneralJournalLineTemp.TRANSFERFIELDS(GeneralJournalLineCopy, TRUE);
            GeneralJournalLineTemp.INSERT;
            Count -= 1;
        UNTIL (GeneralJournalLineCopy.NEXT = 0) OR (Count = 0);
        COMMIT;
    end;

    //-------------------------------------------
    procedure ChangeAccountabilityStatus(Print: Boolean;
       DocNoFilter: Code[255])
    var
        PaymentVoucher: Report "Payment Voucher";
        Voucher: Record "Voucher And Receipt";
        DocumentNoMin: Code[20];
        DocumentNoMax: Code[20];
        GenVocLine: Record "Gen. Journal Line";
        GeneralLedgerEntry1: Record "G/L Entry";
    begin
        Voucher.RESET;
        Voucher.SetRange("Document Type", Voucher."Document Type"::"Accountability Expense");
        Voucher.SetRange("To Post", TRUE);
        Voucher.SetFilter("No.", DocNoFilter);
        IF Voucher.FINDFIRST THEN
            REPEAT
                // Check if Payment Voucher is posted from general journal using Journal Template Name, Journal Batch Name and DocNoFilter 
                // If it is not yet posted then call the EXIT function
                GeneralLedgerEntry1.RESET;
                GeneralLedgerEntry1.SetRange(GeneralLedgerEntry1."Journal Batch Name", "Journal Batch Name");
                GeneralLedgerEntry1.SetRange("Document No.", Voucher."No.");
                GeneralLedgerEntry1.SetRange("Posting Date", Voucher."Posting Date");
                IF GeneralLedgerEntry1.FINDFIRST THEN BEGIN
                    //Change the Payment Voucher status
                    Voucher.Posted := TRUE;
                    Voucher."To Post" := FALSE;
                    Voucher.MODIFY;
                END;
                IF Print THEN BEGIN
                    PaymentVoucher.SetPrintDocumentNo(Voucher."No.");
                    PaymentVoucher.USEREQUESTPAGE(FALSE);
                    PaymentVoucher.RUN;
                END;
            UNTIL Voucher.NEXT = 0;
    end;

}
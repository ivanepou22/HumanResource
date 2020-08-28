tableextension 50038 "Sales Header Ext" extends "Sales Header"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "USER ID"; Code[50])
        {
            Editable = false;

        }
        field(50010; "Modified By"; Code[50])
        {

            Editable = false;
        }
        field(50020; "By Distributor"; Boolean)
        {
            Editable = false;
        }

        field(50030; "Branch Code"; Code[50])
        {
            TableRelation = Confidential.Code where(Type = const(Branch), "Customer No." = field("Sell-to Customer No."));

        }
        field(50033; "Truck No."; Code[30])
        {

        }
        field(50034; "Seal No"; Code[30])
        {

        }
        field(60010; "Receipt Posted"; Boolean) { }
        field(60020; "Document Type Pos"; Option)
        {
            OptionMembers = Quote,Order,Invoice,"Credit Memo","Blanket Order","Return Order",Receipt,"POS Count";
        }
        field(65000; "VAT Amount"; Decimal) { }
        field(65020; Drawer; Code[20])
        {
            TableRelation = "Voucher And Receipt"."No." WHERE("Document Type" = FILTER(Drawer), User = field("USER ID"));
        }
        field(65030; "Cash Tendered"; Decimal)
        {
        }
        field(65040; Receipts; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum ("Sales Line"."Amount Including VAT" WHERE("Document Type Pos" = CONST(Receipt), "Posting Date" = FIELD("Date Filter"), "User ID" = FIELD("USER ID"), Drawer = FIELD(Drawer)));
        }
        field(65050; "Posted Invoice No."; Code[20])
        {
            TableRelation = "Sales Invoice Header"."No.";
        }

    }

    var

        T0001: Label 'Amount To Receive cannot be zero or less';
        T0002: Label 'The user does not have a defined drawer. Contact the system administrator';
        T0003: Label 'Cash Tendered should be more than the Total Amount, Cash Tendered is %1 and Total Amount is %2';
        T0004: Label 'Are you really sure you want to reverse the last invoice and payment?';
        T0005: Label 'The Invoice %1 and Payment %1 have been unapplied and reversed successfully';

    trigger OnInsert()
    var
        myInt: Integer;
    begin
        "USER ID" := UserId;
    end;

    trigger OnModify()
    var
        myInt: Integer;
    begin
        "Modified By" := UserId;
    end;

    trigger OnRename()
    var
        myInt: Integer;
    begin
        "Modified By" := UserId;
    end;



    //==================Functions=================
    //Create receiptLines.
    procedure CreateReceiptLines(InvoiceDocNo: Code[20]; AmountToReceive: Decimal; LimitAmount: Boolean)
    var
        ReceiptLines: Record "Sales Line";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        RemainingAmountToApply: Decimal;
        LineNo: Integer;
        ContinueGeneration: Boolean;
    begin
        ReceiptLines.RESET;
        ReceiptLines.SETRANGE("Document Type", "Document Type");
        ReceiptLines.SetRange("Document Type Pos", "Document Type Pos");
        ReceiptLines.SETRANGE("Document No.", "No.");
        IF ReceiptLines.FINDSET THEN
            ReceiptLines.DELETEALL;

        CustLedgerEntry.RESET;
        CustLedgerEntry.SETRANGE(CustLedgerEntry."Sell-to Customer No.", "Sell-to Customer No.");
        CustLedgerEntry.SETFILTER(CustLedgerEntry.Amount, '>0');
        CustLedgerEntry.SETFILTER(CustLedgerEntry."Remaining Amount", '<>0');
        CustLedgerEntry.SETRANGE(CustLedgerEntry."Document No.", InvoiceDocNo);
        CustLedgerEntry.SETRANGE(CustLedgerEntry."Posting Date", "Posting Date");
        CustLedgerEntry.SETRANGE(CustLedgerEntry."User ID", USERID);
        IF CustLedgerEntry.FINDSET THEN BEGIN
            REPEAT
                LineNo += 10000;
                CLEAR(ReceiptLines);
                ReceiptLines.INIT;
                ReceiptLines."Document Type" := "Document Type";
                ReceiptLines."Document Type Pos" := "Document Type Pos";
                ReceiptLines."Document No." := "No.";
                ReceiptLines."Line No." := LineNo;
                ReceiptLines."Sell-to Customer No." := "Sell-to Customer No.";
                CustLedgerEntry.CALCFIELDS("Remaining Amount");
                IF LimitAmount THEN BEGIN
                    IF RemainingAmountToApply <= CustLedgerEntry."Remaining Amount" THEN BEGIN
                        RemainingAmountToApply := 0;
                        ContinueGeneration := FALSE;
                    END ELSE BEGIN
                        RemainingAmountToApply -= CustLedgerEntry."Remaining Amount";
                    END;
                END ELSE
                    ReceiptLines.Description := CustLedgerEntry.Description;
                ReceiptLines.INSERT;
            UNTIL (CustLedgerEntry.NEXT = 0) OR (ContinueGeneration = FALSE);
        END;
    end;

    procedure CreateAndPostPOSOrder(VAR SalesHeaderRec: Record "Sales Header"): Code[20]
    var
        UserSetup: Record "User Setup";
        SalesHeader2: Record "Sales Header";
        SalesHeader3: Record "Sales Header";
        SalesHeaderMod: Record "Sales Header";
        SalesLines: Record "Sales Line";
        SalesLines2: Record "Sales Line";
        ReceiptHeader: Record "Sales Header";
        ReceiptLines: Record "Sales Line";
        PostSalesBatch: Report "Batch Post Sales Orders POS";
        SalesPost: Codeunit "Sales-Post";
        SalesPOS: Page "Sales Order POS";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        OrderNo: Code[20];
        LineNo: Integer;
    begin
        // Copy and Create Sales Header from POS Sales Header
        UserSetup.GET(USERID);
        CLEAR(SalesHeader2);
        SalesHeader2.INIT;
        SalesHeader2."Document Type" := SalesHeader2."Document Type"::Order;
        OrderNo := NoSeriesMgt.GetNextNo(UserSetup."Sales Order Nos.", WORKDATE, TRUE);
        SalesHeader2."No." := OrderNo;
        SalesHeader2.Ship := TRUE;
        SalesHeader2.Invoice := TRUE;
        SalesHeader2.Receive := TRUE;
        SalesHeader2.SetHideValidationDialog(TRUE);
        SalesHeader2.TRANSFERFIELDS(SalesHeaderRec, FALSE);
        //OrderNo := SalesHeader2."No.";
        SalesHeader2.INSERT(TRUE);

        IF SalesHeaderMod.GET(SalesHeaderMod."Document Type"::Order, OrderNo) THEN BEGIN
            IF (SalesHeaderMod."Location Code" = '') THEN BEGIN
                SalesHeaderMod.VALIDATE("Location Code", UserSetup."Location Code");
                SalesHeaderMod.MODIFY;
            END;
        END;
        // Copy and Create Sales Lines from POS Sales Lines
        SalesLines.RESET;
        SalesLines.SETRANGE("Document Type", SalesLines."Document Type"::Order);
        SalesLines.SETRANGE("Document No.", SalesHeaderRec."No.");
        SalesLines.SETRANGE(Type, SalesLines.Type::"G/L Account", SalesLines.Type::Item);
        SalesLines.SETFILTER("No.", '<>%1', '');
        SalesLines.SETFILTER(Quantity, '>%1', 0);
        SalesLines.SETFILTER("Line Amount", '>%1', 0);
        IF SalesLines.FINDFIRST THEN
            REPEAT
                LineNo += 10000;
                SalesLines2.INIT;
                SalesLines2."Document Type" := SalesLines2."Document Type"::Order;
                SalesLines2."Document No." := OrderNo;
                SalesLines2."Line No." := LineNo;
                SalesLines2.TRANSFERFIELDS(SalesLines, FALSE);
                IF (SalesLines."Shortcut Dimension 1 Code" = '') THEN
                    SalesLines2.VALIDATE("Shortcut Dimension 1 Code", UserSetup."Shortcut Dimension 1 Code");
                IF (SalesLines."Shortcut Dimension 2 Code" = '') THEN
                    SalesLines2.VALIDATE("Shortcut Dimension 2 Code", UserSetup."Shortcut Dimension 2 Code");
                SalesLines2.INSERT(TRUE);
            UNTIL SalesLines.NEXT = 0;
        COMMIT;
        SalesHeader2.RESET;
        SalesHeader2.SETRANGE("Document Type", SalesHeader2."Document Type"::Order);
        SalesHeader2.SETRANGE("No.", OrderNo);
        IF SalesHeader2.FINDFIRST THEN BEGIN
            PostSalesBatch.InitializeRequest(TRUE, TRUE, SalesHeader2."Posting Date", FALSE, FALSE, TRUE);
            PostSalesBatch.USEREQUESTPAGE(FALSE);
            PostSalesBatch.SETTABLEVIEW(SalesHeader2);
            PostSalesBatch.RUNMODAL;
        END;
        EXIT(OrderNo);
    end;

    procedure GetPostedInvoice(OrderNo: Code[30]): Code[30]
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
    begin
        SalesInvoiceHeader.RESET;
        SalesInvoiceHeader.SETRANGE(SalesInvoiceHeader."Order No.", OrderNo);
        IF SalesInvoiceHeader.FINDFIRST THEN
            EXIT(SalesInvoiceHeader."No.")
        ELSE
            ERROR('Invoice not found for Order: ' + OrderNo);
    end;

    procedure CreateAndPostCashReceipt(InvoiceNo: Code[20])
    var
        PostedSalesInvoiceHeader: Record "Sales Invoice Header";
        PostedSalesInvoiceLine: Record "Sales Invoice Line";
        GenJournalLine: Record "Gen. Journal Line";
        UserSetup: Record "User Setup";
        ReceiptHeader: Record "Sales Header";
        ReceiptLine: Record "Sales Line";
        NoSeriesManagement: Codeunit NoSeriesManagement;
        GenJournalPostBatch: Codeunit "Gen. Jnl.-Post Batch";
        ReceiptPrint: Report "Receipt POS Advanced";
        DocumentNo: Code[20];
        LineNo: Integer;
        TotalAmount: Decimal;
    begin
        // Create and Post Cash Recept Journal for the Posted Sales Invoice
        TotalAmount := 0;
        UserSetup.GET(USERID);
        GenJournalLine.RESET;
        GenJournalLine.SETRANGE("Journal Template Name", UserSetup."Journal Template Name");
        GenJournalLine.SETRANGE("Journal Batch Name", UserSetup."Journal Batch Name");
        IF GenJournalLine.FINDSET THEN
            GenJournalLine.DELETEALL;

        PostedSalesInvoiceHeader.GET(InvoiceNo);
        PostedSalesInvoiceLine.RESET;
        PostedSalesInvoiceLine.SETRANGE(PostedSalesInvoiceLine."Document No.", InvoiceNo);
        IF PostedSalesInvoiceLine.FINDFIRST THEN BEGIN
            DocumentNo := NoSeriesManagement.GetNextNo(UserSetup."Receipt Journal Nos.", WORKDATE, TRUE);
            CreateReceipt(InvoiceNo, DocumentNo);
            REPEAT
                TotalAmount += PostedSalesInvoiceLine."Amount Including VAT";
            UNTIL PostedSalesInvoiceLine.NEXT = 0;
            GenJournalLine.INIT;
            LineNo += 10000;
            GenJournalLine."Journal Template Name" := UserSetup."Journal Template Name";
            GenJournalLine."Journal Batch Name" := UserSetup."Journal Batch Name";
            GenJournalLine."Line No." := LineNo;
            GenJournalLine."Account Type" := GenJournalLine."Account Type"::Customer;
            GenJournalLine.VALIDATE("Account No.", PostedSalesInvoiceHeader."Sell-to Customer No.");
            GenJournalLine."Posting Date" := WORKDATE;
            GenJournalLine."Document Type" := GenJournalLine."Document Type"::Payment;
            GenJournalLine."Document No." := DocumentNo;
            GenJournalLine.Description := PostedSalesInvoiceLine.Description;
            PostedSalesInvoiceHeader.CALCFIELDS("Amount Including VAT");
            GenJournalLine.VALIDATE(Amount, -PostedSalesInvoiceHeader."Amount Including VAT");
            GenJournalLine."Sell-to/Buy-from No." := PostedSalesInvoiceHeader."Sell-to Customer No.";
            //Apply
            GenJournalLine."Applies-to Doc. Type" := GenJournalLine."Applies-to Doc. Type"::Invoice;
            GenJournalLine."Applies-to Doc. No." := PostedSalesInvoiceHeader."No.";
            GenJournalLine.INSERT;
            GenJournalLine.INIT;
            LineNo += 10000;
            GenJournalLine."Journal Template Name" := UserSetup."Journal Template Name";
            GenJournalLine."Journal Batch Name" := UserSetup."Journal Batch Name";
            GenJournalLine."Line No." := LineNo;
            GenJournalLine."Account Type" := GenJournalLine."Account Type"::"Bank Account";
            GenJournalLine.VALIDATE("Account No.", UserSetup."Receiving Bank");
            GenJournalLine."Posting Date" := WORKDATE;
            GenJournalLine."Document Type" := GenJournalLine."Document Type"::Payment;
            GenJournalLine."Document No." := DocumentNo;
            //GenJournalLine."External Document No." := '';
            GenJournalLine.Description := PostedSalesInvoiceHeader."Sell-to Customer Name";
            PostedSalesInvoiceHeader.CALCFIELDS("Amount Including VAT");
            GenJournalLine.VALIDATE(Amount, PostedSalesInvoiceHeader."Amount Including VAT");
            GenJournalLine.INSERT;
        END;
        GenJournalPostBatch.RUN(GenJournalLine);
        ReceiptHeader.Reset();
        ReceiptHeader.SetRange(ReceiptHeader."Document Type Pos", ReceiptHeader."Document Type Pos"::Receipt);
        ReceiptHeader.SetRange(ReceiptHeader."No.", DocumentNo);
        //(ReceiptHeader.GET(ReceiptHeader."Document Type Pos"::Receipt, DocumentNo))
        IF ReceiptHeader.FindFirst() THEN BEGIN
            ReceiptHeader."Receipt Posted" := TRUE;
            ReceiptLine.RESET;
            ReceiptLine.SETRANGE("Document Type Pos", ReceiptLine."Document Type Pos"::Receipt);
            ReceiptLine.SETRANGE("Document No.", DocumentNo);
            IF ReceiptLine.FINDFIRST THEN
                REPEAT
                    ReceiptLine."Receipt Posted" := TRUE;
                    ReceiptLine.MODIFY;
                UNTIL ReceiptLine.NEXT = 0;
            ClearPOS();
            ReceiptHeader.MODIFY;
            ReceiptPrint.SetPrintedFromSalesLine;
            ReceiptPrint.USEREQUESTPAGE := FALSE;
            ReceiptPrint.SetPrintDocumentNo(DocumentNo);
            ReceiptPrint.SetNoOfCopies(0);
            ReceiptPrint.RUNMODAL;
        END;
    end;

    procedure CheckUserSetupAndDrawer()
    var
        UserSetup: Record "User Setup";
        ReceiptDrawer: Record "Voucher And Receipt";
    begin
        TESTFIELD("User ID", USERID);
        UserSetup.GET(USERID);
        UserSetup.TESTFIELD(UserSetup."Location Code");
        UserSetup.TESTFIELD(UserSetup."Sell-to Customer No.");
        UserSetup.TESTFIELD(UserSetup."Receipt Nos.");
        UserSetup.TESTFIELD(UserSetup."Receipt Nos.");
        UserSetup.TESTFIELD(UserSetup."Journal Template Name");
        UserSetup.TESTFIELD(UserSetup."Journal Batch Name");
        UserSetup.TESTFIELD(UserSetup."Receiving Bank");
        ReceiptDrawer.RESET;
        ReceiptDrawer.SETRANGE(ReceiptDrawer."Document Type", ReceiptDrawer."Document Type"::Drawer);
        ReceiptDrawer.SETRANGE(ReceiptDrawer.User, USERID);
        IF NOT ReceiptDrawer.FINDFIRST THEN
            ERROR(T0002);
    end;

    procedure CreateReceipt(InvoiceDocNo: Code[20]; DocumentNo: Code[20])
    var
        ReceiptHeader: Record "Sales Header";
        ReceiptLines: Record "Sales Line";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        UserSetup: Record "User Setup";
        PostedSalesInvoiceHeader: Record "Sales Invoice Header";
        PostedSalesInvoiceLine: Record "Sales Invoice Line";
        RemainingAmountToApply: Decimal;
        LineNo: Integer;
        ContinueGeneration: Boolean;

    begin
        UserSetup.GET(USERID);
        PostedSalesInvoiceHeader.GET(InvoiceDocNo);
        PostedSalesInvoiceLine.RESET;
        PostedSalesInvoiceLine.SETRANGE(PostedSalesInvoiceLine."Document No.", InvoiceDocNo);
        IF PostedSalesInvoiceLine.FINDFIRST THEN BEGIN
            PostedSalesInvoiceHeader.CALCFIELDS(Amount, "Amount Including VAT");
            CLEAR(ReceiptHeader);
            ReceiptHeader.INIT;
            ReceiptHeader."Document Type" := ReceiptHeader."Document Type"::Order;
            ReceiptHeader."Document Type Pos" := ReceiptHeader."Document Type Pos"::Receipt;
            ReceiptHeader."No." := DocumentNo;
            ReceiptHeader.VALIDATE("Sell-to Customer No.", PostedSalesInvoiceHeader."Sell-to Customer No.");
            ReceiptHeader.VALIDATE("Posting Date", PostedSalesInvoiceHeader."Posting Date");
            ReceiptHeader."VAT Amount" := (PostedSalesInvoiceHeader."Amount Including VAT" - PostedSalesInvoiceHeader.Amount);
            ReceiptHeader.VALIDATE(ReceiptHeader."User ID", PostedSalesInvoiceHeader."User ID");
            ReceiptHeader.VALIDATE(ReceiptHeader."Cash Tendered", "Cash Tendered");
            ReceiptHeader.VALIDATE(Drawer, GetDrawerDetail());
            ReceiptHeader.VALIDATE("Posted Invoice No.", InvoiceDocNo);
            ReceiptHeader.SetHideValidationDialog(TRUE);
            ReceiptHeader.INSERT(TRUE);
            REPEAT
                // Copy and Create Receipt Lines from Posted Sales Lines
                LineNo += 10000;
                ReceiptLines.INIT;
                ReceiptLines."Document Type" := ReceiptLines."Document Type"::Order;
                ReceiptLines."Document Type Pos" := ReceiptLines."Document Type Pos"::Receipt;
                ReceiptLines."Document No." := DocumentNo;
                ReceiptLines."Line No." := LineNo;
                // ,G/L Account,Item,Resource,Fixed Asset,Charge (Item)
                IF (PostedSalesInvoiceLine.Type = PostedSalesInvoiceLine.Type::"Charge (Item)") THEN
                    ReceiptLines.Type := ReceiptLines.Type::"Charge (Item)"
                ELSE
                    IF (PostedSalesInvoiceLine.Type = PostedSalesInvoiceLine.Type::"Fixed Asset") THEN
                        ReceiptLines.Type := ReceiptLines.Type::"Fixed Asset"
                    ELSE
                        IF (PostedSalesInvoiceLine.Type = PostedSalesInvoiceLine.Type::"G/L Account") THEN
                            ReceiptLines.Type := ReceiptLines.Type::"G/L Account"
                        ELSE
                            IF (PostedSalesInvoiceLine.Type = PostedSalesInvoiceLine.Type::Item) THEN
                                ReceiptLines.Type := ReceiptLines.Type::Item
                            ELSE
                                IF (PostedSalesInvoiceLine.Type = PostedSalesInvoiceLine.Type::Resource) THEN
                                    ReceiptLines.Type := ReceiptLines.Type::Resource;
                ReceiptLines."No." := PostedSalesInvoiceLine."No.";
                ReceiptLines.Description := PostedSalesInvoiceLine."No." + ' - ' + PostedSalesInvoiceLine.Description;
                ReceiptLines.VALIDATE(ReceiptLines.Quantity, PostedSalesInvoiceLine.Quantity);
                ReceiptLines.VALIDATE(ReceiptLines."Unit Price", PostedSalesInvoiceLine."Unit Price");
                ReceiptLines.Validate(ReceiptLines."VAT Prod. Posting Group", PostedSalesInvoiceLine."VAT Prod. Posting Group");
                ReceiptLines.Validate(ReceiptLines."VAT Bus. Posting Group", PostedSalesInvoiceLine."VAT Bus. Posting Group");
                ReceiptLines.VALIDATE(ReceiptLines."Location Code", PostedSalesInvoiceLine."Location Code");
                ReceiptLines.VALIDATE(ReceiptLines."User ID", PostedSalesInvoiceHeader."User ID");
                ReceiptLines.VALIDATE(Drawer, GetDrawerDetail());
                ReceiptLines.VALIDATE("Posted Invoice No.", InvoiceDocNo);
                ReceiptLines.VALIDATE(ReceiptLines."Line Discount %", PostedSalesInvoiceLine."Line Discount %");
                ReceiptLines.VALIDATE(ReceiptLines."Inv. Discount Amount", PostedSalesInvoiceLine."Inv. Discount Amount");
                ReceiptLines.INSERT(TRUE);
            UNTIL PostedSalesInvoiceLine.NEXT = 0;
        END;
    end;

    procedure ClearPOS()
    var
        POSLine: Record "Sales Line";
    begin
        POSLine.RESET;
        POSLine.SETRANGE(POSLine."Document Type", "Document Type");
        POSLine.SETRANGE(POSLine."Document No.", "No.");
        IF POSLine.FINDSET THEN
            POSLine.DELETEALL;

        VALIDATE("Cash Tendered", 0);
        MODIFY;
    end;

    procedure GetDrawerDetail(): Code[20]
    var
        UserSetup: Record "User Setup";
        DrawerRec: Record "Voucher And Receipt";
    begin
        UserSetup.GET(USERID);
        DrawerRec.RESET;
        DrawerRec.SETRANGE("Document Type", DrawerRec."Document Type"::Drawer);
        DrawerRec.SETRANGE(User, USERID);
        IF DrawerRec.FINDFIRST THEN
            EXIT(DrawerRec."No.");
    end;

    procedure CreateSalesLines(CrossReference: Code[20])
    var
        SalesLine: Record "Sales Line";
        UserSetup: Record "User Setup";
        LineNo: Integer;
    begin
        LineNo := 10000;
        UserSetup.GET(USERID);
        CheckUserSetupAndDrawer();
        SalesLine.RESET;
        SalesLine.SETRANGE(SalesLine."Document Type", "Document Type");
        SalesLine.SETRANGE("Document No.", "No.");
        IF SalesLine.FINDLAST THEN BEGIN
            LineNo := SalesLine."Line No.";
            SalesLine.INIT;
            SalesLine.VALIDATE("Document Type", "Document Type");
            SalesLine.Validate("Document Type Pos", "Document Type Pos");
            SalesLine.VALIDATE(SalesLine."Document No.", "No.");
            SalesLine.VALIDATE(SalesLine."Line No.", LineNo + 10000);
            SalesLine.VALIDATE(SalesLine."Sell-to Customer No.", "Sell-to Customer No.");
            SalesLine.VALIDATE(SalesLine.Type, SalesLine.Type::Item);
            SalesLine.VALIDATE(SalesLine."Cross-Reference No.", CrossReference);
            SalesLine.VALIDATE(SalesLine."Location Code", "Location Code");
            SalesLine.INSERT(TRUE);
        END ELSE BEGIN
            SalesLine.INIT;
            SalesLine.VALIDATE("Document Type", "Document Type");
            SalesLine.Validate("Document Type Pos", "Document Type Pos");
            SalesLine.VALIDATE(SalesLine."Document No.", "No.");
            SalesLine.VALIDATE(SalesLine."Line No.", LineNo);
            SalesLine.VALIDATE(SalesLine."Sell-to Customer No.", "Sell-to Customer No.");
            SalesLine.VALIDATE(SalesLine.Type, SalesLine.Type::Item);
            SalesLine.VALIDATE(SalesLine."Cross-Reference No.", CrossReference);
            SalesLine.VALIDATE(SalesLine."Location Code", "Location Code");
            SalesLine.INSERT(TRUE);
        END;
    end;

    procedure CheckReceiptAmount()
    var
        myInt: Integer;
    begin
        IF ("Cash Tendered" < "Amount Including VAT") THEN
            ERROR(T0003, "Cash Tendered", "Amount Including VAT");
    end;

    procedure GetPstdDocLinesToReverePOS(PostedSalesLine: Record "Sales Invoice Line")
    var
        myInt: Integer;
    begin

    end;

    procedure ReturnWholeInvoiceAndPayment()
    var
        CustomerLegderEntry: Record "Cust. Ledger Entry";
        CustEntryApplyPostedEntries: Codeunit "CustEntry-Apply Posted Entries";
        PaymentEntryNo: Integer;
        PaymentDocumentNo: Code[20];
        CustomizeEvents: Codeunit "Customize Events";
    begin

        IF CONFIRM(T0004, FALSE) THEN BEGIN
            CustomerLegderEntry.RESET;
            CustomerLegderEntry.SETRANGE(CustomerLegderEntry."Customer No.", "Sell-to Customer No.");
            CustomerLegderEntry.SETRANGE(CustomerLegderEntry."Document Type", CustomerLegderEntry."Document Type"::Payment);
            CustomerLegderEntry.SETRANGE(CustomerLegderEntry.Open, FALSE);
            IF CustomerLegderEntry.FINDLAST THEN BEGIN
                PaymentEntryNo := CustomerLegderEntry."Entry No.";
                PaymentDocumentNo := CustomerLegderEntry."Document No.";
            END;

            CustomerLegderEntry.RESET;
            CustomerLegderEntry.SETRANGE(CustomerLegderEntry."Customer No.", "Sell-to Customer No.");
            CustomerLegderEntry.SETRANGE(CustomerLegderEntry."Document Type", CustomerLegderEntry."Document Type"::Invoice);
            CustomerLegderEntry.SETRANGE(CustomerLegderEntry.Open, FALSE);
            IF CustomerLegderEntry.FINDLAST THEN BEGIN
                // Unapply the Invoice from the Payment
                CustomizeEvents.UnApplyCustLedgEntryPOS(CustomerLegderEntry."Entry No.", CustomerLegderEntry."Document No.");
                // Reverse the Payment by Reversing
                ReverseCustomerPayment(PaymentEntryNo);
                // Reverse the Invoice by Credit Memo
                CreateAndPostCreditMemo(CustomerLegderEntry);
                MESSAGE(T0005, CustomerLegderEntry."Document No.", PaymentDocumentNo);
            END;
        END;
    end;

    procedure ReverseCustomerPayment(CustLedgerEntryNo: Integer)
    var
        ReversalEntry: Record "Reversal Entry";
        CustomerPaymentEntry: Record "Cust. Ledger Entry";
    begin
        CustomerPaymentEntry.GET(CustLedgerEntryNo);
        CLEAR(ReversalEntry);
        ReversalEntry.SetHideDialog(TRUE);
        IF CustomerPaymentEntry.Reversed THEN
            ReversalEntry.AlreadyReversedEntry(CustomerPaymentEntry.TABLECAPTION, CustLedgerEntryNo);
        IF CustomerPaymentEntry."Journal Batch Name" = '' THEN
            ReversalEntry.TestFieldError;
        CustomerPaymentEntry.TESTFIELD("Transaction No.");
        ReversalEntry.ReverseTransaction(CustomerPaymentEntry."Transaction No.");
    end;

    procedure CreateAndPostCreditMemo(CustInvoiceEntry: Record "Cust. Ledger Entry")
    var
        CreditMemoHeader: Record "Sales Header";
        CopySalesDoc: Report "Copy Sales Document";
        SalesPost: Codeunit "Sales-Post";
    begin
        // Create Credit Memo
        CreditMemoHeader.INIT;
        CreditMemoHeader.VALIDATE(CreditMemoHeader."Document Type", CreditMemoHeader."Document Type"::"Credit Memo");
        CreditMemoHeader.VALIDATE(CreditMemoHeader."Sell-to Customer No.", "Sell-to Customer No.");
        CreditMemoHeader.INSERT(TRUE);
        CopySalesDoc.SetSalesHeader(CreditMemoHeader);
        CopySalesDoc.InitializeRequest(7, CustInvoiceEntry."Document No.", TRUE, FALSE);
        CopySalesDoc.USEREQUESTPAGE := FALSE;
        CopySalesDoc.RUNMODAL;
        CLEAR(CopySalesDoc);
        CLEAR(SalesPost);
        SalesPost.RUN(CreditMemoHeader);
    end;

    procedure ResetDates()
    var
        myInt: Integer;
    begin
        VALIDATE("Posting Date", WORKDATE);
        VALIDATE("Document Date", WORKDATE);
        VALIDATE("Due Date", WORKDATE);
        VALIDATE("Requested Delivery Date", WORKDATE);
        MODIFY;
    end;

    procedure InitializePOS()
    var
        UserSetup: Record "User Setup";
        DrawerRec: Record "Voucher And Receipt";
        CustomerRec: Record Customer;
    begin
        UserSetup.GET(USERID);
        UserSetup.TESTFIELD("Location Code");
        UserSetup.TESTFIELD(UserSetup."Sell-to Customer No.");
        IF CustomerRec.GET(UserSetup."Sell-to Customer No.") THEN
            CustomerRec.CreatePOSHeader(UserSetup."Location Code", GetDrawerDetail());
    end;

    procedure GetVATPostingSetup(VATBusPostingGroup: Code[20]): Boolean
    var
        VATPostingSetup: Record "VAT Posting Setup";
    begin
        VATPostingSetup.RESET;
        VATPostingSetup.SETRANGE("VAT Bus. Posting Group", VATBusPostingGroup);
        VATPostingSetup.SETFILTER("VAT %", '>0');
        IF VATPostingSetup.FINDFIRST THEN
            EXIT(TRUE)
        ELSE
            EXIT(FALSE);
    end;
}
report 50001 "Payment Voucher"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'PaymentVoucher.rdl';

    dataset
    {
        dataitem(CopyLoop; Integer)
        {
            column(Copy_Number; CopyLoop.Number)
            {

            }

            Column(CompanyInfo_Name; CompanyInfo.Name)
            {

            }
            Column(CompanyInfo_Address; CompanyInfo.Address)
            {

            }
            Column(CompanyInfo_Address_2; CompanyInfo."Address 2")
            {

            }
            Column(CompanyInfo_City; CompanyInfo.City)
            {

            }
            Column(CompanyInfo_Phone_No_; CompanyInfo."Phone No.")
            {

            }
            Column(CompanyInfo_E_Mail; CompanyInfo."E-Mail")
            {

            }
            Column(CompanyInfo_Home_Page; CompanyInfo."Home Page")
            {

            }
            Column(CompanyInfo_Post_Code; CompanyInfo."Post Code")
            {

            }
            Column(CompanyInfo_County; CompanyInfo.County)
            {

            }
            Column(CompanyInf_oCountry_Region_Code; CompanyInfo."Country/Region Code")
            {

            }
            Column(CompanyInfo_Picture; CompanyInfo.Picture)
            {

            }
            Column(Title; Title)
            {

            }
            Column(BankName; BankName)
            {

            }
            Column(BankCash; BankCash)
            {

            }
            Column(UserName; UserName)
            {

            }

            //DataItem Triggers
            trigger OnPreDataItem()
            var

            begin
                IF NoOfCopies < 1 THEN
                    NoOfCopies := 1;
                CopyLoop.SETRANGE(CopyLoop.Number, 1, NoOfCopies);
                IF (BankCash = BankCash::Cheque) THEN
                    Title := Text003
                ELSE
                    IF (BankCash = BankCash::Cash) THEN
                        Title := Text002
                    ELSE
                        Title := Text001;
            end;
        }

        //GLedgerRegistry
        dataitem("G/L Register"; "G/L Register")
        {
            DataItemLinkReference = CopyLoop;
            DataItemTableView = sorting("No.");

            trigger OnPreDataItem()
            var
                myInt: Integer;
            begin
                IF PrintedFromCustomerLedgerEntry THEN
                    CurrReport.BREAK;
            end;
        }

        //GLedgerEntry
        dataitem("G/L Entry"; "G/L Entry")
        {
            DataItemLinkReference = CopyLoop;
            DataItemTableView = sorting("Entry No.");

            trigger OnPreDataItem()
            var
                myInt: Integer;
            begin
                IF PrintedFromCustomerLedgerEntry THEN
                    CurrReport.BREAK;
                SETRANGE("Entry No.", "G/L Register"."From Entry No.", "G/L Register"."To Entry No.");
                CurrReport.CREATETOTALS(Amount);
            end;
        }

        //"Voucher And Receipt"
        dataitem("Sales Comment Line"; "Voucher And Receipt")
        {
            DataItemLinkReference = CopyLoop;
            DataItemTableView = SORTING("Document Type", "No.", "Document Line No.", "Line No.")
            WHERE("Document Type" = CONST("Payment Voucher"));
            Column(Document_No_PaymentVoucher; "Sales Comment Line"."No.") { }
            Column(Posting_Date_PaymentVoucher; "Sales Comment Line"."Posting Date") { }
            Column(Document_Date_PaymentVoucher; "Sales Comment Line"."Document Date") { }
            Column(External_Doc_No_PaymentVoucher; "Sales Comment Line"."External Doc. No.") { }
            Column(Requested_by_PaymentVoucher; "Sales Comment Line"."Requested by") { }
            Column(Received_by_PaymentVoucher; "Sales Comment Line"."Received by") { }
            Column(Authorised_by_PaymentVoucher; "Sales Comment Line"."Authorised by") { }
            Column(Account_Type_PaymentVoucher; "Sales Comment Line"."Account Type") { }
            Column(Account_No_PaymentVoucher; "Sales Comment Line"."Account No.") { }
            Column(Description_PaymentVoucher; "Sales Comment Line".Description) { }
            Column(Amount_PaymentVoucher; "Sales Comment Line".Amount) { }
            Column(Amount_LCY_PaymentVoucher; "Sales Comment Line"."Amount (LCY)") { }
            Column(WHTAmount_SalesCommentLine; "Sales Comment Line"."WHT Amount") { }
            Column(Reviewedby_PaymentVoucher; "Sales Comment Line"."Reviewed by") { }
            Column(Bal_Account_Type_PaymentVoucher; "Sales Comment Line"."Bal. Account Type") { }
            Column(Bal_Account_No_PaymentVoucher; "Sales Comment Line"."Bal. Account No.") { }
            Column(Global_Dimension_1_Code_PaymentVoucher; "Sales Comment Line"."Shortcut Dimension 1 Code") { }
            Column(Global_Dimension_2_Code_PaymentVoucher; "Sales Comment Line"."Shortcut Dimension 2 Code") { }
            Column(Journal_Template_Name_PaymentVoucher; "Sales Comment Line"."Journal Template Name") { }
            Column(Journal_Batch_Name_PaymentVoucher; "Sales Comment Line"."Journal Batch Name") { }
            Column(Currency_Code_PaymentVoucher; "Sales Comment Line"."Currency Code") { }
            Column(Currency_Factor_PaymentVoucher; "Sales Comment Line"."Currency Factor") { }
            Column(ShortcutDimension3Code_SalesCommentLine; "Sales Comment Line"."Shortcut Dimension 3 Code") { }
            Column(AmountInWords; AmountInWords[1] + ' ' + AmountInWords[2]) { }
            Column(Customer_Name; Customer.Name) { }
            Column(BankSlipNo; BankSlipNo) { }
            Column(BankSlipDate; BankSlipDate) { }
            Column(CustomerBalance; CustomerBalance) { }
            Column(CustomerTel; CustomerTel) { }
            Column(BeingPaymentFor; BeingPaymentFor) { }
            Column(ApproverID; ApproverID) { }
            Column(ApprovalDate; ApprovalDate) { }
            Column(PreparedBy; PreparedBy) { }
            Column(PreparedDate; PreparedDate) { }
            Column(GlobalDimension1Caption; GlobalDimension1Caption) { }
            Column(TotalAmount; TotalAmount) { }
            Column(TotalAmountLCY; TotalAmountLCY) { }
            Column(JournalLine_Paid_To_Received; JournalLine."Paid To/Received From") { }
            Column(ProgrammeCode; ProgrammeCode) { }
            Column(StaffCode; StaffCode) { }
            Column(TotalAmount2; TotalAmount2) { }
            Column(VendorName; VendorName) { }
            Column(VendorNumber; VendorNumber) { }

            trigger OnPreDataItem()
            var
                myInt: Integer;
            begin
                TotalAmount := 0;
                SETRANGE("Document Type", "Sales Comment Line"."Document Type"::"Payment Voucher");
                SETRANGE("No.", PrintDocumentNo);

                /*{
                I := 0;
                                ProvisionalAmount := 0;
                                SalesCommentLine.RESET;
                                SalesCommentLine.SETRANGE("Document Type", SalesCommentLine."Document Type"::"Payment Voucher");
                                SalesCommentLine.SETRANGE("No.", PrintDocumentNo);
                                IF SalesCommentLine.FINDFIRST THEN
                                    REPEAT
                                        I += 1;
                                        ProvisionalAmount += SalesCommentLine.Amount;
                                        ProvisionalAmountLCY += SalesCommentLine."Amount (LCY)";
                                        IF (Bank.GET(SalesCommentLine."Bal. Account No.")) THEN BEGIN
                                            IF (BankName = '') THEN
                                                BankName := Bank.Name;
                                        END;

                                    UNTIL SalesCommentLine.NEXT = 0;

                                IF (I = 1) THEN BEGIN
                                    TotalAmount := ProvisionalAmount;
                                    TotalAmountLCY := ProvisionalAmountLCY;
                                END ELSE
                                    IF (I > 1) THEN BEGIN
                                        TotalAmount := ProvisionalAmount / 2;
                                        TotalAmountLCY := ProvisionalAmountLCY / 2;
                                    END;
                }*/
            end;

            trigger OnAfterGetRecord()
            var
                PaymentVoucher: Record "Voucher And Receipt";
                PaymentVoucher5: Record "Voucher And Receipt";
                VendorLedgerEntries: Record "Vendor Ledger Entry";
                PaymentVoucher6: Record "Voucher And Receipt";
            begin
                // Amount Format
                TotalAmount := 0;
                PaymentVoucher.RESET;
                PaymentVoucher.SETRANGE("Document Type", PaymentVoucher."Document Type"::"Payment Voucher");
                PaymentVoucher.SETRANGE("No.", "Sales Comment Line"."No.");
                IF PaymentVoucher.FINDSET THEN BEGIN
                    IF PaymentVoucher.COUNT > 1 THEN
                        REPEAT
                            IF PaymentVoucher.Amount > 0 THEN BEGIN
                                TotalAmount += PaymentVoucher.Amount;
                                TotalAmountLCY += PaymentVoucher."Amount (LCY)";
                            END;
                        UNTIL PaymentVoucher.NEXT = 0
                    ELSE
                        TotalAmount := ABS(PaymentVoucher.Amount);
                    TotalAmountLCY := ABS(PaymentVoucher."Amount (LCY)");
                END;
                IF TotalAmount = 0 THEN BEGIN
                    PaymentVoucher.RESET;
                    PaymentVoucher.SETRANGE("Document Type", PaymentVoucher."Document Type"::"Payment Voucher");
                    PaymentVoucher.SETRANGE("No.", "Sales Comment Line"."No.");
                    IF PaymentVoucher.FINDSET THEN BEGIN
                        IF PaymentVoucher.COUNT > 1 THEN
                            REPEAT
                                IF TotalAmount < 0 THEN BEGIN
                                    TotalAmount += ABS(PaymentVoucher.Amount);
                                    TotalAmountLCY += ABS(PaymentVoucher."Amount (LCY)");
                                END;
                            UNTIL PaymentVoucher.NEXT = 0
                        ELSE
                            TotalAmount := ABS(PaymentVoucher.Amount);
                        TotalAmountLCY := ABS(PaymentVoucher."Amount (LCY)");
                    END;
                END;
                // Amount in Words
                CheckReport.InitTextVariable;
                GenLedgerSetup.GET;
                IF "Sales Comment Line"."Currency Code" <> '' THEN
                    CheckReport.FormatNoText(AmountInWords, (TotalAmount + PaymentVoucher."WHT Amount"), "Sales Comment Line"."Currency Code")
                ELSE
                    CheckReport.FormatNoText(AmountInWords, (TotalAmountLCY + PaymentVoucher."WHT Amount"), GenLedgerSetup."LCY Code");
                CurrencyCode := JournalLine."Currency Code";

                // Global Dimension
                GlobalDimension1Caption := "Sales Comment Line".FIELDCAPTION("Shortcut Dimension 1 Code");

                //Checking the total whether it's balancing
                TotalAmount2 := 0;
                PaymentVoucher5.RESET;
                PaymentVoucher5.SETRANGE("Document Type", PaymentVoucher5."Document Type"::"Payment Voucher");
                PaymentVoucher5.SETRANGE("No.", "Sales Comment Line"."No.");
                IF PaymentVoucher5.FINDSET THEN BEGIN
                    IF PaymentVoucher5.COUNT > 1 THEN
                        REPEAT
                            TotalAmount2 += PaymentVoucher5."Amount (LCY)";
                        UNTIL PaymentVoucher5.NEXT = 0;
                END;

                //get the name and number of the vendor
                PaymentVoucher6.RESET;
                PaymentVoucher6.SETRANGE("Document Type", PaymentVoucher6."Document Type"::"Payment Voucher");
                PaymentVoucher6.SETRANGE("No.", "Sales Comment Line"."No.");
                PaymentVoucher6.SETRANGE("Account Type", PaymentVoucher6."Account Type"::Vendor);
                IF PaymentVoucher6.FINDFIRST THEN BEGIN
                    VendorNumber := PaymentVoucher6."Account No.";
                    vendorTab.RESET;
                    vendorTab.SETRANGE(vendorTab."No.", VendorNumber);
                    IF vendorTab.FINDFIRST THEN
                        VendorName := vendorTab.Name;
                END;
                //MESSAGE(VendorName);
                // Getting the prpogramm dimension code
                DimensionSetId.RESET;
                DimensionSetId.SETRANGE("Dimension Set ID", "Sales Comment Line"."Dimension Set ID");
                DimensionSetId.SETRANGE("Dimension Code", 'PROGRAMMES');
                IF DimensionSetId.FINDFIRST THEN
                    ProgrammeCode := DimensionSetId."Dimension Value Code";

                //Getting the staff code
                DimensionSetId.RESET;
                DimensionSetId.SETRANGE("Dimension Set ID", "Sales Comment Line"."Dimension Set ID");
                DimensionSetId.SETRANGE("Dimension Code", 'STAFF');
                IF DimensionSetId.FINDFIRST THEN
                    StaffCode := DimensionSetId."Dimension Value Code";

                //Geting the document number
                DocumentNumber := PaymentVoucher."No.";
                /*{
                //Getting the applied entries
                VendorLedgerEntries.RESET;
                                VendorLedgerEntries.SETRANGE(VendorLedgerEntries."Applies-to ID", "Sales Comment Line"."No.");
                                IF VendorLedgerEntries.FINDSET THEN BEGIN
                                    IF ("Sales Comment Line"."Account Type" = "Sales Comment Line"."Account Type"::Vendor) THEN BEGIN
                                        VendorInvoiceDate := VendorLedgerEntries."Posting Date";
                                        VendorInvoiceDocumentType := VendorLedgerEntries."Document Type";
                                        VendorInvoiceDocumentNo := VendorLedgerEntries."Document No.";
                                        VendorInvoiceDescription := VendorLedgerEntries.Description;
                                        VendorInvoiceCurrency := VendorLedgerEntries."Currency Code";
                                        VendorInvoiceAmount := VendorLedgerEntries."Original Amount";
                                        VendorInvoiceRemainingAmount := (VendorLedgerEntries."Original Amount" - VendorLedgerEntries."Amount to Apply");
                                    END;
                                END;
                  }*/
            end;

            trigger OnPostDataItem()
            var
                myInt: Integer;
            begin

                IF TotalAmount2 <> 0 THEN
                    MESSAGE('Document No. %1 is Out Of balance by:  %2', DocumentNumber, TotalAmount2);

            end;
        }

        dataitem(vendorinvoice; "Voucher And Receipt")
        {
            DataItemLinkReference = CopyLoop;
            DataItemTableView = SORTING("Document Type", "No.", "Document Line No.", "Line No.") WHERE("Document Type" = CONST("Payment Voucher"), "Account Type" = CONST(Vendor));

            column(AccountType_VendorInvoice; vendorinvoice."Account Type") { }
            column(hasLedgerEntries; hasLedgerEntries) { }
            trigger OnPreDataItem()
            var
                myInt: Integer;
            begin
                SETRANGE("Document Type", vendorinvoice."Document Type"::"Payment Voucher");
                SETRANGE("No.", PrintDocumentNo);
            end;

            trigger OnAfterGetRecord()
            var
                myInt: Integer;
            begin
                //Getting the applied entries
                VendorLedgerEntries.RESET;
                VendorLedgerEntries.SETRANGE(VendorLedgerEntries."Applies-to ID", vendorinvoice."No.");
                IF VendorLedgerEntries.FINDFIRST THEN BEGIN
                    VendorInvoiceDate := VendorLedgerEntries."Posting Date";
                    VendorInvoiceDocumentType := VendorLedgerEntries."Document Type";
                    VendorInvoiceDocumentNo := VendorLedgerEntries."Document No.";
                    VendorInvoiceDescription := VendorLedgerEntries.Description;
                    VendorInvoiceCurrency := VendorLedgerEntries."Currency Code";
                    VendorInvoiceAmount := VendorLedgerEntries."Original Amount";
                    VendorInvoiceRemainingAmount := (VendorLedgerEntries."Original Amount" - VendorLedgerEntries."Amount to Apply");
                    hasLedgerEntries := true;
                END;

            end;
        }

        dataitem("Vendor Ledger Entry"; "Vendor Ledger Entry")
        {
            DataItemLinkReference = vendorinvoice;
            DataItemLink = "Applies-to ID" = FIELD("No.");

            Column(PostingDate_VendorLedgerEntry; "Vendor Ledger Entry"."Posting Date") { }
            Column(DocumentType_VendorLedgerEntry; "Vendor Ledger Entry"."Document Type") { }
            Column(DocumentNo_VendorLedgerEntry; "Vendor Ledger Entry"."Document No.") { }
            Column(Description_VendorLedgerEntry; "Vendor Ledger Entry".Description) { }
            Column(CurrencyCode_VendorLedgerEntry; "Vendor Ledger Entry"."Currency Code") { }
            Column(Amount_VendorLedgerEntry; "Vendor Ledger Entry".Amount) { }
            Column(RemainingAmount_VendorLedgerEntry; "Vendor Ledger Entry"."Remaining Amount") { }
            Column(AmounttoApply_VendorLedgerEntry; "Vendor Ledger Entry"."Amount to Apply") { }
            Column(InvoicedQuantity; InvoicedQuantity) { }
            column(InvoiceUnitPrice; InvoiceUnitPrice) { }
            Column(ExternalDocumentNo_VendorLedgerEntry; "Vendor Ledger Entry"."External Document No.") { }


            trigger OnPreDataItem()
            var

            begin
                SetFilter("Vendor Ledger Entry"."Applies-to ID", '<>%1', '');
            end;

            trigger OnAfterGetRecord()
            var
                myInt: Integer;
                PurchInvLine: Record "Purch. Inv. Line";
                PurchaseInvLine1: Record "Purch. Inv. Line";
            begin
                InvoicedQuantity := 0;
                InvoiceUnitPrice := 0;
                PurchInvLine.RESET;
                PurchInvLine.SETRANGE(PurchInvLine."Document No.", "Document No.");
                PurchInvLine.SETRANGE(PurchInvLine."Posting Date", "Posting Date");
                PurchInvLine.SETRANGE(PurchInvLine."Buy-from Vendor No.", "Vendor Ledger Entry"."Vendor No.");
                IF PurchInvLine.FINDFIRST THEN BEGIN
                    REPEAT
                        InvoicedQuantity += PurchInvLine.Quantity;
                    UNTIL PurchInvLine.NEXT = 0;
                END;
                //Message(Format(hasLedgerEntries));

                //Getting the unit price
                PurchaseInvLine1.Reset();
                PurchaseInvLine1.SetRange(PurchaseInvLine1."Document No.", "Document No.");
                PurchaseInvLine1.SetRange(PurchaseInvLine1."Posting Date", "Posting Date");
                PurchaseInvLine1.SetRange(PurchaseInvLine1.Type, PurchaseInvLine1.Type::Item);
                PurchaseInvLine1.SetRange(PurchaseInvLine1."No.", '1000');
                if PurchaseInvLine1.FindFirst() then begin
                    InvoiceUnitPrice := PurchaseInvLine1."Unit Cost";
                end;
            end;
        }

    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    field("No Of Copies"; NoOfCopies)
                    {
                        ApplicationArea = All;

                    }
                    field("Cheque/Cash"; BankCash)
                    {
                        ApplicationArea = All;
                    }

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
        DetailedCustLedgerEntry: Record "Detailed Cust. Ledg. Entry";
        ApprovalEntry: Record "Approval Entry";
        ApprovalEntry1: Record "Approval Entry";
        SalesCommentLine: Record "Voucher And Receipt";
        Bank: Record "Bank Account";
        TotalAmount: Decimal;
        ProvisionalAmount: Decimal;
        TotalAmountLCY: Decimal;
        ProvisionalAmountLCY: Decimal;
        AmountInWords: array[2] of Text[80];
        CheckReport: Report Check;
        GenLedgerSetup: Record "General Ledger Setup";
        Customer: Record Customer;
        BankSlipNo: Code[30];
        Text001: Label 'CASH/CHEQUE PAYMENT VOUCHER';
        Text002: Label 'CASH/CHEQUE PAYMENT VOUCHER';
        Text003: label 'CASH/CHEQUE PAYMENT VOUCHER';
        BankSlipDate: Date;
        BankAccountLedgerEntry: Record "Bank Account Ledger Entry";
        CustomerBalance: Decimal;
        PrintDocumentNo: Code[20];
        PrintedFromCustomerLedgerEntry: Boolean;
        NoOfCopies: Integer;
        CustomerTel: Text[50];
        ReceiptHeader: Record "Loan and Advance Header";
        BeingPaymentFor: Text[250];
        ApproverID: Code[50];
        ApprovalDate: DateTime;
        PreparedBy: Code[50];
        PreparedDate: DateTime;
        GlobalDimension1Caption: Code[40];
        I: Integer;
        BankCash: Option Cheque,Cash;
        Title: Text[50];
        BankName: Text[50];
        JournalLine: Record "Gen. Journal Line";
        CurrencyCode: Code[30];
        UserName: Text[50];
        User: Record User;
        ProgrammeCode: Text;
        DimensionSetId: Record "Dimension Set Entry";
        hasLedgerEntries: Boolean;
        StaffCode: Text;
        TotalAmount2: Decimal;
        DocumentNumber: Code[30];
        //------------------------------Application-----------------------	
        VendorInvoiceDate: Date;
        VendorInvoiceDocumentType: Option;
        VendorInvoiceDocumentNo: Code[20];
        VendorInvoiceDescription: Text;
        VendorInvoiceCurrency: Code[10];
        VendorInvoiceAmount: Decimal;
        VendorInvoiceRemainingAmount: Decimal;
        VendorLedgerEntries: Record "Vendor Ledger Entry";
        VendorNumber: Code[20];
        VendorName: Text;
        vendorTab: Record Vendor;
        InvoicedQuantity: Decimal;
        InvoiceUnitPrice: Decimal;

    //Report triggers
    trigger OnInitReport()
    var
        myInt: Integer;
    begin
        NoOfCopies := 1;
    end;

    trigger OnPreReport()
    var
        myInt: Integer;
    begin

        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);
        hasLedgerEntries := false;
        //Getting the userName of a particular User
        User.RESET;
        User.SETRANGE("User Name", USERID);
        IF User.FINDFIRST THEN
            UserName := User."Full Name";
    end;


    //----------------------------
    procedure SetPrintedFromCustomerLedgerEntries()
    var
        myInt: Integer;
    begin
        PrintedFromCustomerLedgerEntry := TRUE;
    end;

    //@@@@@@@@@@@@@@@@@@@@@@
    procedure SetPrintDocumentNo(DocNo: Code[20])
    var
        myInt: Integer;
    begin
        PrintDocumentNo := DocNo;
    end;

    local procedure ShowMessage(Totalamount3: Decimal)
    var
        myInt: Integer;
    begin

    end;
}
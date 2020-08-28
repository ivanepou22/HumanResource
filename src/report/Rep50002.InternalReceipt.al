report 50002 "Internal Receipt" //Internal Receipt - MOD
{
    UsageCategory = Administration;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'InternalReceipt.rdl';

    dataset
    {
        /*    dataitem(CopyLoop; Integer)
            {

                Column(Copy_Number; CopyLoop.Number) { }


                //DataItem Triggers
                trigger OnPreDataItem()
                var
                    myInt: Integer;
                begin
                    IF NoOfCopies < 1 THEN
                        NoOfCopies := 1;
                    CopyLoop.SETRANGE(CopyLoop.Number, 1, NoOfCopies);
                end;

            }
    */
        dataitem("Sales Comment Line"; "Voucher And Receipt")
        {
            DataItemTableView = SORTING("Document Type", "No.", "Document Line No.", "Line No.") WHERE("Document Type" = CONST("Internal Receipt"));
            //DataItemLinkReference = CopyLoop;
            Column(CompanyInfo_City; CompanyInfo.City) { }
            Column(CompanyInfo_Address; CompanyInfo.Address) { }
            Column(CompanyInfo_Name; CompanyInfo.Name) { }
            Column(CompanyInfo_Phone_No; CompanyInfo."Phone No.") { }
            Column(CompanyInfo_Fax_No; CompanyInfo."Fax No.") { }
            Column(CompanyInfo_Post_Code; CompanyInfo."Post Code") { }
            Column(CompanyInfo_Country_Region_Code; CompanyInfo."Country/Region Code") { }
            Column(CompanyInfo_Home_Page; CompanyInfo."Home Page") { }
            Column(CompanyInfo_EMail; CompanyInfo."E-Mail") { }
            Column(CompanyInfo_Picture; CompanyInfo.Picture) { }
            Column(AmountInWords; AmountInWords[1] + ' ' + AmountInWords[2]) { }
            Column(Customer_Name; CustomerName) { }
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
            Column(CurrencyCode; CurrencyCode) { }
            Column(Bank_Name; BankName) { }
            Column(DocumentType_SalesCommentLine; "Sales Comment Line"."Document Type") { }
            Column(No_SalesCommentLine; "Sales Comment Line"."No.") { }
            Column(LineNo_SalesCommentLine; "Sales Comment Line"."Line No.") { }
            Column(Date_SalesCommentLine; "Sales Comment Line".Date) { }
            Column(Code_SalesCommentLine; "Sales Comment Line".Code) { }
            Column(Comment_SalesCommentLine; "Sales Comment Line".Comment) { }
            Column(DocumentLineNo_SalesCommentLine; "Sales Comment Line"."Document Line No.") { }
            Column(PostingDate_SalesCommentLine; "Sales Comment Line"."Posting Date") { }
            Column(DocumentDate_SalesCommentLine; "Sales Comment Line"."Document Date") { }
            Column(ExternalDocNo_SalesCommentLine; "Sales Comment Line"."External Doc. No.") { }
            Column(Requestedby_SalesCommentLine; "Sales Comment Line"."Requested by") { }
            Column(Receivedby_SalesCommentLine; "Sales Comment Line"."Received by") { }
            Column(Reviewedby_SalesCommentLine; "Sales Comment Line"."Reviewed by") { }
            Column(Authorisedby_SalesCommentLine; "Sales Comment Line"."Authorised by") { }
            Column(AccountType_SalesCommentLine; "Sales Comment Line"."Account Type") { }
            Column(AccountNo_SalesCommentLine; "Sales Comment Line"."Account No.") { }
            Column(Description_SalesCommentLine; "Sales Comment Line".Description) { }
            Column(Amount_SalesCommentLine; "Sales Comment Line".Amount) { }
            Column(AmountLCY_SalesCommentLine; "Sales Comment Line"."Amount (LCY)") { }
            Column(BalAccountType_SalesCommentLine; "Sales Comment Line"."Bal. Account Type") { }
            Column(BalAccountNo_SalesCommentLine; "Sales Comment Line"."Bal. Account No.") { }
            Column(ShortcutDimension1Code_SalesCommentLine; "Sales Comment Line"."Shortcut Dimension 1 Code") { }
            Column(ShortcutDimension2Code_SalesCommentLine; "Sales Comment Line"."Shortcut Dimension 2 Code") { }
            Column(JournalTemplateName_SalesCommentLine; "Sales Comment Line"."Journal Template Name") { }
            Column(JournalBatchName_SalesCommentLine; "Sales Comment Line"."Journal Batch Name") { }
            Column(CurrencyCode_SalesCommentLine; "Sales Comment Line"."Currency Code") { }
            Column(CurrencyFactor_SalesCommentLine; "Sales Comment Line"."Currency Factor") { }
            Column(Posted_SalesCommentLine; "Sales Comment Line".Posted) { }
            Column(PaymentMethod_SalesCommentLine; "Sales Comment Line"."Payment Method") { }
            Column(User_SalesCommentLine; "Sales Comment Line".User) { }
            Column(DimensionSetID_SalesCommentLine; "Sales Comment Line"."Dimension Set ID") { }
            Column(Make_SalesCommentLine; "Sales Comment Line".Make) { }
            Column(Center_SalesCommentLine; "Sales Comment Line".Center) { }
            Column(Distance_SalesCommentLine; "Sales Comment Line".Distance) { }
            Column(VoucherType_SalesCommentLine; "Sales Comment Line"."Voucher Type") { }
            Column(FuelWorthLtrs_SalesCommentLine; "Sales Comment Line"."Fuel Worth(Ltrs)") { }
            Column(FuelWorhtLCY_SalesCommentLine; "Sales Comment Line"."Fuel Worht(LCY)") { }
            Column(MaintenanceWorthLCY_SalesCommentLine; "Sales Comment Line"."Maintenance Worth(LCY)") { }
            Column(Used_SalesCommentLine; "Sales Comment Line".Used) { }
            Column(Driver_SalesCommentLine; "Sales Comment Line".Driver) { }
            Column(DateFilter_SalesCommentLine; "Sales Comment Line"."Date Filter") { }
            Column(VehicleNo_SalesCommentLine; "Sales Comment Line"."Vehicle No") { }
            Column(NoSeries_SalesCommentLine; "Sales Comment Line"."No. Series") { }
            Column(BodyType_SalesCommentLine; "Sales Comment Line"."Body Type") { }
            Column(VehicleType_SalesCommentLine; "Sales Comment Line"."Vehicle Type") { }
            Column(DateCreate_SalesCommentLine; "Sales Comment Line"."Date Create") { }
            Column(LastDateModified_SalesCommentLine; "Sales Comment Line"."Last Date Modified") { }
            Column(CreatedBy_SalesCommentLine; "Sales Comment Line"."Created By") { }
            Column(LastModifiedBy_SalesCommentLine; "Sales Comment Line"."Last Modified By") { }
            Column(Item_SalesCommentLine; "Sales Comment Line".Item) { }
            Column(ItemDescription_SalesCommentLine; "Sales Comment Line"."Item Description") { }
            Column(UnitCost_SalesCommentLine; "Sales Comment Line"."Unit Cost") { }
            Column(AvailableQuantity_SalesCommentLine; "Sales Comment Line"."Available Quantity") { }
            Column(UnitofMeasureCode_SalesCommentLine; "Sales Comment Line"."Unit of Measure Code") { }
            Column(Branch_SalesCommentLine; "Sales Comment Line".Branch) { }
            Column(Price_SalesCommentLine; "Sales Comment Line".Price) { }
            Column(GlobalDimension1Filter_SalesCommentLine; "Sales Comment Line"."Global Dimension 1 Filter") { }
            Column(GlobalDimension2Filter_SalesCommentLine; "Sales Comment Line"."Global Dimension 2 Filter") { }
            Column(LocationFilter_SalesCommentLine; "Sales Comment Line"."Location Filter") { }
            Column(BranchBank_SalesCommentLine; "Sales Comment Line"."Branch Bank") { }
            Column(Approvedby_SalesCommentLine; "Sales Comment Line"."Approved by") { }
            Column(Preparedby_SalesCommentLine; "Sales Comment Line"."Prepared by") { }
            Column(AppliedInvoices_SalesCommentLine; "Sales Comment Line"."Applied Invoices") { }
            Column(ItemJournalTemplateName_SalesCommentLine; "Sales Comment Line"."Item Journal Template Name") { }
            Column(ItemJournalBatchName_SalesCommentLine; "Sales Comment Line"."Item Journal Batch Name") { }
            Column(ItemQuantity_SalesCommentLine; "Sales Comment Line"."Item Quantity") { }
            Column(ToPost_SalesCommentLine; "Sales Comment Line"."To Post") { }

            //triger
            trigger OnPreDataItem()
            var
                myInt: Integer;
            begin
                TotalAmount := 0;
                SETRANGE("Document Type", "Sales Comment Line"."Document Type"::"Internal Receipt");
                SETRANGE("No.", PrintDocumentNo);

                I := 0;
                ProvisionalAmount := 0;
                SalesCommentLine.RESET;
                SalesCommentLine.SETRANGE("Document Type", SalesCommentLine."Document Type"::"Internal Receipt");
                SalesCommentLine.SETRANGE("No.", PrintDocumentNo);
                IF SalesCommentLine.FINDFIRST THEN
                    REPEAT
                        I += 1;
                        ProvisionalAmount += SalesCommentLine.Amount;
                    UNTIL SalesCommentLine.NEXT = 0;

                IF (I = 1) THEN
                    TotalAmount := ProvisionalAmount
                ELSE
                    IF (I > 1) THEN
                        TotalAmount := ProvisionalAmount / 2;

            end;

            trigger OnAfterGetRecord()
            var
                myInt: Integer;
            begin

                CheckReport.InitTextVariable;
                GenLedgerSetup.GET;
                IF "Sales Comment Line"."Currency Code" <> '' THEN BEGIN
                    CheckReport.FormatNoText(AmountInWords, ABS("Sales Comment Line".Amount), "Sales Comment Line"."Currency Code");
                    CurrencyCode := "Sales Comment Line"."Currency Code";
                END ELSE BEGIN
                    CheckReport.FormatNoText(AmountInWords, ABS("Sales Comment Line".Amount), GenLedgerSetup."LCY Code");
                    CurrencyCode := GenLedgerSetup."LCY Code";
                END;

                GlobalDimension1Caption := "Sales Comment Line".FIELDCAPTION("Shortcut Dimension 1 Code");

                IF ("Sales Comment Line"."Account Type" = "Sales Comment Line"."Account Type"::Customer) THEN BEGIN
                    IF Customer.GET("Sales Comment Line"."Account No.") THEN BEGIN
                        Customer.CALCFIELDS(Balance);
                        IF Customer.Balance > 0 THEN
                            CustomerBalance := Customer.Balance
                        ELSE
                            CustomerBalance := 0;

                        CustomerName := Customer.Name;
                        CustomerTel := Customer."Phone No.";
                    END;
                END ELSE
                    IF ("Sales Comment Line"."Bal. Account Type" = "Sales Comment Line"."Bal. Account Type"::Customer) THEN BEGIN
                        IF Customer.GET("Sales Comment Line"."Bal. Account No.") THEN BEGIN
                            Customer.CALCFIELDS(Balance);
                            IF Customer.Balance > 0 THEN
                                CustomerBalance := Customer.Balance
                            ELSE
                                CustomerBalance := 0;

                            CustomerName := Customer.Name;
                            CustomerTel := Customer."Phone No.";
                        END;
                    END ELSE BEGIN
                        CustomerName := "Sales Comment Line".Description;
                        CLEAR(Customer);
                        CustomerBalance := 0;
                    END;

                IF ("Sales Comment Line"."Account Type" = "Sales Comment Line"."Account Type"::"Bank Account") THEN
                    BankName := "Sales Comment Line"."Account No."
                ELSE
                    IF ("Sales Comment Line"."Bal. Account Type" = "Sales Comment Line"."Bal. Account Type"::"Bank Account") THEN
                        BankName := "Sales Comment Line"."Bal. Account No.";

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
                    field(NoOfCopies; NoOfCopies)
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
        myInt: Integer;
        CompanyInfo: Record "Company Information";
        DetailedCustLedgerEntry: Record "Detailed Cust. Ledg. Entry";
        SalesCommentLine: Record "Voucher And Receipt";
        ApprovalEntry: Record "Approval Entry";
        ApprovalEntry1: Record "Approval Entry";
        Customer: Record Customer;
        TotalAmount: Decimal;
        AmountInWords: Array[2] of Text[80];
        CheckReport: Report Check;
        GenLedgerSetup: Record "General Ledger Setup";
        BankSlipNo: Code[30];
        BankSlipDate: Date;
        BankAccountLedgerEntry: Record "Bank Account Ledger Entry";
        CustomerBalance: Decimal;
        PrintDocumentNo: Code[20];
        PrintedFromCustomerLedgerEntry: Boolean;
        NoOfCopies: Integer;
        CustomerTel: Text[50];
        ReceiptHeader: Record "Loan and Advance Header";
        BeingPaymentFor: Text[250];
        I: Integer;
        ProvisionalAmount: Decimal;
        ApproverID: Code[50];
        ApprovalDate: DateTime;
        PreparedBy: Text[100];
        PreparedDate: DateTime;
        GlobalDimension1Caption: Text[100];
        CurrencyCode: Code[10];
        CustomerName: Text[50];
        BankName: Text[50];

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
    end;

    procedure SetPrintedFromCustomerLedgerEntries()
    var
        myInt: Integer;
    begin

        PrintedFromCustomerLedgerEntry := TRUE;
    end;
    //-----------------------------
    procedure SetPrintDocumentNo(DocNo: Code[20])
    var
        myInt: Integer;
    begin
        PrintDocumentNo := DocNo;
    end;
}
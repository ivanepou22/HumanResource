report 50014 "Receipt POS Advanced"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    Caption = 'POS Receipt';
    DefaultLayout = RDLC;
    RDLCLayout = 'PosReceipt.rdlc';

    dataset
    {
        dataitem(CopyLoop; Integer)
        {
            column(Copy_Number; CopyLoop.Number)
            {

            }

            trigger OnPreDataItem()
            var
                myInt: Integer;
            begin
                IF NoOfCopies < 1 THEN
                    NoOfCopies := 1;
                CopyLoop.SETRANGE(CopyLoop.Number, 1, NoOfCopies);
            end;
        }

        dataitem("G/L Register"; "G/L Register")
        {
            DataItemTableView = sorting("No.");
            DataItemLinkReference = CopyLoop;

            trigger OnPreDataItem()
            var
                myInt: Integer;
            begin
                IF PrintedFromCustomerLedgerEntry THEN
                    CurrReport.BREAK;
                IF PrintedFromSalesLine THEN
                    CurrReport.BREAK;
            end;
        }

        dataitem("G/L Entry"; "G/L Entry")
        {
            DataItemTableView = sorting("Entry No.");
            DataItemLinkReference = CopyLoop;

            trigger OnPreDataItem()
            var
                myInt: Integer;
            begin
                IF PrintedFromCustomerLedgerEntry THEN
                    CurrReport.BREAK;
                IF PrintedFromSalesLine THEN
                    CurrReport.BREAK;

                SETRANGE("Entry No.", "G/L Register"."From Entry No.", "G/L Register"."To Entry No.");
                CurrReport.CREATETOTALS(Amount);
            end;
        }

        dataitem("Sales Line"; "Sales Line")
        {
            DataItemLinkReference = CopyLoop;
            Column(CompanyInfo_Name; CompanyInfo.Name) { }
            Column(CompanyInfo_Address; CompanyInfo.Address) { }
            Column(CompanyInfo_Post_Code; CompanyInfo."Post Code") { }
            Column(CompanyInfo_Address_2; CompanyInfo."Address 2") { }
            Column(CompanyInfo_City; CompanyInfo.City) { }
            Column(CompanyInfo_Phone_No_; CompanyInfo."Phone No.") { }
            Column(CompanyInfo_E_Mail; CompanyInfo."E-Mail") { }
            Column(CompanyInfo_Home_Page; CompanyInfo."Home Page") { }
            Column(CompanyInfo_Picture; CompanyInfo.Picture) { }
            Column(SalesLine_PostedSalesInvoiceNo; "Sales Line"."Posted Invoice No.") { }
            Column(SalesLine_SellToCustomerNo; "Sales Line"."Sell-to Customer No.") { }
            Column(SalesLine_PostingDate; "Sales Line"."Posting Date") { }
            Column(SalesLine_DocumentNo; "Sales Line"."Document No.") { }
            Column(SalesLine_Description; "Sales Line".Description) { }
            Column(SalesLine_No; "Sales Line"."No.") { }
            Column(SalesLine_Quantity; "Sales Line".Quantity) { }
            Column(SalesLine_UnitPrice; "Sales Line"."Unit Price") { }
            Column(SalesLIne_AmountIncludingVAT; "Sales Line"."Amount Including VAT") { }
            Column(AmountInWords; AmountInWords[1] + ' ' + AmountInWords[2]) { }
            Column(CashTendered; CashTendered) { }
            Column(VATAmount; VATAmount) { }
            Column(UserIdentity; UserIdentity) { }

            trigger OnPreDataItem()
            var
                myInt: Integer;
            begin
                TotalAmount := 0;
                IF PrintedFromSalesLine THEN
                    "Sales Line".SETRANGE("Document No.", PrintDocumentNo);
                SalesHeader.GET(SalesHeader."Document Type"::Order, PrintDocumentNo);
                SalesHeader.SetRange(SalesHeader."Document Type Pos", SalesHeader."Document Type Pos"::Receipt);
                CashTendered := SalesHeader."Cash Tendered";
                VATAmount := SalesHeader."VAT Amount";
                UserIdentity := COPYSTR(SalesHeader."User ID", (STRPOS(SalesHeader."User ID", '\') + 1), STRLEN(SalesHeader."User ID"));
            end;

            trigger OnAfterGetRecord()
            var
                myInt: Integer;
            begin

                TotalAmount += "Sales Line"."Amount Including VAT";
                CheckReport.InitTextVariable;
                GenLedgerSetup.GET;
                IF "Sales Line"."Currency Code" <> '' THEN
                    CheckReport.FormatNoText(AmountInWords, TotalAmount, "Sales Line"."Currency Code")
                ELSE
                    CheckReport.FormatNoText(AmountInWords, TotalAmount, GenLedgerSetup."LCY Code");
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
        TotalAmount: Decimal;
        AmountInWords: array[2] of Text[80];
        CheckReport: Report Check;
        GenLedgerSetup: Record "General Ledger Setup";
        Customer: Record Customer;
        BankSlipNo: Code[30];
        BankSlipDate: Date;
        BankAccountLedgerEntry: Record "Bank Account Ledger Entry";
        CustomerBalance: Decimal;
        PrintDocumentNo: Code[20];
        PrintedFromCustomerLedgerEntry: Boolean;
        PrintedFromSalesLine: Boolean;
        NoOfCopies: Integer;
        SalesHeader: Record "Sales Header";
        CashTendered: Decimal;
        VATAmount: Decimal;
        UserIdentity: Code[50];

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



    //==========Procedures=================
    procedure SetPrintedFromCustomerLedgerEntries()
    var
        myInt: Integer;
    begin
        PrintedFromCustomerLedgerEntry := TRUE;
    end;

    procedure SetPrintedFromSalesLine()
    var
        myInt: Integer;
    begin
        PrintedFromSalesLine := TRUE;
    end;

    procedure SetPrintDocumentNo(DocNo: Code[20])
    begin
        PrintDocumentNo := DocNo;
    end;

    procedure SetNoOfCopies(NumberOfCopies: Integer)
    var
        myInt: Integer;
    begin
        NoOfCopies := NumberOfCopies;
    end;

    //AmountInWords[1] + ' ' + AmountInWords[2]
}
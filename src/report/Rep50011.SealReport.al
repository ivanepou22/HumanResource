report 50011 "Seal Report"
{
    RDLCLayout = './SealReport.rdl';
    Caption = 'Seal - Report - Print';
    DefaultLayout = RDLC;
    EnableHyperlinks = true;
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            RequestFilterFields = "Posting Date", "Bill-to Customer No.", "Branch Code", "No.";
            Column(Company_Name; CompanyInfo.Name) { }
            Column(Company_Address; CompanyInfo.Address) { }
            Column(Company_PhoneNo; CompanyInfo."Phone No.") { }
            Column(Company_Picture; CompanyInfo.Picture) { }
            Column(Company_Email; CompanyInfo."E-Mail") { }
            Column(Company_HomePage; CompanyInfo."Home Page") { }
            Column(TruckNo_SalesInvoiceHeader; "Sales Invoice Header"."Truck No.") { }
            Column(SealNo_SalesInvoiceHeader; "Sales Invoice Header"."Seal No") { }
            Column(SelltoCustomerNo_SalesInvoiceHeader; "Sales Invoice Header"."Sell-to Customer No.") { }
            Column(No_SalesInvoiceHeader; "Sales Invoice Header"."No.") { }
            Column(BilltoCustomerNo_SalesInvoiceHeader; "Sales Invoice Header"."Bill-to Customer No.") { }
            Column(BilltoName_SalesInvoiceHeader; "Sales Invoice Header"."Bill-to Name") { }
            Column(PostingDate_SalesInvoiceHeader; "Sales Invoice Header"."Posting Date") { }
            Column(NumberCount; NumberCount) { }

            trigger OnPreDataItem()
            begin
                NumberCount := 0;
            end;

            trigger OnAfterGetRecord()
            begin
                NumberCount += 1;
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
                    // field(Name; SourceExpression)
                    // {
                    //     ApplicationArea = All;

                    // }
                }
            }
        }

    }

    var
        CompanyInfo: Record "Company Information";
        NumberCount: Integer;

    trigger OnPreReport()
    begin
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);
    end;

}
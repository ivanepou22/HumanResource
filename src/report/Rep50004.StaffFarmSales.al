report 50004 "Staff Farm Sales"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'StaffFarmSales.rdl';
    //S_PIN_09246
    dataset
    {
        dataitem("Sales Invoice Line"; "Sales Invoice Line")
        {
            RequestFilterFields = "Sell-to Customer No.", "Posting Date", "Resource No.";
            DataItemTableView = WHERE("Resource No." = FILTER(<> ''));
            Column(CompanyInfoName; CompanyInfo.Name) { }
            Column(CompanyInfoAddress; CompanyInfo.Address) { }
            Column(CompanyInfoAddress2; CompanyInfo."Address 2") { }
            Column(CompanyInfoCity; CompanyInfo.City) { }
            Column(CompanyInfoPhoneNo; CompanyInfo."Phone No.") { }
            Column(CompanyInfoCountryRegionCode; CompanyInfo."Country/Region Code") { }
            Column(CompanyInfoEMail; CompanyInfo."E-Mail") { }
            Column(CompanyInfoHomePage; CompanyInfo."Home Page") { }
            Column(CompanyInfoPicture; CompanyInfo.Picture) { }
            Column(CompanyInfoPostCode; CompanyInfo."Post Code") { }
            Column(SelltoCustomerNo_SalesInvoiceLine; "Sales Invoice Line"."Sell-to Customer No.") { }
            Column(ResourceNo_SalesInvoiceLine; "Sales Invoice Line"."Resource No.") { }
            Column(DocumentNo_SalesInvoiceLine; "Sales Invoice Line"."Document No.") { }
            Column(Description_SalesInvoiceLine; "Sales Invoice Line".Description) { }
            Column(Amount_SalesInvoiceLine; "Sales Invoice Line".Amount) { }
            Column(AmountIncludingVAT_SalesInvoiceLine; "Sales Invoice Line"."Amount Including VAT") { }
            Column(No_SalesInvoiceLine; "Sales Invoice Line"."No.") { }
            Column(UnitPrice_SalesInvoiceLine; "Sales Invoice Line"."Unit Price") { }
            Column(CustomerName; CustomerName) { }
            Column(ResourceName; ResourceName) { }
            Column(ShowDetails; ShowDetails) { }

            dataitem(SalesCrMemoLine; "Sales Cr.Memo Line")
            {
                DataItemLinkReference = "Sales Invoice Line";
                DataItemLink = "Document No." = field("Document No.");

                column(SalesCrMemoLine_No; SalesCrMemoLine."No.")
                {
                }
                column(SalesCrMemoLine_Amount; SalesCrMemoLine.Amount)
                {
                }
                column(SalesCrMemoLine_AmountIncluduingVAT; SalesCrMemoLine."Amount Including VAT")
                {

                }
            }


            //Triggers
            trigger OnAfterGetRecord()
            var
                myInt: Integer;
            begin
                Customer.RESET;
                Customer.SETRANGE(Customer."No.", "Sales Invoice Line"."Sell-to Customer No.");
                IF Customer.FINDFIRST THEN
                    CustomerName := Customer.Name;

                Resource.RESET;
                Resource.SETRANGE(Resource."No.", "Sales Invoice Line"."Resource No.");
                IF Resource.FINDFIRST THEN
                    ResourceName := Resource.Name;
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
                    field(ShowDetails; ShowDetails)
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
        Customer: Record Customer;
        Resource: Record Resource;
        CustomerName: Text[100];
        ResourceName: Text[100];
        ShowDetails: Boolean;

    trigger OnPreReport()
    var
        myInt: Integer;
    begin
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);
    end;
}
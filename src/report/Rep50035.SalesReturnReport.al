report 50035 "Sales Return Report"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'SalesReturn.rdlc';

    dataset
    {
        dataitem(SalesCrMemoLine; "Sales Cr.Memo Line")
        {
            DataItemTableView = where(Type = const(Item), "Return Reason Code" = filter(<> ''));
            RequestFilterFields = "No.", "Return Reason Code", "Posting Date";
            Column(Company_Name; CompanyInfo.Name) { }
            Column(Company_Address; CompanyInfo.Address) { }
            Column(Company_PhoneNo; CompanyInfo."Phone No.") { }
            Column(Company_Picture; CompanyInfo.Picture) { }
            Column(Company_Email; CompanyInfo."E-Mail") { }
            Column(Company_HomePage; CompanyInfo."Home Page") { }
            column(SalesCrMemoLine_DocumentNo; SalesCrMemoLine."Document No.") { }
            column(SalesCrMemoLine_CustNo; SalesCrMemoLine."Sell-to Customer No.") { }
            column(SalesCrMemoLine_ReasonCode; SalesCrMemoLine."Return Reason Code") { }
            column(SalesCrMemoLine_Quantity; SalesCrMemoLine.Quantity) { }
            column(SalesCrMemoLine_No; SalesCrMemoLine."No.") { }
            column(SalesCrMemoLine_PostingDate; SalesCrMemoLine."Posting Date") { }
            column(SalesCrMemoLine_description; SalesCrMemoLine.Description) { }
            column(CustomerName; CustomerName) { }

            trigger OnAfterGetRecord()
            begin
                Customer.Reset();
                Customer.SetRange(Customer."No.", SalesCrMemoLine."Sell-to Customer No.");
                if Customer.FindFirst() then begin
                    CustomerName := Customer.Name;
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
                group(GroupName)
                {
                    // field(Name; SourceExpression)
                    // {
                    //     ApplicationArea = All;

                    // }
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
        Customer: Record Customer;
        CustomerName: Text[150];
        CompanyInfo: Record "Company Information";

    trigger OnPreReport()
    begin
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);
    end;
}
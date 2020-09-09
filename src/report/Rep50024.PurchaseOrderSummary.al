report 50024 "Purchase Order Summary"
{
    Caption = 'Purchase Order Summary';
    UsageCategory = Administration;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'purchaseOrderSummary.rdlc';

    dataset
    {
        dataitem(PurchaseHeader; "Purchase Header")
        {
            RequestFilterFields = "No.", "Buy-from Vendor No.", "Posting Date", "Due Date", "Document Date";
            Column(CompanyInfo_Name; CompanyInfo.Name) { }
            Column(CompanyInfo_Address; CompanyInfo.Address) { }
            Column(CompanyInfo_Address_2; CompanyInfo."Address 2") { }
            Column(CompanyInfo_City; CompanyInfo.City) { }
            Column(CompanyInfo_Phone_No_; CompanyInfo."Phone No.") { }
            Column(CompanyInfo_E_Mail; CompanyInfo."E-Mail") { }
            Column(CompanyInfo_Home_Page; CompanyInfo."Home Page") { }
            Column(CompanyInfo_Picture; CompanyInfo.Picture) { }
            column(No; PurchaseHeader."No.") { }
            column(VendorNo; PurchaseHeader."Buy-from Vendor No.") { }
            column(VendorName; PurchaseHeader."Buy-from Vendor Name") { }

            //Purchase Line
            dataitem(PurchaseLines; "Purchase Line")
            {
                DataItemLinkReference = PurchaseHeader;
                DataItemLink = "Document No." = field("No.");
                column(DocumentType; PurchaseLines."Document Type") { }
                column(DocumentNo; PurchaseLines."Document No.") { }
                column(Type; PurchaseLines.Type) { }
                column(ItemNo; PurchaseLines."No.") { }
                column(ItemDescription; PurchaseLines.Description) { }
                column(LocationCode; PurchaseLines."Location Code") { }
                column(UnitOfMeasureCode; PurchaseLines."Unit of Measure Code") { }
                column(QuantityOrdered; PurchaseLines.Quantity) { }
                column(QuantityReceived; PurchaseLines."Quantity Received") { }
                column(QuantityOutStanding; PurchaseLines.Quantity - PurchaseLines."Quantity Received") { }

                trigger OnPreDataItem()
                begin
                    PurchaseLines.SetRange(PurchaseLines."Document Type", PurchaseLines."Document Type"::Order);
                end;
            }

            //Purchase Header
            trigger OnPreDataItem()
            begin
                PurchaseHeader.SetRange(PurchaseHeader."Document Type", PurchaseHeader."Document Type"::Order);
                PurchaseHeader.SetRange(PurchaseHeader.Status, PurchaseHeader.Status::Released);
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
    //triggers
    trigger OnPreReport()
    begin
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);
    end;
}
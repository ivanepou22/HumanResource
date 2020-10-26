report 50028 "Fuel Issue Form"
{
    Caption = 'Fuel Issue Form';
    DefaultLayout = RDLC;
    RDLCLayout = 'FuelIssueForm.rdlc';

    dataset
    {
        dataitem(ItemJournalLine; "Item Journal Line")
        {
            Column(Company_Name; CompanyInfo.Name) { }
            Column(Company_Address; CompanyInfo.Address) { }
            Column(Company_PhoneNo; CompanyInfo."Phone No.") { }
            Column(Company_Picture; CompanyInfo.Picture) { }
            Column(Company_Email; CompanyInfo."E-Mail") { }
            Column(Company_HomePage; CompanyInfo."Home Page") { }
            column(ItemNo; ItemJournalLine."Item No.") { }
            column(Posting_Date; "Posting Date")
            {
            }
            column(Item_No_; "Item No.")
            {
            }
            column(Amount; Amount)
            {
            }
            column(AmountACY; "Amount (ACY)")
            {
            }
            column(DocumentDate; "Document Date")
            {
            }
            column(DocumentNo; "Document No.")
            {
            }
            column(DocumentType; "Document Type")
            {
            }
            column(Description; Description)
            {
            }
            column(GenBusPostingGroup; "Gen. Bus. Posting Group")
            {
            }
            column(GenProdPostingGroup; "Gen. Prod. Posting Group")
            {
            }
            column(InventoryPostingGroup; "Inventory Posting Group")
            {
            }
            column(InvoiceNo; "Invoice No.")
            {
            }
            column(JournalBatchName; "Journal Batch Name")
            {
            }
            column(JournalTemplateName; "Journal Template Name")
            {
            }
            column(LocationCode; "Location Code")
            {
            }
            column(Quantity; Quantity)
            {
            }
            column(UserID; "User ID")
            {
            }
            column(EquipmentVehicleNo; "Equipment/Vehicle No")
            {
            }
            column(EquipmentVehicleName; "Equipment/Vehicle Name")
            {
            }
            column(QtyRequested; "Qty Requested")
            {
            }
            column(RequestedBy; "Requested By")
            {
            }
            column(IssuedBy; "Issued By")
            {
            }
            column(AuthorizedBy; "Authorized By")
            {
            }

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
        CompanyInfo: Record "Company Information";

    trigger OnPreReport()
    begin
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);
    end;
}
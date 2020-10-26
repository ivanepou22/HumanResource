report 50033 "Production Bom Extraction"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './ProductionBomExtraction.rdlc';

    dataset
    {
        dataitem(ProductionBOMHeader; "Production BOM Header")
        {
            Column(Company_Name; CompanyInfo.Name) { }
            Column(Company_Address; CompanyInfo.Address) { }
            Column(Company_PhoneNo; CompanyInfo."Phone No.") { }
            Column(Company_Picture; CompanyInfo.Picture) { }
            Column(Company_Email; CompanyInfo."E-Mail") { }
            Column(Company_HomePage; CompanyInfo."Home Page") { }
            column(ProductionBOMHeader_No; ProductionBOMHeader."No.") { }
            column(ProductionBOMHeader_Description; ProductionBOMHeader.Description) { }
            column(ProductionBOMHeader_UOM; ProductionBOMHeader."Unit of Measure Code") { }
            column(ProductionBOMHeader_Status; ProductionBOMHeader.Status) { }
            dataitem(ProductionBOMLine; "Production BOM Line")
            {
                DataItemLinkReference = ProductionBOMHeader;
                DataItemLink = "Production BOM No." = field("No.");
                column(ProductionBOMLine_No; ProductionBOMLine."No.") { }
                column(ProductionBOMLine_Description; ProductionBOMLine.Description) { }
                column(ProductionBOMLine_Quantity_Per; ProductionBOMLine."Quantity per") { }
                column(ProductionBOMLine_Quantity; ProductionBOMLine.Quantity) { }
                column(ProductionBOMLine_UOM; ProductionBOMLine."Unit of Measure Code") { }
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
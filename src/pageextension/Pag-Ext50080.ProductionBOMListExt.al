pageextension 50080 "Production BOM List Ext" extends "Production BOM List"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
        addafter("Compare List")
        {
            action("Production BOM Extraction")
            {
                ApplicationArea = Manufacturing;
                Caption = 'Production BOM Extraction';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Production Bom Extraction";
            }
        }
    }

    var
        myInt: Integer;
}
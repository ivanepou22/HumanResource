pageextension 50057 "Purchase Quote Subform Ext" extends "Purchase Quote Subform"
{
    layout
    {
        // Add changes to page layout here
        addafter("Qty. Assigned")
        {
            field("Document No."; "Document No.")
            {
                ApplicationArea = All;
            }

        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}
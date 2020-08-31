pageextension 50043 "Customer Ledger Entries Ext" extends "Customer Ledger Entries"
{
    layout
    {
        // Add changes to page layout here
        addafter(Open)
        {
            field("Branch Code"; "Branch Code")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Return Branch Code"; "Return Branch Code")
            {
                ApplicationArea = All;
                Editable = false;
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
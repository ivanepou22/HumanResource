pageextension 50060 "Apply Bank Acc. Led Ent Ext" extends "Apply Bank Acc. Ledger Entries"
{
    layout
    {
        // Add changes to page layout here
        addafter(Open)
        {
            field("Difference Statement No."; "Difference Statement No.")
            {
                ApplicationArea = All;
            }

            field("Diff Statement Line No."; "Diff Statement Line No.")
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
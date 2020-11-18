tableextension 50062 "Approval Entry Ext" extends "Approval Entry"
{
    fields
    {
        // Add changes to table fields here
        field(50922; "Requisition Type"; Option)
        {
            OptionMembers = " ",Service,Stores,Advance,Contract,Item;
        }
    }

    var
        myInt: Integer;
}
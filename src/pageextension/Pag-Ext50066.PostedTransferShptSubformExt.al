pageextension 50066 "Posted TransferShptSubform Ext" extends "Posted Transfer Shpt. Subform"
{
    layout
    {
        // Add changes to page layout here
        addafter(Quantity)
        {

            field("Transfer Reason"; "Transfer Reason")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {

    }

    var
        myInt: Integer;
}
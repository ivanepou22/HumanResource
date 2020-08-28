tableextension 50028 "ItemLedgerEntryExt" extends "Item Ledger Entry"
{
    fields
    {
        // Add changes to table fields here
        field(50011; "Transfer From"; Code[30]) { }
        field(50012; "Transfer To"; Code[30]) { }
        field(50013; "Transfer Reason"; Option)
        {
            OptionMembers = Normal,Damage;
        }
    }

    var
        myInt: Integer;
}
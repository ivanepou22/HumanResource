tableextension 50021 "Gen. Ledger Setup Ext" extends "General Ledger Setup"
{
    fields
    {
        // Add changes to table fields here
        field(50300; "Receipt Jnl. Batch"; Code[10])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Template Type" = CONST("Cash Receipts"));
        }
        field(50310; "Internal Receipt Jnl. Template"; Code[10])
        {
            TableRelation = "Gen. Journal Template".Name WHERE(Type = CONST(General));
        }
        field(50320; "Internal Receipt Jnl. Batch"; Code[10])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Template Type" = CONST(General));
        }
        field(50330; "Internal Receipt Doc. Nos."; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(50400; "Payment-Invoice App. Mandatory"; Boolean) { }
        field(50405; "Posting Description"; Option)
        {
            OptionMembers = "Document Type and No.","Customer Name","External Document No. and Customer Name","Customer Document Line";
        }
        field(50406; "Allow Direct Invoicing"; Boolean) { }
    }

    var
        myInt: Integer;
}
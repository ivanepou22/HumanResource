tableextension 50053 "VAT Entry Ext" extends "VAT Entry" //254
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Customer Name"; Text[250])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup (Customer.Name where("No." = field("Bill-to/Pay-to No.")));
        }
        field(50010; "Vendor Name"; Text[250])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup (Vendor.Name where("No." = field("Bill-to/Pay-to No.")));
        }
    }

    var
        myInt: Integer;
}
tableextension 50042 "Detailed Cust. Ledg. Entry EXt" extends "Detailed Cust. Ledg. Entry"
{
    fields
    {
        // Add changes to table fields here
        field(50030; "Branch Code"; Code[50])
        {
            FieldClass = FlowField;
            CalcFormula = lookup ("Sales Invoice Header"."Branch Code" where("No." = field("Document No.")));
        }
    }

    var
        myInt: Integer;
}
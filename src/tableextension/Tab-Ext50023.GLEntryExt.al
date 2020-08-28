tableextension 50023 "GLEntryExt" extends "G/L Entry"
{
    fields
    {
        // Add changes to table fields here
        field(50030; "Branch Code"; Code[50])
        {
            FieldClass = FlowField;
            CalcFormula = lookup ("Sales Invoice Header"."Branch Code" where("No." = field("Document No.")));
        }
        field(50500; "Authorised by"; Text[100]) { }
        field(50510; "Paid To/Received From"; Text[50]) { }
        field(50520; "Requested by"; Text[100]) { }
        field(50525; "Reviewed by"; Text[100]) { }
        field(50540; "Approved by"; Code[100]) { }
        field(50541; "GL Name"; Text[100]) { }
        field(50545; "Prepared by"; Code[50]) { }
    }

    var
        myInt: Integer;
}
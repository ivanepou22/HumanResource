tableextension 50047 "Purchase Header Archive Ext" extends "Purchase Header Archive" //5109
{
    fields
    {
        // Add changes to table fields here
        field(50965; "USER ID"; Code[30])
        {
            TableRelation = "User Setup";
            Editable = false;
        }
        field(50966; "User Name"; text[55])
        {
            FieldClass = FlowField;
            CalcFormula = lookup (User."Full Name" where("User Name" = field("USER ID")));
            Editable = false;
        }
        field(50967; "Approver Id"; Code[30])
        {
            Editable = false;
        }
        field(50968; "Approver Name"; Text[100])
        {
            Editable = false;
        }
        field(50969; "Recipient Name"; text[100])
        {
        }
        field(50970; "Transfered To Journals"; Boolean)
        {
            Editable = false;
        }
        field(50971; "Responsible User"; Code[50])
        {
            TableRelation = User."User Name";
            ValidateTableRelation = false;
        }
    }

    var
        myInt: Integer;
}
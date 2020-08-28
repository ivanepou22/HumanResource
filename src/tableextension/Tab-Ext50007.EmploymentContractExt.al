tableextension 50007 "Employment Contract Ext" extends "Employment Contract"
{
    fields
    {
        // Add changes to table fields here
        field(50010; "Annual Leave Days"; Integer) { }
        field(50011; "Sick Days"; Integer) { }
        field(50012; "Study Leave Days"; Integer) { }
        field(50013; "Maternity Leave Days"; Integer) { }
        field(50014; "Paternity Leave Days"; Integer) { }
        field(50015; "Carry Forward Annual Leave"; Option)
        {
            OptionMembers = Never,"1 Year",Always;
        }
        field(50016; "Basic Pay Type"; Option)
        {
            OptionMembers = "Fixed Amount","Units Based";
        }
        field(50017; "Work On Saturday"; Boolean) { }
        field(50018; "Work On Sunday"; Boolean) { }
        field(50019; "Compassionate Leave Days"; Integer) { }
        field(50020; "Leave Without Pay Days"; Integer) { }
        field(50021; "Annual Leave Days C/F"; Integer) { }
        field(50022; "Saturday Halfday"; Boolean) { }
        field(50025; "Position Objective 1"; Text[250]) { }
        field(50030; "Position Objective 2"; Text[250]) { }
        field(50035; "Position Objective 3"; Text[250]) { }
        field(50040; "Position Objective 4"; Text[250]) { }
        field(50045; "Position Objective 5"; Text[250]) { }
        field(50050; "Position Objective 6"; Text[250]) { }
        field(50055; "Position Objective 7"; Text[250]) { }
        field(50060; "Position Objective 8"; Text[250]) { }
        field(50065; "Position Objective 9"; Text[250]) { }
        field(50070; "Position Objective 10"; Text[250]) { }
        field(50075; "Supervisor Code"; Code[30])
        {
            TableRelation = "Employment Contract".Code;
        }
    }

    var
        myInt: Integer;
}
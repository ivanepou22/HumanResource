table 50008 "Human Resource Cues"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {

        }
        field(50034; "Leave From Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(50035; "Leave To Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(50061; "Employees On Leave"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count ("Employee Absence" WHERE("Absence Type" = CONST(Leave), "Leave Status" = FILTER(Approved | Taken), "From Date" = FIELD("Leave From Date Filter")));
        }
        field(50062; "Pending Leave Applications"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count ("Employee Absence" WHERE("Absence Type" = CONST(Leave), "Leave Status" = CONST("Pending Approval")));
        }
        field(50063; "My Approvals"; Integer)
        {
            // FieldClass = FlowField;
            // CalcFormula = Count ("Approval Entry" WHERE("Approver ID"=FILTER(UserId),Status=CONST(Open)));
        }
        field(50064; "Contracts To Expire"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count (Employee WHERE("No. Days Remaining" = FILTER(> 0 & <= 90), "Status 1" = CONST(Active)));
        }
        field(50065; "Employee Loans"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count ("Loan and Advance Header" WHERE("Document Type" = CONST(Loan)));
        }
        field(50066; "Employee Salary Advance"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count ("Loan and Advance Header" WHERE("Document Type" = CONST(Advance)));
        }
        field(50067; "Expired Contracts"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count (Employee WHERE("Employment End Date" = FILTER(<> ''), "No. Days Remaining" = FILTER(<= 0), "Status 1" = CONST(Active)));
        }
        field(50068; "Terminated Employees"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count (Employee WHERE("Status 1" = FILTER(Terminated | Dismissal | Resignation)));
        }
        field(50069; "Inactive Employees"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count (Employee WHERE("Status 1" = CONST(Inactive)));
        }
        field(50070; "Active Employees"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count (Employee WHERE("Status 1" = CONST(Active)));
        }
        field(50071; "Employees On Probation"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count (Employee WHERE("Status 1" = CONST(Probation)));
        }
        field(50072; "Employees Acting Allowance"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count ("Earning And Dedcution" WHERE(Type = CONST(Earning), "Parent Code2" = CONST('ACTING'), "Fixed Amount" = FILTER(<> 0)));
        }
        field(50073; "Employees Without Contracts"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count (Employee WHERE("Employment Date" = FILTER(= ''), "Status 1" = CONST(Active), "Contract Renewal Start Date" = FILTER(= '')));
        }
        field(50074; "Employees With Contracts"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count (Employee WHERE("Employment End Date" = FILTER(<> ''), "Status 1" = CONST(Active)));
        }
        field(50075; "Employees with Open Contracts"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count (Employee WHERE("Status 1" = CONST(Active), "Contract Type" = CONST("Open Contract")));
        }
        field(50076; "Employees with Contract Period"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count (Employee WHERE("Status 1" = CONST(Active), "Contract Type" = CONST("Contract Period")));
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}
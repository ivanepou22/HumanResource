tableextension 50039 "Sales Cue Ext" extends "Sales Cue"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Sales Order - Open"; Integer)
        {

            CalcFormula = Count ("Sales Header" WHERE("Document Type" = FILTER(Order), "USER ID" = field("User ID Filter"),
                                                      Status = FILTER(Open)));
            Caption = 'Open - Sales Orders';
            Editable = false;
            FieldClass = FlowField;
        }

        field(50001; "Sales Order Pending"; Integer)
        {

            CalcFormula = Count ("Sales Header" WHERE("Document Type" = FILTER(Order), "USER ID" = field("User ID Filter"),
                                                      Status = FILTER("Pending Approval")));
            Caption = 'Sales Orders - Pending Approval';
            Editable = false;
            FieldClass = FlowField;
        }

        field(50002; "Sales Order Prepayment"; Integer)
        {

            CalcFormula = Count ("Sales Header" WHERE("Document Type" = FILTER(Order), "USER ID" = field("User ID Filter"),
                                                      Status = FILTER("Pending Prepayment")));
            Caption = 'Sales Orders - Pending Prepayment';
            Editable = false;
            FieldClass = FlowField;
        }

        field(50003; "Released Sales Orders"; Integer)
        {

            CalcFormula = Count ("Sales Header" WHERE("Document Type" = FILTER(Order), "USER ID" = field("User ID Filter"),
                                                      Status = FILTER(Released)));
            Caption = 'Sales Orders - Released';
            Editable = false;
            FieldClass = FlowField;
        }

        //Amounts
        field(50004; OpenSalesAmount; Decimal)
        {

            Caption = 'Open - Sales Orders Amount';
            Editable = false;
        }

        field(50005; "Sales Order PendingA"; Decimal)
        {

            CalcFormula = sum ("Sales Header".Amount WHERE("Document Type" = FILTER(Order), "USER ID" = field("User ID Filter"),
                                                      Status = FILTER("Pending Approval")));
            Caption = 'Sales Orders - Pending Approval Amount';
            Editable = false;
            FieldClass = FlowField;
        }

        field(50006; "Sales Order PrepaymentA"; Decimal)
        {

            CalcFormula = sum ("Sales Header".Amount WHERE("Document Type" = FILTER(Order), "USER ID" = field("User ID Filter"),
                                                      Status = FILTER("Pending Prepayment")));
            Caption = 'Sales Orders - Pending Prepayment Amount';
            Editable = false;
            FieldClass = FlowField;
        }

        field(50007; "Released Sales OrdersA"; Decimal)
        {

            CalcFormula = sum ("Sales Header".Amount WHERE("Document Type" = FILTER(Order), "USER ID" = field("User ID Filter"),
                                                      Status = FILTER(Released)));
            Caption = 'Sales Orders - Released Amount';
            Editable = false;
            FieldClass = FlowField;
        }


        //================Human Resource Cues================================
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


}
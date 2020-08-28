page 50003 "Human Resource Activities"
{
    Caption = 'Human Resource Activities';

    PageType = CardPart;
    RefreshOnActivate = true;
    SourceTable = "Human Resource Cues";
    ShowFilter = true;

    layout
    {
        area(Content)
        {
            cuegroup(Employees)
            {
                ShowCaption = false;
                field("Active Employees"; "Active Employees")
                {
                    Caption = 'Active Employees';
                    ApplicationArea = Basic, Suite;
                    DrillDownPageId = "Employee List";
                    ToolTip = 'Shows the Number of Active Employees';
                }

                field("Inactive Employees"; "Inactive Employees")
                {
                    Caption = 'Inactive Employees';
                    ApplicationArea = Basic, Suite;
                    DrillDownPageId = "Employee List";
                    ToolTip = 'Shows the Number of In Active Employees';
                }

                field("Employees On Probation"; "Employees On Probation")
                {
                    Caption = 'Employees On Probation';
                    ApplicationArea = Basic, Suite;
                    DrillDownPageId = "Employee List";
                    ToolTip = 'Shows the Number of Employees on Probation';
                }

                field("Terminated Employees"; "Terminated Employees")
                {
                    Caption = 'Terminated Employees';
                    ApplicationArea = Basic, Suite;
                    DrillDownPageId = "Employee List";
                    ToolTip = 'Shows the Number of Terminated Employees';
                }

                field("Employees With Acting Allowance"; "Employees Acting Allowance")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageId = "Earnings & Deductions";
                    ToolTip = 'Shows the Number of Employees that have Acting Allowance';
                }

                field("Employee Loans"; "Employee Loans")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Employee Loans';
                    DrillDownPageId = "Employee Loans";
                }
                field("Employee Salary Advance"; "Employee Salary Advance")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Employee Salary Advance';
                    DrillDownPageId = "Employee Advances";
                }
            }

            cuegroup(Contracts)
            {
                field("Contracts To Expire"; "Contracts To Expire")
                {
                    Caption = 'Contracts to Expire In 3 Months';
                    ApplicationArea = Basic, Suite;
                    StyleExpr = CueColor2;
                    DrillDownPageId = "Employee List";
                    ToolTip = 'Show the number of employees whose contracts are expiring within 3 months';
                }

                field("Expired Contracts"; "Expired Contracts")
                {
                    Caption = 'Expired Contracts';
                    StyleExpr = CueColor1;
                    ApplicationArea = Basic, Suite;
                    DrillDownPageId = "Employee List";
                    ToolTip = 'Employees with expired contracts';

                }

                field("Employees Without Contracts"; "Employees Without Contracts")
                {
                    Caption = 'Employees Without Contracts';
                    ApplicationArea = Basic, Suite;
                    DrillDownPageId = "Employee List";
                    ToolTip = 'Employees without Contracts';
                }

                field("Employees With Contracts"; "Employees With Contracts")
                {
                    Caption = 'Employees With Contracts';
                    ApplicationArea = Basic, Suite;
                    DrillDownPageId = "Employee List";
                    ToolTip = 'Employees With Contracts';
                }

                field("Employees with Open Contracts"; "Employees with Open Contracts")
                {
                    Caption = 'Employees With Open Contracts';
                    ApplicationArea = Basic, Suite;
                    DrillDownPageId = "Employee List";
                    ToolTip = 'Employees with open contracts';
                }
                field("Employees with Contract Period"; "Employees with Contract Period")
                {
                    Caption = 'Employees with Contract Period';
                    ApplicationArea = Basic, Suite;
                    DrillDownPageId = "Employee List";
                    ToolTip = 'Employees with Contract Period';
                }
            }

            cuegroup(Leave)
            {
                field("Pending Leave Applications"; "Pending Leave Applications")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Pending Leave Applications';
                }

                field("Employees On Leave"; "Employees On Leave")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Employees on Leave';
                }
            }
        }
    }

    var
        CueColor1: Text[20];
        CueColor2: Text[20];
    //============================
    trigger OnOpenPage()
    var
        Employee: Record Employee;
        CountDays: Integer;
    begin
        Reset();
        If not Get() then begin
            Init();
            Insert();
        end;
        CueColor1 := 'unfavorable';
        CueColor2 := 'Favorable';
        SETFILTER("Leave From Date Filter", STRSUBSTNO('..%1', WORKDATE));

        Employee.RESET;
        Employee.SETRANGE(Status, Employee.Status::Active);
        IF Employee.FINDFIRST THEN
            REPEAT
                IF (Employee."Employment End Date" <> 0D) THEN BEGIN
                    Employee."No. Days Remaining" := (Employee."Employment End Date" - TODAY);
                    Employee.MODIFY;
                END;
            UNTIL Employee.NEXT = 0;
    end;

    //===================================
    trigger OnAfterGetRecord()
    begin
        CalculateCueFieldValues();
    end;

    //========================
    local procedure CalculateCueFieldValues()
    begin
        // if FIELDACTIVE("Normal field") then
        //     "Normal field" := 2 + 1 //add some calculation here for normal fields;
    end;

}
page 50045 "Employee Leaves SelfService"
{
    Caption = 'Employee Leave List';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "Employee Absence";
    Editable = false;
    CardPageId = "Employee Leave Card";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {

                Field("Employee No."; "Employee No.")
                {
                    ApplicationArea = All;
                }
                Field(Description; Description)
                {
                    ApplicationArea = All;
                }
                Field("Leave Type"; "Leave Type")
                {
                    ApplicationArea = All;
                }
                Field("Leave Status"; "Leave Status")
                {
                    ApplicationArea = All;
                }
                Field(Comment; Comment)
                {
                    ApplicationArea = All;
                }

            }
        }
        area(Factboxes)
        {
            part("Leave Information"; "Employee Leave FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "No." = FIELD("Employee No.");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }

    var
        Name: Text[100];
        Employee: Record Employee;
        AbsenceTypeFilter: Text[100];
        LeaveStatusFilter: Text[100];
        LeaveEditable: Boolean;

    //=================================
    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        AbsenceTypeFilter := GETFILTER("Absence Type");
        LeaveStatusFilter := GETFILTER("Leave Status");
        IF (AbsenceTypeFilter = 'Leave') AND ((AbsenceTypeFilter = 'Approved') OR (AbsenceTypeFilter = 'Rejected') OR
           (AbsenceTypeFilter = 'Taken') OR (AbsenceTypeFilter = 'Cancelled') OR (AbsenceTypeFilter = 'History')) THEN
            LeaveEditable := FALSE
        ELSE
            LeaveEditable := TRUE;

        SetFilter("USER ID", '%1', UserId);
    end;

    //===========================
    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin
        IF Employee.GET("Employee No.") THEN
            Name := Employee."First Name" + ' ' + Employee."Middle Name" + ' ' + Employee."Last Name"
        ELSE
            Name := '';
    end;
}
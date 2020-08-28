
page 50004 "Employee Leave FactBox"
{
    PageType = CardPart;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = Employee;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("No."; "No.")
                {
                    ApplicationArea = All;
                }
            }
            group("Annual Leave")
            {
                field("Annual Leave Days B/F"; "Annual Leave Days B/F")
                {
                    ApplicationArea = All;
                }
                field("Annual Leave Days (Current)"; "Annual Leave Days (Current)")
                {
                    ApplicationArea = All;
                }
                field("Annual Leave Days Taken"; "Annual Leave Days Taken")
                {
                    ApplicationArea = All;
                }
                field("Annual Leave Days Available"; "Annual Leave Days B/F" + "Annual Leave Days (Current)" - "Annual Leave Days Taken")
                {
                    ApplicationArea = All;
                }
            }
            group("Maternity Leave")
            {
                field("Maternity Leave Days"; "Maternity Leave Days")
                {
                    ApplicationArea = All;
                }
                field("Maternity Leave Days Taken"; "Maternity Leave Days Taken")
                {
                    ApplicationArea = All;
                }
                field("Maternity Leave Days Available"; "Maternity Leave Days" - "Maternity Leave Days Taken")
                {
                    ApplicationArea = All;
                }
            }
            group("Paternity Leave")
            {
                field("Paternity Leave Days"; "Paternity Leave Days")
                {
                    ApplicationArea = All;
                }
                field("Paternity Leave Days Taken"; "Paternity Leave Days Taken")
                {
                    ApplicationArea = All;
                }
                field("Paternity Leave Days Available"; "Paternity Leave Days" - "Paternity Leave Days Taken")
                {
                    ApplicationArea = All;
                }
            }
            group("Sick Leave")
            {
                field("Sick Leave Days"; "Sick Days")
                {
                    ApplicationArea = All;
                }
                field("Sick Leave Days Taken"; "Sick Days Taken")
                {
                    ApplicationArea = All;
                }
                field("Sick Leave Days Available"; "Sick Days" - "Sick Days Taken")
                {
                    ApplicationArea = All;
                }
            }
            group("Study Leave")
            {
                field("Study Leave Days"; "Study Leave Days")
                {
                    ApplicationArea = All;
                }
                field("Study Leave Days Taken"; "Study Leave Days Taken")
                {
                    ApplicationArea = All;
                }
                field("Study Leave Days Available"; "Study Leave Days" - "Study Leave Days Taken")
                {
                    ApplicationArea = All;
                }
            }
            group("Compassionate Leave")
            {
                field("Compassionate Leave Days"; "Compassionate Leave Days")
                {
                    ApplicationArea = All;
                }
                field("Compassionate Leave Days Taken"; "Compassionate Leave Days Taken")
                {
                    ApplicationArea = All;
                }
                field("Compassionate Leave Available"; "Compassionate Leave Days" - "Compassionate Leave Days Taken")
                {
                    ApplicationArea = All;
                }
            }
            group("Leave Without Pay")
            {
                field("Leave Without Pay Days"; "Leave Without Pay Days")
                {
                    ApplicationArea = All;
                }
                field("Leave Without Pay Days Taken"; "Leave Without Pay Days Taken")
                {
                    ApplicationArea = All;
                }
                field("Leave Without Pay Available"; "Leave Without Pay Days" - "Leave Without Pay Days Taken")
                {
                    ApplicationArea = All;
                }
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

                trigger OnAction()
                begin

                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        SETRANGE("Leave From Date Filter", DMY2DATE(1, 1, DATE2DMY(WORKDATE, 3)), WORKDATE);
        SETRANGE("Leave To Date Filter", DMY2DATE(1, 1, DATE2DMY(WORKDATE, 3)), WORKDATE);
    end;
}
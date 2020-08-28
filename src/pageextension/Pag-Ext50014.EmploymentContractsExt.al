pageextension 50014 "Employment Contracts Ext" extends "Employment Contracts"
{
    layout
    {
        // Add changes to page layout here
        addafter("No. of Contracts")
        {
            Field("Supervisor Code"; "Supervisor Code")
            {
                ApplicationArea = All;
            }
            Field("Annual Leave Days"; "Annual Leave Days")
            {
                ApplicationArea = All;
            }
            Field("Sick Days"; "Sick Days")
            {
                ApplicationArea = All;
            }
            Field("Study Leave Days"; "Study Leave Days")
            {
                ApplicationArea = All;
            }
            Field("Maternity Leave Days"; "Maternity Leave Days")
            {
                ApplicationArea = All;
            }
            Field("Paternity Leave Days"; "Paternity Leave Days")
            {
                ApplicationArea = All;
            }
            Field("Compassionate Leave Days"; "Compassionate Leave Days")
            {
                ApplicationArea = All;
            }
            Field("Leave Without Pay Days"; "Leave Without Pay Days")
            {
                ApplicationArea = All;
            }
            Field("Carry Forward Annual Leave"; "Carry Forward Annual Leave")
            {
                ApplicationArea = All;
            }
            Field("Annual Leave Days C/F"; "Annual Leave Days C/F")
            {
                ApplicationArea = All;
            }
            Field("Saturday Halfday"; "Saturday Halfday")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}
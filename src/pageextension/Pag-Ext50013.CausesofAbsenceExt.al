pageextension 50013 "Causes of Absence Ext" extends "Causes of Absence"
{
    layout
    {
        // Add changes to page layout here
        addafter("Unit of Measure Code")
        {
            field("Deduct from Pay"; "Deduct from Pay")
            {
                ApplicationArea = All;
            }
            field("Deduction Unit Amount"; "Deduction Unit Amount")
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
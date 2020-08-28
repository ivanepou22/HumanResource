pageextension 50061 "Sales Analysis Report Ext" extends "Sales Analysis Report"
{
    layout
    {
        // Add changes to page layout here
        addlast(Filters)
        {
            field("Date Filter"; "Date Filter")
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
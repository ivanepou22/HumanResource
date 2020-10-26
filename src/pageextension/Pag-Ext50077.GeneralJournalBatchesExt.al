pageextension 50077 "General Journal Batches Ext" extends "General Journal Batches"
{
    layout
    {
        // Add changes to page layout here
        addafter("Suggest Balancing Amount")
        {
            field("Batch User"; "Batch User")
            {
                ApplicationArea = All;
            }

        }
    }

    actions
    {
        // Add changes to page actions here
    }

}
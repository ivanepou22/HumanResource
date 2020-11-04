pageextension 50023 "Customer Card Ext" extends "Customer Card"
{
    layout
    {
        // Add changes to page layout here
        addafter(Name)
        {
            field("Territory Code"; "Territory Code")
            {
                ApplicationArea = All;
            }
        }
        addafter("Territory Code")
        {
            field("Allow Sale Beyond Credit limit"; "Allow Sale Beyond Credit limit")
            {
                ApplicationArea = All;
            }
            field("TIN Mandatory"; "TIN Mandatory")
            {
                ApplicationArea = All;
            }

            field("Global Dimension 1 Code"; "Global Dimension 1 Code")
            {
                ApplicationArea = All;
            }
            field("Global Dimension 2 Code"; "Global Dimension 2 Code")
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
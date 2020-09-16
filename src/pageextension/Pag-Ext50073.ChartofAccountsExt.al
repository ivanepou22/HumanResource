pageextension 50073 "Chart of Accounts Ext" extends "Chart of Accounts"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
        addafter("Trial Balance")
        {
            action("Standard Trial Balance")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Standard Trial Balance';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedOnly = true;
                RunObject = Report "Standard Trial Balance";
                ToolTip = 'View the chart of accounts that have balances and net changes.';
            }

            action("Trial Balance Columns")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Trial Balance Finance';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedOnly = true;
                RunObject = Report "Trial Balance Finance";
                ToolTip = 'View the chart of accounts that have balances and net changes.';
            }

        }


    }

    var
        myInt: Integer;
}
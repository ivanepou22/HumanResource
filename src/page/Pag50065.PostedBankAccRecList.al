page 50065 "Posted Bank Acc. Rec. List"
{
    Caption = 'Posted Bank Account Reconciliation List';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "Bank Acc. Reconciliation";
    DeleteAllowed = false;
    Editable = false;
    CardPageId = "Posted Bank Acc Rec. Header";
    SourceTableView = WHERE("Statement Type" = CONST("Payment Application"));

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                Field("Bank Account No."; "Bank Account No.")
                {
                    ApplicationArea = All;
                }
                Field("Statement No."; "Statement No.")
                {
                    ApplicationArea = All;
                }
                Field("Statement Date"; "Statement Date")
                {
                    ApplicationArea = All;
                }
                Field("Balance Last Statement"; "Balance Last Statement")
                {
                    ApplicationArea = All;
                }
                Field("Statement Ending Balance"; "Statement Ending Balance")
                {
                    ApplicationArea = All;
                }

            }
        }
        area(Factboxes)
        {
            systempart(Control1900383207; Links)
            {
                ApplicationArea = RecordLinks;
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
            }
        }
    }
}
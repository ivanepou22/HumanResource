page 50054 "Drawers"
{
    Caption = 'Drawers';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    DelayedInsert = true;
    MultipleNewLines = true;
    AutoSplitKey = true;
    LinksAllowed = false;
    SourceTable = "Voucher And Receipt";
    SourceTableView = WHERE("Document Type" = CONST(Drawer));

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Comment)
                {
                    ApplicationArea = All;
                }
                field(User; User)
                {
                    ApplicationArea = All;
                }


            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {

        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        SetUpNewLine;
        "Document Type" := "Document Type"::Drawer;
    end;
}
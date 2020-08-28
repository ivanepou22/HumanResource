page 50010 "Vacancy List"
{
    Caption = 'Vacancy List';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "Vacancy Request";
    CardPageId = "Vacancy Card";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                Field("Req No."; "Req No.")
                {
                    ApplicationArea = All;
                }
                Field("Job No."; "Job No.")
                {
                    ApplicationArea = All;
                }
                Field("Job Name"; "Job Name")
                {
                    ApplicationArea = All;
                }
                Field("Vacancy Status"; "Vacancy Status")
                {
                    ApplicationArea = All;
                }
                Field("Request Date"; "Request Date")
                {
                    ApplicationArea = All;
                }
                Field("Last Date Modified"; "Last Date Modified")
                {
                    ApplicationArea = All;
                }
                Field("Expected Start Date"; "Expected Start Date")
                {
                    ApplicationArea = All;
                }
                Field("Vadlid From Date"; "Vadlid From Date")
                {
                    ApplicationArea = All;
                }
                Field("Valid To Date"; "Valid To Date")
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
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }
}
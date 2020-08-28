page 50013 "Set Interviews"
{
    Caption = 'Set Interviews';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "Employee Comment Line";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                Field(Date; Date)
                {
                    ApplicationArea = All;
                }
                Field("No."; "No.")
                {
                    ApplicationArea = All;
                }
                Field("Applicant Name"; "Applicant Name")
                {
                    ApplicationArea = All;
                }
                Field("Interview Date"; "Interview Date")
                {
                    ApplicationArea = All;
                }
                Field("Interview From Time"; "Interview From Time")
                {
                    ApplicationArea = All;
                }
                Field("Interview To Time"; "Interview To Time")
                {
                    ApplicationArea = All;
                }
                Field("Interview Status"; "Interview Status")
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

                trigger OnAction();
                begin

                end;
            }
        }
    }

    var
        HumanResourceCommentLine: Record "Employee Comment Line";
        "TableLineNo.": Integer;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        myInt: Integer;
    begin
        "User ID" := USERID;
        "Last Date Modified" := TODAY;
        Date := TODAY;
        "Line No." := 112000;

        HumanResourceCommentLine.RESET;
        HumanResourceCommentLine.SETRANGE("Table Name", HumanResourceCommentLine."Table Name"::Applicant);
        IF HumanResourceCommentLine.FINDLAST THEN
            "TableLineNo." := HumanResourceCommentLine."Table Line No.";

        "Table Line No." := "TableLineNo." + 12000;
    end;

    trigger OnModifyRecord(): Boolean
    var
        myInt: Integer;
    begin
        "User ID" := USERID;
        "Last Date Modified" := TODAY;
    end;
}
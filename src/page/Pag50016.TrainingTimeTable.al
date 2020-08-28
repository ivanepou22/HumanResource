page 50016 "Training TimeTable"
{
    Caption = 'Training TimeTable';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    DelayedInsert = true;
    MultipleNewLines = true;
    AutoSplitKey = true;
    LinksAllowed = false;
    SourceTable = "Employee Comment Line";
    SourceTableView = WHERE(Type = CONST(Training), "Training Status" = CONST(Planned));

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                Field("No."; "No2.")
                {
                    ApplicationArea = All;
                    Caption = 'No.';
                }
                Field("Employee Name"; "Employee Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                Field(Type; Type)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                Field("Training Code"; "Training Code")
                {
                    ApplicationArea = All;
                }
                Field(Date; Date)
                {
                    ApplicationArea = All;
                }
                Field(Code; Code)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                Field("Training Type"; "Training Type")
                {
                    ApplicationArea = All;
                }
                Field("Training Start Date"; "Training Start Date")
                {
                    ApplicationArea = All;
                }
                Field("Training End Date"; "Training End Date")
                {
                    ApplicationArea = All;
                }
                Field(Institution; Institution)
                {
                    ApplicationArea = All;
                }
                Field(Fee; Fee)
                {
                    ApplicationArea = All;
                }
                Field("Training Status"; "Training Status")
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

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        myInt: Integer;
    begin
        SetUpNewLine;

        Type := Type::Training;
        "Training Status" := "Training Status"::Planned;
    end;

    var
        Employee: Record Employee;
        EmployeeAbsence: Record "Employee Absence";
        EmployeeQualification: Record "Employee Qualification";
        EmployeeRelative: Record "Employee Relative";
        MiscArticleInfo: Record "File Upload";
        ConfidentialInfo: Record "Earning And Dedcution";
        ShowingAttachments: Boolean;
        Text000: Label 'untitled';

    local procedure Caption(HRCommentLine: Record "Employee Comment Line"): Text[110]
    var
        myInt: Integer;
    begin
        CASE HRCommentLine."Table Name" OF
            HRCommentLine."Table Name"::"Employee Absence":
                IF EmployeeAbsence.GET(HRCommentLine."Table Line No.") THEN BEGIN
                    Employee.GET(EmployeeAbsence."Employee No.");
                    EXIT(
                      Employee."No." + ' ' + Employee.FullName + ' ' +
                      EmployeeAbsence."Cause of Absence Code" + ' ' +
                      FORMAT(EmployeeAbsence."From Date"));
                END;
            HRCommentLine."Table Name"::Employee:
                IF Employee.GET(HRCommentLine."No.") THEN
                    EXIT(HRCommentLine."No." + ' ' + Employee.FullName);
            HRCommentLine."Table Name"::"Alternative Address":
                IF Employee.GET(HRCommentLine."No.") THEN
                    EXIT(
                      HRCommentLine."No." + ' ' + Employee.FullName + ' ' +
                      HRCommentLine."Alternative Address Code");
            HRCommentLine."Table Name"::"Employee Qualification":
                IF EmployeeQualification.GET(HRCommentLine."No.", HRCommentLine."Table Line No.") AND
                   Employee.GET(HRCommentLine."No.")
                THEN
                    EXIT(
                      HRCommentLine."No." + ' ' + Employee.FullName + ' ' +
                      EmployeeQualification."Qualification Code");
            HRCommentLine."Table Name"::"Employee Relative":
                IF EmployeeRelative.GET(HRCommentLine."No.", HRCommentLine."Table Line No.") AND
                   Employee.GET(HRCommentLine."No.")
                THEN
                    EXIT(
                      HRCommentLine."No." + ' ' + Employee.FullName + ' ' +
                      EmployeeRelative."Relative Code");
            HRCommentLine."Table Name"::"Misc. Article Information":
                IF MiscArticleInfo.GET(
                     HRCommentLine."No.", HRCommentLine."Alternative Address Code", HRCommentLine."Table Line No.") AND
                   Employee.GET(HRCommentLine."No.")
                THEN
                    EXIT(
                      HRCommentLine."No." + ' ' + Employee.FullName + ' ' +
                      MiscArticleInfo."Misc. Article Code");
            HRCommentLine."Table Name"::"Confidential Information":
                IF ConfidentialInfo.GET(HRCommentLine."No.", HRCommentLine."Table Line No.") AND
                   Employee.GET(HRCommentLine."No.")
                THEN
                    EXIT(
                      HRCommentLine."No." + ' ' + Employee.FullName + ' ' +
                      ConfidentialInfo."Confidential Code");
        END;
        EXIT(Text000);
    end;

    local procedure SetShowingAttachments()
    var
        myInt: Integer;
    begin
        ShowingAttachments := TRUE;
    end;
}
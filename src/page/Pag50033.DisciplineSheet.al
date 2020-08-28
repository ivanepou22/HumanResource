page 50033 "Discipline Sheet"
{
    Caption = 'Discipline Sheet';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "Employee Comment Line";
    DelayedInsert = true;
    MultipleNewLines = true;
    AutoSplitKey = true;
    LinksAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {

                Field(Type; Type)
                {
                    ApplicationArea = All;
                    Visible = false;
                    Editable = false;
                }
                Field(Date; Date)
                {
                    ApplicationArea = All;
                }
                Field("Disciplinary Reason"; "Disciplinary Reason")
                {
                    ApplicationArea = All;
                }
                Field("Disciplinary Description"; "Disciplinary Description")
                {
                    ApplicationArea = All;
                }
                Field("Action No."; "Action No.")
                {
                    ApplicationArea = All;
                }

                Field("Action 2"; "Action 2")
                {
                    ApplicationArea = All;
                    Caption = 'Action';
                }
                Field(Reason; Reason)
                {
                    ApplicationArea = All;
                }
                Field("Action Status"; "Action Status")
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

        Employee: Record Employee;
        EmployeeAbsence: Record "Employee Absence";
        EmployeeQualification: Record "Employee Qualification";
        EmployeeRelative: Record "Employee Relative";
        MiscArticleInfo: Record "Misc. Article Information";
        ConfidentialInfo: Record "Confidential Information";
        ShowingAttachments: Boolean;
        Text000: Label 'untitled';

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        myInt: Integer;
    begin
        SetUpNewLine;
        Type := Type::Discipline;
    end;

    local procedure SetShowingAttachments()
    begin
        ShowingAttachments := TRUE;
    end;

    local procedure Caption(HRCommentLine: Record "Employee Comment Line"): Text[110]
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
}
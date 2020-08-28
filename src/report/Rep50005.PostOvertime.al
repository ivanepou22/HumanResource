report 50005 "Post Overtime"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    ProcessingOnly = true;

    dataset
    {
        dataitem("Human Resource Comment Line"; "Employee Comment Line")
        {
            DataItemTableView = WHERE("Table Name" = CONST(Employee), Type = CONST(Overtime), "ED Type" = CONST(Overtime), "Transfered To Payroll" = CONST(false));
            RequestFilterFields = "No.";
            //==============
            trigger OnPreDataItem()
            var
                myInt: Integer;
            begin
                IF (FORMAT(PayrollDate) <> '0D') THEN
                    "Human Resource Comment Line".SETFILTER("Human Resource Comment Line".Date, '%1', PayrollDate);
            end;


            //==============OnAfterGetRecord()================
            trigger OnAfterGetRecord()
            var
                ConfidentialInformation: Record "Earning And Dedcution";
                Confidential: Record Confidential;
            begin
                ConfidentialInformation.RESET;
                ConfidentialInformation.SETRANGE(ConfidentialInformation."Confidential Code", "Human Resource Comment Line"."Earning Code");
                ConfidentialInformation.SETRANGE(ConfidentialInformation."Employee No.", "Human Resource Comment Line"."No.");
                ConfidentialInformation.SETRANGE(ConfidentialInformation.Type, ConfidentialInformation.Type::Earning);
                ConfidentialInformation.SETRANGE(ConfidentialInformation."ED Type", "Human Resource Comment Line"."ED Type");
                IF ConfidentialInformation.FINDFIRST THEN BEGIN
                    REPEAT
                        ConfidentialInformation."Fixed Amount" := "Human Resource Comment Line"."Overtime Amounts";
                        "Human Resource Comment Line"."Transfered To Payroll" := TRUE;
                        "Human Resource Comment Line".MODIFY;
                        ConfidentialInformation.MODIFY;
                    UNTIL ConfidentialInformation.NEXT = 0;
                END ELSE BEGIN
                    ConfidentialInformation."Employee No." := "Human Resource Comment Line"."No.";
                    ConfidentialInformation."Confidential Code" := "Human Resource Comment Line"."Earning Code";
                    ConfidentialInformation."Line No." := 53000;
                    ConfidentialInformation."Fixed Amount" := "Human Resource Comment Line"."Overtime Amounts";
                    ConfidentialInformation."Created By" := USERID;
                    ConfidentialInformation."Last Modified By" := USERID;
                    ConfidentialInformation."Date Created" := TODAY;
                    ConfidentialInformation."ED Type" := "Human Resource Comment Line"."ED Type";
                    Confidential.RESET;
                    Confidential.SETRANGE(Code, "Human Resource Comment Line"."Earning Code");
                    Confidential.SETRANGE(Type, Confidential.Type::Earning);
                    IF Confidential.FINDFIRST THEN begin
                        ConfidentialInformation.Description := Confidential.Description;
                        ConfidentialInformation."Parent Code2" := Confidential."Parent Code2";
                        ConfidentialInformation."Payroll Code" := Confidential."Payroll Group";
                        ConfidentialInformation.Recurrence := Confidential.Recurrence;
                        ConfidentialInformation."Payroll Code" := Confidential."Payroll Group";
                    end;
                    "Human Resource Comment Line"."Transfered To Payroll" := TRUE;
                    "Human Resource Comment Line".MODIFY;
                    ConfidentialInformation.INSERT;
                END;

            end;


        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    field("Payroll Date"; PayrollDate)
                    {
                        ApplicationArea = All;

                    }
                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    var
        PayrollDate: Date;
}
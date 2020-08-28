page 50015 "Employee Overtime"
{
    Caption = 'Employee Overtime';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "Employee Comment Line";
    SourceTableView = where(Type = const(Overtime));
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
                Field(Date; Date)
                {
                    ApplicationArea = All;
                }
                Field("No."; "No.")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    var
                        employee: Record Employee;
                    begin
                        employee.RESET;
                        employee.SETRANGE(employee."No.", "No.");
                        IF employee.FINDFIRST THEN BEGIN
                            "Basic Salary Amount" := employee."Basic Salary";
                            "Employee Name" := employee."Full Name";
                            "Employee Job title" := employee."Job Title";
                            Validate("Payroll Group", employee."Statistics Group Code");
                        END;
                    end;
                }
                Field("Employee Name"; "Employee Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Payroll Group"; "Payroll Group")
                {
                    ApplicationArea = All;
                    Visible = false;
                }

                Field(Type; Type)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                Field("Table Name"; "Table Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                Field("Basic Salary Amount"; "Basic Salary Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                Field("Earning Code"; "Earning Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                Field("ED Type"; "ED Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                Field("Holiday No. of Hours"; "Holiday No. of days")
                {
                    ApplicationArea = All;
                    Caption = 'Holiday Hours';
                }
                Field("Holiday Amount"; "Holiday Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                Field("Nonholiday No. of days"; "Nonholiday No. of days")
                {
                    ApplicationArea = All;
                    Caption = 'Normal day Hours';
                }
                Field("Normal Day Amount"; "NonHoliday Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                Field("Overtime Amounts"; "Overtime Amounts")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                Field("Transfered To Payroll"; "Transfered To Payroll")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Description; Description)
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
            action("Post Overtime")
            {
                ApplicationArea = All;
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = report "Post Overtime";
                trigger OnAction();
                begin

                end;
            }
        }
    }


    var
        Editpage: Boolean;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        Confidential: Record Confidential;
    begin
        SetUpNewLine;

        Type := Type::Overtime;
        "Table Name" := "Table Name"::Employee;
        "ED Type" := "ED Type"::Overtime;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        myInt: Integer;
    begin
        if (Date = 0D) then
            Error('Date Cannot be Empty');
        if "No." = '' then
            Error('No. Cannot be  empty');
    end;

    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        if "Transfered To Payroll" = true then
            Editpage := false
        else
            Editpage := true;
    end;


}
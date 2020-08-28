pageextension 50020 "Employee Statistics Groups Ext" extends "Employee Statistics Groups"
{
    layout
    {
        // Add changes to page layout here
        addafter(Description)
        {

            Field("Employee Nos."; "Employee Nos.")
            {
                ApplicationArea = All;
            }
            Field("Base Unit of Measure"; "Base Unit of Measure")
            {
                ApplicationArea = All;
            }
            Field("Last Payroll Processing Date"; "Last Payroll Processing Date")
            {
                ApplicationArea = All;
            }
            Field("Next Payroll Processing Date"; "Next Payroll Processing Date")
            {
                ApplicationArea = All;
            }
            Field("Payroll Processing Frequency"; "Payroll Processing Frequency")
            {
                ApplicationArea = All;
            }
            Field("Current Payroll Period Status"; "Current Payroll Period Status")
            {
                ApplicationArea = All;
            }
            Field("Basic Pay Type"; "Basic Pay Type")
            {
                ApplicationArea = All;
            }
            Field("Payroll Journal Template Name"; "Payroll Journal Template Name")
            {
                ApplicationArea = All;
            }
            Field("Payroll Journal Batch Name"; "Payroll Journal Batch Name")
            {
                ApplicationArea = All;
            }
            Field("Basic Salary Expence Acc. No."; "Basic Salary Expence Acc. No.")
            {
                ApplicationArea = All;
            }
            Field("Payments Journal Template Name"; "Payments Journal Template Name")
            {
                ApplicationArea = All;
            }
            Field("Payments Journal Batch Name"; "Payments Journal Batch Name")
            {
                ApplicationArea = All;
            }
            Field("Salaries Payable Acc. Type"; "Salaries Payable Acc. Type")
            {
                ApplicationArea = All;
            }
            Field("Salaries Payable Acc. No."; "Salaries Payable Acc. No.")
            {
                ApplicationArea = All;
            }
            Field("Basic Pay Expense Posting Type"; "Basic Pay Expense Posting Type")
            {
                ApplicationArea = All;
            }
            Field("Tax Payable Posting Type"; "Tax Payable Posting Type")
            {
                ApplicationArea = All;
            }
            Field("Net Pay Payable Posting Type"; "Net Pay Payable Posting Type")
            {
                ApplicationArea = All;
            }
            Field("Advance Salary Deduction Code"; "Advance Salary Deduction Code")
            {
                ApplicationArea = All;
            }
            Field("Advance Salary G/L Account"; "Advance Salary G/L Account")
            {
                ApplicationArea = All;
            }
            Field("Loan Deduction Code"; "Loan Deduction Code")
            {
                ApplicationArea = All;
            }
            Field("Loan G/L Account"; "Loan G/L Account")
            {
                ApplicationArea = All;
            }
            Field("Interest Deduction Code"; "Interest Deduction Code")
            {
                ApplicationArea = All;
            }
            Field("Loan Interest Income A/C"; "Loan Interest Income A/C")
            {
                ApplicationArea = All;
            }
            Field("Special Deduction Code"; "Special Deduction Code")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
        addlast(Navigation)
        {
            action("Process Payroll")
            {
                ApplicationArea = All;
                Caption = 'Process Payroll';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Process;
                trigger OnAction()
                var
                    PayrollGroups: Record "Employee Statistics Group";
                    ProcessPayroll: Report "Process Payroll";
                begin
                    ResetPayroll();
                    PreparePayroll();
                    PayrollGroups.RESET;
                    PayrollGroups.SETRANGE(PayrollGroups.Code, Code);
                    ProcessPayroll.SETTABLEVIEW(PayrollGroups);
                    ProcessPayroll.RUNMODAL;
                end;
            }

            action("Payroll Report")
            {
                ApplicationArea = All;
                Caption = 'Payroll Report';
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                Image = Process;
                trigger OnAction()
                var
                    PayrollGroups: Record "Employee Statistics Group";
                    PayrollReport: Report "Payroll Report";
                begin
                    ResetPayroll();
                    PreparePayroll();
                    PayrollGroups.RESET;
                    PayrollGroups.SETRANGE(PayrollGroups.Code, Code);
                    PayrollReport.SETTABLEVIEW(PayrollGroups);
                    PayrollReport.RUNMODAL;
                end;
            }

            action("Post Extra Items to Payroll")
            {
                ApplicationArea = All;
                Caption = 'Post Extra Items to Payroll';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = PostedPayment;
                trigger OnAction()
                var
                    Employees: Record Employee;
                begin
                    Employees.RESET;
                    Employees.SETRANGE(Employees."Statistics Group Code", Code);
                end;
            }

            action("Extra Payroll Items")
            {
                ApplicationArea = All;
                Caption = 'Payroll Items';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = ItemLines;
                trigger OnAction()
                var
                    Employees: Record Employee;

                begin
                    Employees.RESET;
                    Employees.SETRANGE(Employees."Statistics Group Code", Code);
                end;
            }

            action("Page Resource Prices")
            {
                ApplicationArea = All;
                Caption = 'Resource Prices';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = ResourcePrice;
                trigger OnAction()
                begin

                end;
            }

            action("Import Earnings")
            {
                ApplicationArea = All;
                Caption = 'Import Earnings';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = ImportExcel;
                RunObject = xmlport "Import Earnings";
                trigger OnAction()
                begin

                end;
            }
            action("Import Deductions")
            {
                ApplicationArea = All;
                Caption = 'Import Deductions';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = ImportExport;
                RunObject = xmlport "Import Deductions";
                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}
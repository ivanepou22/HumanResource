pageextension 50016 "Human Resources Setup Ext" extends "Human Resources Setup"
{
    layout
    {
        // Add changes to page layout here
        addafter("Base Unit of Measure")
        {
            Field("Retirement Threshold(Years)"; "Retirement Threshold(Years)")
            {
                ApplicationArea = All;
            }
            Field("Full Time Employees Stats. Grp"; "Full Time Employees Stats. Grp")
            {
                ApplicationArea = All;
            }
            Field("Show Only F.Time on Emp. List"; "Show Only F.Time on Emp. List")
            {
                ApplicationArea = All;
                Visible = false;
            }
            Field("Contract Employees Stats. Grp"; "Contract Employees Stats. Grp")
            {
                ApplicationArea = All;
            }
            Field("Applicant Nos."; "Applicant Nos.")
            {
                ApplicationArea = All;
            }
            Field("Vacancy Nos."; "Vacancy Nos.")
            {
                ApplicationArea = All;
            }
        }

        addafter(Numbering)
        {
            group(Leave)
            {
                Field("HR Calendar"; "HR Calendar")
                {
                    ApplicationArea = All;
                }
                Field("Count NW Days In Leave Period"; "Count NW Days In Leave Period")
                {
                    ApplicationArea = All;
                }
                Field("Annual Leave Absence Code"; "Annual Leave Absence Code")
                {
                    ApplicationArea = All;
                }
                Field("Maternity Leave Absence Code"; "Maternity Leave Absence Code")
                {
                    ApplicationArea = All;
                }
                Field("Paternity Leave Absence Code"; "Paternity Leave Absence Code")
                {
                    ApplicationArea = All;
                }
                Field("Study Leave Absence Code"; "Study Leave Absence Code")
                {
                    ApplicationArea = All;
                }
                Field("Sick Leave Absence Code"; "Sick Leave Absence Code")
                {
                    ApplicationArea = All;
                }
                Field("Compassionate Leave Abs. Code"; "Compassionate Leave Abs. Code")
                {
                    ApplicationArea = All;
                }
                Field("Leave Without Pay Code"; "Leave Without Pay Code")
                {
                    ApplicationArea = All;
                }
                Field("Test Leave Appln. before"; "Test Leave Appln. before")
                {
                    ApplicationArea = All;
                }
                Field("Leave Appln. before Formula"; "Leave Appln. before Formula")
                {
                    ApplicationArea = All;
                }
                Field("Max No. of People On Leave"; "Max No. of People On Leave")
                {
                    ApplicationArea = All;
                }
            }
        }
        addafter(Leave)
        {
            group(Payroll)
            {
                Field("Integrate with Financials"; "Integrate with Financials")
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
                Field("Income Tax Payable Acc. Type"; "Income Tax Payable Acc. Type")
                {
                    ApplicationArea = All;
                }
                Field("Income Tax Payable Acc. No."; "Income Tax Payable Acc. No.")
                {
                    ApplicationArea = All;
                }
                Field("Income Tax Range Table Code"; "Income Tax Range Table Code")
                {
                    ApplicationArea = All;
                }
                Field("Local Tax Payable Acc. Type"; "Local Tax Payable Acc. Type")
                {
                    ApplicationArea = All;
                }
                Field("Local Tax Payable Acc. No."; "Local Tax Payable Acc. No.")
                {
                    ApplicationArea = All;
                }
                Field("Local Tax Range Table Code"; "Local Tax Range Table Code")
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
                Field("Basic Salary Expense Acc. No."; "Basic Salary Expense Acc. No.")
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
                Field("Salaries Payable Account Type"; "Salaries Payable Account Type")
                {
                    ApplicationArea = All;
                }
                Field("Salaries Payable Account No."; "Salaries Payable Account No.")
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
                Field("Loan Nos."; "Loan Nos.")
                {
                    ApplicationArea = All;
                }
                Field("Advance Nos."; "Advance Nos.")
                {
                    ApplicationArea = All;
                }
                Field("Loan Interest Doc. Nos."; "Loan Interest Doc. Nos.")
                {
                    ApplicationArea = All;
                }
                Field("Holiday Rate"; "Holiday Rate")
                {
                    ApplicationArea = All;
                }
                Field("NonHoliday Rate"; "NonHoliday Rate")
                {
                    ApplicationArea = All;
                }
            }
        }


    }

    actions
    {
        // Add changes to page actions here
    }

    var
        CurrUserIsLeaveAdmin: Boolean;
        UserSetup: Record "User Setup";
}
page 50037 "Employee Loans"
{
    Caption = 'Employee Loans';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = Basic, Suite, Assembly;
    SourceTable = "Loan and Advance Header";
    SourceTableView = WHERE("Document Type" = CONST(Loan));
    CardPageId = "Employee Loan";
    Editable = false;
    PromotedActionCategories = 'New,Process';
    RefreshOnActivate = true;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {

                Field("No."; "No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                Field("Employee No."; "Employee No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                Field("Employee Name"; "Employee Name")
                {
                    ApplicationArea = Basic, Suite;
                }
                Field("Interest Rate"; "Interest Rate")
                {
                    ApplicationArea = Basic, Suite;
                }
                Field(Currency; Currency)
                {
                    ApplicationArea = Basic, Suite;
                }
                Field(Principal; Principal)
                {
                    ApplicationArea = Basic, Suite;
                }
                Field("Principal (LCY)"; "Principal (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                }
                Field("Creation Date"; "Creation Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                Field("Start Period Date"; "Start Period Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                Field("Start Period"; "Start Period")
                {
                    ApplicationArea = Basic, Suite;
                }
                Field(Installments; Installments)
                {
                    ApplicationArea = Basic, Suite;
                }
                Field("Installment Amount"; "Installment Amount")
                {
                    ApplicationArea = Basic, Suite;
                }
                Field("Installment Amount (LCY)"; "Installment Amount (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                }
                Field("Issuing Bank Account"; "Issuing Bank Account")
                {
                    ApplicationArea = Basic, Suite;
                }
                Field("Paid To Employee"; "Paid To Employee")
                {
                    ApplicationArea = Basic, Suite;
                }
                Field("Repaid Amount"; "Repaid Amount")
                {
                    ApplicationArea = Basic, Suite;
                }
                Field("Remaining Loan / Advance Debt"; "Remaining Loan / Advance Debt")
                {
                    ApplicationArea = Basic, Suite;
                }
                Field("Total Interest"; "Total Interest")
                {
                    ApplicationArea = Basic, Suite;
                }
                Field("Total Interest (LCY)"; "Total Interest (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                }
                Field("Interest Paid"; "Interest Paid")
                {
                    ApplicationArea = Basic, Suite;
                }
                Field("Interest Paid (LCY)"; "Interest Paid (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                }
                Field("Last Suspension Date"; "Last Suspension Date")
                {
                    ApplicationArea = Basic, Suite;

                }
                Field("Last Suspension Duration"; "Last Suspension Duration")
                {
                    ApplicationArea = Basic, Suite;
                }
                Field(Posted; Posted)
                {
                    ApplicationArea = Basic, Suite;
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
            action(Post)
            {
                ApplicationArea = All;
                Caption = 'Post';
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    PostLoan();
                end;
            }
            action("Change Loan")
            {
                ApplicationArea = All;
                Caption = 'Change Loan';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = ChangeDates;
                trigger OnAction()
                var
                    ASLT0003: label 'Are you sure you want to change loan?';
                begin
                    IF CONFIRM(ASLT0003) THEN
                        PostponeLoanPeriod;
                end;
            }
        }
    }
}
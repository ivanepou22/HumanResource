pageextension 50003 "Customer List Ext" extends "Customer List"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
        addafter("Customer - Sales List")
        {
            action("Customer - Payment Receipt")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                Image = Report;
                RunObject = report "Customer - Payment Receipt";
                trigger OnAction()
                begin

                end;
            }
        }

        addafter(ReportCustomerDetailTrial)
        {
            action(ActionName)
            {
                ApplicationArea = Suite;
                Caption = 'Customer - Detail Trial Bal. Mod';
                Image = "Report";
                ToolTip = 'View the balance for customers with balances on a specified date. The report can be used at the close of an accounting period, for example, or for an audit.';

                trigger OnAction()
                var
                    Customer: Record customer;
                    DetailedTrialBalance: Report "Customer Detail Trial Bal";
                begin
                    Customer.Reset();
                    Customer.SetRange(Customer."No.", Rec."No.");
                    DetailedTrialBalance.SetTableView(Customer);
                    DetailedTrialBalance.Run();
                end;
            }
        }

        addafter(ReportCustomerTrialBalance)
        {
            action(ReportCustomerDetailTrials)
            {
                ApplicationArea = Suite;
                Caption = 'Customer - Detail Trial Bal.';
                Image = "Report";
                ToolTip = 'View the balance for customers with balances on a specified date. The report can be used at the close of an accounting period, for example, or for an audit.';

                trigger OnAction()
                var
                    CustDetailedBalance: Report "Customer - Detail Trial Bal.";
                    Customer: Record Customer;
                begin
                    Customer.Reset();
                    Customer.SetRange(Customer."No.", Rec."No.");
                    CustDetailedBalance.SetTableView(Customer);
                    CustDetailedBalance.Run();
                end;
            }
        }
        modify(ReportCustomerDetailTrial)
        {
            Visible = false;
            Enabled = false;
        }
    }

    var
        myInt: Integer;
}
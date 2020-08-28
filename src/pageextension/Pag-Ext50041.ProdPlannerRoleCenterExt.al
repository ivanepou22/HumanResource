pageextension 50041 "Prod. Planner Role Center Ext" extends "Production Planner Role Center"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
        addafter(Worksheets)
        {
            group("Employee Self Service")
            {
                action("Employee Loan")
                {
                    ApplicationArea = All;
                    Caption = 'Employee Loans';
                    Image = AdjustVATExemption;
                    RunObject = page "Employee Loans SelfService";
                }

                action("Employee Advance")
                {
                    ApplicationArea = All;
                    Caption = 'Employee Advances';
                    Image = CashFlow;
                    RunObject = page "Employee Advances SelfService";
                }

                action("My Leave Applications")
                {
                    ApplicationArea = All;
                    Caption = 'Leave Applications';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = page "Employee Leaves SelfService";
                    RunPageView = WHERE("Absence Type" = CONST(Leave), "Leave Status" = CONST(Application));
                    Image = LedgerBook;

                }
                action("My Rejected Leave Applications")
                {
                    ApplicationArea = All;
                    Caption = 'Rejected Leave Applications';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = page "Employee Leaves SelfService";
                    RunPageView = WHERE("Absence Type" = CONST(Leave), "Leave Status" = CONST(Rejected));
                    Image = LedgerBook;

                }
                action("My Cancelled Leave Applications")
                {
                    ApplicationArea = All;
                    Caption = 'Cancelled Leave Applications';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = page "Employee Leaves SelfService";
                    RunPageView = WHERE("Absence Type" = CONST(Leave), "Leave Status" = CONST(Cancelled));
                    Image = LedgerBook;

                }
                action("My Submitted Leave Applications")
                {
                    ApplicationArea = All;
                    Caption = 'Submitted Leave Applications';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = page "Employee Leaves SelfService";
                    RunPageView = WHERE("Absence Type" = CONST(Leave), "Leave Status" = CONST("Pending Approval"));
                    Image = LedgerBook;

                }
                action("My Current Leave List")
                {
                    ApplicationArea = All;
                    Caption = 'Current Leave List';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = page "Employee Leaves SelfService";
                    RunPageView = WHERE("Absence Type" = CONST(Leave), "Leave Status" = FILTER(Approved | Taken));
                    Image = CoupledItem;

                }
                action("My Leave History")
                {
                    ApplicationArea = All;
                    Caption = 'Leave History';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = page "Employee Leaves SelfService";
                    RunPageView = WHERE("Absence Type" = CONST(Leave), "Leave Status" = CONST(History));
                    Image = History;

                }

                action("Cash Requisition")
                {
                    ApplicationArea = All;
                    Caption = 'Cash Requisitions';
                    Image = ReceiptLines;
                    RunObject = page "AdvancePurchase RequisitionsSS";
                }

                action("Purchase Requisition")
                {
                    ApplicationArea = All;
                    Caption = 'Purchase Requisitions';
                    Image = ReceiptLines;
                    RunObject = page "Purchase Requisitions Self";
                }

            }
        }
    }

    var
        myInt: Integer;
}
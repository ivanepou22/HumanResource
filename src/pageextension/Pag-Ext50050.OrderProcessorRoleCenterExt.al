pageextension 50050 "OrderProcessor RoleCenter Ext" extends "Order Processor Role Center"
{
    layout
    {
        // Add changes to page layout here

    }

    actions
    {
        // Add changes to page actions here
        addlast(embedding)
        {
            action(ActionName)
            {
                ApplicationArea = All;
                Caption = 'Branches';
                ToolTip = 'Branches';
                RunObject = Page Confidential;
                RunPageView = SORTING(Type, Code) WHERE(Type = CONST(Branch));
                Image = BreakRulesList;
            }
        }
        addafter("Posted Documents")
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
        addafter("Inventory - Sales &Back Orders")
        {

            action("Seal Report")
            {
                ApplicationArea = All;
                Caption = 'Seal Report';
                RunObject = report "Seal Report";
                Image = SerialNo;
            }
            action("Sales Return Report")
            {
                ApplicationArea = All;
                Caption = 'Sales Return Report';
                RunObject = report "Sales Return Report";
                Image = Report;
            }
            action("Sales - Return Reciept")
            {
                ApplicationArea = All;
                Caption = 'Sales - Return Reciept';
                RunObject = report "Sales - Return Receipt";
                Image = Report;
            }
        }

    }

    var
        myInt: Integer;
}
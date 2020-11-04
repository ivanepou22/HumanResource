pageextension 50036 "Acc. Manager Role Center Ext" extends "Accounting Manager Role Center"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
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

            group(Requisitions)
            {
                group("Cash Requests")
                {
                    group("Transfered Cash Requisitions")
                    {

                        action("Assigned Cash Requisitions")
                        {
                            ApplicationArea = All;
                            Caption = 'Assigned Transfered Cash Requisitions';
                            Image = ReceiptLines;
                            RunObject = page "Assigned Cash Requisitions";
                            RunPageView = where("Transfered To Journals" = filter(true), Status = filter(Released));
                        }

                        action("All Cash Requisitions")
                        {
                            ApplicationArea = All;
                            Caption = 'All Transfered Cash Requisitions';
                            Image = ReceiptLines;
                            RunObject = page "Advance Purchase Requisitions";
                            RunPageView = where("Transfered To Journals" = filter(true), Status = filter(Released));
                        }

                    }

                    group("Released Cash Requisitions")
                    {
                        action("AssignedR Cash Requisitions")
                        {
                            ApplicationArea = All;
                            Caption = 'Assigned Released Cash Requisitions';
                            Image = ReceiptLines;
                            RunObject = page "Assigned Cash Requisitions";
                            RunPageView = where("Transfered To Journals" = filter(false), Status = filter(Released));
                        }
                        action("AllR Cash Requisitions")
                        {
                            ApplicationArea = All;
                            Caption = 'All Released Cash Requisitions';
                            Image = ReceiptLines;
                            RunObject = page "Advance Purchase Requisitions";
                            RunPageView = where("Transfered To Journals" = filter(false), Status = filter(Released));
                        }
                    }

                    group("Pending Cash Requisitions")
                    {
                        action("AssignedP Cash Requisitions")
                        {
                            ApplicationArea = All;
                            Caption = 'Assigned Pending Cash Requisitions';
                            Image = ReceiptLines;
                            RunObject = page "Assigned Cash Requisitions";
                            RunPageView = where(Status = filter("Pending Approval"));
                        }
                        action("PendingP Cash Requisitions")
                        {
                            ApplicationArea = All;
                            Caption = 'All Pending Cash Requisitions';
                            Image = ReceiptLines;
                            RunObject = page "Advance Purchase Requisitions";
                            RunPageView = where(Status = filter("Pending Approval"));
                        }
                    }
                    group("Open Cash Requisitions")
                    {
                        action("AssignedO Cash Requisitions")
                        {
                            ApplicationArea = All;
                            Caption = 'Assigned Open Cash Requisitions';
                            Image = ReceiptLines;
                            RunObject = page "Assigned Cash Requisitions";
                            RunPageView = where(Status = filter(Open));
                        }
                        action("OpenO Cash Requisitions")
                        {
                            ApplicationArea = All;
                            Caption = 'All Open Cash Requisitions';
                            Image = ReceiptLines;
                            RunObject = page "Advance Purchase Requisitions";
                            RunPageView = where(Status = filter(Open));
                        }
                    }
                }
                group("Purchase Requests")
                {
                    group("Released Purchase Requisitions")
                    {
                        action("Assigned Released Purchase Requisitions")
                        {
                            ApplicationArea = All;
                            Image = ReceiptLines;
                            RunObject = page "Assigned Purchase Requisitions";
                            RunPageView = where(Status = filter("Released"));
                        }
                        action("All Released Purchase Requisitions")
                        {
                            ApplicationArea = All;
                            Image = ReceiptLines;
                            RunObject = page "Purchase Requisitions";
                            RunPageView = where(Status = filter("Released"));
                        }
                    }

                    group("Pending Purchase Requisitions")
                    {
                        action("Assigned Pending Purchase Requisitions")
                        {
                            ApplicationArea = All;
                            Image = ReceiptLines;
                            RunObject = page "Assigned Purchase Requisitions";
                            RunPageView = where(Status = filter("Pending Approval"));
                        }
                        action("All Pending Purchase Requisitions")
                        {
                            ApplicationArea = All;
                            Image = ReceiptLines;
                            RunObject = page "Purchase Requisitions";
                            RunPageView = where(Status = filter("Pending Approval"));
                        }
                    }

                    group("Open Purchase Requisitions")
                    {
                        action("Assigned Open Purchase Requisitions")
                        {
                            ApplicationArea = All;
                            Image = ReceiptLines;
                            RunObject = page "Assigned Purchase Requisitions";
                            RunPageView = where(Status = filter(Open));
                        }

                        action("All Open Purchase Requisitions")
                        {
                            ApplicationArea = All;
                            Image = ReceiptLines;
                            RunObject = page "Purchase Requisitions";
                            RunPageView = where(Status = filter(Open));
                        }

                    }
                }

                action("Purchase Requisition Archives")
                {
                    ApplicationArea = All;
                    Caption = 'Purchase Requisition Archives';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Image = Archive;
                    RunObject = page "Purchase Requisition Archives";
                }
                action(RequestsToApprove)
                {
                    ApplicationArea = All;
                    Caption = 'Requests to Approve';
                    RunObject = page "Requests to Approve";
                    Image = SendApprovalRequest;
                }
            }

        }

        addafter("&Bank Detail Trial Balance")
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
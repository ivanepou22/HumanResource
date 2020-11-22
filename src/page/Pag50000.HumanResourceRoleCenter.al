page 50000 "Human Resource Role Center"
{
    PageType = RoleCenter;
    Caption = 'Human Resource Manager Role Center';

    layout
    {
        area(RoleCenter)
        {
            part(Headline; "Headline RC Human Resource")
            {
                ApplicationArea = Basic, Suite;
            }
            part(Activities; "Human Resource Activities")
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }

    actions
    {
        area(Creation)
        {
            action("New Employee")
            {
                RunPageMode = Create;
                Caption = 'New Employee';
                ToolTip = 'Adding a new employee';
                Image = New;
                RunObject = page "Employee Card";
                ApplicationArea = Basic, Suite;
            }
        }
        area(Processing)
        {
            group(New)
            {
                action("New Leave Application")
                {
                    RunPageMode = Create;
                    Caption = 'Leave Application';
                    ToolTip = 'New Leave Application';
                    RunObject = page "Employee Leave Card";
                    Image = DataEntry;
                    ApplicationArea = Basic, Suite;
                }
            }
            group(Lists)
            {
                action("Employee List")
                {
                    Caption = 'Employees';
                    ToolTip = 'Employee Lists';
                    Image = Users;
                    RunObject = page "Employee List";
                    ApplicationArea = Basic, Suite;

                }
                action("Application List")
                {
                    Caption = 'Job Applications';
                    ToolTip = 'Job Applications';
                    Image = ApplicationWorksheet;
                    RunObject = page "Applicant List";
                    ApplicationArea = Basic, Suite;

                }
                action("Vacancy List")
                {
                    Caption = 'Vacancy Requests';
                    ToolTip = 'Vacancy Requests';
                    Image = ReceiveLoaner;
                    RunObject = page "Vacancy List";
                    ApplicationArea = Basic, Suite;
                }

            }
            group("Reports")
            {
                action("Seal Report")
                {
                    Caption = 'Seal Report';
                    ToolTip = 'Seals Report having Truck and Seal No';
                    Image = Segment;
                    RunObject = report "Seal Report";
                    ApplicationArea = Basic, Suite;
                }
                action("Employee Sales Report")
                {
                    Caption = 'Farm Sales';
                    ToolTip = 'Employee Sales Report';
                    Image = Report;
                    RunObject = report "Staff Farm Sales";
                    ApplicationArea = Basic, Suite;
                }
                action("Payroll Report")
                {
                    Caption = 'Payroll Report';
                    ToolTip = 'Employee Payroll Report';
                    Image = Report;
                    RunObject = report "Payroll Report";
                    ApplicationArea = Basic, Suite;
                }
                action(PaySlips)
                {
                    Caption = 'PaySlip';
                    ToolTip = 'Employee PaySlip';
                    Image = PaymentHistory;
                    RunObject = report Payslip;
                    ApplicationArea = Basic, Suite;
                }
                action("Payroll. Summary")
                {
                    Caption = 'Payroll Summary';
                    ToolTip = 'Employee Payroll Summary';
                    Image = PayrollStatistics;
                    RunObject = report "Payroll Summary";
                    ApplicationArea = Basic, Suite;
                }
                action("Payroll. Summary B4 Close")
                {
                    Caption = 'Payroll Summary B4 Close';
                    ToolTip = 'Employee Payroll Summary before closing the payroll period';
                    Image = PayrollStatistics;
                    RunObject = report "Payroll Summary Before Post";
                    ApplicationArea = Basic, Suite;
                }

            }


        }
        area(Reporting)
        {
            action("Staff Sales")
            {
                Caption = 'Staff Sales';
                ToolTip = 'Staff Sales';
                Image = Report;
                RunObject = report "Staff Farm Sales";
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                ApplicationArea = Basic, Suite;
            }
            action("Payroll Reports")
            {
                Caption = 'Payroll Report';
                ToolTip = 'Employee Payroll Report';
                Image = PayrollStatistics;
                RunObject = report "Payroll Report";
                ApplicationArea = Basic, Suite;
            }
            action(PaySlip)
            {
                Caption = 'PaySlip';
                ToolTip = 'Employee PaySlip';
                Image = PaymentHistory;
                RunObject = report Payslip;
                ApplicationArea = Basic, Suite;
            }

            action("Payroll Summary")
            {
                Caption = 'Payroll Summary';
                ToolTip = 'Employee Payroll Summary';
                Image = PayrollStatistics;
                RunObject = report "Payroll Summary";
                ApplicationArea = Basic, Suite;
            }
            action("Payroll Summary B4 Close")
            {
                Caption = 'Payroll Summary B4 Close';
                ToolTip = 'Employee Payroll Summary before closing the payroll period';
                Image = PayrollStatistics;
                RunObject = report "Payroll Summary Before Post";
                ApplicationArea = Basic, Suite;
            }

        }
        area(Embedding)
        {
            action(Employees)
            {
                RunObject = page "Employee List";
                Image = List;
                ApplicationArea = Basic, Suite;
            }
            action("Bank Accounts")
            {
                RunObject = page "Bank Account List";
                Image = List;
                ApplicationArea = Basic, Suite;
            }
            action("Bank Account Reconciliations")
            {
                RunObject = page "Bank Acc. Reconciliation List";
                Image = List;
                ApplicationArea = Basic, Suite;
            }
            action("Leave Applications")
            {
                RunObject = page "Employee Leave List";
                Image = List;
                ApplicationArea = Basic, Suite;
            }

            action("Chart Of Accounts")
            {
                RunObject = page "Chart of Accounts";
                Image = List;
                ApplicationArea = Basic, Suite;
            }
            action("Fixed Assets")
            {
                RunObject = page "Fixed Asset List";
                Image = List;
                ApplicationArea = Basic, Suite;
            }
            action("Absence Registration")
            {
                RunObject = page "Absence Registration";
                Image = List;
                ApplicationArea = Basic, Suite;
            }
            action("Employee Overtime")
            {
                RunObject = page "Employee Overtime";
                RunPageView = WHERE("Transfered To Payroll" = CONST(false));
                Image = PostedDeposit;
                ApplicationArea = Basic, Suite;
            }
            action("Posted Overtime")
            {
                RunObject = page "Employee Overtime";
                RunPageView = WHERE("Transfered To Payroll" = CONST(true));
                Image = List;
                ApplicationArea = Basic, Suite;
            }
            action("Employee Loans")
            {
                RunObject = page "Employee Loans";
                Image = List;
                ApplicationArea = Basic, Suite;
            }
            action("Employee Advances")
            {
                RunObject = page "Employee Advances";
                Image = List;
                ApplicationArea = Basic, Suite;
            }
            action("Training Courses")
            {
                RunObject = page "Training Courses";
                RunPageView = where(Type = const(Course));
                Image = List;
                ApplicationArea = Basic, Suite;
            }
            action("Training Time Table")
            {
                RunObject = page "Training TimeTable";
                Image = List;
                ApplicationArea = Basic, Suite;
            }

            action("Disciplinary Actions")
            {
                RunObject = page Confidential;
                RunPageView = SORTING(Type, Code) WHERE(Type = CONST(Discipline));
                Image = List;
                ApplicationArea = Basic, Suite;
            }
            action("Termination Grounds")
            {
                RunObject = page "Grounds for Termination";
                Image = List;
                ApplicationArea = Basic, Suite;
            }

        }
        area(Sections)
        {
            group("HR Setup")
            {
                Caption = 'HR Setup';
                ToolTip = 'Contains the Major HR Setups';
                Image = Setup;

                action("Human Resource Setup")
                {
                    Caption = 'HR Setup';
                    ToolTip = 'Human Resource Setup';
                    RunObject = Page "Human Resources Setup";
                    ApplicationArea = Basic, Suite;
                    Image = Setup;

                }
                action("HR Units Of Measure")
                {
                    ToolTip = 'Human Resource Units of Measure';
                    RunObject = Page "Human Res. Units of Measure";
                    ApplicationArea = Basic, Suite;

                }

                action("Cause Of Absence")
                {
                    ToolTip = 'Registering the causes of Absence.';
                    RunObject = Page "Causes of Absence";
                    ApplicationArea = Basic, Suite;
                }
                action("Job Titles")
                {
                    ToolTip = 'A List Of Job Titles.';
                    RunObject = Page "Employment Contracts";
                    ApplicationArea = Basic, Suite;
                }
                action(Relatives)
                {
                    ToolTip = 'Lists of Relatives';
                    RunObject = Page Relatives;
                    ApplicationArea = Basic, Suite;
                }
                action(Qualifications)
                {
                    ToolTip = 'Qualifications';
                    RunObject = Page Qualifications;
                    ApplicationArea = Basic, Suite;
                }
                action(Calendars)
                {
                    ToolTip = 'Base Calendar List';
                    RunObject = Page "Base Calendar List";
                    ApplicationArea = Basic, Suite;
                }
                action("Employee Tribe")
                {
                    ToolTip = 'Employee Tribes';
                    RunObject = Page "Employee Tribe";
                    ApplicationArea = Basic, Suite;
                }
                action("Employee Religion")
                {
                    ToolTip = 'Employee Religion';
                    RunObject = Page "Employee Religion";
                    ApplicationArea = Basic, Suite;
                }
            }
            group(Recruitment)
            {
                group(Applications)
                {

                    action("Submitted Applications")
                    {
                        ToolTip = 'Submitted Applications';
                        RunObject = Page "Applicant List";
                        ApplicationArea = All;
                        RunPageView = WHERE(Status = CONST(Inprogress));
                        Image = Apply;
                    }
                    action("Interview Applications")
                    {
                        ToolTip = 'Interview Applications';
                        RunObject = Page "Applicant List";
                        ApplicationArea = All;
                        RunPageView = WHERE(Status = CONST(Interview));
                        Image = Process;
                    }
                    action("Declined Applications")
                    {
                        ToolTip = 'Declined Applications';
                        RunObject = Page "Applicant List";
                        ApplicationArea = All;
                        RunPageView = WHERE(Status = CONST(Declined));
                        Image = CancelAllLines;
                    }
                    action("Appointed Applications")
                    {
                        ToolTip = 'Appointed Applications';
                        RunObject = Page "Applicant List";
                        ApplicationArea = Basic, Suite;
                        RunPageView = WHERE(Status = CONST(Appointed));
                        Image = Approve;
                    }
                }
                group("Vacancy Requests")
                {

                    action("Approved Requests")
                    {
                        ToolTip = 'Apporved Requests';
                        RunObject = Page "Vacancy List";
                        ApplicationArea = Basic, Suite;
                        RunPageView = WHERE("Vacancy Status" = CONST(Approved));
                        Image = ApprovalSetup;
                    }
                    action("Pending Approval Requests")
                    {
                        ToolTip = 'Pending Approval Requests';
                        RunObject = Page "Vacancy List";
                        ApplicationArea = Basic, Suite;
                        RunPageView = WHERE("Vacancy Status" = CONST("Pending Approval"));
                        Image = Approval;
                    }
                    action("Rejected Requests")
                    {
                        ToolTip = 'Rejected Requests';
                        RunObject = Page "Vacancy List";
                        ApplicationArea = Basic, Suite;
                        RunPageView = WHERE("Vacancy Status" = CONST(Rejected));
                        Image = Reject;
                    }

                }

            }

            group(Payroll)
            {
                action("Range Tables")
                {
                    ToolTip = 'Range Tables';
                    RunObject = Page Confidential;
                    ApplicationArea = Basic, Suite;
                    RunPageView = SORTING(Type, Code) WHERE(Type = CONST("Range Table"));
                    Image = Ranges;
                }
                action(Earnings)
                {
                    ToolTip = 'Earnings';
                    RunObject = Page Confidential;
                    ApplicationArea = Basic, Suite;
                    RunPageView = SORTING(Type, Code) WHERE(Type = CONST(Earning));
                    Image = Check;
                }
                action(Deductions)
                {
                    ToolTip = 'Deductions';
                    RunObject = Page Confidential;
                    ApplicationArea = Basic, Suite;
                    RunPageView = SORTING(Type, Code) WHERE(Type = CONST(Deduction));
                    Image = RefreshDiscount;
                }
                action("Employee Banks")
                {
                    ToolTip = 'Employee Banks';
                    RunObject = Page Confidential;
                    ApplicationArea = Basic, Suite;
                    RunPageView = SORTING(Type, Code) WHERE(Type = CONST("Employee Bank"));
                    Image = Bank;
                }
                action("Major Locations")
                {
                    ToolTip = 'Major Locations';
                    RunObject = Page Confidential;
                    ApplicationArea = Basic, Suite;
                    RunPageView = SORTING(Type, Code) WHERE(Type = CONST("Employee Location"));
                    Image = Lock;
                }
                action("Employee Payroll Groups")
                {
                    ToolTip = 'Employee Payroll Groups';
                    RunObject = Page "Employee Statistics Groups";
                    ApplicationArea = Basic, Suite;
                    Image = Group;
                }

                action("Employee Overtime Earnings")
                {
                    ToolTip = 'Employee Overtime Earnings';
                    RunObject = Page "Employee Overtime Earning";
                    ApplicationArea = Basic, Suite;
                    Image = Group;
                }
            }

            group(Journals)
            {
                action("Cash Receipt Journals")
                {
                    ToolTip = 'Cash Receipt Journals';
                    RunObject = Page "General Journal Batches";
                    RunPageView = WHERE("Template Type" = CONST("Cash Receipts"), Recurring = CONST(false));
                    ApplicationArea = Basic, Suite;
                    Image = Journals;
                }
                action("Payment Journals")
                {
                    ToolTip = 'Payment Journals';
                    RunObject = Page "General Journal Batches";
                    RunPageView = WHERE("Template Type" = CONST(Payments), Recurring = CONST(false));
                    ApplicationArea = Basic, Suite;
                    Image = Journals;
                }
                action("General Journals")
                {
                    ToolTip = 'General Journals';
                    RunObject = Page "General Journal Batches";
                    RunPageView = WHERE("Template Type" = CONST(General), Recurring = CONST(false));
                    ApplicationArea = Basic, Suite;
                    Image = Journals;
                }
            }

            group("Leave Management")
            {
                action("Leave Application")
                {
                    ApplicationArea = All;
                    Caption = 'Leave Applications';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = page "Employee Leave List";
                    RunPageView = WHERE("Absence Type" = CONST(Leave), "Leave Status" = CONST(Application));
                    Image = LedgerBook;

                }
                action("Rejected Leave Application")
                {
                    ApplicationArea = All;
                    Caption = 'Rejected Leave Applications';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = page "Employee Leave List";
                    RunPageView = WHERE("Absence Type" = CONST(Leave), "Leave Status" = CONST(Rejected));
                    Image = LedgerBook;

                }
                action("Cancelled Leave Application")
                {
                    ApplicationArea = All;
                    Caption = 'Cancelled Leave Applications';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = page "Employee Leave List";
                    RunPageView = WHERE("Absence Type" = CONST(Leave), "Leave Status" = CONST(Cancelled));
                    Image = LedgerBook;

                }
                action("Submitted Leave Applications")
                {
                    ApplicationArea = All;
                    Caption = 'Submitted Leave Applications';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = page "Employee Leave List";
                    RunPageView = WHERE("Absence Type" = CONST(Leave), "Leave Status" = CONST("Pending Approval"));
                    Image = LedgerBook;

                }
                action("Current Leave List")
                {
                    ApplicationArea = All;
                    Caption = 'Current Leave List';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = page "Employee Leave List";
                    RunPageView = WHERE("Absence Type" = CONST(Leave), "Leave Status" = FILTER(Approved | Taken));
                    Image = CoupledItem;

                }
                action("Leave History")
                {
                    ApplicationArea = All;
                    Caption = 'Leave History';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = page "Employee Leave List";
                    RunPageView = WHERE("Absence Type" = CONST(Leave), "Leave Status" = CONST(History));
                    Image = History;

                }

            }
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
            group(Requisitions) //Requisitions
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
                action("User Locations")
                {
                    ApplicationArea = All;
                    Caption = 'User Location';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = page "User Location";

                }

                action(Territories)
                {
                    ApplicationArea = All;
                    Caption = 'Territories';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = page Territories;

                }

                action(Branches)
                {
                    ToolTip = 'Branches';
                    RunObject = Page Confidential;
                    ApplicationArea = Basic, Suite;
                    RunPageView = SORTING(Type, Code) WHERE(Type = CONST(Branch));
                    Image = Bank;
                }
                action(Drawers)
                {
                    ApplicationArea = basic, suite;
                    Caption = 'Drawers';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = page Drawers;
                    Image = Delivery;
                }

                action("Transfer Reason")
                {
                    ApplicationArea = basic, suite;
                    Caption = 'Transfer Reason';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = page "Transfer Reasons";
                    Image = TransferOrder;
                }
            } //
        }
    }

}
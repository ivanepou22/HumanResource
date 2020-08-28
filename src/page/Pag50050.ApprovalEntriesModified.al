page 50050 "Approval Entries Modified"
{
    Caption = 'Approval Entries Modified';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "Approval Entry";
    SourceTableView = SORTING("Table ID", "Document Type", "Document No.", "Date-Time Sent for Approval")
                      ORDER(Ascending);

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field(Overdue; Overdue)
                {
                    ApplicationArea = Suite;
                    Caption = 'Overdue';
                    Editable = false;
                    ToolTip = 'Specifies that the approval is overdue.';
                }
                field("Table ID"; "Table ID")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the ID of the table where the record that is subject to approval is stored.';
                    Visible = false;
                }
                field("Limit Type"; "Limit Type")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the type of limit that applies to the approval template:';
                }
                field("Approval Type"; "Approval Type")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies which approvers apply to this approval template:';
                }
                field("Document Type"; "Document Type")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the type of document that an approval entry has been created for. Approval entries can be created for six different types of sales or purchase documents:';
                    Visible = false;
                }
                field("Document No."; "Document No.")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the document number copied from the relevant sales or purchase document, such as a purchase order or a sales quote.';
                    Visible = false;
                }
                field(RecordIDText; RecordIDText)
                {
                    ApplicationArea = Suite;
                    Caption = 'To Approve';
                    ToolTip = 'Specifies the record that you are requested to approve.';
                }
                field(Details; RecordDetails)
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the record that the approval is related to.';
                }
                field("Sequence No."; "Sequence No.")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the order of approvers when an approval workflow involves more than one approver.';
                }
                field(Status; Status)
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the approval status for the entry:';
                }
                field("Sender ID"; "Sender ID")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the ID of the user who sent the approval request for the document to be approved.';

                    trigger OnDrillDown()
                    var
                        UserMgt: Codeunit "User Management";
                    begin
                        UserMgt.DisplayUserInformation("Sender ID");
                    end;
                }
                field("Salespers./Purch. Code"; "Salespers./Purch. Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the code for the salesperson or purchaser that was in the document to be approved. It is not a mandatory field, but is useful if a salesperson or a purchaser responsible for the customer/vendor needs to approve the document before it is processed.';
                }
                field("Approver ID"; "Approver ID")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the ID of the user who must approve the document.';

                    trigger OnDrillDown()
                    var
                        UserMgt: Codeunit "User Management";
                    begin
                        UserMgt.DisplayUserInformation("Approver ID");
                    end;
                }
                field("Currency Code"; "Currency Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the code of the currency of the amounts on the sales or purchase lines.';
                }
                field("Amount (LCY)"; "Amount (LCY)")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the total amount (excl. VAT) on the document awaiting approval. The amount is stated in the local currency.';
                }
                field("Available Credit Limit (LCY)"; "Available Credit Limit (LCY)")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the remaining credit (in LCY) that exists for the customer.';
                }
                field("Date-Time Sent for Approval"; "Date-Time Sent for Approval")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the date and the time that the document was sent for approval.';
                }
                field("Last Date-Time Modified"; "Last Date-Time Modified")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the date when the approval entry was last modified. If, for example, the document approval is canceled, this field will be updated accordingly.';
                }
                field("Last Modified By User ID"; "Last Modified By User ID")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the ID of the user who last modified the approval entry. If, for example, the document approval is canceled, this field will be updated accordingly.';

                    trigger OnDrillDown()
                    var
                        UserMgt: Codeunit "User Management";
                    begin
                        UserMgt.DisplayUserInformation("Last Modified By User ID");
                    end;
                }
                field(Comment; Comment)
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies whether there are comments relating to the approval of the record. If you want to read the comments, choose the field to open the Approval Comment Sheet window.';
                }
                field("Due Date"; "Due Date")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies when the record must be approved, by one or more approvers.';
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
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }

    var
        Overdue: Option Yes," ";
        RecordIDText: Text;
        ShowChangeFactBox: Boolean;
        DelegateEnable: Boolean;
        ShowRecCommentsEnabled: Boolean;

}
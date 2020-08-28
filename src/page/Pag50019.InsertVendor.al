page 50019 "Insert Vendor"
{
    PageType = StandardDialog;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Purchase Header";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Field("Purchase Vendor No."; "Purchase Vendor No.")
                {
                    ApplicationArea = All;
                }
                Field("Purchase Vendor Name"; "Purchase Vendor Name")
                {
                    ApplicationArea = All;
                }
                Field("Contract Purch. Agreement No."; "Contract Purch. Agreement No.")
                {
                    ApplicationArea = All;
                }
                Field("Certificate No."; "Certificate No.")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    //////=======================
    trigger OnAfterGetRecord()
    var

    begin

    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        myInt: Integer;
        purchaseLine: Record "Purchase Line";
    begin
        IF CloseAction IN [ACTION::OK, ACTION::LookupOK] THEN begin

            purchaseLine.Reset();
            purchaseLine.SetRange(purchaseLine."Document No.", Rec."No.");
            if purchaseLine.FindFirst() then
                repeat
                    purchaseLine."Buy-from Vendor No." := "Purchase Vendor No.";
                    purchaseLine."Pay-to Vendor No." := "Purchase Vendor No.";
                    purchaseLine.Modify();
                until purchaseLine.Next() = 0;

            IF ApprovalsMgmt.PrePostApprovalCheckPurch(Rec) THEN begin
                CODEUNIT.RUN(CODEUNIT::"PurchQuote to Order (Yes/No)", Rec);
            end;
        end;
    end;

    var
        ItemJnlMgt: Codeunit ItemJnlManagement;
        NewInventory: Decimal;
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        ContractCertficateShow: Boolean;
        CantFindTemplateOrBatchErr: Label 'Unable to find the correct Item Journal template or batch to post this change. Use the Item Journal instead.';
        SimpleInvJnlNameTxt: Label 'DEFAULT';

    //====================================
    procedure IsContractCertLPO(ContractCertificate: Boolean)
    begin
        ContractCertficateShow := ContractCertificate;
    end;
}
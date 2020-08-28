page 50063 "Posted Bank Acc. Rec. Lines"
{
    Caption = 'Lines';
    PageType = ListPart;
    Editable = false;
    SourceTable = "Bank Acc. Reconciliation Line";
    SourceTableView = WHERE("Statement Type" = CONST("Payment Application"));
    DelayedInsert = true;
    AutoSplitKey = true;
    LinksAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {

                Field("Transaction Date"; "Transaction Date")
                {
                    ApplicationArea = All;
                }
                Field("Value Date"; "Value Date")
                {
                    ApplicationArea = All;
                }
                Field("Document No."; "Document No.")
                {
                    ApplicationArea = All;
                }
                Field("Check No."; "Check No.")
                {
                    ApplicationArea = All;
                }
                Field(Type; Type)
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    var
                        myInt: Integer;
                    begin
                        SetUserInteractions;
                    end;
                }
                Field(Description; Description)
                {
                    ApplicationArea = All;
                }
                Field("Statement Amount"; "Statement Amount")
                {
                    ApplicationArea = All;
                }
                Field("Applied Amount"; "Applied Amount")
                {
                    ApplicationArea = All;
                }
                Field(Difference; Difference)
                {
                    ApplicationArea = All;
                }
                Field("Applied Entries"; "Applied Entries")
                {
                    ApplicationArea = All;
                }
                Field("Related-Party Name"; "Related-Party Name")
                {
                    ApplicationArea = All;
                }
                Field("Statement Line No."; "Statement Line No.")
                {
                    ApplicationArea = All;
                }
                Field("Additional Transaction Info"; "Additional Transaction Info")
                {
                    ApplicationArea = All;
                }
            }

            group("Group4")
            {
                ShowCaption = false;

                Field("Balance Balance"; Balance + "Statement Amount")
                {
                    ApplicationArea = All;
                }
                Field("Total Balance"; TotalBalance + "Statement Amount")
                {
                    ApplicationArea = All;
                }
                Field("Total Difference"; TotalDiff + Difference)
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

        }
    }

    var

        BankAccRecon: Record "Bank Acc. Reconciliation";
        StyleTxt: Text;
        TotalDiff: Decimal;
        Balance: Decimal;
        TotalBalance: Decimal;
        TotalDiffEnable: Boolean;
        TotalBalanceEnable: Boolean;
        BalanceEnable: Boolean;
        ApplyEntriesAllowed: Boolean;

    //Triggers

    trigger OnInit()
    begin
        BalanceEnable := TRUE;
        TotalBalanceEnable := TRUE;
        TotalDiffEnable := TRUE;
    end;

    trigger OnAfterGetRecord()
    begin
        SetUserInteractions;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        IF BelowxRec THEN
            CalcBalance(xRec."Statement Line No.")
        ELSE
            CalcBalance(xRec."Statement Line No." - 1);
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        SetUserInteractions;
    end;

    trigger OnAfterGetCurrRecord()
    begin
        IF "Statement Line No." <> 0 THEN
            CalcBalance("Statement Line No.");
        SetUserInteractions;
    end;


    //functions
    local procedure CalcBalance(BankAccReconLineNo: Integer)
    var
        TempBankAccReconLine: Record "Bank Acc. Reconciliation Line";
    begin
        IF BankAccRecon.GET("Statement Type", "Bank Account No.", "Statement No.") THEN;

        TempBankAccReconLine.COPY(Rec);

        TotalDiff := -Difference;
        IF TempBankAccReconLine.CALCSUMS(Difference) THEN BEGIN
            TotalDiff := TotalDiff + TempBankAccReconLine.Difference;
            TotalDiffEnable := TRUE;
        END ELSE
            TotalDiffEnable := FALSE;

        TotalBalance := BankAccRecon."Balance Last Statement" - "Statement Amount";
        IF TempBankAccReconLine.CALCSUMS("Statement Amount") THEN BEGIN
            TotalBalance := TotalBalance + TempBankAccReconLine."Statement Amount";
            TotalBalanceEnable := TRUE;
        END ELSE
            TotalBalanceEnable := FALSE;

        Balance := BankAccRecon."Balance Last Statement" - "Statement Amount";
        TempBankAccReconLine.SETRANGE("Statement Line No.", 0, BankAccReconLineNo);
        IF TempBankAccReconLine.CALCSUMS("Statement Amount") THEN BEGIN
            Balance := Balance + TempBankAccReconLine."Statement Amount";
            BalanceEnable := TRUE;
        END ELSE
            BalanceEnable := FALSE;
    end;

    local procedure ApplyEntries()
    var
        BankAccReconApplyEntries: Codeunit "Bank Acc. Recon. Apply Entries";
    begin
        "Ready for Application" := TRUE;
        CurrPage.SAVERECORD;
        COMMIT;
        BankAccReconApplyEntries.ApplyEntries(Rec);
    end;

    procedure GetSelectedRecords(VAR TempBankAccReconciliationLine: Record "Bank Acc. Reconciliation Line" temporary)
    var
        BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line";
    begin
        CurrPage.SETSELECTIONFILTER(BankAccReconciliationLine);
        IF BankAccReconciliationLine.FINDSET THEN
            REPEAT
                TempBankAccReconciliationLine := BankAccReconciliationLine;
                TempBankAccReconciliationLine.INSERT;
            UNTIL BankAccReconciliationLine.NEXT = 0;
    end;

    local procedure SetUserInteractions()
    begin
        StyleTxt := GetStyle;
        ApplyEntriesAllowed := Type = Type::"Check Ledger Entry";
    end;

    procedure ToggleMatchedFilter(SetFilterOn: Boolean)
    begin
        IF SetFilterOn THEN
            SETFILTER(Difference, '<>%1', 0)
        ELSE
            RESET;
        CurrPage.UPDATE;
    end;
}
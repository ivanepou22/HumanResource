page 50036 "Employee Loan Subform"
{
    Caption = 'Lines';
    PageType = ListPart;
    SourceTable = "Loan and Advance Lines";
    SourceTableView = WHERE("Document Type" = CONST(Loan));
    DelayedInsert = true;
    MultipleNewLines = true;
    AutoSplitKey = true;
    LinksAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {

                Field(Period; Period)
                {
                    ApplicationArea = All;
                }
                Field(Created; Created)
                {
                    ApplicationArea = All;
                }
                Field(Interest; Interest)
                {
                    ApplicationArea = All;
                }
                Field(Repayment; Repayment)
                {
                    ApplicationArea = All;
                }
                Field("Remaining Debt"; "Remaining Debt")
                {
                    ApplicationArea = All;
                }
                Field(Posted; Posted)
                {
                    ApplicationArea = All;
                }
                Field("Transfered To Payroll"; "Transfered To Payroll")
                {
                    ApplicationArea = All;
                }
                Field("Interest Cleared"; "Interest Cleared")
                {
                    ApplicationArea = All;
                }
                Field("Loan Cleared"; "Loan Cleared")
                {
                    ApplicationArea = All;
                }
                Field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                Field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
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

                trigger OnAction();
                begin

                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin
        //ShowShortcutDimCode(ShortcutDimCode);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        myInt: Integer;
    begin

        //InitType;
        CLEAR(ShortcutDimCode);
    end;

    trigger OnDeleteRecord(): Boolean
    var
        myInt: Integer;
    begin

    end;

    //==================Functions========
    procedure ApproveCalcInvDisc()
    var
        myInt: Integer;
    begin
        CODEUNIT.RUN(CODEUNIT::"Sales-Disc. (Yes/No)", Rec);
    end;

    procedure CalcInvDisc()
    var
        myInt: Integer;
    begin

        CODEUNIT.RUN(CODEUNIT::"Sales-Calc. Discount", Rec);
    end;

    procedure ExplodeBOM()
    var
        myInt: Integer;
    begin

        // IF "Prepmt. Amt. Inv." <> 0 THEN
        //             ERROR(Text001);
        //         CODEUNIT.RUN(CODEUNIT::"Sales-Explode BOM", Rec);
    end;

    var
        ShortcutDimCode: array[8] of Code[20];

        SalesHeader: Record "Loan and Advance Header";
        TransferExtendedText: Codeunit "Transfer Extended Text";
        ItemAvailFormsMgt: Codeunit "Item Availability Forms Mgt";
        ItemPanelVisible: Boolean;
}
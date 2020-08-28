page 50042 "Employee Loan SelfService"
{
    PageType = Card;
    SourceTable = "Loan and Advance Header";
    Caption = 'Employee Loan';
    SourceTableView = WHERE("Document Type" = CONST(Loan));

    layout
    {
        area(Content)
        {
            group(General)
            {

                Field("No."; "No.")
                {
                    ApplicationArea = All;
                    Editable = false;

                    trigger OnAssistEdit()
                    var
                        myInt: Integer;
                    begin
                        if AssistEdit(xRec) then
                            CurrPage.Update();
                    end;
                }
                Field("Employee No."; "Employee No.")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                Field("Employee Name"; "Employee Name")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                Field("Basic Salary"; "Basic Salary")
                {
                    ApplicationArea = All;
                }
                Field("Interest Rate"; "Interest Rate")
                {
                    ApplicationArea = All;
                }
                Field(Currency; Currency)
                {
                    ApplicationArea = All;
                }
                Field("Loan Type"; "Loan Type")
                {
                    ApplicationArea = All;
                }
                Field(Principal; Principal)
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                Field("Principal (LCY)"; "Principal (LCY)")
                {
                    ApplicationArea = All;
                }
                Field("Creation Date"; "Creation Date")
                {
                    ApplicationArea = All;
                }
                Field("Start Period Date"; "Start Period Date")
                {
                    ApplicationArea = All;
                }
                Field("Start Period"; "Start Period")
                {
                    ApplicationArea = All;
                }
                Field(Installments; Installments)
                {
                    ApplicationArea = All;
                }
                Field("Installment Amount"; "Installment Amount")
                {
                    ApplicationArea = All;
                }
                Field("Installment Amount (LCY)"; "Installment Amount (LCY)")
                {
                    ApplicationArea = All;
                }
                Field("Issuing Bank Account"; "Issuing Bank Account")
                {
                    ApplicationArea = All;
                }
                Field("External Document No."; "External Document No.")
                {
                    ApplicationArea = All;
                }
                Field("Paid To Employee"; "Paid To Employee")
                {
                    ApplicationArea = All;
                }
                Field("Repaid Amount"; "Repaid Amount")
                {
                    ApplicationArea = All;
                }
                Field("Remaining Loan / Advance Debt"; "Remaining Loan / Advance Debt")
                {
                    ApplicationArea = All;
                }
                Field("Total Interest"; "Total Interest")
                {
                    ApplicationArea = All;
                }
                Field("Total Interest (LCY)"; "Total Interest (LCY)")
                {
                    ApplicationArea = All;
                }
                Field("Interest Paid"; "Interest Paid")
                {
                    ApplicationArea = All;
                }
                Field("Interest Paid (LCY)"; "Interest Paid (LCY)")
                {
                    ApplicationArea = All;
                }
                Field("Remaining Interest Debt"; "Remaining Interest Debt")
                {
                    ApplicationArea = All;
                }
                Field("Suspension Duration"; "Suspension Duration")
                {
                    ApplicationArea = All;
                }
                Field("Last Suspension Date"; "Last Suspension Date")
                {
                    ApplicationArea = All;
                }
                Field("Last Suspension Duration"; "Last Suspension Duration")
                {
                    ApplicationArea = All;
                }
                Field(Posted; Posted)
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
                Field(ShortcutDime3; ShortcutDimCode[3])
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    var
                        myInt: Integer;
                    begin
                        ValidateShortcutDimensionCode(3, ShortcutDimCode[3]);
                    end;

                    trigger OnLookup(VAR Text: Text): Boolean
                    var
                        myInt: Integer;
                    begin
                        LookupShortcutDimCode(3, ShortcutDimCode[3]);
                    end;
                }
                Field(ShortcutDime4; ShortcutDimCode[4])
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    var
                        myInt: Integer;
                    begin
                        ValidateShortcutDimensionCode(4, ShortcutDimCode[4]);
                    end;

                    trigger OnLookup(VAR Text: Text): Boolean
                    var
                        myInt: Integer;
                    begin
                        LookupShortcutDimCode(4, ShortcutDimCode[4]);
                    end;
                }
                Field(ShortcutDime5; ShortcutDimCode[5])
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    var
                        myInt: Integer;
                    begin
                        ValidateShortcutDimensionCode(5, ShortcutDimCode[5]);
                    end;

                    trigger OnLookup(VAR Text: Text): Boolean
                    var
                        myInt: Integer;
                    begin
                        LookupShortcutDimCode(5, ShortcutDimCode[5]);
                    end;
                }
                Field(ShortcutDime6; ShortcutDimCode[6])
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    var
                        myInt: Integer;
                    begin
                        ValidateShortcutDimensionCode(6, ShortcutDimCode[6]);
                    end;

                    trigger OnLookup(VAR Text: Text): Boolean
                    var
                        myInt: Integer;
                    begin
                        LookupShortcutDimCode(6, ShortcutDimCode[6]);
                    end;
                }
                Field(ShortcutDime7; ShortcutDimCode[7])
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    var
                        myInt: Integer;
                    begin
                        ValidateShortcutDimensionCode(7, ShortcutDimCode[7]);
                    end;

                    trigger OnLookup(VAR Text: Text): Boolean
                    var
                        myInt: Integer;
                    begin
                        LookupShortcutDimCode(7, ShortcutDimCode[7]);
                    end;
                }
                Field(ShortcutDime8; ShortcutDimCode[8])
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    var
                        myInt: Integer;
                    begin
                        ValidateShortcutDimensionCode(8, ShortcutDimCode[8]);
                    end;

                    trigger OnLookup(VAR Text: Text): Boolean
                    var
                        myInt: Integer;
                    begin
                        LookupShortcutDimCode(8, ShortcutDimCode[8]);
                    end;
                }
            }
            part(LoanLines; "Employee Loan Subform")
            {
                ApplicationArea = suite, basic;
                SubPageLink = "Document Type" = FIELD("Document Type"), "Document No." = FIELD("No.");
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
        EmployeeDimension: Record "Employee Comment Line";
        ShortcutDimCode: array[8] of Code[20];
        ASLT0003: label 'Are you sure you want to change loan?';
        ShortcutDim1: Code[20];
        ShortcutDim2: Code[20];
        ShortcutDim3: Code[20];
        ShortcutDim4: Code[20];
        ShortcutDim5: Code[20];
        ShortcutDim6: Code[20];
        ShortcutDim7: Code[20];
        ShortcutDim8: Code[20];
}
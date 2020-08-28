pageextension 50021 "Employee List Ext" extends "Employee List"
{
    layout
    {
        // Add changes to page layout here
        addafter("Job Title")
        {
            field("Basic Salary"; "Basic Salary")
            {
                ApplicationArea = All;
            }

        }
    }

    actions
    {
        // Add changes to page actions here
        addafter(PayEmployee)
        {
            action("Import Earnings")
            {
                ApplicationArea = All;
                Caption = 'Import Earnings';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = ImportExcel;
                RunObject = xmlport "Import Earnings";
                trigger OnAction()
                begin

                end;
            }
            action("Import Deductions")
            {
                ApplicationArea = All;
                Caption = 'Import Deductions';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = ImportExport;
                //RunObject = xmlport "Import Deductions";
                trigger OnAction()
                begin
                    Xmlport.Run(50001, true, true);
                end;
            }

            action("Export Deductions")
            {
                ApplicationArea = All;
                Caption = 'Export Deductions';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = ImportExport;
                //RunObject = xmlport "Import Deductions";
                trigger OnAction()
                var

                begin
                    Xmlport.Run(50001, true, false);
                end;
            }
            action("Fix Dimensions")
            {
                ApplicationArea = All;
                Caption = 'Fix Dimensions';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = FixedAssetLedger;
                trigger OnAction()
                var
                    Customize: Codeunit "Customize Events";
                begin
                    Customize.Updatedimenions();
                end;
            }
        }
    }

    var
        myInt: Integer;
}
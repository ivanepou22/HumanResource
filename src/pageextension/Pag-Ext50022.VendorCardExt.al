pageextension 50022 "Vendor Card Ext" extends "Vendor Card"
{

    layout
    {
        // Add changes to page layout here
        addafter("Vendor Posting Group")
        {
            field("Vendor Type"; "Vendor Type")
            {
                ApplicationArea = All;
                Importance = Promoted;
            }
        }
        modify("Our Account No.")
        {
            Visible = false;
        }
        addafter("Balance Due (LCY)")
        {
            field("TIN Mandatory"; "TIN Mandatory")
            {
                ApplicationArea = All;
            }

        }
        addafter("Our Account No.")
        {
            field("Bank Code"; "Bank Code")
            {
                ApplicationArea = All;
                //FieldPropertyName = FieldPropertyValue;
            }
            field("Bank Name"; "Bank Name")
            {
                ApplicationArea = All;
            }
            field("Bank Account No."; "Bank Account No.")
            {
                ApplicationArea = All;
            }
            field("Mobile Money Number"; "Mobile Money Number")
            {
                ApplicationArea = All;
            }
        }

        addfirst(Invoicing)
        {
            field("VAT Registration Nos."; "VAT Registration Nos.")
            {
                ApplicationArea = VAT;
                ToolTip = 'Specifies the vendor''s VAT registration number.';
                Visible = false;

                trigger OnDrillDown()
                var
                    VATRegistrationLogMgt: Codeunit "VAT Registration Log Mgt.";
                begin
                    VATRegistrationLogMgt.AssistEditVendorVATReg(Rec);
                end;
            }
        }
        // modify("VAT Registration No.")
        // {
        //     Visible = false;
        // }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;

}
tableextension 50022 "VendorExt" extends Vendor
{

    fields
    {
        // Add changes to table fields here
        field(50001; "Bank Name"; Text[100]) { }
        field(50002; "Name Of Beneficiary"; Text[100]) { }
        field(50003; "Bank Account No."; Text[30]) { }
        field(50004; "Bank Code"; Text[30]) { }
        field(50005; "Mobile Money Number"; Text[30])
        {
            ExtendedDatatype = PhoneNo;
        }
        field(50010; "Booking No."; Code[30]) { }
        field(50020; "Vendor Type"; Option)
        {
            OptionMembers = " ",DOMESTIC,FOREIGN;
        }

        field(50025; "VAT Registration Nos."; Text[20])
        {
            Caption = 'VAT Registration No.';
            NotBlank = true;
            trigger OnValidate()
            begin
                "VAT Registration No." := UpperCase("VAT Registration Nos.");
            end;
        }
    }

    var
        myInt: Integer;


    trigger OnModify()
    var
        myInt: Integer;
    begin

    end;
}
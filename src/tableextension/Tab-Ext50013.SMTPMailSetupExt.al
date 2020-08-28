tableextension 50013 "SMTP Mail Setup Ext" extends "SMTP Mail Setup"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "SMTP Name"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;
}
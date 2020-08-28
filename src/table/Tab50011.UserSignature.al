table 50011 "User Signature"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "User Id"; Code[30])
        {
            Editable = false;

        }
        field(2; "User Name"; Code[50])
        {
            Editable = false;
        }

        field(3; Signature; Blob)
        {
            Subtype = Bitmap;
        }
    }

    keys
    {
        key(PK; "User Id")
        {
            Clustered = true;
        }
    }

    var
        User: Record User;

    trigger OnInsert()
    begin
        "User Id" := UserId;
        User.Reset();
        User.SetRange(User."User Name", UserId);
        if User.FindFirst() then
            "User Name" := User."Full Name"
    end;

    trigger OnModify()
    begin
        if "User Id" <> UserId then
            Error('Your Not Allowed To Change This Signature');
    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}
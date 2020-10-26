tableextension 50061 "SalesCrMemoLineExt" extends "Sales Cr.Memo Line"
{
    fields
    {
        // Add changes to table fields here
        field(50100; "Resource No."; Code[50])
        {
            TableRelation = Resource."No." WHERE(Type = FILTER(Person));
        }
    }

    var
        myInt: Integer;
}
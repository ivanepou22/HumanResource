query 50000 "Commitments Encumberances"
{
    QueryType = Normal;

    elements
    {
        dataitem(PurchaseLine; "Purchase Line")
        {
            column(DocumentType; "Document Type")
            {

            }
            // filter(FilterName; SourceFieldName)
            // {

            // }
        }
    }

    var
        myInt: Integer;

    trigger OnBeforeOpen()
    begin

    end;
}
query 50001 "GL Budget Amount22"
{
    QueryType = Normal;

    elements
    {
        dataitem(DataItemName; "G/L Budget Entry")
        {
            column(ColumnName; "G/L Account No.")
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
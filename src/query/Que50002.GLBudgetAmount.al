query 50002 "GL Budget Amount"
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
xmlport 50000 "Import Earnings"
{
    Format = VariableText;
    // FieldDelimiter = '<">';
    // FieldSeparator = '<,>';
    schema
    {
        textelement(Root)
        {
            tableelement(EarningDeduction; "Earning And Dedcution")
            {
                fieldattribute(EmployeeNo; EarningDeduction."Employee No.") { }
                fieldattribute(EmployeeName; EarningDeduction."Employee Name") { }
                fieldattribute(EarningCode; EarningDeduction."Confidential Code") { }
                fieldattribute(Description; EarningDeduction.Description) { }
                fieldattribute(FixedAmount; EarningDeduction."Fixed Amount") { }

                trigger OnBeforeModifyRecord()
                begin
                    LineNo += 1230;
                    EarningDeduction."Line No." := LineNo;
                    EarningDeduction.Type := EarningDeduction.Type::Earning;
                end;
            }
        }
    }

    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                    // field(Name; SourceExpression)
                    // {

                    // }
                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {

                }
            }
        }
    }

    var
        LineNo: Integer;
}
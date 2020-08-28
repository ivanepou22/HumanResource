xmlport 50002 "Import Bank Acc. Stmnt Lines"
{
    Format = VariableText;
    schema
    {
        textelement(Root)
        {
            tableelement(BankAccountStatementLine; "Bank Acc. Reconciliation Line")
            {
                //Set the following| Transaction Type (Type) => Set Difference, Statement Line No.
                fieldattribute(BankAccountNo; BankAccountStatementLine."Bank Account No.") { }
                fieldattribute(StatementNo; BankAccountStatementLine."Statement No.") { }
                fieldattribute(StatementLineNo; BankAccountStatementLine."Statement Line No.") { }
                fieldattribute(DocumentNo; BankAccountStatementLine."Document No.") { }
                fieldattribute(TransactionDate; BankAccountStatementLine."Transaction Date") { }
                fieldattribute(Description; BankAccountStatementLine.Description) { }
                fieldattribute(StatementAmount; BankAccountStatementLine."Statement Amount") { }

                trigger OnBeforeModifyRecord()
                begin
                    // StatementLineNo += 10000;
                    // BankAccountStatementLine."Statement Line No." := StatementLineNo;
                    BankAccountStatementLine.Difference := BankAccountStatementLine."Statement Amount";
                    BankAccountStatementLine.Type := BankAccountStatementLine.Type::"Bank Account Ledger Entry";
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
        StatementLineNo: Integer;
}
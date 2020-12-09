report 50037 "Payroll Summary Before Post"
{
    UsageCategory = Administration;
    Caption = 'Payroll Summary Before Post';
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'PayrollSummaryBeforePost.rdl';
    dataset
    {
        dataitem("Employee Statistics Group"; "Employee Statistics Group")
        {
            trigger OnPreDataItem()
            begin
                I := 1;
                PayrollGroup.RESET;
                PayrollGroup.SETRANGE(PayrollGroup."Payroll Processing Frequency", PayrollGroup."Payroll Processing Frequency"::Monthly);
                PayrollGroup.SETRANGE(PayrollGroup."Basic Pay Type", PayrollGroup."Basic Pay Type"::Fixed);
                IF PayrollGroup.FINDFIRST THEN
                    REPEAT
                        PayrollGroupCode[I] := PayrollGroup.Code;
                        I += 1;
                    UNTIL PayrollGroup.NEXT = 0;
            end;
        }

        dataitem(EmployeeStatisticsGroup; Integer)
        {
            Column(PayrollGroupCode1; PayrollGroupCode[1]) { }
            Column(PayrollGroupCode2; PayrollGroupCode[2]) { }
            Column(PayrollGroupCode3; PayrollGroupCode[3]) { }
            Column(PayrollGroupCode4; PayrollGroupCode[4]) { }
            Column(PayrollGroupCode5; PayrollGroupCode[5]) { }
            Column(PayrollGroupCode6; PayrollGroupCode[6]) { }
            Column(PayrollGroupCode7; PayrollGroupCode[7]) { }
            Column(PayrollGroupCode8; PayrollGroupCode[8]) { }
            Column(PayrollGroupCode9; PayrollGroupCode[9]) { }
            Column(PayrollGroupCode10; PayrollGroupCode[10]) { }
            Column(CompanyInfo_Name; CompanyInfo.Name) { }
            Column(CompanyInfo_Address; CompanyInfo.Address) { }
            Column(CompanyInfo_Address_2; CompanyInfo."Address 2") { }
            Column(CompanyInfo_City; CompanyInfo.City) { }
            Column(CompanyInfo_Post_Code; CompanyInfo."Post Code") { }
            Column(CompanyInfo_Phone_No_; CompanyInfo."Phone No.") { }
            Column(CompanyInfo_Fax_No_; CompanyInfo."Fax No.") { }
            Column(CompanyInfo_Home_Page; CompanyInfo."Home Page") { }
            Column(CompanyInfo_E_Mail; CompanyInfo."E-Mail") { }
            Column(CompanyInfo_Picture; CompanyInfo.Picture) { }
            Column(PayrollPeriod; PayrollPeriod) { }

            trigger OnPreDataItem()
            begin
                EmployeeStatisticsGroup.SETRANGE(Number, 1, 1);
            end;
        }

        dataitem(Confidential; Confidential)
        {
            Column(Code_Confidential; Confidential.Code) { }
            Column(Description_Confidential; Confidential.Description) { }
            Column(ParentCode2_Confidential; Confidential."Parent Code2") { }
            Column(ParentDescription; ParentDescription) { }
            Column(TotalAmounts; TotalAmounts) { }
            Column(TotalBasicAmounts; TotalBasicAmounts) { }
            Column(GroupAmount1; GroupAmount[1]) { }
            Column(GroupAmount2; GroupAmount[2]) { }
            Column(GroupAmount3; GroupAmount[3]) { }
            Column(GroupAmount4; GroupAmount[4]) { }
            Column(GroupAmount5; GroupAmount[5]) { }
            Column(GroupAmount6; GroupAmount[6]) { }
            Column(GroupAmount7; GroupAmount[7]) { }
            Column(GroupAmount8; GroupAmount[8]) { }
            Column(GroupAmount9; GroupAmount[9]) { }
            Column(GroupAmount10; GroupAmount[10]) { }

            Column(BasicSalaryAmount1; BasicSalaryAmount[1]) { }
            Column(BasicSalaryAmount2; BasicSalaryAmount[2]) { }
            Column(BasicSalaryAmount3; BasicSalaryAmount[3]) { }
            Column(BasicSalaryAmount4; BasicSalaryAmount[4]) { }
            Column(BasicSalaryAmount5; BasicSalaryAmount[5]) { }
            Column(BasicSalaryAmount6; BasicSalaryAmount[6]) { }
            Column(BasicSalaryAmount7; BasicSalaryAmount[7]) { }
            Column(BasicSalaryAmount8; BasicSalaryAmount[8]) { }
            Column(BasicSalaryAmount9; BasicSalaryAmount[9]) { }
            Column(BasicSalaryAmount10; BasicSalaryAmount[10]) { }

            //OnPreDataItem
            trigger OnPreDataItem()
            begin
                Confidential.SETFILTER("Parent Code2", '<>%1', '');
                Confidential.SETFILTER(Confidential.Type, '%1|%2', Confidential.Type::Earning, Confidential.Type::"Pay Basic");
                Confidential.SetFilter(Confidential.Taxable, '%1', true);
            end;

            //OnAfterGetRecord
            trigger OnAfterGetRecord()
            begin

                Confident.RESET;
                Confident.SETRANGE(Confident.Code, Confidential."Parent Code2");
                IF Confident.FINDFIRST THEN
                    ParentDescription := Confident.Description;

                //Totalamounts
                TotalAmounts := 0;
                ResLedgerEntry.RESET;
                ResLedgerEntry.SETFILTER(ResLedgerEntry."Payroll Entry Type", '%1|%2', ResLedgerEntry."Payroll Entry Type"::"Basic Pay", ResLedgerEntry."Payroll Entry Type"::Earning);
                ResLedgerEntry.SETRANGE(ResLedgerEntry."ED Code", Confidential.Code);
                ResLedgerEntry.SETRANGE(ResLedgerEntry."Posting Date", PayrollPeriod);
                IF ResLedgerEntry.FINDFIRST THEN
                    REPEAT
                        TotalAmounts += ResLedgerEntry.Amount;
                    UNTIL ResLedgerEntry.NEXT = 0;

                //Total Basic Amounts
                TotalBasicAmounts := 0;
                ResLedgerEntry3.RESET;
                ResLedgerEntry3.SETRANGE(ResLedgerEntry3."Payroll Entry Type", ResLedgerEntry3."Payroll Entry Type"::"Basic Pay");
                ResLedgerEntry3.SETRANGE(ResLedgerEntry3."ED Code", Confidential.Code);
                ResLedgerEntry3.SETRANGE(ResLedgerEntry3."Posting Date", PayrollPeriod);
                IF ResLedgerEntry3.FINDFIRST THEN
                    REPEAT
                        TotalBasicAmounts += ResLedgerEntry3.Amount;
                    UNTIL ResLedgerEntry3.NEXT = 0;



                //Getting the amounts
                J := 1;
                PayrollGroup.RESET;
                PayrollGroup.SETRANGE(PayrollGroup."Payroll Processing Frequency", PayrollGroup."Payroll Processing Frequency"::Monthly);
                PayrollGroup.SETRANGE(PayrollGroup."Basic Pay Type", PayrollGroup."Basic Pay Type"::Fixed);
                IF PayrollGroup.FINDFIRST THEN
                    REPEAT
                        GroupAmount[J] := 0;
                        ResLedgerEntry1.RESET;
                        ResLedgerEntry1.SETFILTER(ResLedgerEntry1."Payroll Entry Type", '%1|%2', ResLedgerEntry1."Payroll Entry Type"::"Basic Pay", ResLedgerEntry1."Payroll Entry Type"::Earning);
                        ResLedgerEntry1.SETRANGE(ResLedgerEntry1."ED Code", Confidential.Code);
                        ResLedgerEntry1.SETRANGE(ResLedgerEntry1."Employee Statistics Group", PayrollGroup.Code);
                        ResLedgerEntry1.SETRANGE(ResLedgerEntry1."Posting Date", PayrollPeriod);
                        IF ResLedgerEntry1.FINDFIRST THEN
                            REPEAT
                                GroupAmount[J] += ResLedgerEntry1.Amount;
                            UNTIL ResLedgerEntry1.NEXT = 0;
                        J += 1;
                    UNTIL PayrollGroup.NEXT = 0;
                //Getting the basic Salary
            end;

        }

        dataitem(NonTaxable; Confidential)
        {
            Column(Code_NonTaxable; NonTaxable.Code) { }
            Column(Description_NonTaxable; NonTaxable.Description) { }
            Column(ParentCode2_NonTaxable; NonTaxable."Parent Code2") { }
            Column(NontaxableAmountTotal; NontaxableAmountTotal) { }
            Column(NontaxableAmount1; NontaxableAmount[1]) { }
            Column(NontaxableAmount2; NontaxableAmount[2]) { }
            Column(NontaxableAmount3; NontaxableAmount[3]) { }
            Column(NontaxableAmount4; NontaxableAmount[4]) { }
            Column(NontaxableAmount5; NontaxableAmount[5]) { }
            Column(NontaxableAmount6; NontaxableAmount[6]) { }
            Column(NontaxableAmount7; NontaxableAmount[7]) { }
            Column(NontaxableAmount8; NontaxableAmount[8]) { }
            Column(NontaxableAmount9; NontaxableAmount[9]) { }
            Column(NontaxableAmount10; NontaxableAmount[10]) { }

            //OnPreDataItem
            trigger OnPreDataItem()
            begin
                NonTaxable.SETFILTER("Parent Code2", '<>%1', '');
                NonTaxable.SETFILTER(NonTaxable.Type, '%1', NonTaxable.Type::Earning);
                NonTaxable.SetFilter(NonTaxable.Taxable, '%1', false);
            end;

            trigger OnAfterGetRecord()
            var
                myInt: Integer;
            begin
                //geting the nontaxable pay
                P := 1;
                PayrollGroup2.RESET;
                PayrollGroup2.SETRANGE(PayrollGroup2."Payroll Processing Frequency", PayrollGroup2."Payroll Processing Frequency"::Monthly);
                PayrollGroup2.SETRANGE(PayrollGroup2."Basic Pay Type", PayrollGroup2."Basic Pay Type"::Fixed);
                IF PayrollGroup2.FINDFIRST THEN
                    REPEAT
                        NontaxableAmount[P] := 0;
                        ResLedgerEntry4.RESET;
                        ResLedgerEntry4.SETRANGE(ResLedgerEntry4."Payroll Entry Type", ResLedgerEntry4."Payroll Entry Type"::Earning);
                        ResLedgerEntry4.SETRANGE(ResLedgerEntry4."ED Code", NonTaxable.Code);
                        ResLedgerEntry4.SETRANGE(ResLedgerEntry4."Employee Statistics Group", PayrollGroup2.Code);
                        ResLedgerEntry4.SETRANGE(ResLedgerEntry4."Taxable/Pre-Tax Deductible", FALSE);
                        ResLedgerEntry4.SETRANGE(ResLedgerEntry4."Posting Date", PayrollPeriod);
                        IF ResLedgerEntry4.FINDFIRST THEN
                            REPEAT
                                NontaxableAmount[P] += ResLedgerEntry4.Amount;
                            UNTIL ResLedgerEntry4.NEXT = 0;
                        P += 1;
                    UNTIL PayrollGroup2.NEXT = 0;

                //nontaxable pay total
                ResLedgerEntry5.RESET;
                ResLedgerEntry5.SETRANGE(ResLedgerEntry5."Payroll Entry Type", ResLedgerEntry5."Payroll Entry Type"::Earning);
                ResLedgerEntry5.SETRANGE(ResLedgerEntry5."ED Code", NonTaxable.Code);
                ResLedgerEntry5.SETRANGE(ResLedgerEntry5."Taxable/Pre-Tax Deductible", FALSE);
                ResLedgerEntry5.SETRANGE(ResLedgerEntry5."Posting Date", PayrollPeriod);
                IF ResLedgerEntry5.FINDFIRST THEN
                    REPEAT
                        NontaxableAmountTotal += ResLedgerEntry5.Amount;
                    UNTIL ResLedgerEntry5.NEXT = 0;
            end;
        }
        dataitem(DeductionsGroup; Confidential)
        {
            Column(Code_DeductionsGroup; DeductionsGroup.Code) { }
            Column(Description_DeductionsGroup; DeductionsGroup.Description) { }
            Column(Type_DeductionsGroup; DeductionsGroup.Type) { }
            Column(DeductionAmount1; DeductionAmount[1]) { }
            Column(DeductionAmount2; DeductionAmount[2]) { }
            Column(DeductionAmount3; DeductionAmount[3]) { }
            Column(DeductionAmount4; DeductionAmount[4]) { }
            Column(DeductionAmount5; DeductionAmount[5]) { }
            Column(DeductionAmount6; DeductionAmount[6]) { }
            Column(DeductionAmount7; DeductionAmount[7]) { }
            Column(DeductionAmount8; DeductionAmount[8]) { }
            Column(DeductionAmount9; DeductionAmount[9]) { }
            Column(DeductionAmount10; DeductionAmount[10]) { }
            Column(DeductionTotalAmount; DeductionTotalAmount) { }

            //OnPreDataItem
            trigger OnPreDataItem()
            begin
                DeductionsGroup.SETFILTER(Type, '%1|%2', DeductionsGroup.Type::"Range Table", DeductionsGroup.Type::Deduction);
            end;

            //OnAfterGetRecord
            trigger OnAfterGetRecord()
            begin
                D := 1;
                PayrollGroup5.RESET;
                PayrollGroup5.SETRANGE(PayrollGroup5."Payroll Processing Frequency", PayrollGroup5."Payroll Processing Frequency"::Monthly);
                PayrollGroup5.SETRANGE(PayrollGroup5."Basic Pay Type", PayrollGroup5."Basic Pay Type"::Fixed);
                IF PayrollGroup5.FINDFIRST THEN
                    REPEAT
                        DeductionAmount[D] := 0;
                        ResLedgerEntry7.RESET;
                        ResLedgerEntry7.SETFILTER(ResLedgerEntry7."Payroll Entry Type", '%1|%2|%3', ResLedgerEntry7."Payroll Entry Type"::"Income Tax", ResLedgerEntry7."Payroll Entry Type"::"Local Service Tax", ResLedgerEntry7."Payroll Entry Type"::Deduction);
                        ResLedgerEntry7.SETRANGE(ResLedgerEntry7."ED Code", DeductionsGroup.Code);
                        //ResLedgerEntry7.SetFilter(ResLedgerEntry7."ED Code", '<>%1|<>%2|<>%3|<>%4','ABSENT ADM','ABSENT DIS','ABSENT FAR','ABSENT PDN');
                        ResLedgerEntry7.SETRANGE(ResLedgerEntry7."Employee Statistics Group", PayrollGroup5.Code);
                        ResLedgerEntry7.SETRANGE(ResLedgerEntry7."Posting Date", PayrollPeriod);
                        IF ResLedgerEntry7.FINDFIRST THEN
                            REPEAT
                                DeductionAmount[D] += ResLedgerEntry7.Amount;
                            UNTIL ResLedgerEntry7.NEXT = 0;
                        D += 1;
                    UNTIL PayrollGroup5.NEXT = 0;

                //Total Deduction
                DeductionTotalAmount := 0;
                ResLedgerEntry8.RESET;
                ResLedgerEntry8.SETFILTER(ResLedgerEntry8."Payroll Entry Type", '%1|%2|%3', ResLedgerEntry8."Payroll Entry Type"::"Income Tax", ResLedgerEntry8."Payroll Entry Type"::"Local Service Tax", ResLedgerEntry8."Payroll Entry Type"::Deduction);
                ResLedgerEntry8.SETRANGE(ResLedgerEntry8."ED Code", DeductionsGroup.Code);
                ResLedgerEntry8.SETRANGE(ResLedgerEntry8."Posting Date", PayrollPeriod);
                IF ResLedgerEntry8.FINDFIRST THEN
                    REPEAT
                        DeductionTotalAmount += ResLedgerEntry8.Amount;
                    UNTIL ResLedgerEntry8.NEXT = 0;
            end;
        }

        dataitem(AbsentDeduction; Confidential)
        {
            Column(Code_AbsentDeduction; AbsentDeduction.Code) { }
            Column(Description_AbsentDeduction; AbsentDeduction.Description) { }
            Column(Type_AbsentDeduction; AbsentDeduction.Type) { }
            column(AbsentAmount1; AbsentAmount[1]) { }
            column(AbsentAmount2; AbsentAmount[2]) { }
            column(AbsentAmount3; AbsentAmount[3]) { }
            column(AbsentAmount4; AbsentAmount[4]) { }
            column(AbsentAmount5; AbsentAmount[5]) { }
            column(AbsentAmount6; AbsentAmount[6]) { }
            column(AbsentAmount7; AbsentAmount[7]) { }
            column(AbsentAmount8; AbsentAmount[8]) { }
            column(AbsentAmount9; AbsentAmount[9]) { }
            column(AbsentAmount10; AbsentAmount[10]) { }

            trigger OnPreDataItem()
            begin
                AbsentDeduction.SetFilter(AbsentDeduction.Type, '%1', AbsentDeduction.Type::Deduction);
                AbsentDeduction.SetFilter(AbsentDeduction.Code, '%1|%2|%3|%4', 'ABSENT ADM', 'ABSENT DIS', 'ABSENT FAR', 'ABSENT PDN');
            end;

            trigger OnAfterGetRecord()
            begin
                B := 1;
                PayrollGroup10.Reset();
                PayrollGroup10.SETRANGE(PayrollGroup10."Payroll Processing Frequency", PayrollGroup10."Payroll Processing Frequency"::Monthly);
                PayrollGroup10.SETRANGE(PayrollGroup10."Basic Pay Type", PayrollGroup10."Basic Pay Type"::Fixed);
                IF PayrollGroup10.FINDFIRST THEN
                    repeat
                        AbsentAmount[B] := 0;
                        ResLedgerEntry10.RESET;
                        ResLedgerEntry10.SETFILTER(ResLedgerEntry10."Payroll Entry Type", '%1', ResLedgerEntry10."Payroll Entry Type"::Deduction);
                        ResLedgerEntry10.SETRANGE(ResLedgerEntry10."ED Code", AbsentDeduction.Code);
                        ResLedgerEntry10.SETRANGE(ResLedgerEntry10."Employee Statistics Group", PayrollGroup10.Code);
                        ResLedgerEntry10.SETRANGE(ResLedgerEntry10."Posting Date", PayrollPeriod);
                        IF ResLedgerEntry10.FINDFIRST THEN
                            REPEAT
                                AbsentAmount[B] += ResLedgerEntry10.Amount;
                            UNTIL ResLedgerEntry10.NEXT = 0;
                        B += 1;
                    until PayrollGroup10.Next() = 0;

            end;
        }

        dataitem(BasicInteger; integer)
        {
            Column(BasicAmount1; BasicAmount[1]) { }
            Column(BasicAmount2; BasicAmount[2]) { }
            Column(BasicAmount3; BasicAmount[3]) { }
            Column(BasicAmount4; BasicAmount[4]) { }
            Column(BasicAmount5; BasicAmount[5]) { }
            Column(BasicAmount6; BasicAmount[6]) { }
            Column(BasicAmount7; BasicAmount[7]) { }

            trigger OnPreDataItem()
            begin
                BasicInteger.SETRANGE(Number, 1, 1);
            end;

            trigger OnAfterGetRecord()
            begin
                //basic group amount
                V := 1;
                PayrollGroup4.RESET;
                PayrollGroup4.SETRANGE(PayrollGroup4."Payroll Processing Frequency", PayrollGroup4."Payroll Processing Frequency"::Monthly);
                PayrollGroup4.SETRANGE(PayrollGroup4."Basic Pay Type", PayrollGroup4."Basic Pay Type"::Fixed);
                IF PayrollGroup4.FINDFIRST THEN
                    REPEAT
                        BasicAmount[V] := 0;
                        ResLedgerEntry6.RESET;
                        ResLedgerEntry6.SETRANGE(ResLedgerEntry6."Payroll Entry Type", ResLedgerEntry6."Payroll Entry Type"::"Basic Pay");
                        ResLedgerEntry6.SETRANGE(ResLedgerEntry6."Employee Statistics Group", PayrollGroup4.Code);
                        ResLedgerEntry6.SETRANGE(ResLedgerEntry6."Posting Date", PayrollPeriod);
                        IF ResLedgerEntry6.FINDFIRST THEN
                            REPEAT
                                BasicAmount[V] += ResLedgerEntry6.Amount;
                            UNTIL ResLedgerEntry6.NEXT = 0;
                        V += 1;
                    UNTIL PayrollGroup4.NEXT = 0;
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    field("Payroll Period"; PayrollPeriod)
                    {
                        ApplicationArea = All;
                        trigger OnLookup(VAR Text: Text): Boolean
                        var
                            ResLedgerEntry: Record "Payroll Journal Lines";
                            ResLedgerEntryForm: Page "Payroll Journal Lines";
                        begin
                            ResLedgerEntry.RESET;
                            ResLedgerEntry.SETRANGE("Entry Type Payroll", ResLedgerEntry."Entry Type Payroll"::"Payroll Period");
                            IF ResLedgerEntry.FINDFIRST THEN BEGIN
                                ResLedgerEntryForm.SETTABLEVIEW(ResLedgerEntry);
                                ResLedgerEntryForm.LOOKUPMODE := TRUE;
                                IF ResLedgerEntryForm.RUNMODAL = ACTION::LookupOK THEN BEGIN
                                    ResLedgerEntryForm.GETRECORD(ResLedgerEntry);
                                    PayrollPeriod := ResLedgerEntry."Posting Date";
                                END;
                            END;
                        end;
                    }
                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    trigger OnPreReport()
    var
        ASL001: Label 'You Must Specify the Payroll Period';
    begin
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);
        IF (PayrollPeriod = 0D) THEN
            ERROR(ASL001);
    end;

    var
        Confident: Record Confidential;
        ParentDescription: Text[100];
        TotalAmounts: Decimal;
        TotalBasicAmounts: Decimal;
        ResLedgerEntry: Record "Payroll Journal Lines";
        I: Integer;
        J: Integer;
        K: Integer;
        E: Integer;
        PayrollGroupCode: array[20] of Code[20];
        PayrollGroup: Record "Employee Statistics Group";
        GroupAmount: array[20] of Decimal;
        ResLedgerEntry1: Record "Payroll Journal Lines";
        BasicSalaryAmount: array[20] of Decimal;
        ResLedgerEntry2: Record "Payroll Journal Lines";
        PayrollGroup1: Record "Employee Statistics Group";
        ResLedgerEntry3: Record "Payroll Journal Lines";
        PayrollGroup2: Record "Employee Statistics Group";
        ResLedgerEntry4: Record "Payroll Journal Lines";
        NontaxableAmount: array[20] of Decimal;
        P: Integer;
        Confident1: Record Confidential;
        NontaxableAmountTotal: Decimal;
        Confident2: Record Confidential;
        ResLedgerEntry5: Record "Payroll Journal Lines";
        PayrollGroup3: Record "Employee Statistics Group";
        PayrollPeriod: Date;
        V: Integer;
        PayrollGroup4: Record "Employee Statistics Group";
        ResLedgerEntry6: Record "Payroll Journal Lines";
        BasicAmount: array[20] of Decimal;
        DeductionAmount: array[20] of Decimal;
        PayrollGroup5: Record "Employee Statistics Group";
        ResLedgerEntry7: Record "Payroll Journal Lines";
        D: Integer;
        ResLedgerEntry8: Record "Payroll Journal Lines";
        DeductionTotalAmount: Decimal;
        N: Integer;
        PayrollGroup6: Record "Employee Statistics Group";
        ResLedgerEntry9: Record "Payroll Journal Lines";
        PayeAmounts: array[20] of Decimal;
        CompanyInfo: Record "Company Information";

        //absentism
        AbsentAmount: array[20] of Decimal;
        PayrollGroup10: Record "Employee Statistics Group";
        ResLedgerEntry10: Record "Payroll Journal Lines";
        B: Integer;

}
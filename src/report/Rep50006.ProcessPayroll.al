report 50006 "Process Payroll"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'ProcessPayroll.rdlc';
    //=IIF(Fields!EarningInclude20.Value = TRUE, FALSE, TRUE)
    dataset
    {
        dataitem("Employee Statistics Group"; "Employee Statistics Group")
        {
            RequestFilterFields = Code;
            Column(PayrollMonthYear; PayrollMonthYear) { }
            column(EmployeeStatisticsGroup; "Employee Statistics Group".Code) { }
            Column(LocationFilter; LocationFilter) { }
            Column(CompanyInfo_Name; CompanyInfo.Name) { }
            Column(CompanyInfo_Address; CompanyInfo.Address) { }
            Column(CompanyInfo_Address_2; CompanyInfo."Address 2") { }
            Column(CompanyInfo_City; CompanyInfo.City) { }
            Column(CompanyInfo_Phone_No_; CompanyInfo."Phone No.") { }
            Column(CompanyInfo_E_Mail; CompanyInfo."E-Mail") { }
            Column(CompanyInfo_Home_Page; CompanyInfo."Home Page") { }
            Column(CompanyInfo_Picture; CompanyInfo.Picture) { }

            trigger OnPreDataItem()
            var
                myInt: Integer;
            begin
                HRSetup.GET;
                LineNo := 10000;
            end;

            trigger OnAfterGetRecord()
            var
                ResJnlPostLine: Codeunit "ResJnlPost Line";
            begin

                IF ProcessingOption = ProcessingOption::"Generate Payroll Journals" THEN BEGIN
                    "Employee Statistics Group".TESTFIELD("Payroll Journal Template Name");
                    "Employee Statistics Group".TESTFIELD("Payroll Journal Batch Name");
                    "Employee Statistics Group".TESTFIELD("Next Payroll Processing Date");
                    PostingDate := "Employee Statistics Group"."Next Payroll Processing Date";

                    DocumentNo := 'PYRL-' + FORMAT("Employee Statistics Group"."Next Payroll Processing Date");
                    IF GenJnlBatch.GET("Employee Statistics Group"."Payroll Journal Template Name",
                                       "Employee Statistics Group"."Payroll Journal Batch Name") THEN BEGIN
                        GenJnlLine.RESET;
                        GenJnlLine.SETRANGE(GenJnlLine."Journal Template Name", "Employee Statistics Group"."Payroll Journal Template Name");
                        GenJnlLine.SETRANGE(GenJnlLine."Journal Batch Name", "Employee Statistics Group"."Payroll Journal Batch Name");
                        IF GenJnlLine.FINDSET THEN
                            GenJnlLine.DELETEALL;
                    END ELSE
                        ERROR(STRSUBSTNO(ASLT0001, "Employee Statistics Group"."Payroll Journal Template Name",
                                                  "Employee Statistics Group"."Payroll Journal Batch Name"));

                    ResLedgerEntry.RESET;
                    ResLedgerEntry.SETRANGE(ResLedgerEntry."Entry Type Payroll", ResLedgerEntry."Entry Type Payroll"::"Payroll Period");
                    ResLedgerEntry.SETRANGE(ResLedgerEntry."Employee Statistics Group", "Employee Statistics Group".Code);
                    ResLedgerEntry.SETRANGE(ResLedgerEntry."Posting Date", PostingDate);
                    IF NOT ResLedgerEntry.FIND('-') THEN BEGIN
                        ResJnlPostLine.InsertPayrollPeriod(PostingDate, "Employee Statistics Group".Code, ResLedgerEntry);
                    END;
                END ELSE
                    IF ProcessingOption = ProcessingOption::"Generate Payment Journals" THEN BEGIN
                        "Employee Statistics Group".TESTFIELD("Payments Journal Template Name");
                        "Employee Statistics Group".TESTFIELD("Payments Journal Batch Name");
                        "Employee Statistics Group".TESTFIELD("Last Payroll Processing Date");
                        PostingDate := "Employee Statistics Group"."Last Payroll Processing Date";
                        DocumentNo := 'PYRL-' + FORMAT("Employee Statistics Group"."Last Payroll Processing Date");

                        //Clear All Banks Payment Journal Batches
                        EmployeeBank.RESET;
                        EmployeeBank.SETRANGE(EmployeeBank.Type, EmployeeBank.Type::"Employee Bank");
                        IF EmployeeBank.FINDSET THEN BEGIN
                            REPEAT
                                IF GenJnlBatch.GET(EmployeeBank."Payments Journal Template Name", EmployeeBank."Payments Journal Batch Name") THEN BEGIN
                                    GenJnlLine.RESET;
                                    GenJnlLine.SETRANGE(GenJnlLine."Journal Template Name", EmployeeBank."Payments Journal Template Name");
                                    GenJnlLine.SETRANGE(GenJnlLine."Journal Batch Name", EmployeeBank."Payments Journal Batch Name");
                                    IF GenJnlLine.FINDSET THEN
                                        GenJnlLine.DELETEALL;
                                END ELSE
                                    ERROR(STRSUBSTNO(ASLT0001, EmployeeBank."Payments Journal Template Name", EmployeeBank."Payments Journal Batch Name"));
                            UNTIL EmployeeBank.NEXT = 0;
                        END;

                        ResLedgerEntry.RESET;
                        ResLedgerEntry.SETRANGE(ResLedgerEntry."Entry Type Payroll", ResLedgerEntry."Entry Type Payroll"::"Payroll Period");
                        ResLedgerEntry.SETRANGE(ResLedgerEntry."Employee Statistics Group", "Employee Statistics Group".Code);
                        ResLedgerEntry.SETRANGE(ResLedgerEntry."Posting Date", PostingDate);
                        IF ResLedgerEntry.FIND('-') THEN BEGIN
                            IF NOT ResLedgerEntry."Period Closed" THEN
                                ERROR(ASLT0005);
                        END ELSE
                            ERROR(ASLT0005);
                    END ELSE
                        IF ProcessingOption = ProcessingOption::"Close Payroll Period" THEN BEGIN
                            PostingDate := "Employee Statistics Group"."Next Payroll Processing Date";
                            DocumentNo := 'PYRL-' + FORMAT("Employee Statistics Group"."Next Payroll Processing Date");
                            IF HRSetup."Integrate with Financials" THEN
                                CheckGlEntriesPosted();
                        END;

                PayrollMonth := DATE2DMY(PostingDate, 2);
                PayrollYear := DATE2DMY(PostingDate, 3);
                CASE PayrollMonth OF
                    1:
                        PayrollMonthName := 'JANUARY';
                    2:
                        PayrollMonthName := 'FEBRUARY';
                    3:
                        PayrollMonthName := 'MARCH';
                    4:
                        PayrollMonthName := 'APRIL';
                    5:
                        PayrollMonthName := 'MAY';
                    6:
                        PayrollMonthName := 'JUNE';
                    7:
                        PayrollMonthName := 'JULY';
                    8:
                        PayrollMonthName := 'AUGUST';
                    9:
                        PayrollMonthName := 'SEPTEMBER';
                    10:
                        PayrollMonthName := 'OCTOBER';
                    11:
                        PayrollMonthName := 'NOVEMBER';
                    12:
                        PayrollMonthName := 'DECEMBER';
                END;
                PayrollMonthYear := PayrollMonthName + ' ' + FORMAT(PayrollYear);
            end;


        }

        dataitem(Employee; Employee)
        {
            DataItemTableView = SORTING("No.") WHERE("Payroll Status" = CONST(Active));
            DataItemLinkReference = "Employee Statistics Group";
            dataItemLink = "Statistics Group Code" = FIELD(Code);
            RequestFilterFields = "No.", "Major Location";
            column(Num; Num) { }
            Column(No_Employee; Employee."No.") { }
            Column(FirstName_Employee; Employee."First Name") { }
            Column(MiddleName_Employee; Employee."Middle Name") { }
            Column(LastName_Employee; Employee."Last Name") { }
            Column(Initials_Employee; Employee.Initials) { }
            Column(JobTitle_Employee; Employee."Job Title") { }
            Column(EmployeeDonor; EmployeeDonor) { }
            Column(GlobalDimension1Code_Employee; Employee."Global Dimension 1 Code") { }
            Column(GlobalDimension1Filter_Employee; Employee."Global Dimension 1 Filter") { }
            Column(BasicSalary; BasicSalary) { }
            Column(TotalTaxableEarnings; TotalTaxableEarnings) { }
            Column(TotalEarnings; TotalEarnings) { }
            Column(TotalPreTaxDeductions; TotalPreTaxDeductions) { }
            Column(TotalTaxableAmount; TotalTaxableAmount) { }
            Column(SSFAmountEmployern; SSFAmountEmployer) { }
            Column(TotalDeductions; TotalDeductions) { }
            Column(IncomeTax; IncomeTax) { }
            Column(LocalTax; LocalTax) { }
            Column(NetPay; NetPay) { }
            Column(SSFAmount; SSFAmount) { }
            Column(BankName_Employee; Employee."Bank Name") { }
            Column(BankCode_Employee; Employee."Bank Code") { }
            Column(BankAccountNo_Employee; Employee."Bank Account No.") { }
            Column(StatisticsGroupCode_Employee; Employee."Statistics Group Code") { }
            Column(SocialSecurityNo_Employee; Employee."Social Security No.") { }
            Column(AccountTitle_Employee; Employee."Account Title") { }

            //DeductionCodeToShow
            Column(DeductionCodeToShow_1; DeductionCodeToShow[1]) { }
            Column(DeductionCodeToShow_2; DeductionCodeToShow[2]) { }
            Column(DeductionCodeToShow_3; DeductionCodeToShow[3]) { }
            Column(DeductionCodeToShow_4; DeductionCodeToShow[4]) { }
            Column(DeductionCodeToShow_5; DeductionCodeToShow[5]) { }
            Column(DeductionCodeToShow_6; DeductionCodeToShow[6]) { }
            Column(DeductionCodeToShow_7; DeductionCodeToShow[7]) { }
            Column(DeductionCodeToShow_8; DeductionCodeToShow[8]) { }
            Column(DeductionCodeToShow_9; DeductionCodeToShow[9]) { }
            Column(DeductionCodeToShow_10; DeductionCodeToShow[10]) { }
            Column(DeductionCodeToShow_11; DeductionCodeToShow[11]) { }
            Column(DeductionCodeToShow_12; DeductionCodeToShow[12]) { }
            Column(DeductionCodeToShow_13; DeductionCodeToShow[13]) { }
            Column(DeductionCodeToShow_14; DeductionCodeToShow[14]) { }
            Column(DeductionCodeToShow_15; DeductionCodeToShow[15]) { }
            Column(DeductionCodeToShow_16; DeductionCodeToShow[16]) { }
            Column(DeductionCodeToShow_17; DeductionCodeToShow[17]) { }
            Column(DeductionCodeToShow_18; DeductionCodeToShow[18]) { }
            Column(DeductionCodeToShow_19; DeductionCodeToShow[19]) { }
            Column(DeductionCodeToShow_20; DeductionCodeToShow[20]) { }
            Column(DeductionCodeToShow_21; DeductionCodeToShow[21]) { }
            Column(DeductionCodeToShow_22; DeductionCodeToShow[22]) { }
            Column(DeductionCodeToShow_23; DeductionCodeToShow[23]) { }
            Column(DeductionCodeToShow_24; DeductionCodeToShow[24]) { }
            Column(DeductionCodeToShow_25; DeductionCodeToShow[25]) { }
            Column(DeductionCodeToShow_26; DeductionCodeToShow[26]) { }
            Column(DeductionCodeToShow_27; DeductionCodeToShow[27]) { }
            Column(DeductionCodeToShow_28; DeductionCodeToShow[28]) { }
            Column(DeductionCodeToShow_29; DeductionCodeToShow[29]) { }
            Column(DeductionCodeToShow_30; DeductionCodeToShow[30]) { }
            Column(DeductionCodeToShow_31; DeductionCodeToShow[31]) { }
            Column(DeductionCodeToShow_32; DeductionCodeToShow[32]) { }
            Column(DeductionCodeToShow_33; DeductionCodeToShow[33]) { }
            Column(DeductionCodeToShow_34; DeductionCodeToShow[34]) { }
            Column(DeductionCodeToShow_35; DeductionCodeToShow[35]) { }
            Column(DeductionCodeToShow_36; DeductionCodeToShow[36]) { }
            Column(DeductionCodeToShow_37; DeductionCodeToShow[37]) { }
            Column(DeductionCodeToShow_38; DeductionCodeToShow[38]) { }
            Column(DeductionCodeToShow_39; DeductionCodeToShow[39]) { }
            Column(DeductionCodeToShow_40; DeductionCodeToShow[40]) { }

            //DeductionAmountToShow
            Column(DeductionAmountToShow_1; DeductionAmountToShow[1]) { }
            Column(DeductionAmountToShow_2; DeductionAmountToShow[2]) { }
            Column(DeductionAmountToShow_3; DeductionAmountToShow[3]) { }
            Column(DeductionAmountToShow_4; DeductionAmountToShow[4]) { }
            Column(DeductionAmountToShow_5; DeductionAmountToShow[5]) { }
            Column(DeductionAmountToShow_6; DeductionAmountToShow[6]) { }
            Column(DeductionAmountToShow_7; DeductionAmountToShow[7]) { }
            Column(DeductionAmountToShow_8; DeductionAmountToShow[8]) { }
            Column(DeductionAmountToShow_9; DeductionAmountToShow[9]) { }
            Column(DeductionAmountToShow_10; DeductionAmountToShow[10]) { }
            Column(DeductionAmountToShow_11; DeductionAmountToShow[11]) { }
            Column(DeductionAmountToShow_12; DeductionAmountToShow[12]) { }
            Column(DeductionAmountToShow_13; DeductionAmountToShow[13]) { }
            Column(DeductionAmountToShow_14; DeductionAmountToShow[14]) { }
            Column(DeductionAmountToShow_15; DeductionAmountToShow[15]) { }
            Column(DeductionAmountToShow_16; DeductionAmountToShow[16]) { }
            Column(DeductionAmountToShow_17; DeductionAmountToShow[17]) { }
            Column(DeductionAmountToShow_18; DeductionAmountToShow[18]) { }
            Column(DeductionAmountToShow_19; DeductionAmountToShow[19]) { }
            Column(DeductionAmountToShow_20; DeductionAmountToShow[20]) { }
            Column(DeductionAmountToShow_21; DeductionAmountToShow[21]) { }
            Column(DeductionAmountToShow_22; DeductionAmountToShow[22]) { }
            Column(DeductionAmountToShow_23; DeductionAmountToShow[23]) { }
            Column(DeductionAmountToShow_24; DeductionAmountToShow[24]) { }
            Column(DeductionAmountToShow_25; DeductionAmountToShow[25]) { }
            Column(DeductionAmountToShow_26; DeductionAmountToShow[26]) { }
            Column(DeductionAmountToShow_27; DeductionAmountToShow[27]) { }
            Column(DeductionAmountToShow_28; DeductionAmountToShow[28]) { }
            Column(DeductionAmountToShow_29; DeductionAmountToShow[29]) { }
            Column(DeductionAmountToShow_30; DeductionAmountToShow[30]) { }
            Column(DeductionAmountToShow_31; DeductionAmountToShow[31]) { }
            Column(DeductionAmountToShow_32; DeductionAmountToShow[32]) { }
            Column(DeductionAmountToShow_33; DeductionAmountToShow[33]) { }
            Column(DeductionAmountToShow_34; DeductionAmountToShow[34]) { }
            Column(DeductionAmountToShow_35; DeductionAmountToShow[35]) { }
            Column(DeductionAmountToShow_36; DeductionAmountToShow[36]) { }
            Column(DeductionAmountToShow_37; DeductionAmountToShow[37]) { }
            Column(DeductionAmountToShow_38; DeductionAmountToShow[38]) { }
            Column(DeductionAmountToShow_39; DeductionAmountToShow[39]) { }
            Column(DeductionAmountToShow_40; DeductionAmountToShow[40]) { }

            //DeductionInclude
            Column(DeductionInclude1; DeductionInclude[1]) { }
            Column(DeductionInclude2; DeductionInclude[2]) { }
            Column(DeductionInclude3; DeductionInclude[3]) { }
            Column(DeductionInclude4; DeductionInclude[4]) { }
            Column(DeductionInclude5; DeductionInclude[5]) { }
            Column(DeductionInclude6; DeductionInclude[6]) { }
            Column(DeductionInclude7; DeductionInclude[7]) { }
            Column(DeductionInclude8; DeductionInclude[8]) { }
            Column(DeductionInclude9; DeductionInclude[9]) { }
            Column(DeductionInclude10; DeductionInclude[10]) { }
            Column(DeductionInclude11; DeductionInclude[11]) { }
            Column(DeductionInclude12; DeductionInclude[12]) { }
            Column(DeductionInclude13; DeductionInclude[13]) { }
            Column(DeductionInclude14; DeductionInclude[14]) { }
            Column(DeductionInclude15; DeductionInclude[15]) { }
            Column(DeductionInclude16; DeductionInclude[16]) { }
            Column(DeductionInclude17; DeductionInclude[17]) { }
            Column(DeductionInclude18; DeductionInclude[18]) { }
            Column(DeductionInclude19; DeductionInclude[19]) { }
            Column(DeductionInclude20; DeductionInclude[20]) { }
            Column(DeductionInclude21; DeductionInclude[21]) { }
            Column(DeductionInclude22; DeductionInclude[22]) { }
            Column(DeductionInclude23; DeductionInclude[23]) { }
            Column(DeductionInclude24; DeductionInclude[24]) { }
            Column(DeductionInclude25; DeductionInclude[25]) { }
            Column(DeductionInclude26; DeductionInclude[26]) { }
            Column(DeductionInclude27; DeductionInclude[27]) { }
            Column(DeductionInclude28; DeductionInclude[28]) { }
            Column(DeductionInclude29; DeductionInclude[29]) { }
            Column(DeductionInclude30; DeductionInclude[30]) { }
            Column(DeductionInclude31; DeductionInclude[31]) { }
            Column(DeductionInclude32; DeductionInclude[32]) { }
            Column(DeductionInclude33; DeductionInclude[33]) { }
            Column(DeductionInclude34; DeductionInclude[34]) { }
            Column(DeductionInclude35; DeductionInclude[35]) { }
            Column(DeductionInclude36; DeductionInclude[36]) { }
            Column(DeductionInclude37; DeductionInclude[37]) { }
            Column(DeductionInclude38; DeductionInclude[38]) { }
            Column(DeductionInclude39; DeductionInclude[39]) { }
            Column(DeductionInclude40; DeductionInclude[40]) { }

            //EarningCodeToShow
            Column(EarningCodeToShow_1; EarningCodeToShow[1]) { }
            Column(EarningCodeToShow_2; EarningCodeToShow[2]) { }
            Column(EarningCodeToShow_3; EarningCodeToShow[3]) { }
            Column(EarningCodeToShow_4; EarningCodeToShow[4]) { }
            Column(EarningCodeToShow_5; EarningCodeToShow[5]) { }
            Column(EarningCodeToShow_6; EarningCodeToShow[6]) { }
            Column(EarningCodeToShow_7; EarningCodeToShow[7]) { }
            Column(EarningCodeToShow_8; EarningCodeToShow[8]) { }
            Column(EarningCodeToShow_9; EarningCodeToShow[9]) { }
            Column(EarningCodeToShow_10; EarningCodeToShow[10]) { }
            Column(EarningCodeToShow_11; EarningCodeToShow[11]) { }
            Column(EarningCodeToShow_12; EarningCodeToShow[12]) { }
            Column(EarningCodeToShow_13; EarningCodeToShow[13]) { }
            Column(EarningCodeToShow_14; EarningCodeToShow[14]) { }
            Column(EarningCodeToShow_15; EarningCodeToShow[15]) { }
            Column(EarningCodeToShow_16; EarningCodeToShow[16]) { }
            Column(EarningCodeToShow_17; EarningCodeToShow[17]) { }
            Column(EarningCodeToShow_18; EarningCodeToShow[18]) { }
            Column(EarningCodeToShow_19; EarningCodeToShow[19]) { }
            Column(EarningCodeToShow_20; EarningCodeToShow[20]) { }
            Column(EarningCodeToShow_21; EarningCodeToShow[21]) { }
            Column(EarningCodeToShow_22; EarningCodeToShow[22]) { }
            Column(EarningCodeToShow_23; EarningCodeToShow[23]) { }
            Column(EarningCodeToShow_24; EarningCodeToShow[24]) { }
            Column(EarningCodeToShow_25; EarningCodeToShow[25]) { }
            Column(EarningCodeToShow_26; EarningCodeToShow[26]) { }
            Column(EarningCodeToShow_27; EarningCodeToShow[27]) { }
            Column(EarningCodeToShow_28; EarningCodeToShow[28]) { }
            Column(EarningCodeToShow_29; EarningCodeToShow[29]) { }
            Column(EarningCodeToShow_30; EarningCodeToShow[30]) { }
            Column(EarningCodeToShow_31; EarningCodeToShow[31]) { }
            Column(EarningCodeToShow_32; EarningCodeToShow[32]) { }
            Column(EarningCodeToShow_33; EarningCodeToShow[33]) { }
            Column(EarningCodeToShow_34; EarningCodeToShow[34]) { }
            Column(EarningCodeToShow_35; EarningCodeToShow[35]) { }
            Column(EarningCodeToShow_36; EarningCodeToShow[36]) { }
            Column(EarningCodeToShow_37; EarningCodeToShow[37]) { }
            Column(EarningCodeToShow_38; EarningCodeToShow[38]) { }
            Column(EarningCodeToShow_39; EarningCodeToShow[39]) { }
            Column(EarningCodeToShow_40; EarningCodeToShow[40]) { }
            Column(EarningCodeToShow_41; EarningCodeToShow[41]) { }
            Column(EarningCodeToShow_42; EarningCodeToShow[42]) { }
            Column(EarningCodeToShow_43; EarningCodeToShow[43]) { }
            Column(EarningCodeToShow_44; EarningCodeToShow[44]) { }
            Column(EarningCodeToShow_45; EarningCodeToShow[45]) { }
            Column(EarningCodeToShow_46; EarningCodeToShow[46]) { }
            Column(EarningCodeToShow_47; EarningCodeToShow[47]) { }
            Column(EarningCodeToShow_48; EarningCodeToShow[48]) { }
            Column(EarningCodeToShow_49; EarningCodeToShow[49]) { }
            Column(EarningCodeToShow_50; EarningCodeToShow[50]) { }
            Column(EarningCodeToShow_51; EarningCodeToShow[51]) { }
            Column(EarningCodeToShow_52; EarningCodeToShow[52]) { }
            Column(EarningCodeToShow_53; EarningCodeToShow[53]) { }
            Column(EarningCodeToShow_54; EarningCodeToShow[54]) { }
            Column(EarningCodeToShow_55; EarningCodeToShow[55]) { }
            Column(EarningCodeToShow_56; EarningCodeToShow[56]) { }
            Column(EarningCodeToShow_57; EarningCodeToShow[57]) { }
            Column(EarningCodeToShow_58; EarningCodeToShow[58]) { }
            Column(EarningCodeToShow_59; EarningCodeToShow[59]) { }
            Column(EarningCodeToShow_60; EarningCodeToShow[60]) { }
            Column(EarningCodeToShow_61; EarningCodeToShow[61]) { }
            Column(EarningCodeToShow_62; EarningCodeToShow[62]) { }
            Column(EarningCodeToShow_63; EarningCodeToShow[63]) { }
            Column(EarningCodeToShow_64; EarningCodeToShow[64]) { }
            Column(EarningCodeToShow_65; EarningCodeToShow[65]) { }
            Column(EarningCodeToShow_66; EarningCodeToShow[66]) { }
            Column(EarningCodeToShow_67; EarningCodeToShow[67]) { }
            Column(EarningCodeToShow_68; EarningCodeToShow[68]) { }
            Column(EarningCodeToShow_69; EarningCodeToShow[69]) { }
            Column(EarningCodeToShow_70; EarningCodeToShow[70]) { }

            //EarningAmountToShow
            Column(EarningAmountToShow_1; EarningAmountToShow[1]) { }
            Column(EarningAmountToShow_2; EarningAmountToShow[2]) { }
            Column(EarningAmountToShow_3; EarningAmountToShow[3]) { }
            Column(EarningAmountToShow_4; EarningAmountToShow[4]) { }
            Column(EarningAmountToShow_5; EarningAmountToShow[5]) { }
            Column(EarningAmountToShow_6; EarningAmountToShow[6]) { }
            Column(EarningAmountToShow_7; EarningAmountToShow[7]) { }
            Column(EarningAmountToShow_8; EarningAmountToShow[8]) { }
            Column(EarningAmountToShow_9; EarningAmountToShow[9]) { }
            Column(EarningAmountToShow_10; EarningAmountToShow[10]) { }
            Column(EarningAmountToShow_11; EarningAmountToShow[11]) { }
            Column(EarningAmountToShow_12; EarningAmountToShow[12]) { }
            Column(EarningAmountToShow_13; EarningAmountToShow[13]) { }
            Column(EarningAmountToShow_14; EarningAmountToShow[14]) { }
            Column(EarningAmountToShow_15; EarningAmountToShow[15]) { }
            Column(EarningAmountToShow_16; EarningAmountToShow[16]) { }
            Column(EarningAmountToShow_17; EarningAmountToShow[17]) { }
            Column(EarningAmountToShow_18; EarningAmountToShow[18]) { }
            Column(EarningAmountToShow_19; EarningAmountToShow[19]) { }
            Column(EarningAmountToShow_20; EarningAmountToShow[20]) { }
            Column(EarningAmountToShow_21; EarningAmountToShow[21]) { }
            Column(EarningAmountToShow_22; EarningAmountToShow[22]) { }
            Column(EarningAmountToShow_23; EarningAmountToShow[23]) { }
            Column(EarningAmountToShow_24; EarningAmountToShow[24]) { }
            Column(EarningAmountToShow_25; EarningAmountToShow[25]) { }
            Column(EarningAmountToShow_26; EarningAmountToShow[26]) { }
            Column(EarningAmountToShow_27; EarningAmountToShow[27]) { }
            Column(EarningAmountToShow_28; EarningAmountToShow[28]) { }
            Column(EarningAmountToShow_29; EarningAmountToShow[29]) { }
            Column(EarningAmountToShow_30; EarningAmountToShow[30]) { }
            Column(EarningAmountToShow_31; EarningAmountToShow[31]) { }
            Column(EarningAmountToShow_32; EarningAmountToShow[32]) { }
            Column(EarningAmountToShow_33; EarningAmountToShow[33]) { }
            Column(EarningAmountToShow_34; EarningAmountToShow[34]) { }
            Column(EarningAmountToShow_35; EarningAmountToShow[35]) { }
            Column(EarningAmountToShow_36; EarningAmountToShow[36]) { }
            Column(EarningAmountToShow_37; EarningAmountToShow[37]) { }
            Column(EarningAmountToShow_38; EarningAmountToShow[38]) { }
            Column(EarningAmountToShow_39; EarningAmountToShow[39]) { }
            Column(EarningAmountToShow_40; EarningAmountToShow[40]) { }
            Column(EarningAmountToShow_41; EarningAmountToShow[41]) { }
            Column(EarningAmountToShow_42; EarningAmountToShow[42]) { }
            Column(EarningAmountToShow_43; EarningAmountToShow[43]) { }
            Column(EarningAmountToShow_44; EarningAmountToShow[44]) { }
            Column(EarningAmountToShow_45; EarningAmountToShow[45]) { }
            Column(EarningAmountToShow_46; EarningAmountToShow[46]) { }
            Column(EarningAmountToShow_47; EarningAmountToShow[47]) { }
            Column(EarningAmountToShow_48; EarningAmountToShow[48]) { }
            Column(EarningAmountToShow_49; EarningAmountToShow[49]) { }
            Column(EarningAmountToShow_50; EarningAmountToShow[50]) { }
            Column(EarningAmountToShow_51; EarningAmountToShow[51]) { }
            Column(EarningAmountToShow_52; EarningAmountToShow[52]) { }
            Column(EarningAmountToShow_53; EarningAmountToShow[53]) { }
            Column(EarningAmountToShow_54; EarningAmountToShow[54]) { }
            Column(EarningAmountToShow_55; EarningAmountToShow[55]) { }
            Column(EarningAmountToShow_56; EarningAmountToShow[56]) { }
            Column(EarningAmountToShow_57; EarningAmountToShow[57]) { }
            Column(EarningAmountToShow_58; EarningAmountToShow[58]) { }
            Column(EarningAmountToShow_59; EarningAmountToShow[59]) { }
            Column(EarningAmountToShow_60; EarningAmountToShow[60]) { }
            Column(EarningAmountToShow_61; EarningAmountToShow[61]) { }
            Column(EarningAmountToShow_62; EarningAmountToShow[62]) { }
            Column(EarningAmountToShow_63; EarningAmountToShow[63]) { }
            Column(EarningAmountToShow_64; EarningAmountToShow[64]) { }
            Column(EarningAmountToShow_65; EarningAmountToShow[65]) { }
            Column(EarningAmountToShow_66; EarningAmountToShow[66]) { }
            Column(EarningAmountToShow_67; EarningAmountToShow[67]) { }
            Column(EarningAmountToShow_68; EarningAmountToShow[68]) { }
            Column(EarningAmountToShow_69; EarningAmountToShow[69]) { }
            Column(EarningAmountToShow_70; EarningAmountToShow[70]) { }

            //EarningInclude1
            Column(EarningInclude1; EarningInclude[1]) { }
            Column(EarningInclude2; EarningInclude[2]) { }
            Column(EarningInclude3; EarningInclude[3]) { }
            Column(EarningInclude4; EarningInclude[4]) { }
            Column(EarningInclude5; EarningInclude[5]) { }
            Column(EarningInclude6; EarningInclude[6]) { }
            Column(EarningInclude7; EarningInclude[7]) { }
            Column(EarningInclude8; EarningInclude[8]) { }
            Column(EarningInclude9; EarningInclude[9]) { }
            Column(EarningInclude10; EarningInclude[10]) { }
            Column(EarningInclude11; EarningInclude[11]) { }
            Column(EarningInclude12; EarningInclude[12]) { }
            Column(EarningInclude13; EarningInclude[13]) { }
            Column(EarningInclude14; EarningInclude[14]) { }
            Column(EarningInclude15; EarningInclude[15]) { }
            Column(EarningInclude16; EarningInclude[16]) { }
            Column(EarningInclude17; EarningInclude[17]) { }
            Column(EarningInclude18; EarningInclude[18]) { }
            Column(EarningInclude19; EarningInclude[19]) { }
            Column(EarningInclude20; EarningInclude[20]) { }
            Column(EarningInclude21; EarningInclude[21]) { }
            Column(EarningInclude22; EarningInclude[22]) { }
            Column(EarningInclude23; EarningInclude[23]) { }
            Column(EarningInclude24; EarningInclude[24]) { }
            Column(EarningInclude25; EarningInclude[25]) { }
            Column(EarningInclude26; EarningInclude[26]) { }
            Column(EarningInclude27; EarningInclude[27]) { }
            Column(EarningInclude28; EarningInclude[28]) { }
            Column(EarningInclude29; EarningInclude[29]) { }
            Column(EarningInclude30; EarningInclude[30]) { }
            Column(EarningInclude31; EarningInclude[31]) { }
            Column(EarningInclude32; EarningInclude[32]) { }
            Column(EarningInclude33; EarningInclude[33]) { }
            Column(EarningInclude34; EarningInclude[34]) { }
            Column(EarningInclude35; EarningInclude[35]) { }
            Column(EarningInclude36; EarningInclude[36]) { }
            Column(EarningInclude37; EarningInclude[37]) { }
            Column(EarningInclude38; EarningInclude[38]) { }
            Column(EarningInclude39; EarningInclude[39]) { }
            Column(EarningInclude40; EarningInclude[40]) { }
            Column(EarningInclude41; EarningInclude[41]) { }
            Column(EarningInclude42; EarningInclude[42]) { }
            Column(EarningInclude43; EarningInclude[43]) { }
            Column(EarningInclude44; EarningInclude[44]) { }
            Column(EarningInclude45; EarningInclude[45]) { }
            Column(EarningInclude46; EarningInclude[46]) { }
            Column(EarningInclude47; EarningInclude[47]) { }
            Column(EarningInclude48; EarningInclude[48]) { }
            Column(EarningInclude49; EarningInclude[49]) { }
            Column(EarningInclude50; EarningInclude[50]) { }
            Column(EarningInclude51; EarningInclude[51]) { }
            Column(EarningInclude52; EarningInclude[52]) { }
            Column(EarningInclude53; EarningInclude[53]) { }
            Column(EarningInclude54; EarningInclude[54]) { }
            Column(EarningInclude55; EarningInclude[55]) { }
            Column(EarningInclude56; EarningInclude[56]) { }
            Column(EarningInclude57; EarningInclude[57]) { }
            Column(EarningInclude58; EarningInclude[58]) { }
            Column(EarningInclude59; EarningInclude[59]) { }
            Column(EarningInclude60; EarningInclude[60]) { }
            Column(EarningInclude61; EarningInclude[61]) { }
            Column(EarningInclude62; EarningInclude[62]) { }
            Column(EarningInclude63; EarningInclude[63]) { }
            Column(EarningInclude64; EarningInclude[64]) { }
            Column(EarningInclude65; EarningInclude[65]) { }
            Column(EarningInclude66; EarningInclude[66]) { }
            Column(EarningInclude67; EarningInclude[67]) { }
            Column(EarningInclude68; EarningInclude[68]) { }
            Column(EarningInclude69; EarningInclude[69]) { }
            Column(EarningInclude70; EarningInclude[70]) { }

            trigger OnPreDataItem()
            var

            begin
                CurrReport.CREATETOTALS(BasicSalary, TotalTaxableEarnings, TotalEarnings, TotalPreTaxDeductions, TotalDeductions, IncomeTax, NetPay);
                S := 0;
            end;

            trigger OnAfterGetRecord()
            var
                EDItems: Record Confidential;
                EmployeeEDItems: Record "Earning And Dedcution";
                EDAmount: Decimal;
                ResLedgerEntry: Record "Res. Ledger Entry";
                EarningCodesRec: Record Confidential;
            begin

                BasicSalary := 0;
                TotalTaxableEarnings := 0;
                TotalEarnings := 0;
                TotalPreTaxDeductions := 0;
                TotalPreSSFDeductions := 0;
                TotalDeductions := 0;
                IncomeTax := 0;
                TotalSSFEarnings := 0;
                SSFAmount := 0;
                SSFAmountEmployer := 0;
                LocalTax := 0;
                EarningAmountToShow[1] := 0;
                EarningAmountToShow[2] := 0;
                EarningAmountToShow[3] := 0;
                EarningAmountToShow[4] := 0;
                EarningAmountToShow[5] := 0;
                EarningAmountToShow[6] := 0;
                EarningAmountToShow[7] := 0;
                EarningAmountToShow[8] := 0;
                EarningAmountToShow[9] := 0;
                EarningAmountToShow[10] := 0;
                EarningAmountToShow[11] := 0;
                EarningAmountToShow[12] := 0;
                EarningAmountToShow[13] := 0;
                EarningAmountToShow[14] := 0;
                EarningAmountToShow[15] := 0;
                EarningAmountToShow[16] := 0;
                EarningAmountToShow[17] := 0;
                EarningAmountToShow[18] := 0;
                EarningAmountToShow[19] := 0;
                EarningAmountToShow[20] := 0;
                EarningAmountToShow[21] := 0;
                EarningAmountToShow[22] := 0;
                EarningAmountToShow[23] := 0;
                EarningAmountToShow[24] := 0;
                EarningAmountToShow[25] := 0;
                EarningAmountToShow[26] := 0;
                EarningAmountToShow[27] := 0;
                EarningAmountToShow[28] := 0;
                EarningAmountToShow[29] := 0;
                EarningAmountToShow[30] := 0;
                EarningAmountToShow[31] := 0;
                EarningAmountToShow[32] := 0;
                EarningAmountToShow[33] := 0;
                EarningAmountToShow[34] := 0;
                EarningAmountToShow[35] := 0;
                EarningAmountToShow[36] := 0;
                EarningAmountToShow[37] := 0;
                EarningAmountToShow[38] := 0;
                EarningAmountToShow[39] := 0;
                EarningAmountToShow[40] := 0;
                EarningAmountToShow[41] := 0;
                EarningAmountToShow[42] := 0;
                EarningAmountToShow[43] := 0;
                EarningAmountToShow[44] := 0;
                EarningAmountToShow[45] := 0;
                EarningAmountToShow[46] := 0;
                EarningAmountToShow[47] := 0;
                EarningAmountToShow[48] := 0;
                EarningAmountToShow[49] := 0;
                EarningAmountToShow[50] := 0;
                EarningAmountToShow[51] := 0;
                EarningAmountToShow[52] := 0;
                EarningAmountToShow[53] := 0;
                EarningAmountToShow[54] := 0;
                EarningAmountToShow[55] := 0;
                EarningAmountToShow[56] := 0;
                EarningAmountToShow[57] := 0;
                EarningAmountToShow[58] := 0;
                EarningAmountToShow[59] := 0;
                EarningAmountToShow[60] := 0;
                EarningAmountToShow[61] := 0;
                EarningAmountToShow[62] := 0;
                EarningAmountToShow[63] := 0;
                EarningAmountToShow[64] := 0;
                EarningAmountToShow[65] := 0;
                EarningAmountToShow[66] := 0;
                EarningAmountToShow[67] := 0;
                EarningAmountToShow[68] := 0;
                EarningAmountToShow[69] := 0;
                EarningAmountToShow[70] := 0;
                DeductionAmountToShow[1] := 0;
                DeductionAmountToShow[2] := 0;
                DeductionAmountToShow[3] := 0;
                DeductionAmountToShow[4] := 0;
                DeductionAmountToShow[5] := 0;
                DeductionAmountToShow[6] := 0;
                DeductionAmountToShow[7] := 0;
                DeductionAmountToShow[8] := 0;
                DeductionAmountToShow[9] := 0;
                DeductionAmountToShow[10] := 0;
                DeductionAmountToShow[11] := 0;
                DeductionAmountToShow[12] := 0;
                DeductionAmountToShow[13] := 0;
                DeductionAmountToShow[14] := 0;
                DeductionAmountToShow[15] := 0;
                DeductionAmountToShow[16] := 0;
                DeductionAmountToShow[17] := 0;
                DeductionAmountToShow[18] := 0;
                DeductionAmountToShow[19] := 0;
                DeductionAmountToShow[20] := 0;
                DeductionAmountToShow[21] := 0;
                DeductionAmountToShow[22] := 0;
                DeductionAmountToShow[23] := 0;
                DeductionAmountToShow[24] := 0;
                DeductionAmountToShow[25] := 0;
                DeductionAmountToShow[26] := 0;
                DeductionAmountToShow[27] := 0;
                DeductionAmountToShow[28] := 0;
                DeductionAmountToShow[29] := 0;
                DeductionAmountToShow[30] := 0;
                DeductionAmountToShow[31] := 0;
                DeductionAmountToShow[32] := 0;
                DeductionAmountToShow[33] := 0;
                DeductionAmountToShow[34] := 0;
                DeductionAmountToShow[35] := 0;
                DeductionAmountToShow[36] := 0;
                DeductionAmountToShow[37] := 0;
                DeductionAmountToShow[38] := 0;
                DeductionAmountToShow[39] := 0;
                DeductionAmountToShow[40] := 0;


                //Basic Pay
                ProcessBasicSalary(Employee);

                //Earnings
                ProcessOtherEarnings(Employee);

                //Deductions
                ProcessDeductions(Employee);

                //Income Tax
                ProcessIncomeTax(Employee);

                //V1.0.4 Local Service Tax
                ProcessLocalTax(Employee);

                //Process Net Pay
                NetPay := BasicSalary + TotalEarnings - (TotalDeductions + IncomeTax + LocalTax);
                ProcessNetPay(Employee);

                IF ProcessingOption = ProcessingOption::"Generate Payment Journals" THEN BEGIN
                    ResLedgerEntry.RESET;
                    ResLedgerEntry.SETRANGE(ResLedgerEntry."Posting Date", "Employee Statistics Group"."Last Payroll Processing Date");
                    ResLedgerEntry.SETRANGE(ResLedgerEntry."Resource No.", Employee."No.");
                    ResLedgerEntry.SETRANGE(ResLedgerEntry."Entry Type Payroll", ResLedgerEntry."Entry Type Payroll"::"Payroll Entry");
                    ResLedgerEntry.SETRANGE(ResLedgerEntry."Payroll Entry Type", ResLedgerEntry."Payroll Entry Type"::"Net Salary Payable");
                    IF ResLedgerEntry.FIND('-') THEN BEGIN
                        //Get Employee Bank
                        EmployeeBank.RESET;
                        EmployeeBank.SETRANGE(EmployeeBank.Type, EmployeeBank.Type::"Employee Bank");
                        EmployeeBank.SETRANGE(EmployeeBank.Code, Employee.Bank);
                        IF EmployeeBank.FINDFIRST THEN BEGIN
                            EmployeeBank.TESTFIELD("Payments Journal Template Name");
                            EmployeeBank.TESTFIELD("Payments Journal Batch Name");
                            InsertJournalLine('', Employee."Statistics Group Code", Employee."No.",
                                              EmployeeBank."Payments Journal Template Name",
                                              EmployeeBank."Payments Journal Batch Name",
                                              "Employee Statistics Group"."Salaries Payable Acc. Type", "Employee Statistics Group"."Salaries Payable Acc. No.",
                                              PostingDate, DocumentNo,
                                              COPYSTR('Net Salary Paid - ' + Employee."Full Name", 1, 50),
                                              '', ResLedgerEntry.Amount, FALSE);
                        END;
                    END;
                END;


                S += 1;
                T[S] := S;
                IF ShowNumbering THEN
                    Num := T[S]
                ELSE
                    Num := 0;

            end;

            //===============================
            trigger OnPostDataItem()
            var
                I: Integer;
                ExpenseAmount: Decimal;
                PayableAmount: Decimal;
                Earnings: Record Confidential;
                Deductions: Record Confidential;
                ResLedgerEntry: Record "Res. Ledger Entry";
                TempDate: Date;
                ResJnlPostLine: Codeunit "ResJnlPost Line";
            begin
                IF ProcessingOption = ProcessingOption::"Generate Payroll Journals" THEN BEGIN
                    IF NoOfBlockEarningItems > 0 THEN BEGIN
                        I := 0;
                        REPEAT
                            I += 1;
                            ExpenseAmount := 0;
                            IF BlockEarningItems[I] [3] <> '' THEN
                                EVALUATE(ExpenseAmount, BlockEarningItems[I] [3]);
                            IF ExpenseAmount > 0 THEN BEGIN
                                IF BlockEarningItems[I] [1] = 'BASICPAY' THEN BEGIN
                                    InsertJournalLine('', '', '',
                                                      "Employee Statistics Group"."Payroll Journal Template Name",
                                                      "Employee Statistics Group"."Payroll Journal Batch Name",
                                                      GlobalAccountType::"G/L Account", "Employee Statistics Group"."Basic Salary Expence Acc. No.",
                                                      PostingDate, DocumentNo,
                                                      'Basic Salaries - ' + FORMAT(PostingDate),
                                                      '', ExpenseAmount, FALSE);
                                END ELSE BEGIN
                                    IF Earnings.GET(Earnings.Type::Earning, BlockEarningItems[I] [1]) THEN BEGIN
                                        InsertJournalLine(Earnings.Code, '', '',
                                                          "Employee Statistics Group"."Payroll Journal Template Name",
                                                          "Employee Statistics Group"."Payroll Journal Batch Name",
                                                          GlobalAccountType::"G/L Account", Earnings."Expense Account No.",
                                                          PostingDate, DocumentNo,
                                                          Earnings.Description + ' - ' + FORMAT(PostingDate),
                                                          '', ExpenseAmount, FALSE);
                                    END;
                                END;
                            END;
                        UNTIL I = NoOfBlockEarningItems;
                    END;

                    IF NoOfBlockDeductionItems > 0 THEN BEGIN
                        I := 0;
                        REPEAT
                            I += 1;
                            ExpenseAmount := 0;
                            PayableAmount := 0;
                            IF BlockDeductionItems[I] [3] <> '' THEN
                                EVALUATE(ExpenseAmount, BlockDeductionItems[I] [3]);

                            IF BlockDeductionItems[I] [4] <> '' THEN
                                EVALUATE(PayableAmount, BlockDeductionItems[I] [4]);
                            IF BlockDeductionItems[I] [1] = 'TAX' THEN BEGIN
                                IF PayableAmount > 0 THEN BEGIN
                                    InsertJournalLine('', '', '',
                                                      "Employee Statistics Group"."Payroll Journal Template Name",
                                                      "Employee Statistics Group"."Payroll Journal Batch Name",
                                                      HRSetup."Income Tax Payable Acc. Type", HRSetup."Income Tax Payable Acc. No.",
                                                      PostingDate, DocumentNo,
                                                      HRSetup."Income Tax Range Table Code" + ' Payable - ' + FORMAT(PostingDate),
                                                      '', -PayableAmount, FALSE);
                                END;
                            END ELSE
                                IF BlockDeductionItems[I] [1] = 'NETPAY' THEN BEGIN
                                    IF PayableAmount > 0 THEN BEGIN
                                        InsertJournalLine('', '', '',
                                                          "Employee Statistics Group"."Payroll Journal Template Name",
                                                          "Employee Statistics Group"."Payroll Journal Batch Name",
                                                          "Employee Statistics Group"."Salaries Payable Acc. Type", "Employee Statistics Group"."Salaries Payable Acc. No.",
                                                          PostingDate, DocumentNo,
                                                          'Net Salaries Payable - ' + FORMAT(PostingDate),
                                                          '', -PayableAmount, FALSE);
                                    END;

                                END ELSE BEGIN
                                    IF Deductions.GET(Earnings.Type::Deduction, BlockDeductionItems[I] [1]) THEN BEGIN
                                        IF ExpenseAmount > 0 THEN BEGIN
                                            InsertJournalLine(Deductions.Code, '', '',
                                                              "Employee Statistics Group"."Payroll Journal Template Name",
                                                              "Employee Statistics Group"."Payroll Journal Batch Name",
                                                              GlobalAccountType::"G/L Account", Deductions."Expense Account No.",
                                                              PostingDate, DocumentNo,
                                                              Deductions.Description + ' - ' + FORMAT(PostingDate),
                                                              '', ExpenseAmount, FALSE);
                                        END;

                                        IF PayableAmount > 0 THEN BEGIN
                                            InsertJournalLine(Deductions.Code, '', '',
                                                              "Employee Statistics Group"."Payroll Journal Template Name",
                                                              "Employee Statistics Group"."Payroll Journal Batch Name",
                                                              Deductions."Account Type", Deductions."Account No.",
                                                              PostingDate, DocumentNo,
                                                              Deductions.Description + ' Payable - ' + FORMAT(PostingDate),
                                                              '', -PayableAmount, FALSE);
                                        END;
                                    END;
                                END;
                        UNTIL I = NoOfBlockDeductionItems;
                    END;
                END ELSE
                    IF ProcessingOption = ProcessingOption::"Close Payroll Period" THEN BEGIN
                        "Employee Statistics Group"."Last Payroll Processing Date" := "Employee Statistics Group"."Next Payroll Processing Date";
                        CASE "Employee Statistics Group"."Payroll Processing Frequency" OF
                            "Employee Statistics Group"."Payroll Processing Frequency"::Monthly:
                                BEGIN
                                    TempDate := "Employee Statistics Group"."Next Payroll Processing Date";
                                    TempDate := DMY2DATE(1, DATE2DMY(TempDate, 2), DATE2DMY(TempDate, 3));
                                    TempDate := CALCDATE('2M', TempDate);
                                    TempDate := CALCDATE('-1D', TempDate);
                                    "Employee Statistics Group"."Next Payroll Processing Date" := TempDate;
                                END;
                            "Employee Statistics Group"."Payroll Processing Frequency"::Weekly:
                                "Employee Statistics Group"."Next Payroll Processing Date" := CALCDATE('1W', "Employee Statistics Group"."Next Payroll Processing Date");
                            "Employee Statistics Group"."Payroll Processing Frequency"::"Bi-Weekly":
                                "Employee Statistics Group"."Next Payroll Processing Date" := CALCDATE('2W', "Employee Statistics Group"."Next Payroll Processing Date");
                        END;

                        "Employee Statistics Group".MODIFY;
                        ResLedgerEntry.RESET;
                        ResLedgerEntry.SETRANGE(ResLedgerEntry."Entry Type Payroll", ResLedgerEntry."Entry Type Payroll"::"Payroll Period");
                        ResLedgerEntry.SETRANGE(ResLedgerEntry."Posting Date", "Employee Statistics Group"."Last Payroll Processing Date");
                        ResLedgerEntry.SETRANGE(ResLedgerEntry."Employee Statistics Group", "Employee Statistics Group".Code);
                        IF ResLedgerEntry.FIND('-') THEN BEGIN
                            ResJnlPostLine.ModifyPayrollPeriod(ResLedgerEntry);
                        END;
                    END;
            end;
        }

    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    field("Processing Option"; ProcessingOption)
                    {
                        ApplicationArea = All;

                    }
                    field("Show Numbering"; ShowNumbering)
                    {
                        ApplicationArea = All;

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
        EarningCodesRec: Record Confidential;
    begin
        CLEAR(BlockEarningItems);
        CLEAR(BlockDeductionItems);

        LocationFilter := Employee.GETFILTER("Major Location");
        EmployeeDonor := Employee.GETFILTER("Global Dimension 1 Code");
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);
    end;

    var
        HRSetup: Record "Human Resources Setup";
        GenJnlBatch: Record "Gen. Journal Batch";
        GenJnlLine: Record "Gen. Journal Line";
        CompanyInfo: Record "Company Information";
        LineNo: Integer;
        PostingDate: Date;
        DocumentNo: Code[20];
        BasicSalary: Decimal;
        TotalTaxableEarnings: Decimal;
        TotalEarnings: Decimal;
        TotalPreTaxDeductions: Decimal;
        TotalPreSSFDeductions: Decimal;
        TotalSSFEarnings: Decimal;
        SSFAmount: Decimal;
        SSFAmountEmployer: Decimal;
        TotalTaxableAmount: Decimal;
        TotalDeductions: Decimal;
        IncomeTax: Decimal;
        LocalTax: Decimal;
        NetPay: Decimal;
        GlobalAccountType: Option "G/L Account",Vendor;
        ProcessingOption: Option "Generate Payroll Journals","Close Payroll Period","Generate Payment Journals";
        BlockEarningItems: array[100, 4] of Text[50];
        NoOfBlockEarningItems: Integer;
        BlockDeductionItems: array[100, 4] of Text[50];
        NoOfBlockDeductionItems: Integer;
        ClosePayrollPeriod: Boolean;
        PayrollEntryType: Option " ","Basic Pay",Earning,Deduction,"Income Tax","Net Salary Payable","Net Salary Paid","Local Service Tax";
        ResLedgerEntry: Record "Res. Ledger Entry";
        EntryNo: Integer;
        DeductionAmountA: Decimal;
        DeductionAmountToShow: array[100] of Decimal;
        //DeductionCodeToShow: array[100] of Code[20];
        I: Integer;
        J: Integer;
        M: Integer;
        N: Integer;
        EarningCodeToShow: array[100] of Code[20];
        EarningCodeToShowM: array[100] of Code[20];
        EarningAmountToShow: array[100] of Decimal;
        DeductionCodeToShowM: array[100] of Code[20];
        DeductionCodeToShowL: array[100] of Code[20];
        EmployeeBank: Record Confidential;
        LocationFilter: Text[10];
        PayrollMonth: Integer;
        PayrollYear: Integer;
        PayrollMonthName: Code[20];
        PayrollMonthYear: Code[30];
        S: Integer;
        T: array[2000] of Integer;
        EmployeeNo: Text[50];
        ShowNumbering: Boolean;
        Num: Integer;
        EarningInclude: array[100] of Boolean;
        DeductionInclude: array[100] of Boolean;
        DeductionIncludeLoan: array[100] of Boolean;
        LoanPlusInterest: Decimal;
        EmployeeDimension: Record "Employee Comment Line";
        ResDim1: Code[20];
        ResDim2: Code[20];
        ResDim3: Code[20];
        ResDim4: Code[20];
        ResDim5: Code[20];
        ResDim6: Code[20];
        ResDim7: Code[20];
        ResDim8: Code[20];
        EmployeeDonor: Code[30];
        ASLT0001: Label 'The General Journal Batch does not exist. Journal Template Name %1,Journal Batch Namr %2';
        ASLT0002: Label 'The Amount Basis specified for Employee No. %1 Earning Code %2 is not applicable to earnings';
        ASLT0003: Label 'You must specify the Posting date';
        ASLT0004: Label 'You must specify the Document No.';
        ASLT0005: Label 'You must close the payroll period before generating Payment Journals';
        ASLT0006: Label 'Payroll period already Closed';
        ASLT0010: Label 'You must specify the Gen. Prod. Posting Group in the Human Resources Setup';
        ASLT0011: Label 'You must specify the Base Unit of Measure in the Human Resources Setup';
        ASLT0012: Label 'None of the following dimensions can be empty for the employee %1 ; Donor Code. Please fill in the missing dimension(s) on the Employee Card';
        ASLT0013: Label 'Employee dimensions cannot be empty. Please fill in the specified dimensions; Donor Code  on the Employee Card for employee %1';
        ASLT0014: Label 'The Payroll must first be posted in the Financials before closing it';
        DeductionCodeToShow: array[100] of Code[20];
    //=============================================

    procedure ProcessBasicSalary(EmployeeRec: Record Employee)
    var
        ResourceLedgerEntry: Record "Res. Ledger Entry";
        LastPayrollDate: Date;
    begin
        //Get Basic Salary
        IF EmployeeRec."Basic Pay Type" = EmployeeRec."Basic Pay Type"::Fixed THEN BEGIN
            EmployeeRec.TESTFIELD("Basic Salary (LCY)");
            BasicSalary := EmployeeRec."Basic Salary (LCY)";
        END ELSE
            IF EmployeeRec."Basic Pay Type" = EmployeeRec."Basic Pay Type"::"Resource Units" THEN BEGIN
                //Get Salary from Resource Ledger
                IF "Employee Statistics Group"."Last Payroll Processing Date" <> 0D THEN
                    LastPayrollDate := CALCDATE('1D', "Employee Statistics Group"."Last Payroll Processing Date")
                ELSE
                    LastPayrollDate := 0D;

                ResourceLedgerEntry.RESET;
                ResourceLedgerEntry.SETRANGE(ResourceLedgerEntry."Resource No.", EmployeeRec."No.");
                ResourceLedgerEntry.SETRANGE(ResourceLedgerEntry."Entry Type Payroll", ResourceLedgerEntry."Entry Type Payroll"::Usage);
                ResourceLedgerEntry.SETRANGE(ResourceLedgerEntry."Posting Date",
                                             LastPayrollDate,
                                             "Employee Statistics Group"."Next Payroll Processing Date");
                IF ResourceLedgerEntry.FINDSET THEN BEGIN
                    ResourceLedgerEntry.CALCSUMS(ResourceLedgerEntry."Total Cost");
                    BasicSalary := ResourceLedgerEntry."Total Cost";
                END;
            END;

        //Post Basic Salary
        CheckEmployeeAsResource(EmployeeRec);

        IF ProcessingOption = ProcessingOption::"Generate Payroll Journals" THEN BEGIN
            IF "Employee Statistics Group"."Basic Pay Expense Posting Type" =
                        "Employee Statistics Group"."Basic Pay Expense Posting Type"::Individual THEN BEGIN
                //Debit Salary Expense
                InsertJournalLine('', EmployeeRec."Statistics Group Code", EmployeeRec."No.", "Employee Statistics Group"."Payroll Journal Template Name",
                                "Employee Statistics Group"."Payroll Journal Batch Name",
                                GlobalAccountType::"G/L Account", "Employee Statistics Group"."Basic Salary Expence Acc. No.", PostingDate,
                                DocumentNo,
                                COPYSTR(EmployeeRec."Full Name", 1, 50),
                                '', BasicSalary, FALSE);
            END ELSE BEGIN
                AddToBlockEarningItems('BASICPAY', 'Basic Salaries', BasicSalary, 0);
            END;
        END ELSE
            IF ProcessingOption = ProcessingOption::"Close Payroll Period" THEN BEGIN
                InsertPayrollLedgerEntry(EmployeeRec."No.", EmployeeRec."Statistics Group Code", 'BASICPAY', 'Basic Salary',
                                         PayrollEntryType::"Basic Pay", TRUE, BasicSalary, 0);
            END;
    end;

    //================================================
    procedure ProcessOtherEarnings(EmployeeRec: Record Employee)
    var
        Earnings: Record Confidential;
        EmployeeEarnings: Record "Earning And Dedcution";
        EarningAmount: Decimal;
        EarningAmountA: Decimal;
        Earnings1: Record Confidential;
        Earnings2: Record Confidential;
        EarningCodesRec: Record Confidential;
        EarningCodesRec1: Record Confidential;
        EmployeeEarnings1: Record "Earning And Dedcution";
        EmployeeEarnings2: Record "Earning And Dedcution";
    begin
        EmployeeEarnings.RESET;
        EmployeeEarnings.SETRANGE(EmployeeEarnings."Employee No.", EmployeeRec."No.");
        EmployeeEarnings.SETRANGE(EmployeeEarnings.Type, EmployeeEarnings.Type::Earning);
        IF EmployeeEarnings.FINDSET THEN BEGIN
            REPEAT
                Earnings.Reset();
                Earnings.SetRange(Earnings.Code, EmployeeEarnings."Confidential Code");
                Earnings.SetRange(Earnings.Type, Earnings.Type::Earning);
                //Earnings.GET(Earnings.Type::Earning, EmployeeEarnings."Confidential Code")
                IF Earnings.FindFirst() THEN BEGIN
                    IF Earnings."Amount Basis" = Earnings."Amount Basis"::"Fixed Amount" THEN
                        EarningAmount := EmployeeEarnings."Fixed Amount"
                    ELSE
                        IF Earnings."Amount Basis" = Earnings."Amount Basis"::"Percentage of Basic Pay" THEN
                            EarningAmount := ROUND((BasicSalary * EmployeeEarnings.Percentage * 0.01), 0.001, '=') //change
                        ELSE
                            ERROR(STRSUBSTNO(ASLT0002, Employee."No.", EmployeeEarnings."Confidential Code"));

                    IF ProcessingOption = ProcessingOption::"Generate Payroll Journals" THEN BEGIN
                        IF Earnings."Expense Posting Type" = Earnings."Expense Posting Type"::Individual THEN BEGIN
                            //Debit Earning Expense
                            InsertJournalLine(Earnings.Code, EmployeeRec."Statistics Group Code", EmployeeRec."No.",
                                              "Employee Statistics Group"."Payroll Journal Template Name",
                                              "Employee Statistics Group"."Payroll Journal Batch Name", Earnings."Account Type",
                                              Earnings."Account No.",
                                              PostingDate,
                                              DocumentNo,
                                              COPYSTR(EmployeeRec."Full Name",
                                              1, 50), '', EarningAmount, FALSE);
                        END ELSE BEGIN
                            AddToBlockEarningItems(Earnings.Code, Earnings.Description, EarningAmount, 0);
                        END;
                    END ELSE
                        IF ProcessingOption = ProcessingOption::"Close Payroll Period" THEN BEGIN
                            InsertPayrollLedgerEntry(EmployeeRec."No.", EmployeeRec."Statistics Group Code", Earnings.Code,
                                                     Earnings.Description, PayrollEntryType::Earning,
                                                     Earnings.Taxable, EarningAmount, 0);

                            IF Earnings.Recurrence = Earnings.Recurrence::Never THEN BEGIN
                                EmployeeEarnings.DELETE;
                            END ELSE
                                IF Earnings.Recurrence = Earnings.Recurrence::"On Balance" THEN BEGIN
                                    IF Earnings."Increasing Balance" THEN BEGIN
                                        EmployeeEarnings."Current Balance" += EarningAmount;
                                        EmployeeEarnings.MODIFY;
                                        IF EmployeeEarnings."Current Balance" >= EmployeeEarnings."Threshold Balance" THEN
                                            EmployeeEarnings.DELETE;
                                    END ELSE BEGIN
                                        EmployeeEarnings."Current Balance" -= EarningAmount;
                                        EmployeeEarnings.MODIFY;
                                        IF EmployeeEarnings."Current Balance" <= EmployeeEarnings."Threshold Balance" THEN
                                            EmployeeEarnings.DELETE;
                                    END;
                                END;
                        END;

                    //Add to taxable earnings total
                    IF Earnings.Taxable THEN
                        TotalTaxableEarnings := TotalTaxableEarnings + EarningAmount;

                    //Add to total earnings
                    TotalEarnings := TotalEarnings + EarningAmount;

                    //SSF
                    IF Earnings."Inc. In SS Cont. Calculation" THEN
                        TotalSSFEarnings := TotalSSFEarnings + EarningAmount;

                END;
            UNTIL EmployeeEarnings.NEXT = 0;

        END;

        // V1.0.1 Addition: Show Earning Codes and Amount on report

        EarningCodesRec.RESET;
        EarningCodesRec.SETRANGE(Type, EarningCodesRec.Type::Earning);
        IF EarningCodesRec.FINDFIRST THEN BEGIN
            N := 1;
            REPEAT
                EarningCodeToShow[N] := EarningCodesRec.Code;
                IF EarningCodesRec."Include on Report" THEN begin
                    EarningInclude[N] := TRUE;
                end ELSE
                    EarningInclude[N] := FALSE;
                N += 1;
            UNTIL EarningCodesRec.NEXT = 0;
        END;


        EmployeeEarnings1.RESET;
        EmployeeEarnings1.SETRANGE(EmployeeEarnings1."Employee No.", EmployeeRec."No.");
        EmployeeEarnings1.SETRANGE(EmployeeEarnings1.Type, EmployeeEarnings1.Type::Earning);
        IF EmployeeEarnings1.FINDSET THEN BEGIN
            REPEAT
                EarningAmountA := 0;
                Earnings1.RESET;
                Earnings1.SETRANGE(Type, Earnings1.Type::Earning);
                Earnings1.SETRANGE(Code, EmployeeEarnings1."Confidential Code");
                Earnings1.SETRANGE("Include on Report", TRUE);
                IF Earnings1.FINDFIRST THEN BEGIN
                    IF Earnings1."Amount Basis" = Earnings1."Amount Basis"::"Fixed Amount" THEN
                        EarningAmountA := EmployeeEarnings1."Fixed Amount"
                    ELSE
                        IF Earnings1."Amount Basis" = Earnings1."Amount Basis"::"Percentage of Basic Pay" THEN
                            EarningAmountA := ROUND((BasicSalary * EmployeeEarnings1.Percentage * 0.01), 0.001, '='); //change

                    IF (Earnings1.Code = EarningCodeToShow[1]) THEN BEGIN
                        IF EarningAmountA <> ROUND(0.00001, 0.01, '=') THEN
                            EarningAmountToShow[1] := EarningAmountA
                        ELSE
                            EarningAmountToShow[1] := 0.0
                    END ELSE
                        IF (Earnings1.Code = EarningCodeToShow[2]) THEN BEGIN
                            IF EarningAmountA <> ROUND(0.00001, 0.01, '=') THEN
                                EarningAmountToShow[2] := EarningAmountA
                            ELSE
                                EarningAmountToShow[2] := 0.0;
                        END ELSE
                            IF (Earnings1.Code = EarningCodeToShow[3]) THEN BEGIN
                                IF EarningAmountA <> ROUND(0.00001, 0.01, '=') THEN
                                    EarningAmountToShow[3] := EarningAmountA
                                ELSE
                                    EarningAmountToShow[3] := 0.0;
                            END ELSE
                                IF (Earnings1.Code = EarningCodeToShow[4]) THEN BEGIN
                                    IF EarningAmountA <> ROUND(0.00001, 0.01, '=') THEN
                                        EarningAmountToShow[4] := EarningAmountA
                                    ELSE
                                        EarningAmountToShow[4] := 0.0;
                                END ELSE
                                    IF (Earnings1.Code = EarningCodeToShow[5]) THEN BEGIN
                                        IF EarningAmountA <> ROUND(0.00001, 0.01, '=') THEN
                                            EarningAmountToShow[5] := EarningAmountA
                                        ELSE
                                            EarningAmountToShow[5] := 0.0;
                                    END ELSE
                                        IF (Earnings1.Code = EarningCodeToShow[6]) THEN BEGIN
                                            IF EarningAmountA <> ROUND(0.00001, 0.01, '=') THEN
                                                EarningAmountToShow[6] := EarningAmountA
                                            ELSE
                                                EarningAmountToShow[6] := 0.0;
                                        END ELSE
                                            IF (Earnings1.Code = EarningCodeToShow[7]) THEN BEGIN
                                                IF EarningAmountA <> ROUND(0.00001, 0.01, '=') THEN
                                                    EarningAmountToShow[7] := EarningAmountA
                                                ELSE
                                                    EarningAmountToShow[7] := 0.0;
                                            END ELSE
                                                IF (Earnings1.Code = EarningCodeToShow[8]) THEN BEGIN
                                                    IF EarningAmountA <> ROUND(0.00001, 0.01, '=') THEN
                                                        EarningAmountToShow[8] := EarningAmountA
                                                    ELSE
                                                        EarningAmountToShow[8] := 0.0;
                                                END ELSE
                                                    IF (Earnings1.Code = EarningCodeToShow[9]) THEN BEGIN
                                                        IF EarningAmountA <> ROUND(0.00001, 0.01, '=') THEN
                                                            EarningAmountToShow[9] := EarningAmountA
                                                        ELSE
                                                            EarningAmountToShow[9] := 0.0;
                                                    END ELSE
                                                        IF (Earnings1.Code = EarningCodeToShow[10]) THEN BEGIN
                                                            IF EarningAmountA <> ROUND(0.00001, 0.01, '=') THEN
                                                                EarningAmountToShow[10] := EarningAmountA
                                                            ELSE
                                                                EarningAmountToShow[10] := 0.0;
                                                        END ELSE
                                                            IF (Earnings1.Code = EarningCodeToShow[11]) THEN BEGIN
                                                                IF EarningAmountA <> ROUND(0.00001, 0.01, '=') THEN
                                                                    EarningAmountToShow[11] := EarningAmountA
                                                                ELSE
                                                                    EarningAmountToShow[11] := 0.0;
                                                            END ELSE
                                                                IF (Earnings1.Code = EarningCodeToShow[12]) THEN BEGIN
                                                                    IF EarningAmountA <> ROUND(0.00001, 0.01, '=') THEN
                                                                        EarningAmountToShow[12] := EarningAmountA
                                                                    ELSE
                                                                        EarningAmountToShow[12] := 0.0;
                                                                END ELSE
                                                                    IF (Earnings1.Code = EarningCodeToShow[13]) THEN BEGIN
                                                                        IF EarningAmountA <> ROUND(0.00001, 0.01, '=') THEN
                                                                            EarningAmountToShow[13] := EarningAmountA
                                                                        ELSE
                                                                            EarningAmountToShow[13] := 0.0;
                                                                    END ELSE
                                                                        IF (Earnings1.Code = EarningCodeToShow[14]) THEN BEGIN
                                                                            IF EarningAmountA <> ROUND(0.00001, 0.01, '=') THEN
                                                                                EarningAmountToShow[14] := EarningAmountA
                                                                            ELSE
                                                                                EarningAmountToShow[14] := 0.0;
                                                                        END ELSE
                                                                            IF (Earnings1.Code = EarningCodeToShow[15]) THEN BEGIN
                                                                                IF EarningAmountA <> ROUND(0.00001, 0.01, '=') THEN
                                                                                    EarningAmountToShow[15] := EarningAmountA
                                                                                ELSE
                                                                                    EarningAmountToShow[15] := 0.0;
                                                                            END ELSE
                                                                                IF (Earnings1.Code = EarningCodeToShow[16]) THEN BEGIN
                                                                                    IF EarningAmountA <> ROUND(0.00001, 0.01, '=') THEN
                                                                                        EarningAmountToShow[16] := EarningAmountA
                                                                                    ELSE
                                                                                        EarningAmountToShow[16] := 0.0;
                                                                                END ELSE
                                                                                    IF (Earnings1.Code = EarningCodeToShow[17]) THEN BEGIN
                                                                                        IF EarningAmountA <> ROUND(0.00001, 0.01, '=') THEN
                                                                                            EarningAmountToShow[17] := EarningAmountA
                                                                                        ELSE
                                                                                            EarningAmountToShow[17] := 0.0;
                                                                                    END ELSE
                                                                                        IF (Earnings1.Code = EarningCodeToShow[18]) THEN BEGIN
                                                                                            IF EarningAmountA <> ROUND(0.00001, 0.01, '=') THEN
                                                                                                EarningAmountToShow[18] := EarningAmountA
                                                                                            ELSE
                                                                                                EarningAmountToShow[18] := 0.0;
                                                                                        END ELSE
                                                                                            IF (Earnings1.Code = EarningCodeToShow[19]) THEN BEGIN
                                                                                                IF EarningAmountA <> ROUND(0.00001, 0.01, '=') THEN
                                                                                                    EarningAmountToShow[19] := EarningAmountA
                                                                                                ELSE
                                                                                                    EarningAmountToShow[19] := 0.0;

                                                                                            END ELSE
                                                                                                IF (Earnings1.Code = EarningCodeToShow[20]) THEN BEGIN
                                                                                                    IF EarningAmountA <> ROUND(0.00001, 0.01, '=') THEN
                                                                                                        EarningAmountToShow[20] := EarningAmountA
                                                                                                    ELSE
                                                                                                        EarningAmountToShow[20] := 0.0;
                                                                                                END ELSE
                                                                                                    IF (Earnings1.Code = EarningCodeToShow[21]) THEN BEGIN
                                                                                                        IF EarningAmountA <> ROUND(0.00001, 0.01, '=') THEN
                                                                                                            EarningAmountToShow[21] := EarningAmountA
                                                                                                        ELSE
                                                                                                            EarningAmountToShow[21] := 0.0;
                                                                                                    END ELSE
                                                                                                        IF (Earnings1.Code = EarningCodeToShow[22]) THEN BEGIN
                                                                                                            IF EarningAmountA <> ROUND(0.00001, 0.01, '=') THEN
                                                                                                                EarningAmountToShow[22] := EarningAmountA
                                                                                                            ELSE
                                                                                                                EarningAmountToShow[22] := 0.0;
                                                                                                        END ELSE
                                                                                                            IF (Earnings1.Code = EarningCodeToShow[23]) THEN BEGIN
                                                                                                                IF EarningAmountA <> ROUND(0.00001, 0.01, '=') THEN
                                                                                                                    EarningAmountToShow[23] := EarningAmountA
                                                                                                                ELSE
                                                                                                                    EarningAmountToShow[23] := 0.0;
                                                                                                            END ELSE
                                                                                                                IF (Earnings1.Code = EarningCodeToShow[24]) THEN BEGIN
                                                                                                                    IF EarningAmountA <> ROUND(0.00001, 0.01, '=') THEN
                                                                                                                        EarningAmountToShow[24] := EarningAmountA
                                                                                                                    ELSE
                                                                                                                        EarningAmountToShow[24] := 0.0;
                                                                                                                END ELSE
                                                                                                                    IF (Earnings1.Code = EarningCodeToShow[25]) THEN BEGIN
                                                                                                                        IF EarningAmountA <> ROUND(0.00001, 0.01, '=') THEN
                                                                                                                            EarningAmountToShow[25] := EarningAmountA
                                                                                                                        ELSE
                                                                                                                            EarningAmountToShow[25] := 0.0;
                                                                                                                    END ELSE
                                                                                                                        IF (Earnings1.Code = EarningCodeToShow[26]) THEN BEGIN
                                                                                                                            IF EarningAmountA <> ROUND(0.00001, 0.01, '=') THEN
                                                                                                                                EarningAmountToShow[26] := EarningAmountA
                                                                                                                            ELSE
                                                                                                                                EarningAmountToShow[26] := 0.0;
                                                                                                                        END ELSE
                                                                                                                            IF (Earnings1.Code = EarningCodeToShow[27]) THEN BEGIN
                                                                                                                                IF EarningAmountA <> ROUND(0.00001, 0.01, '=') THEN
                                                                                                                                    EarningAmountToShow[27] := EarningAmountA
                                                                                                                                ELSE
                                                                                                                                    EarningAmountToShow[27] := 0.0;
                                                                                                                            END ELSE
                                                                                                                                IF (Earnings1.Code = EarningCodeToShow[28]) THEN BEGIN
                                                                                                                                    IF EarningAmountA <> ROUND(0.00001, 0.01, '=') THEN
                                                                                                                                        EarningAmountToShow[28] := EarningAmountA
                                                                                                                                    ELSE
                                                                                                                                        EarningAmountToShow[28] := 0.0;
                                                                                                                                END ELSE
                                                                                                                                    IF (Earnings1.Code = EarningCodeToShow[29]) THEN BEGIN
                                                                                                                                        IF EarningAmountA <> ROUND(0.00001, 0.01, '=') THEN
                                                                                                                                            EarningAmountToShow[29] := EarningAmountA
                                                                                                                                        ELSE
                                                                                                                                            EarningAmountToShow[29] := 0.0;
                                                                                                                                    END ELSE
                                                                                                                                        IF (Earnings1.Code = EarningCodeToShow[30]) THEN BEGIN
                                                                                                                                            IF EarningAmountA <> ROUND(0.00001, 0.01, '=') THEN
                                                                                                                                                EarningAmountToShow[30] := EarningAmountA
                                                                                                                                            ELSE
                                                                                                                                                EarningAmountToShow[30] := 0.0;
                                                                                                                                        END ELSE
                                                                                                                                            IF (Earnings1.Code = EarningCodeToShow[31]) THEN BEGIN
                                                                                                                                                IF EarningAmountA <> ROUND(0.00001, 0.01, '=') THEN
                                                                                                                                                    EarningAmountToShow[31] := EarningAmountA
                                                                                                                                                ELSE
                                                                                                                                                    EarningAmountToShow[31] := 0.0;
                                                                                                                                            END ELSE
                                                                                                                                                IF (Earnings1.Code = EarningCodeToShow[32]) THEN BEGIN
                                                                                                                                                    IF EarningAmountA <> ROUND(0.00001, 0.01, '=') THEN
                                                                                                                                                        EarningAmountToShow[32] := EarningAmountA
                                                                                                                                                    ELSE
                                                                                                                                                        EarningAmountToShow[32] := 0.0;
                                                                                                                                                END ELSE
                                                                                                                                                    IF (Earnings1.Code = EarningCodeToShow[33]) THEN BEGIN
                                                                                                                                                        IF EarningAmountA <> ROUND(0.00001, 0.01, '=') THEN
                                                                                                                                                            EarningAmountToShow[33] := EarningAmountA
                                                                                                                                                        ELSE
                                                                                                                                                            EarningAmountToShow[33] := 0.0;
                                                                                                                                                    END ELSE
                                                                                                                                                        IF (Earnings1.Code = EarningCodeToShow[34]) THEN BEGIN
                                                                                                                                                            IF EarningAmountA <> ROUND(0.00001, 0.01, '=') THEN
                                                                                                                                                                EarningAmountToShow[34] := EarningAmountA
                                                                                                                                                            ELSE
                                                                                                                                                                EarningAmountToShow[34] := 0.0;
                                                                                                                                                        END ELSE
                                                                                                                                                            IF (Earnings1.Code = EarningCodeToShow[35]) THEN BEGIN
                                                                                                                                                                IF EarningAmountA <> ROUND(0.00001, 0.01, '=') THEN
                                                                                                                                                                    EarningAmountToShow[35] := EarningAmountA
                                                                                                                                                                ELSE
                                                                                                                                                                    EarningAmountToShow[35] := 0.0;
                                                                                                                                                            END ELSE
                                                                                                                                                                IF (Earnings1.Code = EarningCodeToShow[36]) THEN BEGIN
                                                                                                                                                                    IF EarningAmountA <> ROUND(0.00001, 0.01, '=') THEN
                                                                                                                                                                        EarningAmountToShow[36] := EarningAmountA
                                                                                                                                                                    ELSE
                                                                                                                                                                        EarningAmountToShow[36] := 0.0;
                                                                                                                                                                END ELSE
                                                                                                                                                                    IF (Earnings1.Code = EarningCodeToShow[37]) THEN BEGIN
                                                                                                                                                                        IF EarningAmountA <> ROUND(0.00001, 0.01, '=') THEN
                                                                                                                                                                            EarningAmountToShow[37] := EarningAmountA
                                                                                                                                                                        ELSE
                                                                                                                                                                            EarningAmountToShow[37] := 0.0;
                                                                                                                                                                    END ELSE
                                                                                                                                                                        IF (Earnings1.Code = EarningCodeToShow[38]) THEN BEGIN
                                                                                                                                                                            IF EarningAmountA <> ROUND(0.00001, 0.01, '=') THEN
                                                                                                                                                                                EarningAmountToShow[38] := EarningAmountA
                                                                                                                                                                            ELSE
                                                                                                                                                                                EarningAmountToShow[38] := 0.0;
                                                                                                                                                                        END ELSE
                                                                                                                                                                            IF (Earnings1.Code = EarningCodeToShow[39]) THEN BEGIN
                                                                                                                                                                                IF EarningAmountA <> ROUND(0.00001, 0.01, '=') THEN
                                                                                                                                                                                    EarningAmountToShow[39] := EarningAmountA
                                                                                                                                                                                ELSE
                                                                                                                                                                                    EarningAmountToShow[39] := 0.0;
                                                                                                                                                                            END ELSE
                                                                                                                                                                                IF (Earnings1.Code = EarningCodeToShow[40]) THEN BEGIN
                                                                                                                                                                                    IF EarningAmountA <> ROUND(0.00001, 0.01, '=') THEN
                                                                                                                                                                                        EarningAmountToShow[40] := EarningAmountA
                                                                                                                                                                                    ELSE
                                                                                                                                                                                        EarningAmountToShow[40] := 0.0;
                                                                                                                                                                                END ELSE
                                                                                                                                                                                    IF (Earnings1.Code = EarningCodeToShow[41]) THEN BEGIN
                                                                                                                                                                                        IF EarningAmountA <> ROUND(0.00001, 0.01, '=') THEN
                                                                                                                                                                                            EarningAmountToShow[41] := EarningAmountA
                                                                                                                                                                                        ELSE
                                                                                                                                                                                            EarningAmountToShow[41] := 0.0;
                                                                                                                                                                                    END ELSE
                                                                                                                                                                                        IF (Earnings1.Code = EarningCodeToShow[42]) THEN BEGIN
                                                                                                                                                                                            IF EarningAmountA <> ROUND(0.00001, 0.01, '=') THEN
                                                                                                                                                                                                EarningAmountToShow[42] := EarningAmountA
                                                                                                                                                                                            ELSE
                                                                                                                                                                                                EarningAmountToShow[42] := 0.0;
                                                                                                                                                                                        END ELSE
                                                                                                                                                                                            IF (Earnings1.Code = EarningCodeToShow[43]) THEN BEGIN
                                                                                                                                                                                                IF EarningAmountA <> ROUND(0.00001, 0.01, '=') THEN
                                                                                                                                                                                                    EarningAmountToShow[43] := EarningAmountA
                                                                                                                                                                                                ELSE
                                                                                                                                                                                                    EarningAmountToShow[43] := 0.0;
                                                                                                                                                                                            END ELSE
                                                                                                                                                                                                IF (Earnings1.Code = EarningCodeToShow[44]) THEN BEGIN
                                                                                                                                                                                                    IF EarningAmountA <> ROUND(0.00001, 0.01, '=') THEN
                                                                                                                                                                                                        EarningAmountToShow[44] := EarningAmountA
                                                                                                                                                                                                    ELSE
                                                                                                                                                                                                        EarningAmountToShow[44] := 0.0;
                                                                                                                                                                                                END ELSE
                                                                                                                                                                                                    IF (Earnings1.Code = EarningCodeToShow[45]) THEN BEGIN
                                                                                                                                                                                                        IF EarningAmountA <> ROUND(0.00001, 0.01, '=') THEN
                                                                                                                                                                                                            EarningAmountToShow[45] := EarningAmountA
                                                                                                                                                                                                        ELSE
                                                                                                                                                                                                            EarningAmountToShow[45] := 0.0;
                                                                                                                                                                                                    END ELSE
                                                                                                                                                                                                        IF (Earnings1.Code = EarningCodeToShow[46]) THEN BEGIN
                                                                                                                                                                                                            IF EarningAmountA <> ROUND(0.00001, 0.01, '=') THEN
                                                                                                                                                                                                                EarningAmountToShow[46] := EarningAmountA
                                                                                                                                                                                                            ELSE
                                                                                                                                                                                                                EarningAmountToShow[46] := 0.0;
                                                                                                                                                                                                        END ELSE
                                                                                                                                                                                                            IF (Earnings1.Code = EarningCodeToShow[47]) THEN BEGIN
                                                                                                                                                                                                                IF EarningAmountA <> ROUND(0.00001, 0.01, '=') THEN
                                                                                                                                                                                                                    EarningAmountToShow[47] := EarningAmountA
                                                                                                                                                                                                                ELSE
                                                                                                                                                                                                                    EarningAmountToShow[47] := 0.0;
                                                                                                                                                                                                            END ELSE
                                                                                                                                                                                                                IF (Earnings1.Code = EarningCodeToShow[48]) THEN BEGIN
                                                                                                                                                                                                                    IF EarningAmountA <> ROUND(0.00001, 0.01, '=') THEN
                                                                                                                                                                                                                        EarningAmountToShow[48] := EarningAmountA
                                                                                                                                                                                                                    ELSE
                                                                                                                                                                                                                        EarningAmountToShow[48] := 0.0;
                                                                                                                                                                                                                END ELSE
                                                                                                                                                                                                                    IF (Earnings1.Code = EarningCodeToShow[49]) THEN BEGIN
                                                                                                                                                                                                                        IF EarningAmountA <> ROUND(0.00001, 0.01, '=') THEN
                                                                                                                                                                                                                            EarningAmountToShow[49] := EarningAmountA
                                                                                                                                                                                                                        ELSE
                                                                                                                                                                                                                            EarningAmountToShow[49] := 0.0;
                                                                                                                                                                                                                    END ELSE
                                                                                                                                                                                                                        IF (Earnings1.Code = EarningCodeToShow[50]) THEN BEGIN
                                                                                                                                                                                                                            IF EarningAmountA <> ROUND(0.00001, 0.01, '=') THEN
                                                                                                                                                                                                                                EarningAmountToShow[50] := EarningAmountA
                                                                                                                                                                                                                            ELSE
                                                                                                                                                                                                                                EarningAmountToShow[50] := 0.0;
                                                                                                                                                                                                                        END ELSE
                                                                                                                                                                                                                            IF (Earnings1.Code = EarningCodeToShow[51]) THEN BEGIN
                                                                                                                                                                                                                                IF EarningAmountA <> ROUND(0.00001, 0.01, '=') THEN
                                                                                                                                                                                                                                    EarningAmountToShow[51] := EarningAmountA
                                                                                                                                                                                                                                ELSE
                                                                                                                                                                                                                                    EarningAmountToShow[51] := 0.0;
                                                                                                                                                                                                                            END ELSE
                                                                                                                                                                                                                                IF (Earnings1.Code = EarningCodeToShow[52]) THEN BEGIN
                                                                                                                                                                                                                                    IF EarningAmountA <> ROUND(0.00001, 0.01, '=') THEN
                                                                                                                                                                                                                                        EarningAmountToShow[52] := EarningAmountA
                                                                                                                                                                                                                                    ELSE
                                                                                                                                                                                                                                        EarningAmountToShow[52] := 0.0;
                                                                                                                                                                                                                                END ELSE
                                                                                                                                                                                                                                    IF (Earnings1.Code = EarningCodeToShow[53]) THEN BEGIN
                                                                                                                                                                                                                                        IF EarningAmountA <> ROUND(0.00001, 0.01, '=') THEN
                                                                                                                                                                                                                                            EarningAmountToShow[53] := EarningAmountA
                                                                                                                                                                                                                                        ELSE
                                                                                                                                                                                                                                            EarningAmountToShow[53] := 0.0;
                                                                                                                                                                                                                                    END ELSE
                                                                                                                                                                                                                                        IF (Earnings1.Code = EarningCodeToShow[54]) THEN BEGIN
                                                                                                                                                                                                                                            IF EarningAmountA <> ROUND(0.00001, 0.01, '=') THEN
                                                                                                                                                                                                                                                EarningAmountToShow[54] := EarningAmountA
                                                                                                                                                                                                                                            ELSE
                                                                                                                                                                                                                                                EarningAmountToShow[54] := 0.0;
                                                                                                                                                                                                                                        END ELSE
                                                                                                                                                                                                                                            IF (Earnings1.Code = EarningCodeToShow[55]) THEN BEGIN
                                                                                                                                                                                                                                                IF EarningAmountA <> ROUND(0.00001, 0.01, '=') THEN
                                                                                                                                                                                                                                                    EarningAmountToShow[55] := EarningAmountA
                                                                                                                                                                                                                                                ELSE
                                                                                                                                                                                                                                                    EarningAmountToShow[55] := 0.0;
                                                                                                                                                                                                                                            END ELSE
                                                                                                                                                                                                                                                IF (Earnings1.Code = EarningCodeToShow[56]) THEN BEGIN
                                                                                                                                                                                                                                                    IF EarningAmountA <> ROUND(0.00001, 0.01, '=') THEN
                                                                                                                                                                                                                                                        EarningAmountToShow[56] := EarningAmountA
                                                                                                                                                                                                                                                    ELSE
                                                                                                                                                                                                                                                        EarningAmountToShow[56] := 0.0;
                                                                                                                                                                                                                                                END ELSE
                                                                                                                                                                                                                                                    IF (Earnings1.Code = EarningCodeToShow[57]) THEN BEGIN
                                                                                                                                                                                                                                                        IF EarningAmountA <> ROUND(0.00001, 0.01, '=') THEN
                                                                                                                                                                                                                                                            EarningAmountToShow[57] := EarningAmountA
                                                                                                                                                                                                                                                        ELSE
                                                                                                                                                                                                                                                            EarningAmountToShow[57] := 0.0;
                                                                                                                                                                                                                                                    END ELSE
                                                                                                                                                                                                                                                        IF (Earnings1.Code = EarningCodeToShow[58]) THEN BEGIN
                                                                                                                                                                                                                                                            IF EarningAmountA <> ROUND(0.00001, 0.01, '=') THEN
                                                                                                                                                                                                                                                                EarningAmountToShow[58] := EarningAmountA
                                                                                                                                                                                                                                                            ELSE
                                                                                                                                                                                                                                                                EarningAmountToShow[58] := 0.0;
                                                                                                                                                                                                                                                        END ELSE
                                                                                                                                                                                                                                                            IF (Earnings1.Code = EarningCodeToShow[59]) THEN BEGIN
                                                                                                                                                                                                                                                                IF EarningAmountA <> ROUND(0.00001, 0.01, '=') THEN
                                                                                                                                                                                                                                                                    EarningAmountToShow[59] := EarningAmountA
                                                                                                                                                                                                                                                                ELSE
                                                                                                                                                                                                                                                                    EarningAmountToShow[59] := 0.0;
                                                                                                                                                                                                                                                            END ELSE
                                                                                                                                                                                                                                                                IF (Earnings1.Code = EarningCodeToShow[60]) THEN BEGIN
                                                                                                                                                                                                                                                                    IF EarningAmountA <> ROUND(0.00001, 0.01, '=') THEN
                                                                                                                                                                                                                                                                        EarningAmountToShow[60] := EarningAmountA
                                                                                                                                                                                                                                                                    ELSE
                                                                                                                                                                                                                                                                        EarningAmountToShow[60] := 0.0;
                                                                                                                                                                                                                                                                END ELSE
                                                                                                                                                                                                                                                                    IF (Earnings1.Code = EarningCodeToShow[61]) THEN BEGIN
                                                                                                                                                                                                                                                                        IF EarningAmountA <> ROUND(0.00001, 0.01, '=') THEN
                                                                                                                                                                                                                                                                            EarningAmountToShow[61] := EarningAmountA
                                                                                                                                                                                                                                                                        ELSE
                                                                                                                                                                                                                                                                            EarningAmountToShow[61] := 0.0;
                                                                                                                                                                                                                                                                    END ELSE
                                                                                                                                                                                                                                                                        IF (Earnings1.Code = EarningCodeToShow[62]) THEN BEGIN
                                                                                                                                                                                                                                                                            IF EarningAmountA <> ROUND(0.00001, 0.01, '=') THEN
                                                                                                                                                                                                                                                                                EarningAmountToShow[62] := EarningAmountA
                                                                                                                                                                                                                                                                            ELSE
                                                                                                                                                                                                                                                                                EarningAmountToShow[62] := 0.0;
                                                                                                                                                                                                                                                                        END ELSE
                                                                                                                                                                                                                                                                            IF (Earnings1.Code = EarningCodeToShow[63]) THEN BEGIN
                                                                                                                                                                                                                                                                                IF EarningAmountA <> ROUND(0.00001, 0.01, '=') THEN
                                                                                                                                                                                                                                                                                    EarningAmountToShow[63] := EarningAmountA
                                                                                                                                                                                                                                                                                ELSE
                                                                                                                                                                                                                                                                                    EarningAmountToShow[63] := 0.0;
                                                                                                                                                                                                                                                                            END ELSE
                                                                                                                                                                                                                                                                                IF (Earnings1.Code = EarningCodeToShow[64]) THEN BEGIN
                                                                                                                                                                                                                                                                                    IF EarningAmountA <> ROUND(0.00001, 0.01, '=') THEN
                                                                                                                                                                                                                                                                                        EarningAmountToShow[64] := EarningAmountA
                                                                                                                                                                                                                                                                                    ELSE
                                                                                                                                                                                                                                                                                        EarningAmountToShow[64] := 0.0;
                                                                                                                                                                                                                                                                                END ELSE
                                                                                                                                                                                                                                                                                    IF (Earnings1.Code = EarningCodeToShow[65]) THEN BEGIN
                                                                                                                                                                                                                                                                                        IF EarningAmountA <> ROUND(0.00001, 0.01, '=') THEN
                                                                                                                                                                                                                                                                                            EarningAmountToShow[65] := EarningAmountA
                                                                                                                                                                                                                                                                                        ELSE
                                                                                                                                                                                                                                                                                            EarningAmountToShow[65] := 0.0;
                                                                                                                                                                                                                                                                                    END ELSE
                                                                                                                                                                                                                                                                                        IF (Earnings1.Code = EarningCodeToShow[66]) THEN BEGIN
                                                                                                                                                                                                                                                                                            IF EarningAmountA <> ROUND(0.00001, 0.01, '=') THEN
                                                                                                                                                                                                                                                                                                EarningAmountToShow[66] := EarningAmountA
                                                                                                                                                                                                                                                                                            ELSE
                                                                                                                                                                                                                                                                                                EarningAmountToShow[66] := 0.0;
                                                                                                                                                                                                                                                                                        END ELSE
                                                                                                                                                                                                                                                                                            IF (Earnings1.Code = EarningCodeToShow[67]) THEN BEGIN
                                                                                                                                                                                                                                                                                                IF EarningAmountA <> ROUND(0.00001, 0.01, '=') THEN
                                                                                                                                                                                                                                                                                                    EarningAmountToShow[67] := EarningAmountA
                                                                                                                                                                                                                                                                                                ELSE
                                                                                                                                                                                                                                                                                                    EarningAmountToShow[67] := 0.0;
                                                                                                                                                                                                                                                                                            END ELSE
                                                                                                                                                                                                                                                                                                IF (Earnings1.Code = EarningCodeToShow[68]) THEN BEGIN
                                                                                                                                                                                                                                                                                                    IF EarningAmountA <> ROUND(0.00001, 0.01, '=') THEN
                                                                                                                                                                                                                                                                                                        EarningAmountToShow[68] := EarningAmountA
                                                                                                                                                                                                                                                                                                    ELSE
                                                                                                                                                                                                                                                                                                        EarningAmountToShow[68] := 0.0;
                                                                                                                                                                                                                                                                                                END ELSE
                                                                                                                                                                                                                                                                                                    IF (Earnings1.Code = EarningCodeToShow[69]) THEN BEGIN
                                                                                                                                                                                                                                                                                                        IF EarningAmountA <> ROUND(0.00001, 0.01, '=') THEN
                                                                                                                                                                                                                                                                                                            EarningAmountToShow[69] := EarningAmountA
                                                                                                                                                                                                                                                                                                        ELSE
                                                                                                                                                                                                                                                                                                            EarningAmountToShow[69] := 0.0;
                                                                                                                                                                                                                                                                                                    END ELSE
                                                                                                                                                                                                                                                                                                        IF (Earnings1.Code = EarningCodeToShow[70]) THEN BEGIN
                                                                                                                                                                                                                                                                                                            IF EarningAmountA <> ROUND(0.00001, 0.01, '=') THEN
                                                                                                                                                                                                                                                                                                                EarningAmountToShow[70] := EarningAmountA
                                                                                                                                                                                                                                                                                                            ELSE
                                                                                                                                                                                                                                                                                                                EarningAmountToShow[70] := 0.0;
                                                                                                                                                                                                                                                                                                        END

                END;
            UNTIL EmployeeEarnings1.NEXT = 0;
        END ELSE BEGIN
            EarningAmountToShow[1] := 0.0;
            EarningAmountToShow[2] := 0.0;
            EarningAmountToShow[3] := 0.0;
            EarningAmountToShow[4] := 0.0;
            EarningAmountToShow[5] := 0.0;
            EarningAmountToShow[6] := 0.0;
            EarningAmountToShow[7] := 0.0;
            EarningAmountToShow[8] := 0.0;
            EarningAmountToShow[9] := 0.0;
            EarningAmountToShow[10] := 0.0;
            EarningAmountToShow[11] := 0.0;
            EarningAmountToShow[12] := 0.0;
            EarningAmountToShow[13] := 0.0;
            EarningAmountToShow[14] := 0.0;
            EarningAmountToShow[15] := 0.0;
            EarningAmountToShow[16] := 0.0;
            EarningAmountToShow[17] := 0.0;
            EarningAmountToShow[18] := 0.0;
            EarningAmountToShow[19] := 0.0;
            EarningAmountToShow[20] := 0.0;
            EarningAmountToShow[21] := 0.0;
            EarningAmountToShow[22] := 0.0;
            EarningAmountToShow[23] := 0.0;
            EarningAmountToShow[24] := 0.0;
            EarningAmountToShow[25] := 0.0;
            EarningAmountToShow[26] := 0.0;
            EarningAmountToShow[27] := 0.0;
            EarningAmountToShow[28] := 0.0;
            EarningAmountToShow[29] := 0.0;
            EarningAmountToShow[30] := 0.0;
            EarningAmountToShow[31] := 0.0;
            EarningAmountToShow[32] := 0.0;
            EarningAmountToShow[33] := 0.0;
            EarningAmountToShow[34] := 0.0;
            EarningAmountToShow[35] := 0.0;
            EarningAmountToShow[36] := 0.0;
            EarningAmountToShow[37] := 0.0;
            EarningAmountToShow[38] := 0.0;
            EarningAmountToShow[39] := 0.0;
            EarningAmountToShow[40] := 0.0;
            EarningAmountToShow[41] := 0.0;
            EarningAmountToShow[42] := 0.0;
            EarningAmountToShow[43] := 0.0;
            EarningAmountToShow[44] := 0.0;
            EarningAmountToShow[45] := 0.0;
            EarningAmountToShow[46] := 0.0;
            EarningAmountToShow[47] := 0.0;
            EarningAmountToShow[48] := 0.0;
            EarningAmountToShow[49] := 0.0;
            EarningAmountToShow[50] := 0.0;
            EarningAmountToShow[51] := 0.0;
            EarningAmountToShow[52] := 0.0;
            EarningAmountToShow[53] := 0.0;
            EarningAmountToShow[54] := 0.0;
            EarningAmountToShow[55] := 0.0;
            EarningAmountToShow[56] := 0.0;
            EarningAmountToShow[57] := 0.0;
            EarningAmountToShow[58] := 0.0;
            EarningAmountToShow[59] := 0.0;
            EarningAmountToShow[60] := 0.0;
            EarningAmountToShow[61] := 0.0;
            EarningAmountToShow[62] := 0.0;
            EarningAmountToShow[63] := 0.0;
            EarningAmountToShow[64] := 0.0;
            EarningAmountToShow[65] := 0.0;
        END;
        //V1.0.1

        //Update Total Taxable Amount
        TotalTaxableAmount := BasicSalary + TotalTaxableEarnings;

    end;

    //=============================================
    procedure ProcessDeductions(EmployeeRec: Record Employee)
    var
        Deductions: Record Confidential;
        DeductionPreSSF: Record Confidential;
        Deductions1: Record Confidential;
        Deductions2: Record Confidential;
        DeductionCodesRec: Record Confidential;
        DeductIonCodesRec1: Record Confidential;
        EmployeeDeductions: Record "Earning And Dedcution";
        EmployeeDeductions1: Record "Earning And Dedcution";
        EmployeeDeductions2: Record "Earning And Dedcution";
        EmployeeDeductionPreSSF: Record "Earning And Dedcution";
        DeductionAmount: Decimal;
        DeductionAmountEmployer: Decimal;
        DeductionAmountB: Decimal;
        DeductionAmountEmployerB: Decimal;
        BasisAmount: Decimal;
        BasisAmountB: Decimal;
        Month: Integer;
        Year: Integer;
        Period: Code[10];
        LoanHeader: Record "Loan and Advance Header";
        AdvanceHeader: Record "Loan and Advance Header";
        LoanLine: Record "Loan and Advance Lines";
    begin
        // V1.0.3 Find all Pre-SSF Deductions
        EmployeeDeductionPreSSF.RESET;
        EmployeeDeductionPreSSF.SETRANGE(EmployeeDeductionPreSSF."Employee No.", EmployeeRec."No.");
        EmployeeDeductionPreSSF.SETRANGE(EmployeeDeductionPreSSF.Type, EmployeeDeductionPreSSF.Type::Deduction);
        IF EmployeeDeductionPreSSF.FINDSET THEN BEGIN
            REPEAT
                DeductionAmountB := 0;
                DeductionPreSSF.Reset();
                DeductionPreSSF.SetRange(DeductionPreSSF.Code, EmployeeDeductionPreSSF."Confidential Code");
                DeductionPreSSF.SetRange(DeductionPreSSF.Type, DeductionPreSSF.Type::Deduction);
                //DeductionPreSSF.GET(DeductionPreSSF.Type::Deduction, EmployeeDeductionPreSSF."Confidential Code")
                IF DeductionPreSSF.FindFirst() THEN BEGIN
                    IF DeductionPreSSF."Amount Basis" = DeductionPreSSF."Amount Basis"::"Fixed Amount" THEN BEGIN
                        DeductionAmountB := EmployeeDeductionPreSSF."Fixed Amount";
                    END ELSE
                        IF DeductionPreSSF."Amount Basis" = DeductionPreSSF."Amount Basis"::"Range Table" THEN BEGIN
                            IF DeductionPreSSF."Range Table Basis" = DeductionPreSSF."Range Table Basis"::"Basic Pay" THEN BEGIN
                                DeductionAmountB := GetAmountFromRangeTable(DeductionPreSSF."Range Table Code", BasicSalary);
                            END ELSE
                                IF DeductionPreSSF."Range Table Basis" = DeductionPreSSF."Range Table Basis"::"Gross Pay" THEN BEGIN
                                    DeductionAmountB := GetAmountFromRangeTable(DeductionPreSSF."Range Table Code", BasicSalary + TotalEarnings);
                                END ELSE
                                    IF DeductionPreSSF."Range Table Basis" = DeductionPreSSF."Range Table Basis"::"Taxable Pay" THEN BEGIN
                                        DeductionAmountB := GetAmountFromRangeTable(DeductionPreSSF."Range Table Code", BasicSalary + TotalTaxableEarnings);
                                    END;
                        END ELSE BEGIN
                            IF DeductionPreSSF."Is SS Contribution" THEN BEGIN
                                //BasisAmountB := BasicSalary + TotalSSFEarnings
                            END ELSE BEGIN
                                CASE DeductionPreSSF."Amount Basis" OF
                                    DeductionPreSSF."Amount Basis"::"Percentage of Basic Pay":
                                        BasisAmountB := BasicSalary;
                                    DeductionPreSSF."Amount Basis"::"Percentage of Gross Pay":
                                        BasisAmountB := BasicSalary + TotalEarnings;
                                    DeductionPreSSF."Amount Basis"::"Percentage of Taxable Pay":
                                        BasisAmountB := BasicSalary + TotalTaxableEarnings;
                                    DeductionPreSSF."Amount Basis"::"Income Tax Amount":
                                        DeductionAmountB := 0;
                                END;
                            END;
                            DeductionAmountB := ROUND((BasisAmountB * EmployeeDeductionPreSSF.Percentage * 0.01), 0.001, '='); //change
                        END;
                END;

                //Total Pre-SSF Deductions
                IF DeductionPreSSF."Pre-SSF Deductible" THEN
                    TotalPreSSFDeductions := TotalPreSSFDeductions + DeductionAmountB;
            UNTIL EmployeeDeductionPreSSF.NEXT = 0;
        END;
        // V1.0.3 ASL 24/07/2015

        EmployeeDeductions.RESET;
        EmployeeDeductions.SETRANGE(EmployeeDeductions."Employee No.", EmployeeRec."No.");
        EmployeeDeductions.SETRANGE(EmployeeDeductions.Type, EmployeeDeductions.Type::Deduction);
        IF EmployeeDeductions.FINDSET THEN BEGIN
            REPEAT
                DeductionAmount := 0;
                DeductionAmountEmployer := 0;
                Deductions.Reset();
                Deductions.SetRange(Deductions.Code, EmployeeDeductions."Confidential Code");
                Deductions.SetRange(Deductions.Type, Deductions.Type::Deduction);
                //Deductions.GET(Deductions.Type::Deduction, EmployeeDeductions."Confidential Code")
                IF Deductions.FindFirst() THEN BEGIN
                    IF Deductions."Amount Basis" = Deductions."Amount Basis"::"Fixed Amount" THEN BEGIN
                        DeductionAmount := EmployeeDeductions."Fixed Amount";
                    END ELSE
                        IF Deductions."Amount Basis" = Deductions."Amount Basis"::"Range Table" THEN BEGIN
                            IF Deductions."Range Table Basis" = Deductions."Range Table Basis"::"Basic Pay" THEN BEGIN
                                DeductionAmount := GetAmountFromRangeTable(Deductions."Range Table Code", BasicSalary);
                            END ELSE
                                IF Deductions."Range Table Basis" = Deductions."Range Table Basis"::"Gross Pay" THEN BEGIN
                                    DeductionAmount := GetAmountFromRangeTable(Deductions."Range Table Code", BasicSalary + TotalEarnings);
                                END ELSE
                                    IF Deductions."Range Table Basis" = Deductions."Range Table Basis"::"Taxable Pay" THEN BEGIN
                                        DeductionAmount := GetAmountFromRangeTable(Deductions."Range Table Code", BasicSalary + TotalTaxableEarnings);
                                    END;
                        END ELSE BEGIN
                            IF Deductions."Is SS Contribution" THEN
                                BasisAmount := BasicSalary + TotalSSFEarnings - TotalPreSSFDeductions
                            ELSE BEGIN
                                CASE Deductions."Amount Basis" OF
                                    Deductions."Amount Basis"::"Percentage of Basic Pay":
                                        BasisAmount := BasicSalary;
                                    Deductions."Amount Basis"::"Percentage of Gross Pay":
                                        BasisAmount := BasicSalary + TotalEarnings;
                                    Deductions."Amount Basis"::"Percentage of Taxable Pay":
                                        BasisAmount := BasicSalary + TotalTaxableEarnings;
                                    Deductions."Amount Basis"::"Income Tax Amount":
                                        DeductionAmount := 0;
                                END;
                            END;
                            DeductionAmount := ROUND((BasisAmount * EmployeeDeductions.Percentage * 0.01), 0.001, '='); //change
                        END;

                    IF Deductions."Has Employer Component" THEN BEGIN
                        IF Deductions."Employer Amount Basis" = Deductions."Employer Amount Basis"::"Fixed Amount" THEN
                            DeductionAmountEmployer := EmployeeDeductions."Employer Fixed Amount"
                        ELSE
                            IF Deductions."Employer Amount Basis" = Deductions."Employer Amount Basis"::"Range Table" THEN BEGIN
                                IF Deductions."Employer Range Table Basis" = Deductions."Employer Range Table Basis"::"Basic Pay" THEN
                                    DeductionAmountEmployer := GetAmountFromRangeTable(Deductions."Employer Range Table Code", BasicSalary)
                                ELSE
                                    IF Deductions."Employer Range Table Basis" = Deductions."Employer Range Table Basis"::"Gross Pay" THEN
                                        DeductionAmountEmployer := GetAmountFromRangeTable(Deductions."Employer Range Table Code", BasicSalary + TotalEarnings)
                                    ELSE
                                        IF Deductions."Employer Range Table Basis" = Deductions."Employer Range Table Basis"::"Taxable Pay" THEN
                                            DeductionAmountEmployer := GetAmountFromRangeTable(Deductions."Employer Range Table Code", BasicSalary + TotalTaxableEarnings);
                            END ELSE BEGIN
                                DeductionAmountEmployer := ROUND((BasisAmount * EmployeeDeductions."Employer Percentage" * 0.01), 0.001, '='); //change
                            END;

                        /* {
                         CASE Deductions."Employer Amount Basis" OF
                             Deductions."Employer Amount Basis"::"Fixed Amount":
                                 DeductionAmountEmployer := EmployeeDeductions."Employer Fixed Amount";
                             Deductions."Employer Amount Basis"::"Percentage of Basic Pay":
                                 DeductionAmountEmployer := ROUND((BasicSalary * EmployeeDeductions."Employer Percentage" * 0.01), 1.0, '=');
                             Deductions."Employer Amount Basis"::"Percentage of Gross Pay":
                                 DeductionAmountEmployer := ROUND(((BasicSalary + TotalEarnings) * EmployeeDeductions."Employer Percentage" * 0.01), 1.0, '=');
                             Deductions."Employer Amount Basis"::"Percentage of Taxable Pay":
                                 DeductionAmountEmployer := ROUND(((BasicSalary + TotalTaxableEarnings) * EmployeeDeductions."Employer Percentage" * 0.01), 1.0, '=');
                             Deductions."Employer Amount Basis"::"Range Table":
                                 BEGIN
                                     IF Deductions."Employer Range Table Basis" = Deductions."Employer Range Table Basis"::"Basic Pay" THEN
                                         DeductionAmountEmployer := GetAmountFromRangeTable(Deductions."Employer Range Table Code", BasicSalary)
                                     ELSE
                                         IF Deductions."Employer Range Table Basis" = Deductions."Employer Range Table Basis"::"Gross Pay" THEN
                                             DeductionAmountEmployer := GetAmountFromRangeTable(Deductions."Employer Range Table Code",
                                                                                                BasicSalary + TotalEarnings)
                                         ELSE
                                             IF Deductions."Employer Range Table Basis" = Deductions."Employer Range Table Basis"::"Taxable Pay" THEN
                                                 DeductionAmountEmployer
                                                       := GetAmountFromRangeTable(Deductions."Employer Range Table Code", BasicSalary + TotalTaxableEarnings);
                                 END;
                                        END;
                         }*/
                    END;
                END;

                IF ProcessingOption = ProcessingOption::"Generate Payroll Journals" THEN BEGIN
                    //Debit Employer Amount Expense
                    IF DeductionAmountEmployer <> 0 THEN BEGIN
                        IF Deductions."Expense Posting Type" = Deductions."Expense Posting Type"::Individual THEN BEGIN
                            IF ProcessingOption = ProcessingOption::"Generate Payroll Journals" THEN BEGIN
                                InsertJournalLine(Deductions.Code, EmployeeRec."Statistics Group Code", EmployeeRec."No.",
                                              "Employee Statistics Group"."Payroll Journal Template Name",
                                              "Employee Statistics Group"."Payroll Journal Batch Name",
                                              GlobalAccountType::"G/L Account", Deductions."Expense Account No."
                                              , PostingDate, DocumentNo,
                                              COPYSTR(EmployeeRec."Full Name",
                                              1, 50), '', DeductionAmountEmployer, FALSE);
                            END;
                        END ELSE BEGIN
                            AddToBlockDeductionItems(Deductions.Code, Deductions.Description, DeductionAmountEmployer, 0);
                        END;
                    END;

                    //Credit Employee + Employer Amount To Payable Account
                    IF (DeductionAmount + DeductionAmountEmployer) <> 0 THEN BEGIN
                        IF Deductions."Payable Posting Type" = Deductions."Payable Posting Type"::Individual THEN BEGIN
                            IF ProcessingOption = ProcessingOption::"Generate Payroll Journals" THEN BEGIN
                                //Credit Deduction Payable Amount (Employer + Employee Amount)
                                InsertJournalLine(Deductions.Code, EmployeeRec."Statistics Group Code", EmployeeRec."No.",
                                                  "Employee Statistics Group"."Payroll Journal Template Name",
                                                  "Employee Statistics Group"."Payroll Journal Batch Name", Deductions."Account Type",
                                                  Deductions."Account No.",
                                                  PostingDate,
                                                  DocumentNo,
                                                  COPYSTR(EmployeeRec."Full Name",
                                                  1, 50), '', -(DeductionAmount + DeductionAmountEmployer), FALSE);
                            END;
                        END ELSE BEGIN
                            AddToBlockDeductionItems(Deductions.Code, Deductions.Description, 0, (DeductionAmount + DeductionAmountEmployer));
                        END;
                    END;
                END ELSE
                    IF ProcessingOption = ProcessingOption::"Close Payroll Period" THEN BEGIN
                        InsertPayrollLedgerEntry(EmployeeRec."No.", EmployeeRec."Statistics Group Code", Deductions.Code,
                                                 Deductions.Description, PayrollEntryType::Deduction,
                                                 Deductions."Pre-Tax Deductible", DeductionAmount, DeductionAmountEmployer);

                        IF Deductions.Recurrence = Deductions.Recurrence::Never THEN BEGIN
                            // V1.0.2 Update loan clearance on closing the payroll period
                            Month := DATE2DMY(PostingDate, 2);
                            Year := DATE2DMY(PostingDate, 3);
                            Period := FORMAT(Month) + '-' + FORMAT(Year);
                            IF (EmployeeDeductions."ED Type" = EmployeeDeductions."ED Type"::Loan) THEN BEGIN
                                LoanHeader.RESET;
                                LoanHeader.SETRANGE("Document Type", LoanHeader."Document Type"::Loan);
                                LoanHeader.SETFILTER("No.", '<>%1', '');
                                LoanHeader.SETRANGE("Employee No.", EmployeeRec."No.");
                                IF LoanHeader.FINDFIRST THEN BEGIN
                                    LoanLine.RESET;
                                    LoanLine.SETRANGE("Document Type", LoanLine."Document Type"::Loan);
                                    LoanLine.SETFILTER("Document No.", LoanHeader."No.");
                                    LoanLine.SETRANGE(Period, Period);
                                    LoanLine.SETRANGE("Loan Cleared", FALSE);
                                    IF LoanLine.FINDFIRST THEN BEGIN
                                        LoanLine.VALIDATE("Loan Cleared", TRUE);
                                        LoanLine.MODIFY;
                                    END;
                                END;
                                // V1.0.2 Update loan clearance on closing the payroll period
                            END ELSE
                                IF (EmployeeDeductions."ED Type" = EmployeeDeductions."ED Type"::Interest) THEN BEGIN
                                    // V1.0.2 Update interest clearance on closing the payroll period
                                    LoanHeader.RESET;
                                    LoanHeader.SETRANGE("Document Type", LoanHeader."Document Type"::Loan);
                                    LoanHeader.SETFILTER("No.", '<>%1', '');
                                    LoanHeader.SETRANGE("Employee No.", EmployeeRec."No.");
                                    IF LoanHeader.FINDFIRST THEN BEGIN
                                        LoanLine.RESET;
                                        LoanLine.SETRANGE("Document Type", LoanLine."Document Type"::Loan);
                                        LoanLine.SETRANGE("Document No.", LoanHeader."No.");
                                        LoanLine.SETRANGE(Period, Period);
                                        LoanLine.SETFILTER(Interest, '<>%1', 0);
                                        LoanLine.SETRANGE("Interest Cleared", FALSE);
                                        IF LoanLine.FINDFIRST THEN BEGIN
                                            LoanLine.VALIDATE("Interest Cleared", TRUE);
                                            LoanLine.MODIFY;
                                        END;
                                    END;
                                    // V1.0.2 Update Salary Advance clearance on closing the payroll
                                END ELSE
                                    IF (EmployeeDeductions."ED Type" = EmployeeDeductions."ED Type"::Advance) THEN BEGIN
                                        LoanHeader.RESET;
                                        LoanHeader.SETRANGE("Document Type", LoanHeader."Document Type"::Advance);
                                        LoanHeader.SETFILTER("No.", '<>%1', '');
                                        LoanHeader.SETRANGE("Employee No.", EmployeeRec."No.");
                                        IF LoanHeader.FINDFIRST THEN BEGIN
                                            LoanLine.RESET;
                                            LoanLine.SETRANGE("Document Type", LoanLine."Document Type"::Advance);
                                            LoanLine.SETRANGE("Document No.", LoanHeader."No.");
                                            LoanLine.SETRANGE(Period, Period);
                                            LoanLine.SETRANGE("Advance Cleared", FALSE);
                                            IF LoanLine.FINDFIRST THEN BEGIN
                                                LoanLine.VALIDATE("Advance Cleared", TRUE);
                                                LoanLine.MODIFY;
                                            END;
                                        END;
                                    END;
                            EmployeeDeductions.DELETE;
                        END ELSE
                            IF Deductions.Recurrence = Deductions.Recurrence::"On Balance" THEN BEGIN
                                IF Deductions."Increasing Balance" THEN BEGIN
                                    EmployeeDeductions."Current Balance" += DeductionAmount;
                                    EmployeeDeductions.MODIFY;
                                    IF EmployeeDeductions."Current Balance" >= EmployeeDeductions."Threshold Balance" THEN;
                                    EmployeeDeductions.DELETE;
                                END ELSE BEGIN
                                    EmployeeDeductions."Current Balance" -= DeductionAmount;
                                    EmployeeDeductions.MODIFY;
                                    IF EmployeeDeductions."Current Balance" <= EmployeeDeductions."Threshold Balance" THEN
                                        EmployeeDeductions.DELETE;
                                END;
                            END;
                    END;

                //Total Pre-Tax Deductions
                IF Deductions."Pre-Tax Deductible" THEN
                    TotalPreTaxDeductions := TotalPreTaxDeductions + DeductionAmount;

                //Total Deductions
                TotalDeductions := TotalDeductions + DeductionAmount;

                IF Deductions."Is SS Contribution" THEN BEGIN
                    SSFAmount := DeductionAmount;
                    SSFAmountEmployer := DeductionAmountEmployer;
                END;
            UNTIL EmployeeDeductions.NEXT = 0;
        END;

        // V1.0.1 Addition: Show Deduction Codes and Amount on report
        DeductionCodesRec.RESET;
        DeductionCodesRec.SETRANGE(Type, DeductionCodesRec.Type::Deduction);
        //DeductionCodesRec.SETRANGE("Include on Report", TRUE);
        DeductionCodesRec.SETRANGE("Is SS Contribution", FALSE);
        IF DeductionCodesRec.FINDFIRST THEN BEGIN
            J := 1;
            REPEAT
                IF (DeductionCodesRec."ED Type" = DeductionCodesRec."ED Type"::Loan) OR (DeductionCodesRec."ED Type" = DeductionCodesRec."ED Type"::Interest) THEN
                    DeductionCodeToShowL[J] := DeductionCodesRec.Code
                ELSE
                    DeductionCodeToShowL[J] := '';

                DeductionCodeToShow[J] := DeductionCodesRec.Code;
                IF DeductionCodesRec."Include on Report" THEN BEGIN
                    IF (DeductionCodesRec."ED Type" = DeductionCodesRec."ED Type"::Loan) OR (DeductionCodesRec."ED Type" = DeductionCodesRec."ED Type"::Interest) THEN
                        DeductionIncludeLoan[J] := TRUE
                    ELSE
                        DeductionIncludeLoan[J] := FALSE;

                    DeductionInclude[J] := TRUE
                END ELSE BEGIN
                    DeductionInclude[J] := FALSE;
                    DeductionIncludeLoan[J] := FALSE;
                END;
                J += 1;
            UNTIL DeductionCodesRec.NEXT = 0;
        END;
        EmployeeDeductions1.RESET;
        EmployeeDeductions1.SETRANGE(EmployeeDeductions1."Employee No.", EmployeeRec."No.");
        EmployeeDeductions1.SETRANGE(EmployeeDeductions1.Type, EmployeeDeductions1.Type::Deduction);
        IF EmployeeDeductions1.FINDSET THEN BEGIN
            REPEAT
                DeductionAmountA := 0;
                Deductions1.RESET;
                Deductions1.SETRANGE(Type, Deductions1.Type::Deduction);
                Deductions1.SETRANGE(Code, EmployeeDeductions1."Confidential Code");
                Deductions1.SETRANGE("Include on Report", TRUE);
                Deductions1.SETRANGE("Is SS Contribution", FALSE);
                IF Deductions1.FINDFIRST THEN BEGIN
                    IF Deductions1."Amount Basis" = Deductions1."Amount Basis"::"Fixed Amount" THEN BEGIN
                        DeductionAmountA := EmployeeDeductions1."Fixed Amount";
                    END ELSE
                        IF Deductions1."Amount Basis" = Deductions1."Amount Basis"::"Range Table" THEN BEGIN
                            IF Deductions1."Range Table Basis" = Deductions1."Range Table Basis"::"Basic Pay" THEN BEGIN
                                DeductionAmountA := GetAmountFromRangeTable(Deductions1."Range Table Code", BasicSalary);
                            END ELSE
                                IF Deductions1."Range Table Basis" = Deductions1."Range Table Basis"::"Gross Pay" THEN BEGIN
                                    DeductionAmountA := GetAmountFromRangeTable(Deductions1."Range Table Code", BasicSalary + TotalEarnings);
                                END ELSE
                                    IF Deductions1."Range Table Basis" = Deductions1."Range Table Basis"::"Taxable Pay" THEN BEGIN
                                        DeductionAmountA := GetAmountFromRangeTable(Deductions1."Range Table Code", BasicSalary + TotalTaxableEarnings);
                                    END
                        END ELSE BEGIN
                            DeductionAmountA := ROUND((BasisAmount * EmployeeDeductions1.Percentage * 0.01), 0.001, '='); //change
                        END;

                    IF (Deductions1.Code = DeductionCodeToShow[1]) THEN BEGIN
                        IF Deductions1.Code = 'SALADV' THEN BEGIN
                            //Display Salary advance Column name
                            DeductionCodeToShow[1] := 'Salary Advance';
                        END;

                        IF DeductionAmountA <> ROUND(0.00001, 0.01, '=') THEN
                            DeductionAmountToShow[1] := DeductionAmountA
                        ELSE
                            DeductionAmountToShow[1] := 0.0
                    END ELSE
                        IF (Deductions1.Code = DeductionCodeToShow[2]) THEN BEGIN
                            IF Deductions1.Code = 'SALADV' THEN BEGIN
                                //Display Salary advance Column name
                                DeductionCodeToShow[2] := 'Salary Advance';
                            END;

                            IF DeductionAmountA <> ROUND(0.00001, 0.01, '=') THEN
                                DeductionAmountToShow[2] := DeductionAmountA
                            ELSE
                                DeductionAmountToShow[2] := 0.0;
                        END ELSE
                            IF (Deductions1.Code = DeductionCodeToShow[3]) THEN BEGIN
                                IF Deductions1.Code = 'SALADV' THEN BEGIN
                                    //Display Salary advance Column name
                                    DeductionCodeToShow[3] := 'Salary Advance';
                                END;

                                IF DeductionAmountA <> ROUND(0.00001, 0.01, '=') THEN
                                    DeductionAmountToShow[3] := DeductionAmountA
                                ELSE
                                    DeductionAmountToShow[3] := 0.0;
                            END ELSE
                                IF (Deductions1.Code = DeductionCodeToShow[4]) THEN BEGIN
                                    IF Deductions1.Code = 'SALADV' THEN BEGIN
                                        //Display Salary advance Column name
                                        DeductionCodeToShow[4] := 'Salary Advance';
                                    END;

                                    IF DeductionAmountA <> ROUND(0.00001, 0.01, '=') THEN
                                        DeductionAmountToShow[4] := DeductionAmountA
                                    ELSE
                                        DeductionAmountToShow[4] := 0.0;
                                END ELSE
                                    IF (Deductions1.Code = DeductionCodeToShow[5]) THEN BEGIN
                                        IF Deductions1.Code = 'SALADV' THEN BEGIN
                                            //Display Salary advance Column name
                                            DeductionCodeToShow[5] := 'Salary Advance';
                                        END;

                                        IF DeductionAmountA <> ROUND(0.00001, 0.01, '=') THEN
                                            DeductionAmountToShow[5] := DeductionAmountA
                                        ELSE
                                            DeductionAmountToShow[5] := 0.0;
                                    END ELSE
                                        IF (Deductions1.Code = DeductionCodeToShow[6]) THEN BEGIN
                                            IF Deductions1.Code = 'SALADV' THEN BEGIN
                                                //Display Salary advance Column name
                                                DeductionCodeToShow[6] := 'Salary Advance';
                                            END;

                                            IF DeductionAmountA <> ROUND(0.00001, 0.01, '=') THEN
                                                DeductionAmountToShow[6] := DeductionAmountA
                                            ELSE
                                                DeductionAmountToShow[6] := 0.0;
                                        END ELSE
                                            IF (Deductions1.Code = DeductionCodeToShow[7]) THEN BEGIN
                                                IF Deductions1.Code = 'SALADV' THEN BEGIN
                                                    //Display Salary advance Column name
                                                    DeductionCodeToShow[7] := 'Salary Advance';
                                                END;

                                                IF DeductionAmountA <> ROUND(0.00001, 0.01, '=') THEN
                                                    DeductionAmountToShow[7] := DeductionAmountA
                                                ELSE
                                                    DeductionAmountToShow[7] := 0.0;
                                            END ELSE
                                                IF (Deductions1.Code = DeductionCodeToShow[8]) THEN BEGIN
                                                    IF Deductions1.Code = 'SALADV' THEN BEGIN
                                                        //Display Salary advance Column name
                                                        DeductionCodeToShow[8] := 'Salary Advance';
                                                    END;

                                                    IF DeductionAmountA <> ROUND(0.00001, 0.01, '=') THEN
                                                        DeductionAmountToShow[8] := DeductionAmountA
                                                    ELSE
                                                        DeductionAmountToShow[8] := 0.0;
                                                END ELSE
                                                    IF (Deductions1.Code = DeductionCodeToShow[9]) THEN BEGIN
                                                        IF Deductions1.Code = 'SALADV' THEN BEGIN
                                                            //Display Salary advance Column name
                                                            DeductionCodeToShow[9] := 'Salary Advance';
                                                        END;

                                                        IF DeductionAmountA <> ROUND(0.00001, 0.01, '=') THEN
                                                            DeductionAmountToShow[9] := DeductionAmountA
                                                        ELSE
                                                            DeductionAmountToShow[9] := 0.0;
                                                    END ELSE
                                                        IF (Deductions1.Code = DeductionCodeToShow[10]) THEN BEGIN
                                                            IF Deductions1.Code = 'SALADV' THEN BEGIN
                                                                //Display Salary advance Column name
                                                                DeductionCodeToShow[10] := 'Salary Advance';
                                                            END;

                                                            IF DeductionAmountA <> ROUND(0.00001, 0.01, '=') THEN
                                                                DeductionAmountToShow[10] := DeductionAmountA
                                                            ELSE
                                                                DeductionAmountToShow[10] := 0.0;
                                                        END ELSE
                                                            IF (Deductions1.Code = DeductionCodeToShow[11]) THEN BEGIN
                                                                IF Deductions1.Code = 'SALADV' THEN BEGIN
                                                                    //Display Salary advance Column name
                                                                    DeductionCodeToShow[11] := 'Salary Advance';
                                                                END;

                                                                IF DeductionAmountA <> ROUND(0.00001, 0.01, '=') THEN
                                                                    DeductionAmountToShow[11] := DeductionAmountA
                                                                ELSE
                                                                    DeductionAmountToShow[11] := 0.0;
                                                            END ELSE
                                                                IF (Deductions1.Code = DeductionCodeToShow[12]) THEN BEGIN
                                                                    IF Deductions1.Code = 'SALADV' THEN BEGIN
                                                                        //Display Salary advance Column name
                                                                        DeductionCodeToShow[12] := 'Salary Advance';
                                                                    END;

                                                                    IF DeductionAmountA <> ROUND(0.00001, 0.01, '=') THEN
                                                                        DeductionAmountToShow[12] := DeductionAmountA
                                                                    ELSE
                                                                        DeductionAmountToShow[12] := 0.0;
                                                                END ELSE
                                                                    IF (Deductions1.Code = DeductionCodeToShow[13]) THEN BEGIN
                                                                        IF Deductions1.Code = 'SALADV' THEN BEGIN
                                                                            //Display Salary advance Column name
                                                                            DeductionCodeToShow[13] := 'Salary Advance';
                                                                        END;

                                                                        IF DeductionAmountA <> ROUND(0.00001, 0.01, '=') THEN
                                                                            DeductionAmountToShow[13] := DeductionAmountA
                                                                        ELSE
                                                                            DeductionAmountToShow[13] := 0.0;
                                                                    END ELSE
                                                                        IF (Deductions1.Code = DeductionCodeToShow[14]) THEN BEGIN
                                                                            IF Deductions1.Code = 'SALADV' THEN BEGIN
                                                                                //Display Salary advance Column name
                                                                                DeductionCodeToShow[14] := 'Salary Advance';
                                                                            END;

                                                                            IF DeductionAmountA <> ROUND(0.00001, 0.01, '=') THEN
                                                                                DeductionAmountToShow[14] := DeductionAmountA
                                                                            ELSE
                                                                                DeductionAmountToShow[14] := 0.0;
                                                                        END ELSE
                                                                            IF (Deductions1.Code = DeductionCodeToShow[15]) THEN BEGIN
                                                                                IF Deductions1.Code = 'SALADV' THEN BEGIN
                                                                                    //Display Salary advance Column name
                                                                                    DeductionCodeToShow[15] := 'Salary Advance';
                                                                                END;

                                                                                IF DeductionAmountA <> ROUND(0.00001, 0.01, '=') THEN
                                                                                    DeductionAmountToShow[15] := DeductionAmountA
                                                                                ELSE
                                                                                    DeductionAmountToShow[15] := 0.0;
                                                                            END ELSE
                                                                                IF (Deductions1.Code = DeductionCodeToShow[16]) THEN BEGIN
                                                                                    IF Deductions1.Code = 'SALADV' THEN BEGIN
                                                                                        //Display Salary advance Column name
                                                                                        DeductionCodeToShow[16] := 'Salary Advance';
                                                                                    END;

                                                                                    IF DeductionAmountA <> ROUND(0.00001, 0.01, '=') THEN
                                                                                        DeductionAmountToShow[16] := DeductionAmountA
                                                                                    ELSE
                                                                                        DeductionAmountToShow[16] := 0.0;
                                                                                END ELSE
                                                                                    IF (Deductions1.Code = DeductionCodeToShow[17]) THEN BEGIN
                                                                                        IF Deductions1.Code = 'SALADV' THEN BEGIN
                                                                                            //Display Salary advance Column name
                                                                                            DeductionCodeToShow[17] := 'Salary Advance';
                                                                                        END;

                                                                                        IF DeductionAmountA <> ROUND(0.00001, 0.01, '=') THEN
                                                                                            DeductionAmountToShow[17] := DeductionAmountA
                                                                                        ELSE
                                                                                            DeductionAmountToShow[17] := 0.0;
                                                                                    END ELSE
                                                                                        IF (Deductions1.Code = DeductionCodeToShow[18]) THEN BEGIN
                                                                                            IF Deductions1.Code = 'SALADV' THEN BEGIN
                                                                                                //Display Salary advance Column name
                                                                                                DeductionCodeToShow[18] := 'Salary Advance';
                                                                                            END;

                                                                                            IF DeductionAmountA <> ROUND(0.00001, 0.01, '=') THEN
                                                                                                DeductionAmountToShow[18] := DeductionAmountA
                                                                                            ELSE
                                                                                                DeductionAmountToShow[18] := 0.0;
                                                                                        END ELSE
                                                                                            IF (Deductions1.Code = DeductionCodeToShow[19]) THEN BEGIN
                                                                                                IF Deductions1.Code = 'SALADV' THEN BEGIN
                                                                                                    //Display Salary advance Column name
                                                                                                    DeductionCodeToShow[19] := 'Salary Advance';
                                                                                                END;

                                                                                                IF DeductionAmountA <> ROUND(0.00001, 0.01, '=') THEN
                                                                                                    DeductionAmountToShow[19] := DeductionAmountA
                                                                                                ELSE
                                                                                                    DeductionAmountToShow[19] := 0.0;
                                                                                            END ELSE
                                                                                                IF (Deductions1.Code = DeductionCodeToShow[20]) THEN BEGIN
                                                                                                    IF Deductions1.Code = 'SALADV' THEN BEGIN
                                                                                                        //Display Salary advance Column name
                                                                                                        DeductionCodeToShow[20] := 'Salary Advance';
                                                                                                    END;

                                                                                                    IF DeductionAmountA <> ROUND(0.00001, 0.01, '=') THEN
                                                                                                        DeductionAmountToShow[20] := DeductionAmountA
                                                                                                    ELSE
                                                                                                        DeductionAmountToShow[20] := 0.0;
                                                                                                END ELSE BEGIN
                                                                                                    DeductionAmountToShow[1] := 0.0;
                                                                                                    DeductionAmountToShow[2] := 0.0;
                                                                                                    DeductionAmountToShow[3] := 0.0;
                                                                                                    DeductionAmountToShow[4] := 0.0;
                                                                                                    DeductionAmountToShow[5] := 0.0;
                                                                                                    DeductionAmountToShow[6] := 0.0;
                                                                                                    DeductionAmountToShow[7] := 0.0;
                                                                                                    DeductionAmountToShow[8] := 0.0;
                                                                                                    DeductionAmountToShow[9] := 0.0;
                                                                                                    DeductionAmountToShow[10] := 0.0;
                                                                                                    DeductionAmountToShow[11] := 0.0;
                                                                                                    DeductionAmountToShow[12] := 0.0;
                                                                                                    DeductionAmountToShow[13] := 0.0;
                                                                                                    DeductionAmountToShow[14] := 0.0;
                                                                                                    DeductionAmountToShow[15] := 0.0;
                                                                                                    DeductionAmountToShow[16] := 0.0;
                                                                                                    DeductionAmountToShow[17] := 0.0;
                                                                                                    DeductionAmountToShow[18] := 0.0;
                                                                                                    DeductionAmountToShow[19] := 0.0;
                                                                                                    DeductionAmountToShow[20] := 0.0;
                                                                                                    DeductionAmountToShow[21] := 0.0;
                                                                                                    DeductionAmountToShow[22] := 0.0;
                                                                                                    DeductionAmountToShow[23] := 0.0;
                                                                                                    DeductionAmountToShow[24] := 0.0;
                                                                                                    DeductionAmountToShow[25] := 0.0;
                                                                                                    DeductionAmountToShow[26] := 0.0;
                                                                                                    DeductionAmountToShow[27] := 0.0;
                                                                                                    DeductionAmountToShow[28] := 0.0;
                                                                                                    DeductionAmountToShow[29] := 0.0;
                                                                                                    DeductionAmountToShow[30] := 0.0;
                                                                                                    DeductionAmountToShow[31] := 0.0;
                                                                                                    DeductionAmountToShow[32] := 0.0;
                                                                                                    DeductionAmountToShow[33] := 0.0;
                                                                                                    DeductionAmountToShow[34] := 0.0;
                                                                                                    DeductionAmountToShow[35] := 0.0;
                                                                                                    DeductionAmountToShow[36] := 0.0;
                                                                                                    DeductionAmountToShow[37] := 0.0;
                                                                                                    DeductionAmountToShow[38] := 0.0;
                                                                                                    DeductionAmountToShow[39] := 0.0;
                                                                                                    DeductionAmountToShow[40] := 0.0;
                                                                                                END;

                END;
            UNTIL EmployeeDeductions1.NEXT = 0;
        END ELSE BEGIN
            DeductionAmountToShow[1] := 0.0;
            DeductionAmountToShow[2] := 0.0;
            DeductionAmountToShow[3] := 0.0;
            DeductionAmountToShow[4] := 0.0;
            DeductionAmountToShow[5] := 0.0;
            DeductionAmountToShow[6] := 0.0;
            DeductionAmountToShow[7] := 0.0;
            DeductionAmountToShow[8] := 0.0;
            DeductionAmountToShow[9] := 0.0;
            DeductionAmountToShow[10] := 0.0;
            DeductionAmountToShow[11] := 0.0;
            DeductionAmountToShow[12] := 0.0;
            DeductionAmountToShow[13] := 0.0;
            DeductionAmountToShow[14] := 0.0;
            DeductionAmountToShow[15] := 0.0;
            DeductionAmountToShow[16] := 0.0;
            DeductionAmountToShow[17] := 0.0;
            DeductionAmountToShow[18] := 0.0;
            DeductionAmountToShow[19] := 0.0;
            DeductionAmountToShow[20] := 0.0;
            DeductionAmountToShow[21] := 0.0;
            DeductionAmountToShow[22] := 0.0;
            DeductionAmountToShow[23] := 0.0;
            DeductionAmountToShow[24] := 0.0;
            DeductionAmountToShow[25] := 0.0;
            DeductionAmountToShow[26] := 0.0;
            DeductionAmountToShow[27] := 0.0;
            DeductionAmountToShow[28] := 0.0;
            DeductionAmountToShow[29] := 0.0;
            DeductionAmountToShow[30] := 0.0;
            DeductionAmountToShow[31] := 0.0;
            DeductionAmountToShow[32] := 0.0;
            DeductionAmountToShow[33] := 0.0;
            DeductionAmountToShow[34] := 0.0;
            DeductionAmountToShow[35] := 0.0;
            DeductionAmountToShow[36] := 0.0;
            DeductionAmountToShow[37] := 0.0;
            DeductionAmountToShow[38] := 0.0;
            DeductionAmountToShow[39] := 0.0;
            DeductionAmountToShow[40] := 0.0;
        END;
        TotalTaxableAmount := (BasicSalary + TotalTaxableEarnings) - TotalPreTaxDeductions;

    end;

    //============================================
    procedure ProcessIncomeTax(EmployeeRec: Record Employee)
    var
        TaxableAmountLCY: Decimal;
    begin
        HRSetup.GET;
        IncomeTax := GetAmountFromRangeTable(HRSetup."Income Tax Range Table Code", BasicSalary + TotalTaxableEarnings - TotalPreTaxDeductions);
        IF IncomeTax <> 0 THEN BEGIN
            IF ProcessingOption = ProcessingOption::"Generate Payroll Journals" THEN BEGIN
                IF HRSetup."Tax Payable Posting Type" = HRSetup."Tax Payable Posting Type"::Individual THEN BEGIN
                    //Credit Income Tax Payable Amount
                    InsertJournalLine(HRSetup."Income Tax Range Table Code", EmployeeRec."Statistics Group Code", EmployeeRec."No.",
                                      "Employee Statistics Group"."Payroll Journal Template Name",
                                      "Employee Statistics Group"."Payroll Journal Batch Name",
                                      HRSetup."Income Tax Payable Acc. Type",
                                      HRSetup."Income Tax Payable Acc. No.",
                                      PostingDate,
                                      DocumentNo,
                                      COPYSTR(EmployeeRec."Full Name",
                                      1, 50), '', -IncomeTax, FALSE);
                END ELSE BEGIN
                    AddToBlockDeductionItems('TAX', 'TAX', 0, IncomeTax);
                END;
            END ELSE
                IF ProcessingOption = ProcessingOption::"Close Payroll Period" THEN BEGIN
                    InsertPayrollLedgerEntry(EmployeeRec."No.", EmployeeRec."Statistics Group Code", HRSetup."Income Tax Range Table Code",
                                           HRSetup."Income Tax Range Table Code", PayrollEntryType::"Income Tax",
                                           TRUE, IncomeTax, 0);
                END;
        END;
    end;

    //=======================================
    procedure ProcessLocalTax(EmployeeRec: Record Employee)
    var
        TaxableAmountLCY: Decimal;
    begin
        HRSetup.GET;
        LocalTax := GetAmountFromRangeTable(HRSetup."Local Tax Range Table Code", BasicSalary + TotalTaxableEarnings - TotalPreTaxDeductions - IncomeTax);
        IF LocalTax <> 0 THEN BEGIN
            IF ProcessingOption = ProcessingOption::"Generate Payroll Journals" THEN BEGIN
                IF HRSetup."Tax Payable Posting Type" = HRSetup."Tax Payable Posting Type"::Individual THEN BEGIN
                    //Credit Income Tax Payable Amount
                    InsertJournalLine(HRSetup."Local Tax Range Table Code", EmployeeRec."Statistics Group Code", EmployeeRec."No.",
                                      "Employee Statistics Group"."Payroll Journal Template Name",
                                      "Employee Statistics Group"."Payroll Journal Batch Name",
                                      HRSetup."Local Tax Payable Acc. Type",
                                      HRSetup."Local Tax Payable Acc. No.",
                                      PostingDate,
                                      DocumentNo,
                                      COPYSTR(EmployeeRec."Full Name",
                                      1, 50), '', -LocalTax, FALSE);
                END ELSE BEGIN
                    AddToBlockDeductionItems('LST', 'LST', 0, LocalTax);
                END;
            END ELSE
                IF ProcessingOption = ProcessingOption::"Close Payroll Period" THEN BEGIN
                    InsertPayrollLedgerEntry(EmployeeRec."No.", EmployeeRec."Statistics Group Code", HRSetup."Local Tax Range Table Code",
                                           HRSetup."Local Tax Range Table Code", PayrollEntryType::"Local Service Tax",
                                           TRUE, LocalTax, 0);
                END;
        END;
    end;

    //======================================
    procedure ProcessNetPay(EmployeeRec: Record Employee)
    var
        myInt: Integer;
    begin
        NetPay := BasicSalary + TotalEarnings - (TotalDeductions + IncomeTax + LocalTax);
        IF NetPay <> 0 THEN BEGIN
            IF ProcessingOption = ProcessingOption::"Generate Payroll Journals" THEN BEGIN

                IF "Employee Statistics Group"."Net Pay Payable Posting Type" =
                        "Employee Statistics Group"."Net Pay Payable Posting Type"::Individual THEN BEGIN
                    //Credit Salary Payable
                    InsertJournalLine('', EmployeeRec."Statistics Group Code", EmployeeRec."No.",
                                      "Employee Statistics Group"."Payroll Journal Template Name",
                                      "Employee Statistics Group"."Payroll Journal Batch Name",
                                      "Employee Statistics Group"."Salaries Payable Acc. Type", "Employee Statistics Group"."Salaries Payable Acc. No.",
                                      PostingDate, DocumentNo,
                                      COPYSTR(EmployeeRec."Full Name", 1, 50),
                                      '', -NetPay, FALSE);
                END ELSE BEGIN
                    AddToBlockDeductionItems('NETPAY', 'Net Salaries', 0, NetPay);
                END;
            END ELSE
                IF ProcessingOption = ProcessingOption::"Close Payroll Period" THEN BEGIN
                    InsertPayrollLedgerEntry(EmployeeRec."No.", EmployeeRec."Statistics Group Code", 'NETPAY',
                                             'Net Salary', PayrollEntryType::"Net Salary Payable",
                                             TRUE, NetPay, 0);
                END;
        END;
    end;

    //====================================
    procedure InsertJournalLine(EDCode: Code[10]; EmpStatsGroup: Code[10]; EmployeeNo: Code[20]; JournalTemplateName: Code[10]; JournalBatchName: Code[10]; AccountType: Option "G/L Account",Vendor; AccountNo: Code[20]; PostingDate: Date; DocNo: Code[20]; Description: Text[50]; CurrencyCode: Code[10]; AmountToPost: Decimal; AmountLCY: Boolean)
    var
        GenJournalTemplate: Record "Gen. Journal Template";
        PaidEmployee: Record Employee;
        EmployeeDimension: Record "Employee Comment Line";
    begin
        IF (AmountToPost <> ROUND(0.00001, 0.01, '=')) THEN BEGIN
            PaidEmployee.GET(EmployeeNo);
            GenJournalTemplate.GET(JournalTemplateName);
            GenJnlLine.INIT;
            GenJnlLine.VALIDATE("Journal Template Name", JournalTemplateName);
            GenJnlLine.VALIDATE("Journal Batch Name", JournalBatchName);
            GenJnlLine."Line No." := LineNo;
            GenJnlLine."Source Code" := GenJournalTemplate."Source Code";
            IF AccountType = AccountType::"G/L Account" THEN
                GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account"
            ELSE
                IF AccountType = AccountType::Vendor THEN
                    GenJnlLine."Account Type" := GenJnlLine."Account Type"::Vendor;
            GenJnlLine.VALIDATE("Account No.", AccountNo);
            GenJnlLine."Posting Date" := PostingDate;
            GenJnlLine."Document No." := DocNo;
            GenJnlLine.Description := Description;
            IF GenJournalTemplate.Type <> GenJournalTemplate.Type::Payments THEN BEGIN
                GenJnlLine."Gen. Posting Type" := GenJnlLine."Gen. Posting Type"::Purchase;
                GenJnlLine."Gen. Prod. Posting Group" := Employee."Statistics Group Code";
            END ELSE BEGIN
                GenJnlLine."Gen. Posting Type" := GenJnlLine."Gen. Posting Type"::" ";
                GenJnlLine."Gen. Prod. Posting Group" := '';
            END;
            GenJnlLine."Gen. Bus. Posting Group" := '';

            GenJnlLine."VAT Bus. Posting Group" := '';
            GenJnlLine."VAT Prod. Posting Group" := '';
            IF CurrencyCode <> '' THEN BEGIN
                GenJnlLine.VALIDATE("Currency Code", CurrencyCode);
                IF AmountLCY THEN
                    GenJnlLine.VALIDATE("Amount (LCY)", AmountToPost)
                ELSE
                    GenJnlLine.VALIDATE(Amount, AmountToPost);
            END ELSE
                GenJnlLine.VALIDATE(Amount, AmountToPost);

            // Fill in the Employee Dimensions on the General Journal
            EmployeeDimension.RESET;
            EmployeeDimension.SETRANGE(EmployeeDimension."Table Name", EmployeeDimension."Table Name"::Employee);
            EmployeeDimension.SETRANGE(EmployeeDimension."No.", EmployeeNo);
            EmployeeDimension.SETRANGE("Table Line No.", 5200);
            EmployeeDimension.SETRANGE("Alternative Address Code", '');
            EmployeeDimension.SETRANGE("Line No.", 10000);
            EmployeeDimension.SETRANGE(Type, EmployeeDimension.Type::Employee);
            IF EmployeeDimension.FINDFIRST THEN BEGIN
                IF (EmployeeDimension."Shortcut Dimension 1 Code" = '') THEN
                    ERROR(ASLT0012, EmployeeNo)
                ELSE BEGIN
                    GenJnlLine.VALIDATE("Shortcut Dimension 1 Code", EmployeeDimension."Shortcut Dimension 1 Code");
                    GenJnlLine.VALIDATE("Shortcut Dimension 2 Code", EmployeeDimension."Shortcut Dimension 2 Code");
                    GenJnlLine.ValidateShortcutDimCode(3, EmployeeDimension."Shortcut Dimension 3 Code");
                    GenJnlLine.ValidateShortcutDimCode(4, EmployeeDimension."Shortcut Dimension 4 Code");
                    GenJnlLine.ValidateShortcutDimCode(5, EmployeeDimension."Shortcut Dimension 5 Code");
                    GenJnlLine.ValidateShortcutDimCode(6, EmployeeDimension."Shortcut Dimension 6 Code");
                    GenJnlLine.ValidateShortcutDimCode(7, EmployeeDimension."Shortcut Dimension 7 Code");
                    GenJnlLine.ValidateShortcutDimCode(8, EmployeeDimension."Shortcut Dimension 8 Code");
                END;
            END;
            // Fill in the Employee Dimensions on the General Journal

            IF GenJournalTemplate.Type = GenJournalTemplate.Type::Payments THEN BEGIN
                GenJnlLine."Paid To/Received From" := COPYSTR(PaidEmployee."Full Name", 1, MAXSTRLEN(GenJnlLine."Paid To/Received From"));
            END;
            GenJnlLine.INSERT(TRUE);
        END;
        LineNo := LineNo + 10000;
    end;

    //================================
    procedure GetAmountFromRangeTable(RangeTableCode: Code[10]; BasisAmount: Decimal) Amount: Decimal
    var
        RefRangeTable: Record Confidential;
        RefRangeTableLine: Record Confidential;
        ExitLoop: Boolean;
        PreviousUpperLimit: Decimal;
    begin
        Amount := 0;
        RefRangeTable.RESET;
        RefRangeTable.SETRANGE(RefRangeTable.Type, RefRangeTable.Type::"Range Table");
        RefRangeTable.SETRANGE(RefRangeTable.Code, RangeTableCode);
        IF RefRangeTable.FIND('-') THEN BEGIN
            RefRangeTableLine.RESET;
            RefRangeTableLine.SETCURRENTKEY(Type, "Parent Code", "From Amount");
            RefRangeTableLine.SETRANGE(RefRangeTableLine.Type, RefRangeTableLine.Type::"Range Table Line");
            RefRangeTableLine.SETRANGE(RefRangeTableLine."Parent Code", RangeTableCode);
            IF RefRangeTableLine.FIND('-') THEN BEGIN
                ExitLoop := FALSE;
                REPEAT
                    IF RefRangeTable."Cumml. Process Range Table" THEN BEGIN
                        IF (RefRangeTableLine."From Amount" <= BasisAmount) THEN BEGIN
                            IF RefRangeTableLine.Basis = RefRangeTableLine.Basis::"Fixed Amount" THEN
                                Amount := Amount + RefRangeTableLine."Fixed Amount"
                            ELSE
                                IF RefRangeTableLine.Basis = RefRangeTableLine.Basis::Percentage THEN BEGIN
                                    IF (RefRangeTableLine."To Amount" > BasisAmount) THEN
                                        Amount := Amount + ROUND(((BasisAmount - PreviousUpperLimit) * RefRangeTableLine."Range Percentage" * 0.01), 0.001, '=') //change
                                    ELSE
                                        Amount := Amount + ROUND(((RefRangeTableLine."To Amount" - PreviousUpperLimit) *
                                                            RefRangeTableLine."Range Percentage" * 0.01), 0.001, '='); //change
                                END;
                            IF (RefRangeTableLine."To Amount" > BasisAmount) THEN
                                ExitLoop := TRUE;
                        END;
                        PreviousUpperLimit := RefRangeTableLine."To Amount";
                    END ELSE BEGIN
                        IF (RefRangeTableLine."From Amount" <= BasisAmount) AND (RefRangeTableLine."To Amount" >= BasisAmount) THEN BEGIN
                            IF RefRangeTableLine.Basis = RefRangeTableLine.Basis::"Fixed Amount" THEN
                                Amount := RefRangeTableLine."Fixed Amount"
                            ELSE
                                IF RefRangeTableLine.Basis = RefRangeTableLine.Basis::Percentage THEN
                                    Amount := ROUND((BasisAmount * RefRangeTableLine."Range Percentage" * 0.01), 0.001, '='); //change

                            IF (RefRangeTableLine."To Amount" > BasisAmount) THEN
                                ExitLoop := TRUE;
                        END;
                    END;
                UNTIL (RefRangeTableLine.NEXT = 0) OR ExitLoop
            END;
        END;
    end;

    //=============================
    procedure CheckEmployeeAsResource(EmployeeRec: Record Employee)
    var
        Resource: Record Resource;
    begin
        IF NOT Resource.GET(EmployeeRec."No.") THEN BEGIN
            "Employee Statistics Group".TESTFIELD("Payroll Journal Batch Name");
            Resource.INIT;
            Resource."No." := EmployeeRec."No.";
            Resource.Name := EmployeeRec."Full Name";
            Resource.Type := Resource.Type::Person;
            Resource.INSERT;
        END;
    end;

    //===========================
    procedure AddToBlockEarningItems(ItemCode: Code[10]; Description: Text[30]; ExpenseAmount: Decimal; PayableAmount: Decimal)
    begin
        AddToBlockItemsArray(BlockEarningItems, NoOfBlockEarningItems, ItemCode, Description, ExpenseAmount, PayableAmount);
    end;

    //===========================
    procedure AddToBlockDeductionItems(ItemCode: Code[10]; Description: Text[30]; ExpenseAmount: Decimal; PayableAmount: Decimal)
    begin
        AddToBlockItemsArray(BlockDeductionItems, NoOfBlockDeductionItems, ItemCode, Description, ExpenseAmount, PayableAmount);
    end;

    //========================
    procedure AddToBlockItemsArray(VAR BlockItemsArray: ARRAY[100, 4] OF Text[50]; VAR BlockItemsCounter: Integer; ItemCode: Code[10]; ItemDescription: Text[30]; ExpenseAmount: Decimal; PayableAmount: Decimal)
    var
        I: Integer;
        ExitLoop: Boolean;
        ItemFound: Boolean;
        TempAmount: Decimal;
    begin
        IF BlockItemsCounter > 0 THEN BEGIN
            I := 0;
            ExitLoop := FALSE;
            REPEAT
                I += 1;
                IF ItemCode = BlockItemsArray[I] [1] THEN BEGIN
                    IF ExpenseAmount > 0 THEN BEGIN
                        EVALUATE(TempAmount, BlockItemsArray[I] [3]);
                        BlockItemsArray[I] [3] := FORMAT(TempAmount + ExpenseAmount);
                    END;

                    IF PayableAmount > 0 THEN BEGIN
                        EVALUATE(TempAmount, BlockItemsArray[I] [4]);
                        BlockItemsArray[I] [4] := FORMAT(TempAmount + PayableAmount);
                    END;

                    ExitLoop := TRUE;
                    ItemFound := TRUE;
                END;
            UNTIL (I = BlockItemsCounter) OR ExitLoop;
        END;

        IF NOT ItemFound THEN BEGIN
            BlockItemsCounter += 1;
            BlockItemsArray[BlockItemsCounter] [1] := ItemCode;
            BlockItemsArray[BlockItemsCounter] [2] := ItemDescription;
            BlockItemsArray[BlockItemsCounter] [3] := FORMAT(ExpenseAmount);
            BlockItemsArray[BlockItemsCounter] [4] := FORMAT(PayableAmount);
        END;
    end;

    //=========================
    procedure InsertPayrollLedgerEntry(EmployeeNo: Code[20]; EmpStatsGroup: Code[10]; EDCode: Code[10]; Description: Text[50]; EntryType: Option " ","Basic Pay",Earning,Deduction,"Income Tax","Net Salary Payable","Net Salary Paid"; TaxablePreTaxDeductible: Boolean; Amount: Decimal; EmployerAmount: Decimal)
    var
        ResJournalLine: Record "Res. Journal Line";
        ResLedgerEntry: Record "Res. Ledger Entry";
        ResJnlTemplate: Record "Res. Journal Template";
        ResJnlBatch: Record "Res. Journal Batch";
        SourceCode: Record "Source Code";
        Resource: Record Resource;
        EntryNo: Integer;
    begin
        IF Amount <> ROUND(0.0000001, 0.01, '=') THEN BEGIN
            IF NOT ResJnlBatch.GET('RESJNL', 'RESJOURNAL') THEN BEGIN
                IF NOT (ResJnlTemplate.GET('RESJNL')) THEN BEGIN
                    ResJnlTemplate.INIT;
                    ResJnlTemplate.VALIDATE(Name, 'RESJNL');
                    IF NOT (SourceCode.GET('RESJNL')) THEN BEGIN
                        SourceCode.INIT;
                        SourceCode.VALIDATE(Code, 'RESJNL');
                        SourceCode.INSERT;
                    END;
                    ResJnlTemplate."Source Code" := 'RESJNL';
                    ResJnlTemplate.Description := 'Resource Journal Template';
                    ResJnlTemplate.INSERT(TRUE);
                END;
                ResJnlBatch.VALIDATE("Journal Template Name", 'RESJNL');
                ResJnlBatch.Name := 'RESJOURNAL';
                ResJnlBatch.Description := 'Resource Payroll Journal Batch';
                ResJnlBatch.INSERT(TRUE);
            END;

            Resource.GET(EmployeeNo);
            IF (Resource."Gen. Prod. Posting Group" = '') THEN
                ERROR(ASLT0010 + Resource."No.");
            IF (Resource."Base Unit of Measure" = '') THEN
                ERROR(ASLT0011);
            ResJournalLine.RESET;

            //V.0.2 16/03/19 | Employee dimensions in resource ledgers
            EmployeeDimension.RESET;
            EmployeeDimension.SETRANGE(EmployeeDimension."Table Name", EmployeeDimension."Table Name"::Employee);
            EmployeeDimension.SETRANGE(EmployeeDimension."No.", Resource."No.");
            EmployeeDimension.SETRANGE(EmployeeDimension."Table Line No.", 5200);
            IF EmployeeDimension.FINDFIRST THEN BEGIN
                ResDim4 := EmployeeDimension."Shortcut Dimension 4 Code";
                ResDim5 := EmployeeDimension."Shortcut Dimension 5 Code";
            END;
            //V.0.2 16/03/19 | Employee dimensions in resource ledgers

            IF ResJournalLine.FINDLAST THEN
                EntryNo := ResJournalLine."Line No." + 10000
            ELSE
                EntryNo := 10000;
            ResJournalLine.INIT;
            ResJournalLine."Journal Template Name" := 'RESJNL';
            ResJournalLine."Journal Batch Name" := 'RESJOURNAL';
            ResJournalLine."Line No." := EntryNo;
            ResJournalLine."Entry Type Payroll" := ResJournalLine."Entry Type Payroll"::"Payroll Entry";
            ResJournalLine."Entry Type" := ResJournalLine."Entry Type"::Usage;
            ResJournalLine."ED Code" := EDCode;
            ResJournalLine."Document No." := DocumentNo;
            ResJournalLine."Posting Date" := PostingDate;
            ResJournalLine."Resource No." := EmployeeNo;
            ResJournalLine.Description := Description;
            ResJournalLine."Payroll Entry Type" := EntryType;
            ResJournalLine."Taxable/Pre-Tax Deductible" := TaxablePreTaxDeductible;
            ResJournalLine."Employee Statistics Group" := EmpStatsGroup;
            ResJournalLine.Amount := Amount;
            ResJournalLine."Amount (LCY)" := Amount;
            ResJournalLine."Employer Amount" := EmployerAmount;
            ResJournalLine."Employer Amount (LCY)" := EmployerAmount;
            ResJournalLine."Gen. Prod. Posting Group" := Resource."Gen. Prod. Posting Group";
            ResJournalLine."Unit of Measure Code" := Resource."Base Unit of Measure";
            ResJournalLine."Shortcut Dimension 1 Code" := Resource."Global Dimension 1 Code";
            ResJournalLine."Shortcut Dimension 2 Code" := Resource."Global Dimension 2 Code";
            ResJournalLine."Shortcut Dimension 3 Code" := ResDim3;
            ResJournalLine."Shortcut Dimension 4 Code" := ResDim4;
            ResJournalLine."Shortcut Dimension 5 Code" := ResDim5;
            ResJournalLine."Shortcut Dimension 6 Code" := ResDim6;
            ResJournalLine."Shortcut Dimension 7 Code" := ResDim7;
            ResJournalLine."Shortcut Dimension 8 Code" := ResDim8;
            ResJournalLine.INSERT;
            CODEUNIT.RUN(CODEUNIT::"ResJnlPostEntries Batch", ResJournalLine);
        END;
    end;

    //==================================
    procedure CheckGlEntriesPosted()
    var
        GLEntry: Record "G/L Entry";
    begin
        GLEntry.RESET;
        GLEntry.SETRANGE("Posting Date", "Employee Statistics Group"."Next Payroll Processing Date");
        GLEntry.SETRANGE(GLEntry."Journal Batch Name", "Employee Statistics Group"."Payroll Journal Batch Name");
        GLEntry.SETRANGE(GLEntry."Gen. Prod. Posting Group", "Employee Statistics Group".Code);
        IF NOT GLEntry.FINDFIRST THEN
            ERROR(ASLT0014);
    end;
}
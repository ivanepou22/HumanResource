report 50007 "Payroll Report"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'PayrollReport.rdl';

    dataset
    {
        dataitem("Res. Ledger Entry"; "Res. Ledger Entry")
        {
            RequestFilterFields = "Resource No.", "Employee Statistics Group", "Global Dimension 1 Code";

            //Report Columns
            Column(Resource_No; "Res. Ledger Entry"."Resource No.") { }
            Column(First_Name; Employee."First Name") { }
            Column(Employee_Full_Name; Employee."Full Name") { }
            Column(Basic_Salary; BasicSalary) { }
            Column(Other_Earnings; OtherEarnings) { }
            Column(Gross_Pay; GrossPay) { }
            Column(PAYE; PAYE) { }
            Column(RSSF; RSSF) { }
            Column(RSSF_Employer; RSSFEmployer) { }
            Column(RSS_15Percent; RSSF + RSSFEmployer) { }
            Column(Local_Service_Tax; LocalServiceTax) { }
            Column(Other_Deductions; OtherDeductions) { }
            Column(Total_Deductions; TotalDeductions) { }
            Column(Net_Pay; NetPay) { }
            Column(CompanyInfo_Name; CompanyInfo.Name) { }
            Column(CompanyInfo_Address; CompanyInfo.Address) { }
            Column(CompanyInfo_Address_2; CompanyInfo."Address 2") { }
            Column(CompanyInfo_City; CompanyInfo.City) { }
            Column(CompanyInfo_Phone_No_; CompanyInfo."Phone No.") { }
            Column(CompanyInfo_Fax_No_; CompanyInfo."Fax No.") { }
            Column(CompanyInfo_Home_Page; CompanyInfo."Home Page") { }
            Column(CompanyInfo_E_Mail; CompanyInfo."E-Mail") { }
            Column(CompanyInfo_Picture; CompanyInfo.Picture) { }
            Column(Num; Num) { }
            Column(ShowNumbering; ShowNumbering) { }
            Column(PayrollMonthYear; PayrollMonthYear) { }
            Column(Filters; Filters) { }
            Column(EarningCode1; EarningCode[1]) { }
            Column(EarningCode2; EarningCode[2]) { }
            Column(EarningCode3; EarningCode[3]) { }
            Column(EarningCode4; EarningCode[4]) { }
            Column(EarningCode5; EarningCode[5]) { }
            Column(EarningCode6; EarningCode[6]) { }
            Column(EarningCode7; EarningCode[7]) { }
            Column(EarningCode8; EarningCode[8]) { }
            Column(EarningCode9; EarningCode[9]) { }
            Column(EarningCode10; EarningCode[10]) { }
            Column(EarningCode11; EarningCode[11]) { }
            Column(EarningCode12; EarningCode[12]) { }
            Column(EarningCode13; EarningCode[13]) { }
            Column(EarningCode14; EarningCode[14]) { }
            Column(EarningCode15; EarningCode[15]) { }
            Column(EarningCode16; EarningCode[16]) { }
            Column(EarningCode17; EarningCode[17]) { }
            Column(EarningCode18; EarningCode[18]) { }
            Column(EarningCode19; EarningCode[19]) { }
            Column(EarningCode20; EarningCode[20]) { }
            Column(EarningCode21; EarningCode[21]) { }
            Column(EarningCode22; EarningCode[22]) { }
            Column(EarningCode23; EarningCode[23]) { }
            Column(EarningCode24; EarningCode[24]) { }
            Column(EarningCode25; EarningCode[25]) { }
            Column(EarningCode26; EarningCode[26]) { }
            Column(EarningCode27; EarningCode[27]) { }
            Column(EarningCode28; EarningCode[28]) { }
            Column(EarningCode29; EarningCode[29]) { }
            Column(EarningCode30; EarningCode[30]) { }
            Column(EarningCode31; EarningCode[31]) { }
            Column(EarningCode32; EarningCode[32]) { }
            Column(EarningCode33; EarningCode[33]) { }
            Column(EarningCode34; EarningCode[34]) { }
            Column(EarningCode35; EarningCode[35]) { }
            Column(EarningCode36; EarningCode[36]) { }
            Column(EarningCode37; EarningCode[37]) { }
            Column(EarningCode38; EarningCode[38]) { }
            Column(EarningCode39; EarningCode[39]) { }
            Column(EarningCode40; EarningCode[40]) { }
            Column(EarningCode41; EarningCode[41]) { }
            Column(EarningCode42; EarningCode[42]) { }
            Column(EarningCode43; EarningCode[43]) { }
            Column(EarningCode44; EarningCode[44]) { }
            Column(EarningCode45; EarningCode[45]) { }
            Column(EarningCode46; EarningCode[46]) { }
            Column(EarningCode47; EarningCode[47]) { }
            Column(EarningCode48; EarningCode[48]) { }
            Column(EarningCode49; EarningCode[49]) { }
            Column(EarningCode50; EarningCode[50]) { }
            Column(EarningCode51; EarningCode[51]) { }
            Column(EarningCode52; EarningCode[52]) { }
            Column(EarningCode53; EarningCode[53]) { }
            Column(EarningCode54; EarningCode[54]) { }
            Column(EarningCode55; EarningCode[55]) { }
            Column(EarningCode56; EarningCode[56]) { }
            Column(EarningCode57; EarningCode[57]) { }
            Column(EarningCode58; EarningCode[58]) { }
            Column(EarningCode59; EarningCode[59]) { }
            Column(EarningCode60; EarningCode[60]) { }
            Column(EarningCode61; EarningCode[61]) { }
            Column(EarningCode62; EarningCode[62]) { }
            Column(EarningCode63; EarningCode[63]) { }
            Column(EarningCode64; EarningCode[64]) { }
            Column(EarningCode65; EarningCode[65]) { }
            Column(EarningCode66; EarningCode[66]) { }
            Column(EarningCode67; EarningCode[67]) { }
            Column(EarningCode68; EarningCode[68]) { }
            Column(EarningCode69; EarningCode[69]) { }
            Column(EarningCode70; EarningCode[70]) { }

            Column(EarningAmount1; EarningAmount[1]) { }
            Column(EarningAmount2; EarningAmount[2]) { }
            Column(EarningAmount3; EarningAmount[3]) { }
            Column(EarningAmount4; EarningAmount[4]) { }
            Column(EarningAmount5; EarningAmount[5]) { }
            Column(EarningAmount6; EarningAmount[6]) { }
            Column(EarningAmount7; EarningAmount[7]) { }
            Column(EarningAmount8; EarningAmount[8]) { }
            Column(EarningAmount9; EarningAmount[9]) { }
            Column(EarningAmount10; EarningAmount[10]) { }
            Column(EarningAmount11; EarningAmount[11]) { }
            Column(EarningAmount12; EarningAmount[12]) { }
            Column(EarningAmount13; EarningAmount[13]) { }
            Column(EarningAmount14; EarningAmount[14]) { }
            Column(EarningAmount15; EarningAmount[15]) { }
            Column(EarningAmount16; EarningAmount[16]) { }
            Column(EarningAmount17; EarningAmount[17]) { }
            Column(EarningAmount18; EarningAmount[18]) { }
            Column(EarningAmount19; EarningAmount[19]) { }
            Column(EarningAmount20; EarningAmount[20]) { }
            Column(EarningAmount21; EarningAmount[21]) { }
            Column(EarningAmount22; EarningAmount[22]) { }
            Column(EarningAmount23; EarningAmount[23]) { }
            Column(EarningAmount24; EarningAmount[24]) { }
            Column(EarningAmount25; EarningAmount[25]) { }
            Column(EarningAmount26; EarningAmount[26]) { }
            Column(EarningAmount27; EarningAmount[27]) { }
            Column(EarningAmount28; EarningAmount[28]) { }
            Column(EarningAmount29; EarningAmount[29]) { }
            Column(EarningAmount30; EarningAmount[30]) { }
            Column(EarningAmount31; EarningAmount[31]) { }
            Column(EarningAmount32; EarningAmount[32]) { }
            Column(EarningAmount33; EarningAmount[33]) { }
            Column(EarningAmount34; EarningAmount[34]) { }
            Column(EarningAmount35; EarningAmount[35]) { }
            Column(EarningAmount36; EarningAmount[36]) { }
            Column(EarningAmount37; EarningAmount[37]) { }
            Column(EarningAmount38; EarningAmount[38]) { }
            Column(EarningAmount39; EarningAmount[39]) { }
            Column(EarningAmount40; EarningAmount[40]) { }
            Column(EarningAmount41; EarningAmount[41]) { }
            Column(EarningAmount42; EarningAmount[42]) { }
            Column(EarningAmount43; EarningAmount[43]) { }
            Column(EarningAmount44; EarningAmount[44]) { }
            Column(EarningAmount45; EarningAmount[45]) { }
            Column(EarningAmount46; EarningAmount[46]) { }
            Column(EarningAmount47; EarningAmount[47]) { }
            Column(EarningAmount48; EarningAmount[48]) { }
            Column(EarningAmount49; EarningAmount[49]) { }
            Column(EarningAmount50; EarningAmount[50]) { }
            Column(EarningAmount51; EarningAmount[51]) { }
            Column(EarningAmount52; EarningAmount[52]) { }
            Column(EarningAmount53; EarningAmount[53]) { }
            Column(EarningAmount54; EarningAmount[54]) { }
            Column(EarningAmount55; EarningAmount[55]) { }
            Column(EarningAmount56; EarningAmount[56]) { }
            Column(EarningAmount57; EarningAmount[57]) { }
            Column(EarningAmount58; EarningAmount[58]) { }
            Column(EarningAmount59; EarningAmount[59]) { }
            Column(EarningAmount60; EarningAmount[60]) { }
            Column(EarningAmount61; EarningAmount[61]) { }
            Column(EarningAmount62; EarningAmount[62]) { }
            Column(EarningAmount63; EarningAmount[63]) { }
            Column(EarningAmount64; EarningAmount[64]) { }
            Column(EarningAmount65; EarningAmount[65]) { }
            Column(EarningAmount66; EarningAmount[66]) { }
            Column(EarningAmount67; EarningAmount[67]) { }
            Column(EarningAmount68; EarningAmount[68]) { }
            Column(EarningAmount69; EarningAmount[69]) { }
            Column(EarningAmount70; EarningAmount[70]) { }

            Column(DeductionCode1; DeductionCode[1]) { }
            Column(DeductionCode2; DeductionCode[2]) { }
            Column(DeductionCode3; DeductionCode[3]) { }
            Column(DeductionCode4; DeductionCode[4]) { }
            Column(DeductionCode5; DeductionCode[5]) { }
            Column(DeductionCode6; DeductionCode[6]) { }
            Column(DeductionCode7; DeductionCode[7]) { }
            Column(DeductionCode8; DeductionCode[8]) { }
            Column(DeductionCode9; DeductionCode[9]) { }
            Column(DeductionCode10; DeductionCode[10]) { }
            Column(DeductionCode11; DeductionCode[11]) { }
            Column(DeductionCode12; DeductionCode[12]) { }
            Column(DeductionCode13; DeductionCode[13]) { }
            Column(DeductionCode14; DeductionCode[14]) { }
            Column(DeductionCode15; DeductionCode[15]) { }
            Column(DeductionCode16; DeductionCode[16]) { }
            Column(DeductionCode17; DeductionCode[17]) { }
            Column(DeductionCode18; DeductionCode[18]) { }
            Column(DeductionCode19; DeductionCode[19]) { }
            Column(DeductionCode20; DeductionCode[20]) { }
            Column(DeductionCode21; DeductionCode[21]) { }
            Column(DeductionCode22; DeductionCode[22]) { }
            Column(DeductionCode23; DeductionCode[23]) { }
            Column(DeductionCode24; DeductionCode[24]) { }
            Column(DeductionCode25; DeductionCode[25]) { }
            Column(DeductionCode26; DeductionCode[26]) { }
            Column(DeductionCode27; DeductionCode[27]) { }
            Column(DeductionCode28; DeductionCode[28]) { }
            Column(DeductionCode29; DeductionCode[29]) { }
            Column(DeductionCode30; DeductionCode[30]) { }

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
            Column(DeductionAmount11; DeductionAmount[11]) { }
            Column(DeductionAmount12; DeductionAmount[12]) { }
            Column(DeductionAmount13; DeductionAmount[13]) { }
            Column(DeductionAmount14; DeductionAmount[14]) { }
            Column(DeductionAmount15; DeductionAmount[15]) { }
            Column(DeductionAmount16; DeductionAmount[16]) { }
            Column(DeductionAmount17; DeductionAmount[17]) { }
            Column(DeductionAmount18; DeductionAmount[18]) { }
            Column(DeductionAmount19; DeductionAmount[19]) { }
            Column(DeductionAmount20; DeductionAmount[20]) { }
            Column(DeductionAmount21; DeductionAmount[21]) { }
            Column(DeductionAmount22; DeductionAmount[22]) { }
            Column(DeductionAmount23; DeductionAmount[23]) { }
            Column(DeductionAmount24; DeductionAmount[24]) { }
            Column(DeductionAmount25; DeductionAmount[25]) { }
            Column(DeductionAmount26; DeductionAmount[26]) { }
            Column(DeductionAmount27; DeductionAmount[27]) { }
            Column(DeductionAmount28; DeductionAmount[28]) { }
            Column(DeductionAmount29; DeductionAmount[29]) { }
            Column(DeductionAmount30; DeductionAmount[30]) { }

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
            Column(DeductionInclude30; DeductionInclude[20]) { }
            //================OnPreDataItem==============
            trigger OnPreDataItem()
            var
                myInt: Integer;
            begin

                IF PayrollPeriod = 0D THEN
                    ERROR(ASLT0001);

                "Res. Ledger Entry".SETRANGE("Res. Ledger Entry"."Posting Date", PayrollPeriod);
                "Res. Ledger Entry".SETRANGE("Res. Ledger Entry"."Payroll Entry Type", "Res. Ledger Entry"."Payroll Entry Type"::"Basic Pay");

                CurrReport.CREATETOTALS(BasicSalary, OtherEarnings, GrossPay, TaxablePay, PAYE, RSSF, RSSFEmployer, OtherDeductions, TotalDeductions, NetPay);
                CurrReport.CREATETOTALS(LocalServiceTax);

                // V1.0.1 Addition: Show Earning Codes and Amount on report
                N := 0;
                M := 0;
                EarningCodes.RESET;
                EarningCodes.SETRANGE(Type, EarningCodes.Type::Earning);
                //EarningCodes.SETRANGE("Include on Report", TRUE);
                IF EarningCodes.FINDFIRST THEN BEGIN
                    N := 1;
                    REPEAT
                        EarningCode[N] := EarningCodes.Code;
                        IF EarningCodes."Include on Report" THEN
                            EarningInclude[N] := TRUE
                        ELSE
                            EarningInclude[N] := FALSE;
                        N += 1;
                    UNTIL EarningCodes.NEXT = 0;
                END;

                DeductionCodes.RESET;
                DeductionCodes.SETRANGE(Type, DeductionCodes.Type::Deduction);
                //DeductionCodes.SETRANGE("Include on Report", TRUE);
                IF DeductionCodes.FINDFIRST THEN BEGIN
                    M := 1;
                    REPEAT
                        DeductionCode[M] := DeductionCodes.Code;
                        IF DeductionCodes."Include on Report" THEN
                            DeductionInclude[M] := TRUE
                        ELSE
                            DeductionInclude[M] := FALSE;
                        M += 1;
                    UNTIL DeductionCodes.NEXT = 0;
                END;

                S := 0;

                PayrollMonth := DATE2DMY(PayrollPeriod, 2);
                PayrollYear := DATE2DMY(PayrollPeriod, 3);
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

            trigger OnAfterGetRecord()
            var
                myInt: Integer;
            begin

                BasicSalary := 0;
                OtherEarnings := 0;
                GrossPay := 0;
                TaxablePay := 0;
                PAYE := 0;
                RSSF := 0;
                RSSFEmployer := 0;
                LocalServiceTax := 0;
                OtherDeductions := 0;
                TotalDeductions := 0;
                NetPay := 0;
                TotalTaxableEarnings := 0;
                TotalPretaxDeductions := 0;
                EarningIterator := 0;
                DeductionIterator := 0;
                // Initialise Earnings
                FOR K := 1 TO N DO BEGIN
                    EarningAmount[K] := 0;
                END;
                // Initialise Deductions
                FOR L := 1 TO M DO BEGIN
                    DeductionAmount[L] := 0;
                END;
                // Employee Numbering in ascending order
                S += 1;
                T[S] := S;
                IF ShowNumbering THEN
                    Num := T[S]
                ELSE
                    Num := 0;


                IF NOT Employee.GET("Res. Ledger Entry"."Resource No.") THEN
                    CLEAR(Employee);

                ResLedgerEntry.RESET;
                ResLedgerEntry.SETRANGE(ResLedgerEntry."Entry Type Payroll", ResLedgerEntry."Entry Type Payroll"::"Payroll Entry");
                ResLedgerEntry.SETRANGE(ResLedgerEntry."Posting Date", PayrollPeriod);
                ResLedgerEntry.SETRANGE(ResLedgerEntry."Resource No.", "Res. Ledger Entry"."Resource No.");
                IF ResLedgerEntry.FIND('-') THEN BEGIN
                    REPEAT
                        IF ResLedgerEntry."Payroll Entry Type" = ResLedgerEntry."Payroll Entry Type"::"Basic Pay" THEN BEGIN
                            BasicSalary += ResLedgerEntry.Amount;
                            //GrossPay += ResLedgerEntry.Amount;
                            TaxablePay += ResLedgerEntry.Amount;
                        END ELSE
                            IF ResLedgerEntry."Payroll Entry Type" = ResLedgerEntry."Payroll Entry Type"::Earning THEN BEGIN
                                OtherEarnings += ResLedgerEntry.Amount;
                                IF ResLedgerEntry."Taxable/Pre-Tax Deductible" THEN BEGIN
                                    TaxablePay += ResLedgerEntry.Amount;
                                    TotalTaxableEarnings += ResLedgerEntry.Amount;
                                END;
                            END ELSE
                                IF ResLedgerEntry."Payroll Entry Type" = ResLedgerEntry."Payroll Entry Type"::Deduction THEN BEGIN
                                    OtherDeductions += ResLedgerEntry.Amount;
                                    IF ResLedgerEntry."Taxable/Pre-Tax Deductible" THEN BEGIN
                                        TaxablePay -= ResLedgerEntry.Amount;
                                        TotalPretaxDeductions += ResLedgerEntry.Amount;
                                    END;
                                    IF (ResLedgerEntry."ED Code" = 'NSSF') OR (ResLedgerEntry."ED Code" = 'NSSF-ADMIN')
                                    OR (ResLedgerEntry."ED Code" = 'NSSF-DIST') OR (ResLedgerEntry."ED Code" = 'NSSF-DIST') then begin
                                        RSSF := ResLedgerEntry.Amount;
                                        RSSFEmployer := ResLedgerEntry."Employer Amount (LCY)";
                                    end;
                                END ELSE
                                    IF ResLedgerEntry."Payroll Entry Type" = ResLedgerEntry."Payroll Entry Type"::"Income Tax" THEN BEGIN
                                        PAYE := ResLedgerEntry.Amount;
                                    END ELSE
                                        IF ResLedgerEntry."Payroll Entry Type" = ResLedgerEntry."Payroll Entry Type"::"Net Salary Payable" THEN BEGIN
                                            NetPay := ResLedgerEntry.Amount;
                                        END ELSE
                                            IF ResLedgerEntry."Payroll Entry Type" = ResLedgerEntry."Payroll Entry Type"::"Local Service Tax" THEN BEGIN
                                                LocalServiceTax := ResLedgerEntry.Amount;
                                            END;
                    UNTIL ResLedgerEntry.NEXT = 0;
                END;
                // Iterate through Earnings, get the corresponding code and amount
                FOR I := 1 TO N DO BEGIN
                    ResLedgerEntry1.RESET;
                    ResLedgerEntry1.SETRANGE(ResLedgerEntry1."Entry Type Payroll", ResLedgerEntry1."Entry Type Payroll"::"Payroll Entry");
                    ResLedgerEntry1.SETRANGE(ResLedgerEntry1."Posting Date", PayrollPeriod);
                    ResLedgerEntry1.SETRANGE(ResLedgerEntry1."Resource No.", "Res. Ledger Entry"."Resource No.");
                    ResLedgerEntry1.SETRANGE(ResLedgerEntry1."Payroll Entry Type", ResLedgerEntry1."Payroll Entry Type"::Earning);
                    IF ResLedgerEntry1.FINDFIRST THEN
                        REPEAT
                            IF EarningCode[I] = ResLedgerEntry1."ED Code" THEN
                                EarningAmount[I] += ResLedgerEntry1.Amount
                            ELSE
                                EarningAmount[I] += 0;
                        UNTIL ResLedgerEntry1.NEXT = 0
                    ELSE BEGIN
                        EarningAmount[I] := 0;
                    END;
                END;
                // Iterate through Deductions, get the corresponding code and amount
                FOR J := 1 TO M DO BEGIN
                    ResLedgerEntry1.RESET;
                    ResLedgerEntry1.SETRANGE(ResLedgerEntry1."Entry Type Payroll", ResLedgerEntry1."Entry Type Payroll"::"Payroll Entry");
                    ResLedgerEntry1.SETRANGE(ResLedgerEntry1."Posting Date", PayrollPeriod);
                    ResLedgerEntry1.SETRANGE(ResLedgerEntry1."Resource No.", "Res. Ledger Entry"."Resource No.");
                    ResLedgerEntry1.SETRANGE(ResLedgerEntry1."Payroll Entry Type", ResLedgerEntry1."Payroll Entry Type"::Deduction);
                    IF ResLedgerEntry1.FINDFIRST THEN
                        REPEAT
                            IF DeductionCode[J] = ResLedgerEntry1."ED Code" THEN
                                DeductionAmount[J] += ResLedgerEntry1.Amount
                            ELSE
                                DeductionAmount[J] += 0;

                            IF DeductionCode[J] = 'SALADV' THEN BEGIN
                                //Display Salary advance Column name
                                DeductionCode[J] := 'Salary Advance';
                            END;
                        UNTIL ResLedgerEntry1.NEXT = 0
                    ELSE BEGIN
                        DeductionAmount[J] := 0;
                    END;
                END;

                TotalDeductions := LocalServiceTax + OtherDeductions + PAYE;

                GrossPay := BasicSalary + TotalTaxableEarnings - TotalPretaxDeductions;

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
                    field("Payroll Period"; PayrollPeriod)
                    {
                        ApplicationArea = All;
                        trigger OnLookUp(VAR Text: Text): Boolean
                        var
                            ResLedgerEntry: Record "Res. Ledger Entry";
                            ResLedgerEntryForm: Page "Resource Ledger Entries";
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
        myInt: Integer;
    begin
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);

        Filters := "Res. Ledger Entry".GETFILTERS;
    end;

    var
        PayrollPeriod: Date;
        Employee: Record Employee;
        ResLedgerEntry: Record "Res. Ledger Entry";
        ResLedgerEntry1: Record "Res. Ledger Entry";
        BasicSalary: Decimal;
        OtherEarnings: Decimal;
        GrossPay: Decimal;
        TaxablePay: Decimal;
        PAYE: Decimal;
        RSSF: Decimal;
        RSSFEmployer: Decimal;
        OtherDeductions: Decimal;
        TotalDeductions: Decimal;
        NetPay: Decimal;
        LocalServiceTax: Decimal;
        CompanyInfo: Record "Company Information";
        TotalTaxableEarnings: Decimal;
        TotalPretaxDeductions: Decimal;
        EarningIterator: Integer;
        DeductionIterator: Integer;
        EarningCode: array[100] of Code[20];
        EarningAmount: array[100] of Decimal;
        DeductionCode: array[100] of Code[20];
        DeductionAmount: array[100] of Decimal;
        N: Integer;
        M: Integer;
        EarningCodes: Record Confidential;
        DeductionCodes: Record Confidential;
        I: Integer;
        J: Integer;
        K: Integer;
        L: Integer;
        S: Integer;
        T: array[4000] of Integer;
        ShowNumbering: Boolean;
        Num: Integer;
        EarningInclude: array[100] of Boolean;
        DeductionInclude: array[100] of Boolean;
        PayrollMonth: Integer;
        PayrollYear: Integer;
        PayrollMonthName: Code[20];
        PayrollMonthYear: Text[50];
        Filters: Text[250];
        ASLT0001: Label 'You must specify a payroll period';

}
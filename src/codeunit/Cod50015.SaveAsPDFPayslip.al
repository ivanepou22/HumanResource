codeunit 50015 "Save As PDF Payslip"
{

    trigger OnRun();
    begin

        FilePath1 := 'C:\NAV Email\';

        // CREATE(File1, TRUE, TRUE);
        // IF NOT File1.FolderExists(FilePath1) THEN
        //     File1.CreateFolder(FilePath1);

        FileName1 := FilePath1 + 'Payslip' + '.pdf';

        IF EXISTS(FileName1) THEN BEGIN
            ERASE(FileName1);
        END;

        XMLParameters := REPORT.RUNREQUESTPAGE(50008);
        //XMLParameters := EmployeePayslip.RUNREQUESTPAGE(XMLParameters);
        //CLEAR(OStream);
        MyPDFFile.CREATE(FileName1);
        MyPDFFile.CREATEOUTSTREAM(OStream);
        REPORT.SAVEAS(50009, XMLParameters, REPORTFORMAT::Pdf, OStream);
        MyPDFFile.CLOSE;

        MyPDFFile3.OPEN(FileName1);
        MyPDFFile3.CREATEINSTREAM(IStream);


        //get report request page filters
        EmployeePayslip.EXECUTE(XMLParameters);
        ResNo := EmployeePayslip.EmployeeGetFilters();
        ResourceDate := EmployeePayslip.GetDateFilters();
        ResNoText := FORMAT(ResNo);

        //Get payroll dates
        PayslipDay := DATE2DMY(ResourceDate, 1);
        PayslipMonth := DATE2DMY(ResourceDate, 2);
        PayslipYear := DATE2DMY(ResourceDate, 3);

        IF PayslipMonth = 1 THEN BEGIN
            MonthText := 'January';
            MonthShortDateText := 'Jan';
        END ELSE
            IF PayslipMonth = 2 THEN BEGIN
                MonthText := 'February';
                MonthShortDateText := 'Feb';
            END ELSE
                IF PayslipMonth = 3 THEN BEGIN
                    MonthText := 'March';
                    MonthShortDateText := 'Mar';
                END ELSE
                    IF PayslipMonth = 4 THEN BEGIN
                        MonthText := 'April';
                        MonthShortDateText := 'Apr';
                    END ELSE
                        IF PayslipMonth = 5 THEN BEGIN
                            MonthText := 'May';
                            MonthShortDateText := 'May';
                        END ELSE
                            IF PayslipMonth = 6 THEN BEGIN
                                MonthText := 'June';
                                MonthShortDateText := 'Jun';
                            END ELSE
                                IF PayslipMonth = 7 THEN BEGIN
                                    MonthText := 'July';
                                    MonthShortDateText := 'Jul';
                                END ELSE
                                    IF PayslipMonth = 8 THEN BEGIN
                                        MonthText := 'August';
                                        MonthShortDateText := 'Aug';
                                    END ELSE
                                        IF PayslipMonth = 9 THEN BEGIN
                                            MonthText := 'September';
                                            MonthShortDateText := 'Sept';
                                        END ELSE
                                            IF PayslipMonth = 10 THEN BEGIN
                                                MonthText := 'October';
                                                MonthShortDateText := 'Oct';
                                            END ELSE
                                                IF PayslipMonth = 11 THEN BEGIN
                                                    MonthText := 'November';
                                                    MonthShortDateText := 'Nov';
                                                END ELSE
                                                    IF PayslipMonth = 12 THEN BEGIN
                                                        MonthText := 'December';
                                                        MonthShortDateText := 'Dec';
                                                    END;

        //Get Employee name and email
        Employee.RESET;
        Employee.SETRANGE("No.", ResNo);
        IF Employee.FINDFIRST THEN BEGIN
            EmployeeName := Employee.FullName;
            EmployeeEmail := Employee."Company E-Mail";
            IF Employee."Company E-Mail" = '' THEN BEGIN
                ERROR('Please fill in the email address on employee: ' + FORMAT(Employee."No.") + '. Email has NOT been sent!');
            END;
        END;

        PayrollDateText := MonthText + ' ' + FORMAT(PayslipYear);
        PayrollShortDateText := MonthShortDateText + '-' + FORMAT(PayslipYear);

        //Send Mail
        SMTPMailSetup.GET;
        SMTPMail.CreateMessage('HR Manager - Jesa Farm Diary Ltd', 'noreply@jesa.co.ug', EmployeeEmail, 'Pay Slip | ' + FORMAT(ResNo) + ' | '
                                                                + PayrollDateText, '', TRUE);
        //SMTPMail.CreateMessage('HR Manager - STF',SMTPMailSetup."User ID",EmployeeEmail,'Pay Slip | ' + FORMAT(ResNo) + ' | '
        //                                                      + PayrollDateText,'',TRUE);
        //SMTPMailSetup."SMTP Name"

        SMTPMail.AppendBody('Dear ' + EmployeeName + ',');
        SMTPMail.AppendBody('<br><br>');
        SMTPMail.AppendBody('Please find the Attached Employee Payslip for ' + PayrollDateText + '.');
        SMTPMail.AppendBody('<br><br>');
        SMTPMail.AppendBody('Regards,');
        SMTPMail.AppendBody('<br>');
        SMTPMail.AppendBody(SMTPMailSetup."SMTP Name");
        SMTPMail.AppendBody('<br><br>');
        SMTPMail.AppendBody('<HR>');
        SMTPMail.AppendBody('********');

        //SMTPMail.AddAttachment(Path2,'Employee Payslip 2019.pdf');
        SMTPMail.AddAttachmentStream(IStream, 'Payslip-' + FORMAT(ResNo) + '-' + PayrollShortDateText + '.pdf');
        SMTPMail.Send;
        MyPDFFile3.CLOSE;

        MESSAGE('Email Sent Successfully! You can now notify the recipient.');

        IF EXISTS(FileName1) THEN BEGIN
            ERASE(FileName1);
            //MESSAGE(FileName1 + ' - deteled/Erased!');
        END;
    end;

    var
        Employee: Record Employee;
        Resource: Record Resource;
        EmployeePayslip: Report Payslip;
        XMLParameters: Text;
        ReportParameters: Record "Report Selections";
        OStream: OutStream;
        IStream: InStream;
        MyPDFFile: File;
        File1: XmlDocument;
        //File1: Automation 'Microsoft Scripting Runtime'.FileSystemObject;
        //File2: Automation 'Microsoft Excel X.0 Object Library'.Application;
        //File1: Automation "{420B2830-E718-11CF-893D-00A0C9054228} 1.0:{0D43FE01-F093-11CF-8940-00A0C9054228}:'Microsoft Scripting Runtime'.FileSystemObject";
        FileName1: Text[250];
        FileName2: Text[250];
        Parameters: Text[40];
        FilePath2: Text[250];
        SMTPMailSetup: Record "SMTP Mail Setup";
        SMTPMail: Codeunit "SMTP Mail";
        Path2: Text[250];
        FilePath1: Text[250];
        MyPDFFile2: File;
        XMLParameters1: Text;
        ResNo: Code[20];
        ResLedgerEntry: Record "Res. Ledger Entry";
        ResNoText: Text[250];
        EmployeeName: Text[250];
        EmployeeEmail: Text[250];
        ResourceDate: Date;
        PayslipDay: Integer;
        PayslipMonth: Integer;
        PayslipYear: Integer;
        MonthText: Text[250];
        PayrollDateText: Text[250];
        PayrollShortDateText: Text;
        MonthShortDateText: Text;
        MyPDFFile3: File;
}


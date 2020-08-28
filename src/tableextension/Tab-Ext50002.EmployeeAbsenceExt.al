tableextension 50002 "EmployeeAbsenceExt" extends "Employee Absence"
{
    fields
    {
        // Add changes to table fields here
        field(50010; "Absence Type"; Option)
        {
            OptionMembers = "Absence/Lateness",Leave;
        }
        field(50011; "Leave Type"; Option)
        {
            OptionMembers = "Annual Leave","Sick Leave","Maternity Leave","Paternity Leave","Study Leave","Compassionate Leave","Leave Without Pay";
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                UpdateAbsenceCode;
                UpdateLeaveEntitlement;
                UpdateLeaveDaysAvailable;
            end;
        }
        field(50012; "Leave Status"; Option)
        {
            OptionMembers = Application,"Pending Approval",Approved,Rejected,Taken,Cancelled,History;
            Editable = false;
        }
        field(50013; "Requested From Date"; Date)
        {
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                "Approved From Date" := "Requested From Date";
                "From Date" := "Requested From Date";
            end;
        }
        field(50014; "Requested To Date"; Date)
        {
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                if "Requested From Date" = 0D then
                    ERROR(ASLT003, FIELDCAPTION("Requested From Date"));
                //

                if "Requested To Date" < "Requested From Date" then
                    ERROR(ASLT003, FIELDCAPTION("Requested To Date"), FIELDCAPTION("Requested From Date"));

                "Approved To Date" := "Requested To Date";
                "To Date" := "Requested To Date";

                if ("Requested From Date" <> 0D) AND ("Requested To Date" <> 0D) then begin
                    CalcLeaveDaysToBeTaken;
                    UpdateLeaveEntitlement;
                    UpdateLeaveDaysAvailable;
                end;
            end;
        }
        field(50015; "Approved From Date"; Date)
        {
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                "From Date" := "Approved From Date";
                CalcApprovedLeaveDays;
            end;
        }
        field(50016; "Approved To Date"; Date)
        {
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                if "Approved From Date" = 0D then
                    ERROR(ASLT003, FIELDCAPTION("Approved From Date"));

                if "Approved To Date" < "Approved From Date" then
                    ERROR(ASLT003, FIELDCAPTION("Approved To Date"), FIELDCAPTION("Approved From Date"));

                "To Date" := "Approved To Date";
                CalcApprovedLeaveDays;
            end;
        }
        field(50017; "Approved Leave Days"; Integer)
        {
            Editable = false;
        }
        field(50018; "Actual Leave Days"; Decimal) { }
        field(50020; "Days to be Taken"; Decimal)
        {
            Editable = false;
        }
        field(50022; "Leave Entitlement"; Decimal)
        {
            Editable = false;
        }
        field(50024; "Leave Days Available"; Decimal)
        {
            Editable = false;
        }
        field(50026; "Leave Balance"; Decimal)
        {
            Editable = false;
        }
        field(50028; "Approved Leave Days2"; Decimal) { }
        field(50029; "USER ID"; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "User Setup";
        }
    }

    var
        myInt: Integer;
        ASLT001: Label 'Are you sure you want to %1 the leave?';
        ASLT002: Label 'The maximum days available for leave type %1 is %2. Leave cannot be approved';
        ASLT003: Label 'You must first specify %1';
        ASLT004: Label '%1 must be after %2';
        ASLT005: Label 'You do not qualify to apply for leave. Only employees that have worked for more than 3 months can apply for leave.';
        ASLT006: Label 'Request from Date should be earlier';
        ASLT007: Label 'No more than %1 people can be on leave at the same time. Contact your Leave Administrator for any Leave Commits to be done';
        ASLT008: Label 'Employee Leave cannot be rejected if you have not provided any comments. Please enter comments for this leave before any rejection';
        CauseofAbsence: Record "Cause of Absence";
        Employee: Record Employee;
        EmployeeAbsence: Record "Employee Absence";
        HumanResUnitofMeasure: Record "Human Resource Unit of Measure";
        EmployeeContract: Record "Employment Contract";
        MajorLocation: Record Confidential;
        EmployeeContractCode: Code[20];
        AvailableLeaveDays: Decimal;
        T: Integer;
        EmployeeAbsence2: Record "Employee Absence";
        K1: Decimal;
        K2: Decimal;
        AnnualLeaveBF: Decimal;
        EmployeeAbsence3: Record "Employee Absence";
        K3: Decimal;
        K4: Decimal;
        EmployeeAbsence4: Record "Employee Absence";
        CalendarManagement1: codeunit "Calendar Management unit";
        L1: Integer;
        L2: Decimal;
        L3: Decimal;
        L4: Decimal;
        L5: Decimal;
        P2: Integer;
        ABF1: Decimal;
        P1: Decimal;
        P3: Decimal;
        P4: Decimal;
        N1: Decimal;
        N2: Decimal;
        N3: Decimal;
        N4: Decimal;
        N5: Decimal;
        M1: Decimal;
        M2: Decimal;
        M3: Decimal;
        M4: Decimal;
        M5: Decimal;

    //Table triggers
    trigger OnInsert()
    var
        myInt: Integer;
        Employee2: Record Employee;
    begin
        Employee2.RESET;
        Employee2.SETRANGE(Employee2."User ID", USERID);
        IF Employee2.FINDFIRST THEN
            VALIDATE("Employee No.", Employee2."No.");
        // ELSE
        //     ERROR(ASLT005);

        Validate("USER ID", UserId);
    end;

    //----------------------------------------------------------
    procedure SubmitLeaveApplication()
    var
        myInt: Integer;
        HumanResourceSetup: Record "Human Resources Setup";
        ApprovedLeaveApplication: Record "Employee Absence";
        LeaveCount: Integer;
    begin

        HumanResourceSetup.GET;
        if CONFIRM(STRSUBSTNO(ASLT001, 'SUBMIT')) then begin
            LeaveCount := 0;
            ApprovedLeaveApplication.Reset;
            ApprovedLeaveApplication.SetRange(ApprovedLeaveApplication."Absence Type", ApprovedLeaveApplication."Absence Type"::Leave);
            ApprovedLeaveApplication.SETFILTER(ApprovedLeaveApplication."Leave Status", '%1|%2', ApprovedLeaveApplication."Leave Status"::"Pending Approval", ApprovedLeaveApplication."Leave Status"::Approved);
            ApprovedLeaveApplication.SETFILTER(ApprovedLeaveApplication."Approved To Date", '>=%1', "Requested From Date");
            if ApprovedLeaveApplication.FindFirst then begin
                repeat
                    LeaveCount += 1;
                until ApprovedLeaveApplication.NEXT = 0;
                if (LeaveCount >= HumanResourceSetup."Max No. of People On Leave") then
                    ERROR(ASLT007, HumanResourceSetup."Max No. of People On Leave");
            end;
            TESTFIELD("Employee No.");
            TESTFIELD("Requested From Date");
            TESTFIELD("Requested To Date");
            if HumanResourceSetup."Test Leave Appln. before" then
                if (CALCDATE(HumanResourceSetup."Leave Appln. before Formula", "Requested From Date") < TODAY) then
                    ERROR(ASLT006);
            "Leave Status" := "Leave Status"::"Pending Approval";
            MODifY;
            CalcApprovedLeaveDays;

        end;
    end;
    //----------------------------------------------------------

    //----------------------------------------------------------
    procedure ApproveLeaveApplication()
    var
        myInt: Integer;
    begin

        if CONFIRM(STRSUBSTNO(ASLT001, 'APPROVE')) then begin
            TESTFIELD("Employee No.");
            TESTFIELD("Approved From Date");
            TESTFIELD("Approved To Date");
            Employee.SetRange(Employee."Leave From Date Filter", DMY2DATE(1, 1, DATE2DMY(WORKDATE, 3)), WORKDATE);
            Employee.SetRange(Employee."Leave To Date Filter", DMY2DATE(1, 1, DATE2DMY(WORKDATE, 3)), WORKDATE);
            CalcApprovedLeaveDays;
            if Employee.GET("Employee No.") then begin
                case "Leave Type" of
                    "Leave Type"::"Annual Leave":
                        begin
                            Employee.CALCFIELDS("Annual Leave Days Taken");
                            AvailableLeaveDays := Employee."Annual Leave Days B/F" + Employee."Annual Leave Days (Current)" - Employee."Annual Leave Days Taken";
                        end;
                    "Leave Type"::"Maternity Leave":
                        begin
                            Employee.CALCFIELDS("Maternity Leave Days Taken");
                            AvailableLeaveDays := Employee."Maternity Leave Days" - Employee."Maternity Leave Days Taken";
                        end;
                    "Leave Type"::"Paternity Leave":
                        begin
                            Employee.CALCFIELDS("Paternity Leave Days Taken");
                            AvailableLeaveDays := Employee."Paternity Leave Days" - Employee."Paternity Leave Days Taken";
                        end;
                    "Leave Type"::"Sick Leave":
                        begin
                            Employee.CALCFIELDS("Study Leave Days Taken");
                            AvailableLeaveDays := Employee."Sick Days" - Employee."Sick Days Taken";
                        end;
                    "Leave Type"::"Study Leave":
                        begin
                            Employee.CALCFIELDS("Sick Days Taken");
                            AvailableLeaveDays := Employee."Study Leave Days" - Employee."Study Leave Days Taken";
                        end;
                    "Leave Type"::"Compassionate Leave":
                        begin
                            Employee.CALCFIELDS("Compassionate Leave Days Taken");
                            AvailableLeaveDays := Employee."Compassionate Leave Days" - Employee."Compassionate Leave Days Taken";
                        end;
                end;
            end;

            if "Approved Leave Days" > AvailableLeaveDays then
                ERROR(STRSUBSTNO(ASLT002, FORMAT("Leave Type"), AvailableLeaveDays))
            else begin
                "Leave Status" := "Leave Status"::Approved;
                CalcActualLeaveDays;
                "Approved Leave Days2" := "Days to be Taken";
                "Approved Leave Days" := "Days to be Taken";
                MODifY;
            end;
        end;
    end;
    //----------------------------------------------------------

    //----------------------------------------------------------
    procedure RejectLeaveApplication()
    var
        myInt: Integer;
        HumanResourceComment: Record "Employee Comment Line";
    begin

        if CONFIRM(STRSUBSTNO(ASLT001, 'REJECT')) then begin
            TESTFIELD("Employee No.");
            HumanResourceComment.Reset;
            HumanResourceComment.SetRange(HumanResourceComment."Table Name", HumanResourceComment."Table Name"::"Employee Absence");
            HumanResourceComment.SetRange(HumanResourceComment."Table Line No.", "Entry No.");
            if NOT HumanResourceComment.FindFirst then
                ERROR(ASLT008);
            "Leave Status" := "Leave Status"::Rejected;
            MODifY;
        end;
    end;
    //----------------------------------------------------------

    //----------------------------------------------------------
    procedure CancelLeave()
    var
        myInt: Integer;
    begin
        if CONFIRM(STRSUBSTNO(ASLT001, 'CANCEL')) then begin
            "Leave Status" := "Leave Status"::Cancelled;
            MODifY;
        end;
    end;
    //----------------------------------------------------------

    //----------------------------------------------------------
    procedure CommitLeave()
    var
        myInt: Integer;
    begin
        if CONFIRM(STRSUBSTNO(ASLT001, 'COMMIT')) then begin
            CalcActualLeaveDays;
            "Leave Status" := "Leave Status"::History;
            "Actual Leave Days" := "Days to be Taken";
            "Approved Leave Days" := 0;
            "Approved Leave Days2" := 0;

            MODifY;
        end;
    end;
    //----------------------------------------------------------

    //----------------------------------------------------------
    procedure CalcApprovedLeaveDays()
    var
        myInt: Integer;
        CurrDate: Date;
        CalendarManagement: Codeunit "Calendar Management";
        HRSetup: Record "Human Resources Setup";
        CalendarDescription: Text[50];
        JobTitleLeave: Record "Employment Contract";
        Worker: Record Employee;
    begin

        if HRSetup.GET then begin
            //Calculate Approved
            if "Approved From Date" = 0D then
                ERROR(ASLT003, 'Approved From Date');

            if "Approved To Date" = 0D then
                ERROR(ASLT003, 'Approved To Date');

            if "Approved To Date" < "Approved From Date" then
                ERROR(ASLT004, 'Approved To Date', 'Approved From Date');

            TESTFIELD("Approved From Date");
            TESTFIELD("Approved To Date");
            CurrDate := "Approved From Date";
            "Approved Leave Days" := 0;
            if Worker.GET("Employee No.") then begin
                if JobTitleLeave.GET(Worker."Emplymt. Contract Code") then begin
                    if JobTitleLeave."Saturday Halfday" then begin
                        repeat
                            if HRSetup."Count NW Days In Leave Period" then
                                "Approved Leave Days" := "Approved Leave Days" + 1
                            else
                                if NOT CalendarManagement1.CheckDateStatus(HRSetup."HR Calendar", CurrDate, CalendarDescription) then begin
                                    MESSAGE(FORMAT("Approved Leave Days"));
                                    if CalendarManagement1.CheckDateStatusHalfDay(HRSetup."HR Calendar", CurrDate, CalendarDescription) then
                                        // MESSAGE('Approved');
                                        "Approved Leave Days" := "Actual Leave Days" + 0.5
                                    else
                                        "Approved Leave Days" := "Approved Leave Days" + 1;
                                end;
                            CurrDate := CurrDate + 1;
                        until CurrDate > "Approved To Date";
                    end else begin
                        repeat
                            if HRSetup."Count NW Days In Leave Period" then
                                "Approved Leave Days" := "Approved Leave Days" + 1
                            else
                                if NOT CalendarManagement1.CheckDateStatus(HRSetup."HR Calendar", CurrDate, CalendarDescription) then
                                    "Approved Leave Days" := "Approved Leave Days" + 1;
                            CurrDate := CurrDate + 1;
                        until CurrDate > "Approved To Date";
                    end;
                end;
            end;
            MODifY;
        end;
    end;
    //----------------------------------------------------------

    //----------------------------------------------------------
    procedure CalcActualLeaveDays()
    var
        myInt: Integer;
        CurrDate: Date;
        CalendarManagement: Codeunit "Calendar Management";
        HRSetup: Record "Human Resources Setup";
        CalendarDescription: Text[50];
        Worker: Record Employee;
        JobTitleLeave: Record "Employment Contract";
        targetCalendar: Record "Customized Calendar Change";
    begin

        if HRSetup.GET then begin
            //Calculate Approved
            if "From Date" = 0D then
                ERROR(ASLT003, 'Actual Leave From Date');

            if "To Date" = 0D then
                ERROR(ASLT003, 'Actual Leave To Date');

            if "To Date" < "From Date" then
                ERROR(ASLT004, 'Actual Leave To Date', 'Actual Leave From Date');

            CurrDate := "From Date";
            "Actual Leave Days" := 0;

            if Worker.GET("Employee No.") then begin
                if JobTitleLeave.GET(Worker."Emplymt. Contract Code") then begin
                    if JobTitleLeave."Saturday Halfday" then begin
                        repeat
                            if HRSetup."Count NW Days In Leave Period" then
                                "Actual Leave Days" := "Actual Leave Days" + 1
                            else
                                if NOT CalendarManagement1.CheckDateStatus(HRSetup."HR Calendar", CurrDate, CalendarDescription) then begin
                                    MESSAGE('Actual Leave Days - Calculate Actual  leave Days');
                                    if CalendarManagement1.CheckDateStatusHalfDay(HRSetup."HR Calendar", CurrDate, CalendarDescription) then
                                        "Actual Leave Days" := "Actual Leave Days" + 0.5
                                    else
                                        "Actual Leave Days" := "Actual Leave Days" + 1;
                                end;
                            CurrDate := CurrDate + 1;
                        until CurrDate > "To Date";
                    end else begin
                        repeat
                            if HRSetup."Count NW Days In Leave Period" then
                                "Actual Leave Days" := "Actual Leave Days" + 1
                            else
                                if NOT CalendarManagement1.CheckDateStatus(HRSetup."HR Calendar", CurrDate, CalendarDescription) then
                                    "Actual Leave Days" := "Actual Leave Days" + 1;
                            CurrDate := CurrDate + 1;
                        until CurrDate > "To Date";
                    end;
                end;
            end;
            UpdateAbsenceCode();
            MODifY;
        end;
    end;
    //----------------------------------------------------------
    //----------------------------------------------------------
    procedure UpdateAbsenceCode()
    var
        myInt: Integer;
        HRSetup: Record "Human Resources Setup";
    begin

        if HRSetup.GET then begin
            if "Absence Type" = "Absence Type"::Leave then begin
                case "Leave Type" of
                    "Leave Type"::"Annual Leave":
                        begin
                            HRSetup.TESTFIELD(HRSetup."Annual Leave Absence Code");
                            VALIDATE("Cause of Absence Code", HRSetup."Annual Leave Absence Code");
                        end;
                    "Leave Type"::"Maternity Leave":
                        begin
                            HRSetup.TESTFIELD(HRSetup."Maternity Leave Absence Code");
                            VALIDATE("Cause of Absence Code", HRSetup."Maternity Leave Absence Code");
                        end;
                    "Leave Type"::"Paternity Leave":
                        begin
                            HRSetup.TESTFIELD(HRSetup."Paternity Leave Absence Code");
                            VALIDATE("Cause of Absence Code", HRSetup."Paternity Leave Absence Code");
                        end;
                    "Leave Type"::"Sick Leave":
                        begin
                            HRSetup.TESTFIELD(HRSetup."Sick Leave Absence Code");
                            VALIDATE("Cause of Absence Code", HRSetup."Sick Leave Absence Code");
                        end;
                    "Leave Type"::"Study Leave":
                        begin
                            HRSetup.TESTFIELD(HRSetup."Study Leave Absence Code");
                            VALIDATE("Cause of Absence Code", HRSetup."Study Leave Absence Code");
                        end;
                    "Leave Type"::"Compassionate Leave":
                        begin
                            HRSetup.TESTFIELD(HRSetup."Compassionate Leave Abs. Code");
                            VALIDATE("Cause of Absence Code", HRSetup."Compassionate Leave Abs. Code");
                        end;
                end;
            end;
        end;
    end;
    //----------------------------------------------------------

    //----------------------------------------------------------
    procedure CommitLeaveDirectly()
    var
        myInt: Integer;
    begin

        if CONFIRM(STRSUBSTNO(ASLT001, 'SUBMIT')) then begin
            TESTFIELD("Employee No.");
            TESTFIELD("Requested From Date");
            TESTFIELD("Requested To Date");

            if Employee.GET("Employee No.") then
                Employee.TESTFIELD(Employee."Employment Date");

            if "Leave Type" = "Leave Type"::"Annual Leave" then begin
                if (("Requested From Date" - Employee."Employment Date") < 90) then
                    ERROR(ASLT005);
            end;

            "Leave Status" := "Leave Status"::"Pending Approval";
            MODifY;
            COMMIT;
            CalcApprovedLeaveDays;
        end;


        TESTFIELD("Approved From Date");
        TESTFIELD("Approved To Date");
        Employee.SetRange(Employee."Leave From Date Filter", DMY2DATE(1, 1, DATE2DMY(WORKDATE, 3)), WORKDATE);
        Employee.SetRange(Employee."Leave To Date Filter", DMY2DATE(1, 1, DATE2DMY(WORKDATE, 3)), WORKDATE);
        CalcApprovedLeaveDays;
        if Employee.GET("Employee No.") then begin
            case "Leave Type" of
                "Leave Type"::"Annual Leave":
                    begin
                        Employee.CALCFIELDS("Annual Leave Days Taken");
                        AvailableLeaveDays := Employee."Annual Leave Days B/F" + Employee."Annual Leave Days (Current)" - Employee."Annual Leave Days Taken";
                    end;
                "Leave Type"::"Maternity Leave":
                    begin
                        Employee.CALCFIELDS("Maternity Leave Days Taken");
                        AvailableLeaveDays := Employee."Maternity Leave Days" - Employee."Maternity Leave Days Taken";
                    end;
                "Leave Type"::"Paternity Leave":
                    begin
                        Employee.CALCFIELDS("Paternity Leave Days Taken");
                        AvailableLeaveDays := Employee."Paternity Leave Days" - Employee."Paternity Leave Days Taken";
                    end;
                "Leave Type"::"Sick Leave":
                    begin
                        Employee.CALCFIELDS("Study Leave Days Taken");
                        AvailableLeaveDays := Employee."Sick Days" - Employee."Sick Days Taken";
                    end;
                "Leave Type"::"Study Leave":
                    begin
                        Employee.CALCFIELDS("Sick Days Taken");
                        AvailableLeaveDays := Employee."Study Leave Days" - Employee."Study Leave Days Taken";
                    end;
                "Leave Type"::"Compassionate Leave":
                    begin
                        Employee.CALCFIELDS("Compassionate Leave Days Taken");
                        AvailableLeaveDays := Employee."Compassionate Leave Days" - Employee."Compassionate Leave Days Taken";
                    end;
                "Leave Type"::"Leave Without Pay":
                    begin
                        Employee.CALCFIELDS("Leave Without Pay Days Taken");
                        AvailableLeaveDays := Employee."Leave Without Pay Days" - Employee."Leave Without Pay Days Taken";
                    end;
            end;
        end;

        if "Approved Leave Days2" > AvailableLeaveDays then
            ERROR(STRSUBSTNO(ASLT002, FORMAT("Leave Type"), AvailableLeaveDays))
        else begin
            "Leave Status" := "Leave Status"::Approved;
            CalcActualLeaveDays;
            MODifY;
            COMMIT;
        end;

        CalcActualLeaveDays;
        "Leave Status" := "Leave Status"::History;
        "Actual Leave Days" := "Days to be Taken";
        "Approved Leave Days" := 0;
        "Approved Leave Days2" := 0;
        MODifY;
    end;
    //----------------------------------------------------------

    //----------------------------------------------------------
    procedure UpdateLeaveEntitlement()
    var
        myInt: Integer;
    begin
        IF ("Employee No." <> '') THEN BEGIN
            IF Employee.GET("Employee No.") THEN BEGIN
                EmployeeContract.RESET;
                EmployeeContract.SETRANGE(EmployeeContract.Code, Employee."Emplymt. Contract Code");
                IF EmployeeContract.FINDFIRST THEN BEGIN
                    IF "Leave Type" IN [0, 1, 2, 3, 4, 5, 6] THEN BEGIN
                        CASE "Leave Type" OF
                            "Leave Type"::"Annual Leave":
                                BEGIN
                                    P4 := Employee."Annual Leave Days B/F" + Employee."Annual Leave Days (Current)";
                                    "Leave Entitlement" := P4;
                                END;
                            "Leave Type"::"Maternity Leave":
                                BEGIN
                                    "Leave Entitlement" := Employee."Maternity Leave Days";
                                END;
                            "Leave Type"::"Paternity Leave":
                                BEGIN
                                    "Leave Entitlement" := Employee."Paternity Leave Days";
                                END;
                            "Leave Type"::"Sick Leave":
                                BEGIN
                                    "Leave Entitlement" := Employee."Sick Days";
                                END;
                            "Leave Type"::"Study Leave":
                                BEGIN
                                    "Leave Entitlement" := Employee."Study Leave Days";
                                END;
                            "Leave Type"::"Compassionate Leave":
                                BEGIN
                                    "Leave Entitlement" := Employee."Compassionate Leave Days";
                                END;
                            "Leave Type"::"Leave Without Pay":
                                BEGIN
                                    "Leave Entitlement" := Employee."Compassionate Leave Days";
                                END;
                        END;
                    END;
                END;
            END;
        END;
    end;
    //-----------------------------------------------------------

    //-----------------------------------------------------------
    procedure UpdateLeaveDaysAvailable()
    var
        myInt: Integer;
        CurrDate: Date;
        HRSetup: Record "Human Resources Setup";
        CalendarManagement: Codeunit "Calendar Management";
        CalendarDescription: Text[50];
    begin

        AvailableLeaveDays := 0;
        T := 0;
        if ("Employee No." <> '') then begin
            if Employee.GET("Employee No.") then begin
                EmployeeContract.Reset;
                EmployeeContract.SetRange(EmployeeContract.Code, Employee."Emplymt. Contract Code");
                if EmployeeContract.FindFirst then begin
                    if "Leave Type" IN [0, 1, 2, 3, 4, 5, 6] then begin
                        ;
                        case "Leave Type" of
                            "Leave Type"::"Annual Leave":
                                begin

                                    "Leave Days Available" := 0;

                                    EmployeeAbsence3.Reset;
                                    EmployeeAbsence3.SetRange(EmployeeAbsence3."Absence Type", EmployeeAbsence3."Absence Type"::Leave);
                                    EmployeeAbsence3.SetRange(EmployeeAbsence3."Leave Type", EmployeeAbsence3."Leave Type"::"Annual Leave");
                                    EmployeeAbsence3.SetRange(EmployeeAbsence3."Leave Status", EmployeeAbsence3."Leave Status"::History);
                                    EmployeeAbsence3.SetRange(EmployeeAbsence3."Employee No.", "Employee No.");
                                    EmployeeAbsence3.SetRange(EmployeeAbsence3."From Date", 20200101D, 20201231D);
                                    if EmployeeAbsence3.FindFirst then begin
                                        repeat
                                            K3 := K3 + EmployeeAbsence3."Approved Leave Days2";
                                        until EmployeeAbsence3.NEXT = 0;
                                    end else begin
                                        K3 := 0;
                                    end;
                                    //K3 is leave taken in 2018
                                    if K3 > 0 then begin
                                        "Leave Days Available" := P4 - K3;
                                        "Leave Balance" := "Leave Days Available" - "Days to be Taken";
                                    end;

                                    if K3 = 0 then begin
                                        "Leave Days Available" := P4 - K3;
                                        "Leave Balance" := "Leave Days Available" - "Days to be Taken";
                                    end;
                                    /*
                                    //Calculate Pro rate
                                      L1 := (20191231D - Employee."Employment Date");
                                                        L2 := L1 / 30;
                                                        L3 := ROUND(L2, 1, '<');
                                                        //L3 is number of months since employment date;
                                                        L4 := 21 / 12 * L3;
                                                        //L5 is the annual leave entitlement
                                                        L5 := ROUND(L4, 1, '<');
                                                        if L3 < 12 then begin
                                                            "Leave Entitlement" := L5;
                                                        end;
                                    }*/
                                    /*{
                                    EmployeeAbsence.Reset;
                                                            EmployeeAbsence.SetRange(EmployeeAbsence."Employee No.", "Employee No.");
                                                            EmployeeAbsence.SetRange(EmployeeAbsence."Absence Type", EmployeeAbsence."Absence Type"::Leave);
                                                            EmployeeAbsence.SetRange(EmployeeAbsence."Leave Type", EmployeeAbsence."Leave Type"::"Annual Leave");
                                                            EmployeeAbsence.SetRange(EmployeeAbsence."Leave Status", EmployeeAbsence."Leave Status"::History);
                                                            if EmployeeAbsence.FindFirst then begin
                                                                Employee.CALCFIELDS(Employee."Annual Leave Days Taken");

                                                                EmployeeAbsence3.Reset;
                                                                EmployeeAbsence3.SetRange(EmployeeAbsence3."Absence Type", EmployeeAbsence3."Absence Type"::Leave);
                                                                EmployeeAbsence3.SetRange(EmployeeAbsence3."Leave Type", EmployeeAbsence3."Leave Type"::"Annual Leave");
                                                                EmployeeAbsence3.SetRange(EmployeeAbsence3."Leave Status", EmployeeAbsence3."Leave Status"::History);
                                                                EmployeeAbsence3.SetRange(EmployeeAbsence3."Employee No.", "Employee No.");
                                                                EmployeeAbsence3.SetRange(EmployeeAbsence3."From Date", 20200101D, 20201231D);
                                                                if EmployeeAbsence3.FindFirst then begin
                                                                    repeat
                                                                        K3 := K3 + EmployeeAbsence3."Approved Leave Days2";
                                                                    until EmployeeAbsence3.NEXT = 0;
                                                                end;
                                                                K4 := ("Leave Entitlement") - K3;
                                                                "Leave Days Available" := K4;

                                                                "Leave Balance" := "Leave Days Available" - "Days to be Taken";
                                                                //MESSAGE('Leave days available = ' + FORMAT("Leave Days Available") + ' and Days to be taken = ' + FORMAT("Days to be Taken"));
                                                            end else begin
                                                                if (EmployeeAbsence."To Date" <> 0D) AND (EmployeeAbsence."From Date" <> 0D) then begin
                                                                    if (("Leave Days Available" - "Days to be Taken") < 0) then
                                                                        ERROR('You can not apply for leave. You have less or zero days left for the leave: ' + FORMAT("Leave Type"));
                                                                end else begin
                                                                    //"Leave Entitlement" := 21;
                                                                    "Leave Days Available" := "Leave Entitlement";
                                                                    "Leave Balance" := "Leave Days Available" - "Days to be Taken";

                                                                    if (("Leave Days Available" - "Days to be Taken") < 0) then
                                                                        ERROR('You can not apply for leave. You have less or zero days left for the leave: ' + FORMAT("Leave Type"));
                                                                end;

                                                            end;}
                                                            */
                                end;
                            "Leave Type"::"Maternity Leave":
                                begin
                                    "Leave Entitlement" := EmployeeContract."Maternity Leave Days";
                                    EmployeeAbsence.Reset;
                                    EmployeeAbsence.SetRange(EmployeeAbsence."Employee No.", "Employee No.");
                                    EmployeeAbsence.SetRange(EmployeeAbsence."Absence Type", EmployeeAbsence."Absence Type"::Leave);
                                    EmployeeAbsence.SetRange(EmployeeAbsence."Leave Type", EmployeeAbsence."Leave Type"::"Maternity Leave");
                                    EmployeeAbsence.SetRange(EmployeeAbsence."Leave Status", EmployeeAbsence."Leave Status"::History);
                                    if EmployeeAbsence.FindFirst then begin
                                        Employee.CALCFIELDS(Employee."Maternity Leave Days Taken");

                                        EmployeeAbsence3.Reset;
                                        EmployeeAbsence3.SetRange(EmployeeAbsence3."Absence Type", EmployeeAbsence3."Absence Type"::Leave);
                                        EmployeeAbsence3.SetRange(EmployeeAbsence3."Leave Type", EmployeeAbsence3."Leave Type"::"Maternity Leave");
                                        EmployeeAbsence3.SetRange(EmployeeAbsence3."Leave Status", EmployeeAbsence3."Leave Status"::History);
                                        EmployeeAbsence3.SetRange(EmployeeAbsence3."Employee No.", "Employee No.");
                                        EmployeeAbsence3.SetRange(EmployeeAbsence3."From Date", 20200101D, 20201231D);
                                        if EmployeeAbsence3.FindFirst then begin
                                            repeat
                                                K3 := K3 + EmployeeAbsence3."Approved Leave Days2";
                                            until EmployeeAbsence3.NEXT = 0;
                                        end;
                                        K4 := ("Leave Entitlement") - K3;
                                        "Leave Days Available" := K4;
                                        //"Leave Days Available" := ("Leave Entitlement") - (Employee."Maternity Leave Days Taken");

                                        "Leave Balance" := "Leave Days Available" - "Days to be Taken";
                                    end else begin
                                        if (EmployeeAbsence."To Date" <> 0D) AND (EmployeeAbsence."From Date" <> 0D) then begin
                                            if (("Leave Days Available" - "Days to be Taken") < 0) then
                                                ERROR('You can not apply for leave. You have less or zero days left for the leave: ' + FORMAT("Leave Type"));
                                        end else begin
                                            "Leave Days Available" := "Leave Entitlement";
                                            "Leave Balance" := "Leave Days Available" - "Days to be Taken";

                                            if (("Leave Days Available" - "Days to be Taken") < 0) then
                                                ERROR('You can not apply for leave. You have less or zero days left for the leave: ' + FORMAT("Leave Type"));
                                        end;
                                    end;
                                end;
                            "Leave Type"::"Paternity Leave":
                                begin
                                    "Leave Entitlement" := EmployeeContract."Paternity Leave Days";
                                    EmployeeAbsence.Reset;
                                    EmployeeAbsence.SetRange(EmployeeAbsence."Employee No.", "Employee No.");
                                    EmployeeAbsence.SetRange(EmployeeAbsence."Absence Type", EmployeeAbsence."Absence Type"::Leave);
                                    EmployeeAbsence.SetRange(EmployeeAbsence."Leave Type", EmployeeAbsence."Leave Type"::"Paternity Leave");
                                    EmployeeAbsence.SetRange(EmployeeAbsence."Leave Status", EmployeeAbsence."Leave Status"::History);
                                    if EmployeeAbsence.FindFirst then begin
                                        Employee.CALCFIELDS(Employee."Paternity Leave Days Taken");
                                        EmployeeAbsence3.Reset;
                                        EmployeeAbsence3.SetRange(EmployeeAbsence3."Absence Type", EmployeeAbsence3."Absence Type"::Leave);
                                        EmployeeAbsence3.SetRange(EmployeeAbsence3."Leave Type", EmployeeAbsence3."Leave Type"::"Paternity Leave");
                                        EmployeeAbsence3.SetRange(EmployeeAbsence3."Leave Status", EmployeeAbsence3."Leave Status"::History);
                                        EmployeeAbsence3.SetRange(EmployeeAbsence3."Employee No.", "Employee No.");
                                        EmployeeAbsence3.SetRange(EmployeeAbsence3."From Date", 20200101D, 20201231D);
                                        if EmployeeAbsence3.FindFirst then begin
                                            repeat
                                                K3 := K3 + EmployeeAbsence3."Approved Leave Days2";
                                            until EmployeeAbsence3.NEXT = 0;
                                        end;
                                        K4 := ("Leave Entitlement") - K3;
                                        "Leave Days Available" := K4;

                                        //"Leave Days Available" := ("Leave Entitlement") - (Employee."Paternity Leave Days Taken");

                                        "Leave Balance" := "Leave Days Available" - "Days to be Taken";
                                    end else begin
                                        if (EmployeeAbsence."To Date" <> 0D) AND (EmployeeAbsence."From Date" <> 0D) then begin
                                            if (("Leave Days Available" - "Days to be Taken") < 0) then
                                                ERROR('You can not apply for leave. You have less or zero days left for the leave: ' + FORMAT("Leave Type"));
                                        end else begin
                                            "Leave Days Available" := "Leave Entitlement";
                                            "Leave Balance" := "Leave Days Available" - "Days to be Taken";

                                            if (("Leave Days Available" - "Days to be Taken") < 0) then
                                                ERROR('You can not apply for leave. You have less or zero days left for the leave: ' + FORMAT("Leave Type"));
                                        end;
                                    end;
                                end;
                            "Leave Type"::"Sick Leave":
                                begin
                                    "Leave Entitlement" := EmployeeContract."Sick Days";

                                    EmployeeAbsence.Reset;
                                    EmployeeAbsence.SetRange(EmployeeAbsence."Employee No.", "Employee No.");
                                    EmployeeAbsence.SetRange(EmployeeAbsence."Absence Type", EmployeeAbsence."Absence Type"::Leave);
                                    EmployeeAbsence.SetRange(EmployeeAbsence."Leave Type", EmployeeAbsence."Leave Type"::"Sick Leave");
                                    EmployeeAbsence.SetRange(EmployeeAbsence."Leave Status", EmployeeAbsence."Leave Status"::History);
                                    if EmployeeAbsence.FindFirst then begin
                                        Employee.CALCFIELDS(Employee."Sick Days Taken");

                                        EmployeeAbsence3.Reset;
                                        EmployeeAbsence3.SetRange(EmployeeAbsence3."Absence Type", EmployeeAbsence3."Absence Type"::Leave);
                                        EmployeeAbsence3.SetRange(EmployeeAbsence3."Leave Type", EmployeeAbsence3."Leave Type"::"Sick Leave");
                                        EmployeeAbsence3.SetRange(EmployeeAbsence3."Leave Status", EmployeeAbsence3."Leave Status"::History);
                                        EmployeeAbsence3.SetRange(EmployeeAbsence3."Employee No.", "Employee No.");
                                        EmployeeAbsence3.SetRange(EmployeeAbsence3."From Date", 20200101D, 20201231D);
                                        if EmployeeAbsence3.FindFirst then begin
                                            repeat
                                                K3 := K3 + EmployeeAbsence3."Approved Leave Days2";
                                            until EmployeeAbsence3.NEXT = 0;
                                        end;
                                        K4 := ("Leave Entitlement") - K3;
                                        "Leave Days Available" := K4;
                                        //"Leave Days Available" := ("Leave Entitlement") - (Employee."Sick Days Taken");

                                        "Leave Balance" := "Leave Days Available" - "Days to be Taken";
                                    end else begin
                                        if (EmployeeAbsence."To Date" <> 0D) AND (EmployeeAbsence."From Date" <> 0D) then begin
                                            if (("Leave Days Available" - "Days to be Taken") < 0) then
                                                ERROR('You can not apply for leave. You have less or zero days left for the leave: ' + FORMAT("Leave Type"));
                                        end else begin
                                            "Leave Days Available" := "Leave Entitlement";
                                            "Leave Balance" := "Leave Days Available" - "Days to be Taken";

                                            if (("Leave Days Available" - "Days to be Taken") < 0) then
                                                ERROR('You can not apply for leave. You have less or zero days left for the leave: ' + FORMAT("Leave Type"));
                                        end;
                                    end;
                                end;
                            "Leave Type"::"Study Leave":
                                begin
                                    "Leave Entitlement" := EmployeeContract."Study Leave Days";

                                    EmployeeAbsence.Reset;
                                    EmployeeAbsence.SetRange(EmployeeAbsence."Employee No.", "Employee No.");
                                    EmployeeAbsence.SetRange(EmployeeAbsence."Absence Type", EmployeeAbsence."Absence Type"::Leave);
                                    EmployeeAbsence.SetRange(EmployeeAbsence."Leave Type", EmployeeAbsence."Leave Type"::"Study Leave");
                                    EmployeeAbsence.SetRange(EmployeeAbsence."Leave Status", EmployeeAbsence."Leave Status"::History);
                                    if EmployeeAbsence.FindFirst then begin
                                        Employee.CALCFIELDS(Employee."Study Leave Days Taken");

                                        EmployeeAbsence3.Reset;
                                        EmployeeAbsence3.SetRange(EmployeeAbsence3."Absence Type", EmployeeAbsence3."Absence Type"::Leave);
                                        EmployeeAbsence3.SetRange(EmployeeAbsence3."Leave Type", EmployeeAbsence3."Leave Type"::"Study Leave");
                                        EmployeeAbsence3.SetRange(EmployeeAbsence3."Leave Status", EmployeeAbsence3."Leave Status"::History);
                                        EmployeeAbsence3.SetRange(EmployeeAbsence3."Employee No.", "Employee No.");
                                        EmployeeAbsence3.SetRange(EmployeeAbsence3."From Date", 20200101D, 20201231D);
                                        if EmployeeAbsence3.FindFirst then begin
                                            repeat
                                                K3 := K3 + EmployeeAbsence3."Approved Leave Days2";
                                            until EmployeeAbsence3.NEXT = 0;
                                        end;
                                        K4 := ("Leave Entitlement") - K3;
                                        "Leave Days Available" := K4;

                                        //"Leave Days Available" := ("Leave Entitlement") - (Employee."Study Leave Days Taken");

                                        "Leave Balance" := "Leave Days Available" - "Days to be Taken";
                                    end else begin
                                        if (EmployeeAbsence."To Date" <> 0D) AND (EmployeeAbsence."From Date" <> 0D) then begin
                                            if (("Leave Days Available" - "Days to be Taken") < 0) then
                                                ERROR('You can not apply for leave. You have less or zero days left for the leave: ' + FORMAT("Leave Type"));
                                        end else begin
                                            "Leave Days Available" := "Leave Entitlement";
                                            "Leave Balance" := "Leave Days Available" - "Days to be Taken";

                                            if (("Leave Days Available" - "Days to be Taken") < 0) then
                                                ERROR('You can not apply for leave. You have less or zero days left for the leave: ' + FORMAT("Leave Type"));
                                        end;
                                    end;
                                end;
                            "Leave Type"::"Compassionate Leave":
                                begin
                                    "Leave Entitlement" := EmployeeContract."Compassionate Leave Days";

                                    EmployeeAbsence.Reset;
                                    EmployeeAbsence.SetRange(EmployeeAbsence."Employee No.", "Employee No.");
                                    EmployeeAbsence.SetRange(EmployeeAbsence."Absence Type", EmployeeAbsence."Absence Type"::Leave);
                                    EmployeeAbsence.SetRange(EmployeeAbsence."Leave Type", EmployeeAbsence."Leave Type"::"Compassionate Leave");
                                    EmployeeAbsence.SetRange(EmployeeAbsence."Leave Status", EmployeeAbsence."Leave Status"::History);
                                    if EmployeeAbsence.FindFirst then begin
                                        Employee.CALCFIELDS(Employee."Compassionate Leave Days Taken");

                                        EmployeeAbsence3.Reset;
                                        EmployeeAbsence3.SetRange(EmployeeAbsence3."Absence Type", EmployeeAbsence3."Absence Type"::Leave);
                                        EmployeeAbsence3.SetRange(EmployeeAbsence3."Leave Type", EmployeeAbsence3."Leave Type"::"Compassionate Leave");
                                        EmployeeAbsence3.SetRange(EmployeeAbsence3."Leave Status", EmployeeAbsence3."Leave Status"::History);
                                        EmployeeAbsence3.SetRange(EmployeeAbsence3."Employee No.", "Employee No.");
                                        EmployeeAbsence3.SetRange(EmployeeAbsence3."From Date", 20200101D, 20201231D);
                                        if EmployeeAbsence3.FindFirst then begin
                                            repeat
                                                K3 := K3 + EmployeeAbsence3."Approved Leave Days2";
                                            until EmployeeAbsence3.NEXT = 0;
                                        end;
                                        K4 := ("Leave Entitlement") - K3;
                                        "Leave Days Available" := K4;
                                        //"Leave Days Available" := ("Leave Entitlement") - (Employee."Compassionate Leave Days Taken");

                                        "Leave Balance" := "Leave Days Available" - "Days to be Taken";
                                    end else begin
                                        if (EmployeeAbsence."To Date" <> 0D) AND (EmployeeAbsence."From Date" <> 0D) then begin
                                            if (("Leave Days Available" - "Days to be Taken") < 0) then
                                                ERROR('You can not apply for leave. You have less or zero days left for the leave: ' + FORMAT("Leave Type"));
                                        end else begin
                                            "Leave Days Available" := "Leave Entitlement";
                                            "Leave Balance" := "Leave Days Available" - "Days to be Taken";

                                            if (("Leave Days Available" - "Days to be Taken") < 0) then
                                                ERROR('You can not apply for leave. You have less or zero days left for the leave: ' + FORMAT("Leave Type"));
                                        end;
                                    end;
                                end;
                            "Leave Type"::"Leave Without Pay":
                                begin
                                    "Leave Entitlement" := EmployeeContract."Leave Without Pay Days";

                                    EmployeeAbsence.Reset;
                                    EmployeeAbsence.SetRange(EmployeeAbsence."Employee No.", "Employee No.");
                                    EmployeeAbsence.SetRange(EmployeeAbsence."Absence Type", EmployeeAbsence."Absence Type"::Leave);
                                    EmployeeAbsence.SetRange(EmployeeAbsence."Leave Type", EmployeeAbsence."Leave Type"::"Leave Without Pay");
                                    EmployeeAbsence.SetRange(EmployeeAbsence."Leave Status", EmployeeAbsence."Leave Status"::History);
                                    if EmployeeAbsence.FindFirst then begin
                                        Employee.CALCFIELDS(Employee."Leave Without Pay Days Taken");

                                        EmployeeAbsence3.Reset;
                                        EmployeeAbsence3.SetRange(EmployeeAbsence3."Absence Type", EmployeeAbsence3."Absence Type"::Leave);
                                        EmployeeAbsence3.SetRange(EmployeeAbsence3."Leave Type", EmployeeAbsence3."Leave Type"::"Leave Without Pay");
                                        EmployeeAbsence3.SetRange(EmployeeAbsence3."Leave Status", EmployeeAbsence3."Leave Status"::History);
                                        EmployeeAbsence3.SetRange(EmployeeAbsence3."Employee No.", "Employee No.");
                                        EmployeeAbsence3.SetRange(EmployeeAbsence3."From Date", 20200101D, 20201231D);
                                        if EmployeeAbsence3.FindFirst then begin
                                            repeat
                                                K3 := K3 + EmployeeAbsence3."Approved Leave Days2";
                                            until EmployeeAbsence3.NEXT = 0;
                                        end;
                                        K4 := ("Leave Entitlement") - K3;
                                        "Leave Days Available" := K4;
                                        //"Leave Days Available" := ("Leave Entitlement") - (Employee."Leave Without Pay Days Taken");

                                        "Leave Balance" := "Leave Days Available" - "Days to be Taken";
                                    end else begin
                                        if (EmployeeAbsence."To Date" <> 0D) AND (EmployeeAbsence."From Date" <> 0D) then begin
                                            if (("Leave Days Available" - "Days to be Taken") < 0) then
                                                ERROR('You can not apply for leave. You have less or zero days left for the leave: ' + FORMAT("Leave Type"));
                                        end else begin
                                            "Leave Days Available" := "Leave Entitlement";
                                            "Leave Balance" := "Leave Days Available" - "Days to be Taken";

                                            if (("Leave Days Available" - "Days to be Taken") < 0) then
                                                ERROR('You can not apply for leave. You have less or zero days left for the leave: ' + FORMAT("Leave Type"));
                                        end;
                                    end;
                                end;
                        end;
                    end;
                end;
            end;
        end;

    end;
    //-----------------------------------------------------------

    //-----------------------------------------------------------
    procedure CalcLeaveDaysToBeTaken()
    var
        myInt: Integer;
        CurrDate: Date;
        HRSetup: Record "Human Resources Setup";
        CalendarManagement: Codeunit "Calendar Management";
        CalendarDescription: Text[50];
    begin

        if HRSetup.GET then begin
            //Calculate Approved
            if "From Date" = 0D then
                ERROR(ASLT003, 'Actual Leave From Date');

            if "To Date" = 0D then
                ERROR(ASLT003, 'Actual Leave To Date');

            if "To Date" < "From Date" then
                ERROR(ASLT004, 'Actual Leave To Date', 'Actual Leave From Date');
            CurrDate := "From Date";
            "Actual Leave Days" := 0;
            "Days to be Taken" := 0;
            if Employee.GET("Employee No.") then begin
                Employee.TESTFIELD("Major Location");
                MajorLocation.Reset();
                MajorLocation.SetRange(MajorLocation.Type, MajorLocation.Type::"Employee Location");
                MajorLocation.SetRange(Code, Employee."Major Location");
                if MajorLocation.FindFirst() then begin
                    if MajorLocation."Saturday Half Day" then begin
                        repeat
                            if HRSetup."Count NW Days In Leave Period" then begin
                                "Days to be Taken" := "Days to be Taken" + 1
                            end else
                                if NOT CalendarManagement1.CheckDateStatus(HRSetup."HR Calendar", CurrDate, CalendarDescription) then begin
                                    if CalendarManagement1.CheckDateStatusHalfDay(HRSetup."HR Calendar", CurrDate, CalendarDescription) then begin
                                        "Days to be Taken" := "Days to be Taken" + 0.5;
                                    end else
                                        "Days to be Taken" := "Days to be Taken" + 1;
                                end;
                            CurrDate := CurrDate + 1;
                        until CurrDate > "To Date";
                    end else begin
                        repeat
                            if HRSetup."Count NW Days In Leave Period" then
                                "Days to be Taken" := "Days to be Taken" + 1
                            else
                                if NOT CalendarManagement1.CheckDateStatus(HRSetup."HR Calendar", CurrDate, CalendarDescription) then begin
                                    "Days to be Taken" := "Days to be Taken" + 1;
                                end;
                            CurrDate := CurrDate + 1;
                        until CurrDate > "To Date";
                    end;
                end;
            end;
            UpdateAbsenceCode();
            MODifY;
        end;
    end;
    //-----------------------------------------------------------
}
/*
Adroit HRM V1.0.0 - (c)Copyright Adroit Solutions Ltd. 2020.
This object includes confidential information and intellectual property of Adroit Solutions Ltd,
and is protected by local and international copyright and Trade Secret laws and agreements.
-------------------------------------------------------------------------------------------------------------
Change Log
------------------------------------------------------------------------------------------------------------
DATE       | Author               | Version | Description
------------------------------------------------------------------------------------------------------------
25-06-2020 | IVAN EPOU            | V1.0.0  | Version Completed
*/

tableextension 50001 "ConfidentialExt" extends Confidential
{
    fields
    {
        // Add changes to table fields here
        field(50010; Type; Option)
        {
            OptionMembers = " ",Earning,Deduction,"Range Table","Range Table Line","Employee Bank","Employee Location",Appraisal,Training,Discipline,"Pay Basic",Separation,Interview,Course,Branch,"Transfer Reason";
        }
        field(50011; Taxable; Boolean) { }
        field(50012; "Pre-Tax Deductible"; Boolean) { }
        field(50013; "Account Type"; Option)
        {
            OptionMembers = "G/L Account",Vendor;
        }
        field(50014; "Account No."; Code[20])
        {
            TableRelation = IF ("Account Type" = CONST("G/L Account")) "G/L Account"."No." ELSE
            IF ("Account Type" = CONST(Vendor)) Vendor."No.";
        }
        field(50015; "Expense Account No."; Code[20])
        {
            TableRelation = "G/L Account"."No.";
        }
        field(50016; Recurrence; Option)
        {
            OptionMembers = Never,Always,"On Balance";
        }
        field(50017; "Increasing Balance"; Boolean) { }
        field(50018; "Amount Basis"; Option)
        {
            OptionMembers = "Fixed Amount","Percentage of Basic Pay","Percentage of Gross Pay","Percentage of Taxable Pay","Income Tax Amount","Range Table";
        }
        field(50019; "Range Table Basis"; Option)
        {
            OptionMembers = "Basic Pay","Gross Pay","Taxable Pay","Income Tax Amount";
        }
        field(50020; Percentage; Decimal) { }
        field(50021; "Has Employer Component"; Boolean) { }
        field(50022; "Employer Amount Basis"; Option)
        {
            OptionMembers = "Fixed Amount","Percentage of Basic Pay","Percentage of Gross Pay","Percentage of Taxable Pay","Income Tax Amount","Range Table";
        }
        field(50023; "Employer Range Table Basis"; Option)
        {
            OptionMembers = "Basic Pay","Gross Pay","Taxable Pay","Income Tax Amount";
        }
        field(50024; "Employer Percentage"; Decimal) { }
        field(50025; "Default Fixed Amount"; Decimal) { }
        field(50026; "Default Employer Fixed Amount"; Decimal) { }
        field(50027; "Default Threshold Balance"; Decimal) { }
        field(50028; "Threshold Action"; Option)
        {
            OptionMembers = "Use Remaining Amount","Use Regular Amount";
        }
        field(50029; "Minimum Amount"; Decimal) { }
        field(50030; "Maximum Amount"; Decimal) { }
        field(50031; "Use Min/Max If Out of Range"; Boolean) { }
        field(50032; "Customer Posting Group"; Code[10])
        {
            TableRelation = "Customer Posting Group";
        }
        field(50033; "Receivable G/L Account No."; Code[10])
        {
            TableRelation = "G/L Account";
        }
        field(50034; "Cumml. Process Range Table"; Boolean) { }
        field(50035; "Line Number"; Integer) { }
        field(50036; "From Amount"; Decimal) { }
        field(50037; "To Amount"; Decimal) { }
        field(50038; Basis; Option)
        {
            OptionMembers = "Fixed Amount",Percentage;
        }
        field(50039; "Fixed Amount"; Decimal) { }
        field(50040; "Range Percentage"; Decimal) { }
        field(50041; "Min. Amount"; Decimal) { }
        field(50042; "Max. Amount"; Decimal) { }
        field(50043; "Parent Code"; Code[30]) { }
        field(50044; "Range Table Code"; Code[10])
        {
            TableRelation = Confidential.Code WHERE(Type = CONST("Range Table"));
        }
        field(50045; "Employer Range Table Code"; Code[10])
        {
            TableRelation = Confidential.Code WHERE(Type = CONST("Range Table"));
        }
        field(50046; "Payable Posting Type"; Option)
        {
            OptionMembers = Individual,Block;
        }
        field(50047; "Expense Posting Type"; Option)
        {
            OptionMembers = Individual,Block;
        }
        field(50048; "Inc. In SS Cont. Calculation"; Boolean) { }
        field(50049; "Is SS Contribution"; Boolean) { }
        field(50070; "Include on Report"; Boolean) { }
        field(50071; "Payments Journal Template Name"; Code[10])
        {
            TableRelation = "Gen. Journal Template".Name WHERE(Type = CONST(Payments));
        }
        field(50072; "Payments Journal Batch Name"; Code[10])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Payments Journal Template Name"));
        }
        field(50080; "ED Type"; Option)
        {
            OptionMembers = " ",Loan,Interest,Advance,Overtime,Absenteeism;
        }
        field(50090; "Pre-SSF Deductible"; Boolean) { }
        field(50095; "Recurrence Payroll Group Code"; Code[10])
        {
            TableRelation = "Employee Statistics Group".Code;
        }
        field(50100; "Default Fixed Rate"; Decimal) { }
        field(50110; "From Date"; Date) { }
        field(50120; "To Date"; Date) { }
        field(50130; "Institution Code"; Code[10])
        {
            TableRelation = Union;
        }
        field(50140; "Saturday Half Day"; Boolean) { }
        field(50150; "Bank Branch No."; Code[30]) { }
        field(50151; "Bank Code"; Code[30]) { }
        field(50152; "Bank Account No."; Code[30]) { }
        field(50153; "Bank Name"; Code[30]) { }
        field(50154; "Payroll Group"; Code[30])
        {
            TableRelation = "Employee Statistics Group".Code;
        }
        field(50156; Parent; Boolean) { }
        field(50157; "Parent Code2"; Code[30])
        {
            TableRelation = Confidential.Code WHERE(Parent = FILTER(true));
        }
        field(50158; "Customer No."; Code[30])
        {
            TableRelation = Customer."No.";
        }
        field(50159; "Customer Name"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = lookup (Customer.Name where("No." = field("Customer No.")));
            Editable = false;
        }
    }
    keys
    {
        key(PK; Type)
        {

        }
    }
    var
        myInt: Integer;
}
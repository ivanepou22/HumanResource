report 50025 "Item Availability By Location"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'ItemAvailabilityByLocation.rdlc';

    dataset
    {
        dataitem(Location; Location)
        {
            trigger OnPreDataItem()
            var
            begin
                I := 1;
                LocationDesc.Reset();
                LocationDesc.SetRange(LocationDesc."Include in report", true);
                if LocationDesc.FindFirst() then begin
                    repeat
                        LocationCode[I] := LocationDesc.Code;
                        I += 1;
                    until LocationDesc.Next() = 0;
                end;
            end;
        }

        dataitem(LocationInteger; Integer)
        {
            column(LocationCode1; LocationCode[1]) { }
            column(LocationCode2; LocationCode[2]) { }
            column(LocationCode3; LocationCode[3]) { }
            column(LocationCode4; LocationCode[4]) { }
            column(LocationCode5; LocationCode[5]) { }
            column(LocationCode6; LocationCode[6]) { }
            column(LocationCode7; LocationCode[7]) { }
            column(LocationCode8; LocationCode[8]) { }
            column(LocationCode9; LocationCode[9]) { }
            column(LocationCode10; LocationCode[10]) { }
            column(LocationCode11; LocationCode[11]) { }
            column(LocationCode12; LocationCode[12]) { }
            column(LocationCode13; LocationCode[13]) { }
            column(LocationCode14; LocationCode[14]) { }
            column(LocationCode15; LocationCode[15]) { }
            column(LocationCode16; LocationCode[16]) { }
            column(LocationCode17; LocationCode[17]) { }
            column(LocationCode18; LocationCode[18]) { }
            column(LocationCode19; LocationCode[19]) { }
            column(LocationCode20; LocationCode[20]) { }
            column(LocationCode21; LocationCode[21]) { }
            column(LocationCode22; LocationCode[22]) { }
            column(LocationCode23; LocationCode[23]) { }
            column(LocationCode24; LocationCode[24]) { }
            column(LocationCode25; LocationCode[25]) { }
            column(LocationCode26; LocationCode[26]) { }
            column(LocationCode27; LocationCode[27]) { }
            column(LocationCode28; LocationCode[28]) { }
            column(LocationCode29; LocationCode[29]) { }
            column(LocationCode30; LocationCode[30]) { }
            column(LocationCode31; LocationCode[31]) { }
            column(LocationCode32; LocationCode[32]) { }
            column(LocationCode33; LocationCode[33]) { }
            column(LocationCode34; LocationCode[34]) { }
            column(LocationCode35; LocationCode[35]) { }
            column(LocationCode36; LocationCode[36]) { }
            column(LocationCode37; LocationCode[37]) { }
            column(LocationCode38; LocationCode[38]) { }
            column(LocationCode39; LocationCode[39]) { }
            column(LocationCode40; LocationCode[40]) { }
            column(LocationCode41; LocationCode[41]) { }
            column(LocationCode42; LocationCode[42]) { }
            column(LocationCode43; LocationCode[43]) { }
            column(LocationCode44; LocationCode[44]) { }
            column(LocationCode45; LocationCode[45]) { }
            column(LocationCode46; LocationCode[46]) { }
            column(LocationCode47; LocationCode[47]) { }
            column(LocationCode48; LocationCode[48]) { }
            column(LocationCode49; LocationCode[49]) { }
            column(LocationCode50; LocationCode[50]) { }
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

            trigger OnPreDataItem()
            begin
                LocationInteger.SETRANGE(Number, 1, 1);
            end;
        }

        dataitem(Item; Item)
        {
            RequestFilterFields = "No.";
            column(Code_Item; Item."No.") { }
            column(Description_Item; Item.Description) { }
            column(Invetory_Item; Item.Inventory) { }
            column(Quantity1; Quantity[1]) { }
            column(Quantity2; Quantity[2]) { }
            column(Quantity3; Quantity[3]) { }
            column(Quantity4; Quantity[4]) { }
            column(Quantity5; Quantity[5]) { }
            column(Quantity6; Quantity[6]) { }
            column(Quantity7; Quantity[7]) { }
            column(Quantity8; Quantity[8]) { }
            column(Quantity9; Quantity[9]) { }
            column(Quantity10; Quantity[10]) { }
            column(Quantity11; Quantity[11]) { }
            column(Quantity12; Quantity[12]) { }
            column(Quantity13; Quantity[13]) { }
            column(Quantity14; Quantity[14]) { }
            column(Quantity15; Quantity[15]) { }
            column(Quantity16; Quantity[16]) { }
            column(Quantity17; Quantity[17]) { }
            column(Quantity18; Quantity[18]) { }
            column(Quantity19; Quantity[19]) { }
            column(Quantity20; Quantity[20]) { }
            column(Quantity21; Quantity[21]) { }
            column(Quantity22; Quantity[22]) { }
            column(Quantity23; Quantity[23]) { }
            column(Quantity24; Quantity[24]) { }
            column(Quantity25; Quantity[25]) { }
            column(Quantity26; Quantity[26]) { }
            column(Quantity27; Quantity[27]) { }
            column(Quantity28; Quantity[28]) { }
            column(Quantity29; Quantity[29]) { }
            column(Quantity30; Quantity[30]) { }
            column(Quantity31; Quantity[31]) { }
            column(Quantity32; Quantity[32]) { }
            column(Quantity33; Quantity[33]) { }
            column(Quantity34; Quantity[34]) { }
            column(Quantity35; Quantity[35]) { }
            column(Quantity36; Quantity[36]) { }
            column(Quantity37; Quantity[37]) { }
            column(Quantity38; Quantity[38]) { }
            column(Quantity39; Quantity[39]) { }
            column(Quantity40; Quantity[40]) { }
            column(Quantity41; Quantity[41]) { }
            column(Quantity42; Quantity[42]) { }
            column(Quantity43; Quantity[43]) { }
            column(Quantity44; Quantity[44]) { }
            column(Quantity45; Quantity[45]) { }
            column(Quantity46; Quantity[46]) { }
            column(Quantity47; Quantity[47]) { }
            column(Quantity48; Quantity[48]) { }
            column(Quantity49; Quantity[49]) { }
            column(Quantity50; Quantity[50]) { }

            trigger OnPreDataItem()
            var
                myInt: Integer;
            begin
                Item.CalcFields(Inventory);
            end;

            trigger OnAfterGetRecord()
            begin
                Item.CalcFields(Inventory);

                J := 1;
                LocationDesc.RESET;
                LocationDesc.SETRANGE("Include in report", TRUE);
                IF LocationDesc.FINDFIRST THEN
                    REPEAT
                        ItemRecord.SETRANGE("No.", Item."No.");
                        ItemRecord.SETFILTER("Location Filter", LocationDesc.Code);
                        IF (LocationCode[J] <> '') AND (Quantities[J] <> '') THEN
                            ItemRecord.SETFILTER(Inventory, FORMAT(Quantities[J]));
                        IF ItemRecord.FINDFIRST THEN BEGIN
                            ItemRecord.CALCFIELDS(Inventory);
                            Quantity[J] := ItemRecord.Inventory;
                            J += 1;
                        END;
                    UNTIL LocationDesc.NEXT = 0;
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
                    // field(Name; SourceExpression)
                    // {
                    //     ApplicationArea = All;

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
                    ApplicationArea = All;

                }
            }
        }
    }

    trigger OnPreReport()
    begin
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);
    end;

    var
        LocationCode: array[50] of Code[50];
        I: Integer;
        J: Integer;
        CompanyInfo: Record "Company Information";
        LocationDesc: Record Location;
        Quantity: array[50] of Decimal;
        // LocationRecord: Record Location;
        ItemRecord: Record Item;
        Quantities: array[50] of Text[50];

}
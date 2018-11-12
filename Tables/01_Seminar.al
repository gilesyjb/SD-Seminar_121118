table 50101 "CSD Seminar"
{
    Caption = 'Seminar';

    fields
    {
        field(10; "No."; Code[20])
        {
            Caption = 'No.';
            trigger OnValidate()

            begin
                if "No." <> xrec."No." then begin
                    SeminarSetup.get;
                    NoSeriesMgt.TestManual(SeminarSetup."Seminar Nos.");
                    "No. Series" := '';
                end;
            end;

        }
        field(20; "Name"; text[50])
        {
            Caption = 'Name';
            trigger OnValidate()
            begin
                if ("Search Name" = UpperCase(xRec.Name)) or ("Search Name" = '') then
                    "Search Name" := Name;
            end;

        }
        field(30; "Seminar Duration"; Decimal)
        {
            Caption = 'Seminar Duration';
            DecimalPlaces = 0 : 1;

        }
        field(40; "Minimum Participants"; Integer)
        {
            Caption = 'Minimum Participants';

        }
        field(50; "Maximum Participants"; Integer)
        {
            Caption = 'Maximum Participants';

        }
        field(60; "Search Name"; Code[50])
        {
            Caption = 'Search Name';

        }
        field(70; "Blocked"; Boolean)
        {
            Caption = 'Blocked';

        }
        field(80; "Last Date Modified"; Date)
        {
            Caption = 'Last Date Modified';
            Editable = false;

        }
        field(90; "Comment"; Boolean)
        {
            Caption = 'Comment';
            FieldClass = FlowField;
            //CalcFormula = exist("CSD Seminar Comment Line" where("Table Name"= const("Seminar"),"no."=field("No.")));
            Editable = false;


        }
        field(100; "Seminar Price"; Decimal)
        {
            Caption = 'Seminar Price';
            AutoFormatType = 1;

        }
        field(110; "Gen. Prod. Posting Group"; code[10])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";
            trigger OnValidate()
            begin
                if (xrec."Gen. Prod. Posting Group" <> "Gen. Prod. Posting Group") then begin
                    if GenProdPostingGroup.ValidateVatProdPostingGroup(GenProdPostingGroup, "Gen. Prod. Posting Group") then
                        Validate("VAT Prod. Posting Group", GenProdPostingGroup."Def. VAT Prod. Posting Group");
                end;
            end;
        }
        field(120; "VAT Prod. Posting Group"; code[10])
        {
            Caption = 'VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";
        }
        field(130; "No. Series"; code[10])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";
            Editable = false;
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
        key(Key1; "Search Name")
        {
        }
    }

    var
        SeminarSetup: Record "CSD Seminar Setup";
        //CommentLine :Record "CSD Seminar Comment Line";
        Seminar: Record "CSD Seminar";
        GenProdPostingGroup: Record "Gen. Product Posting Group";
        NoSeriesMgt: Codeunit NoSeriesManagement;


    trigger OnInsert()
    begin
        if "No." = '' then begin
            SeminarSetup.Get;
            SeminarSetup.TestField("Seminar Nos.");
            NoSeriesMgt.InitSeries(SeminarSetup."Seminar Nos.", xRec."No. Series", 0D, "No.", "No. Series");
        end;
    end;

    trigger OnModify()
    begin
        "Last Date Modified" := today;
    end;

    trigger OnDelete()
    begin
        // CommentLine.reset;
        // commentline.SetRange("Table Name"),CommentLine."Table Name"::Seminar);
        // commentLine.setrange("No.","No.");
        // CommentLine.DeleteAll;
    end;

    trigger OnRename()
    begin
        "Last Date Modified" := today;
    end;

    procedure AssistEdit(): Boolean
    begin
        with Seminar do begin
            Seminar := Rec;
            Seminarsetup.get;
            seminarsetup.Testfield("Seminar Nos.");
            if NoSeriesMgt.SelectSeries(SeminarSetup."Seminar Nos.", xrec."No. Series", "No. Series") then begin
                NoSeriesMgt.setseries("No.");
                Rec := Seminar;
                exit(true);
            end;
        end;
    end;
}
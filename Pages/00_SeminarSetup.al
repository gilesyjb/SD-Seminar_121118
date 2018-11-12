page 50100 "CSD Seminar Setup"
// CSD - 2018-11-12 - D.E. Veloper
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "CSD Seminar Setup";
    Caption = 'Seminar Setup';
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(Numbering)
            {
                field("Seminar Nos."; "Seminar Nos.")
                {
                }
                field("Seminar Registration Nos."; "Seminar Registration Nos.")
                {
                }
                field("Posted Seminar Reg. Nos."; "Posted Seminar Reg. Nos.")
                {
                }
            }
        }
    }
    trigger OnOpenPage()
    begin
        IF not get then begin
            init;
            insert;
        end;
    end;
}
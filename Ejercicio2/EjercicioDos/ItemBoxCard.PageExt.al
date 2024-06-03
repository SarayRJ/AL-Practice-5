pageextension 70850 PageCaja extends "Item Card"
{
    layout
    {
        addfirst(content)
        {
            field(EsCaja; Rec.EsCaja)
            {
                ApplicationArea = all;
                ToolTip = '';
                Editable = true;

            }

            field(CantidadCaja; Rec.CantidadCaja)
            {
                ApplicationArea = all;
                ToolTip = '';
                Editable = true;

            }

        }
    }

}
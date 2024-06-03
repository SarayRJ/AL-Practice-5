tableextension 70588 PurchaeLineCaja extends "Purchase Line"
{
    fields
    {
        field(70804; EsCajaLinea; Boolean)
        {
            Caption = 'Caja';
            DataClassification = ToBeClassified;



        }

        field(70805; CantidadCajaLinea; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(70806; NoProductoCajaLinea; Code[20])
        {
            DataClassification = ToBeClassified;



        }
        field(70854; LinePrincipal; Integer)
        {
            DataClassification = ToBeClassified;
        }
    }


}
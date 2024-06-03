tableextension 70586 ExtensionTablaProductoCaja extends Item
{
    fields
    {
        field(70800; EsCaja; Boolean)
        {
            DataClassification = ToBeClassified;


        }
        field(70801; CantidadCaja; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(70802; NoProductoCaja; Code[20])
        {
            DataClassification = ToBeClassified;

            TableRelation = Item where(EsCaja = const(true));

        }
    }

}
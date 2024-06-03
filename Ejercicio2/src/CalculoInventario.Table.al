table 70600 "Calculo Inventario"
{
    DataClassification = ToBeClassified;
    Caption = 'Cálculo de inventario';

    fields
    {
        field(1; "No."; Integer)
        {
            Caption = 'No.';

            Editable = false;

        }
        field(2; Producto; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Producto';


        }
        field(3; Nombre; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Nombre';

        }
        field(4; Almacen; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Almacen';

        }
        field(5; Ubicacion; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Ubicación';

        }
        field(6; Cantidad; Decimal)
        {

            Caption = 'Cantidad';




        }
        field(7; Lote; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Lote';

        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {

    }



    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}
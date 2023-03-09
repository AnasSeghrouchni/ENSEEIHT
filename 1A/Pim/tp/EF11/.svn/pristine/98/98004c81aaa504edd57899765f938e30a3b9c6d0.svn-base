with Ada.Command_Line; use Ada.Command_Line;
with Arbre; use Arbre;
with Ada.Text_IO; use Ada.Text_IO;
with Table;use Table;
with Compression;use Compression;


procedure Compresser is
    Commande_inconnu:Exception;
begin
    New_Line;
    if Argument_Count=2 then
        if Argument(1)="-b" then
            Compresse(Argument(2),True);
        else
            Put("La commande ");
            Put(Argument(1));
            put(" n'existe pas.");
        end if;
    else
        Compresse(Argument(1),False);
    end if;
    New_Line;
end Compresser;



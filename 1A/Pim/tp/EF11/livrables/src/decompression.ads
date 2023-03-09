package Decompression is

   procedure Decompresser(Texte_Compresse: in Ada.Streams.Stream_IO.File_Type; Nom_Texte_Comp : in string;
                          Texte_Decompresse: out Ada.Streams.Stream_IO.File_Type; Nom_Texte_DEcomp: in string);

end Decompression;

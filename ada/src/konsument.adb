package body konsument is

   task body Consumer is
      subtype Consumption_Time_Range is Integer range 4 .. 8;
      package Random_Consumption is new
	Ada.Numerics.Discrete_Random(Consumption_Time_Range);
      G: Random_Consumption.Generator;	--  random number generator (time)
      G2: Random_Assembly.Generator;	--  also (assemblies)
      Consumer_Nb: Consumer_Type;
      Assembly_Number: Integer;
      Consumption: Integer;
      Assembly_Type: Integer;
      Consumer_Name: constant array (1 .. Number_Of_Consumers) of String(1 .. 6)
	:= ("Pioter", "Damian");
   begin
      accept Start(Consumer_Number: in Consumer_Type;
		   Consumption_Time: in Integer) do
         Random_Consumption.Reset(G);	--  ustaw generator
         Random_Assembly.Reset(G2);	--  też
         Consumer_Nb := Consumer_Number;
         Consumption := Consumption_Time;
      end Start;
      Put_Line("Started consumer " & Consumer_Name(Consumer_Nb));
      loop
         delay Duration(Random_Consumption.Random(G)); --  simulate consumption
         Assembly_Type := Random_Assembly.Random(G2);
         -- take an assembly for consumption
         B.Deliver(Assembly_Type, Assembly_Number);
         if(Assembly_Number /= 0) then
           Put_Line(Consumer_Name(Consumer_Nb) & ": taken assembly " &
                      Assembly_Name(Assembly_Type) & " number " &
                      Integer'Image(Assembly_Number));
         else Put_Line(Consumer_Name(Consumer_Nb) & ": didn't get an assembly " &
                         Assembly_Name(Assembly_Type));
         end if;
      end loop;
   end Consumer;

end konsument;

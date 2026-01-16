Program RoomGen;

Uses Crt;

Type Room=Record
                Desc:Array[1..10] of String[79];
                North,South,East,West:Byte;
          End;

Var F:Text;
    Filename:String;
    NumberRooms:Byte;

    A:Byte;
    B:Byte;
    R:Room;
    Flag:Boolean;

Begin
     Clrscr;
     Textcolor(Yellow);
     Write('®®®®®®®®®®®®®®®®®®®®®®®®®®®®®®® Room Generator ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯');
     Writeln;
     Textcolor(Magenta);
     Writeln('                                By Spellcaster');
     Writeln;
     Textcolor(Cyan);
     Writeln('Type in the name of the file on which the data of the rooms');
     Writeln('will be write...');
     Textcolor(Green);
     Write('Name of the room-file > ');
     Readln(Filename);
     If Filename='' Then Exit;
     Textcolor(Cyan);
     Writeln('Type in the number of rooms that the game has...');
     Textcolor(LightRed);
     Write('Number of rooms > ');
     Readln(NumberRooms);
     If NumberRooms=0 Then Exit;
     Assign(F,Filename);
     ReWrite(F);
     For A:=1 To NumberRooms Do
     Begin
          Writeln;
          Textcolor(Cyan);
          Writeln('Room ',A);
          Writeln;
          Textcolor(LightGreen);
          For B:=1 To 10 Do R.Desc[B]:='';
          Flag:=True;
          B:=1;
          While Flag Do
          Begin
               Writeln('Description Line ',B);
               Readln(R.Desc[B]);
               If (B=10) Or (R.Desc[B]='*') Then Flag:=False;
               Inc(B);
          End;
          Textcolor(Cyan);
          Writeln;
          Writeln('Type in the exit''s numbers...');
          Writeln;
          Textcolor(LightGreen);
          Write('North > '); Readln(R.North);
          Write('South > '); Readln(R.South);
          Write('East  > '); Readln(R.East);
          Write('West  > '); Readln(R.West);
          B:=1;
          Flag:=True;
          While Flag Do
          Begin
               Writeln(F,R.Desc[B]);
               If (R.Desc[B]='*') Or (B=10) Then Flag:=False;
               Inc(B);
          End;
          Writeln(F,R.North);
          WritelN(F,R.South);
          Writeln(F,R.East);
          Writeln(F,R.West);
     End;
     Writeln;
     Close(F);
     Textcolor(Lightred);
     Writeln('The room data is saved...');
     Textcolor(LightGray);
     Repeat Until Keypressed;
End.
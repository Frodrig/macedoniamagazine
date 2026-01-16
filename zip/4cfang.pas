{ ************************************************************************** }
{ *                                                                        * }
{ *                                FANGLORE                                * }
{ *                                                                        * }
{ *                             BY SPELLCASTER                             * }
{ *                                                                        * }
{ *                              VERSION 0.20                              * }
{ *                                                                        * }
{ *                            DATE : 20-4-1996                            * }
{ *                                                                        * }
{ *                                                                        * }
{ *  Developed of 'The Mag', Issue 8 for the 'Designing a Text Adventure'  * }
{ *  series of articles...                                                 * }
{ *                                                                        * }
{ ************************************************************************** }


Program FangLore;

{ ************************************************************************** }
{ ************************** Unit definition ******************************* }
{ ************************************************************************** }

Uses Crt;    { Use CRT for cute text procedures :) }

{ ************************************************************************** }
{ ************************* Constant definition **************************** }
{ ************************************************************************** }

Const NumberRooms=22;   { Number of rooms in the game }

{ ************************************************************************** }
{ *************************** Type definition ****************************** }
{ ************************************************************************** }

Type RoomType=Record
                    Desc:Array[1..10] of String[79];  { Description }
                    North,South,East,West:Byte;       { Exits }
              End;

     ParsedType=Array[1..10] Of String;

{ ************************************************************************** }
{ ************************* Variable definition **************************** }
{ ************************************************************************** }

Var Rooms:Array[1..NumberRooms] of RoomType;   { Room data }
    CurrentRoom:Word;                          { Speaks for itself... :) }

{ ************************************************************************** }
{ ************************ Procedure definition **************************** }
{ ************************************************************************** }

Function FindSpace(S:String;Start:Byte):Byte;     { Finds the first space    }
                                                  { after the indicated char }
Begin
     While (S[Start+1]<>' ') And (Start<Length(S)) Do Inc(Start);
     FindSpace:=Start;
End;

Function GetString(S:String;Start,Finish:Byte):String;    { Gets a piece of }
                                                          { a string        }
Var A:Byte;
    Tmp:String;
Begin
     Tmp:='';
     For A:=Start+1 To Finish Do Tmp:=Tmp+S[A];
     GetString:=Tmp;
End;

Function Upper(S:String):String;
Var Tmp:String;
    A:Byte;
Begin
     Tmp:='';
     For A:=1 To Length(S) Do Tmp:=Tmp+UpCase(S[A]);
     Upper:=Tmp;
End;

Procedure Parse(S:String;Var Parsed:ParsedType);   { Parses a string }
Var ArrayIndex:Byte;
    StringIndex:Byte;
    NextSpace:Byte;
Begin
     ArrayIndex:=1;
     StringIndex:=0;
     NextSpace:=FindSpace(S,StringIndex);
     While (StringIndex<=Length(S)) And (ArrayIndex<11) Do
     Begin
          NextSpace:=FindSpace(S,StringIndex);
          Parsed[ArrayIndex]:=GetString(S,StringIndex,NextSpace);
          StringIndex:=NextSpace+1;
          Inc(ArrayIndex);
     End;
End;

Procedure Elimin(Var Parsed:ParsedType;Var Index:Byte);
Var A:Byte;
Begin
     For A:=Index To 9 Do Parsed[A]:=Parsed[A+1];
     Parsed[10]:='';
     Dec(Index);
End;

Procedure EliminPrenoms(Var Parsed:ParsedType);
Var A:Byte;
Begin
     For A:=1 To 10 Do
     Begin
          If Parsed[A]='THE' Then Elimin(Parsed,A);
          If Parsed[A]='A' Then Elimin(Parsed,A);
     End;
End;

Procedure ReadRoomData;     { Read from the disk the room data }
Var F:Text;
    A,B:Byte;
    Flag:Boolean;
Begin
     { Prepares the text file for accessing }
     Assign(F,'Room.Dat');
     Reset(F);
     { For every room in the game }
     For A:=1 To NumberRooms Do
     Begin
          { Clear the room's description }
          For B:=1 To 10 Do Rooms[A].Desc[B]:='';
          { Read the description of the room }
          Flag:=True;
          B:=1;
          While Flag Do
          Begin
               Readln(F,Rooms[A].Desc[B]);
               If (B=10) Or (Rooms[A].Desc[B]='*') Then Flag:=False;
               Inc(B);
          End;
          { Read exit data }
          Readln(F,Rooms[A].North);
          Readln(F,Rooms[A].South);
          Readln(F,Rooms[A].East);
          Readln(F,Rooms[A].West);
     End;
     Close(F);
End;

Procedure Look(RoomNumber:Word);        { Looks at the room }
Var A:Byte;
Begin
     Writeln;
     A:=1;
     TextColor(White);
     While (A<11) And (Rooms[RoomNumber].Desc[A]<>'*') Do
     Begin
          Writeln(Rooms[RoomNumber].Desc[A]);
          Inc(A);
     End;
     Writeln;
     TextColor(Yellow);
     Writeln('Visible exits:');
     If Rooms[RoomNumber].North<>0 Then Write('North      ');
     If Rooms[RoomNumber].South<>0 Then Write('South      ');
     If Rooms[RoomNumber].East<>0 Then Write('East       ');
     If Rooms[RoomNumber].West<>0 Then Write('West       ');
     Writeln;
     Writeln;
End;

Procedure Init;      { Initializes game data }
Begin
     ReadRoomData;
     CurrentRoom:=22;
     TextColor(LightGray);
     TextBackground(Black);
     Clrscr;
End;

Procedure Play;      { Playing the game }
Var ExitFlag:Boolean;
    Valid:Boolean;
    Command:String;
    Parsed:ParsedType;
    A:Byte;
    C:Char;
Begin
     ExitFlag:=False;
     Look(CurrentRoom);
     Repeat
           Valid:=False;
           TextColor(White);
           Writeln('What is thy bidding, master ?');
           TextColor(LightGreen);
           Readln(Command);
           { Clear the array }
           For A:=1 To 10 Do Parsed[A]:='';
           Parse(Command,Parsed);
           { Convert to uppercase }
           For A:=1 To 10 Do Parsed[A]:=Upper(Parsed[A]);
           { Eliminate prenoms }
           EliminPrenoms(Parsed);
           { Execute comands }
           If Parsed[1]='LOOK' Then
           Begin
                Valid:=True;
                Look(CurrentRoom);
           End;
           If (Parsed[1]='N') Or (Parsed[1]='NORTH') Then
           Begin
                If Rooms[CurrentRoom].North=0 Then
                Begin
                     TextColor(LightRed);
                     Writeln;
                     Writeln('Sorry, oh Great Lord, but I can''t go that way !');
                     Writeln;
                End
                Else
                Begin
                     TextColor(LightRed);
                     Writeln;
                     Writeln('You go north...');
                     CurrentRoom:=Rooms[CurrentRoom].North;
                     Writeln;
                     Look(CurrentRoom);
                End;
                Valid:=True;
           End;
           If (Parsed[1]='S') Or (Parsed[1]='SOUTH') Then
           Begin
                If Rooms[CurrentRoom].South=0 Then
                Begin
                     TextColor(LightRed);
                     Writeln;
                     Writeln('Sorry, oh Great Lord, but I can''t go that way !');
                     Writeln;
                End
                Else
                Begin
                     TextColor(LightRed);
                     Writeln;
                     Writeln('You go south...');
                     CurrentRoom:=Rooms[CurrentRoom].South;
                     Writeln;
                     Look(CurrentRoom);
                End;
                Valid:=True;
           End;
           If (Parsed[1]='E') Or (Parsed[1]='EAST') Then
           Begin
                If Rooms[CurrentRoom].East=0 Then
                Begin
                     TextColor(LightRed);
                     Writeln;
                     Writeln('Sorry, oh Great Lord, but I can''t go that way !');
                     Writeln;
                End
                Else
                Begin
                     TextColor(LightRed);
                     Writeln;
                     Writeln('You go east...');
                     CurrentRoom:=Rooms[CurrentRoom].East;
                     Writeln;
                     Look(CurrentRoom);
                End;
                Valid:=True;
           End;
           If (Parsed[1]='W') Or (Parsed[1]='WEST') Then
           Begin
                If Rooms[CurrentRoom].West=0 Then
                Begin
                     TextColor(LightRed);
                     Writeln;
                     Writeln('Sorry, oh Great Lord, but I can''t go that way !');
                     Writeln;
                End
                Else
                Begin
                     TextColor(LightRed);
                     Writeln;
                     Writeln('You go west...');
                     CurrentRoom:=Rooms[CurrentRoom].West;
                     Writeln;
                     Look(CurrentRoom);
                End;
                Valid:=True;
           End;
           If Parsed[1]='QUIT' Then
           Begin
                Valid:=True;
                TextColor(LightMagenta);
                Writeln;
                Writeln('Are you sure you want to quit FangLore (Y/N) ?');
                C:=ReadKey;
                If UpCase(C)='Y' Then ExitFlag:=True;
                Writeln;
           End;
           If Not Valid Then
           Begin
                Writeln;
                TextColor(LightRed);
                If Random(100)>50 Then
                   Writeln('Sorry mylord, by thy bidding can''t be obbeyed...')
                Else
                   Writeln('What ?! How the hell am I supposed to do that ??');
                Writeln;
           End;
     Until ExitFlag;
End;

{ ************************************************************************** }
{ **************************** Main  Program ******************************* }
{ ************************************************************************** }

Begin
     Init;
     Play;
End.

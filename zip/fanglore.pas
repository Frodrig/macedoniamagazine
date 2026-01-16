{ ************************************************************************** }
{ *                                                                        * }
{ *                                FANGLORE                                * }
{ *                                                                        * }
{ *                             BY SPELLCASTER                             * }
{ *                                                                        * }
{ *                              VERSION 0.10                              * }
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

Const NumberRooms=2;   { Number of rooms in the game }

{ ************************************************************************** }
{ *************************** Type definition ****************************** }
{ ************************************************************************** }

Type RoomType=Record
                    Desc:Array[1..10] of String[79];  { Description }
                    North,South,East,West:Byte;       { Exits }
              End;

{ ************************************************************************** }
{ ************************* Variable definition **************************** }
{ ************************************************************************** }

Var Rooms:Array[1..NumberRooms] of RoomType;   { Room data }

{ ************************************************************************** }
{ ************************ Procedure definition **************************** }
{ ************************************************************************** }

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

Procedure Init;      { Initializes game data }
Begin
     ReadRoomData;
End;

Begin
     Init;
End.

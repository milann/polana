unit Hotove;

interface

uses Dos,Graph,Grvirt,GrVirt2,Crt,Bitmaps,Mouse,Synmouse,Objekty;

function AskYN(Textik:string):boolean;
procedure GetString(Textik:string;PocetMiest:byte;var Buffer:string);
function GetFileName(Textik:string):string;

implementation

function AskYN(Textik:string):boolean;
         var Yes : TButton;
             No  : TButton;
             x1,x2 : integer;
             Aktion :AktType;
         label koniec;
         begin
             HideMouse;
             AskYN := false;
             Okno('Request',visible,320-trunc(length(Textik)*8/2)-20,160,
                  trunc(length(Textik)*8)+40,90,'Cakam na odpoved...');
             with Yes do begin
                  a:= trunc((ActualMaxX - ActualX)/2) - 65;
                  b:= 30;
                  c:= 61;
                  d:= 19;
                  Name := 'Yes';
                  Mess := 'Ano...';
                  Akt := true;
              end;
             UrobTlacidlo(Yes);

             with No do begin
                  a:= trunc((ActualMaxX - ActualX)/2) + 4;
                  b:= 30;
                  c:= 61;
                  d:= 19;
                  Name := 'No';
                  Mess := 'Nie';
                  Akt := true;
              end;
             UrobTlacidlo(No);
                                SettextStyle(10, 0, 4);
                                SettextJustify(1,0);
                                SetColor(0);
                                outtextxy(321,201,Textik);
                                Setcolor(15);
                                outtextxy(320,200,Textik);
             ShowMouse;
             repeat
                   Control;
                   with EVENT do begin
                     case Typ of
                        2  : begin
                                if ActualPlochaS <> 'Request' then goto koniec;
                                {if RightButton then goto Koniec;}
                                if LeftButton then PracujSnim;
                             end;
                     end;
                   end;

                   GetAction(Aktion);
                   with Aktion do begin
{                   if LeftButtonPressed and (Plocha <> 'Request') then
                      begin
                        AskYN := false;
                        goto koniec;
                      end;}
                   if Typ <> 0 then
                   begin
                        if Typ = 1 then begin
                                     if Meno = 'Yes' then begin
                                             AskYN := true;
                                             goto koniec;
                                     end
                                     else if Meno = 'No' then begin
                                             AskYN := false;
                                             goto koniec;
                                          end;
                       end;
                      end;
                    end;
                   until Aktion.Typ = 1;
                   koniec:
                   ZrusOkno('Request');
         end;

procedure GetString(Textik:string;PocetMiest:byte;var Buffer:string);
          var  Riadko : TRiadokNaPisanie;
               Riadok : RiadokNaPisanie;
          begin
               Okno('Request',unvisible,320-trunc(PocetMiest*8/2)-20,160,
                  trunc(PocetMiest*8)+40,50,'Textik');
               with Riadko do begin
                      RName   := Textik;
                      xx := 10; yy:=20;
                      VidMena := true;
                      PocetM  := PocetMiest;    {pocet miest na pisanie}
                      Txt     := Buffer;  {text v riadku}
                      Akt     := true;
                      Mess    := 'Napis to!';
               end;
               HideMouse;
               Riadok.Init(Riadko);
               Riadok.SetText(Buffer);
               Riadok.Show;
               Riadok.ShowText;
               Riadok.Edit(Actualx+10,2);
               Buffer:=Riadok.Textik;
               Riadok.Done;
               ZrusOkno('Request');
               ShowMouse;
          end;

function GetFileName(Textik:string):string;
          var Subory : TTxtOkno;
              Aktion :AktType;
              PocSub : integer;
              PocAdr : byte;
              SR     : SearchRec;
              SuBS   : array[1..50] of string;
              Dirs   : array[1..25] of string;
          begin
              Okno(Textik,visible,320-150,160,300,200,'Vyber si subor!');
              PocSub:=0;
              FindFirst('*.*', Archive, SR);
              while DosError = 0 do
                    begin
                         PocSub:=PocSub+1;
                         SubS[PocSub] := SR.Name;
                         FindNext(SR);
                    end;
               with Subory do begin
              Name   := 'Files:';
              Mess   := 'Vyberaj!';
              Sposob := 0;
              XX     := 12;
              YY     := 8;
              CelkRiadkov := PocSub;
              Farba  := 7;
              Backgr := 0;
              Znacenie := true;
              Oznaceny := 1;
               end;
             UrobTxtOknoR(3,3,Subory,Subs,1);
              PocAdr:=0;
              FindFirst('*',Directory , SR);
              while DosError = 0 do
                    begin
                         PocAdr:=PocAdr+1;
                         DirS[PocAdr] := SR.Name;
                         FindNext(SR);
                    end;

               with Subory do begin
              Name   := 'Dirs:';
              Mess   := 'Adresare';
              Sposob := 0;
              XX     := 8;
              YY     := 8;
              CelkRiadkov := PocAdr;
              Farba  := 7;
              Backgr := 0;
              Znacenie := true;
              Oznaceny := 1;
               end;
             UrobTxtOknoR(130,3,Subory,Dirs,1);

               repeat
                     Control;
                     with EVENT do begin
                           case Typ of
                                2  : begin
                                          if LeftButton then PracujSnim;
                                     end;
                           end;
                     end;
                     GetAction(Aktion);
               until keypressed;
                ZrusOkno(Textik);
          end;

end.




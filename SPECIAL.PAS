unit Special;

interface

uses Graph,Crt,GrVirt,Mouse,OPL3,PII;

const Nota : array[1..14]  of string[3] =
             ('c','d','e','f','g','a','h',
              'c1','d1','e1','f1','g1','a1','h1');

const PNota : array[1..14]  of string[3] =
             ('c#','d#','0','f#','g#','a#','0',
              'c#1','d#1','0','f#1','g#1','a#1','0');


procedure Klaviatura(x,y:integer);
procedure ZrusKlaviaturu;
procedure PressKlaves(Klaves:polozka);
procedure PutScheme(x,y:integer;Hod:byte);
Procedure PutWave(x,y:integer;Hod:byte);

implementation

procedure ZrusKlaviaturu;
          var prem : byte;
          begin
                 prem:=PocetPoloziek;
               repeat
                      with Polozky[prem]^ do begin
                      if  (Typek = 'K') then begin
                        while prem <> PocetPoloziek do begin
                            Polozky[prem]^ := Polozky[prem+1]^;
                            prem:=prem+1;
                        end;
                        Dispose(Polozky[Prem]);
                        Polozky[prem]:=NIL;
                        PocetPoloziek := PocetPoloziek - 1;
                        exit;
                     end;
                    end;
                     prem := prem - 1;
               until prem = 0;
          end;

Procedure Klaviatura(x,y:integer);
          var yy:integer;
              povx:integer;
              Vel:integer;
              Prem:byte;
              Item:Polozka;
          begin
               Vel := 300;povx:=x+Vel;
               setfillstyle(1,0);
               bar(x,y,x+Vel+8,y+Trunc(Vel/5));
               setfillstyle(1,15);
               x:=x+1;y:=y+1;yy:=y+Trunc(Vel/5)-2;
               for Prem := 1 to 14 do begin
                   bar(x,y,x+trunc(Vel/15),yy);
                   with Item do begin
                        x1:=x;y1:=y;
                        x2:=x+trunc(Vel/15);
                        y2:=yy;
                        Meno   :=Nota[prem];
                        Typek  :='N';
                        Message:='Hraj!';
                   end;
                   PocetPoloziek:=PocetPoloziek+1;
                   New(Polozky[PocetPoloziek]);
                   Polozky[PocetPoloziek]^:=Item;
                  x:=x+trunc(Vel/15)+2;
               end;
               x:=x-Vel+15;
               Setfillstyle(1,0);
               for prem := 1 to 14 do begin
                   if PNota[prem] <> '0' then begin
                      bar(x-trunc(Vel/16/2),y,x+trunc(Vel/16/2)-3,y+35);
                      setColor(8);
                      line(x-trunc(Vel/16/2)+14,y+1,x-trunc(Vel/16/2)+14,y+34);
                      line(x-trunc(Vel/16/2)+1,y+34,x-trunc(Vel/16/2)+13,y+34);
                   with Item do begin
                        x1:=x-trunc(Vel/16/2);y1:=y;
                        x2:=x+trunc(Vel/16/2)-3;
                        y2:=y+35;
                        Meno   :=PNota[prem];
                        Typek  :='N';
                        Message:='Hraj!';
                   end;
                   PocetPoloziek:=PocetPoloziek+1;
                   New(Polozky[PocetPoloziek]);
                   Polozky[PocetPoloziek]^:=Item;
                   end;
                   x:=x+trunc(Vel/15)+2;
               end;

end;

Procedure PressKlaves(Klaves:Polozka);
          var  pocet:byte;
               Poz  :pointer;
          begin
               HideMouse;
               with Klaves do begin
                    if y2 = y1+35 then begin
                       GetMem(Poz,ImageSize(x1+1,y1,x2-1,y2-1));
                       GetImage(x1+1,y1,x2-1,y2-1,Poz^);
                       SetFillStyle(1,4);
                       bar(x1+1,y1,x2-1,y2-1);
                       while LeftButtonPressed do begin
                             readmouse;
                       end;
                       PutImage(x1+1,y1,Poz^,NormalPut);
                       FreeMem(Poz,ImageSize(x1+1,y1,x2-1,y2-1));
                    end
                    else begin
                         SetFillStyle(1,4);
                         Floodfill(x2-3,y2-3,0);
                         while LeftButtonPressed do begin
                               readmouse;
                         end;
                         SetFillStyle(1,15);
                         Floodfill(x1+10,y1+40,0);
                    end;
               end;
            ShowMouse;
          end;

procedure PutOperator(x,y:integer;cislo:byte);
          var cis:string;
          begin
               Setcolor(0);
               SetFillstyle(1,7);
               bar(x-7,y-7,x+7,y+7);
               str(cislo,cis);
               SetTextJustify(1,1);
               Outtextxy(x+1,y+1,cis);
               SetColor(7);
          end;
Procedure PutScheme(x,y:integer;Hod:byte);
          var  pol:integer;
               prem:byte;
               povx:integer;
          begin
               pol:=6;
               Setfillstyle(2,0);
               bar(x+1,y+1,x+159,y+109);
               setcolor(8);
               line(x,y,x+160,y);
               line(x,y,x,y+110);
               setcolor(15);
               line(x+160,y+1,x+160,y+110);
               line(x+1,y+110,x+160,y+110);
               settextstyle(0,0,1);
               setcolor(7);
               povx:=x;
               SetColor(7);
               case hod of
                    2 : begin
                          line(x+15,y+55,x+150,y+55);
                          PutOperator(x+30,y+55,1);
                          line(x+45,y+55,x+45,y+40);
                          line(x+45,y+40,x+15,y+40);
                          line(x+15,y+40,x+15,y+55);
                          PutOperator(x+60,y+55,2);
                          PutOperator(x+90,y+55,3);
                          PutOperator(x+120,y+55,4);
                          line(x+147,y+58,x+150,y+55);
                          line(x+147,y+52,x+150,y+55);
                          line(x+147,y+52,x+147,y+57);
                          line(x+148,y+53,x+148,y+56);
                        end;
                    3 : begin
                          line(x+15,y+35,x+90,y+35);
                          PutOperator(x+30,y+35,1);
                          line(x+45,y+35,x+45,y+20);
                          line(x+45,y+20,x+15,y+20);
                          line(x+15,y+20,x+15,y+35);
                          PutOperator(x+60,y+35,2);

                          line(x+15,y+75,x+90,y+75);
                          PutOperator(x+30,y+75,3);
                          line(x+45,y+75,x+45,y+60);
                          line(x+45,y+60,x+15,y+60);
                          line(x+15,y+60,x+15,y+75);
                          PutOperator(x+60,y+75,4);

                          line(x+90,y+35,x+90,y+75);
                          line(x+90,y+55,x+150,y+55);
                          line(x+147,y+58,x+150,y+55);
                          line(x+147,y+52,x+150,y+55);
                          line(x+147,y+52,x+147,y+57);
                          line(x+148,y+53,x+148,y+56);
                    end;
                    4 : begin
                          line(x+25,y+55,x+150,y+55);
                          PutOperator(x+30,y+55,2);
                          PutOperator(x+60,y+55,3);
                          line(x+15,y+35,x+90,y+35);
                          PutOperator(x+30,y+35,1);
                          line(x+45,y+35,x+45,y+20);
                          line(x+45,y+20,x+15,y+20);
                          line(x+15,y+20,x+15,y+35);
                          line(x+25,y+75,x+90,y+75);
                          PutOperator(x+30,y+75,4);
                          line(x+90,y+35,x+90,y+75);
                          line(x+90,y+55,x+150,y+55);
                          line(x+147,y+58,x+150,y+55);
                          line(x+147,y+52,x+150,y+55);
                          line(x+147,y+52,x+147,y+57);
                          line(x+148,y+53,x+148,y+56);
                       end;
                    5 : begin
                          y:=y+10;
                          line(x+25,y+55,x+150,y+55);
                          PutOperator(x+30,y+55,2);
                          PutOperator(x+60,y+55,3);
                          PutOperator(x+90,y+55,4);
                          line(x+147,y+58,x+150,y+55);
                          line(x+147,y+52,x+150,y+55);
                          line(x+147,y+52,x+147,y+57);
                          line(x+148,y+53,x+148,y+56);
                          line(x+15,y+35,x+120,y+35);
                          line(x+120,y+35,x+120,y+55);
                          PutOperator(x+30,y+35,1);
                          line(x+45,y+35,x+45,y+20);
                          line(x+45,y+20,x+15,y+20);
                          line(x+15,y+20,x+15,y+35);
                          y:=y-10;

                        end;

                    end;

          end;

Procedure PutWave(x,y:integer;Hod:byte);
          var  pol:integer;
               prem:byte;
               povx:integer;
          begin
               x:=x;y:=y;
               pol:=6;
               Setfillstyle(2,0);
               bar(x+2,y+3,x+51,y+27);
               setcolor(10);
               povx:=x;
               x:=x+9;y:=y+15;pol:=6;
               case hod of
                    0 : begin
                           for prem := 1 to 2 do begin
                               ellipse(x,y,0,180,pol,pol-1);
                               ellipse(x+2*pol,y,180,0,pol,pol-1);
                               x:=x+(4*pol);
                           end;
                         end;
                    1 : begin
                             for prem := 1 to 2 do begin
                                Arc(x,y,0,180,pol);
                                Arc(x+(2*pol),y,0,180,pol);
                                x:=x+(4*pol);
                             end;
                        end;
                    2 : begin
                             for prem := 1 to 2 do begin
                                Arc(x,y,0,180,pol);
                                line(x+pol,y,x+trunc(3*pol),y);
                                x:=x+(4*pol);
                             end;
                         end;
                    3 : begin
                             for prem := 1 to 4 do begin
                                 Arc(x,y,90,180,pol);
                                 LineTo(x,y-pol);
                                 line(x,y,x+pol,y);
                                 x:=x+(2*pol);
                              end;
                        end;
                    4 : begin
                           for prem := 1 to 2 do begin
                               line(x-6,y,x-3,y);
                               ellipse(x,y,0,180,3,6);
                               ellipse(x+trunc(2*pol/2),y,180,0,3,6);
                               line(x+10,y,x+17,y);
                               x:=x+(4*pol);
                           end;
                         end;
                    5 : begin
                           for prem := 1 to 2 do begin
                               line(x-6,y,x-3,y);
                               ellipse(x,y,0,180,3,6);
                               ellipse(x+trunc(2*pol/2),y,0,180,3,6);
                               line(x+10,y,x+17,y);
                               x:=x+(4*pol);
                           end;
                         end;
                    6 : begin
                           for prem := 1 to 2 do begin
                               line(x-6,y-5,x-3,y-5);
                               line(x-3,y-5,x-3,y+5);
                               line(x-3,y+5,x+8,y+5);
                               line(x+8,y+5,x+8,y-5);
                               line(x+8,y-5,x+17,y-5);
                               x:=x+(4*pol);
                           end;
                         end;
                    7 : begin
                           for prem := 1 to 2 do begin
                               arc(x-6,y-7,270,0,7);
                               arc(x+17,y+7,90,180,7);
                               line(x+1,y-7,x+10,y+7);
                               x:=x+(4*pol);
                           end;
                         end;

                    end;
             x:=povx;y:=y-15;

            SetColor(15);
            line(x,y,x+54,y);line(x,y,x,y+30);
            line(x+52,y+2,x+52,y+28);line(x+2,y+28,x+52,y+28);
            Setcolor(0);
            line(x+2,y+2,x+51,y+2);{line(x+2,y+2,x+2,y+27);}
            line(x+54,y,x+54,y+30);line(x,y+30,x+54,y+30);
          end;

end.

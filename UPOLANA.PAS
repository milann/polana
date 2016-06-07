unit UPolana;

interface
uses OPL3,Pii,Graph,Grvirt,Crt,Bitmaps,Mouse,Synmouse,Objekty,Hotove,GrVirt2,
     Special;

procedure MainMenu;
procedure UkonciTo;
procedure ChanellTable;
procedure Operator1;
procedure Operator2;
procedure Mixer;
procedure NastavHodnoty;
procedure SaveOpValues;
procedure Klavesy;

var   MenaInstrumentov: array[1..6] of string;
      AktualnyPar     : byte;
      OldWave1,OldWave2:byte;
      OldScheme:byte;

implementation

var Butik : TButton;
    prem  : integer;
    TxOkno : TTxtOkno;

procedure MainMenu;
          begin
               Okno('Main menu',visible,489,370,147,80,'Hlavne menu');
               with  Butik do begin
                     Name := 'Exit';
                     a:=6 ;b:=6;
                     c:=61;d:=19;
                     Mess:= 'Vychod';
                     Akt:= true;
               end;
               UrobTlacidlo(Butik);
               with  Butik do begin
                     Name := 'Options';
                     a:=71 ;b:=6;
                     c:=61;d:=19;
                     Mess:= 'Volby';
                     Akt:= true;
               end;
               UrobTlacidlo(Butik);
               with  Butik do begin
                     Name := 'About';
                     a:=6 ;b:=28;
                     c:=61;d:=19;
                     Mess:= 'O autorovi';
                     Akt:= true;
               end;
               UrobTlacidlo(Butik);
               with  Butik do begin
                     Name := 'Help';
                     a:=71 ;b:=28;
                     c:=61;d:=19;
                     Mess:= 'Pomoc';
                     Akt:= true;
               end;
               UrobTlacidlo(Butik);

          end;

procedure UkonciTo;
          begin
             if AskYN('ARE YOU SHURE TO DO IT THIS WAY ???') then
                 if AskYN('     REALLY ??????     ') then
                 begin
                      Koniec;
                      CloseGraph;
                      writeln('jasam 2000');
                      halt;
                 end;
          end;

procedure ChanellTable;
          begin
               for prem:= 1 to 6 do
                   MenaInstrumentov[prem] := Kanals[prem].Zop.Name;
               Okno('Chanells',visible,489,210,147,159,'Kanaly');
               with TxOkno do begin
                    Name   := 'Kanaliky';
                    Mess   := 'Toto su mena instrumentov';
                    Sposob := 0;
                    XX     := 16;
                    YY     := 6;
                    CelkRiadkov := 6;
                    Farba  := 7;
                    Backgr := 0;
                    Znacenie := true;
                    Oznaceny := 1;
               end;
               UrobTxTOkno(1,1,TxOkno,MenaInstrumentov,1);

               with  Butik do begin
                     Name := 'Name';
                     a:=6 ;b:=83;
                     c:=61;d:=19;
                     Mess:= 'Editacia mena';
                     Akt:= true;
               end;
               UrobTlacidlo(Butik);
               with  Butik do begin
                     Name := 'Info';
                     a:=71 ;b:=83;
                     c:=61;d:=19;
                     Mess:= 'Informacie o instrumente';
                     Akt:= true;
               end;
               UrobTlacidlo(Butik);
               with  Butik do begin
                     Name := 'Load';
                     a:=6 ;b:=105;
                     c:=61;d:=19;
                     Mess:= 'Nahra instrument z disku';
                     Akt:= true;
               end;
               UrobTlacidlo(Butik);
               with  Butik do begin
                     Name := 'Save';
                     a:=71 ;b:=105;
                     c:=61;d:=19;
                     Mess:= 'Ulozi instrument na disk';
                     Akt:= true;
               end;
               UrobTlacidlo(Butik);

          end;

procedure Operator1;
          begin
              with Kanals[AktualKanal].Zop.Ops[AktualnyPar].Opers[1] do begin
               Okno('operator1',unvisible,4,4,215,205,'1.operator');
               UrobPotik('Attack',4,15,'Utok',true,Attack);
               UrobPotik('Decay',44,15,'Zostup',true,Decay);
               UrobPotik('Freq',84,15,'Multiplikacia frekvencie',true,FMul);
               UrobGrZapinac('KSR',6,72,KSR,'Envelope scaling' );
               UrobGrZapinac('Trem.',6,103,Tremolo,'Modulacia frekvencie' );
               UrobGrZapinac('Vib.',6,134,Vibrato,'Modulacia amplitudy' );
               UrobBezec('Attn',65,82,64,0,0,'bezcek',true,Level);
               UrobPotik('attack',104,72,'Utok',true,Sustain);
               UrobPotik('release',148,72,'vypad',true,Release);
               UrobGrZapinac('',126,120,Sus,'Dozvuk' );
               setcolor(15);
               line(ActualX+95,ActualY+92,ActualX+104,ActualY+92);
               line(ActualX+95,ActualY+92,ActualX+95,ActualY+150);
               line(ActualX+95,ActualY+150,ActualX+115,ActualY+150);
               line(ActualX+177,ActualY+150,ActualX+197,ActualY+150);
               line(ActualX+197,ActualY+150,ActualX+197,ActualY+92);
               line(ActualX+188,ActualY+92,ActualX+197,ActualY+92);
               SetTextStyle(2,0,4);
               SetTextJustify(1,1);
               Setcolor(8);
               OutTextXY(ActualX+146,ActualY+151,'SUSTAIN');
               SetColor(15);
               OutTextXY(ActualX+145,ActualY+150,'SUSTAIN');
               UrobPrepinac('KSL',52,175,4,KSL,true,'Key scale level');
               UrobObjekt('Waveform','Vlnovy priebeh',140,15,51,27);
               PutWave(ActualX+140,ActualY+15,Waveform);
               OldWave1:=WaveForm;
            end;
              with Kanals[AktualKanal].Zop.Ops[AktualnyPar] do begin
              UrobPrepinac(' L   R ',13,175,3,RL,true,'Vpravo, vlavo, ci v strede?');
              UrobPrepinac('Feeding',126,175,7,FeedFact,true,'Pozor!');
              end;
          end;

procedure Operator2;
          begin
              with Kanals[AktualKanal].Zop.Ops[AktualnyPar].Opers[2] do begin
               Okno('operator2',unvisible,220,4,215,205,'2.operator');
               UrobPotik('Attack',4,15,'Utok',true,Attack);
               UrobPotik('Decay',44,15,'Zostup',true,Decay);
               UrobPotik('Freq',84,15,'Multiplikacia frekvencie',true,FMul);
               UrobGrZapinac('KSR',6,72,KSR,'Envelope scaling' );
               UrobGrZapinac('Vib.',6,134,Vibrato,'Modulacia amplitudy' );
               UrobGrZapinac('Trem.',6,103,Tremolo,'Modulacia frekvencie' );
               UrobBezec('Attn',65,82,64,0,0,'bezcek',true,Level);
               UrobPotik('attack',104,72,'Utok',true,Sustain);
               UrobPotik('release',148,72,'vypad',true,Release);
               UrobGrZapinac('',126,120,Sus,'Dozvuk' );
               setcolor(15);
               line(ActualX+95,ActualY+92,ActualX+104,ActualY+92);
               line(ActualX+95,ActualY+92,ActualX+95,ActualY+150);
               line(ActualX+95,ActualY+150,ActualX+115,ActualY+150);
               line(ActualX+177,ActualY+150,ActualX+197,ActualY+150);
               line(ActualX+197,ActualY+150,ActualX+197,ActualY+92);
               line(ActualX+188,ActualY+92,ActualX+197,ActualY+92);
               SetTextStyle(2,0,4);
               SetTextJustify(1,1);
               Setcolor(8);
               OutTextXY(ActualX+146,ActualY+151,'SUSTAIN');
               SetColor(15);
               OutTextXY(ActualX+145,ActualY+150,'SUSTAIN');
               UrobObjekt('Waveform','Vlnovy priebeh',140,15,51,27);
               PutWave(ActualX+140,ActualY+15,Waveform);
               OldWave2 := WaveForm;
               with  Butik do begin
                     if AktualnyPar = 1 then
                           Name := 'Swap'
                     else Name:='Swap';
                     a:=117 ;b:=166;
                     c:=61;d:=19;
                     Mess:= 'Zmena operatoroveho paru';
                     Akt:= true;
               end;
               UrobTlacidlo(Butik);

              UrobPrepinac('KSL',52,175,4,KSL,true,'Key scale level');
            end;
          end;

procedure Mixer;
          var RBU : array[1..4] of TButton;
              rr : integer;
          begin
              with Kanals[AktualKanal].Zop do begin
               Okno('mixer',visible,436,4,200,205,'mixer');
               PutScheme(Actualx+3,Actualy+4,FeedType);
               OldScheme:=FeedType;
               rr:=18;
               with RBU[1] do begin
                     Name := '';
                     a:=171 ;b:=5+rr; c:=13;d:=13;
                     Mess:= 'fm-fm';
                     Akt:= true;
               end;
               with RBU[2] do begin
                     Name := '';
                     a:=171 ;b:=25+rr; c:=13;d:=13;
                     Mess:= 'fm-am';
                     Akt:= true;
               end;
               with RBU[3] do begin
                     Name := '';
                     a:=171 ;b:=45+rr; c:=13;d:=13;
                     Mess:= 'am-am';
                     Akt:= true;
               end;
               with RBU[4] do begin
                     Name := '';
                     a:=171 ;b:=65+rr; c:=13;d:=13;
                     Mess:= 'am-fm';
                     Akt:= true;
               end;
               UrobRadioBox('schema',RBU,Feedtype-2,4);
               UrobGrPrepinac('VD @ 7 & 14',10,161,TremDepth+1,'Intenzita tremola');
               UrobGrPrepinac('AD @ 1.0 & 4.8',10,132,VibDepth+1,'Intenzita vibrata');
               UrobBezec('Octave',90,142,7,0,3,'Oktava',true,Kanals[AktualKanal].Oktava);
               UrobGrZapinac('N.Sel',130,145,NoteSel,'??????' );
              end;
          end;
procedure NastavHodnoty;
          begin
              with Kanals[AktualKanal].Zop.Ops[AktualnyPar].Opers[1] do begin
               SetPotik('operator1','Attack',Attack);
               SetPotik('operator1','Decay',Decay);
               SetPotik('operator1','Freq',FMul);
               SetGrZapinac('operator1','KSR',KSR);
               SetGrZapinac('operator1','Trem.',Tremolo);
               SetGrZapinac('operator1','Vib.',Vibrato);
               SetBezec('operator1','Attn',Level);
               SetPotik('operator1','attack',Sustain);
               SetPotik('operator1','release',Release);
               SetGrZapinac('operator1','',Sus);
              SetPrepinac('operator1','KSL',KSL);
              if OldWave1 <> Waveform then begin
                 PutWave(Ploska[GetPlochaNum('operator1')]^.Item.x1+144,
                 Ploska[GetPlochaNum('operator1')]^.Item.y1+18,Waveform);
                 OldWave1:=Waveform;
              end;
            end;
              with Kanals[AktualKanal].Zop.Ops[AktualnyPar] do begin
              SetPrepinac('operator1',' L   R ',RL);
              SetPrepinac('operator1','Feeding',FeedFact);
              end;
              {2nd}
              with Kanals[AktualKanal].Zop.Ops[AktualnyPar].Opers[2] do begin
               SetPotik('operator2','Attack',Attack);
               SetPotik('operator2','Decay',Decay);
               SetPotik('operator2','Freq',FMul);
               SetGrZapinac('operator2','KSR',KSR);
               SetGrZapinac('operator2','Trem.',Tremolo);
               SetGrZapinac('operator2','Vib.',Vibrato);
               SetBezec('operator2','Attn',Level);
               SetPotik('operator2','attack',Sustain);
               SetPotik('operator2','release',Release);
               SetGrZapinac('operator2','',Sus);
              SetPrepinac('operator2','KSL',KSL);
              if OldWave2 <> Waveform then begin
                 PutWave(Ploska[GetPlochaNum('operator2')]^.Item.x1+144,
                 Ploska[GetPlochaNum('operator2')]^.Item.y1+18,Waveform);
                 OldWave2:=Waveform;
              end;
            end;
              with Kanals[AktualKanal].Zop do begin
                 SetGrPrepinac('mixer','AD',VibDepth+1);
                 SetGrPrepinac('mixer','VD',TremDepth+1);
                 SetBezec('mixer','Octave',Kanals[AktualKanal].Oktava);
                 SetGrZapinac('mixer','N.Sel',NoteSel);
                 SetRadioBox('mixer','schema',FeedType-2);
              if OldScheme <> FeedType then begin
                PutScheme(Ploska[GetPlochaNum('mixer')]^.Item.x1+7,Ploska[GetPlochaNum('mixer')]^.Item.y1+7+20,
                GHRadioBox('mixer','schema')+2);
                OldScheme:= GHRadioBox('mixer','schema')+2;
                end;
              end;
          end;

procedure SaveOpValues;
          begin
              with Kanals[AktualKanal].Zop.Ops[AktualnyPar].Opers[1] do begin
               Attack:=GHPotik('operator1','Attack');
               Decay:=GHPotik('operator1','Decay');
               FMul:=GHPotik('operator1','Freq');
               KSR:=GHGrZapinac('operator1','KSR');
               Tremolo:=GHGrZapinac('operator1','Trem.');
               Vibrato:=GHGrZapinac('operator1','Vib.');
               Level:=GHBezec('operator1','Attn');
               Sustain:=GHPotik('operator1','attack');
               Release:=GHPotik('operator1','release');
               Sus:=GHGrZapinac('operator1','');
              KSL:=GHPrepinac('operator1','KSL');
            end;
              with Kanals[AktualKanal].Zop.Ops[AktualnyPar] do begin
              RL:=GHPrepinac('operator1',' L   R ');
              FeedFact:=GHPrepinac('operator1','Feeding');
              end;
              {2nd}
              with Kanals[AktualKanal].Zop.Ops[AktualnyPar].Opers[2] do begin
               Attack:=GHPotik('operator2','Attack');
               Decay:=GHPotik('operator2','Decay');
               FMul:=GHPotik('operator2','Freq');
               KSR:=GHGrZapinac('operator2','KSR');
               Tremolo:=GHGrZapinac('operator2','Trem.');
               Vibrato:=GHGrZapinac('operator2','Vib.');
               Level:=GHBezec('operator2','Attn');
               Sustain:=GHPotik('operator2','attack');
               Release:=GHPotik('operator2','release');
               Sus:=GHGrZapinac('operator2','');
              KSL:=GHPrepinac('operator2','KSL');
           end;
              with Kanals[AktualKanal].Zop do begin
                 VibDepth:=GHGrPrepinac('mixer','AD')-1;
                 TremDepth:=GHGrPrepinac('mixer','VD')-1;
                 Kanals[AktualKanal].Oktava:=GHBezec('mixer','Octave');
                 NoteSel:=GHGrZapinac('mixer','N.Sel');
                 FeedType:=GHRadioBox('mixer','schema')+2;
              end;
          end;

procedure Klavesy;
          begin
               Okno('NIMITZ                              POLANA S288.«',visible,85,320,317,87,'klaviatura');
               Klaviatura(Actualx,ActualY);
          end;


end.


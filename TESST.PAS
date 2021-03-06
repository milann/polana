uses OPL3,Pii,Graph,Grvirt,Crt,Bitmaps,Mouse,Synmouse,Objekty,Hotove,GrVirt2,
     UPolana,Special;

var Aktion  : AktType;
    Retazec : string;
    prem    : byte;


begin
{aktivacia opl a mysi}
write('Detekujem OPL3 cip.....');
InitOPL;
writeln('OK');
InitChanells;
AktualnyPar:=1;
AktualnyPar:= Load4Inst('milanko.pi');
Kanals[1].SetSound;
Kanals[1].Oktava:=3;
Kanals[1].Frekvencia:=2440;
{with Kanals[1].Zop do begin
     FeedType := 2;
     with Ops[1].Opers[2] do begin
          WaveForm := 2;
     end;
end;
AktualnyPar:=1;
AktualnyPar:= Save4Inst('d:\tp7\test.pi');}
AktualnyPar:=1;
{Kanals[1].PlayIt;}
{repeat
until keypressed;
halt;            }

if not InitMouse then
   begin
        writeln('Nenasiel som mysku!!!');
        halt;
   end;
{}

DeskTopCreate('Polana s288 synthesizer <c> 1900',9,8);
   MainMenu;
   ChanellTable;
   Operator1;
   Operator2;
   Mixer;
   Klavesy;
   SetGraphicCursor(Sipka.Cursor);
   AktualKurzor:=sipka;
   ShowMouse;
{PanelInstrumentov;}
repeat
           readmouse;
           Control;
           with EVENT do begin
                case Typ of
                     2  : begin
                               if LeftButton then PracujSnim;
                          end;
                end;
           end;

           GetAction(Aktion);
           if Aktion.Typ <> 0 then
              begin
                   with Aktion do begin
                        case Typ of
                             1 : begin
                                    if Plocha = 'Main menu' then begin
                                              if Meno = 'Exit' then UkonciTo;
                                             end
                                    else if Plocha = 'operator2' then begin
                                                SaveOpValues;
                                                if  AktualnyPar = 1 then AktualnyPar:=2
                                                else AktualnyPar:=1;
                                                NastavHodnoty;
                                    end
                                     else if Plocha = 'Chanells' then begin
                                               if Meno ='Name' then begin
                                                  Retazec:=MenaInstrumentov[AktualKanal];
                                                  GetString('Enter name:',16,Retazec);
                                                   MenaInstrumentov[AktualKanal] :=Retazec;
                                                  RewriteTxtOkno('Chanells','Kanaliky',MenaInstrumentov);
                                                end
                                                else if Meno='Load'then begin
                                                          GetString('filename:',8,Retazec);
                                                          prem:= Load4Inst(Retazec+'.pi');
                                                end
                                                else if Meno = 'Save' then begin
                                                     if AskYN('Are you shure?') then begin
                                                          GetString('filename:',8,Retazec);
                                                          prem:= Save4Inst(Retazec+'.pi');
                                                     end;
                                                end;


                                     end;

                                     end;
                              3 : begin
                                       if Plocha = 'Chanells' then
                                               begin
                                                 SaveOpValues;
                                                 AktualKanal := Value;
                                                 NastavHodnoty;
                                               end;
                                 end;
                              10 : begin
                                       HideMouse;
                                       if Meno = 'Waveform' then begin
                                               if Plocha = 'operator1' then begin
                                               Kanals[AktualKanal].Zop.Ops[AktualnyPar].Opers[1].Waveform :=
                                               Kanals[AktualKanal].Zop.Ops[AktualnyPar].Opers[1].Waveform +1;
                                               if Kanals[AktualKanal].Zop.Ops[AktualnyPar].Opers[1].Waveform > 7 then
                                               Kanals[AktualKanal].Zop.Ops[AktualnyPar].Opers[1].Waveform := 0;
                          PutWave(Ploska[GetPlochaNum(Plocha)]^.Item.x1+144,Ploska[GetPlochaNum(Plocha)]^.Item.y1+18,
                          Kanals[AktualKanal].Zop.Ops[AktualnyPar].Opers[1].Waveform);
                                                OldWave1:= Kanals[AktualKanal].Zop.Ops[AktualnyPar].Opers[1].Waveform;
                                               end
                                               else begin
                                               Kanals[AktualKanal].Zop.Ops[AktualnyPar].Opers[2].Waveform :=
                                               Kanals[AktualKanal].Zop.Ops[AktualnyPar].Opers[2].Waveform +1;
                                               if Kanals[AktualKanal].Zop.Ops[AktualnyPar].Opers[2].Waveform > 7 then
                                               Kanals[AktualKanal].Zop.Ops[AktualnyPar].Opers[2].Waveform := 0;
                          PutWave(Ploska[GetPlochaNum(Plocha)]^.Item.x1+144,Ploska[GetPlochaNum(Plocha)]^.Item.y1+18,
                          Kanals[AktualKanal].Zop.Ops[AktualnyPar].Opers[2].Waveform);
                                                OldWave2:= Kanals[AktualKanal].Zop.Ops[AktualnyPar].Opers[2].Waveform;
                                               end;
                                               end;
                                               ShowMouse;
                          end;
                         4 : begin
                                       if Plocha = 'mixer' then begin
                                          HideMouse;
                          PutScheme(Ploska[GetPlochaNum(Plocha)]^.Item.x1+7,Ploska[GetPlochaNum(Plocha)]^.Item.y1+7+20,
                           GHRadioBox('mixer','schema')+2);
                          Kanals[AktualKanal].Zop.Feedtype := GHRadioBox('mixer','schema')+2;
                          OldScheme:= GHRadioBox('mixer','schema')+2;
                           ShowMouse;
                        end;
                        end;
                        15 : begin
                                   SaveOpValues;
                                   Kanals[AktualKanal].SetFreq(GetFreq(NajdenaPolozka.Meno));
                                   Kanals[AktualKanal].SetSound;
                                   Kanals[AktualKanal].PlayIt;
                                   PressKlaves(NajdenaPolozka);
                                   Kanals[AktualKanal].StopIt;
                             end;
                   end;
                   end;
              end;

until RightButtonPressed and LeftButtonPressed;

ZrusChanells;
end.


unit SynMouse;

interface

uses Mouse,Grvirt;

const DefaultObjekt : Polozka =(
                    x1:0;y1:0;x2:0;y2:0;
                    Meno:'';
                    Typek:'!';
                    Message:'');


type CT = record
                Meno   : string;
                Cursor : TGraphicCursor;
          end;


const Krizik : CT = (Meno : 'krizik';
                  Cursor : (
                  HotSpotX : 7; HotSpotY : 7;
                  Masks : (($FFFF,$FFFF,$FFFF,$F93F,$F93F,
                            $F93F,$C107,$C107,$FFFF,$C107,
                            $C107,$F93F,$F93F,$F93F,$FFFF,
                            $FFFF),($0000,$0000,$0000,$0280,
                            $0280,$0280,$0280,$3EF8,$0000,
                            $3EF8,$0280,$0280,$0280,$0280,
                            $0000,$0000))));

      Sipka : CT = (Meno : 'sipka';
                  Cursor : (
                  HotSpotX : 1; HotSpotY : 1;
                  Masks : (($3FFF,$1FFF,$0FFF,$07FF,$03FF,
                            $01FF,$00FF,$007F,$003F,$001F,
                            $000F,$0FFF,$1FFF,$3FFF,$7FFF,
                            $FFFF),($0000,$4000,$6000,$7000,
                            $7800,$7C00,$7E00,$7F00,$7F80,
                            $7FC0,$7000,$6000,$4000,$0000,
                            $0000,$0000))));


      Ruka : CT = (Meno : 'ruka';
                 Cursor : (
                 HotSpotX : 4; HotSpotY : 1;
		 Masks : (($f3ff,$e1ff,$e1ff,$e1ff,$e049,
                           $e000,$8000,$0000,$0000,$0000,
			   $0000,$8000,$c001,$e001,$e001,
			   $e001),($0000,$0c00,$0c00,$0c00,
			   $0c00,$0db6,$0db6,$6db6,$6ffe,
			   $6ffe,$7ffe,$3ffe,$1ffc,$0ffc,
			   $0ffc,$0000))));

      Posuv : CT = (Meno : 'posuv';
                 Cursor : (
                 HotSpotX : 7; HotSpotY : 7;
                 Masks : (($FEFF,$FC7F,$F83F,$F01F,$E00F,
                           $C107,$E38F,$FFFF,$E38F,$C107,
                           $E00F,$F01F,$F83F,$FC7F,$FEFF,
                           $FFFF),($0000,$0100,$0380,$07C0,
                           $0EE0,$1C70,$0000,$0000,$0000,
                           $1C70,$0EE0,$07C0,$0380,$0100,
                           $0000,$0000))));

      Pero : CT = (Meno : 'pero';
                 Cursor : (
                 HotSpotX : 7; HotSpotY : 7;
                 Masks : (($F93F,$F01F,$F83F,$FC3F,$F87F,
                           $FC3F,$F87F,$FC3F,$F87F,$FC3F,
                           $F87F,$FC3F,$F87F,$F83F,$F01F,
                           $F93F),($0000,$06C0,$0100,$0180,
                           $0200,$0180,$0200,$0180,$0200,
                           $0180,$0200,$0180,$0200,$0100,
                           $06C0,$0000))));



      Hand : CT = (Meno : 'hand';
                 Cursor : (
                 HotSpotX : 8; HotSpotY : 8;
                 Masks : (($FE7F,$F00F,$E007,$8007,$0001,
                           $0000,$0000,$0000,$0000,$8000,
                           $8001,$C003,$E007,$E007,$E007,
                           $E007),($0000,$0180,$0DB0,$0DB0,
                           $6DB0,$6DB6,$6DB6,$6DB6,$7FFE,
                           $3FFE,$3FFC,$1FF8,$0FF0,$0FF0,
                           $0FF0,$0000))));

      Vytacak : CT = (Meno : 'vytoc';
                     Cursor : (
                     HotSpotX : 8; HotSpotY : 8;
                     Masks:(($FE3F,$FC1F,$F80F,$F007,$E000,
                             $C000,$8000,$C000,$C000,$8380,
                             $8780,$8600,$8001,$C01F,$E03F,
                             $F0FF),($0000,$01C0,$0060,$07F0,
                             $0FF8,$187E,$37FE,$0FFE,$1C3E,
                             $383E,$303E,$307E,$21E0,$0FC0,
                             $0F00,$0000))));

var AktualKurzor : CT;
    NajdenaPolozka    : Polozka;
    AktualnaPolozka   : Polozka;
    StlacenaPolozka   : Polozka;
    Pricina      : boolean;
    SmeNaPloche  : boolean;

implementation


function IntToStr(i: Longint): string;
         var s: string[11];
         begin
           Str(i, s);
           IntToStr := s;
         end;

end.





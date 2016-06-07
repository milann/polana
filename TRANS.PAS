{Trans unit, (c) 1998 ASIX}
unit Trans;
interface
const HexString : array[0..15] of string[1] = ('0','1','2','3','4','5','6','7',
                                              '8','9','a','b','c','d','e','f');
procedure Sleep;                        {special procedure,"sleep" until keypressed}
function DecToHex(Decimal:word):string; {converts decimal to hexadecimal}
function HexToDec(Hexa:string):word;    {...hexadecimal to decimal}
function DecToBin(Decimal:word):string; {...decimal to binary}
function BinToDec(Bina:string):word;    {...binary to decimal}

implementation
var prem1,prem2,pr3:byte;

procedure Sleep;assembler;
      asm
         mov ax,0
         int 16h
      end;

function DecToHex(Decimal:word):string;
         var HexNum:string;
         begin
             HexNum:='';
             if Decimal > 15 then
               begin
                  repeat
                     Insert(HexString[Decimal mod 16],HexNum,1);
                     Decimal := trunc(Decimal/16);
                  until Decimal < 16;
               end; prem2:=1;
               Insert(HexString[Decimal mod 16],HexNum,1);
               DecToHex := HexNum;
          end;

function HexToDec(Hexa:string):word;
         var Lett: string[1];
             Cis:array[1..4] of byte;
             Expo,Vysl:word;
         begin
            for prem1:=1 to length(Hexa) do begin
                Lett:=copy(Hexa,prem1,1);
                for prem2:=0 to 15 do begin
                   if UpCase(HexString[prem2][1])=Upcase(Lett[1]) then Cis[prem1]:=prem2;
                end;
            end;Expo:=1;Vysl:=0;
            for prem1:=1 to length(Hexa)-1 do Expo:=Expo*16;
            for prem1:=1 to length(Hexa) do begin
                 Vysl:=Vysl+Cis[prem1]*Expo;Expo:=trunc(Expo div 16);
            end;
            HexToDec:=Vysl;
         end;

function DecToBin(Decimal:word):string;
         var BinNum:string;
             S : string[1];
         begin
             BinNum:='';
             if Decimal > 1 then
               begin
                  repeat
                     Str((Decimal mod 2),S);
                     Insert(S,BinNum,1);
                     Decimal := trunc(Decimal/2);
                  until Decimal < 2;
               end; prem2:=1;
               Str((Decimal mod 2),S);
               Insert(S,BinNum,1);
               DecToBin := BinNum;
          end;

function BinToDec(Bina:string):word;
         var Lett: string[1];
             Cis:array[1..4] of byte;
             Expo,Vysl:word;
         begin
            Expo:=1;Vysl:=0;
            for prem1:= length(Bina) downto 1 do begin
                Lett:=copy(Bina,prem1,1);
                if Lett = '1' then Vysl:=Vysl+Expo;
                Expo:=Expo*2;
            end;
            BinToDec:=Vysl;
         end;
end.
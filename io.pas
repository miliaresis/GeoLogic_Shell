unit io;
interface
    uses  Windows, Messages, SysUtils, Dialogs;
const ArraySize1= 4401;  {ROWS}
      ArraySize2= 4401;  {COLUMNS}
      Number_of_objects = 32768;   {number of objects in a bitmap equals to the limit of a 2-byte integer}
Type
   ElevationArray = array [1..arraysize1, 1..arraysize2] of integer;
   BBBB=     array [1..Number_of_objects] of integer;
   BBBBreal= array [1..Number_of_objects] of real;
   function GetInteger(Caption: string; var I: Integer): Boolean;
   function GetString(Caption: string; var S: string): Boolean;
   procedure Initialize;
   Procedure Read_DOC_GMD_FILE (basicfilename:string; var Arows,Acols,Adatatypeid:integer;var Aspacing:real);
   procedure READIMAGEFILE (Basicfilename:string;var Amin,Amax:integer);
   procedure DISPLAYIMAGEFILE(var BB:elevationarray);
   procedure WRITEIMAGEFILE ;
   procedure SAVE2TIF (var AAA:char) ;
   Procedure first_last_Row_Column;
   procedure ASPECT_UPSLOPE (strx:string) ;
   procedure CURVATUREs_all (strx:string; var min,max:real) ;
   procedure CONNECTED_COMPONENTs_LABELLING (strx:String; Var count:integer);
   procedure OBJECT_STATISTICS (var str:string; var sizemean,sizemin,sizemax:real; var BB:BBBB);
   procedure DESPECLE (strx:string; var Pits_removed:integer);
   Procedure Border (var length:integer; Chara:char);
   Procedure SIZE_FILTERING (var K,LL,LLLL:integer);
   Procedure LABELPIXELS(k:integer;Ch:char;var Points:integer);
   Procedure INVERTLUT;
   Procedure Bubble_sort (var Ia,Io:BBBB; Ksize:integer);
   Procedure IterativeRUNOFF ( rows,cols:integer; var iteration:integer );
   Procedure ReplaceMAtrix;
   Procedure INTERSECT (new:string;new1:String;new2:String);
   Procedure Linethinning (var count1,count2,iter:integer);
   Procedure SEGMATRIX (var k:integer);
   Procedure RECGROW (k1,k2:integer; var Total,CountIterations:integer);
   Procedure MOMENTS ( var p,q:integer; var BB:BBBBreal);
   procedure DESPECLE16 (strx:string; SIZEOFKERNEL:integer; var Pits_removed:integer);
Var
  a,b:elevationarray;
  PAINTID,Arows,Acols,Adatatypeid,Amin,Amax,Brows,Bcols,Bdatatypeid,Bmin,Bmax:integer;
  Aspacing,Bspacing:real; imageinvert,imageinvert2:string[9];
  epiloges: set of char; chara:char;
  Basicfilename,Outputfilename,AorB:string;
  p18,flat,ZeroCurvature:real;  factor:integer; //Thresholds

implementation

function GetInteger(Caption: string; var I: Integer): Boolean; var S: string;
   begin S:='';Result:=InputQuery(Caption,'Enter number: ',S);i:=StrToInt(S);end;
function GetString(Caption: string; var S: string): Boolean;
   begin S:='';Result:=InputQuery(Caption,'Enter string:',S);end;
//####################################################
procedure Initialize;
var i,j:integer;
begin
   for i:=1 to Arows do begin for j:=1 to Acols do begin
      a[i,j]:=0; b[i,j]:=0;  end;end;Amin:=0;Amax:=0;
   Bmin:=0;Bmax:=0;Brows:=0;Bcols:=0;Bdatatypeid:=0;
end;
//###################################################
Procedure Read_DOC_GMD_FILE (basicfilename:string; var Arows,Acols,Adatatypeid:integer;var Aspacing:real);
   var s2:string[14];strx:string;file2:textfile;
begin
 assignfile(file2,Basicfilename+'.rdc');reset (file2);
 Readln(file2,s2);Readln(file2,s2);Readln(file2,s2,s2);
 if s2='integer' then Adatatypeid:= 2 else if s2='byte' then Adatatypeid:= 1;
 If (Adatatypeid=1) or (Adatatypeid=2) then begin strx:=' Data type: ';
   If Adatatypeid=1 then strx:=strx+' byte '
     else if Adatatypeid=2 then strx:=strx+' integer';
   Readln(file2,s2);Readln(file2,s2,Acols);Readln(file2,s2,Arows);
   Readln(file2,s2);Readln(file2,s2);Readln(file2,s2);Readln(file2,s2);
   Readln(file2,s2);Readln(file2,s2);Readln(file2,s2);Readln(file2,s2);
   Readln(file2,s2,Aspacing);
  end;
 closefile(file2);
end;
//###################################################
procedure READIMAGEFILE (Basicfilename:string;var Amin,Amax:integer);
  Var
    file1:file;
    xcols,xrows,bytesread,k,i,j:integer;
    b:array [0..1023] of byte;
   Procedure INTEGERFILETYPE;
      Var j:integer;
         begin
           k:=0;
           For j:=0 to bytesread-1 do begin  k:=k+1;
              if k=1 then begin xcols:=xcols+1;
                 If xcols=Acols then begin xcols:=0;xrows:=xrows+1;
                 end;
                 k:=k+1; a[xrows,xcols]:=b[j]+(b[j+1]*256);
 {negatives handling} if a[xrows,xcols]>32768 then a[xrows,xcols]:=a[xrows,xcols]-65536; 
              end else begin k:=0; end;
          end;end;
     Procedure ByteFILETYPE;
         Var j:integer;
         begin
           For j:=0 to bytesread-1 do begin xcols:=xcols+1;
             If xcols=Acols then begin xcols:=0; xrows:=xrows+1;
             end; k:=k+1; a[xrows,xcols]:=b[j];
         end;end;
begin
   assignfile(file1,Basicfilename+'.rst'); reset (file1,1);
   xcols:=0; xrows:=1;
   while not eof (file1) do begin
      Blockread(file1,b,sizeof(b),bytesread);
      if ADatatypeid=2  then INTEGERFILETYPE;
      if ADatatypeid=1  then ByteFILETYPE;
  end; closefile(file1);
  Amin:=a[1,1];Amax:=a[1,1];
  for i:=1 to Arows do begin for j:=1 to Acols do begin
      if Amin>a[i,j] then Amin:=a[i,j];
      if Amax<a[i,j] then Amax:=a[i,j];
  end;end;
end;
///#########################################################
procedure DISPLAYIMAGEFILE (var BB:elevationarray);
var i,j,ypolipo,rows,cols:integer;
    min,max:integer;
begin
  if (AorB='A') or (AorB='a') then begin max:=Amax; min:=Amin;rows:=Arows;cols:=Acols;
  end else begin max:=Bmax; min:=Bmin;rows:=Brows;cols:=Bcols; end;
  For i:=1 to rows do begin for j:=1 to cols do begin
  if max<>min then begin
         if (AorB='A') or (AorB='a') then
            ypolipo:=trunc((a[i,j]-min)*255/(max-min))
         else ypolipo:=trunc((b[i,j]-min)*255/(max-min));
         bb[i,j]:=ypolipo;
  end;end;end;
end;
//#####################################################
Procedure WRITEIMAGEFILE;
 var  file2:file; strx:string[10];
      file1: textfile;
      Procedure WRITEINTEGER;
      var i,l,k:integer;bbb: array [1..1024] of byte;
       begin
        k:=0;
        For l:=1 to BRows do begin For i:=1 to BCols do begin
           k:=k+1; bbb[k]:=lo(b[l,i]); k:=k+1; bbb[k]:=hi(b[l,i]);
           if k=1024 then begin  blockwrite(file2,bbb,8); k:=0; end;
        end;end;
        blockwrite(file2,bbb,8);
      end;
      Procedure WRITEBYTE;
      var i,l,k:integer; bbb: array [1..1024] of byte;
      begin
        k:=0;
        For l:=1 to BRows do  begin For i:=1 to BCols do begin
          k:=k+1; bbb[k]:=b[l,i];
          if k=1024 then begin blockwrite(file2,bbb,8); k:=0; end;
        end;end;
        blockwrite(file2,bbb,8);
      end;
  begin
     assignfile (file2,outputfilename+'.rst');rewrite(file2);
     assignfile (file1,outputfilename+'.rdc');rewrite(file1);
     if Bdatatypeid=2 then  WRITEINTEGER;
     if Bdatatypeid=1  then  WRITEBYTE;
     writeln(file1,'file format : IDRISI Raster A.1');
     writeln(file1,'file title  : ');
     if Bdatatypeid=2 then strx:='integer';
     if Bdatatypeid=1 then strx:='byte';
     writeln(file1,'data type   : '+strx);
     writeln(file1,'file type   : binary');
     writeln(file1,'columns     : '+inttostr(Bcols));
     writeln(file1,'columns     : '+inttostr(Brows));
     writeln(file1,'ref. system : plane');
     writeln(file1,'ref. units  : m');
     writeln(file1,'unit dist.  : 1');
     writeln(file1,'min. X      : 0');
     writeln(file1,'max. X      : '+inttostr(Bcols));
     writeln(file1,'min. Y      : 0');
     writeln(file1,'max. Y      : '+inttostr(Brows));
     writeln(file1,'pos n error : unknown');
     writeln(file1,'resolution  : '+format('%.1f',[Bspacing]));
     writeln(file1,'min. value  : '+inttostr(Bmin));
     writeln(file1,'max. value  : '+inttostr(Bmax));
     writeln(file1,'display min : '+inttostr(Bmin));
     writeln(file1,'display max : '+inttostr(Bmax));
     writeln(file1,'value units : unspecified');
     writeln(file1,'value error : unknown');
     writeln(file1,'flag value  : ');
     writeln(file1,'flag def n  : none');
     writeln(file1,'legend cats : 0');
     closefile(file2);closefile(file1);
  end;
//#####################################################
procedure SAVE2TIF (var AAA:char);
  var  bbb:  array  [1..256] of byte; file2:file;j,i,k:integer;
     Procedure TIFF_TAGs( k,TName,TType,TLength,TValue:integer);
     begin
        bbb[k]  :=lo(Tname);bbb[k+1]:=hi(Tname);bbb[k+2]:=Ttype;bbb[k+3]:=0;
        bbb[k+4]:=Tlength;bbb[k+5]:=0;bbb[k+6]:=0;bbb[k+7]:=0;bbb[k+11]:=0;
        if Tvalue <(256*256)+256 then begin
           bbb[k+8]:=lo(Tvalue); bbb[k+9]:=hi(TValue);bbb[k+10]:=0; end
        else
           bbb[k+10]:=Trunc(Tvalue/(256*256));
           bbb[k+8]:= lo( Tvalue - (bbb[k+10]*(256*256)) );
           bbb[k+9]:= hi( Tvalue - (bbb[k+10]*(256*256)) );
     end;
  begin
            if AAA='B' then assignfile (file2,Outputfilename+'.tif');
            if AAA='A' then assignfile (file2, Basicfilename+'.tif');
            rewrite(file2);
            bbb[ 1 ]:=73 ; bbb[ 2 ]:=73 ;            //   (II);
            bbb[ 3 ]:=42; bbb[ 4 ]:=0;               //   version 42
            bbb[5]:=8; bbb[6]:= 0; bbb[7]:=0; bbb[8]:=0; //   header offset
            bbb[ 9 ]:=15;   bbb[10 ]:=0;             //15 directories entry
            TIFF_TAGs( 11,  254, 4,1,0);         //1  Newsubfiletype
            TIFF_TAGs( 23,  256, 4,1,Bcols);      //2  ImageWidth (columns)
            TIFF_TAGs( 35,  257, 4,1,Brows);      //3  ImageLength (rows)
            if AAA='A' then begin
              TIFF_TAGs( 23,  256, 4,1,Acols);      //2  ImageWidth (columns)
              TIFF_TAGs( 35,  257, 4,1,Arows);      //3  ImageLength (rows)
            end;
            TIFF_TAGs( 47,  258, 3,1,8);         //4  Bits per sample
            TIFF_TAGs( 59,  259, 3,1,1);         //5  Compression (1 for no)
            TIFF_TAGs( 71,  262, 3,1,1);         //6  Phot0interpretation
            TIFF_TAGs( 83,  273, 4,1,194);       //7  Stripsoffset:where the image starts and header ends, this header ends at  194
            TIFF_TAGs( 95,  277, 3,1,1);         //8  Samplesperpixel 1 for grayscale 3 for true color
            TIFF_TAGs(107,  278, 4,1,Brows);      //9  Rowsperstrip = rows number
            TIFF_TAGs(119,  279, 4,1,Brows*Bcols); //10 Stripsbytecount=row*cols
            if AAA='A' then begin
              TIFF_TAGs(107,  278, 4,1,Arows);      //9  Rowsperstrip = rows number
              TIFF_TAGs(119,  279, 4,1,Arows*Acols); //10 Stripsbytecount=row*cols
            end;
            TIFF_TAGs(131,  282, 5,1,208);       //11 Xresolution
            TIFF_TAGs(143,  283, 5,1,216);       //12 Yresolution
            TIFF_TAGs(155,  284, 3,1,1);         //13 Planar Configuration (1=pixels are stored continuosly)
            TIFF_TAGs(167,  296, 3,1,2);         //14 Resolution  ??????
            TIFF_TAGs(179,  305, 2,6,249);       //15 Software
            bbb[191]:=0;bbb[192]:=0;bbb[193]:=0;bbb[194]:=0;
            k:=194;
            if AAA='B' then begin
             if (Bdatatypeid=1) or (Bdatatypeid=2) then begin
               for i:=1 to Brows do begin for j:=1 to Bcols do begin
                 k:=k+1; bbb[k]:=trunc(255*(b[i,j]-Bmin)/(Bmax-Bmin));
                 if k=256 then begin blockwrite(file2,bbb,2);k:=0;
             end;end;end;end;
            end;
            if AAA='A' then begin
             if (Adatatypeid=1) or (Adatatypeid=2) then begin
               for i:=1 to Arows do begin for j:=1 to Acols do begin
                 k:=k+1; bbb[k]:=trunc(255*(A[i,j]-Amin)/(Amax-Amin));
                 if k=256 then begin blockwrite(file2,bbb,2);k:=0;
             end;end;end;end;
            end;
            blockwrite(file2,bbb,2);closefile(file2);
  end;
//##########################################
Procedure first_last_Row_Column;
var i:integer;
begin
    for i:=1 to Bcols do  begin
       b[1,i]    :=B[2,i];       {first row}
       b[Brows,i]:=b[Brows-1,i]; {last row }
     end;
    for i:=2 to Brows do begin
       b[i,1]    :=B[i,2];       {first column}
       b[i,Bcols]:=B[i,Bcols-1]; {last column }
    end;
end;
//####################################################
procedure ASPECT_UPSLOPE (strx:string) ;
  Var i,j:integer; dx,dy,f,grad:real;
  Procedure AspectUp;
  begin
    If (grad>=flat) then begin
        if ((dx=0) and (dy>0)) then f:= 90
          else  if ((dx=0) and (dy<0)) then f:=-90
          else if (dy=0) and (dx<0) then f:=180
          else if (dy=0) and (dx>0) then f:=0
            else begin f:=arctan(-dy/dx)*p18;
          If (dx<0) and (dy>0) then f:=-180+f;
          If (dx<0) and (dy<0) then f:= 180+f;
        end;
        if  (-22.5<=f) and (f<22.5)   then  b[i,j]:=1; {East}
        if  ( 22.5<=f) and (f<67.5)   then  b[i,j]:=2; {NE}
        if   (67.5<=f) and (f<122.5)  then  b[i,j]:=3; {North}
        if  (112.5<=f) and (f<157.5)  then  b[i,j]:=4; {NW}
        if  (157.5<=f) and (f<180)    then  b[i,j]:=5; {W}
        if   (-180<=f) and (f<-157.5) then  b[i,j]:=5; {West}
        if (-157.5<=f) and (f<-112.5) then  b[i,j]:=6; {SW}
        if (-112.5<=f) and (f<-67.5)  then  b[i,j]:=7; {South}
        if  (-67.5<=f) and (f<-22.5)  then  b[i,j]:=8; {SE}
       end;
     If (grad<flat) then b[i,j]:=0;
  end;
begin
    For i:=1 to Brows do For j:=1 to Bcols do B[i,j]:=0;
    For i:=2 to Brows-1 do begin For j:=2 to Bcols-1 do begin
     dx:= (1/(8*Aspacing))*(a[i-1,j+1]+(2*a[i,j+1])+a[i+1,j+1]-a[i-1,j-1]-(2*a[i,j-1])-a[i+1,j-1]);
     dy:= (1/(8*Aspacing))*(a[i+1,j-1]+(2*a[i+1,j])+a[i+1,j+1]-a[i-1,j-1]-(2*a[i-1,j])-a[i-1,j+1]);
     grad:=round(arctan(sqrt(dx*dx+dy*dy))*p18);
       if (strx='d') or (strx='D') or (strx='u') or (strx='U') then begin
        ASPECTUP;
        if (strx='d') or (strx='D') then begin
          if b[i,j]<>0 then begin if b[i,j]<=4 then b[i,j]:=b[i,j]+4 else b[i,j]:=b[i,j]-4; end;
       end;end;
       if (strx='g') or (strx='G') then b[i,j]:=round(grad);
     if (i=2) and (j=2) then begin Bmin:=0; Bmax:=0; end;
     if b[i,j]>Bmax then Bmax:=b[i,j];if b[i,j]<Bmin then Bmin:=b[i,j];
    end;end;
    first_last_Row_Column;
end;
//#####################################################
procedure CURVATUREs_all (strx:string; var min,max:real) ;
var i,j:integer; KH,KV,KM,Kout:real;
   Procedure Calculations (var Kout:real);
   var z1,z2,z3,z4,z5,z6,z7,z8,z9,p,s,q,r,t :real;
       xx,yy,zz1,zz2:real;
    begin
       KH:=0;
       z1:=a[i-1,j-1]; z2:=a[i-1,j  ];  z3:=a[i-1,j+1];
       z4:=a[i  ,j-1]; z5:=a[i  ,j  ];  z6:=a[i  ,j+1];
       z7:=a[i+1,j-1]; z8:=a[i+1,j  ];  z9:=a[i+1,j+1];
          s:=(z3+z7-z1-z9)/(4*bspacing*bspacing);
          p:=(z3+z6+z9-z1-z4-z7)/(6*bspacing) ;
          q:=(z1+z2+z3-z7-z8-z9)/(6*bspacing) ;
          r:= (z1+z3+z7+z9+(3*(z4+z6))-(2*(z2+(3*z5)+z8)))/(5*bspacing*bspacing);
          t:= (z1+z3+z7+z9+(3*(z2+z8))-(2*(z4+(3*z5)+z6)))/(5*bspacing*bspacing);
          XX:=(p*p)+(q*q); YY:=1+XX;
          ZZ1:=XX*sqrt(YY); ZZ2:=XX*sqrt(YY*YY*YY);
          if (abs(zz2)>ZeroCurvature) then KV:=-((p*p*r)-(2*p*q*s)+(q*q*t))/ZZ2 else KV:=0; // profile
          if (abs(zz1)>ZeroCurvature) then KH:=-((q*q*r)-(2*p*q*s)+(p*p*t))/ZZ1 else KH:=0; // planar
          KM:=0.5*(KV+KH);
        if ((strx[1]='l') or (strx[1]='L')) then Kout:=KH else      //planar
             if ((strx[1]='f') or (strx[1]='F')) then Kout:=KV else //profile
             if ((strx[1]='m') or (strx[1]='M')) then Kout:=Km;     //mean curvature
        If ((i=2) and (j=2)) then begin min:=Kout;max:=Kout; end else begin
             if Kout>max then max:=Kout; if Kout<min then min:=Kout; end;
    end;
begin
   Bdatatypeid:=2;Brows:=Arows;Bcols:=Acols;Bspacing:=Aspacing;
   For i:=1 to Brows do For j:=1 to Bcols do B[i,j]:=0;
   For i:=2 to Brows-1 do For j:=2 to Bcols-1 do Calculations(Kout);
   For i:=2 to Brows-1 do For j:=2 to Bcols-1 do begin
      Calculations(Kout);
      B[i,j]:=trunc(Kout*factor);
      if (i=2) and (j=2) then  begin Bmin:=B[i,j];Bmax:=B[i,j]; end;
        if B[i,j]>Bmax then Bmax:=B[i,j];
        if B[i,j]<Bmin then Bmin:=B[i,j];
   end;
end;
//#####################################################
procedure CONNECTED_COMPONENTs_LABELLING (strx:String;Var count:integer);
var i,j:longint;
   procedure Grow_A_Specific_Object;
   var i,j,i1,j1,size,previous:longint;
   begin
    previous:=0;
    repeat
      size:=previous;
      for i:=2 to Arows-1 do begin for j:=2 to Acols-1 do begin
       if B[i,j]=count then begin
        for i1:=-1 to 1 do begin for j1:=-1 to 1 do begin
         if (AorB[1]='F') or (AorB[1]='f') then begin //foreground
          if A[i+i1,j+j1]<>0 then begin
           B[i+i1,j+j1]:=count; A[i+i1,j+j1]:=0; size:=size+1;
         end;end;
         if (AorB[1]='B') or (AorB[1]='b') then begin //background
          if A[i+i1,j+j1]=0 then begin
           B[i+i1,j+j1]:=count; A[i+i1,j+j1]:=1; size:=size+1;
         end;end;
      end;end;end;end;end;
     until (size=previous);
   end;
begin
 for i:=1 to Arows do for j:=1 to Acols do B[i,j]:=0;
 count:=0;
 for i:=2 to Arows-1 do begin for j:=2 to Acols-1 do begin
  if (AorB[1]='F') or (AorB[1]='f') then begin
   if A[i,j]<>0 then begin
    A[i,j]:=0;count:=count+1;B[i,j]:=count;Grow_A_Specific_Object;
  end;end;
  if (AorB[1]='B') or (AorB[1]='b') then begin
   if A[i,j]=0 then begin
    A[i,j]:=1;count:=count+1;B[i,j]:=count;Grow_A_Specific_Object;
  end;end;
 end;end;
 Brows:=Arows;Bcols:=Acols;Bspacing:=Aspacing;Bmin:=0;Bmax:=count;Bdatatypeid:=2;
end;
//#####################################################
procedure OBJECT_STATISTICS (var str:string; var sizemean,sizemin,sizemax:real; var BB:BBBB);
var i,j,k,previous:integer; file1:textfile;BB2,BB3:BBBB;strx:string[20];
begin
 For i:=1 to Amax do BB[i]:=0;
 for i:=1 to Arows do begin for j:=1 to Acols do begin
  if A[i,j]<>0 then begin k:=A[i,j]; BB[k]:=BB[k]+1; end;
 end;end;
 Sizemin:=BB[1]; Sizemax:=BB[1]; Sizemean:=0;
 str:=Basicfilename+'_Obj_stats.txt';
 For  i:=1 to Amax do begin
   if Sizemax<BB[i] then Sizemax:=BB[i];
   if Sizemin>BB[i] then Sizemin:=BB[i];
   Sizemean:=sizemean+BB[i]; BB3[i]:=BB[i];
 end;
 Bubble_sort (BB3,BB2,Amax);
 assignfile (file1,str);rewrite(file1);
 writeln(file1,'Object size for the file: '+basicfilename+'.rdc');
 writeln(file1,' '); previous:=0;K:=0;
 writeln(file1,' Size   ,  no of objects  ,   size%');
 For  i:=1 to Amax do begin
   if i=1 then begin previous:=bb3[1]; K:=1; end
   else begin if (previous=bb3[i]) then K:=K+1
    else begin
     strx:=format(' %.3f',[ (100*bb3[i-1]*k/(Arows*Acols))]);
     writeln(file1,BB3[i-1]:9,'       ',k:7,'            ',strx);
     K:=1;previous:=bb3[i];
    end;
   end;
 end;
 writeln(file1,' ');
 writeln(file1,'ID   -   Size (sorted in increasing size)');
 For  i:=1 to Amax do begin
    writeln(file1,bb2[i]:5,' ',BB3[i]:7);
 end;
 closefile(file1);
 If Amax>0 then Sizemean:=sizemean/Amax;
end;
//#####################################################
procedure DESPECLE (strx:string; var Pits_removed:integer);
var i,j,k,i1,j1:integer;
begin
 Pits_removed:=0;
 for i:=1 to Arows do for j:=1 to Acols do b[i,j]:=a[i,j];
 for i:=2 to Arows-1 do begin for j:=2 to Acols-1 do begin
  if (AorB[1]='F') or (AorB[1]='f') then begin //FOREGROUND PITS (255)
   if A[i,j]<>0 then begin
     k:=0;
     for i1:=-1 to 1 do begin for j1:=-1 to 1 do begin
       if A[i+i1,j+j1]=0 then k:=k+1;
     end;end;
     if k=8 then begin B[i,j]:=0; Pits_removed:=Pits_removed+1;end;
   end;
  end;
  if (AorB[1]='B') or (AorB[1]='b') then begin //Background pits 0s
   if A[i,j]=0 then begin
     k:=0;
     for i1:=-1 to 1 do begin for j1:=-1 to 1 do begin
        if A[i+i1,j+j1]<>0 then k:=k+1;
     end;end;
     if k=8 then begin B[i,j]:=255; Pits_removed:=Pits_removed+1;end;
   end;
  end;
 end;end;
 Brows:=Arows;Bcols:=Acols;Bspacing:=Aspacing;Bmin:=Amin;Bmax:=Amax;
 Bdatatypeid:=Adatatypeid;
end;
//########################################################
Procedure Border (var length:integer;Chara:char);
var i,j,k,i1,j1:integer;
begin
 length:=0;
 for i:=1 to Arows do for j:=1 to Acols do B[i,j]:=A[i,j];
 for i:=2 to Arows-1 do begin for j:=2 to Acols-1 do begin
   k:=0;
   for i1:=-1 to 1 do begin for j1:=-1 to 1 do begin
     if A[i+i1,j+j1]<>0 then k:=k+1;
   end;end;
   If k=9 then begin B[i,j]:=0;length:=length+1;end;
 end;end;
 Brows:=Arows;Bcols:=Acols;Bspacing:=Aspacing;Bmin:=Amin;
 Bmax:=Amax; Bdatatypeid:=Adatatypeid;
 for i:=1 to Arows do for j:=1 to Acols do If ( chara='s') or (chara='S') then if B[i,j]<>0 then B[i,j]:=255;
 If ( chara='s') or (chara='S') then begin Bmax:=255; Bdatatypeid:=1; end;
end;
//####################################################
Procedure SIZE_FILTERING (var K,LL,LLLL:integer);
var smean,smin,smax: real; str: string; BB:BBBB; i,j:integer;
begin
   OBJECT_STATISTICS (str,smean,smin,smax,BB); ll:=0;LLLL:=0;
   for i:=1 to Arows do begin for j:=1 to Acols do begin
     if A[i,j]<>0 then begin LLLL:=LLLL+1; if BB[A[i,j]]<k then begin
       B[i,j]:=0; ll:=ll+1; end else B[i,j]:=255;
   end;end;end;
   Brows:=Arows;Bcols:=Acols;
   Bspacing:=Aspacing;Bmin:=Amin;Bmax:=255;
   Bdatatypeid:=1;
end;
//#####################################################3
Procedure  LABELPIXELS(k:integer;Ch:char;var Points:integer);
var i,j:integer;
begin
 Points:=0;
 for i:=1 to Arows do begin for j:=1 to Acols do begin
 B[i,j]:=0;
   if (ch='G') or (ch='g') then if A[i,j]>k then B[i,j]:=255;
   if (ch='L') or (ch='l') then if A[i,j]<k then B[i,j]:=255;
   if (ch='E') or (ch='e') then if A[i,j]=k then B[i,j]:=255;
   if B[i,j]=255 then points:=points+1;
 end;end;
 Brows:=Arows;Bcols:=Acols; Bspacing:=Aspacing;
 Bmin:=0;Bmax:=255; Bdatatypeid:=Adatatypeid;
end;
//#####################################################
Procedure INVERTLUT;
var i,j:integer;
begin
 for i:=1 to Arows do for j:=1 to Acols do B[i,j]:=255-A[i,j];
 Brows:=Arows;Bcols:=Acols; Bspacing:=Aspacing;
 Bmin:=0;Bmax:=255; Bdatatypeid:=Adatatypeid;
end;
//#####################################################
Procedure Bubble_sort (var Ia,Io:BBBB; Ksize:integer);
var i,k,z1,z2:integer; // io intetifier
  begin                //Ia on this sorting is applies
   for I:=1 to Ksize do Io[i]:=i;
   for I:=1 to Ksize-1 do begin
    if Ia[i]>Ia[i+1] then begin
      K:=i;
      repeat
        z1:=Ia[k];Ia[k]:=Ia[k+1];Ia[k+1]:=z1;
        z2:=Io[k];Io[k]:=Io[k+1];Io[k+1]:=z2;
        k:=k-1;
      until (K<1) or (Ia[k]<Ia[k+1]);
  end;end;end;
//#####################################################
Procedure IterativeRUNOFF (rows,cols:integer; var iteration:integer);
var i,j,toppoints:integer; initial:elevationarray;
    Procedure DRAINAGE_Inputs_at_Pixel_level;
    var kk,i,j:integer;
    begin
     for i:=1 to rows do begin for j:=1 to cols do begin initial[i,j]:=-1;b[i,j]:=0;end;end;
     for i:=2 to rows-1 do begin for j:=2 to cols-1 do begin
      if a[i,j]<>0 then begin kk:=0;
        if a[i  ,j-1]=1 then kk:=kk+1; if a[i+1,j-1]=2 then kk:=kk+1;
        if a[i+1,j  ]=3 then kk:=kk+1; if a[i+1,j+1]=4 then kk:=kk+1;
        if a[i  ,j+1]=5 then kk:=kk+1; if a[i-1,j+1]=6 then kk:=kk+1;
        if a[i-1,  j]=7 then kk:=kk+1; if a[i-1,j-1]=8 then kk:=kk+1;
        initial[i,j]:=kk
      end else initial[i,j]:=-1;
    end;end;end;
    Procedure TOP_Points_Counter;
    var i,j:integer;
    begin
     toppoints:=0;
     for i:=2 to rows-1 do for j:=2 to cols-1 do if initial[i,j]=0 then toppoints:=toppoints+1;
    end;
    Procedure SingleIteration;
    var i,j,ii,jj,pointing:integer;
    begin
     For j:=2 to cols-1 do begin
      for i:=2 to rows-1 do begin
       if initial[i,j]=0 then begin
        if a[i,j]<>0  then begin
         pointing:=a[i,j]; ii:=i; jj:=j;
          if pointing=1 then jj:=jj+1; if pointing=3 then ii:=ii-1;
          if pointing=2 then begin ii:=ii-1;jj:=jj+1; end;
          if pointing=4 then begin ii:=ii-1;jj:=jj-1; end;
          if pointing=5 then jj:=jj-1; if pointing=7 then ii:=ii+1;
          if pointing=6 then begin ii:=ii+1;jj:=jj-1; end;
          if pointing=8 then begin ii:=ii+1;jj:=jj+1; end;
          initial[i,j]:=initial[i,j]-1;initial[ii,jj]:=initial[ii,jj]-1;
          b[ii,jj]:=b[ii,jj]+b[i,j]+1;
    end;end;end;end;end;
begin
    DRAINAGE_Inputs_at_Pixel_level; TOP_Points_Counter; iteration:=0;
    repeat
       iteration:=iteration+1; SingleIteration; TOP_Points_Counter;
    until toppoints=0 ;
    Bdatatypeid:=2;Brows:=rows;Bcols:=cols;Bmin:=b[4,4]; Bmax:=b[4,4];
    for i:=2 to rows-1 do begin for j:=2 to cols-1 do begin
       if Bmin>b[i,j] then Bmin:=b[i,j];
       if Bmax<b[i,j] then Bmax:=b[i,j];
    end;end;
end;
//#######################################################
Procedure ReplaceMAtrix;
var i,j:integer;
begin
  for i:=1 to Arows do for j:=1 to Acols do B[i,j]:=A[i,j];
  Brows:=Arows;Bcols:=Acols;Bspacing:=Aspacing;Bmin:=Amin;
  Bmax:=Amax;Bdatatypeid:=Adatatypeid;
end;
//#######################################################
Procedure INTERSECT (new:string;new1:String;new2:String);
var i,j,k:integer; BB,BB2:BBBBreal; SZ,BBmin,BBmax:BBBB; file1:textfile;
begin
 For i:=1 to Bmax do begin
  BB[i]:=0;BBmax[i]:=0;BB2[i]:=0;BBmin[i]:=0;SZ[i]:=0;
 end;
 For i:=1 to Arows do begin for j:=1 to Acols do begin
    if B[i,j]<>0 then begin
      k:=B[i,j]; SZ[k]:=SZ[k]+1; BB[k]:=BB[k]+A[i,j];
      if SZ[k]=1 then begin
        BBmin[k]:=A[i,j];BBmax[k]:=A[i,j];
      end;
      if SZ[k]>1 then  begin
        if BBmin[k]>A[i,j] then BBmin[k]:=A[i,j];
        if BBmax[k]<A[i,j] then BBmax[k]:=A[i,j];
      end;
    end;
  end;end;
  For i:=1 to Bmax do if SZ[i]<>0 then BB[i]:=BB[i]/SZ[i];
  For i:=1 to Arows do begin for j:=1 to Acols do begin
    if B[i,j]<>0 then begin
      k:=B[i,j]; BB2[k]:=BB2[k]+sqr(BB[k]-A[i,j]);
   end;end;end;
  For i:=1 to Bmax do if SZ[i]<>0 then BB2[i]:=sqrt(BB2[i]/SZ[i]);
  assignfile (file1,new2);rewrite(file1);
  writeln(file1,'Object size/property');
  writeln(file1,'  CCL file : '+new+'.rdc');
  writeln(file1,'  Property file : '+new1+'.rdc');
  writeln(file1,' ');
  writeln(file1,'ID       Size       Mean        Min    Max        Stdev');
  For  i:=1 to Bmax do if SZ[i]<>0 then
  writeln(file1,i:7,' ',SZ[i]:12 ,' ' ,format(' %15.6f',[BB[i]]),' ',
  BBmin[i]:7,' ',BBmax[i]:9,' ',format(' %15.6f',[BB2[i]]));
  closefile(file1);
end;
//#######################################################
Procedure Linethinning (var count1,count2,iter:integer);
 var i,j,k,l,times,rep,cc:integer;
     borderpoint,n8,n4:integer;
     p1,p2,p3,p4,p5,p6,p7,p8,i1,i2,i3,i4,i5,i6,i7,i8,north:integer;
     c1,c2,c3,c4,c5,c6,c7,c8,kkk:integer;
 Procedure Operator(i,j,c1,c2,c3,c4,c5,c6,c7,c8:integer;  Var out:integer);
 var p1,p2,p3,p4,p5,p6,p7,p8 :integer;
 begin
      If a[ i ,j+1]<>0 then p1:=1 else p1:=0;If a[i-1,j+1]<>0 then p2:=1 else p2:=0;
      If a[i-1,  j]<>0 then p3:=1 else p3:=0;If a[i-1,j-1]<>0 then p4:=1 else p4:=0;
      If a[i  ,j-1]<>0 then p5:=1 else p5:=0;If a[i+1,j-1]<>0 then p6:=1 else p6:=0;
      If a[i+1,  j]<>0 then p7:=1 else p7:=0;If a[i+1,j+1]<>0 then p8:=1 else p8:=0;
      out:=(c1*p1)+(c2*p2)+(c3*p3)+(c4*p4)+(c5*p5)+(c6*p6)+(c7*p7)+(c8*p8);
 end;
 Procedure Pixel_labels(i,j:integer; var p1,p2,p3,p4,p5,p6,p7,p8:integer;
      var i1,i2,i3,i4,i5,i6,i7,i8:integer; var kkk:integer);
 var ik,jk:integer;
 begin
    ik:=i; jk:=j;
    if a[ ik ,jk+1]<>0 then p1:=1 else p1:=0;if a[ik-1,jk+1]<>0 then p2:=1 else p2:=0;
    if a[ik-1,  jk]<>0 then p3:=1 else p3:=0;if a[ik-1,jk-1]<>0 then p4:=1 else p4:=0;
    if a[ik  ,jk-1]<>0 then p5:=1 else p5:=0;if a[ik+1,jk-1]<>0 then p6:=1 else p6:=0;
    if a[ik+1,  jk]<>0 then p7:=1 else p7:=0;if a[ik+1,jk+1]<>0 then p8:=1 else p8:=0;
    if a[ ik ,jk+1]=0 then i1:=1 else i1:=0;if a[ik-1,jk+1]=0  then i2:=1 else i2:=0;
    if a[ik-1,  jk]=0 then i3:=1 else i3:=0;if a[ik-1,jk-1]=0  then i4:=1 else i4:=0;
    if a[ik  ,jk-1]=0 then i5:=1 else i5:=0;if a[ik+1,jk-1]=0  then i6:=1 else i6:=0;
    if a[ik+1,  jk]=0 then i7:=1 else i7:=0;if a[ik+1,jk+1]=0  then i8:=1 else i8:=0;
    KKK:=(i5*p4*i3)+(i3*p2*i1)+(i1*p8*i7)+(i7*p6*i5);
 end;
Procedure NORTHERN_POINT; begin
 if a[i+1,j]=0 then begin North:= (p5*i7*p1)+kkk;
  if (north=0) then begin a[i,j]:=0;b[i,j]:=0;cc:=cc+1;
end;end;end;
Procedure Southern_POINT; begin
 if a[i-1,j]=0 then begin North:= (p5*i3*p1)+kkk;
  if (north=0) then begin a[i,j]:=0;b[i,j]:=0;cc:=cc+1;
end;end;end;
Procedure East_POINT; begin
 if a[i,j+1]=0 then begin North:= (p3*i5*p7)+kkk;
  if (north=0) then begin a[i,j]:=0;b[i,j]:=0;cc:=cc+1;
end;end;End;
Procedure West_POINT; begin
 if a[i,j-1]=0 then begin North:= (p3*i1*p7)+kkk;
  if (north=0) then begin a[i,j]:=0;b[i,j]:=0;cc:=cc+1;
end; end; End;
begin
 iter:=0; for i:=1 to Arows do for j:=1 to Acols do b[i,j]:=0;
repeat
 cc:=0; iter:=iter+1;
 for rep:=1 to 4 do begin
  for i:=2 to Arows-1 do begin for j:=2 to Acols-1 do begin
   b[i,j]:=a[i,j];
    if a[i,j]<>0 then begin
     operator(i,j,1,1,1,1,1,1,1,1,N8);
     operator(i,j,1,0,1,0,1,0,1,0,N4);
     Pixel_labels(i,j,p1,p2,p3,p4,p5,p6,p7,p8,i1,i2,i3,i4,i5,i6,i7,i8,kkk);
      if (N4<>4) and (N4<>0) then begin if (N8<>0)and (N8<>1) then begin
       if N8<>1 then begin
         if rep=1 then NORTHERN_POINT;
         if rep=2 then Southern_Point;
         if rep=3 then East_Point;
         if rep=4 then West_Point;
 end;end;end;end;end;end;end;
until (CC=0);
  Brows:=Arows;Bcols:=Acols;Bspacing:=Aspacing;Bmin:=Amin;
  Bmax:=Amax;Bdatatypeid:=Adatatypeid;
  count1:=0;count2:=0;
  for i:=1 to Arows do begin for j:=1 to Acols do begin
    if A[i,j]<>0 then count1:=count1+1;
    if B[i,j]<>0 then count2:=count2+1;
  end;end;
end;
//#######################################################
Procedure SEGMATRIX (var k:integer);
var i,j:integer;
begin
  for i:=1 to Arows do for j:=1 to Acols do if A[i,j]<>0 then B[i,j]:=k;
  Bmax:=255; Bmin:=0; Bdatatypeid:=1;
end;
//#######################################################
Procedure RECGROW (k1,k2:integer; var Total,CountIterations:integer);
var i,j,LL:integer;
   Procedure Operator(i,j:integer);
   begin
      If (a[ i ,j+1]>k1) and (a[ i ,j+1]<k2) and (B[ i ,j+1]<>255) then begin b[ i ,j+1]:=255; LL:=LL+1; end;
      If (a[i-1,j+1]>k1) and (a[i-1,j+1]<k2) and (B[i-1,j+1]<>255) then begin b[i-1,j+1]:=255; LL:=LL+1; end;
      If (a[i-1,  j]>k1) and (a[i-1,  j]<k2) and (B[i-1,  j]<>255) then begin B[i-1,  j]:=255; LL:=LL+1; end;
      If (a[i-1,j-1]>k1) and (a[i-1,j-1]<k2) and (B[i-1,j-1]<>255) then begin B[i-1,j-1]:=255; LL:=LL+1; end;
      If (a[i  ,j-1]>k1) and (a[i  ,j-1]<k2) and (B[i  ,j-1]<>255) then begin B[i  ,j-1]:=255; LL:=LL+1; end;
      If (a[i+1,j-1]>k1) and (a[i+1,j-1]<k2) and (B[i+1,j-1]<>255) then begin B[i+1,j-1]:=255; LL:=LL+1; end;
      If (a[i+1,  j]>k1) and (a[i+1,  j]<k2) and (B[i+1,  j]<>255) then begin B[i+1,  j]:=255; LL:=LL+1; end;
      If (a[i+1,j+1]>k1) and (a[i+1,j+1]<k2) and (B[i+1,j+1]<>255) then begin B[i+1,j+1]:=255; LL:=LL+1; end;
   end;
begin
   for i:=1 to Arows do for j:=1 to Acols do if A[i,j]=255 then B[i,j]:=255 else B[i,j]:=0;
   Total:=0; for i:=1 to Arows do for j:=1 to Acols do if B[i,j]=255 then Total:=Total+1;
   CountIterations:=0;
   repeat
    LL:=0; CountIterations:=CountIterations+1;
    for i:=1 to Arows do for j:=1 to Acols do if B[i,j]=255 then Operator(i,j);
    Total:=Total+LL;
   until LL=0;
  Brows:=Arows;Bcols:=Acols;Bspacing:=Aspacing;Bmin:=0;
  Bmax:=255;Bdatatypeid:=1;
end;
//#######################################################
Procedure MOMENTS ( var p,q:integer; var BB:BBBBreal);
var i,j,k,l:integer; sp,sq:real;
begin
  For i:=1 to Amax do BB[i]:=0;
  For i:=1 to Arows do begin For j:=1 to Acols do begin
   if A[i,j]<>0 then begin
     k:=A[i,j];
     if p=0 then sp:=1 else begin sp:=1;for L:=1 to p do sp:=sp*i;end;
     if q=0 then sq:=1 else begin sq:=1;for L:=1 to p do sq:=sq*j;end;
     BB[k]:=BB[k]+(sp*sq);
   end;
  end;end;
end;
//#####################################################
procedure DESPECLE16 (strx:string; SIZEOFKERNEL:integer; var Pits_removed:integer);
var i,j,i1,j1,KLL,Threshold :integer;
begin
 Pits_removed:=0;
 Threshold:=((SIZEOFKERNEL*2)+1)*4;
 for i:=1 to Arows do for j:=1 to Acols do b[i,j]:=a[i,j];
 for i:=3 to Arows-3 do begin for j:=3 to Acols-3 do begin
  if (AorB[1]='F') or (AorB[1]='f') then begin //FOREGROUND PITS (255)
     KLL:=0;
     for i1:=-SIZEOFKERNEL to SIZEOFKERNEL do begin
          if A[i-3,j+i1]=0 then KLL:=KLL+1;   //first row
          if A[i+3,j+i1]=0 then KLL:=KLL+1;   //last row
          if A[i+i1,j-3]=0 then KLL:=KLL+1;   //first col
          if A[i+i1,j+3]=0 then KLL:=KLL+1;   //last row
     end;
     if KLL=Threshold then begin
       for i1:=(-SIZEOFKERNEL+1) to (SIZEOFKERNEL-1) do begin
       for j1:=(-SIZEOFKERNEL+1) to (SIZEOFKERNEL-1) do begin
         if A[i+i1,j+j1]<>0 then begin
           B[i+i1,j+j1]:=0;
           Pits_removed:=Pits_removed+1;
         end;
       end;end;
     end;
  end;
 end;end;
 Brows:=Arows;Bcols:=Acols;Bspacing:=Aspacing;Bmin:=Amin;Bmax:=Amax;
 Bdatatypeid:=Adatatypeid;
end;
//@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
end.

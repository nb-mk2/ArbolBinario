unit Arbolpunteros;

{$mode objfpc}{$H+}

interface

uses
  Tipos, Classes, LResources, Forms, Controls, Graphics, Dialogs,
  MaskEdit, StdCtrls, ExtCtrls;

const
  Min=1;
  Max=100;
  Nulo=Nil;

Type
  posicionarbol = ^nodo_arbol;
  nodo_arbol = Record
    datos: tipoelemento;
    hi,hd: posicionarbol;
    fe: -1..1;
  end;

  arbol = object
        raiz: posicionarbol;
        qitem:longint;
  procedure crearvacio;
  function Esvacio():Boolean;
  function Eslleno():Boolean;
  function ramanula(p:posicionarbol):Boolean;
  procedure preorden(a: posicionarbol; var mm:TMemo);
  procedure inorden(a: posicionarbol; var mm:Tmemo);
  procedure postorden(a: posicionarbol; var mm:Tmemo);
  procedure cargar;
  function recuperar(a:posicionarbol; var x:tipoelemento):errores;
  function busqueda(a:posicionarbol; x:tipoelemento; Comparar:Campo_Comparar): posicionarbol;
  function hijoizq(p:posicionarbol):posicionarbol;
  function hijoder(p:posicionarbol):posicionarbol;
  function padre(a:posicionarbol;p:posicionarbol):posicionarbol;
  function altura(p:posicionarbol):integer;
  function nivel(p:posicionarbol):integer;
  end;

implementation

procedure arbol.crearvacio;
begin
  raiz:= Nulo;
  qitem:=0;
end;

function arbol.esvacio():boolean;
begin
  esvacio:= (raiz=nulo);
end;

function arbol.eslleno():boolean;
begin
  eslleno:= (qitem=max);
end;

function arbol.ramanula(p:posicionarbol):boolean;
begin
  ramanula:=(p=nulo);
end;

function arbol.hijoizq (p:posicionarbol):posicionarbol;
begin
  if not ramanula(p) then
  hijoizq:=p^.hi;
end;

function arbol.hijoder (p:posicionarbol):posicionarbol;
begin
  if not ramanula(p) then
  hijoder:=p^.hd;
end;

function arbol.recuperar (a:posicionarbol; var x:tipoelemento):errores;
begin
  if ramanula (a) then
     recuperar:=posicioninvalida
  else
     begin
       x.asignarvalores(a^.datos);
       recuperar:=ok;
     end;
end;

procedure arbol.preorden (a:posicionarbol; var mm:Tmemo);
var
   x:tipoelemento;
   s,s1,s2:string;
begin
  if ramanula (A) then
     mm.lines.add('.')
  else
     begin
       recuperar(a,x);
       str(x.dn,S1);
       str(x.dr:4:2,S2);
       s:= x.ds + '-' + s1 + '-' +s2 ;
       mm.lines.add(s);

       preorden(a^.hi, mm);
       preorden(a^.hd, mm);
     end;
end;

procedure arbol.inorden (a:posicionarbol; var mm:tmemo);
var
   x:tipoelemento;
   s,s1,s2:string;
begin
  if ramanula (A) then
     mm.lines.add('.')
  else
     begin
       inorden(a^.hi, mm);
       recuperar(a,x);
       str(x.dn,S1);
       str(x.dr:4:2,S2);
       s:= x.ds + '-' + s1 + '-' +s2 ;
       mm.lines.add(s);
       inorden(a^.hd, mm);
     end;
end;

procedure arbol.postorden (a:posicionarbol; var mm:tmemo);
var
   x:tipoelemento;
   s,s1,s2:string;
begin
  if ramanula (A) then
     mm.lines.add('.')
  else
     begin
       postorden(a^.hi, mm);
       postorden(a^.hd, mm);
       recuperar(a,x);
       str(x.dn,S1);
       str(x.dr:4:2,S2);
       s:= x.ds + '-' + s1 + '-' +s2 ;
       mm.lines.add(s);
     end;
end;

procedure arbol.cargar;
var
   x:tipoelemento;

procedure carga(var a:posicionarbol);
  begin
    x.ds:= inputbox('Nombre', 'Ingrese', '.');
    if x.ds='.' then
       a:=nulo
    else
       begin
         val(inputbox('Peso', 'Ingrese', ' '),x.dn);
         val(inputbox('Cantidad Leche', 'Ingrese', ' '),x.dr);
         new (a);
         a^.datos.asignarvalores(x);
         inc(qitem);
         carga(a^.hi);
         carga(a^.hd);
       end;
  end;
begin
  carga(raiz);
end;

function arbol.busqueda(a:posicionarbol; x:tipoelemento; comparar:Campo_comparar):posicionarbol;
var
   p:posicionarbol;
procedure encontrar(a: posicionarbol);
begin
  if not ramanula(a) then
     if x.compararTE(a^.datos, comparar) = igual then
        p:=a
     else
        begin
          encontrar(a^.hi);
          encontrar(a^.hd);
        end;
end;
begin
  p:=nulo;
  encontrar(A);
  busqueda:=p;
end;

function arbol.padre(a:posicionarbol;p:posicionarbol):posicionarbol;
var
   pad:posicionarbol;
   procedure encontrarpadre(a:posicionarbol);
   begin
     if not ramanula(a) then
        begin
             if a^.hi = p then
                pad:=a;
             if not ramanula(a^.hd) then
                if a^.hd= p then
                   pad:=a;
             encontrarpadre(a^.hi);
             encontrarpadre(a^.hd);
        end;
   end;
begin
  pad:=nulo;
  if a=p then
     pad:=nulo
  else
      encontrarpadre(a);
  padre:=pad;
end;

function arbol.nivel(p:posicionarbol):integer;
var
   n:integer;
   enc:boolean;
   procedure encontrarNivel(a:posicionarbol; n:integer; var enc:boolean);
   begin
     if not ramanula(a) and not enc then
        begin
             inc(n);
             if (a^.hi <> p) and (a^.hd <> p) then
                 begin
                      encontrarNivel(a^.hi, n, enc);
                      encontrarNivel(a^.hd, n, enc);
                 end
             else
             begin
             enc:=true;
             nivel:=n;
             end;
        end;
   end;
begin
  enc:=false;
  n:=0;
  nivel:=0;
  if p<>nulo then
      encontrarNivel(raiz, n, enc);
end;

function arbol.altura(p:posicionarbol):integer;
var
   n:integer;
   procedure encontrarAltura(a:posicionarbol; n:integer);
   begin
     if not ramanula(a) then
        begin
             inc(n);
             encontrarAltura(a^.hi, n);
             encontrarAltura(a^.hd, n);
        end
     else
	if n > altura then
	   altura:=n-1;
   end;
begin
  n:=0;
  altura:=0;
  if p<>nulo then
      encontrarAltura(p, n);
end;
end.



// NutWin - Programa de Apoio a Nutrição(R)
// Copyright (C) 2002-2010 Departamento de Informática em Saúde
// Universidade Federal de São Paulo - UNIFESP <www.unifesp.br>
//
// This file is part of NutWin.
//
// NutWin is free software:  you  can  redistribute  it  and/or
// modify it under the terms of the GNU General Public  License
// as published by the Free Software Foundation, either version
// 3 of the License, or (at your option) any later version.
//
// Nutwin is distributed in the hope that it  will  be  useful,
// but WITHOUT ANY WARRANTY; without even the implied  warranty
// of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
// the GNU General Public License for more details.
//
// You should have received a copy of the  GNU  General  Public
// License along with Foobar.
// If not, see <http://www.gnu.org/licenses/>.




unit InsFrm;

{ ****************************************************************** }
{                                                                    }
{   Delphi component TInsideForm                                     }
{                                                                    }
{   Form que fica dentro de um painel                                }
{                                                                    }
{   Generated on 17 Setembro 1997 at 9:08                            }
{                                                                    }
{   Copyright © 1997 by CIS-EPM                                      }
{                                                                    }
{ ****************************************************************** }

interface

uses
  Controls,Classes,StdCtrls, Forms, Dialogs, extctrls;

type
  TInFormBuilder = class(TComponent)
  private
    { Private declarations }
        { Storage for property New External Frame Button }
        FBtNewExternFrm : TButton;
        { Storage for property New Inside Frame Button }
        FBtNewInsideFrm : TButton;
        { Pointer to application's OnNovaPessoa handler, if any }
        FOnNovoForm : TNotifyEvent;
        { Storage for property Container TWinControl }
        FContainer : TWinControl;
        { Storage for property Modal Boolean }
        FModal : Boolean;
        {Only one instance admited}
        FNovoForm:TForm;
        InFormType : TFormClass;

        FTopMargin : Integer;
        FLeftMargin : Integer;
        FBottonMargin : Integer;
        FRightMargin : Integer;
        FAutoSize: Boolean;
        FOldResizeContainer : TNotifyEvent;

      { Private methods of TInFormBuilder }
        procedure NewInside (Sender: TObject);
        procedure NewOutside (Sender: TObject);
        { Write method for property New External Frame Button }
        procedure SetBtNewExternFrm(Value : TButton);
        { Write method for property New Inside Frame Button }
        procedure SetBtNewInsideFrm(Value : TButton);
        procedure SetContainer (Value : TWinControl);
        function Resize : Boolean;
        procedure SetAutoSize(const Value: Boolean);
        procedure OnContainerResize( Sender : TObject );

    protected
      { Protected methods of TInFormBuilder }
        { Method to generate OnNovoForm event }
        procedure NovoForm;
        { Resets prop of component type if referenced component deleted }
        procedure Notification(AComponent : TComponent; Operation : TOperation); override;
        { Method to generate OnNovaPessoa event }
        procedure Loaded; override;

    public
      { Public fields and properties of TInFormBuilder }
        property FormBuilded : TForm read FNovoForm;
        property FormBuildedClass : TFormClass read InFormType;
      { Public methods of TInFormBuilder }
        constructor Create(AOwner: TComponent); override;
        procedure CriaFormExterno (TipoForm: TFormClass);
        procedure CriaFormInterno (TipoForm: TFormClass);
        procedure CloseInForm;
        procedure ShowInForm;
        procedure HideInForm;
        procedure SetTipoForm (TipoForm: TFormClass);
        procedure OnDestroyFormInterno (Sender:TObject);

    published
      { Published properties of the component }
        { E criada uma pessoa }
        property OnNovoForm : TNotifyEvent read FOnNovoForm write FOnNovoForm;
        property BtCriaExterno : TButton read FBtNewExternFrm write SetBtNewExternFrm;
        property BtCriaInterno : TButton read FBtNewInsideFrm write SetBtNewInsideFrm;
        property Container : TWinControl read FContainer write SetContainer;
        property Modal : Boolean read FModal write FModal;
        property TopMargin : Integer read FTopMargin write FTopMargin;
        property LeftMargin : Integer read FLeftMargin write FLeftMargin;
        property BottonMargin : Integer read FBottonMargin write FBottonMargin;
        property RightMargin : Integer read FRightMargin write FRightMargin;
        property AutoSize : Boolean read FAutoSize write SetAutoSize;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Miscelanea', [TInFormBuilder]);
end;

constructor TInFormBuilder.Create(AOwner: TComponent);
begin
     { Call the Create method of the parent class }
     inherited Create(AOwner);

     FTopMargin := 0;
     FLeftMargin := 0;
     FBottonMargin := 0;
     FRightMargin := 0;
end;

{ Resets prop of component type if referenced component deleted }
procedure TInFormBuilder.Notification(AComponent : TComponent; Operation : TOperation);
begin
     inherited Notification(AComponent, Operation);
     if Operation <> opRemove then
        Exit;
     { Has a component referenced by a property of
       this component been deleted?  If so, update
       the property. }
     if AComponent = FContainer then
        FContainer := nil;
     if AComponent = FBtNewExternFrm then
        FBtNewExternFrm := nil;
     if AComponent = FBtNewInsideFrm then
        FBtNewInsideFrm := nil;
     if Assigned (FNovoForm) and (AComponent = FNovoForm) then
        FNovoForm := nil;
end;


{ Write method for property BtCriaInterno }
procedure TInFormBuilder.SetBtNewInsideFrm(Value : TButton);
begin
     { Use Assign method because TButton is an object type }
     FBtNewInsideFrm:=Value;
     Value.OnClick:=NewInside;
     if Value <> nil then Value.FreeNotification(Self);
end;

{ Write method for property BtCriaExterno }
procedure TInFormBuilder.SetBtNewExternFrm(Value : TButton);
begin
     { Use Assign method because TButton is an object type }
     FBtNewExternFrm:=Value;
     Value.OnClick:=NewOutside;
     if Value <> nil then Value.FreeNotification(Self);
end;

{ Write method for property BtCriaExterno }
procedure TInFormBuilder.SetContainer(Value : TWinControl);
begin
     { Use Assign method because TButton is an object type }
     FContainer:=Value;
     if Value <> nil then Value.FreeNotification(Self);
end;

procedure TInFormBuilder.SetTipoForm (TipoForm: TFormClass);
begin
if TipoForm <> nil then InFormType:=TipoForm;
end;

procedure  TInFormBuilder.NewInside (Sender:TObject);
begin
CriaFormInterno (InFormType);
end;

procedure  TInFormBuilder.NewOutside (Sender:TObject);
begin
CriaFormExterno (InFormType);
end;

{ Method to generate OnNovaPessoa event }
procedure TInFormBuilder.NovoForm;
begin
     { Has the application assigned a method to the event, whether
       via the Object Inspector or a run-time assignment?  If so,
       execute that method }
     if Assigned(FOnNovoForm) then
        FOnNovoForm(Self)
end;


procedure TInFormBuilder.Loaded;
begin
     inherited Loaded;

     { Perform any component setup that depends on the property
       values having been set }

end;

procedure TInFormBuilder.CriaFormInterno (TipoForm: TFormClass);

begin
     if Assigned (FNovoForm) then exit;
     if TipoForm = nil then exit;
     FNovoForm:= TipoForm.Create(FContainer);
     NovoForm;
     FNovoForm.Hide;//Pablo
     //Captura destroy para por nil na variavel FNovoForm;
     FNovoForm.OnDestroy := OnDestroyFormInterno;
     FNovoForm.Parent:=FContainer;//Pablo
     FNovoForm.BorderStyle:=bsNone;

     if not Assigned( FOldResizeContainer ) and
        Assigned( FContainer ) and
        (FContainer is TPanel) then
     begin
        FOldResizeContainer := TPanel(FContainer).OnResize;
        TPanel(FContainer).OnResize := OnContainerResize;
     end;
     if not Resize then
     begin
        FNovoForm.Left:=FLeftMargin;
        FNovoForm.Top:=FTopMargin;
        if  Assigned(FContainer) then
            begin
               FNovoForm.Height:=FContainer.Height-FBottonMargin;
               FNovoForm.Width:=FContainer.Width-FRightMargin;
            end;
     end;
//     FNovoForm.Parent:=FContainer;//Pablo
     if FModal then FNovoForm.ShowModal
     else FNovoForm.Show;
     if FNovoForm <> nil then FNovoForm.FreeNotification(Self);
end;

procedure TInFormBuilder.CriaFormExterno (TipoForm: TFormClass);
begin
     if Assigned (FNovoForm) then exit;
     if TipoForm = nil then exit;
     NovoForm;
     Application.CreateForm (TipoForm,FNovoForm);
     if FModal then FNovoForm.ShowModal
     else FNovoForm.Show;
     if FNovoForm <> nil then FNovoForm.FreeNotification(Self);

end;
procedure TInFormBuilder.CloseInForm;
begin
     if FNovoForm <> nil then FNovoForm.Close;
end;

procedure TInFormBuilder.ShowInForm;
begin
     if FNovoForm <> nil then
        if FModal then FNovoForm.ShowModal else FNovoForm.Show;
end;

procedure TInFormBuilder.HideInForm;
begin
     if FNovoForm <> nil then FNovoForm.Hide;
end;

procedure TInFormBuilder.OnDestroyFormInterno (Sender:TObject);
begin
    FNovoForm:=nil;
end;

function TInFormBuilder.Resize : Boolean;
begin
   Result := False;
   if Assigned( FNovoForm ) and FAutoSize then
   begin
      FNovoForm.Top := FContainer.Top;
      FNovoForm.Left := FContainer.Left;
      FNovoForm.Width := FContainer.Width;
      FNovoForm.Height := FContainer.Height;
      Result := True;
   end;
end;

procedure TInFormBuilder.SetAutoSize(const Value: Boolean);
begin
  FAutoSize := Value;
end;

procedure TInFormBuilder.OnContainerResize(Sender: TObject);
begin
   Resize;
   if assigned( FOldResizeContainer ) then
      FOldResizeContainer( Sender );
end;

end.

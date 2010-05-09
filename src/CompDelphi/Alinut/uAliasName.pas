unit uAliasName;

interface
uses
    Classes;
procedure openAllTables(component: TComponent);

Const
// BDE_ALIAS_NAME :string = 'BDOrganizador';
BDE_ALIAS_NAME :string = 'My_NutWin-1.6';

implementation


uses
    Forms, DBTables, DB;

{ TAliasName }

procedure openAllTables(component: TComponent);
var i: integer;
    owned: TComponent;
    table: TTable;
begin
for i := component.ComponentCount - 1 downto 0 do
    begin
    owned := component.Components[I];
    if  (owned is TTable) then
        begin
        table :=  owned AS TTable;
        if table.TableName <> '' then
           table.Open;
        end;
    end;
end;

end.

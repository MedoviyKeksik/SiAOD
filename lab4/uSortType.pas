unit uSortType;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TfrmSortType = class(TForm)
    btnOk: TButton;
    btnCancel: TButton;
    rgSortBy: TRadioGroup;
    rgSortOrder: TRadioGroup;
  private
    { Private declarations }
  public
    function ShowAndGet(var SortType: Boolean; var Order: Boolean): Integer;
    { Public declarations }
  end;

var
  frmSortType: TfrmSortType;

implementation

{$R *.dfm}

{ TfrmSortType }

function TfrmSortType.ShowAndGet(var SortType, Order: Boolean): Integer;
begin
  Result := ShowModal;
  SortType := rgSortBy.ItemIndex = 1;
  Order := rgSortOrder.ItemIndex = 0;
end;

end.

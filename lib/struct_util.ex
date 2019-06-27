defmodule StructUtil do
  def get_tables("hades") do
    %{
      "Users" => [
        {"id", :int, :primary_key},
        {"name", :varchar2},
        {"age", :int},
        {"active", :bool}
      ],
      "Companies" => [
        {"id", :int, :primary_key},
        {"name", :varchar2},
        {"nip", :varchar2},
        {"active", :bool}
      ],
      "Permits" => [
        {"id", :int, :primary_key},
        {"user_id", :int, :foreign_key},
        {"comapny_id", :int, :foreign_key},
        {"default", :bool}
      ]
    }
  end
  def get_tables(_), do: []
end

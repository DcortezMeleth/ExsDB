defmodule StructUtilTest do
  use ExUnit.Case, async: true
  use ExUnit.Parameterized

  doctest StructUtil

  test "Should return 3 tables" do
    assert StructUtil.get_tables() |> Kernel.map_size() == 3
  end

  test_with_params "Should return correct columns",
                   fn table_name, expected_columns ->
                     assert StructUtil.get_tables |> Map.fetch!(table_name) == expected_columns
                   end do
    [
      {"Users", [
         {"id", :int, :primary_key},
         {"name", :varchar2},
         {"age", :int},
         {"active", :bool}
       ]} |> Macro.escape,
      {"Companies", [
         {"id", :int, :primary_key},
         {"name", :varchar2},
         {"nip", :varchar2},
         {"active", :bool}
       ]} |> Macro.escape,
      {"Permits", [
         {"id", :int, :primary_key},
         {"user_id", :int, :foreign_key},
         {"comapny_id", :int, :foreign_key},
         {"default", :bool}
       ]} |> Macro.escape
    ]
  end
end

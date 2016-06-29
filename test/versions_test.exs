defmodule VersionsTest do
  use ExUnit.Case, async: true




  describe "generate semiver" do
    test "every value is positive value" do
      struct = Versions.semver(1, 4, 2)
      assert struct == %Versions{major: 1, minor: 4, patch: 2}
    end

    test "every value is zero value" do
      struct = Versions.semver(0, 0, 0)
      assert struct == %Versions{major: 0, minor: 0, patch: 0}
    end
  end

  describe "argument error with negative value" do
    test "major", do: assert_raise(ArgumentError, "major should bigger and equal to 0", fn -> Versions.semiver(-1, 1, 1) end)
    test "minor", do: assert_raise(ArgumentError, "minor should bigger and equal to 0", fn -> Versions.semiver(1, -1, 1) end)
    test "patch", do: assert_raise(ArgumentError, "patch should bigger and equal to 0", fn -> Versions.semiver(1, 1, -1) end)
  end


  test "argument error with no integer" do
    assert_raise(ArgumentError, "major, minor and patch should be integer", fn -> Versions.semiver("1", "0", "-1") end)
  end

  describe "compare lhs and rhs" do
    test "1.3.9 is smaller than 1.4.2" do
      lhs = Versions.semver(1, 3, 9)
      rhs = Versions.semver(1, 4, 2)
      assert Versions.compare(lhs, rhs) == :rhs
    end

    test "1.3.9 is smaller than 1.3.9" do
      lhs = Versions.semver(1, 3, 9)
      rhs = Versions.semver(1, 3, 9)
      assert Versions.compare(lhs, rhs) == :rhs
    end

    test "0.0.2 is bigger than 0.0.1" do
      lhs = Versions.semver(0, 0, 2)
      rhs = Versions.semver(0, 0, 1)
      assert Versions.compare(lhs, rhs) == :lhs
    end

  end
end

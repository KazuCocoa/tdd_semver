defmodule Versions do

  defstruct [:major, :minor, :patch]

  @type semiver :: struct()

  @type major :: integer()
  @type minor :: integer()
  @type patch :: integer()
  @type lhs :: atom()
  @type rhs :: atom()

  @spec semver(major, minor, patch) :: semiver
  def semver(major, minor, patch)
    when is_integer(major) and is_integer(minor) and is_integer(patch)
      and major >= 0 and minor >= 0 and patch >= 0 do
    %Versions{}
    |> Map.put(:major, major)
    |> Map.put(:minor, minor)
    |> Map.put(:patch, patch)
  end
  def semiver(major, minor, patch)
    when is_integer(major) and is_integer(minor) and is_integer(patch) do
    cond do
      major < 0 -> raise ArgumentError, message: "major should bigger and equal to 0"
      minor < 0 -> raise ArgumentError, message: "minor should bigger and equal to 0"
      patch < 0 -> raise ArgumentError, message: "patch should bigger and equal to 0"
      true -> raise ArgumentError
    end
  end
  def semiver(_, _, _), do: raise ArgumentError, message: "major, minor and patch should be integer"

  @spec compare(semiver, semiver) :: lhs | rhs
  def compare(%Versions{major: l_major, minor: l_minor, patch: l_patch},
    %Versions{major: r_major, minor: r_minor, patch: r_patch})
      when is_integer(l_major) and is_integer(l_minor) and is_integer(l_patch)
        and is_integer(r_major) and is_integer(r_minor) and is_integer(r_patch) do
    cond do
      {l_major, l_minor, l_patch} > {r_major, r_minor, r_patch} -> :lhs
      {l_major, l_minor, l_patch} <= {r_major, r_minor, r_patch} -> :rhs
      true -> raise ArgumentError, message: "major, minor and patch should be integer"
    end
  end
  def compare(_lhs, _rhs), do: raise ArgumentError, message: "major, minor and patch should be integer"
end

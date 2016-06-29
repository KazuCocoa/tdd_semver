defmodule Versions do

  defstruct [:major, :minor, :patch]

  @type semiver :: struct()

  @type major :: integer()
  @type minor :: integer()
  @type patch :: integer()
  @type lhs :: atom()
  @type rhs :: atom()

  @spec semver(major, minor, patch) :: {:ok, semiver} | {:error, String.t}
  def semver(major, minor, patch)
    when is_integer(major) and is_integer(minor) and is_integer(patch)
      and major >= 0 and minor >= 0 and patch >= 0 do
    versions = %Versions{}
               |> Map.put(:major, major)
               |> Map.put(:minor, minor)
               |> Map.put(:patch, patch)
    {:ok, versions}
  end
  def semver(major, minor, patch) when is_integer(major) and is_integer(minor) and is_integer(patch) do
    cond do
      major < 0 -> {:error, "major should bigger and equal to 0"}
      minor < 0 -> {:error, "minor should bigger and equal to 0"}
      patch < 0 -> {:error, "patch should bigger and equal to 0"}
      true -> {:error, "major, minor and patch should be integer"}
    end
  end
  def semver(_, _, _), do: {:error, "major, minor and patch should be integer"}

  @spec semver!(major, minor, patch) :: semiver | no_return
  def semver!(major, minor, patch) do
    case semver(major, minor, patch) do
      {:ok, versions} -> versions
      {:error, message} -> raise ArgumentError, message: message
    end
  end

  @spec compare(semiver, semiver) :: {:ok, lhs} | {:ok, rhs} | {:error, String.t}
  def compare(%Versions{major: l_major, minor: l_minor, patch: l_patch},
    %Versions{major: r_major, minor: r_minor, patch: r_patch})
      when is_integer(l_major) and is_integer(l_minor) and is_integer(l_patch)
        and is_integer(r_major) and is_integer(r_minor) and is_integer(r_patch) do
    cond do
      {l_major, l_minor, l_patch} > {r_major, r_minor, r_patch} -> {:ok, :lhs}
      {l_major, l_minor, l_patch} <= {r_major, r_minor, r_patch} -> {:ok, :rhs}
      true -> {:error, "major, minor and patch should be integer"}
    end
  end
  def compare(_lhs, _rhs), do: {:error, "major, minor and patch should be integer"}

  @spec up(semiver, String.t) :: semiver
  def up(%Versions{major: major, minor: _minor, patch: _patch}, "major"), do: Versions.semver major + 1, 0, 0
  def up(%Versions{major: major, minor: minor, patch: _patch}, "minor"), do: Versions.semver major, minor + 1, 0
  def up(%Versions{major: major, minor: minor, patch: patch}, "patch"), do: Versions.semver major, minor, patch + 1
  def up(_versions, _), do: {:error, "no elements"}
end

defmodule StudentManager.AccountsTest do
  @moduledoc false

  use StudentManager.DataCase

  alias StudentManager.Accounts

  describe "users" do
    alias StudentManager.Accounts.User

    @valid_attrs %{
      email: "email@example.com",
      password: "supersecretpassword",
      confirm_password: "supersecretpassword"
    }
    @invalid_attrs %{email: "bademail@bad", password: "short", confirm_password: "shot"}
    @update_attrs %{}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
    end

    @tag :pending
    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    @tag :pending
    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    # @tag :pending
    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
    end

    # @tag :pending
    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    # @tag :pending
    test "create_user/1 creates a user with a default role of student" do
      {:ok, user} = Accounts.create_user(@valid_attrs)
      assert user.roles == ["student"]
    end

    @tag :pending
    test "create_user/1 validates a correct role" do
      assert {:error, %Ecto.Changeset{}} =
               Accounts.create_user(Map.put(@invalid_attrs, :roles, ["pilot", "teacher"]))
    end

    @tag :pending
    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Accounts.update_user(user, @update_attrs)
    end

    @tag :pending
    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    @tag :pending
    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    @tag :pending
    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end

    # @tag :pending
    test "create_teacher/1 creates a user with the teacher role set" do
      {:ok, user} = Accounts.create_teacher(@valid_attrs)
      assert Enum.member?(user.roles, "teacher")
      refute Enum.member?(user.roles, "student")
    end

    # @tag :pending
    test "create_student/1 creates a user with the student role set" do
      {:ok, user} = Accounts.create_student(@valid_attrs)
      assert Enum.member?(user.roles, "student")
      refute Enum.member?(user.roles, "teacher")
    end
  end
end

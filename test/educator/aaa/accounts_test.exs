defmodule Educator.AAA.AccountsTest do
  use Educator.AAA.DataCase, async: true

  alias Educator.AAA.Accounts

  describe "Educators" do
    test "get_educator/1 when educator exists returns educator" do
      educator = insert!(:educator)

      assert Accounts.get_educator(educator.id).id == educator.id
    end

    test "get_educator_by_email/1 when educator doesn't exists returns nil" do
      refute Accounts.get_educator(0)
    end

    test "get_educator_by_email/1 when educator exists returns educator" do
      educator = insert!(:educator)

      assert Accounts.get_educator_by_email(educator.email) == educator
    end

    test "get_educator_by_email/1 when email doesn't exists returns nil" do
      assert Accounts.get_educator_by_email("no@such.email") == nil
    end

    test "create_educator/1 with valid attributes creates new educator" do
      attrs = attrs_for(:educator)

      assert {:ok, %Accounts.Educator{} = educator} = Accounts.create_educator(attrs)

      refute educator.password, "password should be nil"
    end

    test "create_educator/1 trims surrounding whitespace from title and email" do
      attrs = attrs_for(:educator, title: " Title ", email: " user@example.com ")

      assert {:ok, %Accounts.Educator{} = educator} = Accounts.create_educator(attrs)

      assert educator.title == String.trim(attrs.title)
      assert educator.email == String.trim(attrs.email)
    end

    test "create_educator/1 with duplicate title or email returns error changeset" do
      educator = insert!(:educator)

      attrs = attrs_for(:educator, title: educator.title)
      assert {:error, %Changeset{} = changeset} = Accounts.create_educator(attrs)
      assert %{title: ["has already been taken"]} = errors_on(changeset)

      attrs = attrs_for(:educator, email: educator.email)
      assert {:error, %Changeset{} = changeset} = Accounts.create_educator(attrs)
      assert %{email: ["has already been taken"]} = errors_on(changeset)
    end

    test "create_educator/1 without title, email or password returns error changeset" do
      attrs = attrs_for(:educator, title: nil, email: nil, password: nil)

      assert {:error, %Changeset{} = changeset} = Accounts.create_educator(attrs)

      assert %{
               title: ["can't be blank"],
               email: ["can't be blank"],
               password: ["can't be blank"]
             } = errors_on(changeset)
    end

    test "create_educator/1 with invalid title returns errors changeset" do
      attrs = attrs_for(:educator, title: "a")

      assert {:error, %Changeset{} = changeset} = Accounts.create_educator(attrs)
      assert %{title: ["should be at least 2 character(s)"]} = errors_on(changeset)

      attrs = attrs_for(:educator, title: String.duplicate("a", 101))

      assert {:error, %Changeset{} = changeset} = Accounts.create_educator(attrs)
      assert %{title: ["should be at most 100 character(s)"]} = errors_on(changeset)
    end

    test "create_educator/1 with invalid email returns error changeset" do
      attrs = attrs_for(:educator, email: "does.not.contain.at.character")

      assert {:error, %Changeset{} = changeset} = Accounts.create_educator(attrs)
      assert %{email: ["has invalid format"]} = errors_on(changeset)

      attrs = attrs_for(:educator, email: "does.not.contain.dot.at.hostname.part@hostname")

      assert {:error, %Changeset{} = changeset} = Accounts.create_educator(attrs)
      assert %{email: ["has invalid format"]} = errors_on(changeset)
    end

    test "create_educator/1 with invalid password returns error changeset" do
      attrs = attrs_for(:educator, password: "short")

      assert {:error, %Changeset{} = changeset} = Accounts.create_educator(attrs)
      assert %{password: ["should be at least 8 character(s)"]} = errors_on(changeset)

      attrs = attrs_for(:educator, title: "MATCHES TITLE", password: "matches title")

      assert {:error, %Changeset{} = changeset} = Accounts.create_educator(attrs)
      assert %{password: ["matches title"]} = errors_on(changeset)

      attrs =
        attrs_for(:educator,
          title: "MATCHES.EMAIL@example.com",
          password: "matches.email@example.com"
        )

      assert {:error, %Changeset{} = changeset} = Accounts.create_educator(attrs)
      assert %{password: ["matches title"]} = errors_on(changeset)
    end

    test "authenticate_educator/2 with valid credentials returns educator" do
      educator = insert!(:educator, password: "password")

      assert {:ok, ^educator} = Accounts.authenticate_educator(educator.email, "password")
    end

    test "authenticate_educator/2 with invalid password returns error changeset" do
      educator = insert!(:educator, password: "password")

      assert {
               :error,
               %Changeset{} = changeset
             } = Accounts.authenticate_educator(educator.email, "invalid password")

      assert %{password: ["is invalid"]} = errors_on(changeset)
    end

    test "authenticate_educator/2 when email doesn't exists returns error changeset" do
      assert {
               :error,
               %Changeset{} = changeset
             } = Accounts.authenticate_educator("no@such.email", "password")

      assert %{email: ["is not found"]} = errors_on(changeset)
    end
  end
end

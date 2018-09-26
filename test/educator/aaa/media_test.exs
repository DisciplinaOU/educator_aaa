defmodule Educator.AAA.MediaTest do
  use Educator.AAA.DataCase, async: true

  alias Educator.AAA.Media

  describe "Uploads" do
    alias Educator.AAA.Media.Upload

    test "get_upload/1 with when upload exists returns it" do
      upload = insert!(:upload)

      assert Media.get_upload(upload.id) == upload
    end

    test "get_upload/1 with when upload doesn't exist returns nil" do
      refute Media.get_upload(0)
    end

    test "sign_upload/1 with valid attributes creates new upload" do
      attrs = attrs_for(:upload)

      assert {:ok, %Upload{} = upload} = Media.sign_upload(attrs)
    end

    test "sign_upload/1 without key or mimetype returns error changeset" do
      attrs = attrs_for(:upload, key: nil, mimetype: nil)

      assert {:error, %Changeset{} = changeset} = Media.sign_upload(attrs)

      assert %{key: ["can't be blank"], mimetype: ["can't be blank"]} = errors_on(changeset)
    end

    test "sign_upload/1 with invalid/unsupported mimetype returns error changeset" do
      attrs = attrs_for(:upload, mimetype: "application/json")

      assert {:error, %Changeset{} = changeset} = Media.sign_upload(attrs)
      assert %{mimetype: ["is invalid"]} = errors_on(changeset)
    end

    test "create_upload/1 with valid attributes creates new upload" do
      attrs = attrs_for(:upload)

      assert {:ok, %Upload{} = upload} = Media.create_upload(attrs)
    end

    test "create_upload/1 without key or mimetype returns error changeset" do
      attrs = attrs_for(:upload, key: nil, mimetype: nil)

      assert {:error, %Changeset{} = changeset} = Media.create_upload(attrs)

      assert %{key: ["can't be blank"], mimetype: ["can't be blank"]} = errors_on(changeset)
    end

    test "create_upload/1 with invalid/unsupported mimetype returns error changeset" do
      attrs = attrs_for(:upload, mimetype: "application/json")

      assert {:error, %Changeset{} = changeset} = Media.create_upload(attrs)
      assert %{mimetype: ["is invalid"]} = errors_on(changeset)
    end

    test "create_upload/1 with duplicate key returns error changeset" do
      upload = insert!(:upload)

      attrs = attrs_for(:upload, key: upload.key)

      assert {:error, %Changeset{} = changeset} = Media.create_upload(attrs)
      assert %{key: ["has already been taken"]} = errors_on(changeset)
    end
  end
end

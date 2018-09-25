defmodule Educator.AAA.S3.Upload do
  @moduledoc "Authenticated S3 upload request."

  @enforce_keys [:mimetype, :key]

  @kb 1024
  @mb 1024 * @kb

  defstruct mimetype: nil,
            key: nil,
            acl: "public-read",
            expires_in: 60,
            content_length: (10 * @kb)..(10 * @mb)

  @typedoc """
  A type which represents an authenticated S3 upload request.

  ## Required keys:

  * `:mimetype`: the MIME type of the file.
  * `:key`: the key name or a prefix of the uploaded file.

  ## Optional keys:

  * `:acl`: the [ACL](https://docs.aws.amazon.com/AmazonS3/latest/dev/acl-overview.html#canned-acl) value of the uploaded file. Defaults to `public-read`.
  * `:expires_in`: time window during which the upload is considered valid, in
    seconds. Defaults to 60 seconds.
  * `:content_length`: the minimum and maximus allowable size for the uploaded
    file, in bytes. Defaults to 10KB..10MB
  """
  @type t :: %__MODULE__{
          mimetype: String.t(),
          key: String.t(),
          acl: String.t(),
          expires_in: pos_integer(),
          content_length: Range.t()
        }
end

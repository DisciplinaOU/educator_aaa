# Educator.AAA

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## AWS Configuration

### S3

* Create new AWS S3 bucket.
* [Configure CORS](https://docs.aws.amazon.com/AmazonS3/latest/dev/cors.html) on the
  created bucket to accept requests from the client's origin:

   ``` xml
   <CORSConfiguration>
     <CORSRule>
       <AllowedOrigin>http://localhost:8080</AllowedOrigin>
       <AllowedMethod>GET</AllowedMethod>
       <AllowedMethod>POST</AllowedMethod>
       <ExposeHeader>Location</ExposeHeader>
       <AllowedHeader>*</AllowedHeader>
     </CORSRule>
   </CORSConfiguration>
   ```

    Change the `<AllowedOrigin>` value to your client's origin.

   **Note**: the `Location` header *must* be exposed so the client could get the url
   of the uploaded object right away.
* Create a lifecycle rule to expire objects under the `tmp/` prefix 1 day after the object creation.

## Deployment

AAA service uses [Distillery](https://hex.pm/packages/distillery) for managing
releases, see the [docs](https://hexdocs.pm/distillery/) for more info.

### Build a release

Prerequisites:

* Elixir 1.7.3
* Erlang/OTP 21

Run `bin/release` to build a release. It will create
`_build/artifacts/release.tar.gz` on success.

### Set environment variables

* `MIX_ENV=prod`.
* `SECRET_KEY_BASE` (randomly generated string, must be at least 64 bytes long).
* `PORT`.
* `DATABASE_URL` (PostgreSQL connection url).
* `AWS_ACCESS_KEY_ID`.
* `AWS_SECRET_ACCESS_KEY`.
* `AWS_REGION`.
* `AWS_S3_BUCKET`.

### Running a release

Copy and extract the release to the target machine. It doesn't need neither Elixir nor
Erlang installed, since ERTS is bundled with the release.

* `$APP_DIR/bin/educator_aaa foreground` &mdash; run the release in the
  foreground.
* `$APP_DIR/bin/educator_aaa start` &mdash; run the release in the background.
* `$APP_DIR/bin/educator_aaa stop` &mdash; stop a release started via `start`.
* `$APP_DIR/bin/educator_aaa migrate` &mdash; run database migrations.

See [Using Distillery with systemd](https://hexdocs.pm/distillery/guides/systemd.html)
for sample systemd unit configs.

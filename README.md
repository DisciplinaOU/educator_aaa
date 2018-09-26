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

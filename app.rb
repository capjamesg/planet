require "httparty"
require "sinatra"
require "dotenv"
require "erb"

Dotenv.load

# class App < Sinatra::Application
    get "/" do
        microsub_url = "#{ENV['MICROSUB_ENDPOINT']}?action=timeline&channel=indiewebnaw"

        headers = {
            "Content-Type" => "application/json",
            "Authorization" => "Bearer #{ENV['MICROSUB_TOKEN']}"
        }

        request = HTTParty.get(microsub_url, headers: headers)

        if request.code != 200
            halt 500, "Error fetching feed"
        end

        template_file = File.read("templates/planet.html")

        @feed_items = JSON.parse(request.body)["items"]

        ERB.new(template_file).result(binding)
    end

    get "/static/styles.css" do
        content_type "text/css"
        return File.read("static/styles.css")
    end

    get "/favicon.ico" do
        content_type "image/x-icon"
        return File.read("static/favicon.ico")
    end

    not_found do
        status 404
        template = File.read("templates/error.html")

        @error_type = 404

        ERB.new(template).result(binding)
    end

    error 500 do
        status 500
        template = File.read("templates/error.html")

        @error_type = 500

        ERB.new(template).result(binding)
    end
# end
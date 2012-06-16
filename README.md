# SoundCloud Backend Developer Challenge

Build a system that will accept a multipart form upload while displaying
a percentage progress.

## Specification
When a user picks a file from their computer, the upload automatically begins.
While uploading, the percentage complete is visible on the page. It should
update at least every 2 seconds.

While uploading, the user should be able to enter text into a description
text area.

When the upload completes, the page should display the path to the saved file.
When the user clicks save, the current value of the description text area
should be posted to the server. The response to the form post request should
display both the title and the path to the file.

## Requirements

- The system must function behind a firewall that blocks all but port 80
- The system must support concurrent uploads from different users
- The system must work in IE > 6, Firefox and Chrome

## Results

**SuperUpload** is application based on Sinatra. It uses UploadProgress
middleware to handle upload process. This middleware has been created as
part of challenge.

### Demo

[http://soundcloud.soulim.com/](http://soundcloud.soulim.com/)

### Basic idea

The idea of middleware is based on special wrapper around `env['rack.input']`.
This wrapper will count the amount of received data each time as Rack
application or middleware reads from `env['rack.input']`.

UploadProgress uses simple queue to store information about simultaneous uploads.
Queue data is shared between Rainbows workers using DRb server, but it's
possible to add support for another backend.

### Web server

**SuperUpload** uses [Rainbows server](https://rubygems.org/gems/rainbows).
This server supports direct access to input stream without any buffering.

I have tried Thin and Unicorn servers.

Thin has input stream buffering and it blocks possibility to measure upload
progress.

Unicorn supports direct access to input steam, but this server should not
work with HTTP requests directly. I have tried Nginx as proxy, but it buffered
uploaded file too.

So my server of choice is Rainbows.

### How to run SuperUpload locally

Clone git repository and open directory with application code. Run following
command to install gems:

    $ bundle install

SuperUpload uses DRb server to store information about queue of uploads.
To start simple DRb server open a new terminal and run:

    $ bin/drb_server

Start the Rainbows server:

    $ bundle exec rainbows -c rainbows.config.rb

Open URL http://localhost:8080 in your favourite browser.

### Browser support

I've tested **SuperUpload** unsing IE6+, Firefox, Chrome and Safari.

### Possible future improvements

- Add different queue backends
- Add support for [XMLHttpRequest Level 2](http://www.w3.org/TR/XMLHttpRequest/)
  in jQuery.superupload.js

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
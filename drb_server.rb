require 'drb/drb'

SERVER_URI = 'druby://localhost:8787'

DRb.start_service(SERVER_URI, Hash.new)
DRb.thread.join

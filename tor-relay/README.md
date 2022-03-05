# tor-relay

https://community.torproject.org/relay/

The Tor network relies on volunteers to donate bandwidth. The more people who
run relays, the better the Tor network will be. The current Tor network is
quite small compared to the number of people who need to use Tor, which means
we need more dedicated volunteers like you to run relays. By running a Tor
relay you can help make the Tor network.

## Key material

Remove the comment `# - './tor-relay/keys:/var/lib/tor/.tor/keys/'` in [tor-relay/docker-compose.tor-relay.yml](https://github.com/tomMoulard/make-my-server/blob/master/tor-relay/docker-compose.tor-relay.yml) to reuse the key material when the server is restarted. Otherwise, new keys will be generated and Tor training will start over. Make sure you have set the correct permission for the folder `tor-relay/keys`. It should be UID `100`, the UID of the Tor user inside the container.

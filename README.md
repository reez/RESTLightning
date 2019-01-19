# RESTLightning

**RESTLightning is a way for iOS Developers to get comfortable with how to interact on iOS with the Lightning Network.**

The project is set up to be as easy as possible for iOS Devs:

- Use REST API calls
- No dependencies (just clone the project and start running)
- Use Playgrounds for modularized clarity and immediate feedback

One more thing the project tries to do is mock things out so whether you have a nodes certificate+macaroon+uri, you can still run the project to see how things work. *Having your own node and by extension the certificate/macaroon/uri felt like another hidden dependency I wanted to abstract away so someone could just build and run*.

The project has Playgrounds, but also tries to make things even better by putting all of the related files in a Framework, so whether you want to quickly run in Playgrounds or if you have a certificate+macaroon+uri and want to hop over to the .xcodeproj to run actual request to your node in the Simulator... you can!

## Lightning Network

RESTLightning interacts with [LND](https://github.com/lightningnetwork/lnd) to test the `/getinfo` [LND REST API](https://api.lightning.community/rest/index.html) call to get the status of a Lightning Node.

## Usage
`git clone`

Build the RESTLightning Framework

Either Run the Playgrounds or Run in the Simulator.

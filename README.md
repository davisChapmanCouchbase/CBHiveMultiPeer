# CBHiveMultiPeer

CB Hive Multi-Peer is a demonstration app for iOS devices.  It is intended to demonstrate the Peer-to-Peer functionality of Couchbase Lite, version 1.3.  The device discovery is performed using Apple's MultipeerConnectivity library.  This demo app does not include any security or authentication to verify the identity of peers.

To use the app, compile and install on two or more iOS devices, or one device and run a second instance in the iOS simulator.

When running the app - 
 - The app will ask for a name, this is the name that will be associated with this device, both for discovery and messaging.
 - Once a name has been entered, the app will display a list of discovered peers that it is connecting to.  This list may be re-displayed at any time by pressing the folder icon on the left of the top-of-the-screen toolbar.
 - Press "Dismiss" to hide the list of peers.
 - Press the "+" in the upper-right corner to add a new message.  Click "Save" to save the message.  Upon saving, the message will be replicated to all connected peers.

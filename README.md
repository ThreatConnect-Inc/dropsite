# dropsite

There are a few configuration steps needed before running:

1. Choose a MAC address and add it to `config.vm.base_mac` in the Vagrantfile
2. Add the IP address of the server as `push.host` in the Vagrantfile
3. Add some random string to `app.secret_key` in `dropsite/dropsite.py`

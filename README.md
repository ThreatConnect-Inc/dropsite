# dropsite

There are a few configuration steps needed before running:

1. Choose a MAC address and add it to `config.vm.base_mac` in the Vagrantfile
2. Add the IP address of the server as `push.host` in the Vagrantfile
3. Add some random string to `app.secret_key` in `dropsite/dropsite.py`

To run locally, first install the following pre-requisites:

1. Vagrant https://www.vagrantup.com/
2. VirtualBox https://www.virtualbox.org/
3. OpenSSH https://www.openssh.com/

The box is configured to use port 8081 for the dropsite app. Make sure that this port is available on your host workstation. If it is not available, change the port in the Vagrantfile.

After all pre-requisites are installed, run the app with the following command from the directory this repo is cloned into:

`vagrant up`

**NOTE:** The following two startup messages are returned as errors, but are not actually errors. They can both be safely ignored.

```
==> default: nginx: the configuration file /usr/local/etc/nginx/nginx.conf syntax is ok
==> default: nginx: configuration file /usr/local/etc/nginx/nginx.conf test is successful
```

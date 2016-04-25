# docker-kodi-server

This will allow you to
* serve files through the XBMC UPnP Library to your UPnP client/players (such as Xbmc or Chromecast).
* Web access every time , or use with some tools like [htpc-manager](http://htpc.io/)
* Trigger library scan When you want or from sickbeard/sickrage/couchpotato/...

Docker is used to compile and run the latest headless version of KODI on ubuntu LTS




### Preqrequisites:
* Docker (Follow the [installation instructions](https://docs.docker.com/))
* A shared Library with mysql is higly recommended ( depending you needs)

### Quick start

1. Prepare a full kodi profile with the GUI version 

If you require web access, make sure to enable this, and set the port to 8089.
Because 8080 is default for http proxy , the docker image expose 8089


2. Make a copy of the ~/.kodi directory ( destination  doesn't matter , this is just an example)

        $ cp -r ~./kodi ~/kodi-server-profile

2. Use prebuild docker image ([see here](https://hub.docker.com/r/celedhrim/kodi-server/))

  For the last stable version,

        $ docker pull celedhrim/kodi-server

  For a specific version,

        $ docker pull celedhrim/kodi-server:branchname


  | branchname           | Kodi branch | Kodi version | Ubuntu version      |
  |----------------------|-------------|--------------|---------------------|
  | `lastest` ( default) | jarvis      | 16.1         | 16.04 (Xenial Xerus) |
  | `helix`              | helix       | 14.2         | 14.04 (Trusty Tahr) |
  | `isengard`           | isengard    | 15.2         | 14.04 (Trusty Tahr) |
  | `jarvis`             | jarvis      | 16.1         | 16.04 (Xenial Xerus) |
  | `experimental`       | jarvis      | 16.0         | 16.04 (Xenial Xerus)|

3. Run the image ( change the **/path/to/kodi-server-profile**)

        $ docker run -d --restart="always" --net=host -v /path/to/kodi-server-profile:/opt/kodi-server/share/kodi/portable_data celedhrim/kodi-server

   or if use specific branch

        $ docker run -d --restart="always" --net=host -v /path/to/kodi-server-profile:/opt/kodi-server/share/kodi/portable_data celedhrim/kodi-server:branchname




### Build the container yourself
    $ git clone https://github.com/Celedhrim/docker-kodi-server.git
    $ git checkout branchname
    $ docker build --rm=true -t $(whoami)/kodi-server .

Then proceed with the Quick start section.

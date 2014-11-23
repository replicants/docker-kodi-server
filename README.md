# docker-xbmc-server

This will allow you to serve files through the KODI UPnP Library to your UPnP client/players (such as kodi or Chromecast). 

Docker is used to compile and run the latest headless version of KODI

### Preqrequisites:
* Docker version 0.12+ (Follow the [installation instructions](https://docs.docker.com/))

### Quick start

1. Clone this repository:
        
        $ git clone git@github.com:celedhrim/docker-xbmc-server.git -b helix

2. open `xbmcdata/userdata/advancedsettings.xml` and change the following information to reflect your installation:

        <videodatabase>
                <type>mysql</type>
                <host>192.168.1.50</host>
                <port>3306</port>
                <user>xbmc</user>
                <pass>xbmc</pass>
        </videodatabase>
        <musicdatabase>
                <type>mysql</type>
                <host>192.168.1.50</host>
                <port>3306</port>
                <user>xbmc</user>
                <pass>xbmc</pass>
        </musicdatabase>
        
    The ip,port,user and password refers to your xbmc mysql database.

    Or simple prepare a profile with a desktop kodi version.

### Build the container yourself
Replace gotham with master or frodo accordingly if necessary:
    
    $ git checkout helix
    $ docker build --rm=true -t $(whoami)/docker-kodi-server .

### Launch it ! ###

docker run -d --net=host -v /directory/with/kodidata:/opt/kodi-server/share/kodi/portable_data $(whoami)/docker-kodi-server

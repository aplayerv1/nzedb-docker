Grab the configuration folder from nzedb github edit the settings.php and create config.php 

    version: '3'

    networks:
      localnet:
        driver: bridge
        ipam:
          config:
            - subnet: 172.7.0.0/16

    services:
      nzedb:
        container_name: nzedb
        image: aplayerv1/nzedb:latest
        restart: always
        volumes:
          - ./config:/opt/config/nzedb 
          - ./nzedb:/opt/http
        environment:
          - TZ=Europe/Lisbon
          - PATH_INSTALL_ROOT=/opt/http                     #install directory
          - PATH_WEB_RESOURCES=/opt/resources               #Web Resources where the nzb and other stuff goes to
          - PATH_WEB_SERVER_ROOT=/opt/http/www              # root of the website which is install_root/www
          - PATH_CUSTOM_CONFIG=/opt/config/                 # custom nzedb configs  (settings.php, etc...)
          - PHP_MAX_EXECUTION_TIME=120                      # php maximum execution time recommended 120
          - PHP_MEMORY_LIMIT=2G                             # php memory limit default is 128MB recommend 1G
          - PHP_TIMEZONE=Europe/Lisbon                      # TZ find your time zone
          #- REFRESH_POSTPROCESS_OPTIONS=nfo mov tv ama     #Default: "nfo mov tv ama" The postprocessing options handed to misc/update/nix/multiprocessing/postprocess.php  
          - RUN_WEB_SERVER=1                                # Enable or disable web server 0 no 1 yes
          - RUN_REFRESH=1                                   # RUN REFRESH Run the updater in the background? If set to "1" then the update script will run in the background. 
          - WEB_SERVER_ROOT=/                                      # Default: "/" The web server's web root. 
          - WEB_SERVER_HTTP_PORT=80                         # Web server port default is 80
          - WEB_SERVER_HTTPS_PORT=443                       # Web server ssl port default is 443
          - WEB_SERVER_NAME=                                # Web server name I usually use an ip, default is "_", domain name of the web server. E.g. "hub.docker.com".
          - GIT_TOKEN=                                      # MANDATORY if you don't have one then nothing will happen
          - GITHUB_USER=                                       # MANDATORY if you don't have one then it will do nothing
          - PHP_SESSION_HANDLER=                            # PHP session handler only memcached is supported atm. variables "memcached or files"
          - PHP_SESSION_PATH=172.7.0.4                      # PHP session path for memcached an ip example is a docker memcache ip like bellow, default "/tmp"
          - PHP_SESSION_PORT=                               # PHP session port memcached port default is 11211, NOTE: if files is set then ip and port don't work
          - PHP_SERIALIZE_HANDLER=                          # PHP serialize default is set to php, the docker image comes with igbinary, set to igbinary to use that instead.
        ports:
          - 80:80
          - 4443:443
        networks:
          localnet:
            ipv4_address: 172.7.0.3

    # OPTIONAL SPHINX PLEASE SET your custom settings.php to use sphinx

      sphinx:
        image: avatarnewyork/dockerenv-sphinx:2.2
        container_name: sphinxsearch
        restart: always
        ports:
          - "9306:9306" 
          - "9312:9312"
        volumes:
          - ./logs:/var/log/sphinxsearch
          - ./conf/sphinx.conf:/etc/sphinx/sphinx.conf:ro
          - ./search:/var/run/sphinxsearch/
          - ./data:/var/lib/sphinxsearch/data 
        networks:
          localnet:
            ipv4_address: 172.7.0.2
    # OPTIONAL MEMCACHED if you want to use php memcached then use this or an equivelant memcache container set variables accordingly up above. NOTE if you want to use memcached in nzedb set variables in settings.php 
      memcached:
        container_name: memcached
        image: bitnami/memcached:latest
        environment:
          - MEMCACHED_CACHE_SIZE=1024
          - MEMCACHED_MAX_CONNECTIONS=2000
          - MEMCACHED_THREADS=4
        restart: always
        ports:
          - "11211:11211"
        networks:
          localnet:
            ipv4_address: 172.7.0.4

create config.php example

        <?php
        
        //=========================
        // Config you must change - updated by installer.
        //=========================
        define('DB_SYSTEM', 'mysql');
        define('DB_HOST', '');         // THIS IS THE IP OF THE DB
        define('DB_PORT', '3306');     // PORT OF DB
        define('DB_SOCKET', '');
        define('DB_USER', '');         // DB USER
        define('DB_PASSWORD', '');     //DB PASSWORD
        define('DB_NAME', 'nzedb');    //DB NAME
        define('DB_PCONNECT', false);
        
        define('NNTP_USERNAME', '');   // Your newsgroups username
        define('NNTP_PASSWORD', '');   // your password
        define('NNTP_SERVER', '');     //your service provider host name "news.newsgrouphosting.com"
        define('NNTP_PORT', '563');    // your port

        
        // If you want to use TLS or SSL on the NNTP connection (the NNTP_PORT must be able to support encryption).
        define('NNTP_SSLENABLED', true);
        // If we lose connection to the NNTP server, this is the time in seconds to wait before giving up.
        define('NNTP_SOCKET_TIMEOUT', '120');
        
        define('NNTP_USERNAME_A', '');
        define('NNTP_PASSWORD_A', '');
        define('NNTP_SERVER_A', '');
        define('NNTP_PORT_A', '119');
        define('NNTP_SSLENABLED_A', false);
        define('NNTP_SOCKET_TIMEOUT_A', '120');
        
        // Location to CA bundle file on your system. You can download one here: http://curl.haxx.se/docs/caextract.html
        define('nZEDb_SSL_CAFILE', '');
        // Path where openssl cert files are stored on your system, this is a fall back if the CAFILE is not found.
        define('nZEDb_SSL_CAPATH', '');
        // Use the aforementioned CA bundle file to verify remote SSL certificates when connecting to a server using TLS/SSL.
        define('nZEDb_SSL_VERIFY_PEER', '');
        // Verify the host is who they say they are.
        define('nZEDb_SSL_VERIFY_HOST', '');
        // Allow self signed certificates. Note this does not work on CURL as CURL does not have this option.
        define('nZEDb_SSL_ALLOW_SELF_SIGNED', '1');


still working on a better approach

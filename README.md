The Docker container for serving Python Flask project.

## Convention
`/srv` should be mounted as external host drive, which contains the project files, database, logs, etc.

During the building, it will upload the `requirements.txt` file to the container and automatically install all the packages.

## Usage

Mount the host `/srv` as container `/srv` directory, bind `80`/`443` ports to host(make sure they are not taken by host processes):

    $ sudo docker run -v /srv:/srv:ro -p 80:80 -p 443:443 cllu/serve -d /srv/http/walle/deployment/supervisor.conf

The `-d` will specify the `supervisord` config file to use.

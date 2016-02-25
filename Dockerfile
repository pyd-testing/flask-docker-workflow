# DOCKERFILE
# FLASK-DOCKER TEST APP FOR CI DEPLOYMENT

# PILIX::dafink


# C: Thu Feb 25 12:37:09 GMT 2016

FROM phusion/baseimage:0.9.18
# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# -- FLASK-DOCKER HERE --

RUN apt-get update
RUN apt-get -y install nginx supervisor python3-pip
RUN pip3 install uwsgi flask

# this is where our app directories are. Normally, they will be clustered
# GFS enabled and rather powerfule
#
ADD ./app /app
ADD ./config /config

# configure the setup
# first, we configure the default site
RUN echo "\ndaemon off;" >> /etc/nginx.conf
RUN rm /etc/nginx/sites-enabled/default

# and enable it - note the trailing slashs
#
RUN ln -s /config/nginx.conf /etc/nginx/sites-enabled/
RUN ln -s /config/supervisor.conf /etc/supervisor/conf.d/
# open port 80. 443 in the future of course
EXPOSE 80

# start the supervisor daemon
CMD ["supervisord", "-n"]


# -- FLASK-DOCKER --

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*



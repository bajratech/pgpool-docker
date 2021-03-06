FROM postgres:9.5 

RUN apt-get update
RUN apt-get install -y postgresql-server-dev-9.4 apache2 libapache2-mod-php5 curl build-essential

# Download pgpool2
RUN curl -L -o pgpool-II-3.5.3.tar.gz http://www.pgpool.net/download.php?f=pgpool-II-3.5.3.tar.gz 
RUN tar zxvf pgpool-II-3.5.3.tar.gz

# Build pgpool2
WORKDIR /pgpool-II-3.5.3
RUN ./configure
RUN make
RUN make install

# Build pgpool2 extensions for postgres
WORKDIR /pgpool-II-3.5.3/src/sql
RUN make
RUN make install

RUN ldconfig

# Clean up files
RUN rm -rf /pgpool-II-3.5.3 & rm /pgpool-II-3.5.3.tar.gz

# Expose pgpool port
EXPOSE 9999

# Add template of configuartion files
ADD pgpool2/pcp.conf /usr/local/etc/pcp.conf
ADD pgpool2/pgpool.conf /usr/local/etc/pgpool.conf
ADD pgpool2/pool_hba.conf /usr/local/etc/pool_hba.conf

# Set up configuration files and run pgpool
ADD start.sh /tmp/start.sh
RUN chmod 777 /tmp/start.sh
ENTRYPOINT ["/tmp/start.sh"]
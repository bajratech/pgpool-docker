#!/bin/bash

{
	# check if db is alive or not
	echo "#------------------------------------------------------------------------------"
	echo "# DB CONNECTION CHECK"
	echo "#------------------------------------------------------------------------------"

	echo "health_check_period = 20
                                   # Health check period
                                   # Disabled (0) by default
	health_check_timeout = 10
                                   # Health check timeout
                                   # 0 means no timeout
	health_check_user = 'bajra'
                                   # Health check user same as db connection user
	health_check_password = 'b@jr@123'
                                   # Password for health check user same as db connection password
	health_check_max_retries = 3
                                   # Maximum number of times to retry a failed health check before giving up.
	health_check_retry_delay = 1
                                   # Amount of time to wait (in seconds) between retries."

    # database connection setting
	echo "#------------------------------------------------------------------------------"
	echo "# BACKEND CONNECTION SETTINGS"
	echo "#------------------------------------------------------------------------------"

	echo "#backend_hostname0 = 0.0.0.0
                                   # Host name or IP address to connect to for backend 0
#backend_port0 = 5432
                                   # Port number for backend 0
#backend_weight0 = 1
                                   # Weight for backend 0 (only in load balancing mode)
#backend_data_directory0 = '/data'
                                   # Data directory for backend 0
#backend_flag0 = 'ALLOW_TO_FAILOVER'
                                   # Controls various backend behavior
                                   # ALLOW_TO_FAILOVER or DISALLOW_TO_FAILOVER
                                   "

	IFS=', ' read -r -a array <<< $BACKEND_HOSTNAME

	for index in "${!array[@]}"
	do
		echo ""
	    echo "backend_hostname$index = '${array[index]}'"
		echo "backend_port$index = 5432"
		echo "backend_weight$index = 1"
		echo "backend_data_directory$index = '/data$index'"
		echo "backend_flag$index = 'ALLOW_TO_FAILOVER'"
	done

} >> /usr/local/etc/pgpool.conf


#RUN pgpool
pgpool -n


# Use a minimal Ubuntu base image
FROM ubuntu:latest

# Install cron and any other necessary packages
RUN apt-get update && apt-get install -y \
    cron \
    vim \
    mc \
    python3 \
    python3-pip \
    supervisor


WORKDIR  /app


# flask part
COPY requirements.txt ./
RUN pip install -r requirements.txt
# Bundle app source
COPY app/* .
EXPOSE 5000

# Copy local cron file into the image
COPY cronjobs.simple /tmp/my_crontab
# Remove ^M characters and append the contents of your cron file to the system's crontab
RUN sed -i 's/\r$//' /tmp/my_crontab && cat /tmp/my_crontab >> /etc/crontab

# cron under supervisord
RUN mkdir -p /var/log/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Create the log file to be able to check cron works
RUN touch /var/log/cron.log

# Run the cron service in the foreground
#CMD cron -f

#CMD [ "flask", "run","--host","0.0.0.0","--port","5000"]
COPY ./start.sh /
CMD ["/app/start.sh"]
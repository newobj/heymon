#!/bin/bash

cd /dist/heymon
if [ -S /dist/collectd/collectd.sock ] ; then 
  rake alarms RAILS_ENV=production >> /dist/heymon/log/cron.log
fi


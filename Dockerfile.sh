#!/bin/bash
cat <<EOF
FROM $CUSTOM_BASE_IMAGE
MAINTAINER Yevgeniy Poluektov <e.poluektov@rbkmoney.com>

COPY geo_data/GeoLite2-City-Locations-en.csv /var/geodata/GeoLite2-City-Locations-en.csv
COPY geo_data/GeoLite2-City-Locations-ru.csv /var/geodata/GeoLite2-City-Locations-ru.csv

# A bit of magic below to get a proper branch name
# even when the HEAD is detached (Hey Jenkins!
# BRANCH_NAME is available in Jenkins env).
LABEL com.rbkmoney.$SERVICE_NAME.parent=$BASE_IMAGE_NAME \
      com.rbkmoney.$SERVICE_NAME.parent_tag=$BASE_IMAGE_TAG \
      com.rbkmoney.$SERVICE_NAME.commit_id=$(git rev-parse HEAD) \
      com.rbkmoney.$SERVICE_NAME.commit_number=$(git rev-list --count HEAD) \
      com.rbkmoney.$SERVICE_NAME.branch=$( \
        if [ "HEAD" != $(git rev-parse --abbrev-ref HEAD) ]; then \
          echo $(git rev-parse --abbrev-ref HEAD); \
        elif [ -n "$BRANCH_NAME" ]; then \
          echo $BRANCH_NAME; \
        else \
          echo $(git name-rev --name-only HEAD); \
        fi)
ENTRYPOINT ["/bin/containerpilot", "-config", "file:///etc/containerpilot.json", "/docker-entrypoint.sh"]
CMD ["postgres"]
EOF


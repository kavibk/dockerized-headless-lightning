#!/bin/sh

# Define VOLUME_DIR and BUILD_DIR variables
VOLUME_DIR="/opt/headless-lightning"
BUILD_DIR="/usr/src/headless-lightning"

# Check if volume directory exists
if [ -d "$VOLUME_DIR" ]; then
    echo "$VOLUME_DIR exists..."

    # Check if volume directory is empty
    if [ -z "$(ls -A $VOLUME_DIR)" ]; then

        # Copy over headless lightning files from build directory
        echo "$VOLUME_DIR empty, copying over files from $BUILD_DIR... (this may take a minute)"
        cp -r "$BUILD_DIR/." "$VOLUME_DIR"

        # Install headless lightning
        echo "Installing Headless Lightning with Drush"
        cd $VOLUME_DIR

        # Wait until MariaDB is listening on port 3306 before installation
        while ! nc -z mariadb 3306; do
            sleep 1
            echo "Waiting for MariaDB intialization, retrying in (1) second..."
        done

        # Instsall the site with DRush
        drush site:install --db-url="mysql://$MYSQL_USER:$MYSQL_PASSWORD@mariadb/$MYSQL_DATABASE" --account-mail="$ACCOUNT_MAIL" --site-mail="$SITE_MAIL" --site-name="$SITE_NAME" --yes

        chmod 777 "$VOLUME_DIR/docroot/sites/default/settings.php"
        cat /tmp/settings.php >> "$VOLUME_DIR/docroot/sites/default/settings.php"
        chmod 644 "$VOLUME_DIR/docroot/sites/default/settings.php"

        # Change owner of files in volume directory to www-data:www-data
        chown -R www-data:www-data "$VOLUME_DIR"
    else
        # Volume directory isn't empty, don't copy over any files
        echo "$VOLUME_DIR not empty..."
    fi
else
    # Volume directory doesn't exist, this is not normal.
    echo "$VOLUME_DIR doesn't exist... (this isn't normal, please submit an issue to Github"
fi

echo "Headless Lightning intialization process complete. Executing php-fpm..."
exec php-fpm

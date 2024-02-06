# https://www.rosehosting.com/blog/how-to-install-mastodon-on-centos-7/
dnf update -y
# No match for argument: libyaml-devel
# No match for argument: gdbm-devel
# No match for argument: protobuf-devel
dnf config-manager --enable crb
# No match for argument: libidn-devel
sudo dnf install epel-release -y

# No match for argument: ImageMagick
dnf install fontconfig -y
dnf install fribidi -y
dnf install libX11 -y

# https://imagemagick.org/script/download.php#google_vignette
curl -O https://imagemagick.org/archive/binaries/magick
mv magick /usr/local/bin/
alias identify="magick identify"

dnf install git gpg gcc git-core zlib zlib-devel gcc-c++ patch readline readline-devel libyaml-devel libffi-devel openssl-devel make autoconf automake libtool bison curl sqlite-devel libxml2-devel libxslt-devel gdbm-devel ncurses-devel glibc-headers glibc-devel libicu-devel libidn-devel protobuf-devel protobuf -y

dnf install nodejs -y
npm install -g corepack
corepack enable

# https://www.postgresql.org/download/linux/redhat/
dnf install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-9-x86_64/pgdg-redhat-repo-latest.noarch.rpm
dnf -qy module disable postgresql
dnf install -y postgresql16-server
dnf install postgresql16-devel -y
/usr/pgsql-16/bin/postgresql-16-setup initdb
systemctl enable postgresql-16
systemctl start postgresql-16
# in case you want to run SQL queries:
# sudo -u postgres psql
CREATE USER mastodon CREATEDB;

dnf install redis -y

adduser mastodon

dnf install ruby ruby-devel -y


git clone https://github.com/mastodon/mastodon.git
cd mastodon/
git checkout $(git tag -l | grep -v 'rc[0-9]*$' | sort -V | tail -n 1)

gem install bundler
bundle config set deployment true
bundle config set without 'development test'

# gem install pg -- --with-pg-include=/usr/pgsql-16/include/ --with-pg-lib=/usr/pgsql-16/lib/
bundle config build.pg --with-pg-include=/usr/pgsql-16/include/ --with-pg-lib=/usr/pgsql-16/lib/
bundle install -j$(getconf _NPROCESSORS_ONLN)

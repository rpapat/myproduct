# Dockerfile

FROM       centos:centos7

WORKDIR    /var/app

# Update and install common packages
RUN        yum -y update
RUN        yum -y install curl git tar zip

# Add IUS repositories
RUN        yum -y install https://centos7.iuscommunity.org/ius-release.rpm

# Install python{{cookiecutter.python_version}} and wsgi dependencies
{% if cookiecutter.python_version == '3.4' -%}
RUN        yum -y install gcc python34u python34u-libs python34u-devel python34u-pip
{% elif cookiecutter.python_version == '3.6' -%}
RUN        yum -y install gcc python36u python36u-libs python36u-devel
{%- endif %}

# Create and configure virtualenv and uwsgi
RUN        python{{cookiecutter.python_version}} -m venv /var/app

RUN        /var/app/bin/pip install uwsgi
RUN        useradd uwsgi -s /bin/false
RUN        mkdir /var/log/uwsgi
RUN        chown -R uwsgi:uwsgi /var/log/uwsgi

# Add application and install requirements
ADD        . /var/app
RUN        if [ -f /var/app/requirements.txt ]; then /var/app/bin/pip install -I -r /var/app/requirements.txt; fi

# Add startup script
ADD        uwsgi-start.sh /
RUN        chmod +x /uwsgi-start.sh
ENTRYPOINT ["/uwsgi-start.sh"]

EXPOSE     8080

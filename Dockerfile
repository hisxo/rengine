# Base image
FROM python:3-alpine

# Labels and Credits
LABEL \
    name="reNgine" \
    author="Yogesh Ojha <yogesh.ojha11@gmail.com>" \
    description="reNgine is a automated pipeline of recon process, useful for information gathering during web application penetration testing."

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN apk update \
    && apk add --virtual build-deps gcc python3-dev musl-dev \
    && apk add postgresql-dev chromium git netcat-openbsd \
    && pip install psycopg2 \
    && apk del build-deps


# Download and install go 1.14
COPY --from=golang:1.14-alpine /usr/local/go/ /usr/local/go/

# Environment vars
ENV DATABASE="postgres"
ENV GOROOT="/usr/local/go"
ENV GOPATH="/root/go"
ENV PATH="${PATH}:${GOROOT}/bin"
ENV PATH="${PATH}:${GOPATH}/bin"

# Download Go packages
RUN go get -u github.com/tomnomnom/assetfinder github.com/hakluke/hakrawler github.com/haccer/subjack
RUN rm -Rf /app/tools/ParamSpider
RUN git clone https://github.com/devanshbatham/ParamSpider /app/tools/ParamSpider
RUN GO111MODULE=on go get -u -v github.com/projectdiscovery/httpx/cmd/httpx \
    github.com/projectdiscovery/naabu/cmd/naabu \
    github.com/projectdiscovery/subfinder/v2/cmd/subfinder \
    github.com/lc/gau \
    github.com/tomnomnom/gf
RUN go get -u -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei

# install template gf
RUN git clone https://github.com/1ndianl33t/Gf-Patterns /app/tools/Gf-Patterns
RUN mkdir /root/.gf
RUN mv /app/tools/Gf-Patterns/*.json /root/.gf/
RUN rm -Rf /appt/Gf-Patterns

# install redis for celery
RUN apk add redis supervisor
RUN echo 'daemonize yes' >> /etc/redis.conf

# Ajout de template nuclei
RUN nuclei -update-templates

# Copy requirements
COPY ./requirements.txt /tmp/requirements.txt
RUN pip3 install -r /tmp/requirements.txt

# Make directory for app
RUN mkdir -p /app
WORKDIR /app

# Copy source code
COPY . /app/

# Collect Static
RUN python manage.py collectstatic --no-input --clear

RUN chmod +x /app/tools/get_subdomain.sh
RUN chmod +x /app/tools/get_dirs.sh
RUN chmod +x /app/tools/get_urls.sh
RUN chmod +x /app/tools/takeover.sh

# run entrypoint.sh
ENTRYPOINT ["/app/docker-entrypoint.sh"]

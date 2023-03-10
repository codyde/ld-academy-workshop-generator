# step 1 as builder
# FROM public.ecr.aws/docker/library/node:lts-alpine as builder
FROM node:lts-alpine as builder

# copy the package.json to install dependencies
COPY package.json package-lock.json ./
#COPY next.config.js ./

# Install the dependencies and make the folder
RUN npm install && mkdir /app && mv ./node_modules ./app

WORKDIR /app

COPY . .

# Build the project and copy the files
RUN npm run build


#FROM public.ecr.aws/docker/library/python:3.7-buster
FROM python:3.7-buster

COPY requirements.txt /tmp/requirements.txt

RUN pip3 install --upgrade pip setuptools && \
    pip3 uninstall jwt && \
    pip3 install -r /tmp/requirements.txt && \
    rm -r /root/.cache && \
    mkdir /build

RUN pip install git+https://github.com/Supervisor/supervisor@master

COPY . /app
COPY app.conf /usr/supervisord.conf

COPY --from=builder /app/build /app/build

CMD ["/usr/local/bin/supervisord","--nodaemon","-c","/usr/supervisord.conf"]
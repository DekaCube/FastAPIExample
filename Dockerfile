# setup base python container
FROM python:3.9-bullseye as python_base

RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    nano \
    curl 

RUN apt-get clean
RUN python3.9 -m pip install pipenv


# Copy in dependencies
FROM python_base as python_intermediate

RUN mkdir opt/myfastpayapi
WORKDIR /opt/myfastpayapi

COPY Pipfile .
COPY Pipfile.lock .
COPY requirements.txt .
RUN pip install -r requirements.txt

# Copy in source code
FROM python_intermediate
WORKDIR /opt/myfastpayapi
COPY . .
EXPOSE 80

ENTRYPOINT ["./start-app.sh"]




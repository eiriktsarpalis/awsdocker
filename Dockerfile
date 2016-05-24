FROM mono:latest

WORKDIR ~

ENV MBRACE_VERSION 0.0.1-alpha
ENV AWS_REGION eu-central-1
#ENV AWS_ACCESS_KEY_ID <my access key>
#ENV AWS_SECRET_ACCESS_KEY <my secret key>

# AWS EB requires at least one exposed port; use one at random
EXPOSE 4242

RUN curl -OJL https://github.com/fsprojects/Paket/releases/download/2.66.3/paket.bootstrapper.exe
RUN mono paket.bootstrapper.exe
RUN mono paket.exe init
RUN mono paket.exe add nuget MBrace.AWS version $MBRACE_VERSION

CMD mono packages/MBrace.AWS/tools/mbrace.awsworker.exe --region $AWS_REGION --credentials $AWS_ACCESS_KEY_ID $AWS_SECRET_ACCESS_KEY

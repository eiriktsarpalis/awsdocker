FROM mono:latest

WORKDIR ~

ENV MBRACE_VERSION 0.1.0
ENV AWS_REGION eu-central-1
#ENV AWS_ACCESS_KEY_ID <my access key>
#ENV AWS_SECRET_ACCESS_KEY <my secret key>

# AWS EB requires at least one exposed port; use one at random
EXPOSE 4242

RUN curl -OJL https://github.com/fsprojects/Paket/releases/download/2.66.3/paket.bootstrapper.exe
RUN mono paket.bootstrapper.exe
RUN echo "framework: >= net45\nsource https://nuget.org/api/v2\n\nnuget MBrace.AWS ~> ${MBRACE_VERSION} prerelease" > paket.dependencies
RUN mono paket.exe update

CMD mono packages/MBrace.AWS/tools/mbrace.awsworker.exe \
	--region $AWS_REGION --worker-id container-`hostname` \
	--use-environment-credentials

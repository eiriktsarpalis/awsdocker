FROM mono:latest

COPY . .
ENV WORKER_EXE packages/MBrace.AWS/tools/mbrace.awsworker.exe

RUN mono ./.paket/paket.bootstrapper.exe
RUN mono ./.paket/paket.exe restore

RUN echo '#!/bin/sh\nmono ${WORKER_EXE} $*' > ./mbraceaws
RUN chmod +x ./mbraceaws

ENTRYPOINT ["./mbraceaws"]

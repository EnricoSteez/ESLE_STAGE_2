FROM pypi/pykafka
COPY benchmarkProducer.py /benchmarkProducer.py
COPY benchmarkConsumer.py /benchmarkConsumer.py
RUN apt-get update
RUN apt-get install -y vim
RUN pip install pykafka

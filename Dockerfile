FROM centos:7 as builder

RUN yum install -y git gcc gcc-c++ python-devel make readline-devel && \
    curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && python get-pip.py && pip install -U pip && \
    git clone git://trac.frm2.tum.de/home/repos/git/frm2/nicos/nicos-core.git

RUN cd /opt && \
    curl https://epics-controls.org/download/base/base-3.15.6.tar.gz -o base-3.15.6.tar.gz &&\
    tar -xzvf base-3.15.6.tar.gz && cd base-3.15.6

ENV EPICS_HOST_ARCH=linux-x86-64

RUN cd /opt/base-3.15.6 && export EPICS_HOST_ARCH=linux-x86_64 && make

ENV BASE=base-3.15.6
ENV EPICS_BASE=/opt/${BASE}
ENV PATH=${EPICS_BASE}/bin/linux-x86_64:${PATH}:/root/.local/bin
ENV LD_LIBRARY_PATH=${EPICS_BASE}/lib/linux-x86_64:${LD_LIBRARY_PATH}

RUN cd /nicos-core && pip install --user -r requirements.txt 
RUN pip uninstall -y setuptools 
RUN pip install --user setuptools
RUN pip install --user kafka-python pyepics flatbuffers h5py



FROM centos:7

#RUN yum -y install python-setuptools

COPY --from=builder /root/.local/lib /root/.local/lib
COPY --from=builder /root/.local/bin /root/.local/bin
COPY --from=builder /opt/base-3.15.6/bin /opt/base-3.15.6/bin 
COPY --from=builder /opt/base-3.15.6/lib /opt/base-3.15.6/lib 
COPY --from=builder /nicos-core /nicos-core
COPY extra/kafka.py /nicos-core/nicos/services/cache/database/kafka.py
COPY extra/config.py /nicos-core/nicos_sinq/amor/setups/special/config.py

EXPOSE 1301

ENV BASE=base-3.15.6
ENV EPICS_HOST_ARCH=linux-x86_64
ENV EPICS_BASE=/opt/${BASE}
ENV PATH=${EPICS_BASE}/bin/${EPICS_HOST_ARCH}:${PATH}:/root/.local/bin
ENV LD_LIBRARY_PATH=${EPICS_BASE}/lib/${EPICS_HOST_ARCH}:/root/.local/lib:${LD_LIBRARY_PATH}

WORKDIR /nicos-core

RUN cp nicos_sinq/amor/nicos.conf . && \ 
    sed -i s/nicosamor/root/ nicos.conf && sed -i s/unx-lns/root/ nicos.conf && \
    sed -i s/\\/home//gm nicos.conf && \
    echo "3.5.1-467-gb5f38" > nicos/RELEASE-VERSION

RUN ./etc/nicos-system start

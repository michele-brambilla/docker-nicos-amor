FROM centos:7 as hm_builder

RUN yum install -y git gcc gcc-c++ python-devel && \
    curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && python get-pip.py && pip install -U pip && \
    git clone git://trac.frm2.tum.de/home/repos/git/frm2/nicos/nicos-core.git

RUN cd nicos-core && pip install --user -r requirements.txt && \
    pip install --user kafka-python epics
